-- v007: Bổ sung 2 cột cho chức năng Cancel 2-mode (REBUILD / KILL)
-- Áp dụng khi muốn phân biệt "hủy để làm lại" vs "hủy hoàn toàn kế hoạch"

ALTER TABLE `purchase_order`
  ADD COLUMN `cancel_mode` varchar(20) DEFAULT NULL COMMENT 'REBUILD hoặc KILL, NULL nếu không phải cancel' AFTER `reject_reason`,
  ADD COLUMN `cancel_reason` text DEFAULT NULL COMMENT 'Lý do hủy PO' AFTER `cancel_mode`;
