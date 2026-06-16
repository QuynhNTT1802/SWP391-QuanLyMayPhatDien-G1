-- ============================================================
-- Migration: v008_refactor_receipt_detail
-- Mục đích:  Chuyển receipt_detail từ text-based (serial_number)
--            sang FK-based (inventory_id) + thêm 2 status mới
--            cho inventory (PENDING_IMPORT, RESERVED_EXPORT).
-- Tác giả:  Auto-generated
-- Ngày:     2026-06-16
--
-- !!! CHẠY SAU KHI BACKUP DB, TRƯỚC KHI DEPLOY CODE MỚI !!!
--
-- Thay đổi:
--   receipt_detail:
--     + ADD COLUMN inventory_id INT NULL
--     + ADD KEY idx_rd_inventory
--     + DROP COLUMN serial_number
--     + DROP COLUMN quantity
--     + DROP COLUMN generator_id
--     + DROP INDEX uk_serial_receipt
--     + DROP INDEX idx_rd_generator
--     + MODIFY inventory_id NOT NULL
--     + ADD FOREIGN KEY fk_rd_inventory
--     + ADD UNIQUE KEY uk_rd_inventory
-- ============================================================

START TRANSACTION;

-- 1. Backfill: tạo inventory row cho mỗi serial trong receipt_detail (nếu chưa có)
INSERT INTO inventory (serial_number, generator_id, warehouse_id, status, created_at, updated_at)
SELECT DISTINCT rd.serial_number, rd.generator_id, r.warehouse_id, 'IN_STOCK', NOW(), NOW()
FROM receipt_detail rd
JOIN receipt r ON rd.receipt_id = r.receipt_id
WHERE rd.serial_number IS NOT NULL AND rd.serial_number <> ''
  AND NOT EXISTS (SELECT 1 FROM inventory i WHERE i.serial_number = rd.serial_number);

-- 2. Thêm cột inventory_id (NULL tạm thời)
ALTER TABLE receipt_detail
  ADD COLUMN inventory_id INT NULL AFTER receipt_id,
  ADD KEY idx_rd_inventory (inventory_id);

-- 3. Backfill inventory_id từ serial_number
UPDATE receipt_detail rd
JOIN inventory i ON i.serial_number = rd.serial_number
SET rd.inventory_id = i.inventory_id
WHERE rd.serial_number IS NOT NULL AND rd.serial_number <> '';

-- 4. Drop cột cũ + index cũ
ALTER TABLE receipt_detail
  DROP INDEX uk_serial_receipt,
  DROP COLUMN serial_number,
  DROP COLUMN quantity,
  DROP COLUMN generator_id,
  DROP INDEX idx_rd_generator;

-- 5. Thêm FK + UNIQUE mới
ALTER TABLE receipt_detail
  MODIFY COLUMN inventory_id INT NOT NULL,
  ADD CONSTRAINT fk_rd_inventory
      FOREIGN KEY (inventory_id) REFERENCES inventory(inventory_id) ON DELETE CASCADE,
  ADD UNIQUE KEY uk_rd_inventory (inventory_id);

COMMIT;

-- 6. Verify: đảm bảo không có detail row nào NULL inventory_id
SELECT COUNT(*) AS detail_total,
       COUNT(inventory_id) AS detail_with_fk
FROM receipt_detail;
-- Expected: detail_total = detail_with_fk
-- Nếu lệch: có receipt_detail với serial_number rỗng / không match → cần xử lý tay.
