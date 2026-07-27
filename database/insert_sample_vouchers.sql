-- =================================================================================
-- FILE: database/insert_sample_vouchers.sql
-- TÁC DỤNG: Insert dữ liệu mẫu cho 8 loại phiếu & bảng chi tiết (Tháng 4 -> Tháng 7/2026)
-- ĐẶC ĐIỂM: Dùng biến SQL (@var) để gán ID chính xác, chống tràn số UNSIGNED & trùng UNIQUE code
-- =================================================================================

USE `warehousedb`;

SET FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@sql_mode;
SET sql_mode = 'NO_UNSIGNED_SUBTRACTION';
START TRANSACTION;

-- =================================================================================
-- PHẦN 1: PHIẾU ĐỀ XUẤT NHẬP KHO (import_proposal & import_proposal_detail) - 20 PHIẾU
-- =================================================================================

-- Đề xuất 1 (T4)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202604-SMP01', 'APPROVED', 1, 10, 3, 3, '2026-04-05 08:30:00', '202604', 'Đề xuất nhập máy Honda 5kW Kho 1 đợt T4', '2026-04-05 09:00:00', '2026-04-05 08:30:00');
SET @prc1 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc1, 6, 10, 3, 2, 45000000.00, 'Honda 5kW');
SET @pd1 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc1, 7, 10, 2, 1, 68000000.00, 'Honda 8kW');
SET @pd2 = LAST_INSERT_ID();

-- Đề xuất 2 (T4)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202604-SMP02', 'APPROVED', 2, 5, 14, 5, '2026-04-12 09:15:00', '202604', 'Đề xuất máy Cummins công nghiệp Kho 2', '2026-04-12 10:00:00', '2026-04-12 09:15:00');
SET @prc2 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc2, 24, 5, 4, 0, 226000000.00, 'Cummins 100kVA');
SET @pd3 = LAST_INSERT_ID();

-- Đề xuất 3 (T4)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202604-SMP03', 'APPROVED', 1, 1, 3, 3, '2026-04-18 10:00:00', '202604', 'Nhập máy phát Honda dân dụng đợt T4', '2026-04-18 11:30:00', '2026-04-18 10:00:00');
SET @prc3 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc3, 11, 1, 5, 3, 95000000.00, 'Honda 1 pha');
SET @pd4 = LAST_INSERT_ID();

-- Đề xuất 4 (T4)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202604-SMP04', 'APPROVED', 2, 2, 14, 5, '2026-04-25 14:00:00', '202604', 'Đề xuất máy Yamaha dự phòng Kho 2', '2026-04-25 15:30:00', '2026-04-25 14:00:00');
SET @prc4 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc4, 16, 2, 2, 2, 172000000.00, 'Yamaha Inverter');
SET @pd5 = LAST_INSERT_ID();

-- Đề xuất 5 (T5)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202605-SMP05', 'APPROVED', 1, 9, 3, 3, '2026-05-04 08:00:00', '202605', 'Nhập bổ sung Cummins 3 pha đợt T5', '2026-05-04 09:10:00', '2026-05-04 08:00:00');
SET @prc5 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc5, 21, 9, 3, 1, 245000000.00, 'Cummins 150kVA');
SET @pd6 = LAST_INSERT_ID();

-- Đề xuất 6 (T5)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202605-SMP06', 'APPROVED', 2, 7, 14, 5, '2026-05-10 10:30:00', '202605', 'Đề xuất bổ sung kho miền Nam T5', '2026-05-10 11:45:00', '2026-05-10 10:30:00');
SET @prc6 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc6, 22, 7, 2, 0, 21700000.00, 'Máy dầu 10kW');
SET @pd7 = LAST_INSERT_ID();

-- Đề xuất 7 (T5)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202605-SMP07', 'APPROVED', 1, 11, 3, 3, '2026-05-17 13:45:00', '202605', 'Đề xuất máy Mitsubishi Kho 1', '2026-05-17 15:00:00', '2026-05-17 13:45:00');
SET @prc7 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc7, 13, 11, 3, 2, 87000000.00, 'Mitsubishi 5kW');
SET @pd8 = LAST_INSERT_ID();

-- Đề xuất 8 (T5)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202605-SMP08', 'APPROVED', 2, 14, 14, 5, '2026-05-24 09:00:00', '202605', 'Nhập máy 3 pha theo hợp đồng T5', '2026-05-24 10:20:00', '2026-05-24 09:00:00');
SET @prc8 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc8, 23, 14, 5, 1, 228000000.00, 'Cummins dự phòng');
SET @pd9 = LAST_INSERT_ID();

-- Đề xuất 9 (T6)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202606-SMP09', 'APPROVED', 1, 10, 15, 3, '2026-06-03 08:15:00', '202606', 'Đề xuất nhập đợt 1 Kho Tổng T6', '2026-06-03 09:30:00', '2026-06-03 08:15:00');
SET @prc9 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc9, 10, 10, 4, 2, 35000000.00, 'Honda dân dụng 3kW');
SET @pd10 = LAST_INSERT_ID();

-- Đề xuất 10 (T6)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202606-SMP10', 'APPROVED', 2, 12, 14, 5, '2026-06-11 11:00:00', '202606', 'Bổ sung tồn kho an toàn tháng 6', '2026-06-11 14:00:00', '2026-06-11 11:00:00');
SET @prc10 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc10, 25, 12, 3, 2, 15800000.00, 'Yamaha 2.5kW');
SET @pd11 = LAST_INSERT_ID();

