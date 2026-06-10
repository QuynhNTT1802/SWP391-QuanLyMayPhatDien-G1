-- Migration v005: Bỏ bảng stock_card_serial, restore + enforce unique cột receipt_detail.serial_number
-- (Bảng stock_card vẫn giữ làm audit log)

-- Bước 1: Xóa stock_card mẫu cũ (không có receipt_id, không thể JOIN với receipt_detail)
DELETE FROM stock_card WHERE receipt_id IS NULL;

-- Bước 2: Drop bảng stock_card_serial
DROP TABLE IF EXISTS stock_card_serial;

-- Bước 3: Sửa constraint trên receipt_detail
--   Cột serial_number vẫn còn trong schema; đổi UNIQUE KEY cũ (chỉ unique trong cùng phiếu)
--   thành UNIQUE KEY mới (unique toàn hệ thống).
ALTER TABLE receipt_detail DROP INDEX uk_serial_receipt;
ALTER TABLE receipt_detail ADD UNIQUE KEY uk_serial_global (serial_number);
ALTER TABLE receipt_detail ADD INDEX idx_rd_serial (serial_number);
