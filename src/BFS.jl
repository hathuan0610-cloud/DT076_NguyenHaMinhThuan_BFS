module BFS

export tao_ke, bfs_cha, truy_vet, kiem_duong, tim_duong

"""Dựng danh sách kề của đồ thị vô hướng đơn; nhãn đỉnh là 1:n."""
function tao_ke(n::Integer, canh)
    1 <= n <= 100 || throw(ArgumentError("n phai nam trong 1..100"))
    ke = [Int[] for _ in 1:n]
    da_co = Set{Tuple{Int,Int}}()
    for (u, v) in canh
        (u isa Integer && v isa Integer) || throw(ArgumentError("nhan dinh phai la so nguyen"))
        (1 <= u <= n && 1 <= v <= n) || throw(ArgumentError("dinh nam ngoai 1..n"))
        u != v || throw(ArgumentError("do thi don khong co canh khuyen"))
        e = minmax(Int(u), Int(v))
        e in da_co && throw(ArgumentError("canh bi lap"))
        push!(da_co, e)
        push!(ke[u], v)
        push!(ke[v], u)
    end
    # Thứ tự này quyết định đường được chọn khi có nhiều đường ngắn nhất.
    for ds in ke
        sort!(ds)
    end
    return ke
end

"""
    bfs_cha(ke, s)

Duyệt hết thành phần liên thông chứa s. d[v]=-1 nếu chưa tới được v;
cha[s]=0; cha[v] chỉ được gán ở lần đầu phát hiện. Hàng đợi dùng mảng
cấp phát trước, chỉ số dau và cuoi; không dùng popfirst!.
"""
function bfs_cha(ke, s::Integer)
    n = length(ke)
    1 <= s <= n || throw(ArgumentError("nguon nam ngoai 1..n"))
    d = fill(-1, n)
    cha = zeros(Int, n)
    hang = zeros(Int, n)
    thu_tu = Int[]
    dau, cuoi = 1, 1
    hang[cuoi] = s
    d[s] = 0
    so_xet_canh = 0

    while dau <= cuoi
        u = hang[dau]
        dau += 1
        push!(thu_tu, u)
        for v in ke[u]
            so_xet_canh += 1
            if d[v] == -1
                # Đánh dấu ngay khi đưa vào hàng để mỗi đỉnh chỉ vào một lần.
                d[v] = d[u] + 1
                cha[v] = u
                cuoi += 1
                hang[cuoi] = v
            end
        end
    end
    return (; d, cha, thu_tu, so_phat_hien=length(thu_tu), so_xet_canh)
end

"""Lần theo cha từ t về s rồi đảo; trả Int[] nếu không có đường."""
function truy_vet(cha, s::Integer, t::Integer)
    n = length(cha)
    (1 <= s <= n && 1 <= t <= n) || throw(ArgumentError("s, t nam ngoai 1..n"))
    duong = Int[]
    v = Int(t)
    # Tối đa n đỉnh; chặn cả trường hợp mảng cha do người gọi truyền bị lỗi.
    for _ in 1:n
        push!(duong, v)
        if v == s
            reverse!(duong)
            return duong
        end
        v = cha[v]
        v == 0 && return Int[]
        1 <= v <= n || throw(ArgumentError("mang cha khong hop le"))
    end
    throw(ArgumentError("mang cha co chu trinh"))
end

"""Kiểm tra nhãn đỉnh và từng cặp đỉnh liên tiếp trên một đường không rỗng."""
function kiem_duong(ke, duong)
    isempty(duong) && return false
    all(v -> 1 <= v <= length(ke), duong) || return false
    for i in 1:(length(duong) - 1)
        duong[i + 1] in ke[duong[i]] || return false
    end
    return true
end

"""Ghép dựng đồ thị, BFS và truy vết; không đọc bất kỳ tệp dữ liệu nào."""
function tim_duong(n::Integer, canh, s::Integer, t::Integer)
    ke = tao_ke(n, canh)
    1 <= t <= n || throw(ArgumentError("dich nam ngoai 1..n"))
    kq = bfs_cha(ke, s)
    duong = kq.d[t] == -1 ? Int[] : truy_vet(kq.cha, s, t)
    so_canh = kq.d[t]
    if !isempty(duong)
        @assert length(duong) - 1 == so_canh
        @assert kiem_duong(ke, duong)
    end
    return (; ke, kq..., duong, so_canh, so_buoc_truy_vet=length(duong))
end

end # module BFS