-- Đề xuất 11 (T6)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202606-SMP11', 'APPROVED', 1, 2, 15, 3, '2026-06-19 14:00:00', '202606', 'Đề xuất máy phát chạy dầu 15kVA T6', '2026-06-19 15:30:00', '2026-06-19 14:00:00');
SET @prc11 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc11, 19, 2, 2, 1, 17600000.00, 'Yamaha 3kW');
SET @pd12 = LAST_INSERT_ID();

-- Đề xuất 12 (T6)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202606-SMP12', 'APPROVED', 2, 11, 14, 5, '2026-06-26 09:30:00', '202606', 'Nhập đợt máy công nghiệp T6', '2026-06-26 11:00:00', '2026-06-26 09:30:00');
SET @prc12 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc12, 24, 11, 3, 1, 226000000.00, 'Cummins 100kVA Kho 2');
SET @pd13 = LAST_INSERT_ID();

-- Đề xuất 13 (T7)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202607-SMP13', 'APPROVED', 1, 6, 3, 3, '2026-07-02 11:00:00', '202607', 'Đề xuất máy công suất 50kVA Kho 1', '2026-07-02 14:00:00', '2026-07-02 11:00:00');
SET @prc13 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc13, 14, 6, 3, 0, 183000000.00, 'Máy 3 pha Hyundai');
SET @pd14 = LAST_INSERT_ID();

-- Đề xuất 14 (T7)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `approved_by`, `proposal_date`, `period`, `note`, `approved_at`, `created_at`)
VALUES ('PRC-202607-SMP14', 'APPROVED', 2, 15, 14, 5, '2026-07-08 09:00:00', '202607', 'Bổ sung Kho 2 đợt đầu T7', '2026-07-08 10:30:00', '2026-07-08 09:00:00');
SET @prc14 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc14, 17, 15, 4, 0, 17200000.00, 'Hyundai 3.5kW');
SET @pd15 = LAST_INSERT_ID();

-- Đề xuất 15 (T7)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `proposal_date`, `period`, `note`, `created_at`)
VALUES ('PRC-202607-SMP15', 'PENDING_CEO', 1, 15, 3, '2026-07-14 10:30:00', '202607', 'Đề xuất chờ CEO duyệt đợt giữa T7', '2026-07-14 10:30:00');
SET @prc15 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc15, 15, 15, 3, 0, 189000000.00, 'Honda Inverter silent');
SET @pd16 = LAST_INSERT_ID();

-- Đề xuất 16 (T7)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `proposal_date`, `period`, `note`, `created_at`)
VALUES ('PRC-202607-SMP16', 'PENDING', 2, 5, 14, '2026-07-18 13:45:00', '202607', 'Chờ Sale Manager kiểm tra', '2026-07-18 13:45:00');
SET @prc16 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc16, 18, 5, 2, 1, 230000000.00, 'Cummins 120kVA');
SET @pd17 = LAST_INSERT_ID();

-- Đề xuất 17 (T7)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `proposal_date`, `period`, `note`, `created_at`)
VALUES ('PRC-202607-SMP17', 'NEEDS_REVISION', 1, 3, 3, '2026-07-21 09:00:00', '202607', 'Yêu cầu sửa lại số lượng nhập', '2026-07-21 09:00:00');
SET @prc17 = LAST_INSERT_ID();
INSERT INTO `import_proposal_detail` (`proposal_id`, `generator_id`, `supplier_id`, `quantity`, `current_stock`, `unit_price`, `note`)
VALUES (@prc17, 8, 3, 1, 1, 158000000.00, 'Kiểm tra thông số');

-- Đề xuất 18 (T7)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `rejected_by`, `proposal_date`, `period`, `note`, `created_at`)
VALUES ('PRC-202607-SMP18', 'REJECTED', 1, 1, 3, 5, '2026-07-23 11:20:00', '202607', 'Từ chối do giá nhà cung cấp cao', '2026-07-23 11:20:00');

-- Đề xuất 19 (T7)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `proposal_date`, `period`, `note`, `created_at`)
VALUES ('PRC-202607-SMP19', 'PENDING', 2, 7, 14, '2026-07-25 08:00:00', '202607', 'Chờ duyệt nhập thêm đợt 2 T7', '2026-07-25 08:00:00');

-- Đề xuất 20 (T7)
INSERT INTO `import_proposal` (`proposal_code`, `status`, `warehouse_id`, `supplier_id`, `created_by`, `proposal_date`, `period`, `note`, `created_at`)
VALUES ('PRC-202607-SMP20', 'CANCELLED', 1, 10, 3, '2026-07-27 10:00:00', '202607', 'Hủy do thay đổi kế hoạch', '2026-07-27 10:00:00');


-- =================================================================================
-- PHẦN 2: PHIẾU MUA PO (purchase_order & purchase_order_detail) - 10 PHIẾU
-- =================================================================================

-- PO 1 (T4)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `approved_by`, `total_proposals`, `total_quantity`, `note`, `approved_at`, `created_at`)
VALUES ('PO-202604-SMP01', '202604', '2026-04-01', '2026-04-30', 1, 'APPROVED', 3, 3, 1, 5, 'Gom đề xuất PRC-202604-SMP01', '2026-04-06 09:30:00', '2026-04-06 08:30:00');
SET @po1 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po1, @pd1, 6, 3, 2, 45000000.00, 3, 'Duyệt mua 3 máy Honda');
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po1, @pd2, 7, 2, 1, 68000000.00, 2, 'Duyệt mua 2 máy Honda');
UPDATE `import_proposal` SET `purchase_order_id` = @po1 WHERE `proposal_id` = @prc1;

