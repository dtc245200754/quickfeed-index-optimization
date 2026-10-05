-- ============================================================================
-- DỰ ÁN QUICKFEED - MÃ NGUỒN TỐI ƯU HÓA INDEX VÀ GIẢI PHÓNG DUNG LƯỢNG Ổ CỨNG
-- Vai trò: Database Administrator (DBA)
-- ============================================================================

USE quickfeed_db;

-- 1. KIỂM TRA TÀI NGUYÊN BỘ NHỚ TRƯỚC KHI TỐI ƯU HÓA
-- Truy vấn information_schema để lấy dung lượng Data và Index theo đơn vị Megabytes (MB)
SELECT 
    table_name AS 'Table Name',
    ROUND(((data_length) / 1024 / 1024), 2) AS 'Data Size (MB)',
    ROUND(((index_length) / 1024 / 1024), 2) AS 'Index Size (MB)',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Total Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';

-- Xem chi tiết các Index hiện tại và độ phân giải (Cardinality)
SHOW INDEX FROM Posts;


-- 2. LOẠI BỎ CÁC INDEX KHÔNG HIỆU QUẢ / DƯ THỪA (CẮT BỎ CHỈ MỤC GÂY HẠI)

-- Lỗi 1: Xóa Index trên cột TEXT (content) - Tốn Disk/RAM cực lớn, B-Tree không tối ưu cho tìm kiếm văn bản
ALTER TABLE Posts DROP INDEX idx_content;

-- Lỗi 2: Xóa Index trên cột post_type - Cardinality cực thấp (chỉ có 3 giá trị)
ALTER TABLE Posts DROP INDEX idx_post_type;

-- Lỗi 3: Xóa Index trên cột is_visible - Cardinality cực thấp (chỉ có 0 và 1)
ALTER TABLE Posts DROP INDEX idx_is_visible;


-- 3. GIỮ LẠI VÀ BỔ SUNG INDEX CÓ GIÁ TRỊ CAO
-- idx_user_id: Giữ lại (Lọc bài viết theo người dùng)
-- idx_created_at: Giữ lại (Sắp xếp Newsfeed theo thời gian)
-- (Tùy chọn) Nếu ứng dụng có tính năng tìm kiếm từ khóa trong bài viết, sử dụng FULLTEXT Index thay vì B-Tree prefix
-- CREATE FULLTEXT INDEX idx_content_ft ON Posts(content);


-- 4. KIỂM TRA LẠI DUNG LƯỢNG BỘ NHỚ SAU KHI TỐI ƯU HÓA
SELECT 
    table_name AS 'Table Name',
    ROUND(((data_length) / 1024 / 1024), 2) AS 'Data Size (MB)',
    ROUND(((index_length) / 1024 / 1024), 2) AS 'Index Size (MB)',
    ROUND(((data_length + index_length) / 1024 / 1024), 2) AS 'Total Size (MB)'
FROM information_schema.TABLES
WHERE table_schema = 'quickfeed_db' AND table_name = 'Posts';