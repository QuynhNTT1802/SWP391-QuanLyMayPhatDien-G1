-- ============================================================
-- MIGRATION: Loại bỏ status PENDING_IMPORT và RESERVED_EXPORT
-- Áp dụng: 2026-07-15
-- Lý do: Sau khi bỏ flow "scan-and-reserve" (đổi sang inventory-lookup
--        không tạo reservation trước), 2 status này không còn được tạo.
--        Cần xử lý dữ liệu cũ (nếu có) trước khi có thể DROP CONSTRAINT
--        hoặc xóa cột nếu schema ENUM.
-- Lưu ý: Chạy script này 1 lần trên database đang hoạt động
-- ============================================================

-- 1. Rollback PENDING_IMPORT -> IN_STOCK cho các inventory rows cũ
--    Lý do: PENDING_IMPORT được dùng cho phiếu nhập đang chờ duyệt.
--    Nếu phiếu đã được duyệt, inventory đáng lẽ đã ở IN_STOCK.
--    Nếu phiếu đã bị hủy, inventory rows PENDING_IMPORT bị xóa (ON DELETE CASCADE).
--    Tuy nhiên, để chắc chắn, ta set PENDING_IMPORT -> IN_STOCK.
UPDATE inventory SET status = 'IN_STOCK' WHERE status = 'PENDING_IMPORT';

-- 2. Rollback RESERVED_EXPORT -> IN_STOCK cho các inventory rows cũ
--    Lý do: RESERVED_EXPORT được dùng cho phiếu xuất đã "đặt trước" serial.
--    Nếu phiếu đã được duyệt, inventory đáng lẽ đã ở SOLD/IN_TRANSIT/LIQUIDATED.
--    Nếu phiếu bị hủy/rút, reservation bị release về IN_STOCK.
--    Tuy nhiên, để chắc chắn, ta set RESERVED_EXPORT -> IN_STOCK.
UPDATE inventory SET status = 'IN_STOCK' WHERE status = 'RESERVED_EXPORT';

-- 3. Kiểm tra: không còn inventory rows nào ở 2 status này
SELECT COUNT(*) AS remaining_pending_import FROM inventory WHERE status = 'PENDING_IMPORT';
SELECT COUNT(*) AS remaining_reserved_export FROM inventory WHERE status = 'RESERVED_EXPORT';
-- Cả 2 query trên phải trả về 0. Nếu không, kiểm tra lại dữ liệu.