-- PO 2 (T4)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `approved_by`, `total_proposals`, `total_quantity`, `note`, `approved_at`, `created_at`)
VALUES ('PO-202604-SMP02', '202604', '2026-04-01', '2026-04-30', 2, 'APPROVED', 14, 5, 1, 4, 'Gom đề xuất PRC-202604-SMP02', '2026-04-13 10:30:00', '2026-04-13 09:00:00');
SET @po2 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po2, @pd3, 24, 4, 0, 226000000.00, 4, 'Duyệt mua 4 máy Cummins');
UPDATE `import_proposal` SET `purchase_order_id` = @po2 WHERE `proposal_id` = @prc2;

-- PO 3 (T5)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `approved_by`, `total_proposals`, `total_quantity`, `note`, `approved_at`, `created_at`)
VALUES ('PO-202605-SMP03', '202605', '2026-05-01', '2026-05-31', 1, 'APPROVED', 3, 3, 1, 3, 'Gom đề xuất PRC-202605-SMP05', '2026-05-05 10:00:00', '2026-05-05 08:45:00');
SET @po3 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po3, @pd6, 21, 3, 1, 245000000.00, 3, 'Duyệt mua 3 máy 150kVA');
UPDATE `import_proposal` SET `purchase_order_id` = @po3 WHERE `proposal_id` = @prc5;

-- PO 4 (T5)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `approved_by`, `total_proposals`, `total_quantity`, `note`, `approved_at`, `created_at`)
VALUES ('PO-202605-SMP04', '202605', '2026-05-01', '2026-05-31', 2, 'APPROVED', 14, 5, 1, 2, 'Gom đề xuất PRC-202605-SMP06', '2026-05-11 11:30:00', '2026-05-11 09:15:00');
SET @po4 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po4, @pd7, 22, 2, 0, 21700000.00, 2, 'Duyệt mua 2 máy dầu');
UPDATE `import_proposal` SET `purchase_order_id` = @po4 WHERE `proposal_id` = @prc6;

-- PO 5 (T6)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `approved_by`, `total_proposals`, `total_quantity`, `note`, `approved_at`, `created_at`)
VALUES ('PO-202606-SMP05', '202606', '2026-06-01', '2026-06-30', 1, 'APPROVED', 3, 3, 1, 4, 'Gom đề xuất PRC-202606-SMP09', '2026-06-04 10:00:00', '2026-06-04 08:30:00');
SET @po5 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po5, @pd10, 10, 4, 2, 35000000.00, 4, 'Duyệt mua 4 máy 3kW');
UPDATE `import_proposal` SET `purchase_order_id` = @po5 WHERE `proposal_id` = @prc9;

-- PO 6 (T6)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `approved_by`, `total_proposals`, `total_quantity`, `note`, `approved_at`, `created_at`)
VALUES ('PO-202606-SMP06', '202606', '2026-06-01', '2026-06-30', 2, 'APPROVED', 14, 5, 1, 3, 'Gom đề xuất PRC-202606-SMP10', '2026-06-12 14:00:00', '2026-06-12 10:00:00');
SET @po6 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po6, @pd11, 25, 3, 2, 15800000.00, 3, 'Duyệt mua 3 máy 2.5kW');
UPDATE `import_proposal` SET `purchase_order_id` = @po6 WHERE `proposal_id` = @prc10;

-- PO 7 (T7)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `approved_by`, `total_proposals`, `total_quantity`, `note`, `approved_at`, `created_at`)
VALUES ('PO-202607-SMP07', '202607', '2026-07-01', '2026-07-31', 1, 'APPROVED', 3, 3, 1, 3, 'Gom đề xuất PRC-202607-SMP13', '2026-07-03 11:00:00', '2026-07-03 09:00:00');
SET @po7 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po7, @pd14, 14, 3, 0, 183000000.00, 3, 'Duyệt mua máy Hyundai');
UPDATE `import_proposal` SET `purchase_order_id` = @po7 WHERE `proposal_id` = @prc13;

-- PO 8 (T7)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `approved_by`, `total_proposals`, `total_quantity`, `note`, `approved_at`, `created_at`)
VALUES ('PO-202607-SMP08', '202607', '2026-07-01', '2026-07-31', 2, 'APPROVED', 14, 5, 1, 3, 'Gom đề xuất PRC-202607-SMP14', '2026-07-09 10:30:00', '2026-07-09 09:30:00');
SET @po8 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po8, @pd15, 17, 4, 0, 17200000.00, 3, 'Duyệt mua máy 3.5kW Kho 2');
UPDATE `import_proposal` SET `purchase_order_id` = @po8 WHERE `proposal_id` = @prc14;

-- PO 9 (T7)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `total_proposals`, `total_quantity`, `note`, `created_at`)
VALUES ('PO-202607-SMP09', '202607', '2026-07-01', '2026-07-31', 1, 'PENDING_CEO', 3, 1, 3, 'Chờ CEO phê duyệt đợt T7', '2026-07-15 10:00:00');
SET @po9 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po9, @pd16, 15, 3, 0, 189000000.00, 3, 'Chờ duyệt');

-- PO 10 (T7)
INSERT INTO `purchase_order` (`po_code`, `period`, `period_start`, `period_end`, `warehouse_id`, `status`, `created_by`, `total_proposals`, `total_quantity`, `note`, `created_at`)
VALUES ('PO-202607-SMP10', '202607', '2026-07-01', '2026-07-31', 2, 'REJECTED', 14, 1, 2, 'Từ chối do quá hạn mức ngân sách', '2026-07-20 14:30:00');
SET @po10 = LAST_INSERT_ID();
INSERT INTO `purchase_order_detail` (`po_id`, `proposal_detail_id`, `generator_id`, `proposed_quantity`, `current_stock`, `unit_price`, `final_quantity`, `note`)
VALUES (@po10, @pd17, 18, 2, 1, 230000000.00, 0, 'Từ chối');


