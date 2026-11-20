// Build the declaration dependency graph from a lean4export (format 3.1.0) ndjson file.
// Usage: depgraph <export.ndjson> <outdir> [stmt]
// With "stmt", a theorem contributes only its type (its statement), not its proof term.
// Output: nodes.tsv (id, kind, dag_size, names joined by '|'), indptr.bin (uint64[n+1]), indices.bin (uint32 dep node ids)
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdint>
#include <string>
#include <vector>
#include <algorithm>
using namespace std;
static inline const char* nextInt(const char* p, uint64_t& v){ while(*p && (*p<'0'||*p>'9')) p++; v=0; while(*p>='0'&&*p<='9'){ v=v*10+(*p-'0'); p++; } return p; }
struct NameE { uint32_t pre; int32_t str; uint64_t num; };   // str = index into strs, or -1 for numeric component
enum : uint8_t { K_OTHER=0, K_APP, K_BIND, K_LET, K_PROJ, K_CONST };
struct Decl { char kind; vector<uint32_t> names; vector<uint32_t> roots; };
static string unesc(const char* p, const char* e){ string o; o.reserve(e-p); while(p<e){ if(*p=='\\' && p+1<e){ p++; switch(*p){ case 'n': o+='\n'; break; case 't': o+='\t'; break; case 'u': { unsigned c=0; sscanf(p+1,"%4x",&c); p+=4; if(c<0x80) o+=(char)c; else if(c<0x800){ o+=(char)(0xC0|(c>>6)); o+=(char)(0x80|(c&0x3F)); } else { o+=(char)(0xE0|(c>>12)); o+=(char)(0x80|((c>>6)&0x3F)); o+=(char)(0x80|(c&0x3F)); } } break; default: o+=*p; } p++; } else o+=*p++; } return o; }
int main(int argc, char** argv){
  if(argc<3){ fprintf(stderr,"usage\n"); return 2; }
  bool stmtOnly = argc>3 && string(argv[3])=="stmt";
  FILE* f=fopen(argv[1],"rb"); if(!f){ perror("open"); return 1; }
  static char iobuf[1<<26]; setvbuf(f,iobuf,_IOFBF,sizeof iobuf);
  fseeko(f,0,SEEK_END); uint64_t fsz=ftello(f); fseeko(f,0,SEEK_SET);
  uint64_t est=fsz/40+1000;
  vector<uint8_t> kind; vector<uint32_t> c0,c1,c2; kind.reserve(est); c0.reserve(est); c1.reserve(est); c2.reserve(est);
  vector<NameE> names(1, NameE{0,-1,0}); vector<string> strs; vector<Decl> decls;
  char* line=nullptr; size_t cap=0; ssize_t len; uint64_t nline=0, nexpr=0, bad=0, nlevel=0; uint64_t v;
  while((len=getline(&line,&cap,f))>0){
    nline++; if((nline & ((1ull<<27)-1))==0){ fprintf(stderr,"lines %llu exprs %llu names %zu decls %zu\n",(unsigned long long)nline,(unsigned long long)nexpr,names.size(),decls.size()); }
    const char* s=line; if(len<6) continue; char a=s[2], b=s[3];
    uint8_t k=K_OTHER; uint32_t x0=0,x1=0,x2=0; bool isExpr=false;
    if(a=='a' && b=='p'){ const char* p=s+7; uint64_t A,F; p=nextInt(p,A); p=nextInt(p,F); k=K_APP; x0=A; x1=F; isExpr=true; }
    else if(a=='i' && b=='e'){ const char* p=nextInt(s+6,v); if(v!=nexpr) bad++; while(*p && *p!='"') p++; char t=p[1], t2=p[2]; isExpr=true;
      if(t=='l' && t2=='a'){ uint64_t B,N,T; p=strstr(p,"\"body\":"); p=nextInt(p,B); p=nextInt(p,N); p=nextInt(p,T); k=K_BIND; x0=B; x1=T; }
      else if(t=='l' && t2=='e'){ uint64_t B,N,T,V; p=strstr(p,"\"body\":"); p=nextInt(p,B); p=nextInt(p,N); p=strstr(p,"\"type\":"); p=nextInt(p,T); p=nextInt(p,V); k=K_LET; x0=B; x1=T; x2=V; }
      else if(t=='p'){ uint64_t I,S,N; p=strstr(p,"\"idx\":"); p=nextInt(p,I); p=nextInt(p,S); p=nextInt(p,N); k=K_PROJ; x0=S; x1=N; }
      else if(t=='m'){ const char* q=strstr(p,"\"expr\":"); if(q){ uint64_t E; nextInt(q,E); k=K_PROJ; x0=E; x1=0; } }
      /* sort, natVal, strVal: leaves */ }
    else if(a=='c'){ const char* p=strstr(s,"\"name\":"); uint64_t N; nextInt(p,N); k=K_CONST; x0=N; isExpr=true; }
    else if(a=='f'){ const char* p=strstr(s,"\"body\":"); uint64_t B,N,T; p=nextInt(p,B); p=nextInt(p,N); p=nextInt(p,T); k=K_BIND; x0=B; x1=T; isExpr=true; }
    else if(a=='b'){ isExpr=true; }
    else if(a=='i' && b=='l'){ nlevel++; }
    else if(a=='i' && b=='n' && s[4]=='"'){ uint64_t I,Pp; const char* p=nextInt(s+6,I); if(I!=names.size()) bad++; NameE e; 
      if(strncmp(p,",\"str\":",7)==0){ p=strstr(p,"\"pre\":"); p=nextInt(p,Pp); const char* q=strstr(p,"\"str\":\""); q+=7; const char* e2=line+len; while(e2>q && *(e2-1)!='"') e2--; e2--; e.pre=Pp; e.str=strs.size(); e.num=0; strs.push_back(unesc(q,e2)); }
      else { uint64_t Nn; p=strstr(p,"\"i\":"); p=nextInt(p,Nn); p=nextInt(p,Pp); e.pre=Pp; e.str=-1; e.num=Nn; }
      names.push_back(e); }
    else if(a=='t'||a=='d'||a=='o'||a=='q'||(a=='a'&&b=='x')||(a=='i'&&b=='n')){ Decl d; d.kind = (a=='i')?'I':(a=='a'?'A':a); const char* p=s;
      while((p=strstr(p,"\"name\":"))){ p=nextInt(p+7,v); d.names.push_back(v); }
      for(const char* key : {"\"type\":","\"value\":","\"rhs\":"}){ p=s; size_t kl=strlen(key); while((p=strstr(p,key))){ p+=kl; if(*p>='0'&&*p<='9'){ nextInt(p,v); d.roots.push_back(v); } } }
      if(stmtOnly && d.kind=='t' && d.roots.size()>1) d.roots.resize(1);
      decls.push_back(std::move(d)); }
    if(isExpr){ kind.push_back(k); c0.push_back(x0); c1.push_back(x1); c2.push_back(x2); nexpr++; }
  }
  fprintf(stderr,"parsed: lines %llu exprs %llu levels %llu names %zu decls %zu index-mismatches %llu\n",(unsigned long long)nline,(unsigned long long)nexpr,(unsigned long long)nlevel,names.size(),decls.size(),(unsigned long long)bad);
  // name -> decl
  vector<int32_t> n2d(names.size(), -1); for(size_t i=0;i<decls.size();i++) for(uint32_t n: decls[i].names) if(n<n2d.size()) n2d[n]=i;
  // full names (memoised)
  vector<string> full(names.size()); vector<char> have(names.size(),0); have[0]=1;
  auto fullName=[&](uint32_t n){ vector<uint32_t> chain; uint32_t c=n; while(!have[c]){ chain.push_back(c); c=names[c].pre; } for(auto it=chain.rbegin(); it!=chain.rend(); ++it){ const NameE& e=names[*it]; string comp = e.str>=0 ? strs[e.str] : to_string(e.num); const string& pre=full[e.pre]; full[*it] = pre.empty()? comp : pre+"."+comp; have[*it]=1; } return full[n]; };
  string od=argv[2]; FILE* fn=fopen((od+"/nodes.tsv").c_str(),"w"); FILE* fp=fopen((od+"/indptr.bin").c_str(),"wb"); FILE* fi=fopen((od+"/indices.bin").c_str(),"wb");
  vector<uint32_t> stamp(nexpr,0), dstamp(decls.size(),0), st, deps; uint64_t off=0, totalVisited=0, unresolved=0; fwrite(&off,8,1,fp);
  for(size_t i=0;i<decls.size();i++){
    uint32_t id=i+1; st.assign(decls[i].roots.begin(), decls[i].roots.end()); deps.clear(); uint64_t vis=0;
    auto addName=[&](uint32_t n){ int32_t d = n<n2d.size()? n2d[n] : -1; if(d<0){ unresolved++; return; } if((size_t)d==i) return; if(dstamp[d]!=id){ dstamp[d]=id; deps.push_back(d); } };
    while(!st.empty()){ uint32_t e=st.back(); st.pop_back(); if(e>=nexpr || stamp[e]==id) continue; stamp[e]=id; vis++;
      switch(kind[e]){ case K_APP: st.push_back(c0[e]); st.push_back(c1[e]); break; case K_BIND: st.push_back(c0[e]); st.push_back(c1[e]); break; case K_LET: st.push_back(c0[e]); st.push_back(c1[e]); st.push_back(c2[e]); break; case K_PROJ: st.push_back(c0[e]); if(c1[e]) addName(c1[e]); break; case K_CONST: addName(c0[e]); break; default: break; } }
    totalVisited+=vis; sort(deps.begin(),deps.end()); fwrite(deps.data(),4,deps.size(),fi); off+=deps.size(); fwrite(&off,8,1,fp);
    fprintf(fn,"%zu\t%c\t%llu\t",i,decls[i].kind,(unsigned long long)vis); for(size_t j=0;j<decls[i].names.size();j++){ if(j) fputc('|',fn); string nm=fullName(decls[i].names[j]); for(char& ch: nm) if(ch=='\t'||ch=='\n'||ch=='|') ch='?'; fputs(nm.c_str(),fn); } fputc('\n',fn);
  }
  fclose(fn); fclose(fp); fclose(fi);
  fprintf(stderr,"done: decl nodes %zu edges %llu total expr visits %llu unresolved const refs %llu\n",decls.size(),(unsigned long long)off,(unsigned long long)totalVisited,(unsigned long long)unresolved);
  return 0;
}
