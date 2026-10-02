-- ========================================================
-- HỆ THỐNG QUICKFEED - TỐI ƯU HÓA INDEX & DUNG LƯỢNG LƯU TRỮ
-- ========================================================

CREATE DATABASE IF NOT EXISTS quickfeed_db;
USE quickfeed_db;

-- 1. Khởi tạo bảng Posts (mô phỏng bảng thực tế bị lạm dụng Index)
DROP TABLE IF EXISTS Posts;
CREATE TABLE Posts (
    post_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT,
    post_type VARCHAR(10), -- 'TEXT', 'IMAGE', 'VIDEO'
    is_visible BOOLEAN DEFAULT 1, -- 1 (Hiện), 0 (Ẩn)
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tình trạng ban đầu: Lập trình viên cũ tạo Index vô tội vạ (Over-Indexing)
CREATE INDEX idx_user_id ON Posts(user_id);
CREATE INDEX idx_content ON Posts(content(255)); 
CREATE INDEX idx_post_type ON Posts(post_type); 
CREATE INDEX idx_is_visible ON Posts(is_visible); 
CREATE INDEX idx_created_at ON Posts(created_at);

-- ========================================================
-- 2. KIỂM TRA THỐNG KÊ DUNG LƯỢNG TRƯỚC KHI TỐI ƯU (Dùng information_schema)
-- ========================================================
SELECT 
    TABLE_NAME,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS Data_Size_MB,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS Index_Size_MB,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS Total_Size_MB
FROM 
    information_schema.TABLES
WHERE 
    TABLE_SCHEMA = 'quickfeed_db' 
    AND TABLE_NAME = 'Posts';

-- ========================================================
-- 3. TRIỂN KHAI GIẢI PHÁP: LOẠI BỎ CÁC INDEX VÔ GIÁ TRỊ (LOW CARDINALITY / OVERHEAD)
-- Giữ lại: idx_user_id (để lọc theo user) và idx_created_at (để sắp xếp newsfeed theo thời gian).
-- Xóa bỏ: idx_content (tốn kém dung lượng văn bản), idx_post_type, idx_is_visible (Cardinality quá thấp).
-- ========================================================
ALTER TABLE Posts DROP INDEX idx_content;
ALTER TABLE Posts DROP INDEX idx_post_type;
ALTER TABLE Posts DROP INDEX idx_is_visible;

-- ========================================================
-- 4. KIỂM TRA LẠI THỐNG KÊ DUNG LƯỢNG SAU KHI TỐI ƯU
-- ========================================================
SELECT 
    TABLE_NAME,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS Data_Size_MB,
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS Index_Size_MB,
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS Total_Size_MB
FROM 
    information_schema.TABLES
WHERE 
    TABLE_SCHEMA = 'quickfeed_db' 
    AND TABLE_NAME = 'Posts';
