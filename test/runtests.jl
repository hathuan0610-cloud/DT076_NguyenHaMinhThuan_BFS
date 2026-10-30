using Test
include(joinpath(@__DIR__, "..", "src", "BFS.jl"))
using .BFS

@testset "DT076 - 12 ca chuc nang" begin
    # T01: hình thoi, hai đường cùng độ dài; buộc chọn qua đỉnh 2.
    kq = tim_duong(4, [(3, 4), (1, 3), (2, 4), (1, 2)], 1, 4)
    @test kq.d == [0, 1, 1, 2]
    @test kq.cha == [0, 1, 1, 2]
    @test kq.thu_tu == [1, 2, 3, 4]
    @test kq.duong == [1, 2, 4]
    @test kq.so_canh == 2
    @test kq.so_phat_hien == 4
    @test kq.so_xet_canh == 8
    @test kq.so_buoc_truy_vet == 3

    # T02: ví dụ không có đường; không truy vết từ đỉnh chưa thăm.
    kq = tim_duong(3, [(1, 2)], 1, 3)
    @test kq.so_canh == -1
    @test isempty(kq.duong)
    @test kq.cha == [0, 1, 0]
    @test kq.so_buoc_truy_vet == 0

    # T03: s=t, đường một đỉnh, khoảng cách không.
    kq = tim_duong(4, [(1, 2), (1, 3), (2, 4), (3, 4)], 2, 2)
    @test kq.duong == [2]
    @test kq.so_canh == 0
    @test kq.d == [1, 0, 2, 1]
    @test kq.cha == [2, 0, 1, 2]
    @test kiem_duong(kq.ke, kq.duong)

    # T04: một cạnh; đồ thị vô hướng nên đi được theo chiều ngược.
    kq = tim_duong(2, [(1, 2)], 2, 1)
    @test kq.duong == [2, 1]
    @test kq.so_canh == 1

    # T05: đường dài, phải đảo đúng thứ tự truy vết.
    kq = tim_duong(4, [(1, 2), (2, 3), (3, 4)], 1, 4)
    @test kq.duong == [1, 2, 3, 4]
    @test kq.so_canh == 3

    # T06: có chu trình; mỗi đỉnh chỉ đưa vào hàng một lần.
    kq = tim_duong(4, [(1, 2), (2, 3), (3, 1), (3, 4)], 1, 4)
    @test kq.duong == [1, 3, 4]
    @test kq.thu_tu == [1, 2, 3, 4]
    @test kq.so_phat_hien == 4

    # T07: nguồn cô lập, còn đỉnh khác có cạnh.
    kq = tim_duong(4, [(2, 3), (3, 4)], 1, 4)
    @test kq.d == [0, -1, -1, -1]
    @test kq.thu_tu == [1]
    @test isempty(kq.duong)

    # T08: nhỏ nhất n=1, không cạnh.
    kq = tim_duong(1, Tuple{Int,Int}[], 1, 1)
    @test kq.duong == [1]
    @test kq.so_canh == 0
    @test kq.so_xet_canh == 0

    # T09: đồ thị đầy đủ, đích là láng giềng trực tiếp của nguồn.
    canh = [(u, v) for u in 1:5 for v in (u + 1):5]
    kq = tim_duong(5, canh, 5, 1)
    @test kq.duong == [5, 1]
    @test kq.d == [1, 1, 1, 1, 0]
    @test kq.so_xet_canh == 20

    # T10: hai thành phần đều có cạnh; không được nhảy sang thành phần đích.
    kq = tim_duong(6, [(1, 2), (2, 3), (4, 5), (5, 6)], 2, 5)
    @test kq.d == [1, 0, 1, -1, -1, -1]
    @test isempty(kq.duong)
    @test kq.so_xet_canh == 4

    # T11: biên trên n=100, hàng đợi và truy vết phải đủ chỗ.
    kq = tim_duong(100, [(i, i + 1) for i in 1:99], 100, 1)
    @test kq.duong == collect(100:-1:1)
    @test kq.so_canh == 99
    @test kq.so_phat_hien == 100
    @test kq.so_xet_canh == 198

    # T12: hình sao, phải đi qua tâm; đầu vào xáo trộn vẫn xét kề tăng dần.
    kq = tim_duong(5, [(1, 5), (1, 3), (1, 4), (1, 2)], 5, 4)
    @test kq.duong == [5, 1, 4]
    @test kq.cha == [5, 1, 1, 1, 0]
    @test kq.thu_tu == [5, 1, 2, 3, 4]
end

@testset "Du lieu vao va ham kiem duong" begin
    @test_throws ArgumentError tao_ke(0, [])  # V01
    @test_throws ArgumentError tao_ke(101, [])  # V02
    @test_throws ArgumentError tao_ke(3, [(1, 4)])  # V03
    @test_throws ArgumentError tao_ke(3, [(0, 2)])  # V04
    @test_throws ArgumentError tao_ke(3, [(1.0, 2)])  # V05
    @test_throws ArgumentError tao_ke(3, [(1, 1)])  # V06
    @test_throws ArgumentError tao_ke(3, [(1, 2), (2, 1)])  # V07
    @test_throws ArgumentError tim_duong(3, [(1, 2)], 0, 2)  # V08
    @test_throws ArgumentError tim_duong(3, [(1, 2)], 1, 4)  # V09
    @test !kiem_duong(tao_ke(3, [(1, 2)]), [1, 3])  # V10
    @test !kiem_duong(tao_ke(3, [(1, 2)]), Int[])  # V11
    @test !kiem_duong(tao_ke(3, [(1, 2)]), [0])  # V12
    @test_throws ArgumentError truy_vet([2, 1, 0], 3, 1)  # V13
    @test_throws ArgumentError truy_vet([0, 4, 0], 1, 2)  # V14
    @test_throws ArgumentError truy_vet([0, 1, 0], 0, 2)  # V15
    @test isempty(truy_vet([0, 1, 0], 1, 3))  # V16
end

println("DA QUA 12 CA CHUC NANG VA CAC KIEM TRA DU LIEU VAO.")