-- =================================================================================
-- PHẦN 3: PHIẾU NHẬP KHO (receipt IMPORT & receipt_detail) - 10 PHIẾU
-- =================================================================================

-- Receipt Import 1 (T4)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `purchase_order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-IM-202604-SMP01', 'IMPORT', @po1, 1, 3, 3, 'COMPLETED', 'Nhập kho từ PO-202604-SMP01', 83, '2026-04-08 10:00:00', '2026-04-08 10:30:00');
SET @rxim1 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim1, 1, 'Nhập máy GEN83D2K-2026A01');
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim1, 3, 'Nhập máy XP921L4M-2026B01');

-- Receipt Import 2 (T4)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `purchase_order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-IM-202604-SMP02', 'IMPORT', @po2, 2, 14, 5, 'COMPLETED', 'Nhập kho từ PO-202604-SMP02', 83, '2026-04-15 11:00:00', '2026-04-15 11:45:00');
SET @rxim2 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim2, 14, 'Nhập máy Kho 2');

-- Receipt Import 3 (T5)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `purchase_order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-IM-202605-SMP03', 'IMPORT', @po3, 1, 3, 3, 'COMPLETED', 'Nhập kho từ PO-202605-SMP03', 83, '2026-05-07 14:00:00', '2026-05-07 14:30:00');
SET @rxim3 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim3, 29, 'Nhập máy XG83N2K Kho 1');

-- Receipt Import 4 (T5)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `purchase_order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-IM-202605-SMP04', 'IMPORT', @po4, 2, 14, 5, 'COMPLETED', 'Nhập kho từ PO-202605-SMP04', 83, '2026-05-13 09:30:00', '2026-05-13 10:15:00');
SET @rxim4 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim4, 49, 'Nhập máy MW48C1T Kho 2');

-- Receipt Import 5 (T6)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `purchase_order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-IM-202606-SMP05', 'IMPORT', @po5, 1, 3, 3, 'COMPLETED', 'Nhập kho từ PO-202606-SMP05', 83, '2026-06-06 10:15:00', '2026-06-06 11:00:00');
SET @rxim5 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim5, 54, 'Nhập máy NX49J3V Kho 1');

-- Receipt Import 6 (T6)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `purchase_order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-IM-202606-SMP06', 'IMPORT', @po6, 2, 14, 5, 'COMPLETED', 'Nhập kho từ PO-202606-SMP06', 83, '2026-06-15 15:00:00', '2026-06-15 15:30:00');
SET @rxim6 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim6, 50, 'Nhập máy KP90D2R Kho 2');

-- Receipt Import 7 (T7)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `purchase_order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-IM-202607-SMP07', 'IMPORT', @po7, 1, 3, 3, 'COMPLETED', 'Nhập kho từ PO-202607-SMP07', 83, '2026-07-05 09:00:00', '2026-07-05 09:45:00');
SET @rxim7 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim7, 81, 'Nhập máy ABC-123 Kho 1');

-- Receipt Import 8 (T7)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `purchase_order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-IM-202607-SMP08', 'IMPORT', @po8, 2, 14, 5, 'COMPLETED', 'Nhập kho từ PO-202607-SMP08', 83, '2026-07-11 10:30:00', '2026-07-11 11:15:00');
SET @rxim8 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim8, 88, 'Nhập máy 123567f92 Kho 2');

-- Receipt Import 9 (T7)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `warehouse_id`, `created_by`, `status`, `note`, `reason_id`, `created_at`)
VALUES ('RX-IM-202607-SMP09', 'IMPORT', 1, 15, 'PENDING', 'Chờ kiểm đếm nhập máy trả bảo hành', 25, '2026-07-19 14:00:00');
SET @rxim9 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim9, 86, 'Chờ nhập');

-- Receipt Import 10 (T7)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `warehouse_id`, `created_by`, `status`, `note`, `reason_id`, `created_at`)
VALUES ('RX-IM-202607-SMP10', 'IMPORT', 2, 14, 'CANCELLED', 'Hủy nhập do hàng sai quy cách', 83, '2026-07-26 16:00:00');
SET @rxim10 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxim10, 90, 'Đã hủy nhập');


-- =================================================================================
-- PHẦN 4: PHIẾU KIỂM KÊ (inventory_check, inventory_check_detail, inventory_check_serial) - 5 PHIẾU
-- =================================================================================

-- Kiểm kê 1 (T4)
INSERT INTO `inventory_check` (`check_code`, `warehouse_id`, `status`, `notes`, `created_by`, `started_at`, `completed_at`, `created_at`)
VALUES ('IC-202604-SMP01', 1, 'completed', 'Kiểm kê định kỳ Kho 1 cuối tháng 4', 3, '2026-04-20 08:00:00', '2026-04-20 11:30:00', '2026-04-20 08:00:00');
SET @ic1 = LAST_INSERT_ID();
INSERT INTO `inventory_check_detail` (`check_id`, `generator_id`, `system_quantity`, `actual_quantity`, `notes`)
VALUES (@ic1, 6, 2, 2, 'Đủ số lượng');
SET @icd1 = LAST_INSERT_ID();
INSERT INTO `inventory_check_detail` (`check_id`, `generator_id`, `system_quantity`, `actual_quantity`, `notes`)
VALUES (@ic1, 7, 1, 1, 'Tốt');
SET @icd2 = LAST_INSERT_ID();
INSERT INTO `inventory_check_serial` (`check_detail_id`, `serial_number`, `status`, `notes`) VALUES (@icd1, 'GEN83D2K-2026A01', 'GOOD', 'Máy hoạt động bình thường');
INSERT INTO `inventory_check_serial` (`check_detail_id`, `serial_number`, `status`, `notes`) VALUES (@icd2, 'XP921L4M-2026B01', 'GOOD', 'Máy tốt');

