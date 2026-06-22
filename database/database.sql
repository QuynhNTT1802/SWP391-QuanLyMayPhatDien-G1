CREATE DATABASE  IF NOT EXISTS `warehousedb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `warehousedb`;
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

--
-- Table structure for table `activity_log`
--

DROP TABLE IF EXISTS `activity_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activity_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `entity_type` varchar(50) NOT NULL,
  `action` varchar(50) NOT NULL,
  `entity_id` int DEFAULT NULL,
  `entity_name` varchar(255) DEFAULT NULL,
  `details` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_entity` (`entity_type`,`entity_id`),
  KEY `idx_created` (`created_at`),
  CONSTRAINT `activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
INSERT INTO `activity_log` VALUES (1,3,'warehouse','UNLOCK',2,'Kho Hồ Chí Minh','Admin đã mở khóa kho \'Kho Hồ Chí Minh\' — Trạng thái: Bị khóa -> Hoạt động','2026-06-19 16:43:39'),(2,3,'warehouse','LOCK',1,'Kho Hà Nội','Admin đã khóa kho \'Kho Hà Nội\' — Trạng thái: Hoạt động -> Bị khóa','2026-06-19 16:44:01'),(3,3,'warehouse','UNLOCK',1,'Kho Hà Nội','Admin đã mở khóa kho \'Kho Hà Nội\' — Trạng thái: Bị khóa -> Hoạt động','2026-06-19 16:44:13'),(4,3,'generator','UPDATE',3,'DHY8000','Cập nhật thông tin máy phát điện: DHY8000','2026-06-19 16:45:04'),(5,3,'user','CREATE',13,'CEO','Tạo người dùng: ceo','2026-06-19 16:58:07'),(6,3,'import_proposal','CREATE',1,'PRC-20260619-001','Tạo phiếu đề xuất từ Excel (gửi duyệt) — 1 dòng','2026-06-19 17:12:10'),(7,3,'receipt','CREATE',1,'RX-IM-20260619-344','Tạo phiếu nhập kho','2026-06-19 17:13:06'),(8,3,'receipt','APPROVE',1,'RX-IM-20260619-344','Duyệt phiếu nhập kho, cập nhật tồn kho','2026-06-19 17:13:11'),(9,3,'receipt','CREATE',2,'RX-EX-20260619-396','Tạo phiếu xuất kho','2026-06-19 17:16:41'),(10,3,'receipt','APPROVE',2,'RX-EX-20260619-396','Duyệt phiếu xuất kho, cập nhật tồn kho','2026-06-19 17:16:46'),(11,3,'customer','DEACTIVATE',6,'Linh Hoàng','Khóa khách hàng: Linh Hoàng','2026-06-19 17:17:20'),(12,3,'customer','ACTIVATE',6,'Linh Hoàng','Kích hoạt khách hàng: Linh Hoàng','2026-06-19 17:18:04'),(13,3,'inventory_check','CREATE',1,'IC-20260619-829','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-06-19 17:19:15'),(14,3,'inventory_check','UPDATE',1,'IC-20260619-829','Cập nhật số lượng kiểm kê','2026-06-19 17:19:22'),(15,3,'inventory_check','COMPLETE',1,'IC-20260619-829','Hoàn thành kiểm kê','2026-06-19 17:19:24'),(16,3,'categories','UPDATE',44,'Mitsubishi','Admin đã cập nhật \'Mitsubishi\' (Thương hiệu) — Mô tả: H?ng s?n xu?t m?y ph?t ?i?n Mitsubishi -> Mitsubishi | module:quản lý vật tư','2026-06-20 15:47:37');
/*!40000 ALTER TABLE `activity_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `module` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'quản lý vật tư','Honda','brand','Hãng sản xuất máy phát điện Honda','active','2026-05-23 19:15:54','2026-05-27 22:41:32'),(2,'quản lý vật tư','Yamaha','brand','Hãng sản xuất máy phát điện Yamaha','active','2026-05-23 19:15:54','2026-05-27 22:41:54'),(3,'quản lý vật tư','Hyundai','brand','Hãng sản xuất máy phát điện Hyundai','active','2026-05-23 19:15:54','2026-05-27 22:41:40'),(4,'quản lý vật tư','Cummins','brand','Hãng sản xuất máy phát điện Cummins','active','2026-05-23 19:15:54','2026-05-30 08:40:53'),(5,'quản lý vật tư','Xăng','fuel_type','Máy phát điện chạy xăng','active','2026-05-23 19:15:54','2026-05-28 08:09:36'),(6,'quản lý vật tư','Dầu Diesel','fuel_type','Máy phát điện chạy dầu diesel','active','2026-05-23 19:15:54','2026-05-29 09:58:26'),(11,'quản lý vật tư','Inverter','generator_type','Máy phát điện Inverter','active','2026-05-23 19:15:54',NULL),(12,'quản lý vật tư','Công nghiệp','generator_type','Máy phát điện công nghiệp','active','2026-05-23 19:15:54',NULL),(13,'quản lý vật tư','Dân dụng','generator_type','Máy phát điện dân dụng','active','2026-05-23 19:15:54',NULL),(14,'quản lý vật tư','1 pha','phase','Máy phát điện 1 pha','active','2026-05-23 19:15:54',NULL),(15,'quản lý vật tư','3 pha','phase','Máy phát điện 3 pha','active','2026-05-23 19:15:54',NULL),(16,'quản lý vật tư','Mới','condition','Máy mới 100%','active','2026-05-23 19:15:54','2026-06-01 07:12:11'),(17,'quản lý vật tư','Đã qua sử dụng','condition','Máy đã qua sử dụng','active','2026-05-23 19:15:54','2026-05-27 22:46:02'),(18,'quản lý vật tư','Nhật Bản','origin','Xuất xứ Nhật Bản','active','2026-05-23 19:15:54',NULL),(19,'quản lý vật tư','Trung Quốc','origin','Xuất xứ Trung Quốc','active','2026-05-23 19:15:54',NULL),(20,'quản lý vật tư','Việt Nam','origin','Xuất xứ Việt Nam','active','2026-05-23 19:15:54',NULL),(21,'quản lý vật tư','Hàn Quốc','origin','Xuất xứ Hàn Quốc','active','2026-05-23 19:15:54','2026-06-01 07:12:34'),(22,'quản lý vật tư','Mỹ','origin','Xuất xứ Mỹ','active','2026-05-23 19:15:54',NULL),(25,'quản lý phiếu xuất nhập','Bảo hành','receipt_reason','Bảo hành sản phẩm','active','2026-05-28 04:28:53','2026-06-01 08:32:47'),(26,'quản lý phiếu xuất nhập','Bảo trì','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(27,'quản lý phiếu xuất nhập','Hư hỏng','receipt_reason','','active','2026-05-28 04:28:53','2026-05-28 08:07:58'),(28,'quản lý phiếu xuất nhập','Hết hạn sử dụng','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(29,'quản lý phiếu xuất nhập','Điều chuyển kho','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(30,'quản lý phiếu xuất nhập','Thanh lý','receipt_reason','','inactive','2026-05-28 04:28:53','2026-06-11 10:00:15'),(31,'quản lý phiếu xuất nhập','Khác','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(32,'quản lý phiếu mua bán','Cá nhân','customer_type','Khách hàng cá nhân','active','2026-05-23 19:15:54','2026-05-27 22:49:17'),(33,'quản lý phiếu mua bán','Doanh nghiệp','customer_type','Khách hàng doanh nghiệp','active','2026-05-23 19:15:54',NULL),(34,'quản lý kiểm kê','Hao hụt','adjust_reason','Lý do hao hụt','active','2026-05-23 19:15:54',NULL),(35,'quản lý kiểm kê','Hư hỏng','adjust_reason','Lý do hư hỏng','active','2026-05-23 19:15:54',NULL),(36,'quản lý kiểm kê','Điều chỉnh khác','adjust_reason','Lý do điều chỉnh khác','active','2026-05-23 19:15:54',NULL),(44,'quản lý vật tư','Mitsubishi','brand',' Mitsubishi','active','2026-05-26 21:07:30','2026-06-20 08:47:37'),(66,'quản lý vật tư','Cummi','brand','Group 1','active','2026-05-27 22:24:30','2026-06-01 07:11:59'),(67,'quản lý vật tư','2 pha','phase','Máy phát điện 2 pha','active','2026-05-27 22:48:06','2026-05-27 22:48:06'),(68,'quản lý phiếu mua bán','Nhà nước','customer_type','Nhà nước tài trợ','active','2026-05-27 22:49:02','2026-05-27 22:49:02'),(69,'quản lý vật tư','Test','brand','Test','active','2026-05-29 07:18:53','2026-05-29 07:18:53'),(70,'quản lý thanh lý','Máy quá cũ, hỏng nặng','liquidation_reason','Máy đã sử dụng lâu năm, không thể sửa chữa','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(71,'quản lý thanh lý','Chi phí sửa chữa quá cao','liquidation_reason','Chi phí bảo trì tốn kém hơn mua máy mới','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(72,'quản lý thanh lý','Thay đổi mục đích sử dụng','liquidation_reason','Không còn nhu cầu sử dụng loại máy này','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(73,'quản lý thanh lý','Giá đề xuất quá thấp','manager_reject_reason','Giá đề xuất quá thấp','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(74,'quản lý thanh lý','Thiết bị không thuộc diện thanh lý','manager_reject_reason','Thiết bị không thuộc diện thanh lý','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(75,'quản lý thanh lý','Sai thông tin series','manager_request_edit_reason','Sai thông tin series','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(76,'quản lý thanh lý','Cập nhật lại giá thanh lý','manager_request_edit_reason','Cập nhật lại giá thanh lý','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(77,'quản lý thanh lý','Không được phép thanh lý lúc này','ceo_reject_reason','Không được phép thanh lý lúc này','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(78,'quản lý thanh lý','Sai chiến lược giá','ceo_reject_reason','Sai chiến lược giá','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(79,'quản lý thanh lý','Cần xem xét lại giá thấp nhất','ceo_request_edit_reason','Cần xem xét lại giá thấp nhất','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(80,'quản lý thanh lý','Yêu cầu bổ sung chứng từ','ceo_request_edit_reason','Yêu cầu bổ sung chứng từ','active','2026-06-09 18:58:53','2026-06-09 18:58:53');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_brand`
--

DROP TABLE IF EXISTS `category_brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_brand` (
  `category_id` int NOT NULL,
  `country` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `website` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `founded_year` int DEFAULT NULL,
  `warranty_period` int DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `category_brand_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_brand`
--

LOCK TABLES `category_brand` WRITE;
/*!40000 ALTER TABLE `category_brand` DISABLE KEYS */;
INSERT INTO `category_brand` VALUES (1,'Nhật Bản','honda.com.vn',1948,12),(2,'Nhật Bản','yamaha-motor.com.vn',1955,12),(3,'Hàn Quốc','hyundai.com',1967,12),(4,'Mĩ','cummins.com',1919,26),(44,'Nhật Bản','mitsubishi.com',1870,12),(66,'Nhật Bản','cummins.com',2025,36),(69,'Việt Nam','test.com.vn',1986,12);
/*!40000 ALTER TABLE `category_brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_condition`
--

DROP TABLE IF EXISTS `category_condition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_condition` (
  `category_id` int NOT NULL,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `category_condition_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_condition`
--

LOCK TABLES `category_condition` WRITE;
/*!40000 ALTER TABLE `category_condition` DISABLE KEYS */;
INSERT INTO `category_condition` VALUES (16),(17);
/*!40000 ALTER TABLE `category_condition` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_customer_type`
--

DROP TABLE IF EXISTS `category_customer_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_customer_type` (
  `category_id` int NOT NULL,
  `tax_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `category_customer_type_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_customer_type`
--

LOCK TABLES `category_customer_type` WRITE;
/*!40000 ALTER TABLE `category_customer_type` DISABLE KEYS */;
INSERT INTO `category_customer_type` VALUES (32,'VAT 10%'),(33,'VAT 10%'),(68,'Không chịu thuế');
/*!40000 ALTER TABLE `category_customer_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_fuel_type`
--

DROP TABLE IF EXISTS `category_fuel_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_fuel_type` (
  `category_id` int NOT NULL,
  `unit` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `typical_price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `category_fuel_type_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_fuel_type`
--

LOCK TABLES `category_fuel_type` WRITE;
/*!40000 ALTER TABLE `category_fuel_type` DISABLE KEYS */;
INSERT INTO `category_fuel_type` VALUES (5,'lít',25000.00),(6,'lít',22000.00);
/*!40000 ALTER TABLE `category_fuel_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_generator_type`
--

DROP TABLE IF EXISTS `category_generator_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_generator_type` (
  `category_id` int NOT NULL,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `category_generator_type_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_generator_type`
--

LOCK TABLES `category_generator_type` WRITE;
/*!40000 ALTER TABLE `category_generator_type` DISABLE KEYS */;
/*!40000 ALTER TABLE `category_generator_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_origin`
--

DROP TABLE IF EXISTS `category_origin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_origin` (
  `category_id` int NOT NULL,
  `country_code` varchar(5) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `category_origin_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_origin`
--

LOCK TABLES `category_origin` WRITE;
/*!40000 ALTER TABLE `category_origin` DISABLE KEYS */;
INSERT INTO `category_origin` VALUES (18,'JP'),(19,'CN'),(20,'VN'),(21,'KR'),(22,'US');
/*!40000 ALTER TABLE `category_origin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_phase`
--

DROP TABLE IF EXISTS `category_phase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_phase` (
  `category_id` int NOT NULL,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `category_phase_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_phase`
--

LOCK TABLES `category_phase` WRITE;
/*!40000 ALTER TABLE `category_phase` DISABLE KEYS */;
INSERT INTO `category_phase` VALUES (67);
/*!40000 ALTER TABLE `category_phase` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category_receipt_reason`
--

DROP TABLE IF EXISTS `category_receipt_reason`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category_receipt_reason` (
  `category_id` int NOT NULL,
  PRIMARY KEY (`category_id`),
  CONSTRAINT `category_receipt_reason_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category_receipt_reason`
--

LOCK TABLES `category_receipt_reason` WRITE;
/*!40000 ALTER TABLE `category_receipt_reason` DISABLE KEYS */;
INSERT INTO `category_receipt_reason` VALUES (25),(26),(27),(28),(29),(30),(31);
/*!40000 ALTER TABLE `category_receipt_reason` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customer` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Tên khách hàng hoặc tên công ty',
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text,
  `company_name` varchar(255) DEFAULT NULL COMMENT 'NULL nếu là cá nhân',
  `customer_type_id` int DEFAULT NULL COMMENT 'FK → category (Cá nhân / Doanh nghiệp / Nhà nước)',
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_customer_name` (`name`),
  KEY `idx_customer_phone` (`phone`),
  KEY `idx_customer_status` (`status`),
  KEY `fk_customer_type_cat` (`customer_type_id`),
  KEY `fk_customer_created_by` (`created_by`),
  KEY `fk_customer_updated_by` (`updated_by`),
  CONSTRAINT `fk_customer_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_customer_type_cat` FOREIGN KEY (`customer_type_id`) REFERENCES `category` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_customer_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quản lý thông tin khách hàng';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Công ty TNHH Xây Dựng ABC','0988123456','abc@xaydungabc.com','12 Trần Duy Hưng, Cầu Giấy, Hà Nội','Công ty TNHH Xây Dựng ABC',33,'active','2026-05-21 09:00:00',4,NULL,NULL),(2,'Công ty CP Điện Máy XYZ','0977123456','xyz@dienmayxyz.com','56 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh','Công ty CP Điện Máy XYZ',33,'active','2026-05-21 10:00:00',4,'2026-06-19 17:15:17',3),(3,'123','123','123@gmail.com','123','123',32,'active','2026-06-07 03:40:43',3,'2026-06-07 03:40:43',NULL),(4,'1','1','123@gmail.com','123','1',32,'active','2026-06-07 04:30:08',3,'2026-06-07 04:30:08',NULL),(5,'123','0944727285','123@gmail.com','ninh bình','Công ty 123',33,'active','2026-06-07 05:15:24',3,'2026-06-07 05:15:24',NULL),(6,'Linh Hoàng','0978287102','123@gmail.com',' Hà Nội','',32,'active','2026-06-07 15:36:06',3,'2026-06-19 17:18:04',2),(7,'Thị Thu Hiền Hoàng','0981059011','12345@gmail.com','Hà Nội','',32,'active','2026-06-09 12:07:22',2,'2026-06-09 12:07:22',NULL),(8,'Nguyễn Văn Khánh','02938434','vankhan@gmail.com','23434','FPT University',32,'active','2026-06-19 15:14:36',3,'2026-06-19 15:14:36',NULL),(9,'Khánh Nguyễn Văn','0846723234','vankhanhak54@gmail.com','TP HN','FPT University',32,'active','2026-06-19 15:28:34',3,'2026-06-19 15:28:34',NULL),(10,'Khánh Nguyễn Văn','0846723771','vankhanhak54@gmail.com','TP HN','FPT University',32,'active','2026-06-19 15:29:38',3,'2026-06-19 15:29:37',NULL);
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generator`
--

DROP TABLE IF EXISTS `generator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generator` (
  `id` int NOT NULL AUTO_INCREMENT,
  `model` varchar(100) NOT NULL,
  `power_rating` decimal(10,2) DEFAULT NULL,
  `frequency` varchar(20) DEFAULT NULL,
  `weight` decimal(10,2) DEFAULT NULL,
  `description` text,
  `status` varchar(20) NOT NULL DEFAULT 'available',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generator`
--

LOCK TABLES `generator` WRITE;
/*!40000 ALTER TABLE `generator` DISABLE KEYS */;
INSERT INTO `generator` VALUES (1,'EG4500CX',4.50,'50Hz',85.00,'Máy phát điện Honda 4.5kVA, chạy xăng, 1 pha','active','2026-05-20 08:00:00','2026-06-05 16:21:42',NULL,1),(2,'EF6000',6.00,NULL,NULL,'Máy phát điện Yamaha 6.0kVA, chạy xăng, 1 pha','active','2026-05-20 08:00:00','2026-05-27 00:46:22',NULL,NULL),(3,'DHY8000',8.00,NULL,NULL,'Máy phát điện Hyundai 8.0kVA, chạy dầu diesel, 3 pha','locked','2026-05-20 08:00:00','2026-06-05 16:18:09',NULL,NULL),(4,'C10D5',10.00,NULL,NULL,'Máy phát điện Cummins 10kVA, chạy dầu diesel, 3 pha','active','2026-05-20 08:00:00','2026-05-27 00:46:22',NULL,NULL),(5,'MGP-15',15.00,NULL,NULL,'Máy phát điện Mitsubishi 15kVA, chạy dầu diesel, 3 pha','active','2026-05-20 08:00:00','2026-05-27 00:46:22',NULL,NULL);
/*!40000 ALTER TABLE `generator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generator_category`
--

DROP TABLE IF EXISTS `generator_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generator_category` (
  `generator_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`generator_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `generator_category_ibfk_1` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`),
  CONSTRAINT `generator_category_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generator_category`
--

LOCK TABLES `generator_category` WRITE;
/*!40000 ALTER TABLE `generator_category` DISABLE KEYS */;
INSERT INTO `generator_category` VALUES (1,1),(2,2),(3,3),(4,4),(1,5),(2,5),(3,6),(4,6),(5,6),(3,12),(4,12),(5,12),(1,13),(2,13),(1,14),(2,14),(3,15),(4,15),(5,15),(1,16),(2,16),(3,16),(4,16),(5,16),(1,18),(5,44);
/*!40000 ALTER TABLE `generator_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_proposal`
--

DROP TABLE IF EXISTS `import_proposal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_proposal` (
  `proposal_id` int NOT NULL AUTO_INCREMENT,
  `proposal_code` varchar(50) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'DRAFT',
  `warehouse_id` int NOT NULL,
  `created_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `rejected_by` int DEFAULT NULL,
  `proposal_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `period` varchar(10) DEFAULT NULL,
  `purchase_order_id` int DEFAULT NULL,
  `note` text,
  `reject_reason` text,
  `approved_at` datetime DEFAULT NULL,
  `rejected_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`proposal_id`),
  UNIQUE KEY `uk_proposal_code` (`proposal_code`),
  KEY `idx_proposal_warehouse` (`warehouse_id`),
  KEY `idx_proposal_created` (`created_by`),
  KEY `idx_proposal_approved` (`approved_by`),
  KEY `idx_proposal_rejected` (`rejected_by`),
  KEY `idx_proposal_status` (`status`),
  KEY `idx_proposal_po` (`purchase_order_id`),
  KEY `idx_proposal_period` (`period`,`warehouse_id`,`status`),
  CONSTRAINT `fk_proposal_approved` FOREIGN KEY (`approved_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proposal_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_proposal_po` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_order` (`po_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proposal_rejected` FOREIGN KEY (`rejected_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proposal_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_proposal`
--

LOCK TABLES `import_proposal` WRITE;
/*!40000 ALTER TABLE `import_proposal` DISABLE KEYS */;
INSERT INTO `import_proposal` VALUES (1,'PRC-20260619-001','APPROVED',1,3,NULL,NULL,'2026-06-19 17:12:10','202606',1,'',NULL,NULL,NULL,'2026-06-19 17:12:10','2026-06-19 17:12:22');
/*!40000 ALTER TABLE `import_proposal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `import_proposal_detail`
--

DROP TABLE IF EXISTS `import_proposal_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `import_proposal_detail` (
  `proposal_detail_id` int NOT NULL AUTO_INCREMENT,
  `proposal_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `supplier_id` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `current_stock` int NOT NULL DEFAULT '0',
  `unit_price` decimal(15,2) DEFAULT NULL COMMENT 'Giá đề xuất tại thời điểm tạo phiếu',
  `note` text,
  PRIMARY KEY (`proposal_detail_id`),
  KEY `idx_pd_proposal` (`proposal_id`),
  KEY `idx_pd_generator` (`generator_id`),
  KEY `idx_pd_supplier` (`supplier_id`),
  CONSTRAINT `fk_pd_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_pd_proposal` FOREIGN KEY (`proposal_id`) REFERENCES `import_proposal` (`proposal_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pd_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_proposal_detail`
--

LOCK TABLES `import_proposal_detail` WRITE;
/*!40000 ALTER TABLE `import_proposal_detail` DISABLE KEYS */;
INSERT INTO `import_proposal_detail` VALUES (1,1,1,2,2,0,18000000.00,'');
/*!40000 ALTER TABLE `import_proposal_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `inventory_id` int NOT NULL AUTO_INCREMENT,
  `serial_number` varchar(100) NOT NULL,
  `generator_id` int NOT NULL,
  `warehouse_id` int NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'IN_STOCK',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_id`),
  UNIQUE KEY `uk_inv_serial` (`serial_number`),
  KEY `idx_inv_warehouse` (`warehouse_id`),
  KEY `idx_inv_generator` (`generator_id`),
  KEY `idx_inv_status` (`status`),
  CONSTRAINT `fk_inv_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`),
  CONSTRAINT `fk_inv_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,'SR3213232399',1,1,'SOLD','2026-06-19 17:13:06','2026-06-19 17:16:46'),(2,'SR3213232398',1,1,'SOLD','2026-06-19 17:13:06','2026-06-19 17:16:46');
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_check`
--

DROP TABLE IF EXISTS `inventory_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_check` (
  `id` int NOT NULL AUTO_INCREMENT,
  `check_code` varchar(50) NOT NULL,
  `warehouse_id` int NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'doing',
  `notes` text,
  `created_by` int NOT NULL,
  `started_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `completed_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `warehouse_id` (`warehouse_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `inventory_check_ibfk_1` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`),
  CONSTRAINT `inventory_check_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_check`
--

LOCK TABLES `inventory_check` WRITE;
/*!40000 ALTER TABLE `inventory_check` DISABLE KEYS */;
INSERT INTO `inventory_check` VALUES (1,'IC-20260619-829',1,'completed','',3,'2026-06-19 17:19:15','2026-06-19 17:19:24','2026-06-19 17:19:15','2026-06-19 17:19:24');
/*!40000 ALTER TABLE `inventory_check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_check_detail`
--

DROP TABLE IF EXISTS `inventory_check_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_check_detail` (
  `id` int NOT NULL AUTO_INCREMENT,
  `check_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `system_quantity` int NOT NULL DEFAULT '0',
  `actual_quantity` int DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `check_id` (`check_id`),
  KEY `generator_id` (`generator_id`),
  CONSTRAINT `inventory_check_detail_ibfk_1` FOREIGN KEY (`check_id`) REFERENCES `inventory_check` (`id`) ON DELETE CASCADE,
  CONSTRAINT `inventory_check_detail_ibfk_2` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_check_detail`
--

LOCK TABLES `inventory_check_detail` WRITE;
/*!40000 ALTER TABLE `inventory_check_detail` DISABLE KEYS */;
INSERT INTO `inventory_check_detail` VALUES (1,1,1,0,0,'');
/*!40000 ALTER TABLE `inventory_check_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_check_serial`
--

DROP TABLE IF EXISTS `inventory_check_serial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_check_serial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `check_detail_id` int NOT NULL,
  `serial_number` varchar(100) NOT NULL,
  `status` varchar(20) DEFAULT NULL,
  `notes` text,
  PRIMARY KEY (`id`),
  KEY `check_detail_id` (`check_detail_id`),
  CONSTRAINT `inventory_check_serial_ibfk_1` FOREIGN KEY (`check_detail_id`) REFERENCES `inventory_check_detail` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_check_serial`
--

LOCK TABLES `inventory_check_serial` WRITE;
/*!40000 ALTER TABLE `inventory_check_serial` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_check_serial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `liquidation`
--

DROP TABLE IF EXISTS `liquidation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liquidation` (
  `liquidation_id` int NOT NULL AUTO_INCREMENT,
  `liquidation_code` varchar(50) NOT NULL,
  `created_by` int NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'PENDING_MANAGER',
  `reason_id` int NOT NULL,
  `manager_reviewed_by` int DEFAULT NULL,
  `manager_reviewed_at` datetime DEFAULT NULL,
  `ceo_reviewed_by` int DEFAULT NULL,
  `ceo_reviewed_at` datetime DEFAULT NULL,
  `ceo_feedback_id` int DEFAULT NULL,
  `manager_feedback_id` int DEFAULT NULL,
  `converted_receipt_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `warehouse_id` int NOT NULL DEFAULT '1',
  `customer_id` int DEFAULT NULL,
  PRIMARY KEY (`liquidation_id`),
  UNIQUE KEY `liquidation_code` (`liquidation_code`),
  KEY `fk_liq_created_by` (`created_by`),
  KEY `fk_liq_manager_by` (`manager_reviewed_by`),
  KEY `fk_liq_ceo_by` (`ceo_reviewed_by`),
  KEY `fk_liq_receipt` (`converted_receipt_id`),
  KEY `fk_liq_reason` (`reason_id`),
  KEY `fk_liq_ceo_feedback` (`ceo_feedback_id`),
  KEY `fk_liq_manager_feedback` (`manager_feedback_id`),
  KEY `fk_liq_warehouse` (`warehouse_id`),
  KEY `fk_liq_customer` (`customer_id`),
  CONSTRAINT `fk_liq_ceo_by` FOREIGN KEY (`ceo_reviewed_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_liq_ceo_feedback` FOREIGN KEY (`ceo_feedback_id`) REFERENCES `category` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_liq_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_liq_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_liq_manager_by` FOREIGN KEY (`manager_reviewed_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_liq_manager_feedback` FOREIGN KEY (`manager_feedback_id`) REFERENCES `category` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_liq_reason` FOREIGN KEY (`reason_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_liq_receipt` FOREIGN KEY (`converted_receipt_id`) REFERENCES `receipt` (`receipt_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_liq_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `liquidation`
--

LOCK TABLES `liquidation` WRITE;
/*!40000 ALTER TABLE `liquidation` DISABLE KEYS */;
/*!40000 ALTER TABLE `liquidation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `liquidation_detail`
--

DROP TABLE IF EXISTS `liquidation_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `liquidation_detail` (
  `liquidation_detail_id` int NOT NULL AUTO_INCREMENT,
  `liquidation_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `serial_number` varchar(100) NOT NULL,
  `original_price` decimal(15,2) NOT NULL,
  `liquidation_price` decimal(15,2) DEFAULT NULL,
  PRIMARY KEY (`liquidation_detail_id`),
  KEY `fk_ld_liquidation` (`liquidation_id`),
  KEY `fk_ld_generator` (`generator_id`),
  CONSTRAINT `fk_ld_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_ld_liquidation` FOREIGN KEY (`liquidation_id`) REFERENCES `liquidation` (`liquidation_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `liquidation_detail`
--

LOCK TABLES `liquidation_detail` WRITE;
/*!40000 ALTER TABLE `liquidation_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `liquidation_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification`
--

DROP TABLE IF EXISTS `notification`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `entity_type` varchar(50) DEFAULT NULL,
  `entity_id` int DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `fk_notif_user` (`user_id`),
  KEY `idx_notif_entity` (`entity_type`,`entity_id`),
  CONSTRAINT `fk_notif_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,7,'Phiếu nhập kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu nhập RX-IM-20260619-344 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/import-receipt?action=detail&id=1','import_receipt',1,0,'2026-06-19 17:13:06'),(2,8,'Phiếu nhập kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu nhập RX-IM-20260619-344 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/import-receipt?action=detail&id=1','import_receipt',1,0,'2026-06-19 17:13:06'),(3,9,'Phiếu nhập kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu nhập RX-IM-20260619-344 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/import-receipt?action=detail&id=1','import_receipt',1,0,'2026-06-19 17:13:06'),(4,7,'Phiếu xuất kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu xuất RX-EX-20260619-396 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/export-receipt?action=detail&id=2','export_receipt',2,0,'2026-06-19 17:16:41'),(5,8,'Phiếu xuất kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu xuất RX-EX-20260619-396 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/export-receipt?action=detail&id=2','export_receipt',2,0,'2026-06-19 17:16:41'),(6,9,'Phiếu xuất kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu xuất RX-EX-20260619-396 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/export-receipt?action=detail&id=2','export_receipt',2,0,'2026-06-19 17:16:41');
/*!40000 ALTER TABLE `notification` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_category`
--

DROP TABLE IF EXISTS `order_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_category` (
  `order_id` int NOT NULL,
  `category_id` int NOT NULL,
  PRIMARY KEY (`order_id`,`category_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `order_category_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `sale_order` (`order_id`) ON DELETE CASCADE,
  CONSTRAINT `order_category_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_category`
--

LOCK TABLES `order_category` WRITE;
/*!40000 ALTER TABLE `order_category` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_detail`
--

DROP TABLE IF EXISTS `order_detail`;
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
  CONSTRAINT `fk_od_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_od_order` FOREIGN KEY (`order_id`) REFERENCES `sale_order` (`order_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (1,1,1,1,18000000.00,NULL);
/*!40000 ALTER TABLE `order_detail` ENABLE KEYS */;
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
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `processed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_password_reset_user_idx` (`user_id`),
  KEY `fk_password_reset_processed_by_idx` (`processed_by`),
  CONSTRAINT `fk_password_reset_processed_by` FOREIGN KEY (`processed_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_password_reset_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_request`
--

LOCK TABLES `password_reset_request` WRITE;
/*!40000 ALTER TABLE `password_reset_request` DISABLE KEYS */;
/*!40000 ALTER TABLE `password_reset_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `resource` varchar(100) NOT NULL,
  `action` varchar(50) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `module` varchar(50) DEFAULT NULL,
  `feature_name` varchar(100) DEFAULT NULL,
  `task_type` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_resource_action` (`resource`,`action`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES (1,'users','view','Xem danh sach nguoi dung','admin','Người dùng','READ'),(2,'users','create','Them nguoi dung moi','admin','Người dùng','CREATE'),(3,'users','update','Cap nhat thong tin nguoi dung','admin','Người dùng','UPDATE'),(4,'users','deactivate','Vo hieu hoa nguoi dung','admin','Người dùng','DELETE'),(5,'roles','view','Xem danh sach vai tro','admin','Vai trò','READ'),(6,'roles','create','Them vai tro moi','admin','Vai trò','CREATE'),(7,'roles','update','Cap nhat vai tro','admin','Vai trò','UPDATE'),(8,'roles','deactivate','Vo hieu hoa vai tro','admin','Vai trò','DELETE'),(9,'roles','edit_permissions','Chinh sua quyen cua vai tro','admin','Vai trò','UPDATE'),(10,'generators','view','Xem danh sach may phat dien','warehouse','Máy phát điện','READ'),(11,'generators','create','Them may phat dien moi','warehouse','Máy phát điện','CREATE'),(12,'generators','update','Cap nhat thong tin may','warehouse','Máy phát điện','UPDATE'),(22,'inventory','view','Xem ton kho','warehouse','Tồn kho','READ'),(24,'inventory','adjust','Dieu chinh ton kho','warehouse','Tồn kho','ADJUST'),(25,'warehouses','view','Xem thong tin kho','warehouse','Kho','READ'),(26,'warehouses','create','Them kho moi','warehouse','Kho','CREATE'),(27,'warehouses','update','Cap nhat thong tin kho','warehouse','Kho','UPDATE'),(45,'orders','view','Xem don hang','sales','Đơn hàng','READ'),(46,'orders','create','Tao don hang','sales','Đơn hàng','CREATE'),(47,'orders','update','Cap nhat don hang','sales','Đơn hàng','UPDATE'),(48,'orders','cancel','Huy don hang','sales','Đơn hàng','CANCEL'),(65,'reports','view','Xem bao cao','report','Báo cáo','READ'),(66,'reports','export','Xuat bao cao','report','Báo cáo','EXPORT'),(91,'dashboard','view','Xem dashboard','system','Dashboard','READ'),(95,'profile','view','Xem ho so ca nhan','account','Hồ sơ cá nhân','READ'),(96,'profile','edit','Sua ho so ca nhan','account','Hồ sơ cá nhân','UPDATE'),(97,'password','change','Doi mat khau','account','Mật khẩu','UPDATE'),(98,'forgot_pw','process','Xu ly yeu cau reset mat khau','account','Đặt lại mật khẩu','UPDATE'),(100,'orders','approve','Duyet don hang (sale_manager)','sales','Đơn hàng','APPROVE'),(101,'receipts','view','Xem phieu xuat/nhap kho','warehouse','Phiếu xuất/nhập','READ'),(102,'receipts','create','Tao phieu xuat/nhap kho','warehouse','Phiếu xuất/nhập','CREATE'),(103,'receipts','approve','Duyet phieu xuat/nhap kho (warehouse_manager)','warehouse','Phiếu xuất/nhập','APPROVE'),(104,'stock_card','view','Xem the kho','warehouse','Thẻ kho','READ'),(105,'orders','reject','Tu choi don hang (sale_manager)','sales','Đơn hàng','REJECT'),(106,'receipts','reject','Tu choi phieu xuat/nhap kho (warehouse_manager)','warehouse','Phiếu xuất/nhập','REJECT'),(107,'categories','view','Xem danh mục','system','Danh mục','READ'),(108,'categories','create','Tạo danh mục mới','system','Danh mục','CREATE'),(109,'categories','update','Sửa danh mục','system','Danh mục','UPDATE'),(110,'categories','delete','Xóa danh mục','system','Danh mục','DELETE'),(111,'activity_log','view','Xem lịch sử hoạt động','system','Lịch sử hoạt động','READ'),(112,'system_log','view','Xem nhật ký hệ thống','system','Nhật ký hệ thống','READ'),(113,'customers','view','Xem danh sách khách hàng','sales','Khách hàng','READ'),(114,'customers','create','Thêm khách hàng mới','sales','Khách hàng','CREATE'),(115,'customers','update','Sửa thông tin khách hàng','sales','Khách hàng','UPDATE'),(116,'customers','deactivate','Vô hiệu hóa khách hàng','sales','Khách hàng','DELETE'),(117,'proposals','view','Xem phiếu đề xuất nhập kho','sales','Đề xuất nhập kho','READ'),(118,'proposals','create','Tạo phiếu đề xuất nhập kho','sales','Đề xuất nhập kho','CREATE'),(119,'proposals','update','Cập nhật phiếu đề xuất nhập kho','sales','Đề xuất nhập kho','UPDATE'),(120,'proposals','cancel','Hủy phiếu đề xuất nhập kho','sales','Đề xuất nhập kho','CANCEL'),(121,'proposals','approve','Duyệt phiếu đề xuất nhập kho (sale_manager)','sales','Đề xuất nhập kho','APPROVE'),(122,'proposals','reject','Từ chối phiếu đề xuất nhập kho (sale_manager)','sales','Đề xuất nhập kho','REJECT'),(124,'liquidations','view','Xem danh sách đơn thanh lý','warehouse','Đơn thanh lý','READ'),(125,'liquidations','create','Tạo đơn thanh lý (Warehouse Staff)','warehouse','Đơn thanh lý','CREATE'),(126,'liquidations','approve_manager','Duyệt và báo giá đơn thanh lý (Warehouse Manager)','warehouse','Đơn thanh lý','APPROVE'),(127,'liquidations','approve_ceo','Duyệt/Yêu cầu sửa đơn thanh lý (CEO)','warehouse','Đơn thanh lý','APPROVE'),(128,'transfers','view','Xem phiếu luân chuyển kho','warehouse','Phiếu luân chuyển','READ'),(129,'transfers','create','Tạo phiếu luân chuyển kho','warehouse','Phiếu luân chuyển','CREATE'),(130,'transfers','approve_manager','Duyệt phiếu luân chuyển (warehouse_manager)','warehouse','Phiếu luân chuyển','APPROVE'),(131,'transfers','approve_ceo','Duyệt phiếu luân chuyển (ceo)','warehouse','Phiếu luân chuyển','APPROVE'),(132,'purchase_orders','reject','Từ chối phiếu mua (CEO)','sales','Phiếu mua hàng','REJECT'),(133,'purchase_orders','view','Xem phiếu mua','sales','Phiếu mua hàng','READ'),(134,'purchase_orders','create','Tạo/gom phiếu mua (sale_manager)','sales','Phiếu mua hàng','CREATE'),(135,'purchase_orders','send_ceo','Gửi phiếu mua cho CEO','sales','Phiếu mua hàng','APPROVE'),(136,'purchase_orders','approve','Duyệt phiếu mua (CEO)','sales','Phiếu mua hàng','APPROVE'),(137,'suppliers','view','Xem danh sách nhà cung cấp','sales','Nhà cung cấp','READ'),(138,'suppliers','create','Thêm nhà cung cấp mới','sales','Nhà cung cấp','CREATE'),(139,'suppliers','update','Cập nhật thông tin nhà cung cấp','sales','Nhà cung cấp','UPDATE'),(140,'suppliers','deactivate','Vô hiệu hóa nhà cung cấp','sales','Nhà cung cấp','DELETE'),(141,'inventory_check','view','Xem phieu kiem ke','warehouse','Kiểm kê','READ'),(142,'inventory_check','create','Tao phieu kiem ke','warehouse','Kiểm kê','CREATE'),(143,'inventory_check','update','Cap nhat phieu kiem ke','warehouse','Kiểm kê','UPDATE'),(144,'inventory_check','complete','Hoan thanh kiem ke','warehouse','Kiểm kê','COMPLETE'),(145,'liquidations','cancel','Hủy đơn thanh lý do mình tạo (Warehouse Staff)','warehouse','Đơn thanh lý','CANCEL');
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_order`
--

DROP TABLE IF EXISTS `purchase_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order` (
  `po_id` int NOT NULL AUTO_INCREMENT,
  `po_code` varchar(50) NOT NULL,
  `period` varchar(10) NOT NULL COMMENT 'YYYYQn (vd 2026Q1)',
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `warehouse_id` int NOT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'DRAFT',
  `created_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `rejected_by` int DEFAULT NULL,
  `reject_reason` text,
  `cancel_reason` text,
  `total_proposals` int NOT NULL DEFAULT '0',
  `total_quantity` int NOT NULL DEFAULT '0',
  `note` text,
  `sent_to_ceo_at` datetime DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `rejected_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`po_id`),
  UNIQUE KEY `uk_po_code` (`po_code`),
  UNIQUE KEY `uk_po_period_warehouse` (`period`,`warehouse_id`),
  KEY `idx_po_status` (`status`),
  KEY `idx_po_created` (`created_by`),
  KEY `idx_po_approved` (`approved_by`),
  KEY `idx_po_warehouse` (`warehouse_id`),
  KEY `fk_po_rejected` (`rejected_by`),
  CONSTRAINT `fk_po_approved` FOREIGN KEY (`approved_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_po_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_po_rejected` FOREIGN KEY (`rejected_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_po_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order`
--

LOCK TABLES `purchase_order` WRITE;
/*!40000 ALTER TABLE `purchase_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_order_detail`
--

DROP TABLE IF EXISTS `purchase_order_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_order_detail` (
  `po_detail_id` int NOT NULL AUTO_INCREMENT,
  `po_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `proposed_quantity` int NOT NULL DEFAULT '0' COMMENT 'Tong SL tu cac proposal goc',
  `current_stock` int NOT NULL DEFAULT '0' COMMENT 'Ton kho luc gom',
  `unit_price` decimal(15,2) DEFAULT NULL COMMENT 'Giá duyệt tại PO, copy từ proposal detail',
  `final_quantity` int NOT NULL DEFAULT '0' COMMENT 'Sale manager chot',
  `note` text,
  PRIMARY KEY (`po_detail_id`),
  UNIQUE KEY `uk_po_detail_generator` (`po_id`,`generator_id`),
  KEY `idx_pod_po` (`po_id`),
  KEY `idx_pod_generator` (`generator_id`),
  CONSTRAINT `fk_pod_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`),
  CONSTRAINT `fk_pod_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order_detail`
--

LOCK TABLES `purchase_order_detail` WRITE;
/*!40000 ALTER TABLE `purchase_order_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `purchase_order_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipt`
--

DROP TABLE IF EXISTS `receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipt` (
  `receipt_id` int NOT NULL AUTO_INCREMENT,
  `receipt_code` varchar(50) NOT NULL,
  `receipt_type` enum('IMPORT','EXPORT') NOT NULL,
  `order_id` int DEFAULT NULL,
  `purchase_order_id` int DEFAULT NULL,
  `warehouse_id` int NOT NULL,
  `created_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'PENDING',
  `note` text,
  `approved_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `reason_id` int DEFAULT NULL,
  `reason_note` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`receipt_id`),
  UNIQUE KEY `uk_receipt_code` (`receipt_code`),
  KEY `idx_receipt_order` (`order_id`),
  KEY `idx_receipt_warehouse` (`warehouse_id`),
  KEY `idx_receipt_created` (`created_by`),
  KEY `idx_receipt_approved` (`approved_by`),
  KEY `idx_receipt_status` (`status`),
  KEY `reason_id` (`reason_id`),
  KEY `idx_receipt_po` (`purchase_order_id`),
  CONSTRAINT `fk_receipt_approved` FOREIGN KEY (`approved_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_receipt_order` FOREIGN KEY (`order_id`) REFERENCES `sale_order` (`order_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_po` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_order` (`po_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT,
  CONSTRAINT `receipt_ibfk_1` FOREIGN KEY (`reason_id`) REFERENCES `category` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt`
--

LOCK TABLES `receipt` WRITE;
/*!40000 ALTER TABLE `receipt` DISABLE KEYS */;
INSERT INTO `receipt` VALUES (1,'RX-IM-20260619-344','IMPORT',NULL,1,1,3,3,'COMPLETED','','2026-06-19 17:13:11','2026-06-19 17:13:06','2026-06-19 17:13:10',25,NULL),(2,'RX-EX-20260619-396','EXPORT',1,NULL,1,3,3,'COMPLETED','Tạo từ đơn OR-34354986586','2026-06-19 17:16:46','2026-06-19 17:16:41','2026-06-19 17:16:46',25,NULL);
/*!40000 ALTER TABLE `receipt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipt_detail`
--

DROP TABLE IF EXISTS `receipt_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipt_detail` (
  `receipt_detail_id` int NOT NULL AUTO_INCREMENT,
  `receipt_id` int NOT NULL,
  `inventory_id` int NOT NULL,
  `note` text,
  PRIMARY KEY (`receipt_detail_id`),
  KEY `idx_rd_receipt` (`receipt_id`),
  KEY `idx_rd_inventory` (`inventory_id`),
  CONSTRAINT `fk_rd_inventory` FOREIGN KEY (`inventory_id`) REFERENCES `inventory` (`inventory_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rd_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `receipt` (`receipt_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt_detail`
--

LOCK TABLES `receipt_detail` WRITE;
/*!40000 ALTER TABLE `receipt_detail` DISABLE KEYS */;
INSERT INTO `receipt_detail` VALUES (1,1,1,''),(2,1,2,''),(3,2,2,''),(4,2,1,'');
/*!40000 ALTER TABLE `receipt_detail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_role_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'admin','Quản trị hệ thống','active','2026-05-15 16:43:03','2026-06-18 16:44:59'),(2,'warehouse_manager','Quản lý kho - Duyệt phiếu xuất/nhập','active','2026-05-15 16:43:03','2026-05-21 08:00:00'),(3,'warehouse_staff','Nhân viên kho - Tạo phiếu, quét serial','active','2026-05-15 16:43:03','2026-05-21 08:00:00'),(5,'sales_staff','Nhân viên kinh doanh - Tạo đơn hàng','active','2026-05-15 16:43:03','2026-06-15 21:18:10'),(10,'sale_manager','Trưởng phòng kinh doanh - Duyệt đơn hàng','active','2026-05-21 00:00:00','2026-06-16 22:43:07'),(13,'ceo','Giám đốc điều hành - Duyệt các đơn thanh lý và quyết định cấp cao','active','2026-06-09 21:49:56','2026-06-16 22:43:17');
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permission`
--

DROP TABLE IF EXISTS `role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permission` (
  `role_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `idx_rp_permission` (`permission_id`),
  CONSTRAINT `fk_rp_permission` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_rp_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permission`
--

LOCK TABLES `role_permission` WRITE;
/*!40000 ALTER TABLE `role_permission` DISABLE KEYS */;
INSERT INTO `role_permission` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(2,10),(3,10),(5,10),(10,10),(1,11),(1,12),(1,22),(2,22),(3,22),(1,24),(2,24),(1,25),(2,25),(3,25),(1,26),(2,26),(1,27),(2,27),(1,45),(2,45),(3,45),(5,45),(10,45),(1,46),(5,46),(1,47),(5,47),(1,48),(5,48),(1,65),(2,65),(10,65),(1,66),(2,66),(1,91),(2,91),(3,91),(5,91),(10,91),(1,95),(2,95),(3,95),(5,95),(10,95),(1,96),(2,96),(3,96),(5,96),(10,96),(1,97),(2,97),(3,97),(5,97),(10,97),(1,98),(1,100),(10,100),(1,101),(2,101),(3,101),(1,102),(2,102),(3,102),(1,103),(2,103),(1,104),(2,104),(1,105),(10,105),(1,106),(2,106),(1,107),(1,108),(1,109),(1,110),(1,111),(1,112),(1,113),(1,114),(1,115),(1,116),(1,117),(2,117),(5,117),(10,117),(1,118),(5,118),(1,119),(5,119),(1,120),(5,120),(1,121),(10,121),(1,122),(10,122),(1,124),(2,124),(3,124),(10,124),(13,124),(1,125),(3,125),(1,126),(2,126),(1,127),(10,127),(13,127),(1,128),(2,128),(3,128),(13,128),(1,129),(2,129),(3,129),(1,130),(2,130),(1,131),(13,131),(1,132),(13,132),(1,133),(10,133),(13,133),(1,134),(10,134),(1,135),(10,135),(1,136),(13,136),(1,137),(1,138),(1,139),(1,140),(1,141),(1,142),(1,143),(1,144),(1,145),(3,145);
/*!40000 ALTER TABLE `role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_order`
--

DROP TABLE IF EXISTS `sale_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_order` (
  `order_id` int NOT NULL AUTO_INCREMENT,
  `order_code` varchar(50) NOT NULL,
  `customer_id` int DEFAULT NULL,
  `created_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'PENDING',
  `total_amount` decimal(15,2) DEFAULT NULL,
  `note` text,
  `customer_note` text,
  `order_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `approved_at` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `cancelled_by` int DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  `rejected_by` int DEFAULT NULL,
  `reject_reason` text,
  PRIMARY KEY (`order_id`),
  UNIQUE KEY `uk_order_code` (`order_code`),
  KEY `idx_order_created` (`created_by`),
  KEY `idx_order_approved` (`approved_by`),
  KEY `idx_order_status` (`status`),
  KEY `fk_order_customer` (`customer_id`),
  KEY `fk_so_rejected_by` (`rejected_by`),
  CONSTRAINT `fk_order_approved` FOREIGN KEY (`approved_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_order_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_so_customer` FOREIGN KEY (`customer_id`) REFERENCES `customer` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_so_rejected_by` FOREIGN KEY (`rejected_by`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_order`
--

LOCK TABLES `sale_order` WRITE;
/*!40000 ALTER TABLE `sale_order` DISABLE KEYS */;
INSERT INTO `sale_order` VALUES (1,'OR-34354986586',2,3,3,'APPROVED',18000000.00,NULL,'Giao giờ khách hàng','2026-06-18 00:00:00','2026-06-19 17:15:39','2026-06-19 17:15:17','2026-06-19 17:15:39',NULL,NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `sale_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `serial_number`
--

DROP TABLE IF EXISTS `serial_number`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `serial_number` (
  `id` int NOT NULL AUTO_INCREMENT,
  `generator_id` int NOT NULL,
  `serial_number` varchar(100) NOT NULL,
  `warehouse_id` int NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'IN_STOCK',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_serial_number` (`serial_number`),
  KEY `fk_sn_generator` (`generator_id`),
  KEY `fk_sn_warehouse` (`warehouse_id`),
  CONSTRAINT `fk_sn_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_sn_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `serial_number`
--

LOCK TABLES `serial_number` WRITE;
/*!40000 ALTER TABLE `serial_number` DISABLE KEYS */;
/*!40000 ALTER TABLE `serial_number` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_card`
--

DROP TABLE IF EXISTS `stock_card`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_card` (
  `stock_card_id` int NOT NULL AUTO_INCREMENT,
  `warehouse_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `receipt_id` int DEFAULT NULL,
  `transaction_type` enum('IMPORT','EXPORT','ADJUST','TRANSFER_OUT','TRANSFER_IN') NOT NULL,
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
  KEY `fk_sc_created_by` (`created_by`),
  CONSTRAINT `fk_sc_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_sc_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_sc_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `receipt` (`receipt_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_sc_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_card`
--

LOCK TABLES `stock_card` WRITE;
/*!40000 ALTER TABLE `stock_card` DISABLE KEYS */;
INSERT INTO `stock_card` VALUES (1,1,1,1,'IMPORT',2,2,'Phi?u RX-IM-20260619-344','2026-06-19 17:13:11',3),(2,1,1,2,'EXPORT',-2,0,'Phi?u RX-EX-20260619-396','2026-06-19 17:16:46',3);
/*!40000 ALTER TABLE `stock_card` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `supplier`
--

DROP TABLE IF EXISTS `supplier`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `supplier` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL COMMENT 'Tên nhà cung cấp hoặc tên công ty',
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text,
  `company_name` varchar(255) DEFAULT NULL COMMENT 'NULL nếu là cá nhân',
  `supplier_type_id` int DEFAULT NULL COMMENT 'FK → category (Cá nhân / Doanh nghiệp / Nhà nước)',
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `created_by` int DEFAULT NULL,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `updated_by` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_supplier_name` (`name`),
  KEY `idx_supplier_phone` (`phone`),
  KEY `idx_supplier_status` (`status`),
  KEY `fk_supplier_type_cat` (`supplier_type_id`),
  KEY `fk_supplier_created_by` (`created_by`),
  KEY `fk_supplier_updated_by` (`updated_by`),
  CONSTRAINT `fk_supplier_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_supplier_type_cat` FOREIGN KEY (`supplier_type_id`) REFERENCES `category` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_supplier_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quản lý thông tin nhà cung cấp';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'Công ty TNHH Thiết Bị Điện Hoàng Gia','02412345678','info@hoanggia.com','Số 15 Lý Thường Kiệt, Hoàn Kiếm, Hà Nội','Công ty TNHH Thiết Bị Điện Hoàng Gia',33,'active','2026-05-20 08:00:00',3,NULL,NULL),(2,'Công ty CP Máy Phát Điện Đông Dương','02898765432','sales@dongduong.com','120 Nguyễn Văn Linh, Quận 7, TP. Hồ Chí Minh','Công ty CP Máy Phát Điện Đông Dương',33,'active','2026-05-20 08:00:00',3,NULL,NULL),(3,'Trần Văn Minh - Đại lý Honda','0912345670','minhtran@gmail.com','45 Cầu Giấy, Hà Nội',NULL,32,'active','2026-05-20 08:00:00',3,NULL,NULL),(4,'Linh Hoàng','0981059011','linhlinhlinh582006@gmail.com',' Hà Nội','Linh Hoàng',33,'active','2026-06-16 21:38:16',3,'2026-06-16 21:38:16',NULL),(5,'Thị Thu Hiền Hoàng','0981059012','linhlinhlinh582006@gmail.com',' Hà Nội','',33,'active','2026-06-16 21:40:40',3,'2026-06-16 21:40:40',NULL);
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_log`
--

DROP TABLE IF EXISTS `system_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `level` enum('INFO','WARNING','ERROR') NOT NULL DEFAULT 'ERROR',
  `module` varchar(64) NOT NULL DEFAULT 'OTHER',
  `user_id` int DEFAULT NULL,
  `source` varchar(255) DEFAULT NULL,
  `message` text NOT NULL,
  `stack_trace` text,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_level_created` (`level`,`created_at`),
  KEY `idx_module` (`module`),
  KEY `idx_user_id` (`user_id`),
  CONSTRAINT `fk_systemlog_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_log`
--

LOCK TABLES `system_log` WRITE;
/*!40000 ALTER TABLE `system_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `system_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfer`
--

DROP TABLE IF EXISTS `transfer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transfer` (
  `transfer_id` int NOT NULL AUTO_INCREMENT,
  `transfer_code` varchar(50) NOT NULL,
  `source_warehouse_id` int NOT NULL,
  `dest_warehouse_id` int NOT NULL,
  `status` varchar(30) NOT NULL DEFAULT 'DRAFT',
  `created_by` int NOT NULL,
  `manager_reviewed_by` int DEFAULT NULL,
  `manager_reviewed_at` datetime DEFAULT NULL,
  `manager_note` varchar(500) DEFAULT NULL,
  `ceo_reviewed_by` int DEFAULT NULL,
  `ceo_reviewed_at` datetime DEFAULT NULL,
  `ceo_note` varchar(500) DEFAULT NULL,
  `final_reviewed_by` int DEFAULT NULL,
  `final_reviewed_at` datetime DEFAULT NULL,
  `executed_at` datetime DEFAULT NULL,
  `note` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`transfer_id`),
  UNIQUE KEY `transfer_code` (`transfer_code`),
  KEY `fk_tr_src` (`source_warehouse_id`),
  KEY `fk_tr_dst` (`dest_warehouse_id`),
  KEY `fk_tr_created` (`created_by`),
  KEY `fk_tr_mgr1` (`manager_reviewed_by`),
  KEY `fk_tr_ceo` (`ceo_reviewed_by`),
  KEY `fk_tr_final` (`final_reviewed_by`),
  CONSTRAINT `fk_tr_ceo` FOREIGN KEY (`ceo_reviewed_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_tr_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_tr_dst` FOREIGN KEY (`dest_warehouse_id`) REFERENCES `warehouse` (`warehouse_id`),
  CONSTRAINT `fk_tr_final` FOREIGN KEY (`final_reviewed_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_tr_mgr1` FOREIGN KEY (`manager_reviewed_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_tr_src` FOREIGN KEY (`source_warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer`
--

LOCK TABLES `transfer` WRITE;
/*!40000 ALTER TABLE `transfer` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfer_detail`
--

DROP TABLE IF EXISTS `transfer_detail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transfer_detail` (
  `transfer_detail_id` int NOT NULL AUTO_INCREMENT,
  `transfer_id` int NOT NULL,
  `generator_id` int NOT NULL,
  `serial_number` varchar(100) DEFAULT NULL,
  `quantity` int NOT NULL,
  `note` text,
  PRIMARY KEY (`transfer_detail_id`),
  KEY `fk_td_transfer` (`transfer_id`),
  KEY `fk_td_generator` (`generator_id`),
  CONSTRAINT `fk_td_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`),
  CONSTRAINT `fk_td_transfer` FOREIGN KEY (`transfer_id`) REFERENCES `transfer` (`transfer_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer_detail`
--

LOCK TABLES `transfer_detail` WRITE;
/*!40000 ALTER TABLE `transfer_detail` DISABLE KEYS */;
/*!40000 ALTER TABLE `transfer_detail` ENABLE KEYS */;
UNLOCK TABLES;

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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Nguyễn Văn A','vana','','vana@gmail.com','0944727281','Hà Nội','active','2026-05-16 18:57:20','2026-05-21 15:18:35',NULL,NULL),(2,'Trần Thị B','thib','123','thib@gmail.com','08467237727','Hà Nội','active','2026-05-16 18:57:20','2026-05-28 11:38:51',NULL,NULL),(3,'Admin','admin','admin123','admin@warehouse.com','0846723771','30','active','2026-05-16 18:57:20','2026-06-14 18:29:43',NULL,NULL),(4,'Nguyễn Văn Nam','salestaff1','$2a$10$zBXM5qSw.D.8QN8Kdp8FZ.SJ33GhtgKXLlRcW1rFpH0N71LoF0hAK','salestaff1@warehouse.com','0912345678','Bắc Giang','active','2026-05-21 08:00:00','2026-06-09 10:24:54',3,NULL),(5,'Trần Thị Hương','salemanager1','123','salemanager1@warehouse.com','0912345679','Hà Nội','active','2026-05-21 08:00:00','2026-05-21 15:20:58',3,NULL),(6,'Lê Văn Cường','warehousestaff1','123','warehousestaff1@warehouse.com','0912345680','Hà Nội','active','2026-05-21 08:00:00','2026-05-21 08:00:00',3,NULL),(7,'Khánh Nguyễn Văn','vanb','$2a$10$QbvQzIVNH/osQwDyFc6x3.AzYpVtYgyn6ADGSjP.DiGqKnF4eCJbq','vankhanhak54@gmail.com','0846723779','Hà Nội','active','2026-05-18 14:20:02','2026-05-21 15:18:28',1,NULL),(8,'Phạm Minh Tuấn','warehousemanager1','123','warehousemanager1@warehouse.com','0912345681','Hồ Chí Minh','active','2026-05-21 08:00:00','2026-06-05 10:39:55',3,NULL),(9,'Nguyễn Văn B','vanVB','$2a$10$RWSZe8R4XFrSUfHQe7CrYOym8.ysXZvUi3jEm.BBpcZcCrmpXIK2O','vanvb@gmail.com','0846723661','Bắc Giang','active','2026-05-22 04:02:50','2026-05-22 04:02:50',1,NULL),(10,'Khánh Nguyễn Văn','sale123_','$2a$10$XtG49C3Og360orC82gkEaOIoPTzGmx/P/YywjI5p3YLMoJpoaM0xS','khanh@gmail.com','0846723781','Hà Nội','active','2026-05-22 13:03:56','2026-05-22 13:03:56',1,NULL),(11,'1','a_v_g','$2a$10$/Lx1V/dM4vMwkRmi15zAQON4xWuYDWpFtK7y1BQCRP/1KPZ0D56WG','ABC@gmail.com','0846733771','Bắc Giang','active','2026-05-22 13:06:09','2026-05-22 17:15:52',1,NULL),(12,'Nguyen Van A','Anhcad','ncikanfc','ntf@gmail.com','0836786867','ha noi','active','2026-05-22 17:23:05','2026-05-28 17:28:27',NULL,NULL),(13,'CEO','ceo','$2a$10$fZ1zHDvp3bWhbIn/QPH5n.k3rENJEK7TAUt7WrbQ7QZvnnnnsragG','ceo@gmail.com','0846723711','30','active','2026-06-19 16:58:07','2026-06-19 16:58:07',1,NULL);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_permission`
--

DROP TABLE IF EXISTS `user_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_permission` (
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  `type` enum('GRANT','DENY') NOT NULL,
  PRIMARY KEY (`user_id`,`permission_id`),
  KEY `idx_up_permission` (`permission_id`),
  CONSTRAINT `fk_up_permission` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_up_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permission`
--

LOCK TABLES `user_permission` WRITE;
/*!40000 ALTER TABLE `user_permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_role`
--

DROP TABLE IF EXISTS `user_role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_role` (
  `user_id` int NOT NULL,
  `role_id` int NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `idx_ur_role` (`role_id`),
  CONSTRAINT `fk_ur_role` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_ur_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_role`
--

LOCK TABLES `user_role` WRITE;
/*!40000 ALTER TABLE `user_role` DISABLE KEYS */;
INSERT INTO `user_role` VALUES (3,1),(7,2),(8,2),(9,2),(1,3),(6,3),(10,3),(2,5),(4,5),(11,5),(5,10),(12,10),(13,13);
/*!40000 ALTER TABLE `user_role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `warehouse`
--

DROP TABLE IF EXISTS `warehouse`;
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

--
-- Dumping data for table `warehouse`
--

LOCK TABLES `warehouse` WRITE;
/*!40000 ALTER TABLE `warehouse` DISABLE KEYS */;
INSERT INTO `warehouse` VALUES (1,'Kho Hà Nội','123 Nguyễn Trãi, Thanh Xuân, Hà Nội','Kho chính miền Bắc','active','2026-05-20 08:00:00','2026-06-19 16:44:12'),(2,'Kho Hồ Chí Minh','456 Lê Lợi, Quận 1, TP. Hồ Chí Minh','Kho chính miền Nam','active','2026-05-20 08:00:00','2026-06-19 16:43:39');
/*!40000 ALTER TABLE `warehouse` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-20 21:28:47
