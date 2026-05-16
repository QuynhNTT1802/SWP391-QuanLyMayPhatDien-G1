-- ============================================
-- Database: warehousedb
-- Bảng user cho chức năng Profile
-- ============================================

CREATE DATABASE IF NOT EXISTS warehousedb;
USE warehousedb;

-- ============================================
-- Bảng user
-- ============================================
CREATE TABLE IF NOT EXISTS `user` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `name` VARCHAR(100) NOT NULL,
  `username` VARCHAR(50) NOT NULL UNIQUE,
  `password` VARCHAR(255) NOT NULL,
  `email` VARCHAR(100) NOT NULL UNIQUE,
  `phone` VARCHAR(20),
  `address` VARCHAR(200),
  `status` VARCHAR(20) DEFAULT 'active',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP NULL DEFAULT NULL,
  `created_by` INT DEFAULT NULL,
  `updated_by` INT DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- Dữ liệu test (password plain text để test login)
-- ============================================
INSERT INTO `user` (`name`, `username`, `password`, `email`, `phone`, `address`, `status`, `created_at`, `updated_at`) VALUES
('Mai Hoàng',        'maihoang',    '123456',    'mai.hoang@warehouseos.vn',      '+84 912 345 678',  'Số 24, ngõ 12, Đội Cấn, Ba Đình, Hà Nội',     'active', NOW(), NOW()),
('Nguyễn Văn Admin', 'admin',       'admin123',  'admin@warehouseos.vn',          '+84 900 000 001',  'Hà Nội',                                       'active', NOW(), NOW()),
('Trần Thị User',    'user01',      '123456',    'user01@warehouseos.vn',         '+84 987 654 321',  'TP. Hồ Chí Minh',                              'active', NOW(), NOW()),
('Lê Văn Test',      'testuser',    'test123',   'test@warehouseos.vn',           '+84 911 222 333',  'Đà Nẵng',                                      'active', NOW(), NOW());

-- ============================================
-- Kiểm tra dữ liệu
-- ============================================
SELECT * FROM `user`;

-- ============================================
-- Tài khoản test để login:
--   Username: maihoang  | Password: 123456
--   Username: admin     | Password: admin123
--   Username: user01    | Password: 123456
--   Username: testuser  | Password: test123
-- ============================================
