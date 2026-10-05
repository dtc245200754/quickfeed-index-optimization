# Nhật Ký Tương Tác AI (AI Prompt Log) - Dự Án QuickFeed

### Session 1: Tìm hiểu về cấu trúc InnoDB Storage & Truy vấn tài nguyên
- **Prompt:** "Trong MySQL InnoDB, làm thế nào để viết câu lệnh SQL truy vấn bảng information_schema.TABLES lấy ra dung lượng Data_length và Index_length theo đơn vị Megabyte (MB) của một bảng cụ thể?"
- **AI Response Summary:** AI cung cấp công thức chia `1024 / 1024` cho các trường `data_length` và `index_length` từ `information_schema.TABLES`, giải thích cơ chế cập nhật thống kê tài nguyên của InnoDB engine.

### Session 2: Khái niệm Cardinality & Đánh giá tác hại Over-Indexing
- **Prompt:** "Trong MySQL, nếu tôi tạo Index trên một cột kiểu BOOLEAN (chỉ có 0 và 1) hoặc VARCHAR chỉ có 3 giá trị, tại sao Query Optimizer lại bỏ qua Index này và tiến hành Full Table Scan? Điều này ảnh hưởng như thế nào đến B-Tree?"
- **AI Response Summary:** AI giải thích nguyên lý độ chọn lọc (Selectivity). Khi một giá trị chiếm phần lớn dữ liệu (ví dụ 90% dòng mang giá trị `is_visible = 1`), việc MySQL duyệt qua Index B-Tree rồi quay lại lấy dòng dữ liệu thực tế (Clustered Index Lookup) tốn thêm rất nhiều I/O so với việc đọc nối tiếp toàn bộ Data Pages (Full Table Scan).

### Session 3: Tối ưu tìm kiếm văn bản dài (TEXT)
- **Prompt:** "Nếu muốn tìm kiếm từ khóa bên trong cột content (kiểu TEXT) mà không bị tốn quá nhiều dung lượng như B-Tree Prefix Index, tôi nên sử dụng cơ chế nào của MySQL?"
- **AI Response Summary:** AI phân tích sự khác biệt giữa B-Tree Index (phù hợp so sánh chính xác `=`, khoảng giá trị `>`, `<`) và FULLTEXT Index (sử dụng Inverted Index phù hợp cho từ khóa bài viết, tiết kiệm dung lượng và không làm chậm thao tác chèn chuỗi dài).