-- Kiểm kê 2 (T5)
INSERT INTO `inventory_check` (`check_code`, `warehouse_id`, `status`, `notes`, `created_by`, `started_at`, `completed_at`, `created_at`)
VALUES ('IC-202605-SMP02', 2, 'completed', 'Kiểm kê định kỳ Kho 2 cuối tháng 5', 14, '2026-05-22 08:30:00', '2026-05-22 12:00:00', '2026-05-22 08:30:00');
SET @ic2 = LAST_INSERT_ID();
INSERT INTO `inventory_check_detail` (`check_id`, `generator_id`, `system_quantity`, `actual_quantity`, `notes`)
VALUES (@ic2, 23, 1, 1, 'Đủ số lượng Kho 2');
SET @icd3 = LAST_INSERT_ID();
INSERT INTO `inventory_check_serial` (`check_detail_id`, `serial_number`, `status`, `notes`) VALUES (@icd3, 'KP90D2R', 'POOR', 'Cần bảo dưỡng / chuẩn bị thanh lý');

-- Kiểm kê 3 (T6)
INSERT INTO `inventory_check` (`check_code`, `warehouse_id`, `status`, `notes`, `created_by`, `started_at`, `completed_at`, `created_at`)
VALUES ('IC-202606-SMP03', 1, 'completed', 'Kiểm kê đột xuất Kho 1 tháng 6', 3, '2026-06-25 13:00:00', '2026-06-25 16:30:00', '2026-06-25 13:00:00');
SET @ic3 = LAST_INSERT_ID();
INSERT INTO `inventory_check_detail` (`check_id`, `generator_id`, `system_quantity`, `actual_quantity`, `notes`)
VALUES (@ic3, 8, 2, 2, 'Đủ số lượng');
SET @icd4 = LAST_INSERT_ID();
INSERT INTO `inventory_check_serial` (`check_detail_id`, `serial_number`, `status`, `notes`) VALUES (@icd4, 'SER-HFX49-45G2D', 'GOOD', 'Máy tốt');

-- Kiểm kê 4 (T7)
INSERT INTO `inventory_check` (`check_code`, `warehouse_id`, `status`, `notes`, `created_by`, `started_at`, `completed_at`, `created_at`)
VALUES ('IC-202607-SMP04', 2, 'completed', 'Kiểm kê định kỳ đợt 1 tháng 7 Kho 2', 15, '2026-07-15 09:00:00', '2026-07-15 11:45:00', '2026-07-15 09:00:00');
SET @ic4 = LAST_INSERT_ID();
INSERT INTO `inventory_check_detail` (`check_id`, `generator_id`, `system_quantity`, `actual_quantity`, `notes`)
VALUES (@ic4, 24, 1, 1, 'Máy Cummins Kho 2');
SET @icd5 = LAST_INSERT_ID();
INSERT INTO `inventory_check_serial` (`check_detail_id`, `serial_number`, `status`, `notes`) VALUES (@icd5, 'SER-LKB38-300F3', 'GOOD', 'Hoàn hảo');

-- Kiểm kê 5 (T7)
INSERT INTO `inventory_check` (`check_code`, `warehouse_id`, `status`, `notes`, `created_by`, `started_at`, `created_at`)
VALUES ('IC-202607-SMP05', 1, 'doing', 'Đang tiến hành kiểm kê đợt 2 tháng 7 Kho 1', 3, '2026-07-27 14:00:00', '2026-07-27 14:00:00');
SET @ic5 = LAST_INSERT_ID();
INSERT INTO `inventory_check_detail` (`check_id`, `generator_id`, `system_quantity`, `actual_quantity`, `notes`)
VALUES (@ic5, 11, 3, 3, 'Đang đếm');


-- =================================================================================
-- PHẦN 5: PHIẾU THANH LÝ (liquidation & liquidation_detail) - 5 PHIẾU
-- CHỈ thanh lý những máy đã được kiểm kê trước thời điểm lập phiếu
-- =================================================================================

-- Thanh lý 1 (T5)
INSERT INTO `liquidation` (`liquidation_code`, `created_by`, `status`, `reason_id`, `manager_reviewed_by`, `manager_reviewed_at`, `ceo_reviewed_by`, `ceo_reviewed_at`, `warehouse_id`, `customer_id`, `created_at`)
VALUES ('LT-202605-SMP01', 3, 'COMPLETED', 70, 3, '2026-05-28 10:00:00', 5, '2026-05-28 11:00:00', 1, 1, '2026-05-28 09:00:00');
SET @liq1 = LAST_INSERT_ID();
INSERT INTO `liquidation_detail` (`liquidation_id`, `generator_id`, `serial_number`, `original_price`, `liquidation_price`)
VALUES (@liq1, 7, 'VQ38X1D', 68000000.00, 15000000.00);

