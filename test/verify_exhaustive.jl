# Oracle độc lập: Floyd-Warshall, không gọi BFS để tạo expected.
include(joinpath(@__DIR__, "..", "src", "BFS.jl"))
using .BFS

function verify_all()
    graphs=0;pairs=0
    for n in 1:5
        possible=[(u,v) for u in 1:n for v in u+1:n]
        count_pairs=length(possible)
        for mask in 0:(1<<count_pairs)-1
            edges=[possible[i] for i in eachindex(possible) if (mask>>(i-1))&1==1]
            inf=10^6
            dist=fill(inf,n,n)
            for i in 1:n;dist[i,i]=0;end
            for (u,v) in edges;dist[u,v]=1;dist[v,u]=1;end
            for k in 1:n,i in 1:n,j in 1:n
                dist[i,j]=min(dist[i,j],dist[i,k]+dist[k,j])
            end
            graphs+=1
            for s in 1:n,t in 1:n
                got=tim_duong(n,edges,s,t)
                expected=dist[s,t]==inf ? -1 : dist[s,t]
                @assert got.so_canh==expected "distance n=$n mask=$mask s=$s t=$t"
                if expected==-1
                    @assert isempty(got.duong)
                else
                    @assert first(got.duong)==s && last(got.duong)==t
                    @assert length(got.duong)-1==expected
                    @assert length(unique(got.duong))==length(got.duong)
                    for i in 1:length(got.duong)-1
                        u,v=got.duong[i],got.duong[i+1]
                        @assert (min(u,v),max(u,v)) in edges
                    end
                end
                for v in 1:n
                    expected_v=dist[s,v]==inf ? -1 : dist[s,v]
                    @assert got.d[v]==expected_v
                    if v!=s && got.d[v]>=0
                        @assert got.d[got.cha[v]]==got.d[v]-1
                    end
                end
                pairs+=1
            end
        end
    end
    println("EXHAUSTIVE_OK graphs=$graphs source_target_pairs=$pairs n=1..5")
    println("ORACLE=Floyd-Warshall; distances, endpoints, real edges, simple path and parent distances checked")
    println("This checks finite graphs up to n=5; mathematical proof covers all valid n.")
end
verify_all()
