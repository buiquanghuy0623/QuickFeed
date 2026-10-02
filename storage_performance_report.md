# Báo cáo Đánh giá Tài nguyên & Hiệu năng (Storage & Performance Report)

- **Nguyên nhân sự cố:** Việc lạm dụng tạo Index trên mọi cột (Over-Indexing), đặc biệt là cột văn bản dài (`content`) và các cột có độ phân giải dữ liệu cực thấp (`is_visible` chỉ có 2 giá trị, `post_type` có 3 giá trị) đã làm phình to dung lượng ổ cứng. Mỗi thao tác `INSERT` bài viết mới buộc hệ thống phải ghi đè đồng thời lên 5 cây cấu trúc B-Tree ngầm, gây tranh chấp tài nguyên và lỗi Timeout (5-10 giây).
- **Giải pháp tối ưu:** 
  - Giữ lại các Index có tính phân biệt (Cardinality) cao và phục vụ trực tiếp cho truy vấn cốt lõi: `idx_user_id` và `idx_created_at`.
  - Cắt bỏ hoàn toàn 3 Index thừa thãi: `idx_content`, `idx_post_type`, và `idx_is_visible`.
- **Kết quả đối chiếu:** 
  - Dung lượng `Index_Length` giảm mạnh (giải phóng hàng chục đến hàng trăm MB dung lượng ổ cứng và RAM).
  - Tốc độ Ghi (`WRITE` / `INSERT`) được cải thiện rõ rệt, loại bỏ hoàn toàn hiện tượng nghẽn cổ chai và giải quyết triệt để lỗi Timeout cho người dùng.