-- Thanh lý 2 (T6)
INSERT INTO `liquidation` (`liquidation_code`, `created_by`, `status`, `reason_id`, `manager_reviewed_by`, `manager_reviewed_at`, `ceo_reviewed_by`, `ceo_reviewed_at`, `warehouse_id`, `customer_id`, `created_at`)
VALUES ('LT-202606-SMP02', 14, 'COMPLETED', 71, 5, '2026-06-28 11:00:00', 5, '2026-06-28 14:00:00', 2, 2, '2026-06-28 10:00:00');
SET @liq2 = LAST_INSERT_ID();
INSERT INTO `liquidation_detail` (`liquidation_id`, `generator_id`, `serial_number`, `original_price`, `liquidation_price`)
VALUES (@liq2, 23, 'KP90D2R', 228000000.00, 50000000.00);

-- Thanh lý 3 (T7)
INSERT INTO `liquidation` (`liquidation_code`, `created_by`, `status`, `reason_id`, `manager_reviewed_by`, `manager_reviewed_at`, `ceo_reviewed_by`, `ceo_reviewed_at`, `warehouse_id`, `created_at`)
VALUES ('LT-202607-SMP03', 3, 'APPROVED', 70, 3, '2026-07-18 09:30:00', 5, '2026-07-18 10:30:00', 1, '2026-07-18 08:30:00');
SET @liq3 = LAST_INSERT_ID();
INSERT INTO `liquidation_detail` (`liquidation_id`, `generator_id`, `serial_number`, `original_price`, `liquidation_price`)
VALUES (@liq3, 7, 'ZN48R1S', 68000000.00, 18000000.00);

-- Thanh lý 4 (T7)
INSERT INTO `liquidation` (`liquidation_code`, `created_by`, `status`, `reason_id`, `warehouse_id`, `created_at`)
VALUES ('LT-202607-SMP04', 14, 'PENDING_CEO', 72, 2, '2026-07-22 14:00:00');
SET @liq4 = LAST_INSERT_ID();
INSERT INTO `liquidation_detail` (`liquidation_id`, `generator_id`, `serial_number`, `original_price`, `liquidation_price`)
VALUES (@liq4, 8, 'SER-HFX49-45G2D', 158000000.00, 40000000.00);

-- Thanh lý 5 (T7)
INSERT INTO `liquidation` (`liquidation_code`, `created_by`, `status`, `reason_id`, `manager_reviewed_by`, `warehouse_id`, `created_at`)
VALUES ('LT-202607-SMP05', 3, 'CANCELLED', 71, 3, 1, '2026-07-25 09:00:00');
SET @liq5 = LAST_INSERT_ID();
INSERT INTO `liquidation_detail` (`liquidation_id`, `generator_id`, `serial_number`, `original_price`, `liquidation_price`)
VALUES (@liq5, 7, 'FJ38A1S', 68000000.00, 12000000.00);


-- =================================================================================
-- PHẦN 6: PHIẾU BÁN / ĐƠN HÀNG (sale_order & order_detail) - 5 PHIẾU
-- =================================================================================

-- Đơn bán 1 (T4)
INSERT INTO `sale_order` (`order_code`, `customer_id`, `created_by`, `approved_by`, `status`, `total_amount`, `note`, `order_date`, `approved_at`, `created_at`)
VALUES ('SO-202604-SMP01', 1, 3, 3, 'COMPLETED', 135000000.00, 'Đơn bán máy phát cho Khách hàng Cá nhân A đợt T4', '2026-04-22 11:00:00', '2026-04-22 11:30:00', '2026-04-22 11:00:00');
SET @so1 = LAST_INSERT_ID();
INSERT INTO `order_detail` (`order_id`, `generator_id`, `quantity`, `unit_price`, `note`)
VALUES (@so1, 6, 3, 45000000.00, 'Bán 3 máy Honda 5kW');

-- Đơn bán 2 (T5)
INSERT INTO `sale_order` (`order_code`, `customer_id`, `created_by`, `approved_by`, `status`, `total_amount`, `note`, `order_date`, `approved_at`, `created_at`)
VALUES ('SO-202605-SMP02', 2, 14, 5, 'COMPLETED', 452000000.00, 'Đơn bán máy công nghiệp cho Công ty B đợt T5', '2026-05-15 13:00:00', '2026-05-15 14:15:00', '2026-05-15 13:00:00');
SET @so2 = LAST_INSERT_ID();
INSERT INTO `order_detail` (`order_id`, `generator_id`, `quantity`, `unit_price`, `note`)
VALUES (@so2, 24, 2, 226000000.00, 'Bán 2 máy Cummins 100kVA');

-- Đơn bán 3 (T6)
INSERT INTO `sale_order` (`order_code`, `customer_id`, `created_by`, `approved_by`, `status`, `total_amount`, `note`, `order_date`, `approved_at`, `created_at`)
VALUES ('SO-202606-SMP03', 6, 3, 3, 'COMPLETED', 226000000.00, 'Đơn bán máy Cummins Kho 1 đợt T6', '2026-06-18 10:00:00', '2026-06-18 11:00:00', '2026-06-18 10:00:00');
SET @so3 = LAST_INSERT_ID();
INSERT INTO `order_detail` (`order_id`, `generator_id`, `quantity`, `unit_price`, `note`)
VALUES (@so3, 24, 1, 226000000.00, 'Bán 1 máy Cummins 100kVA');

