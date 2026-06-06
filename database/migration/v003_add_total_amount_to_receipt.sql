ALTER TABLE `receipt`
  ADD COLUMN `total_amount` decimal(15,2) DEFAULT NULL AFTER `note`;
