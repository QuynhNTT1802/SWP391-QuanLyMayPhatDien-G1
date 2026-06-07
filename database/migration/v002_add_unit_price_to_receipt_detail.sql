ALTER TABLE `receipt_detail`
  ADD COLUMN `unit_price` decimal(15,2) DEFAULT NULL AFTER `quantity`;