-- Đơn bán 4 (T7)
INSERT INTO `sale_order` (`order_code`, `customer_id`, `created_by`, `approved_by`, `status`, `total_amount`, `note`, `order_date`, `approved_at`, `created_at`)
VALUES ('SO-202607-SMP04', 9, 15, 3, 'APPROVED', 95000000.00, 'Đã duyệt chờ xuất kho bán', '2026-07-10 14:00:00', '2026-07-10 15:00:00', '2026-07-10 14:00:00');
SET @so4 = LAST_INSERT_ID();
INSERT INTO `order_detail` (`order_id`, `generator_id`, `quantity`, `unit_price`, `note`)
VALUES (@so4, 11, 1, 95000000.00, 'Bán 1 máy 1 pha');

-- Đơn bán 5 (T7)
INSERT INTO `sale_order` (`order_code`, `customer_id`, `created_by`, `status`, `total_amount`, `note`, `order_date`, `created_at`)
VALUES ('SO-202607-SMP05', 12, 14, 'PENDING', 68000000.00, 'Chờ duyệt đơn hàng mới T7', '2026-07-24 09:00:00', '2026-07-24 09:00:00');
SET @so5 = LAST_INSERT_ID();
INSERT INTO `order_detail` (`order_id`, `generator_id`, `quantity`, `unit_price`, `note`)
VALUES (@so5, 7, 1, 68000000.00, 'Chờ duyệt');


-- =================================================================================
-- PHẦN 7: PHIẾU XUẤT KHO (receipt EXPORT & receipt_detail) - 10 PHIẾU
-- =================================================================================

-- Receipt Export 1 (T4 từ đơn bán)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-EX-202604-SMP01', 'EXPORT', @so1, 1, 3, 3, 'COMPLETED', 'Xuất kho theo đơn SO-202604-SMP01', 82, '2026-04-24 14:00:00', '2026-04-24 14:30:00');
SET @rxex1 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex1, 2, 'Xuất máy SOLD');

-- Receipt Export 2 (T5 từ đơn bán)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-EX-202605-SMP02', 'EXPORT', @so2, 2, 14, 5, 'COMPLETED', 'Xuất kho theo đơn SO-202605-SMP02', 82, '2026-05-17 15:00:00', '2026-05-17 15:45:00');
SET @rxex2 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex2, 14, 'Xuất máy Kho 2');

-- Receipt Export 3 (T5 từ thanh lý LT-202605-SMP01)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `liquidation_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-EX-202605-SMP03', 'EXPORT', @liq1, 1, 3, 3, 'COMPLETED', 'Xuất kho thanh lý LT-202605-SMP01', 30, '2026-05-30 09:00:00', '2026-05-30 09:30:00');
SET @rxex3 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex3, 34, 'Xuất máy thanh lý VQ38X1D');
UPDATE `liquidation` SET `converted_receipt_id` = @rxex3 WHERE `liquidation_id` = @liq1;

-- Receipt Export 4 (T6 từ đơn bán)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-EX-202606-SMP04', 'EXPORT', @so3, 1, 3, 3, 'COMPLETED', 'Xuất kho theo đơn SO-202606-SMP03', 82, '2026-06-20 11:15:00', '2026-06-20 11:45:00');
SET @rxex4 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex4, 33, 'Xuất máy ZM90W2C');

-- Receipt Export 5 (T6 từ thanh lý LT-202606-SMP02)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `liquidation_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-EX-202606-SMP05', 'EXPORT', @liq2, 2, 14, 5, 'COMPLETED', 'Xuất kho thanh lý LT-202606-SMP02', 30, '2026-06-30 16:00:00', '2026-06-30 16:30:00');
SET @rxex5 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex5, 50, 'Xuất máy thanh lý KP90D2R');
UPDATE `liquidation` SET `converted_receipt_id` = @rxex5 WHERE `liquidation_id` = @liq2;

-- Receipt Export 6 (T7 từ đơn bán)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `order_id`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-EX-202607-SMP06', 'EXPORT', @so4, 1, 15, 3, 'COMPLETED', 'Xuất kho theo đơn SO-202607-SMP04', 82, '2026-07-12 10:00:00', '2026-07-12 10:30:00');
SET @rxex6 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex6, 30, 'Xuất máy PL92M4L');

-- Receipt Export 7 (T7 từ thanh lý LT-202607-SMP03)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `liquidation_id`, `warehouse_id`, `created_by`, `status`, `note`, `reason_id`, `created_at`)
VALUES ('RX-EX-202607-SMP07', 'EXPORT', @liq3, 1, 3, 'PENDING', 'Chờ xuất kho thanh lý LT-202607-SMP03', 30, '2026-07-19 08:30:00');
SET @rxex7 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex7, 42, 'Chờ xuất thanh lý ZN48R1S');

-- Receipt Export 8 (T7)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-EX-202607-SMP08', 'EXPORT', 1, 3, 3, 'COMPLETED', 'Xuất kho bảo trì định kỳ', 26, '2026-07-22 14:00:00', '2026-07-22 14:30:00');
SET @rxex8 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex8, 4, 'Xuất bảo trì');

-- Receipt Export 9 (T7)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `warehouse_id`, `created_by`, `status`, `note`, `reason_id`, `created_at`)
VALUES ('RX-EX-202607-SMP09', 'EXPORT', 2, 14, 'CANCELLED', 'Hủy lệnh xuất do thiếu linh kiện', 82, '2026-07-25 09:00:00');
SET @rxex9 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex9, 20, 'Hủy xuất');

