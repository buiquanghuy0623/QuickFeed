# Nhật ký tương tác AI (AI Prompt Log)

1. **Tác hại của Over-Indexing trên cột TEXT và BOOLEAN:**
   - *Prompt:* "Trong MySQL, nếu tôi tạo Index trên một cột chứa văn bản dài (TEXT) và một cột kiểu BOOLEAN (0 và 1), thì điều này gây hại như thế nào đến bộ nhớ RAM, dung lượng Disk và bộ tối ưu hóa (Query Optimizer)?"
   - *Kết quả học tập:* Hiểu rằng Index trên kiểu TEXT làm cây B-Tree cồng kềnh, lãng phí không gian; trong khi Index trên cột ít giá trị (Boolean) khiến Optimizer bỏ qua Index vì quét toàn bảng (Full Table Scan) còn nhanh hơn do chi phí đọc trang đĩa thấp.

2. **Truy vấn information_schema để đo lường dung lượng:**
   - *Prompt:* "Hãy cho tôi xem truy vấn SQL sử dụng bảng information_schema.TABLES để in ra kích thước Data và kích thước Index của bảng 'Posts' tính theo đơn vị Megabyte (MB)."
   - *Kết quả học tập:* Biết cách khai thác bảng hệ thống `information_schema.TABLES` để trích xuất trực quan các thông số `DATA_LENGTH` và `INDEX_LENGTH`.

3. **Giải pháp thay thế cho tìm kiếm văn bản dài:**
   - *Prompt:* "Nếu muốn tìm kiếm từ khóa bên trong cột content (kiểu TEXT) mà không bị tốn quá nhiều dung lượng như B-Tree Index, tôi nên sử dụng cơ chế nào của MySQL (Gợi ý: FULLTEXT Index)?"
   - *Kết quả học tập:* Nắm bắt cơ chế `FULLTEXT` chuyên dụng cho tìm kiếm văn bản thay vì cố gắng dùng B-Tree Index truyền thống.
