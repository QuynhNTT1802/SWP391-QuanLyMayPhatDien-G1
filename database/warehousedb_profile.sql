-- Chay file nay trong mysql.exe de tao database va insert du lieu test
-- mysql -u root -p < warehousedb_profile.sql

CREATE DATABASE IF NOT EXISTS warehousedb;
USE warehousedb;

-- Tao bang user
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

-- Xoa du lieu cu neu da ton tai
DELETE FROM `user`;

-- Insert du lieu test
INSERT INTO `user` (`name`, `username`, `password`, `email`, `phone`, `address`, `status`, `created_at`, `updated_at`) VALUES
('Mai Hoang',        'maihoang',    '123456',    'mai.hoang@warehouseos.vn',    '+84 912 345 678',  'So 24, ngo 12, Doi Can, Ba Dinh, Ha Noi',    'active', NOW(), NOW()),
('Nguyen Van Admin', 'admin',       'admin123',  'admin@warehouseos.vn',        '+84 900 000 001',  'Ha Noi',                                     'active', NOW(), NOW()),
('Tran Thi User',    'user01',      '123456',    'user01@warehouseos.vn',       '+84 987 654 321',  'TP. Ho Chi Minh',                            'active', NOW(), NOW()),
('Le Van Test',      'testuser',    'test123',   'test@warehouseos.vn',         '+84 911 222 333',  'Da Nang',                                    'active', NOW(), NOW());

-- Kiem tra ket qua
SELECT * FROM `user`;
