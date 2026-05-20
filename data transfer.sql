-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: warehousedb
-- ------------------------------------------------------
-- Server version	8.0.46

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

-- ============================================================
-- PHẦN 1: XOÁ CÁC BẢNG ROLE-PROFILE KHÔNG CÒN DÙNG
-- ============================================================

DROP TABLE IF EXISTS `accountant`;
DROP TABLE IF EXISTS `admin`;
DROP TABLE IF EXISTS `customer`;
DROP TABLE IF EXISTS `driver`;
DROP TABLE IF EXISTS `sales_staff`;
DROP TABLE IF EXISTS `technician`;
DROP TABLE IF EXISTS `warehouse_manager`;
DROP TABLE IF EXISTS `warehouse_staff`;

-- ============================================================
-- PHẦN 2: XOÁ BẢNG NGHIỆP VỤ (để chạy lại được)
-- ============================================================

DROP TABLE IF EXISTS `stock_card`;
DROP TABLE IF EXISTS `inventory`;
DROP TABLE IF EXISTS `receipt_detail`;
DROP TABLE IF EXISTS `receipt`;
DROP TABLE IF EXISTS `order_detail`;
DROP TABLE IF EXISTS `sale_order`;
DROP TABLE IF EXISTS `generator`;
DROP TABLE IF EXISTS `warehouse`;

-- ============================================================
-- PHẦN 3: BẢNG NỀN TẢNG
-- ============================================================

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `username` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_updated_by` (`updated_by`),
  CONSTRAINT `fk_user_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_user_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES
