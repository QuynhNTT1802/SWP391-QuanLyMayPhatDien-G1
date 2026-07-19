-- ============================================================
-- MIGRATION: Luồng luân chuyển kho mới (Transfer -> Export -> Import)
-- Áp dụng: 2026-07-15
-- Lưu ý: Chạy script này 1 lần trên database đang hoạt động
-- ============================================================

-- 1. Cho phép transfer_detail.serial_number NULL
--    (đề xuất chỉ cần generator + quantity, không cần serial cụ thể)
ALTER TABLE transfer_detail MODIFY COLUMN serial_number VARCHAR(100) NULL;

-- 2. Bảng transfer: thêm liên kết phiếu xuất/nhập + theo dõi trạng thái mới
ALTER TABLE transfer
  ADD COLUMN export_receipt_id INT NULL AFTER final_reviewed_at,
  ADD COLUMN import_receipt_id INT NULL AFTER export_receipt_id;

-- 3. Foreign key cho transfer
-- Lưu ý: kiểm tra FK đã tồn tại chưa trước khi thêm
SET @fk_export := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
                   WHERE CONSTRAINT_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'transfer'
                     AND CONSTRAINT_NAME = 'fk_tr_export_receipt');
SET @sql := IF(@fk_export = 0,
  'ALTER TABLE transfer ADD CONSTRAINT fk_tr_export_receipt FOREIGN KEY (export_receipt_id) REFERENCES receipt(receipt_id) ON DELETE SET NULL',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_import := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
                   WHERE CONSTRAINT_SCHEMA = DATABASE()
                     AND TABLE_NAME = 'transfer'
                     AND CONSTRAINT_NAME = 'fk_tr_import_receipt');
SET @sql := IF(@fk_import = 0,
  'ALTER TABLE transfer ADD CONSTRAINT fk_tr_import_receipt FOREIGN KEY (import_receipt_id) REFERENCES receipt(receipt_id) ON DELETE SET NULL',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 4. Index
SET @idx_export := (SELECT COUNT(*) FROM information_schema.STATISTICS
                    WHERE TABLE_SCHEMA = DATABASE()
                      AND TABLE_NAME = 'transfer'
                      AND INDEX_NAME = 'idx_tr_export_receipt');
SET @sql := IF(@idx_export = 0,
  'ALTER TABLE transfer ADD INDEX idx_tr_export_receipt (export_receipt_id)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_import := (SELECT COUNT(*) FROM information_schema.STATISTICS
                    WHERE TABLE_SCHEMA = DATABASE()
                      AND TABLE_NAME = 'transfer'
                      AND INDEX_NAME = 'idx_tr_import_receipt');
SET @sql := IF(@idx_import = 0,
  'ALTER TABLE transfer ADD INDEX idx_tr_import_receipt (import_receipt_id)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 5. Bảng receipt: thêm liên kết phiếu đề xuất + phiếu xuất nguồn
ALTER TABLE receipt
  ADD COLUMN linked_transfer_id INT NULL AFTER purchase_order_id,
  ADD COLUMN related_export_receipt_id INT NULL AFTER linked_transfer_id;

SET @fk_receipt_tr := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
                       WHERE CONSTRAINT_SCHEMA = DATABASE()
                         AND TABLE_NAME = 'receipt'
                         AND CONSTRAINT_NAME = 'fk_receipt_transfer');
SET @sql := IF(@fk_receipt_tr = 0,
  'ALTER TABLE receipt ADD CONSTRAINT fk_receipt_transfer FOREIGN KEY (linked_transfer_id) REFERENCES transfer(transfer_id) ON DELETE SET NULL',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @fk_receipt_re := (SELECT COUNT(*) FROM information_schema.TABLE_CONSTRAINTS
                       WHERE CONSTRAINT_SCHEMA = DATABASE()
                         AND TABLE_NAME = 'receipt'
                         AND CONSTRAINT_NAME = 'fk_receipt_related_export');
SET @sql := IF(@fk_receipt_re = 0,
  'ALTER TABLE receipt ADD CONSTRAINT fk_receipt_related_export FOREIGN KEY (related_export_receipt_id) REFERENCES receipt(receipt_id) ON DELETE SET NULL',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_receipt_tr := (SELECT COUNT(*) FROM information_schema.STATISTICS
                        WHERE TABLE_SCHEMA = DATABASE()
                          AND TABLE_NAME = 'receipt'
                          AND INDEX_NAME = 'idx_receipt_transfer');
SET @sql := IF(@idx_receipt_tr = 0,
  'ALTER TABLE receipt ADD INDEX idx_receipt_transfer (linked_transfer_id)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

SET @idx_receipt_re := (SELECT COUNT(*) FROM information_schema.STATISTICS
                        WHERE TABLE_SCHEMA = DATABASE()
                          AND TABLE_NAME = 'receipt'
                          AND INDEX_NAME = 'idx_receipt_related_export');
SET @sql := IF(@idx_receipt_re = 0,
  'ALTER TABLE receipt ADD INDEX idx_receipt_related_export (related_export_receipt_id)',
  'SELECT 1');
PREPARE stmt FROM @sql; EXECUTE stmt; DEALLOCATE PREPARE stmt;

-- 6. Theo lựa chọn của user "Bỏ qua - giữ nguyên":
--    KHÔNG migration dữ liệu cũ. Các phiếu AWAITING_DEST_ACCEPT cũ vẫn giữ nguyên.
-- ============================================================
-- DONE
-- ============================================================
