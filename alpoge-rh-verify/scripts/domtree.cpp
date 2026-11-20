// Dominator tree and closure sizes on the declaration dependency DAG written by depgraph.
// Usage: domtree dom <graphdir> <outdir> <target ids file>      -> writes idom.bin (int32[n]; n = virtual root, -1 = unreachable)
//        domtree closure <graphdir> <is_lib.npy> <ids file> <out.tsv>   -> for each id: nodes and project nodes reachable
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cstring>
#include <string>
#include <vector>
#include <thread>
#include <atomic>
using namespace std;
template<class T> static vector<T> readAll(const string& p, size_t skip=0){ FILE* f=fopen(p.c_str(),"rb"); if(!f){ perror(p.c_str()); exit(1);} fseeko(f,0,SEEK_END); size_t n=ftello(f)-skip; fseeko(f,skip,SEEK_SET); vector<T> v(n/sizeof(T)); if(fread(v.data(),sizeof(T),v.size(),f)!=v.size()){ fprintf(stderr,"short read\n"); exit(1);} fclose(f); return v; }
static vector<int64_t> readIds(const string& p){ vector<int64_t> v; FILE* f=fopen(p.c_str(),"r"); if(!f){ perror(p.c_str()); exit(1);} long long x; while(fscanf(f,"%lld",&x)==1) v.push_back(x); fclose(f); return v; }
int main(int argc, char** argv){
  if(argc<5) return 2; string mode=argv[1], g=argv[2];
  vector<uint64_t> ip=readAll<uint64_t>(g+"/indptr.bin"); vector<uint32_t> ix=readAll<uint32_t>(g+"/indices.bin"); size_t n=ip.size()-1;
  if(mode=="dom"){
    vector<int64_t> tg=readIds(argv[4]); vector<char> isT(n,0); for(auto t: tg) isT[t]=1;
    vector<uint64_t> rp(n+1,0); for(uint32_t v: ix) rp[v+1]++; for(size_t i=0;i<n;i++) rp[i+1]+=rp[i];
    vector<uint32_t> ru(ix.size()); { vector<uint64_t> pos(rp.begin(), rp.end()-1); for(size_t u=0;u<n;u++) for(uint64_t e=ip[u]; e<ip[u+1]; e++) ru[pos[ix[e]]++]=u; }
    vector<int32_t> idom(n+1,-1), dd(n+1,0); const int32_t ROOT=n; idom[ROOT]=ROOT; uint64_t steps=0;
    for(int64_t v=(int64_t)n-1; v>=0; v--){ int32_t c = isT[v]? ROOT : -1;
      for(uint64_t e=rp[v]; e<rp[v+1]; e++){ int32_t u=ru[e]; if(idom[u]==-1) continue; if(c==-1){ c=u; continue; } int32_t a=c,b=u; while(a!=b){ steps++; if(dd[a]>dd[b]) a=idom[a]; else b=idom[b]; } c=a; if(c==ROOT) break; }
      idom[v]=c; if(c!=-1) dd[v]=dd[c]+1; }
    FILE* f=fopen((string(argv[3])+"/idom.bin").c_str(),"wb"); fwrite(idom.data(),4,n,f); fclose(f);
    fprintf(stderr,"dominators done: n=%zu lca steps=%llu\n",n,(unsigned long long)steps);
  } else {
    // .npy v1: data starts at 10 + uint16 header length
    FILE* f=fopen(argv[3],"rb"); unsigned char h[10]; if(fread(h,1,10,f)!=10) return 1; fclose(f); size_t skip=10+h[8]+256*h[9];
    vector<uint8_t> lib=readAll<uint8_t>(argv[3],skip); if(lib.size()!=n){ fprintf(stderr,"is_lib size %zu != %zu\n",lib.size(),n); return 1; }
    vector<int64_t> ids=readIds(argv[4]); vector<uint64_t> ra(ids.size()), rpj(ids.size()); atomic<size_t> next(0);
    auto work=[&](){ vector<uint32_t> stamp(n,0), st; uint32_t cur=0; for(;;){ size_t k=next++; if(k>=ids.size()) break; cur++; uint64_t a=0,pj=0; st.clear(); st.push_back(ids[k]); stamp[ids[k]]=cur;
        while(!st.empty()){ uint32_t u=st.back(); st.pop_back(); a++; if(!lib[u]) pj++; for(uint64_t e=ip[u]; e<ip[u+1]; e++){ uint32_t v=ix[e]; if(stamp[v]!=cur){ stamp[v]=cur; st.push_back(v);} } }
        ra[k]=a; rpj[k]=pj; } };
    vector<thread> th; for(int i=0;i<24;i++) th.emplace_back(work); for(auto& t: th) t.join();
    FILE* o=fopen(argv[5],"w"); for(size_t k=0;k<ids.size();k++) fprintf(o,"%lld\t%llu\t%llu\n",(long long)ids[k],(unsigned long long)ra[k],(unsigned long long)rpj[k]); fclose(o);
    fprintf(stderr,"closures done: %zu queries\n",ids.size());
  }
  return 0;
}
