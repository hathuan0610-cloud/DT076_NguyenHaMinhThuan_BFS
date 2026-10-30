include(joinpath(@__DIR__, "src", "BFS.jl"))
using .BFS
using Printf

function in_ket_qua(n, canh, s, t)
    kq = tim_duong(n, canh, s, t)
    println("DT076 - TIM DUONG DI IT CANH NHAT BANG BFS")
    println("n=$n; canh=$canh; s=$s; t=$t")
    println("Lang gieng tang dan; cha chi gan khi phat hien lan dau.")
    println("Dinh | Khoang cach d | Dinh cha")
    for v in 1:n
        @printf("%4d | %13d | %8d\n", v, kq.d[v], kq.cha[v])
    end
    println("Thu tu BFS: ", join(kq.thu_tu, " -> "))
    if kq.so_canh == -1
        println("KHONG CO DUONG")
    else
        println("Duong di: ", join(kq.duong, " -> "))
        println("So canh: ", kq.so_canh)
        println("Kiem tung cap canh: ", kiem_duong(kq.ke, kq.duong) ? "DUNG" : "SAI")
    end
    println("So dinh phat hien: ", kq.so_phat_hien)
    println("So muc ke da xet: ", kq.so_xet_canh)
    println("So dinh khi truy vet: ", kq.so_buoc_truy_vet)
    return kq
end

function nhap_ban_phim()
    println("Nhap n m (vi du: 4 4):")
    nm = parse.(Int, split(readline()))
    length(nm) == 2 || throw(ArgumentError("can dung 2 so n m"))
    n, m = nm
    1 <= n <= 100 || throw(ArgumentError("n phai nam trong 1..100"))
    0 <= m <= n * (n - 1) ÷ 2 || throw(ArgumentError("m khong hop le"))
    canh = Tuple{Int,Int}[]
    for i in 1:m
        println("Nhap canh $i (u v):")
        uv = parse.(Int, split(readline()))
        length(uv) == 2 || throw(ArgumentError("moi canh can dung 2 so"))
        push!(canh, (uv[1], uv[2]))
    end
    println("Nhap s t:")
    st = parse.(Int, split(readline()))
    length(st) == 2 || throw(ArgumentError("can dung 2 so s t"))
    in_ket_qua(n, canh, st[1], st[2])
end

function minh_hoa_du_lieu_sai()
    println("DT076 - MINH HOA TU CHOI DU LIEU KHONG HOP LE")
    println("n=3; canh=[(1, 2), (2, 1)]; s=1; t=3")
    println("Mong doi: canh (2, 1) lap lai canh vo huong (1, 2).")
    try
        tim_duong(3, [(1, 2), (2, 1)], 1, 3)
    catch loi
        if loi isa ArgumentError && occursin("canh bi lap", sprint(showerror, loi))
            println("DA TU CHOI DU LIEU: ", sprint(showerror, loi))
            println("KET QUA MINH HOA: DUNG; loi du kien da duoc bat.")
            println("Ma thoat 0 chi danh cho demo bat loi dung nhu mong doi.")
            return nothing
        end
        rethrow()
    end
    error("LOI: chuong trinh da chap nhan canh lap")
end

if "--nhap" in ARGS
    nhap_ban_phim()
elseif any(startswith("--ca="), ARGS)
    ca = only(filter(startswith("--ca="), ARGS))
    if ca == "--ca=1"
        in_ket_qua(4, [(1, 2), (1, 3), (2, 4), (3, 4)], 1, 4)
    elseif ca == "--ca=2"
        in_ket_qua(3, [(1, 2)], 1, 3)
    elseif ca == "--ca=3"
        in_ket_qua(4, [(1, 2), (1, 3), (2, 4), (3, 4)], 2, 2)
    elseif ca == "--ca=4"
        in_ket_qua(4, [(2, 3), (3, 4)], 1, 4)
    elseif ca == "--ca=5"
        in_ket_qua(4, [(1, 2), (2, 3), (3, 4)], 1, 4)
    elseif ca == "--ca=6"
        in_ket_qua(4, [(1, 2), (2, 3), (3, 1), (3, 4)], 1, 4)
    elseif ca == "--ca=7"
        in_ket_qua(1, Tuple{Int,Int}[], 1, 1)
    elseif ca == "--ca=8"
        minh_hoa_du_lieu_sai()
    else
        throw(ArgumentError("chon --ca=1 den --ca=8"))
    end
else
    # Hai ví dụ đúng như phiếu DT076. Có thể sửa trực tiếp các biến này.
    in_ket_qua(4, [(1, 2), (1, 3), (2, 4), (3, 4)], 1, 4)
    println("\n--- VI DU 2: DICH KHONG TOI DUOC ---")
    in_ket_qua(3, [(1, 2)], 1, 3)
end
