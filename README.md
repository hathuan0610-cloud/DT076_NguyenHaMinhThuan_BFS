# DT076 — Tìm và in đường đi ít cạnh nhất bằng BFS

**Sinh viên thực hiện:** Nguyễn Hà Minh Thuận  
**MSSV:** N24DCDT093  
**Lớp:** D24CQDT01-N  
**Học phần:** Cấu trúc dữ liệu và Giải thuật (INT13185 — Nhóm 03)  
**Giảng viên hướng dẫn:** Hồ Nhựt Minh  

# DT076 Tìm đường đi ít cạnh nhất bằng BFS

Bản giải tham khảo hoàn chỉnh dùng cho học phần INT13185 nhóm 03. Đây là mã mẫu
giảng viên, không nhận danh tính hoặc kết quả của một sinh viên cụ thể.
Tham chiếu giáo trình INT1306, mục 6.2 và 6.3.2, trang in 140–145, Bài tập 28
trang in 159. Đồ thị hình thoi là ví dụ tự thiết kế.

## Bắt đầu

Cài Julia; bản này được kiểm bằng Julia 1.13.1. Chỉ dùng thư viện chuẩn.
Từ thư mục mã, chạy trong PowerShell:

```powershell
.\Run_all.ps1
```

Nếu Julia chưa có trên PATH, truyền đường dẫn tới julia.exe:

```powershell
.\Run_all.ps1 -Julia 'DUONG_DAN_DEN_JULIA_EXE'
```

Tệp Run_all.ps1 chỉ chạy các lệnh dưới, dừng ngay khi lệnh trả mã lỗi.
Không cần Python, Node, CSV, mạng hoặc tệp dữ liệu nhập để chạy thuật toán.

```powershell
julia --startup-file=no demo.jl --ca=1
# Thay 1 bằng 2..8 để xem từng ca
julia --startup-file=no test/runtests.jl
julia --startup-file=no test/verify_exhaustive.jl
julia --startup-file=no scripts/trace_and_scales.jl
julia --startup-file=no scripts/test_catalog.jl
julia --startup-file=no demo.jl --nhap
```

Nhập bàn phím ví dụ hình thoi: dòng đầu `4 4`, bốn dòng `1 2`, `1 3`, `2 4`,
`3 4`, cuối `1 4`. Chương trình hỏi từng dòng. Các demo khai báo trực tiếp.

## Hợp đồng bài toán

- Đồ thị đơn vô hướng không trọng số, 1≤n≤100, nhãn 1..n; s,t trong miền.
- Không cạnh khuyên/trùng; cặp đảo là cùng một cạnh. Kề xét tăng dần.
- In thứ tự BFS, d, cha, một tuyến s→t và số cạnh. d=-1 là chưa đến được,
  cha=0 là không cha. Không đường trả [] và -1; s=t trả [s], 0 cạnh.
- BFS chạy hết thành phần chứa s. Đánh dấu ngay khi enqueue; cha gán một lần.
- Hai lời gọi trên cùng đồ thị phải bắt đầu từ trạng thái mới.

## Các phần đã giải

| Tệp | Vai trò |
|---|---|
| src/BFS.jl | Dựng kề, FIFO mảng, BFS, truy vết và kiểm đường |
| demo.jl | 8 demo và nhập bàn phím |
| test/runtests.jl | 12 ca chức năng và 16 ca hàm/validator, 59 phép assert |
| test/verify_exhaustive.jl | Floyd–Warshall độc lập trên mọi đồ thị đơn n≤5 |
| scripts/test_catalog.jl | In input, expected, actual, PASS của 28 ca có mã |
| scripts/trace_and_scales.jl | Truy vết T01 và 9 phép đếm ở 3 họ đồ thị/3 cỡ |
| Run_all.ps1 | Chạy toàn bộ quy trình bằng một lệnh |

Demo 1 hình thoi cho [1,2,4], 2 cạnh; 2 không có đường; 3 s=t;
4 nguồn cô lập; 5 chuỗi; 6 chu trình; 7 n=1; 8 cạnh trùng bị từ chối.
Demo 8 bắt đúng ArgumentError dự kiến rồi trả mã 0. Lỗi khác bị ném lại;
không có nghĩa thuật toán chấp nhận input sai.

## Lập luận và kiểm chứng

FIFO xử lý theo mức; mỗi đỉnh mới v nhận d[v]=d[u]+1 từ cha u.
Nếu có đường ngắn hơn thì v đã được phát hiện ở mức trước, mâu thuẫn lần đầu.
Truy vết theo cha giảm d một đơn vị, dừng tại s. Kiểm độ dài và từng cạnh
chỉ chứng minh tuyến hợp lệ; tối ưu dựa vào BFS và oracle độc lập.

Lõi BFS sau chuẩn bị kề tốn O(n+m), phụ O(n). Truy vết O(l). Chuẩn bị kề
có chi phí sắp riêng Σ deg(v)log(deg(v)); kiểm trùng bằng Set có chi phí
kỳ vọng O(m), không phải cam kết tệ nhất hằng số của bảng băm.
kiem_duong dùng tìm tuyến tính trong kề; trên tuyến BFS đơn, tổng bậc các
đỉnh của tuyến ≤2m, nên bước kiểm này O(n+m), không phải O(l) tổng quát.
Một đường nhập tùy ý có l đỉnh lặp có thể tốn O(l·Δ).

Oracle Floyd–Warshall không dùng BFS tạo expected. Nó kiểm 1.099 đồ thị,
26.705 cặp nguồn/đích với n=1..5. Đây là kiểm hữu hạn, không thay chứng minh
cho n lớn; không gọi số cặp là số phép assert của test/runtests.jl.

## Phiên bản và chạy lại

Gói có Git bundle thật do bản giải này tạo và thử clone cục bộ. Lệnh khôi phục:

```powershell
git clone BFS_mau.bundle BFS_clone
cd BFS_clone
git rev-parse HEAD
.\Run_all.ps1
```

Bundle đặt cạnh ZIP mã trong thư mục phát hành, không phải dữ liệu thuật toán.
SHA C của nguồn dùng tạo kết quả được ghi trong báo cáo. Đã có bằng chứng
clone local thực chạy; chưa có repository GitHub cá nhân được tạo thay.
Sinh viên dùng tài khoản của mình tạo repo GitHub, push mã, tự chụp bằng chứng
GitHub và điền URL/permalink thật theo hướng dẫn Classroom đi kèm.

## Sử dụng học thuật

Không còn TODO thuật toán trong bản giải. Sinh viên đề khác phải thay nội dung,
thuật toán và test theo đúng phiếu cá nhân. Nêu phần tham khảo từ bản mẫu,
tự chạy và chụp ảnh của mình. Rubric chấm theo chất lượng có thể kiểm lại;
phiếu điểm trong báo cáo mẫu không được tự coi là điểm sinh viên đã đạt.
