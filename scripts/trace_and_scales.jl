include(joinpath(@__DIR__, "..", "src", "BFS.jl"))
using .BFS

function in_trace()
    ke=tao_ke(4,[(1,2),(1,3),(2,4),(3,4)])
    d=fill(-1,4);cha=zeros(Int,4);hang=zeros(Int,4)
    dau=1;cuoi=1;hang[1]=1;d[1]=0
    println("TRACE_T01 | n=4; edges=[(1,2),(1,3),(2,4),(3,4)]; s=1; t=4")
    println("Buoc | u | dau | cuoi | hang_con_cho | d | cha")
    println("0 | - | 1 | 1 | [1] | $d | $cha")
    buoc=0
    while dau<=cuoi
        u=hang[dau];dau+=1;buoc+=1
        for v in ke[u]
            if d[v]==-1
                d[v]=d[u]+1;cha[v]=u;cuoi+=1;hang[cuoi]=v
            end
        end
        println("$buoc | $u | $dau | $cuoi | $(hang[dau:cuoi]) | $d | $cha")
    end
    kq=tim_duong(4,[(1,2),(1,3),(2,4),(3,4)],1,4)
    @assert kq.d==d && kq.cha==cha
    println("Doi chieu voi ham chinh: DUNG; truy nguoc 4,2,1; duong=$(kq.duong)")
end

function in_scales()
    println("SCALE | family | n | m | discovered | adjacency_examined | trace_vertices | distance")
    for n in [10,30,100], family in ["chain","star","complete"]
        canh=family=="chain" ? [(i,i+1) for i in 1:n-1] :
             family=="star" ? [(1,i) for i in 2:n] :
             [(i,j) for i in 1:n for j in i+1:n]
        kq=tim_duong(n,canh,1,n)
        @assert kq.so_phat_hien==n
        @assert kq.so_xet_canh==2length(canh)
        println("SCALE | $family | $n | $(length(canh)) | $(kq.so_phat_hien) | $(kq.so_xet_canh) | $(kq.so_buoc_truy_vet) | $(kq.so_canh)")
    end
end

in_trace()
in_scales()
