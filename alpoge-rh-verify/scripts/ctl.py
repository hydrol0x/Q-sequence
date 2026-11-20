import os, sys, json, time, subprocess, threading, urllib.request, urllib.parse
from http.server import ThreadingHTTPServer, BaseHTTPRequestHandler
TOKEN = os.environ["CTL_TOKEN"]; D = "/ctl"; os.makedirs(D + "/jobs", exist_ok=True)
START = time.time(); HARD = float(os.environ.get("CTL_HARD_HOURS", "19.5")) * 3600
def self_terminate():
    key = os.environ.get("RUNPOD_API_KEY"); pid = os.environ.get("RUNPOD_POD_ID")
    if not key or not pid: return "no key"
    q = json.dumps({"query": 'mutation { podTerminate(input: {podId: "%s"}) }' % pid}).encode()
    r = urllib.request.Request("https://api.runpod.io/graphql", q, {"content-type": "application/json", "Authorization": "Bearer " + key, "User-Agent": "curl/8"})
    try: return urllib.request.urlopen(r, timeout=30).read().decode()
    except Exception as e: return repr(e)
def watchdog():
    while True:
        time.sleep(60)
        if time.time() - START > HARD:
            open(D + "/watchdog.log", "a").write("%s hard deadline: %s\n" % (time.ctime(), self_terminate()))
threading.Thread(target=watchdog, daemon=True).start()
class H(BaseHTTPRequestHandler):
    def log_message(self, *a): pass
    def out(self, code, body):
        if isinstance(body, str): body = body.encode("utf-8", "replace")
        self.send_response(code); self.send_header("content-type", "text/plain; charset=utf-8")
        self.send_header("content-length", str(len(body))); self.end_headers(); self.wfile.write(body)
    def auth(self): return self.headers.get("X-Token") == TOKEN
    def do_GET(self):
        u = urllib.parse.urlparse(self.path); q = dict(urllib.parse.parse_qsl(u.query))
        if u.path == "/health": return self.out(200, "ok up=%ds\n" % (time.time() - START))
        if not self.auth(): return self.out(403, "no\n")
        if u.path == "/file":
            try:
                with open(q["path"], "rb") as f:
                    sz = os.fstat(f.fileno()).st_size; n = int(q.get("len", "200000"))
                    off = int(q["offset"]) if "offset" in q else max(0, sz - n)
                    f.seek(off); return self.out(200, f.read(n))
            except Exception as e: return self.out(404, repr(e))
        self.out(404, "?\n")
    def do_POST(self):
        u = urllib.parse.urlparse(self.path); q = dict(urllib.parse.parse_qsl(u.query))
        if not self.auth(): return self.out(403, "no\n")
        body = self.rfile.read(int(self.headers.get("content-length", "0")))
        if u.path == "/exec":
            try:
                p = subprocess.run(["bash", "-c", body.decode()], stdout=subprocess.PIPE, stderr=subprocess.STDOUT, timeout=float(q.get("timeout", "80")))
                return self.out(200, p.stdout[-400000:] + ("\n[rc=%d]\n" % p.returncode).encode())
            except subprocess.TimeoutExpired as e: return self.out(200, (e.stdout or b"")[-400000:] + b"\n[timeout]\n")
        if u.path == "/job":
            name = q["name"]; sh = "%s/jobs/%s.sh" % (D, name); open(sh, "wb").write(body)
            cmd = "bash %s > %s/jobs/%s.log 2>&1; echo $? > %s/jobs/%s.rc" % (sh, D, name, D, name)
            p = subprocess.Popen(["setsid", "bash", "-c", cmd], stdin=subprocess.DEVNULL)
            return self.out(200, "started %s pid=%d\n" % (name, p.pid))
        if u.path == "/put":
            open(q["path"], "wb").write(body); return self.out(200, "wrote %d\n" % len(body))
        self.out(404, "?\n")
ThreadingHTTPServer(("0.0.0.0", 8000), H).serve_forever()
