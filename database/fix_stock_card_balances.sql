-- Script cập nhật đồng bộ số dư thẻ kho lũy kế cho MySQL
-- Chạy script này trên MySQL Database của bạn để dọn dẹp và làm sạch lịch sử thẻ kho

-- 1. Đồng bộ dòng máy Honda XP921L4M (generator_id = 7, kho Hà Nội = 1)
UPDATE `stock_card` SET `quantity_change` = 4, `quantity_after` = 4 WHERE `stock_card_id` = 85;
UPDATE `stock_card` SET `quantity_after` = 3 WHERE `stock_card_id` = 95;
UPDATE `stock_card` SET `quantity_after` = 2 WHERE `stock_card_id` = 98;
UPDATE `stock_card` SET `quantity_after` = 1 WHERE `stock_card_id` = 99;

-- 2. Đồng bộ dòng máy Mitsubishi LKB3812H (generator_id = 16, kho Hà Nội = 1)
INSERT IGNORE INTO `stock_card` (`stock_card_id`, `warehouse_id`, `generator_id`, `receipt_id`, `transaction_type`, `quantity_change`, `quantity_after`, `reference_note`, `created_at`, `created_by`)
VALUES (83, 1, 16, 37, 'IMPORT', 1, 1, 'Phiếu RX-IM-202604-SMP01', '2026-04-08 10:30:00', 3);
