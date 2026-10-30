include(joinpath(@__DIR__, "..", "src", "BFS.jl"))
using .BFS
cases=[
 ("T01",4,[(3,4),(1,3),(2,4),(1,2)],1,4,[1,2,4],2),
 ("T02",3,[(1,2)],1,3,Int[],-1),
 ("T03",4,[(1,2),(1,3),(2,4),(3,4)],2,2,[2],0),
 ("T04",2,[(1,2)],2,1,[2,1],1),
 ("T05",4,[(1,2),(2,3),(3,4)],1,4,[1,2,3,4],3),
 ("T06",4,[(1,2),(2,3),(3,1),(3,4)],1,4,[1,3,4],2),
 ("T07",4,[(2,3),(3,4)],1,4,Int[],-1),
 ("T08",1,Tuple{Int,Int}[],1,1,[1],0),
 ("T09",5,[(u,v) for u in 1:5 for v in u+1:5],5,1,[5,1],1),
 ("T10",6,[(1,2),(2,3),(4,5),(5,6)],2,5,Int[],-1),
 ("T11",100,[(i,i+1) for i in 1:99],100,1,collect(100:-1:1),99),
 ("T12",5,[(1,5),(1,3),(1,4),(1,2)],5,4,[5,1,4],2)
]
println("CATALOG | id | input | expected | actual | result")
for (id,n,edges,s,t,path,dist) in cases
    result=tim_duong(n,edges,s,t)
    ok=result.duong==path && result.so_canh==dist
    @assert ok id
    short_input=n==100 ? "n=100; chain (1,2)..(99,100); s=100;t=1" : "n=$n;edges=$edges;s=$s;t=$t"
    expected=n==100 ? "path=[100,99,...,1];distance=99" : "path=$path;distance=$dist"
    actual=n==100 ? "path=$(first(result.duong))..$(last(result.duong)); vertices=$(length(result.duong));distance=$(result.so_canh)" : "path=$(result.duong);distance=$(result.so_canh)"
    println("CATALOG | $id | $short_input | $expected | $actual | PASS")
end
function throws_argument(f)
    try
        f();return false
    catch err
        return err isa ArgumentError
    end
end
validators=[
 ("V01","tao_ke(0,[])","ArgumentError",()->throws_argument(()->tao_ke(0,[]))),
 ("V02","tao_ke(101,[])","ArgumentError",()->throws_argument(()->tao_ke(101,[]))),
 ("V03","n3;edge(1,4)","ArgumentError",()->throws_argument(()->tao_ke(3,[(1,4)]))),
 ("V04","n3;edge(0,2)","ArgumentError",()->throws_argument(()->tao_ke(3,[(0,2)]))),
 ("V05","n3;edge(1.0,2)","ArgumentError",()->throws_argument(()->tao_ke(3,[(1.0,2)]))),
 ("V06","n3;edge(1,1)","ArgumentError",()->throws_argument(()->tao_ke(3,[(1,1)]))),
 ("V07","n3;edges(1,2),(2,1)","ArgumentError",()->throws_argument(()->tao_ke(3,[(1,2),(2,1)]))),
 ("V08","n3;edge12;s0;t2","ArgumentError",()->throws_argument(()->tim_duong(3,[(1,2)],0,2))),
 ("V09","n3;edge12;s1;t4","ArgumentError",()->throws_argument(()->tim_duong(3,[(1,2)],1,4))),
 ("V10","n3;edge12;path[1,3]","false",()->!kiem_duong(tao_ke(3,[(1,2)]),[1,3])),
 ("V11","n3;edge12;path[]","false",()->!kiem_duong(tao_ke(3,[(1,2)]),Int[])),
 ("V12","n3;edge12;path[0]","false",()->!kiem_duong(tao_ke(3,[(1,2)]),[0])),
 ("V13","cha[2,1,0];s3;t1","ArgumentError",()->throws_argument(()->truy_vet([2,1,0],3,1))),
 ("V14","cha[0,4,0];s1;t2","ArgumentError",()->throws_argument(()->truy_vet([0,4,0],1,2))),
 ("V15","cha[0,1,0];s0;t2","ArgumentError",()->throws_argument(()->truy_vet([0,1,0],0,2))),
 ("V16","cha[0,1,0];s1;t3","[]",()->isempty(truy_vet([0,1,0],1,3)))
]
for (id,input,expected,check) in validators
    @assert check() id
    println("CATALOG | $id | $input | $expected | $expected | PASS")
end
println("CATALOG_OK functional_cases=12 helper_validator_cases=16 total_cases=28")
