-- ============================================================
-- Migration: Chuyen doi sang utf8mb4 ho tro Tieng Viet day du
-- Database: warehousedb
-- MySQL 8.0+
-- ============================================================

USE warehousedb;

-- 1. Sua cot user.name tu utf8mb3 -> utf8mb4 (day la cot DUY NHAT dang dung sai charset)
ALTER TABLE `user`
    MODIFY COLUMN `name` VARCHAR(255)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL;

-- 2. Dam bao cac cot TEXT cung dung utf8mb4 (an toan neu table co DEFAULT khac)
ALTER TABLE `customer`
    MODIFY COLUMN `note` TEXT
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

ALTER TABLE `password_reset_request`
    MODIFY COLUMN `note` TEXT
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

-- 3. Dam bao cac cot VARCHAR trong bang `user` deu utf8mb4
-- (cac bang khac da DEFAULT CHARSET=utf8mb4 nen VARCHAR tu dong utf8mb4)
ALTER TABLE `user`
    MODIFY COLUMN `username` VARCHAR(45)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    MODIFY COLUMN `password` VARCHAR(255)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    MODIFY COLUMN `email` VARCHAR(100)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    MODIFY COLUMN `phone` VARCHAR(45)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    MODIFY COLUMN `address` TEXT
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
    MODIFY COLUMN `status` VARCHAR(20)
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active';

-- 4. Kiem tra ket qua
SELECT TABLE_NAME, COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'warehousedb'
  AND DATA_TYPE IN ('varchar', 'text')
  AND CHARACTER_SET_NAME IS NOT NULL
ORDER BY TABLE_NAME, ORDINAL_POSITION;