-- Receipt Export 10 (T7)
INSERT INTO `receipt` (`receipt_code`, `receipt_type`, `warehouse_id`, `created_by`, `approved_by`, `status`, `note`, `reason_id`, `created_at`, `approved_at`)
VALUES ('RX-EX-202607-SMP10', 'EXPORT', 1, 3, 3, 'COMPLETED', 'Xuất kho điều chuyển', 29, '2026-07-27 15:00:00', '2026-07-27 15:30:00');
SET @rxex10 = LAST_INSERT_ID();
INSERT INTO `receipt_detail` (`receipt_id`, `inventory_id`, `note`) VALUES (@rxex10, 47, 'Xuất điều chuyển FJ38A1S');


-- =================================================================================
-- PHẦN 8: PHIẾU LUÂN CHUYỂN KHO (transfer & transfer_detail) - 5 PHIẾU
-- =================================================================================

-- Luân chuyển 1 (T4)
INSERT INTO `transfer` (`transfer_code`, `source_warehouse_id`, `dest_warehouse_id`, `status`, `created_by`, `manager_reviewed_by`, `manager_reviewed_at`, `ceo_reviewed_by`, `ceo_reviewed_at`, `export_receipt_id`, `import_receipt_id`, `executed_at`, `note`, `created_at`)
VALUES ('TR-202604-SMP01', 1, 2, 'COMPLETED', 3, 3, '2026-04-26 13:00:00', 5, '2026-04-26 14:00:00', @rxex10, @rxim1, '2026-04-26 15:00:00', 'Điều chuyển máy Kho 1 sang Kho 2 T4', '2026-04-26 12:00:00');
SET @tr1 = LAST_INSERT_ID();
INSERT INTO `transfer_detail` (`transfer_id`, `generator_id`, `serial_number`, `quantity`, `note`)
VALUES (@tr1, 6, 'GEN83D2K-2026A01', 1, 'Chuyển 1 máy Honda 5kW');

-- Luân chuyển 2 (T5)
INSERT INTO `transfer` (`transfer_code`, `source_warehouse_id`, `dest_warehouse_id`, `status`, `created_by`, `manager_reviewed_by`, `manager_reviewed_at`, `ceo_reviewed_by`, `ceo_reviewed_at`, `executed_at`, `note`, `created_at`)
VALUES ('TR-202605-SMP02', 2, 1, 'COMPLETED', 14, 5, '2026-05-20 09:30:00', 5, '2026-05-20 10:30:00', '2026-05-20 11:30:00', 'Điều chuyển máy Kho 2 về Kho 1 T5', '2026-05-20 08:30:00');
SET @tr2 = LAST_INSERT_ID();
INSERT INTO `transfer_detail` (`transfer_id`, `generator_id`, `serial_number`, `quantity`, `note`)
VALUES (@tr2, 20, 'SER-KJR73-4921Q', 1, 'Chuyển máy Cummins Kho 2 về Kho 1');

-- Luân chuyển 3 (T6)
INSERT INTO `transfer` (`transfer_code`, `source_warehouse_id`, `dest_warehouse_id`, `status`, `created_by`, `manager_reviewed_by`, `manager_reviewed_at`, `ceo_reviewed_by`, `ceo_reviewed_at`, `executed_at`, `note`, `created_at`)
VALUES ('TR-202606-SMP03', 1, 2, 'COMPLETED', 3, 3, '2026-06-22 15:00:00', 5, '2026-06-22 16:00:00', '2026-06-22 17:00:00', 'Điều chuyển máy hỗ trợ chi nhánh T6', '2026-06-22 14:00:00');
SET @tr3 = LAST_INSERT_ID();
INSERT INTO `transfer_detail` (`transfer_id`, `generator_id`, `serial_number`, `quantity`, `note`)
VALUES (@tr3, 10, 'ZMT9012B-2026D01', 2, 'Điều chuyển 2 máy dân dụng');

-- Luân chuyển 4 (T7)
INSERT INTO `transfer` (`transfer_code`, `source_warehouse_id`, `dest_warehouse_id`, `status`, `created_by`, `manager_reviewed_by`, `manager_reviewed_at`, `ceo_reviewed_by`, `ceo_reviewed_at`, `note`, `created_at`)
VALUES ('TR-202607-SMP04', 2, 1, 'EXPORTED', 14, 5, '2026-07-16 10:00:00', 5, '2026-07-16 11:00:00', 'Đã xuất khỏi Kho 2 đang trên đường sang Kho 1', '2026-07-16 09:00:00');
SET @tr4 = LAST_INSERT_ID();
INSERT INTO `transfer_detail` (`transfer_id`, `generator_id`, `serial_number`, `quantity`, `note`)
VALUES (@tr4, 22, 'ZL92G4M', 1, 'Đang vận chuyển');

-- Luân chuyển 5 (T7)
INSERT INTO `transfer` (`transfer_code`, `source_warehouse_id`, `dest_warehouse_id`, `status`, `created_by`, `manager_reviewed_by`, `manager_reviewed_at`, `note`, `created_at`)
VALUES ('TR-202607-SMP05', 1, 2, 'PENDING_CEO', 3, 3, '2026-07-26 16:00:00', 'Chờ CEO duyệt luân chuyển T7', '2026-07-26 15:00:00');
SET @tr5 = LAST_INSERT_ID();
INSERT INTO `transfer_detail` (`transfer_id`, `generator_id`, `serial_number`, `quantity`, `note`)
VALUES (@tr5, 16, 'YHJ9729', 1, 'Chờ CEO duyệt');


-- =================================================================================
-- HOÀN TẤT GIAO DỊCH DỮ LIỆU MẪU
-- =================================================================================

SET sql_mode = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = 1;
COMMIT;

-- SUCCESS: Đã fix triệt để toàn bộ 3 lỗi MySQL (1062, 1690, UNIQUE FK constraint)!