(1, N'Nguyễn Văn A',  'vana',  '',                                     'vana@gmail.com',            '0944727281', N'Hà Nội',         'active', '2026-05-16 18:57:20', '2026-05-18 14:37:11', NULL, NULL),
(2, N'Trần Thị B',    'thib',  '123',                                   'thib@gmail.com',            '08467237727', N'Hà Nội',        'active', '2026-05-16 18:57:20', '2026-05-18 14:58:03', NULL, NULL),
(3, 'Admin',          'admin', 'admin123',                              'admin@warehouse.com',       '0846723771',  '30',              'active', '2026-05-16 18:57:20', '2026-05-18 14:39:43', NULL, NULL),
(4, N'Nguyễn Văn Nam','salestaff1',   '123',                            'salestaff1@warehouse.com',  '0912345678',  N'Hà Nội',        'active', '2026-05-21 08:00:00', '2026-05-21 08:00:00', 3, NULL),
(5, N'Trần Thị Hương','salemanager1', '123',                            'salemanager1@warehouse.com','0912345679',  N'Hà Nội',        'active', '2026-05-21 08:00:00', '2026-05-21 08:00:00', 3, NULL),
(6, N'Lê Văn Cường',  'warehousestaff1','123',                          'warehousestaff1@warehouse.com','0912345680',N'Hà Nội',        'active', '2026-05-21 08:00:00', '2026-05-21 08:00:00', 3, NULL),
(7, N'Khánh Nguyễn Văn','vanb','$2a$10$QbvQzIVNH/osQwDyFc6x3.AzYpVtYgyn6ADGSjP.DiGqKnF4eCJbq','vankhanhak54@gmail.com','0846723779', N'Hà Nội',        'active', '2026-05-18 14:20:02', '2026-05-18 14:20:01', 1, NULL),
(8, N'Phạm Minh Tuấn', 'warehousemanager1','123',                       'warehousemanager1@warehouse.com','0912345681',N'Hồ Chí Minh',   'active', '2026-05-21 08:00:00', '2026-05-21 08:00:00', 3, NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `roles` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES
(1,  'admin',              N'Quản trị hệ thống',                            'active', '2026-05-15 16:43:03', '2026-05-18 13:44:28'),
(2,  'warehouse_manager',  N'Quản lý kho - Duyệt phiếu xuất/nhập',          'active', '2026-05-15 16:43:03', '2026-05-21 08:00:00'),
(3,  'warehouse_staff',    N'Nhân viên kho - Tạo phiếu, quét serial',       'active', '2026-05-15 16:43:03', '2026-05-21 08:00:00'),
(5,  'sales_staff',        N'Nhân viên kinh doanh - Tạo đơn hàng',          'active', '2026-05-15 16:43:03', '2026-05-21 08:00:00'),
(10, 'sale_manager',       N'Trưởng phòng kinh doanh - Duyệt đơn hàng',     'active', '2026-05-21 00:00:00', '2026-05-21 00:00:00');
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_roles`
--

DROP TABLE IF EXISTS `user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_roles` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `idx_ur_role` (`role_id`),
  CONSTRAINT `fk_ur_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ur_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_roles`
--

LOCK TABLES `user_roles` WRITE;
/*!40000 ALTER TABLE `user_roles` DISABLE KEYS */;
INSERT INTO `user_roles` VALUES
(3, 1),    -- admin           -> Admin
(4, 5),    -- salestaff1      -> Nhan vien kinh doanh
(5, 10),   -- salemanager1    -> Truong phong kinh doanh
(6, 3),    -- warehousestaff1 -> Nhan vien kho
(8, 2);    -- warehousemanager1 -> Quan ly kho
/*!40000 ALTER TABLE `user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permissions`
--

DROP TABLE IF EXISTS `permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permissions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `resource` varchar(100) NOT NULL,
  `action` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resource_action` (`resource`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=107 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permissions`
--

LOCK TABLES `permissions` WRITE;
/*!40000 ALTER TABLE `permissions` DISABLE KEYS */;
INSERT INTO `permissions` VALUES
(1,'users','view','Xem danh sach nguoi dung'),
(2,'users','create','Them nguoi dung moi'),
(3,'users','update','Cap nhat thong tin nguoi dung'),
(4,'users','deactivate','Vo hieu hoa nguoi dung'),
(5,'roles','view','Xem danh sach vai tro'),
(6,'roles','create','Them vai tro moi'),
(7,'roles','update','Cap nhat vai tro'),
(8,'roles','deactivate','Vo hieu hoa vai tro'),
(9,'roles','edit_permissions','Chinh sua quyen cua vai tro'),
(10,'generators','view','Xem danh sach may phat dien'),
(11,'generators','create','Them may phat dien moi'),
(12,'generators','update','Cap nhat thong tin may'),
(22,'inventory','view','Xem ton kho'),
(24,'inventory','adjust','Dieu chinh ton kho'),
(25,'warehouses','view','Xem thong tin kho'),
(26,'warehouses','create','Them kho moi'),
(27,'warehouses','update','Cap nhat thong tin kho'),
(45,'orders','view','Xem don hang'),
(46,'orders','create','Tao don hang'),
(47,'orders','update','Cap nhat don hang'),
(48,'orders','cancel','Huy don hang'),
(100,'orders','approve','Duyet don hang (sale_manager)'),
(101,'receipts','view','Xem phieu xuat/nhap kho'),
(102,'receipts','create','Tao phieu xuat/nhap kho'),
(103,'receipts','approve','Duyet phieu xuat/nhap kho (warehouse_manager)'),
(104,'stock_card','view','Xem the kho'),
(65,'reports','view','Xem bao cao'),
(66,'reports','export','Xuat bao cao'),
(91,'dashboard','view','Xem dashboard'),
(95,'profile','view','Xem ho so ca nhan'),
(96,'profile','edit','Sua ho so ca nhan'),
(97,'password','change','Doi mat khau'),
(98,'forgot_pw','process','Xu ly yeu cau reset mat khau'),
(105,'orders','reject','Tu choi don hang (sale_manager)'),
(106,'receipts','reject','Tu choi phieu xuat/nhap kho (warehouse_manager)');
/*!40000 ALTER TABLE `permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permissions`
--

DROP TABLE IF EXISTS `role_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permissions` (
  `role_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `idx_rp_permission` (`permission_id`),
  CONSTRAINT `fk_rp_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permissions`
--

LOCK TABLES `role_permissions` WRITE;
/*!40000 ALTER TABLE `role_permissions` DISABLE KEYS */;
INSERT INTO `role_permissions` VALUES
-- admin (1): tat ca quyen
(1,1),(1,2),(1,3),(1,4),
(1,5),(1,6),(1,7),(1,8),(1,9),
(1,10),(1,11),(1,12),
(1,22),(1,24),
(1,25),(1,26),(1,27),
(1,45),(1,46),(1,47),(1,48),(1,100),(1,105),
(1,65),(1,66),
(1,91),(1,95),(1,96),(1,97),(1,98),
(1,101),(1,102),(1,103),(1,106),
(1,104),
-- warehouse_manager (2): quan ly kho
(2,10),(2,22),(2,24),(2,25),(2,26),(2,27),
(2,45),
(2,65),(2,66),
(2,91),(2,95),(2,96),(2,97),
(2,101),(2,102),(2,103),(2,106),
(2,104),
-- warehouse_staff (3): nhan vien kho
(3,10),(3,22),(3,25),
(3,45),
(3,91),(3,95),(3,96),(3,97),
(3,101),(3,102),
-- sales_staff (5): nhan vien kinh doanh
(5,10),
(5,45),(5,46),(5,47),
(5,91),(5,95),(5,96),(5,97),
-- sale_manager (10): truong phong kinh doanh
(10,10),
(10,45),(10,46),(10,47),(10,48),(10,100),(10,105),
(10,65),
(10,91),(10,95),(10,96),(10,97);
/*!40000 ALTER TABLE `role_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_permissions`
--

DROP TABLE IF EXISTS `user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_permissions` (
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  `type` enum('GRANT','DENY') NOT NULL,
  PRIMARY KEY (`user_id`,`permission_id`),
  KEY `idx_up_permission` (`permission_id`),
  CONSTRAINT `fk_up_permission` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_up_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permissions`
--

LOCK TABLES `user_permissions` WRITE;
/*!40000 ALTER TABLE `user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_request`
--

DROP TABLE IF EXISTS `password_reset_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_request` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `status` varchar(20) DEFAULT 'pending',
  `processed_by` int DEFAULT NULL,
  `new_password` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `processed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_password_reset_user_idx` (`user_id`),
  KEY `fk_password_reset_processed_by_idx` (`processed_by`),
  CONSTRAINT `fk_password_reset_processed_by` FOREIGN KEY (`processed_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_password_reset_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_request`
--

LOCK TABLES `password_reset_request` WRITE;
/*!40000 ALTER TABLE `password_reset_request` DISABLE KEYS */;
INSERT INTO `password_reset_request` VALUES
(1,1,'','approved',3,'1234','2026-05-16 18:57:20','2026-05-16 19:47:55'),
(2,2,'','approved',3,'12345','2026-05-16 18:57:20','2026-05-16 19:52:11'),
(3,1,N'Đã cấp lại','approved',3,'abc123','2026-05-16 18:57:20','2026-05-16 18:57:20'),
(4,1,N'ád','approved',3,'123','2026-05-17 15:46:23','2026-05-17 15:46:42'),
(5,2,'','approved',3,'123','2026-05-17 15:47:27','2026-05-17 15:47:37');
/*!40000 ALTER TABLE `password_reset_request` ENABLE KEYS */;
UNLOCK TABLES;

-- ============================================================
-- PHẦN 4: BẢNG NGHIỆP VỤ
-- ============================================================

--
-- Table structure for table `generator` -- May phat dien
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generator` (
  `generator_id` int NOT NULL AUTO_INCREMENT,
  `model` varchar(100) NOT NULL,
  `brand` varchar(100) DEFAULT NULL,
  `power_rating` decimal(10,2) DEFAULT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `description` text,
  `status` varchar(20) NOT NULL DEFAULT 'available',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`generator_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `generator` WRITE;
/*!40000 ALTER TABLE `generator` DISABLE KEYS */;
INSERT INTO `generator` VALUES
(1, 'EG4500CX',   'Honda',      4.50,  25000000.00, N'Máy phát điện Honda 4.5kVA, chạy xăng, 1 pha',          'available', '2026-05-20 08:00:00', '2026-05-20 08:00:00'),
(2, 'EF6000',     'Yamaha',     6.00,  35000000.00, N'Máy phát điện Yamaha 6.0kVA, chạy xăng, 1 pha',           'available', '2026-05-20 08:00:00', '2026-05-20 08:00:00'),
(3, 'DHY8000',    'Hyundai',    8.00,  48000000.00, N'Máy phát điện Hyundai 8.0kVA, chạy dầu diesel, 3 pha',     'available', '2026-05-20 08:00:00', '2026-05-20 08:00:00'),
(4, 'C10D5',      'Cummins',   10.00,  85000000.00, N'Máy phát điện Cummins 10kVA, chạy dầu diesel, 3 pha',       'available', '2026-05-20 08:00:00', '2026-05-20 08:00:00'),
(5, 'MGP-15',     'Mitsubishi',15.00, 120000000.00, N'Máy phát điện Mitsubishi 15kVA, chạy dầu diesel, 3 pha',    'available', '2026-05-20 08:00:00', '2026-05-20 08:00:00');
/*!40000 ALTER TABLE `generator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouse` -- Kho hang
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `warehouse` (
  `warehouse_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `address` text,
  `description` text,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`warehouse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `warehouse` WRITE;
/*!40000 ALTER TABLE `warehouse` DISABLE KEYS */;
INSERT INTO `warehouse` VALUES
(1, N'Kho Hà Nội',       N'123 Nguyễn Trãi, Thanh Xuân, Hà Nội',         N'Kho chính miền Bắc',         'active', '2026-05-20 08:00:00', '2026-05-20 08:00:00'),
(2, N'Kho Hồ Chí Minh',  N'456 Lê Lợi, Quận 1, TP. Hồ Chí Minh',         N'Kho chính miền Nam',         'active', '2026-05-20 08:00:00', '2026-05-20 08:00:00');
/*!40000 ALTER TABLE `warehouse` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_order` -- Don hang
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `order_code` varchar(50) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_phone` varchar(45) DEFAULT NULL,
  `customer_email` varchar(100) DEFAULT NULL,
  `customer_address` text,
  `customer_tax_code` varchar(45) DEFAULT NULL,
  `customer_type` varchar(45) DEFAULT 'individual',
  `customer_company_name` varchar(255) DEFAULT NULL,
  `customer_note` text,
  `created_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `total_amount` decimal(15,2) DEFAULT NULL,
  `note` text,
  `order_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `approved_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_code` (`order_code`),
  KEY `idx_order_created` (`created_by`),
  KEY `idx_order_approved` (`approved_by`),
  KEY `idx_order_status` (`status`),
  CONSTRAINT `fk_order_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_order_approved` FOREIGN KEY (`approved_by`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `sale_order` WRITE;
/*!40000 ALTER TABLE `sale_order` DISABLE KEYS */;
INSERT INTO `sale_order` VALUES
(1, 'SO-20260521-001',
 N'Công ty TNHH Xây Dựng ABC', '0988123456', 'abc@xaydungabc.com', N'12 Trần Duy Hưng, Cầu Giấy, Hà Nội',
 '0101234567', 'company', N'Công ty TNHH Xây Dựng ABC', N'Khách hàng thân thiết, đã mua 3 lần',
 4, NULL,
 'PENDING', 85000000.00, N'Đơn hàng gấp, yêu cầu giao trong tuần',
 '2026-05-21 09:00:00', NULL, '2026-05-21 09:00:00', '2026-05-21 09:00:00'),
(2, 'SO-20260521-002',
 N'Công ty CP Điện Máy XYZ', '0977123456', 'xyz@dienmayxyz.com', N'56 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh',
 '0201234568', 'company', N'Công ty CP Điện Máy XYZ', NULL,
 4, 5,
 'APPROVED', 96000000.00, NULL,
 '2026-05-21 10:00:00', '2026-05-21 10:30:00', '2026-05-21 10:00:00', '2026-05-21 10:30:00');
/*!40000 ALTER TABLE `sale_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail` -- Chi tiet don hang
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_detail` (
  `order_detail_id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `note` text,
  PRIMARY KEY (`order_detail_id`),
  KEY `idx_od_order` (`order_id`),
  KEY `idx_od_generator` (`generator_id`),
  CONSTRAINT `fk_od_order` FOREIGN KEY (`order_id`) REFERENCES `sale_order` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_od_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`generator_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES
(1, 1, 1, 2, 25000000.00, NULL),
(2, 1, 2, 1, 35000000.00, N'Yêu cầu đời mới nhất'),
(3, 2, 3, 2, 48000000.00, NULL);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipt` -- Phieu xuat/nhap kho
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipt` (
  `receipt_id` int NOT NULL AUTO_INCREMENT,
  `receipt_code` varchar(50) NOT NULL,
  `receipt_type` enum('IMPORT','EXPORT') NOT NULL,
  `order_id` int DEFAULT NULL,
  `warehouse_id` int NOT NULL,
  `created_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `status` enum('PENDING_RECONCILIATION','COMPLETED','CANCELLED') NOT NULL DEFAULT 'PENDING_RECONCILIATION',
  `note` text,
  `approved_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`receipt_id`),
  UNIQUE KEY `uk_receipt_code` (`receipt_code`),
  KEY `idx_receipt_order` (`order_id`),
  KEY `idx_receipt_warehouse` (`warehouse_id`),
  KEY `idx_receipt_created` (`created_by`),
  KEY `idx_receipt_approved` (`approved_by`),
  KEY `idx_receipt_status` (`status`),
  CONSTRAINT `fk_receipt_order` FOREIGN KEY (`order_id`) REFERENCES `sale_order` (`order_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_receipt_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_receipt_approved` FOREIGN KEY (`approved_by`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `receipt` WRITE;
/*!40000 ALTER TABLE `receipt` DISABLE KEYS */;
INSERT INTO `receipt` VALUES
(1, 'RX-20260521-001', 'EXPORT', 2, 1, 6, NULL,
 'PENDING_RECONCILIATION',
 N'Xuất kho 2 máy Hyundai DHY8000 theo đơn hàng SO-20260521-002. Đã quét serial.',
 NULL, '2026-05-21 11:00:00', '2026-05-21 11:00:00');
/*!40000 ALTER TABLE `receipt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipt_detail` -- Chi tiet phieu (Serial quet)
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipt_detail` (
  `receipt_detail_id` int NOT NULL AUTO_INCREMENT,
  `receipt_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `serial_number` varchar(100) NOT NULL,
  `quantity` int NOT NULL DEFAULT 1,
  `note` text,
  PRIMARY KEY (`receipt_detail_id`),
  KEY `idx_rd_receipt` (`receipt_id`),
  KEY `idx_rd_generator` (`generator_id`),
  UNIQUE KEY `uk_serial_receipt` (`serial_number`,`receipt_id`),
  CONSTRAINT `fk_rd_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `receipt` (`receipt_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rd_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`generator_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `receipt_detail` WRITE;
/*!40000 ALTER TABLE `receipt_detail` DISABLE KEYS */;
INSERT INTO `receipt_detail` VALUES
(1, 1, 3, 'HYU-DHY8000-SN001', 1, N'Máy mới 100%, tem nguyên vẹn'),
(2, 1, 3, 'HYU-DHY8000-SN002', 1, N'Máy mới 100%, tem nguyên vẹn');
/*!40000 ALTER TABLE `receipt_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory` -- Ton kho
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `inventory_id` int NOT NULL AUTO_INCREMENT,
  `warehouse_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `quantity` int NOT NULL DEFAULT 0,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_id`),
  UNIQUE KEY `uk_inventory_wh_gen` (`warehouse_id`,`generator_id`),
  KEY `idx_inv_warehouse` (`warehouse_id`),
  KEY `idx_inv_generator` (`generator_id`),
  CONSTRAINT `fk_inv_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_inv_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`generator_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES
(1, 1, 1, 15, '2026-05-20 08:00:00'),
(2, 1, 2, 10, '2026-05-20 08:00:00'),
(3, 1, 3,  8, '2026-05-20 08:00:00'),
(4, 2, 4,  5, '2026-05-20 08:00:00'),
(5, 2, 5,  3, '2026-05-20 08:00:00');
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_card` -- The kho (log bien dong ton kho)
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_card` (
  `stock_card_id` int NOT NULL AUTO_INCREMENT,
  `warehouse_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `receipt_id` int DEFAULT NULL,
  `transaction_type` enum('IMPORT','EXPORT','ADJUST') NOT NULL,
  `quantity_change` int NOT NULL,
  `quantity_after` int NOT NULL,
  `reference_note` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  PRIMARY KEY (`stock_card_id`),
  KEY `idx_sc_warehouse` (`warehouse_id`),
  KEY `idx_sc_generator` (`generator_id`),
  KEY `idx_sc_receipt` (`receipt_id`),
  KEY `idx_sc_created_at` (`created_at`),
  CONSTRAINT `fk_sc_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_sc_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`generator_id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_sc_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `receipt` (`receipt_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_sc_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `stock_card` WRITE;
/*!40000 ALTER TABLE `stock_card` DISABLE KEYS */;
INSERT INTO `stock_card` VALUES
(1, 1, 1, NULL, 'IMPORT', 15, 15, N'Nhập kho ban đầu - Kho Hà Nội - Honda EG4500CX',   '2026-05-20 08:00:00', 6),
(2, 1, 2, NULL, 'IMPORT', 10, 10, N'Nhập kho ban đầu - Kho Hà Nội - Yamaha EF6000',       '2026-05-20 08:00:00', 6),
(3, 1, 3, NULL, 'IMPORT',  8,  8, N'Nhập kho ban đầu - Kho Hà Nội - Hyundai DHY8000',      '2026-05-20 08:00:00', 6),
(4, 2, 4, NULL, 'IMPORT',  5,  5, N'Nhập kho ban đầu - Kho HCM - Cummins C10D5',           '2026-05-20 08:00:00', 6),
(5, 2, 5, NULL, 'IMPORT',  3,  3, N'Nhập kho ban đầu - Kho HCM - Mitsubishi MGP-15',       '2026-05-20 08:00:00', 6);
/*!40000 ALTER TABLE `stock_card` ENABLE KEYS */;
UNLOCK TABLES;

-- ============================================================
-- RESTORE SETTINGS
-- ============================================================

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-21
