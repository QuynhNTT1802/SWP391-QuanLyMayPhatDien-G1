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
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
INSERT INTO `activity_log` VALUES (1,3,'supplier','UPDATE',2,'Trần Thị Thảo','Cập nhật thông tin nhà cung cấp: Trần Thị Thảo','2026-07-21 01:18:36'),(2,3,'supplier','UPDATE',4,'Phạm Đức Anh','Cập nhật thông tin nhà cung cấp: Phạm Đức Anh','2026-07-21 01:18:42'),(3,3,'supplier','UPDATE',6,'Phan Thanh Sơn','Cập nhật thông tin nhà cung cấp: Phan Thanh Sơn','2026-07-21 01:18:47'),(4,3,'supplier','UPDATE',8,'Đặng Quốc Dũng','Cập nhật thông tin nhà cung cấp: Đặng Quốc Dũng','2026-07-21 01:18:52'),(5,3,'supplier','UPDATE',10,'Bùi Minh Tuấn','Cập nhật thông tin nhà cung cấp: Bùi Minh Tuấn','2026-07-21 01:18:58'),(6,3,'supplier','UPDATE',12,'Nguyễn Hải Vinh','Cập nhật thông tin nhà cung cấp: Nguyễn Hải Vinh','2026-07-21 01:19:05'),(7,3,'supplier','UPDATE',14,'Lê Mai Phương','Cập nhật thông tin nhà cung cấp: Lê Mai Phương','2026-07-21 01:19:13'),(8,3,'import_proposal','CREATE',1,'PRC-20260721-001','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:21:51'),(9,3,'import_proposal','APPROVE',1,'PRC-20260721-001','Duyệt phiếu đề xuất','2026-07-21 01:21:55'),(10,3,'receipt','CREATE',1,'RX-IM-20260804-656','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-04 01:26:07'),(11,3,'import_proposal','CREATE',2,'PRC-20260721-002','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:28:41'),(12,3,'import_proposal','APPROVE',2,'PRC-20260721-002','Duyệt phiếu đề xuất','2026-07-21 01:28:45'),(13,3,'import_proposal','CREATE',3,'PRC-20260721-003','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:29:33'),(14,3,'import_proposal','APPROVE',3,'PRC-20260721-003','Duyệt phiếu đề xuất','2026-07-21 01:29:37'),(15,3,'import_proposal','CREATE',4,'PRC-20260721-004','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:30:53'),(16,3,'import_proposal','APPROVE',4,'PRC-20260721-004','Duyệt phiếu đề xuất','2026-07-21 01:30:56'),(17,3,'import_proposal','CREATE',5,'PRC-20260721-005','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:31:47'),(18,3,'import_proposal','APPROVE',5,'PRC-20260721-005','Duyệt phiếu đề xuất','2026-07-21 01:31:49'),(19,3,'import_proposal','CREATE',6,'PRC-20260721-006','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:32:46'),(20,3,'import_proposal','APPROVE',6,'PRC-20260721-006','Duyệt phiếu đề xuất','2026-07-21 01:32:48'),(21,3,'import_proposal','CREATE',7,'PRC-20260721-007','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:33:32'),(22,3,'import_proposal','APPROVE',7,'PRC-20260721-007','Duyệt phiếu đề xuất','2026-07-21 01:33:35'),(23,3,'import_proposal','CREATE',8,'PRC-20260721-008','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:34:23'),(24,3,'import_proposal','APPROVE',8,'PRC-20260721-008','Duyệt phiếu đề xuất','2026-07-21 01:34:25'),(25,3,'import_proposal','CREATE',9,'PRC-20260721-009','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:35:05'),(26,3,'import_proposal','APPROVE',9,'PRC-20260721-009','Duyệt phiếu đề xuất','2026-07-21 01:35:08'),(27,3,'import_proposal','CREATE',10,'PRC-20260721-010','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:35:58'),(28,3,'import_proposal','APPROVE',10,'PRC-20260721-010','Duyệt phiếu đề xuất','2026-07-21 01:36:01'),(29,3,'import_proposal','CREATE',11,'PRC-20260721-011','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 01:36:37'),(30,3,'import_proposal','APPROVE',11,'PRC-20260721-011','Duyệt phiếu đề xuất','2026-07-21 01:36:39'),(31,3,'receipt','CREATE',2,'RX-IM-20260801-030','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-01 01:40:31'),(32,3,'receipt','CREATE',3,'RX-IM-20260805-172','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-05 01:46:21'),(33,3,'receipt','CREATE',4,'RX-IM-20260805-774','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-05 01:47:08'),(34,3,'receipt','CREATE',5,'RX-IM-20260805-153','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-05 01:48:02'),(35,3,'receipt','CREATE',6,'RX-IM-20260805-563','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-05 01:49:11'),(36,3,'receipt','CREATE',7,'RX-IM-20260805-180','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-05 01:51:20'),(37,3,'receipt','CREATE',8,'RX-IM-20260805-749','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-05 01:53:23'),(38,3,'receipt','CREATE',9,'RX-EX-20260807-929','Tạo phiếu xuất kho và cập nhật tồn kho','2026-08-07 02:02:42'),(39,3,'receipt','CREATE',10,'RX-EX-20260807-429','Tạo phiếu xuất kho và cập nhật tồn kho','2026-08-07 02:03:22'),(40,3,'import_proposal','CREATE',12,'PRC-20260802-001','Tạo phiếu đề xuất (gửi duyệt)','2026-08-02 02:05:33'),(41,3,'import_proposal','APPROVE',12,'PRC-20260802-001','Duyệt phiếu đề xuất','2026-08-02 02:05:37'),(42,3,'import_proposal','CREATE',13,'PRC-20260723-001','Tạo phiếu đề xuất (gửi duyệt)','2026-07-23 02:06:29'),(43,3,'import_proposal','APPROVE',13,'PRC-20260723-001','Duyệt phiếu đề xuất','2026-07-23 02:06:33'),(44,3,'receipt','CREATE',11,'RX-IM-20260804-186','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-04 02:07:51'),(45,3,'receipt','CREATE',12,'RX-EX-20260807-673','Tạo phiếu xuất kho và cập nhật tồn kho','2026-08-07 02:09:12'),(46,3,'receipt','CREATE',13,'RX-EX-20260807-756','Tạo phiếu xuất kho và cập nhật tồn kho','2026-08-07 02:10:16'),(47,3,'receipt','CREATE',14,'RX-EX-20260807-626','Tạo phiếu xuất kho và cập nhật tồn kho','2026-08-07 02:10:47'),(48,3,'inventory_check','CREATE',1,'IC-20260721-130','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-21 02:12:04'),(49,3,'inventory_check','UPDATE',1,'IC-20260721-130','Cập nhật số lượng kiểm kê','2026-07-21 02:12:31'),(50,3,'inventory_check','COMPLETE',1,'IC-20260721-130','Hoàn thành kiểm kê','2026-07-21 02:12:36'),(51,3,'inventory_check','CREATE',2,'IC-20260721-749','Tạo phiếu kiểm kê tại kho Kho Hồ Chí Minh','2026-07-21 02:14:43'),(52,3,'inventory_check','UPDATE',2,'IC-20260721-749','Cập nhật số lượng kiểm kê','2026-07-21 02:15:04'),(53,3,'inventory_check','COMPLETE',2,'IC-20260721-749','Hoàn thành kiểm kê','2026-07-21 02:15:07'),(54,3,'generator','UPDATE',6,'GEN83D2K','Cập nhật thông tin máy phát điện: GEN83D2K','2026-07-21 13:31:26'),(55,3,'generator','UPDATE',7,'XP921L4M','Cập nhật thông tin máy phát điện: XP921L4M','2026-07-21 13:39:09'),(56,3,'generator','UPDATE',8,'KJR7392N','Cập nhật thông tin máy phát điện: KJR7392N','2026-07-21 13:39:20'),(57,3,'generator','UPDATE',9,'PLX4821A','Cập nhật thông tin máy phát điện: PLX4821A','2026-07-21 13:40:03'),(58,3,'generator','UPDATE',10,'ZMT9012B','Cập nhật thông tin máy phát điện: ZMT9012B','2026-07-21 13:40:15'),(59,3,'generator','UPDATE',11,'VQP3821C','Cập nhật thông tin máy phát điện: VQP3821C','2026-07-21 13:40:28'),(60,3,'generator','UPDATE',12,'NKW8472D','Cập nhật thông tin máy phát điện: NKW8472D','2026-07-21 13:40:47'),(61,3,'generator','UPDATE',13,'BFT2941E','Cập nhật thông tin máy phát điện: BFT2941E','2026-07-21 13:41:09'),(62,3,'generator','UPDATE',14,'MXR7381F','Cập nhật thông tin máy phát điện: MXR7381F','2026-07-21 13:41:21'),(63,3,'generator','UPDATE',15,'QWD9284G','Cập nhật thông tin máy phát điện: QWD9284G','2026-07-21 13:41:33'),(64,3,'generator','UPDATE',16,'LKB3812H','Cập nhật thông tin máy phát điện: LKB3812H','2026-07-21 13:41:59'),(65,3,'generator','UPDATE',17,'HFX4921J','Cập nhật thông tin máy phát điện: HFX4921J','2026-07-21 13:42:13'),(66,3,'generator','UPDATE',18,'GMC8392K','Cập nhật thông tin máy phát điện: GMC8392K','2026-07-21 13:42:26'),(67,3,'generator','UPDATE',19,'TNY2841L','Cập nhật thông tin máy phát điện: TNY2841L','2026-07-21 13:42:38'),(68,3,'generator','UPDATE',20,'WRE3821M','Cập nhật thông tin máy phát điện: WRE3821M','2026-07-21 13:42:53'),(69,3,'generator','UPDATE',21,'YUP9284N','Cập nhật thông tin máy phát điện: YUP9284N','2026-07-21 13:43:05'),(70,3,'generator','UPDATE',22,'CHJ3812P','Cập nhật thông tin máy phát điện: CHJ3812P','2026-07-21 13:43:25'),(71,3,'generator','UPDATE',23,'SDF4921Q','Cập nhật thông tin máy phát điện: SDF4921Q','2026-07-21 13:43:38'),(72,3,'generator','UPDATE',24,'VGT8392R','Cập nhật thông tin máy phát điện: VGT8392R','2026-07-21 13:43:52'),(73,3,'generator','UPDATE',25,'MKL2841S','Cập nhật thông tin máy phát điện: MKL2841S','2026-07-21 13:44:04'),(74,3,'generator','UPDATE',4,'C10D5','Cập nhật thông tin máy phát điện: C10D5','2026-07-21 13:44:15'),(75,3,'import_proposal','CREATE',14,'PRC-21/07/2026-012','Tạo phiếu đề xuất (gửi duyệt)','2026-07-21 14:21:58'),(76,3,'import_proposal','APPROVE',14,'PRC-21/07/2026-012','Duyệt phiếu đề xuất','2026-07-21 14:22:13'),(77,3,'receipt','CREATE',15,'RX-IM-20260804-055','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-04 14:39:16'),(78,3,'import_proposal','CREATE',15,'PRC-04/08/2026-001','Tạo phiếu đề xuất (gửi duyệt)','2026-08-04 14:40:04'),(79,3,'import_proposal','APPROVE',15,'PRC-04/08/2026-001','Duyệt phiếu đề xuất','2026-08-04 14:40:07'),(80,3,'receipt','CREATE',16,'RX-IM-20260904-586','Tạo phiếu nhập kho và cập nhật tồn kho','2026-09-04 14:44:09'),(81,3,'generator','UPDATE',6,'Cummins GEN83D2K','Cập nhật thông tin máy phát điện: Cummins GEN83D2K','2026-07-23 13:11:13'),(82,3,'generator','UPDATE',7,'Honda XP921L4M','Cập nhật thông tin máy phát điện: Honda XP921L4M','2026-07-23 13:11:19'),(83,3,'generator','UPDATE',8,'Hyundai KJR7392N','Cập nhật thông tin máy phát điện: Hyundai KJR7392N','2026-07-23 13:11:29'),(84,3,'generator','UPDATE',9,'Mitsubishi PLX4821A','Cập nhật thông tin máy phát điện: Mitsubishi PLX4821A','2026-07-23 13:11:47'),(85,3,'generator','UPDATE',10,'Yamaha ZMT9012B','Cập nhật thông tin máy phát điện: Yamaha ZMT9012B','2026-07-23 13:11:58'),(86,3,'generator','UPDATE',11,'Cummins VQP3821C','Cập nhật thông tin máy phát điện: Cummins VQP3821C','2026-07-23 13:12:05'),(87,3,'generator','UPDATE',12,'Honda NKW8472D','Cập nhật thông tin máy phát điện: Honda NKW8472D','2026-07-23 13:12:11'),(88,3,'generator','UPDATE',13,'Hyundai BFT2941E','Cập nhật thông tin máy phát điện: Hyundai BFT2941E','2026-07-23 13:12:20'),(89,3,'generator','UPDATE',15,'Yamaha QWD9284G','Cập nhật thông tin máy phát điện: Yamaha QWD9284G','2026-07-23 13:12:29'),(90,3,'generator','UPDATE',14,'Mitsubishi MXR7381F','Cập nhật thông tin máy phát điện: Mitsubishi MXR7381F','2026-07-23 13:12:38'),(91,3,'generator','UPDATE',16,'Mitsubishi LKB3812H','Cập nhật thông tin máy phát điện: Mitsubishi LKB3812H','2026-07-23 13:12:56'),(92,3,'generator','UPDATE',17,'Mitsubishi HFX4921J','Cập nhật thông tin máy phát điện: Mitsubishi HFX4921J','2026-07-23 13:13:06'),(93,3,'generator','UPDATE',18,'Yamaha GMC8392K','Cập nhật thông tin máy phát điện: Yamaha GMC8392K','2026-07-23 13:13:16'),(94,3,'generator','UPDATE',19,'Cummins TNY2841L','Cập nhật thông tin máy phát điện: Cummins TNY2841L','2026-07-23 13:13:25'),(95,3,'generator','UPDATE',23,'Hyundai SDF4921Q','Cập nhật thông tin máy phát điện: Hyundai SDF4921Q','2026-07-23 13:13:34'),(96,3,'generator','UPDATE',22,'Honda CHJ3812P','Cập nhật thông tin máy phát điện: Honda CHJ3812P','2026-07-23 13:13:42'),(97,3,'generator','UPDATE',25,'Yamaha MKL2841S','Cập nhật thông tin máy phát điện: Yamaha MKL2841S','2026-07-23 13:13:52'),(98,3,'generator','UPDATE',21,'Hyundai YUP9284N','Cập nhật thông tin máy phát điện: Hyundai YUP9284N','2026-07-23 13:14:00'),(99,3,'generator','UPDATE',20,'Mitsubishi WRE3821M','Cập nhật thông tin máy phát điện: Mitsubishi WRE3821M','2026-07-23 13:14:11'),(100,3,'generator','UPDATE',24,'Cummins VGT8392R','Cập nhật thông tin máy phát điện: Cummins VGT8392R','2026-07-23 13:14:20'),(101,3,'generator','UPDATE',1,'Honda EG4500CX','Cập nhật thông tin máy phát điện: Honda EG4500CX','2026-07-23 13:14:31'),(102,3,'generator','UPDATE',2,'Yamaha EF6000','Cập nhật thông tin máy phát điện: Yamaha EF6000','2026-07-23 13:15:11'),(103,3,'generator','UPDATE',3,'Hyundai DHY8000','Cập nhật thông tin máy phát điện: Hyundai DHY8000','2026-07-23 13:15:19'),(104,3,'generator','UPDATE',4,'Honda C10D5','Cập nhật thông tin máy phát điện: Honda C10D5','2026-07-23 13:15:29'),(105,3,'generator','UPDATE',5,'Mitsubishi MGP-15','Cập nhật thông tin máy phát điện: Mitsubishi MGP-15','2026-07-23 13:15:41'),(106,3,'user','UPDATE',14,'Nguyễn Thị B','Cập nhật người dùng #14 (Nguyễn Thị B): roles: +sales_staff; permissions: +orders.view=GRANT; +orders.create=GRANT; +orders.update=GRANT; +orders.cancel=GRANT; +dashboard.view=GRANT; +profile.view=GRANT; +profile.edit=GRANT; +password.change=GRANT; +forgot_pw.process=GRANT; +activity_log.view=GRANT; +customers.view=GRANT; +customers.create=GRANT; +customers.update=GRANT; +customers.deactivate=GRANT; +proposals.view=GRANT; +proposals.create=GRANT; +proposals.update=GRANT; +proposals.cancel=GRANT; +suppliers.view=GRANT; +suppliers.create=GRANT; +suppliers.update=GRANT; +suppliers.deactivate=GRANT','2026-07-27 10:51:37'),(107,14,'import_proposal','CREATE',16,'PRC-20260524-001','Tạo phiếu đề xuất (gửi duyệt)','2026-05-24 10:52:51'),(108,14,'import_proposal','CREATE',17,'PRC-20260525-001','Tạo phiếu đề xuất (gửi duyệt)','2026-05-25 10:55:24'),(109,14,'import_proposal','CREATE',18,'PRC-20260526-001','Tạo phiếu đề xuất (gửi duyệt)','2026-05-26 10:57:21'),(110,14,'import_proposal','CREATE',19,'PRC-20260527-001','Tạo phiếu đề xuất (gửi duyệt)','2026-05-27 10:58:07'),(111,5,'import_proposal','APPROVE',19,'PRC-20260527-001','Duyệt phiếu đề xuất','2026-05-27 11:08:59'),(112,5,'import_proposal','APPROVE',18,'PRC-20260526-001','Duyệt phiếu đề xuất','2026-05-27 11:09:14'),(113,5,'import_proposal','APPROVE',16,'PRC-20260524-001','Duyệt phiếu đề xuất','2026-05-27 11:09:26'),(114,5,'import_proposal','APPROVE',17,'PRC-20260525-001','Duyệt phiếu đề xuất','2026-05-27 11:09:35'),(115,3,'user','UPDATE',15,'Nguyễn Linh','Cập nhật người dùng #15 (Nguyễn Linh): phone: \"\" → \"0861235469\"; address: \"\" → \"\"; roles: +sales_staff; permissions: +generators.view=GRANT; +generators.create=GRANT; +generators.update=GRANT; +inventory.view=GRANT; +orders.view=GRANT; +orders.create=GRANT; +orders.update=GRANT; +orders.cancel=GRANT; +dashboard.view=GRANT; +profile.view=GRANT; +profile.edit=GRANT; +password.change=GRANT; +forgot_pw.process=GRANT; +activity_log.view=GRANT; +customers.view=GRANT; +customers.create=GRANT; +customers.update=GRANT; +customers.deactivate=GRANT; +proposals.view=GRANT; +proposals.create=GRANT; +proposals.update=GRANT; +proposals.cancel=GRANT; +suppliers.view=GRANT; +suppliers.create=GRANT; +suppliers.update=GRANT; +suppliers.deactivate=GRANT','2026-05-13 11:15:55'),(116,14,'import_proposal','CREATE',20,'PRC-20260527-002','Tạo phiếu đề xuất (gửi duyệt)','2026-05-27 16:19:44'),(117,3,'user','UPDATE',8,'Phạm Minh Tuấn','Cập nhật người dùng #8 (Phạm Minh Tuấn): permissions: +forgot_pw.process=GRANT','2026-05-27 16:22:08'),(118,3,'user','UPDATE',8,'Phạm Minh Tuấn','Cập nhật người dùng #8 (Phạm Minh Tuấn): permissions: -forgot_pw.process=GRANT','2026-05-27 16:22:16'),(119,3,'user','UPDATE',14,'Nguyễn Thị B','Cập nhật người dùng #14 (Nguyễn Thị B): không có thay đổi','2026-07-27 16:31:24'),(120,3,'user','UPDATE',14,'Nguyễn Thị B','Cập nhật người dùng #14 (Nguyễn Thị B): không có thay đổi','2026-07-27 16:31:27'),(121,3,'user','UPDATE',8,'Phạm Minh Tuấn','Cập nhật người dùng #8 (Phạm Minh Tuấn): không có thay đổi','2026-07-27 16:33:00'),(122,3,'user','UPDATE',8,'Phạm Minh Tuấn','Cập nhật người dùng #8 (Phạm Minh Tuấn): không có thay đổi','2026-07-27 16:35:00'),(123,3,'user','CREATE',20,'Thi C','Tạo người dùng: ThiC','2026-07-27 16:52:11'),(124,3,'user','UPDATE',20,'Thi C','Cập nhật người dùng #20 (Thi C): roles: +ceo -sale_manager','2026-07-27 16:52:28'),(125,3,'user','UPDATE_PROFILE',3,'Admin','Tự cập nhật hồ sơ: không có thay đổi','2026-07-27 16:53:50'),(126,3,'user','UPDATE_PROFILE',3,'Admin','Tự cập nhật hồ sơ: không có thay đổi','2026-07-27 16:54:39'),(127,15,'import_proposal','CREATE',21,'PRC-20260727-001','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 18:55:49'),(128,15,'import_proposal','CREATE',22,'PRC-20260727-002','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 18:56:27'),(129,14,'import_proposal','CREATE',23,'PRC-20260727-003','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 18:59:17'),(130,14,'import_proposal','CREATE',24,'PRC-20260727-004','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 18:59:46'),(131,14,'import_proposal','CREATE',25,'PRC-20260727-005','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 19:00:21'),(132,14,'import_proposal','CREATE',26,'PRC-20260727-006','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 19:01:04'),(133,14,'import_proposal','CREATE',27,'PRC-20260727-007','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 19:01:35'),(134,15,'import_proposal','CREATE',28,'PRC-20260727-008','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 19:02:06'),(135,15,'import_proposal','CREATE',29,'PRC-20260727-009','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 19:02:31'),(136,15,'import_proposal','CREATE',30,'PRC-20260727-010','Tạo phiếu đề xuất (gửi duyệt)','2026-07-27 19:02:52'),(137,15,'import_proposal','CREATE',31,'PRC-20260613-001','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:03:54'),(138,15,'import_proposal','CREATE',32,'PRC-20260613-002','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:04:12'),(139,15,'import_proposal','CREATE',33,'PRC-20260613-003','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:04:40'),(140,15,'import_proposal','CREATE',34,'PRC-20260613-004','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:05:12'),(141,15,'import_proposal','CREATE',35,'PRC-20260613-005','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:05:42'),(142,14,'import_proposal','CREATE',36,'PRC-20260613-006','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:06:47'),(143,14,'import_proposal','CREATE',37,'PRC-20260613-007','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:07:04'),(144,14,'import_proposal','CREATE',38,'PRC-20260613-008','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:07:20'),(145,14,'import_proposal','CREATE',39,'PRC-20260613-009','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:07:43'),(146,14,'import_proposal','CREATE',40,'PRC-20260613-010','Tạo phiếu đề xuất (gửi duyệt)','2026-06-13 19:08:09'),(147,14,'import_proposal','CREATE',41,'PRC-20260513-001','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:08:50'),(148,14,'import_proposal','CREATE',42,'PRC-20260513-002','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:09:13'),(149,14,'import_proposal','CREATE',43,'PRC-20260513-003','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:09:46'),(150,14,'import_proposal','CREATE',44,'PRC-20260513-004','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:10:03'),(151,14,'import_proposal','CREATE',45,'PRC-20260513-005','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:10:18'),(152,14,'import_proposal','CREATE',46,'PRC-20260513-006','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:10:32'),(153,15,'import_proposal','CREATE',47,'PRC-20260513-007','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:11:03'),(154,15,'import_proposal','CREATE',48,'PRC-20260513-008','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:11:16'),(155,15,'import_proposal','CREATE',49,'PRC-20260513-009','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:11:27'),(156,15,'import_proposal','CREATE',50,'PRC-20260513-010','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:11:41'),(157,15,'import_proposal','CREATE',51,'PRC-20260513-011','Tạo phiếu đề xuất (gửi duyệt)','2026-05-13 19:12:01'),(158,15,'import_proposal','CREATE',52,'PRC-20260520-001','Tạo phiếu đề xuất (gửi duyệt)','2026-05-20 19:16:29'),(159,15,'import_proposal','CREATE',53,'PRC-20260520-002','Tạo phiếu đề xuất (gửi duyệt)','2026-05-20 19:17:03'),(160,14,'import_proposal','CREATE',54,'PRC-20260520-003','Tạo phiếu đề xuất (gửi duyệt)','2026-05-20 19:17:38'),(161,5,'import_proposal','APPROVE',41,'PRC-20260513-001','Duyệt phiếu đề xuất','2026-06-04 19:21:57'),(162,5,'import_proposal','APPROVE',42,'PRC-20260513-002','Duyệt phiếu đề xuất','2026-06-04 19:22:49');
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
) ENGINE=InnoDB AUTO_INCREMENT=87 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'quản lý vật tư','Honda','brand','Hãng sản xuất máy phát điện Honda','active','2026-05-23 19:15:54','2026-05-27 22:41:32'),(2,'quản lý vật tư','Yamaha','brand','Hãng sản xuất máy phát điện Yamaha','active','2026-05-23 19:15:54','2026-05-27 22:41:54'),(3,'quản lý vật tư','Hyundai','brand','Hãng sản xuất máy phát điện Hyundai','active','2026-05-23 19:15:54','2026-05-27 22:41:40'),(4,'quản lý vật tư','Cummins','brand','Hãng sản xuất máy phát điện Cummins','active','2026-05-23 19:15:54','2026-05-30 08:40:53'),(5,'quản lý vật tư','Xăng','fuel_type','Máy phát điện chạy xăng','active','2026-05-23 19:15:54','2026-05-28 08:09:36'),(6,'quản lý vật tư','Dầu Diesel','fuel_type','Máy phát điện chạy dầu diesel','active','2026-05-23 19:15:54','2026-05-29 09:58:26'),(11,'quản lý vật tư','Inverter','generator_type','Máy phát điện Inverter','active','2026-05-23 19:15:54',NULL),(12,'quản lý vật tư','Công nghiệp','generator_type','Máy phát điện công nghiệp','active','2026-05-23 19:15:54',NULL),(13,'quản lý vật tư','Dân dụng','generator_type','Máy phát điện dân dụng','active','2026-05-23 19:15:54',NULL),(14,'quản lý vật tư','1 pha','phase','Máy phát điện 1 pha','active','2026-05-23 19:15:54',NULL),(15,'quản lý vật tư','3 pha','phase','Máy phát điện 3 pha','active','2026-05-23 19:15:54',NULL),(16,'quản lý vật tư','Mới','condition','Máy mới 100%','active','2026-05-23 19:15:54','2026-06-01 07:12:11'),(17,'quản lý vật tư','Đã qua sử dụng','condition','Máy đã qua sử dụng','active','2026-05-23 19:15:54','2026-05-27 22:46:02'),(18,'quản lý vật tư','Nhật Bản','origin','Xuất xứ Nhật Bản','active','2026-05-23 19:15:54',NULL),(19,'quản lý vật tư','Trung Quốc','origin','Xuất xứ Trung Quốc','active','2026-05-23 19:15:54',NULL),(20,'quản lý vật tư','Việt Nam','origin','Xuất xứ Việt Nam','active','2026-05-23 19:15:54',NULL),(21,'quản lý vật tư','Hàn Quốc','origin','Xuất xứ Hàn Quốc','active','2026-05-23 19:15:54','2026-06-01 07:12:34'),(22,'quản lý vật tư','Mỹ','origin','Xuất xứ Mỹ','active','2026-05-23 19:15:54',NULL),(25,'quản lý phiếu xuất nhập','Bảo hành','receipt_reason','Bảo hành sản phẩm','active','2026-05-28 04:28:53','2026-06-01 08:32:47'),(26,'quản lý phiếu xuất nhập','Bảo trì','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(27,'quản lý phiếu xuất nhập','Hư hỏng','receipt_reason','','active','2026-05-28 04:28:53','2026-05-28 08:07:58'),(28,'quản lý phiếu xuất nhập','Hết hạn sử dụng','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(29,'quản lý phiếu xuất nhập','Điều chuyển kho','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(30,'quản lý phiếu xuất nhập','Thanh lý','receipt_reason','','active','2026-05-28 04:28:53','2026-07-20 08:39:32'),(31,'quản lý phiếu xuất nhập','Khác','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(32,'quản lý phiếu mua bán','Cá nhân','customer_type','Khách hàng cá nhân','active','2026-05-23 19:15:54','2026-05-27 22:49:17'),(33,'quản lý phiếu mua bán','Doanh nghiệp','customer_type','Khách hàng doanh nghiệp','active','2026-05-23 19:15:54',NULL),(34,'quản lý kiểm kê','Hao hụt','adjust_reason','Lý do hao hụt','active','2026-05-23 19:15:54',NULL),(35,'quản lý kiểm kê','Hư hỏng','adjust_reason','Lý do hư hỏng','active','2026-05-23 19:15:54',NULL),(36,'quản lý kiểm kê','Điều chỉnh khác','adjust_reason','Lý do điều chỉnh khác','active','2026-05-23 19:15:54',NULL),(44,'quản lý vật tư','Mitsubishi','brand','H?ng s?n xu?t m?y ph?t ?i?n Mitsubishi','active','2026-05-26 21:07:30','2026-05-27 22:41:47'),(68,'quản lý phiếu mua bán','Nhà nước','customer_type','Nhà nước tài trợ','active','2026-05-27 22:49:02','2026-05-27 22:49:02'),(70,'quản lý thanh lý','Máy quá cũ, hỏng nặng','liquidation_reason','Máy đã sử dụng lâu năm, không thể sửa chữa','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(71,'quản lý thanh lý','Chi phí sửa chữa quá cao','liquidation_reason','Chi phí bảo trì tốn kém hơn mua máy mới','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(72,'quản lý thanh lý','Thay đổi mục đích sử dụng','liquidation_reason','Không còn nhu cầu sử dụng loại máy này','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(77,'quản lý thanh lý','Không được phép thanh lý lúc này','ceo_reject_reason','Không được phép thanh lý lúc này','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(78,'quản lý thanh lý','Sai chiến lược giá','ceo_reject_reason','Sai chiến lược giá','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(79,'quản lý thanh lý','Cần xem xét lại giá thấp nhất','ceo_request_edit_reason','Cần xem xét lại giá thấp nhất','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(80,'quản lý thanh lý','Yêu cầu bổ sung chứng từ','ceo_request_edit_reason','Yêu cầu bổ sung chứng từ','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(82,'quản lý phiếu xuất nhập','Xuất kho','receipt_reason','','active','2026-06-25 18:53:46','2026-06-25 18:53:46'),(83,'quản lý phiếu xuất nhập','Nhập kho','receipt_reason','','active','2026-06-25 18:53:56','2026-06-25 18:53:56'),(85,'quản lý phiếu xuất nhập','Nhập bù','receipt_reason','','active','2026-07-20 07:46:01','2026-07-20 07:46:01'),(86,'quản lý phiếu xuất nhập','Xuất bù','receipt_reason','','active','2026-07-20 07:46:08','2026-07-20 07:46:08');
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
INSERT INTO `category_brand` VALUES (1,'Nhật Bản','honda.com.vn',1948,12),(2,'Nhật Bản','yamaha-motor.com.vn',1955,12),(3,'Hàn Quốc','hyundai.com',1967,12),(4,'Mĩ','cummins.com',1919,26),(44,'Nhật Bản','mitsubishi.com',1870,12);
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
INSERT INTO `category_generator_type` VALUES (11),(12),(13);
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
INSERT INTO `category_phase` VALUES (14),(15);
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
INSERT INTO `category_receipt_reason` VALUES (25),(26),(27),(28),(29),(30),(31),(82),(83),(85),(86);
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quản lý thông tin khách hàng';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Công ty TNHH Xây Dựng ABC','0988123456','abc@xaydungabc.com','12 Trần Duy Hưng, Cầu Giấy, Hà Nội','Công ty TNHH Xây Dựng ABC',33,'active','2026-05-21 09:00:00',4,'2026-05-13 11:20:12',15),(2,'Công ty CP Điện Máy XYZ','0977123456','xyz@dienmayxyz.com','56 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh','Công ty CP Điện Máy XYZ',33,'active','2026-05-21 10:00:00',4,'2026-09-04 14:54:27',3),(6,'Linh Hoàng','0978287102','123@gmail.com',' Hà Nội','',32,'active','2026-06-07 15:36:06',3,'2026-05-13 11:21:12',15),(7,'Thị Thu Hiền Hoàng','0981059011','12345@gmail.com','Hà Nội','',32,'active','2026-06-09 12:07:22',3,'2026-06-09 12:07:22',NULL),(8,'Nguyễn Văn Khánh','02938434','vankhan@gmail.com','23434','FPT University',32,'active','2026-06-19 15:14:36',3,'2026-06-19 15:14:36',NULL),(9,'Khánh Nguyễn Văn','0846723234','vankhanhak54@gmail.com','TP HN','FPT University',32,'active','2026-06-19 15:28:34',3,'2026-05-13 11:20:54',15),(10,'Khánh Nguyễn Văn','0846723771','vankhanhak54@gmail.com','TP HN','FPT University',32,'active','2026-06-19 15:29:38',3,'2026-06-19 15:29:37',NULL),(11,'Nguyễn Văn Bình','0912345678','binhnv@gmail.com','Số 12, Ngõ 45, Đường Cầu Giấy, Quận Cầu Giấy, Hà Nội','Công ty TNHH Công nghệ Viettel',32,'active','2026-07-21 01:16:35',3,'2026-07-21 01:16:35',NULL),(12,'Trần Thị Thảo','0987654321','thaott@gmail.com','Tòa nhà Landmark 81, Phường 22, Quận Bình Thạnh, TP. Hồ Chí Minh','Tập đoàn FPT',33,'active','2026-07-21 01:16:35',3,'2026-07-21 02:00:13',3),(13,'Lê Minh Hùng','0905123456','hunglm@gmail.com','Số 88, Đường Nguyễn Văn Linh, Quận Hải Châu, Đà Nẵng','Công ty Cổ phần MISA',32,'active','2026-07-21 01:16:35',3,'2026-07-21 01:16:35',NULL),(14,'Phạm Đức Anh','0934567890','anhpd@gmail.com','Khu đô thị mới Mỹ Đình 2, Quận Nam Từ Liêm, Hà Nội','Tổng Công ty VNPT',32,'active','2026-07-21 01:16:35',3,'2026-07-21 01:16:35',NULL),(15,'Hoàng Thu Linh','0971234567','linhht@gmail.com','Số 154, Đường Trần Hưng Đạo, Quận 1, TP. Hồ Chí Minh','Ngân hàng Vietcombank',33,'active','2026-07-21 01:16:35',3,'2026-05-27 16:17:00',15),(16,'Phan Thanh Sơn','0968888999','sonpt@gmail.com','Số 45, Đường Lê Lợi, Quận Ngô Quyền, Hải Phòng','Tập đoàn Vingroup',33,'active','2026-07-21 01:16:35',3,'2026-07-21 01:16:35',NULL),(17,'Vũ Ngọc Hương','0945678123','huongvn@gmail.com','Số 23, Đại lộ Bình Dương, Thủ Dầu Một, Bình Dương','Công ty Cổ phần Vinamilk',33,'active','2026-07-21 01:16:35',3,'2026-05-27 16:18:46',15),(18,'Đặng Quốc Dũng','0911223344','dungdq@gmail.com','Số 67, Đường Hùng Vương, Ninh Kiều, Cần Thơ','Tập đoàn Hòa Phát',32,'active','2026-07-21 01:16:35',3,'2026-05-13 11:19:50',15),(19,'Bùi Minh Tuấn','0988776655','tuanbm@gmail.com','Khu công nghiệp VSIP, Huyện Thủy Nguyên, Hải Phòng','Công ty TNHH Samsung Electronics',32,'active','2026-07-21 01:16:35',3,'2026-05-27 16:14:47',14),(20,'Đỗ Thị Quỳnh','0909090909','quynhdt@gmail.com','Số 10, Lý Thường Kiệt, Thành phố Huế, Thừa Thiên Huế','Tập đoàn Massan',32,'active','2026-07-21 01:16:35',3,'2026-05-27 16:18:15',15),(21,'Hoàng Văn Nam','0955556666','namhv@gmail.com','Số 56, Đường Lê Duẩn, Quận Đống Đa, Hà Nội','Công ty Cổ phần Thế giới Di động',32,'active','2026-07-21 01:16:35',3,'2026-05-13 11:20:35',15),(22,'Nguyễn Hải Vinh','0922334455','vinhnh@gmail.com','Số 78, Đường Nguyễn Trãi, Quận Thanh Xuân, Hà Nội','Tổng Công ty Bảo Việt',33,'active','2026-07-21 01:16:35',3,'2026-07-21 01:59:48',3),(23,'Trần Đại Nghĩa','0933445566','nghiatd@gmail.com','Số 234, Đường Điện Biên Phủ, Quận 3, TP. Hồ Chí Minh','Ngân hàng Techcombank',32,'active','2026-07-21 01:16:35',3,'2026-07-21 01:16:35',NULL),(24,'Lê Mai Phương','0977889900','phuonglm@gmail.com','Số 12, Đường Hoàng Văn Thụ, Thành phố Thái Nguyên','Công ty Cổ phần PNJ',33,'active','2026-07-21 01:16:35',3,'2026-07-21 01:16:35',NULL),(25,'Phạm Hồng Nhung','0966554433','nhunghp@gmail.com','Số 89, Đường Hùng Vương, Thành phố Tuy Hòa, Phú Yên','Tập đoàn Geleximco',32,'active','2026-07-21 01:16:35',3,'2026-07-21 01:16:35',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generator`
--

LOCK TABLES `generator` WRITE;
/*!40000 ALTER TABLE `generator` DISABLE KEYS */;
INSERT INTO `generator` VALUES (1,'Honda EG4500CX',4.50,'50Hz',85.00,'Máy phát điện Honda 4.5kVA, chạy xăng, 1 pha','active','2026-05-20 08:00:00','2026-07-23 13:14:31',NULL,1),(2,'Yamaha EF6000',6.00,'',NULL,'Máy phát điện Yamaha 6.0kVA, chạy xăng, 1 pha','active','2026-05-20 08:00:00','2026-07-23 13:15:10',NULL,1),(3,'Hyundai DHY8000',8.00,'',NULL,'Máy phát điện Hyundai 8.0kVA, chạy dầu diesel, 3 pha','locked','2026-05-20 08:00:00','2026-07-23 13:15:19',NULL,1),(4,'Honda C10D5',10.00,'',NULL,'Máy phát điện Cummins 10kVA, chạy dầu diesel, 3 pha','active','2026-05-20 08:00:00','2026-07-23 13:15:29',NULL,1),(5,'Mitsubishi MGP-15',15.00,'',NULL,'Máy phát điện Mitsubishi 15kVA, chạy dầu diesel, 3 pha','active','2026-05-20 08:00:00','2026-07-23 13:15:41',NULL,1),(6,'Cummins GEN83D2K',150.00,'50Hz',450.00,'Máy phát điện công nghiệp công suất vừa, hoạt động ổn định.','active','2026-07-21 01:10:03','2026-07-23 13:11:12',8,1),(7,'Honda XP921L4M',220.00,'60Hz',580.00,'Thích hợp cho các công trình xây dựng nhỏ và vừa.','active','2026-07-21 01:10:03','2026-07-23 13:11:19',8,1),(8,'Hyundai KJR7392N',85.00,'50Hz',210.00,'Thiết kế nhỏ gọn, dễ dàng di chuyển, tiết kiệm nhiên liệu.','active','2026-07-21 01:10:03','2026-07-23 13:11:29',8,1),(9,'Mitsubishi PLX4821A',500.00,'50Hz',1200.00,'Công suất lớn phục vụ cho tòa nhà và nhà xưởng.','active','2026-07-21 01:10:03','2026-07-23 13:11:47',8,1),(10,'Yamaha ZMT9012B',110.00,'50Hz',320.00,'Độ ồn thấp, thân thiện với môi trường xung quanh.','active','2026-07-21 01:10:03','2026-07-23 13:11:57',8,1),(11,'Cummins VQP3821C',300.00,'60Hz',850.00,'Hệ thống tản nhiệt nước hiện đại, hiệu suất cao.','active','2026-07-21 01:10:03','2026-07-23 13:12:05',8,1),(12,'Honda NKW8472D',45.00,'50Hz',150.00,'Dùng cho hộ gia đình lớn hoặc văn phòng nhỏ.','active','2026-07-21 01:10:03','2026-07-23 13:12:11',8,1),(13,'Hyundai BFT2941E',180.00,'50Hz',490.00,'Khởi động nhanh, chịu tải tốt trong thời gian dài.','active','2026-07-21 01:10:03','2026-07-23 13:12:20',8,1),(14,'Mitsubishi MXR7381F',650.00,'60Hz',1650.00,'Dòng máy siêu tải công nghiệp nặng.','active','2026-07-21 01:10:03','2026-07-23 13:12:38',8,1),(15,'Yamaha QWD9284G',95.00,'50Hz',240.00,'Tự động điều chỉnh điện áp (AVR) chất lượng cao.','active','2026-07-21 01:10:03','2026-07-23 13:12:29',8,1),(16,'Mitsubishi LKB3812H',130.00,'60Hz',380.00,'Vỏ chống ồn đồng bộ, thích hợp khu dân cư.','active','2026-07-21 01:10:03','2026-07-23 13:12:56',8,1),(17,'Mitsubishi HFX4921J',400.00,'50Hz',980.00,'Động cơ diesel mạnh mẽ, linh kiện nhập khẩu.','active','2026-07-21 01:10:03','2026-07-23 13:13:06',8,1),(18,'Yamaha GMC8392K',75.00,'60Hz',190.00,'Dễ dàng bảo trì và sửa chữa, chi phí vận hành thấp.','active','2026-07-21 01:10:03','2026-07-23 13:13:16',8,1),(19,'Cummins TNY2841L',250.00,'50Hz',710.00,'Bảng điều khiển kỹ thuật số hiển thị thông minh.','active','2026-07-21 01:10:03','2026-07-23 13:13:25',8,1),(20,'Mitsubishi WRE3821M',350.00,'60Hz',920.00,'Hệ thống cảnh báo an toàn khi quá tải hoặc áp suất dầu thấp.','active','2026-07-21 01:10:03','2026-07-23 13:14:11',8,1),(21,'Hyundai YUP9284N',55.00,'50Hz',165.00,'Mẫu mã cải tiến, tiết kiệm 15% nhiên liệu.','active','2026-07-21 01:10:03','2026-07-23 13:14:00',8,1),(22,'Honda CHJ3812P',800.00,'50Hz',2100.00,'Giải pháp nguồn điện dự phòng hoàn hảo cho nhà máy lớn.','active','2026-07-21 01:10:03','2026-07-23 13:13:41',8,1),(23,'Hyundai SDF4921Q',160.00,'50Hz',460.00,'Hoạt động bền bỉ trong mọi điều kiện thời tiết.','active','2026-07-21 01:10:03','2026-07-23 13:13:34',8,1),(24,'Cummins VGT8392R',120.00,'60Hz',340.00,'Thiết kế tối ưu hóa dung tích bình nhiên liệu lớn.','active','2026-07-21 01:10:03','2026-07-23 13:14:20',8,1),(25,'Yamaha MKL2841S',280.00,'50Hz',780.00,'Khung bệ chắc chắn, giảm chấn chống rung lắc hiệu quả.','active','2026-07-21 01:10:03','2026-07-23 13:13:52',8,1);
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
INSERT INTO `generator_category` VALUES (1,1),(4,1),(7,1),(12,1),(22,1),(2,2),(10,2),(15,2),(18,2),(25,2),(3,3),(8,3),(13,3),(21,3),(23,3),(6,4),(11,4),(19,4),(24,4),(1,5),(2,5),(7,5),(9,5),(13,5),(21,5),(25,5),(3,6),(4,6),(5,6),(6,6),(8,6),(10,6),(11,6),(12,6),(14,6),(15,6),(16,6),(17,6),(18,6),(19,6),(20,6),(22,6),(23,6),(24,6),(3,12),(4,12),(5,12),(6,12),(7,12),(8,12),(9,12),(10,12),(11,12),(13,12),(14,12),(18,12),(20,12),(21,12),(22,12),(23,12),(24,12),(1,13),(2,13),(12,13),(15,13),(16,13),(17,13),(19,13),(25,13),(1,14),(2,14),(6,14),(8,14),(11,14),(12,14),(14,14),(16,14),(18,14),(20,14),(21,14),(23,14),(24,14),(25,14),(3,15),(4,15),(5,15),(7,15),(9,15),(10,15),(13,15),(15,15),(17,15),(19,15),(22,15),(1,18),(2,18),(4,18),(7,18),(9,18),(10,18),(12,18),(14,18),(15,18),(16,18),(17,18),(18,18),(20,18),(22,18),(25,18),(8,21),(13,21),(21,21),(23,21),(6,22),(11,22),(19,22),(24,22),(5,44),(9,44),(14,44),(16,44),(17,44),(20,44);
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
  `supplier_id` int DEFAULT NULL,
  `created_by` int NOT NULL,
  `approved_by` int DEFAULT NULL,
  `rejected_by` int DEFAULT NULL,
  `cancelled_by` int DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `revision_requested_by_role` varchar(20) NOT NULL DEFAULT 'SM',
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
  KEY `idx_proposal_supplier` (`supplier_id`),
  CONSTRAINT `fk_proposal_approved` FOREIGN KEY (`approved_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proposal_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_proposal_po` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_order` (`po_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proposal_rejected` FOREIGN KEY (`rejected_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proposal_supplier` FOREIGN KEY (`supplier_id`) REFERENCES `supplier` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_proposal_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_proposal`
--

LOCK TABLES `import_proposal` WRITE;
/*!40000 ALTER TABLE `import_proposal` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_proposal_detail`
--

LOCK TABLES `import_proposal_detail` WRITE;
/*!40000 ALTER TABLE `import_proposal_detail` DISABLE KEYS */;
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
  `condition` varchar(20) DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`inventory_id`),
  UNIQUE KEY `uk_inv_serial` (`serial_number`),
  KEY `idx_inv_warehouse` (`warehouse_id`),
  KEY `idx_inv_generator` (`generator_id`),
  KEY `idx_inv_status` (`status`),
  KEY `idx_inv_condition` (`condition`),
  CONSTRAINT `fk_inv_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`),
  CONSTRAINT `fk_inv_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=97 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,'GEN83D2K-2026A01',6,1,'IN_STOCK','GOOD','2026-08-04 01:26:06','2026-07-21 02:12:35'),(2,'GEN83D2K-2026A02',6,1,'SOLD',NULL,'2026-08-04 01:26:06','2026-08-07 02:02:42'),(3,'XP921L4M-2026B01',7,1,'IN_STOCK','GOOD','2026-08-04 01:26:06','2026-07-21 02:12:35'),(4,'PLX4821A-2026C01',9,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(5,'PLX4821A-2026C02',9,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(6,'PLX4821A-2026C03',9,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(7,'ZMT9012B-2026D01',10,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(8,'ZMT9012B-2026D02',10,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(9,'ZMT9012B-2026D03',10,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(10,'ZMT9012B-2026D04',10,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(11,'ZMT9012B-2026D05',10,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(12,'VQP3821C-2026E01',11,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(13,'VQP3821C-2026E02',11,1,'IN_STOCK',NULL,'2026-08-04 01:26:06','2026-08-04 01:26:06'),(14,'SER-83D2K-9284N',17,2,'SOLD',NULL,'2026-08-01 01:40:31','2026-08-07 02:03:21'),(15,'SER-XP921-3812P',19,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(16,'SER-KJR73-4921Q',20,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(17,'SER-PLX48-8392R',20,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(18,'SER-ZMT90-2841S',20,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(19,'SER-VQP38-150A2',20,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(20,'SER-NKW84-220B4',6,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(21,'SER-BFT29-85C7M',6,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(22,'SER-MXR73-500D1',6,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(23,'SER-QWD92-110E9',6,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(24,'SER-LKB38-300F3',24,2,'SOLD',NULL,'2026-08-01 01:40:31','2026-08-07 02:09:11'),(25,'SER-HFX49-45G2D',8,2,'IN_STOCK','GOOD','2026-08-01 01:40:31','2026-07-21 02:15:06'),(26,'SER-GMC83-180H6',8,2,'IN_STOCK','GOOD','2026-08-01 01:40:31','2026-07-21 02:15:06'),(27,'SER-TNY28-650J8',25,2,'IN_STOCK','GOOD','2026-08-01 01:40:31','2026-07-21 02:15:06'),(28,'SER-WRE38-95K4L',13,2,'IN_STOCK',NULL,'2026-08-01 01:40:31','2026-08-01 01:40:31'),(29,'XG83N2K',18,1,'IN_STOCK',NULL,'2026-08-05 01:46:21','2026-08-05 01:46:21'),(30,'PL92M4L',19,1,'SOLD',NULL,'2026-08-05 01:46:21','2026-08-07 02:10:15'),(31,'KT73R9N',21,1,'IN_STOCK',NULL,'2026-08-05 01:46:21','2026-08-05 01:46:21'),(32,'ZA48V1B',22,1,'IN_STOCK',NULL,'2026-08-05 01:46:21','2026-08-05 01:46:21'),(33,'ZM90W2C',6,1,'SOLD',NULL,'2026-08-05 01:46:21','2026-08-07 02:02:41'),(34,'VQ38X1D',7,1,'IN_STOCK','POOR','2026-08-05 01:46:21','2026-07-21 02:12:35'),(35,'NK84Y2E',24,1,'IN_STOCK',NULL,'2026-08-05 01:46:21','2026-08-05 01:46:21'),(36,'BF29Z1F',10,1,'IN_STOCK',NULL,'2026-08-05 01:46:21','2026-08-05 01:46:21'),(37,'MX73A9G',13,1,'IN_STOCK',NULL,'2026-08-05 01:46:21','2026-08-05 01:46:21'),(38,'QW92B4H',14,1,'IN_STOCK',NULL,'2026-08-05 01:46:21','2026-08-05 01:46:21'),(39,'HT83P1X',19,1,'SOLD',NULL,'2026-08-05 01:47:07','2026-08-07 02:10:15'),(40,'GL92V4M',21,1,'IN_STOCK',NULL,'2026-08-05 01:47:07','2026-08-05 01:47:07'),(41,'KD73C9Q',22,1,'IN_STOCK',NULL,'2026-08-05 01:47:07','2026-08-05 01:47:07'),(42,'ZN48R1S',7,1,'IN_STOCK','POOR','2026-08-05 01:47:07','2026-07-21 02:12:35'),(43,'VB90Y2W',15,1,'IN_STOCK',NULL,'2026-08-05 01:47:07','2026-08-05 01:47:07'),(44,'CR73M9V',20,1,'IN_STOCK',NULL,'2026-08-05 01:48:02','2026-08-05 01:48:02'),(45,'TW48X1P',21,1,'IN_STOCK',NULL,'2026-08-05 01:48:02','2026-08-05 01:48:02'),(46,'YL90Z2K',22,1,'IN_STOCK',NULL,'2026-08-05 01:48:02','2026-08-05 01:48:02'),(47,'FJ38A1S',7,1,'IN_STOCK','DAMAGED','2026-08-05 01:48:02','2026-07-21 02:12:35'),(48,'QX92B4N',10,1,'IN_STOCK',NULL,'2026-08-05 01:48:02','2026-08-05 01:48:02'),(49,'MW48C1T',15,2,'IN_STOCK',NULL,'2026-08-05 01:49:10','2026-08-05 01:49:10'),(50,'KP90D2R',23,2,'IN_STOCK','POOR','2026-08-05 01:49:10','2026-07-21 02:15:06'),(51,'XF38E1V',22,2,'IN_STOCK',NULL,'2026-08-05 01:49:10','2026-08-05 01:49:10'),(52,'ZL92G4M',21,2,'IN_STOCK',NULL,'2026-08-05 01:49:10','2026-08-05 01:49:10'),(53,'BY73H9K',18,2,'IN_STOCK',NULL,'2026-08-05 01:49:10','2026-08-05 01:49:10'),(54,'NX49J3V',10,1,'IN_STOCK',NULL,'2026-08-05 01:51:20','2026-08-05 01:51:20'),(55,'BQ73K1W',21,1,'IN_STOCK',NULL,'2026-08-05 01:51:20','2026-08-05 01:51:20'),(56,'LC28M7P',13,1,'IN_STOCK',NULL,'2026-08-05 01:51:20','2026-08-05 01:51:20'),(57,'WF92R4T',9,1,'IN_STOCK',NULL,'2026-08-05 01:51:20','2026-08-05 01:51:20'),(58,'HD38S5K',20,1,'IN_STOCK',NULL,'2026-08-05 01:51:20','2026-08-05 01:51:20'),(59,'ESS4DIV',21,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(60,'U2T011V',21,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(61,'IWD3Q3Y',21,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(62,'YHJ9729',16,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(63,'SCMUKQ5',16,1,'SOLD',NULL,'2026-08-05 01:53:22','2026-08-07 02:10:46'),(64,'ZUAZNPO',16,1,'SOLD',NULL,'2026-08-05 01:53:22','2026-08-07 02:10:46'),(65,'VRES1VR',16,1,'SOLD',NULL,'2026-08-05 01:53:22','2026-08-07 02:10:46'),(66,'7JP7RSA',12,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(67,'IEBZ5DW',12,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(68,'QRI5WQQ',12,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(69,'79TUYL2',12,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(70,'SR5PKJB',18,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(71,'XVQSR7J',18,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(72,'RS33U63',18,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(73,'L7DY2SQ',18,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(74,'884RCJR',18,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(75,'D0OQAAU',14,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(76,'7C2IW18',8,1,'IN_STOCK','GOOD','2026-08-05 01:53:22','2026-07-21 02:12:35'),(77,'YWFLU18',23,1,'SOLD',NULL,'2026-08-05 01:53:22','2026-08-07 02:10:15'),(78,'RZEIV85',15,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(79,'SDY726L',22,1,'IN_STOCK',NULL,'2026-08-05 01:53:22','2026-08-05 01:53:22'),(80,'VQP38213',11,2,'SOLD',NULL,'2026-08-04 02:07:51','2026-08-07 02:09:11'),(81,'ABC-abc-12345677',18,1,'IN_STOCK',NULL,'2026-08-04 14:39:16','2026-08-04 14:39:16'),(82,'ABC-abc-1234567729',18,1,'IN_STOCK',NULL,'2026-08-04 14:39:16','2026-08-04 14:39:16'),(83,'ABC-abc-1234567729444',22,1,'IN_STOCK',NULL,'2026-08-04 14:39:16','2026-08-04 14:39:16'),(84,'ABC-abc-12345676729444',22,1,'IN_STOCK',NULL,'2026-08-04 14:39:16','2026-08-04 14:39:16'),(85,'ABC-abc-1234567672946447',22,1,'IN_STOCK',NULL,'2026-08-04 14:39:16','2026-08-04 14:39:16'),(86,'ABC-abc-123456797294',13,1,'IN_STOCK',NULL,'2026-08-04 14:39:16','2026-08-04 14:39:16'),(87,'ABC-abc-123567f97',13,1,'IN_STOCK',NULL,'2026-08-04 14:39:16','2026-08-04 14:39:16'),(88,'123567f92',23,1,'IN_STOCK',NULL,'2026-09-04 14:44:08','2026-09-04 14:44:08'),(89,'123567f94',23,1,'IN_STOCK',NULL,'2026-09-04 14:44:08','2026-09-04 14:44:08'),(90,'123567f95',12,1,'IN_STOCK',NULL,'2026-09-04 14:44:08','2026-09-04 14:44:08'),(91,'123567f96',12,1,'IN_STOCK',NULL,'2026-09-04 14:44:08','2026-09-04 14:44:08'),(92,'123567f97',12,1,'IN_STOCK',NULL,'2026-09-04 14:44:08','2026-09-04 14:44:08'),(93,'123567f98',12,1,'IN_STOCK',NULL,'2026-09-04 14:44:08','2026-09-04 14:44:08'),(94,'123567f99',14,1,'IN_STOCK',NULL,'2026-09-04 14:44:08','2026-09-04 14:44:08'),(95,'123567f100',14,1,'IN_STOCK',NULL,'2026-09-04 14:44:08','2026-09-04 14:44:08'),(96,'123567f101',14,1,'IN_STOCK',NULL,'2026-09-04 14:44:08','2026-09-04 14:44:08');
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_check`
--

LOCK TABLES `inventory_check` WRITE;
/*!40000 ALTER TABLE `inventory_check` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_check_detail`
--

LOCK TABLES `inventory_check_detail` WRITE;
/*!40000 ALTER TABLE `inventory_check_detail` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `status` varchar(50) NOT NULL DEFAULT 'PENDING_CEO',
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=178 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,3,'Phiếu đề xuất PRC-20260721-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=1','proposal',1,1,'2026-07-21 01:21:51'),(2,5,'Phiếu đề xuất PRC-20260721-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=1','proposal',1,0,'2026-07-21 01:21:51'),(3,3,'Phiếu đề xuất PRC-20260721-001 đã được duyệt','Phiếu PRC-20260721-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=1','proposal',1,1,'2026-07-21 01:21:55'),(4,3,'Phiếu mua PO-202607-001 đã được duyệt','Phiếu mua PO-202607-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=1','purchase_order',1,1,'2026-08-04 01:22:52'),(5,3,'Phiếu đề xuất PRC-20260721-002 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=2','proposal',2,1,'2026-07-21 01:28:41'),(6,5,'Phiếu đề xuất PRC-20260721-002 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=2','proposal',2,0,'2026-07-21 01:28:41'),(7,3,'Phiếu đề xuất PRC-20260721-002 đã được duyệt','Phiếu PRC-20260721-002 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=2','proposal',2,1,'2026-07-21 01:28:44'),(8,3,'Phiếu đề xuất PRC-20260721-003 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=3','proposal',3,1,'2026-07-21 01:29:33'),(9,5,'Phiếu đề xuất PRC-20260721-003 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=3','proposal',3,0,'2026-07-21 01:29:33'),(10,3,'Phiếu đề xuất PRC-20260721-003 đã được duyệt','Phiếu PRC-20260721-003 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=3','proposal',3,1,'2026-07-21 01:29:36'),(11,3,'Phiếu đề xuất PRC-20260721-004 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=4','proposal',4,1,'2026-07-21 01:30:52'),(12,5,'Phiếu đề xuất PRC-20260721-004 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=4','proposal',4,0,'2026-07-21 01:30:52'),(13,3,'Phiếu đề xuất PRC-20260721-004 đã được duyệt','Phiếu PRC-20260721-004 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=4','proposal',4,1,'2026-07-21 01:30:55'),(14,3,'Phiếu đề xuất PRC-20260721-005 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=5','proposal',5,1,'2026-07-21 01:31:46'),(15,5,'Phiếu đề xuất PRC-20260721-005 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=5','proposal',5,0,'2026-07-21 01:31:46'),(16,3,'Phiếu đề xuất PRC-20260721-005 đã được duyệt','Phiếu PRC-20260721-005 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=5','proposal',5,1,'2026-07-21 01:31:49'),(17,3,'Phiếu đề xuất PRC-20260721-006 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=6','proposal',6,1,'2026-07-21 01:32:45'),(18,5,'Phiếu đề xuất PRC-20260721-006 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=6','proposal',6,0,'2026-07-21 01:32:45'),(19,3,'Phiếu đề xuất PRC-20260721-006 đã được duyệt','Phiếu PRC-20260721-006 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=6','proposal',6,1,'2026-07-21 01:32:48'),(20,3,'Phiếu đề xuất PRC-20260721-007 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=7','proposal',7,1,'2026-07-21 01:33:32'),(21,5,'Phiếu đề xuất PRC-20260721-007 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=7','proposal',7,0,'2026-07-21 01:33:32'),(22,3,'Phiếu đề xuất PRC-20260721-007 đã được duyệt','Phiếu PRC-20260721-007 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=7','proposal',7,1,'2026-07-21 01:33:35'),(23,3,'Phiếu đề xuất PRC-20260721-008 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=8','proposal',8,1,'2026-07-21 01:34:22'),(24,5,'Phiếu đề xuất PRC-20260721-008 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=8','proposal',8,0,'2026-07-21 01:34:22'),(25,3,'Phiếu đề xuất PRC-20260721-008 đã được duyệt','Phiếu PRC-20260721-008 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=8','proposal',8,1,'2026-07-21 01:34:25'),(26,3,'Phiếu đề xuất PRC-20260721-009 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=9','proposal',9,1,'2026-07-21 01:35:05'),(27,5,'Phiếu đề xuất PRC-20260721-009 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=9','proposal',9,0,'2026-07-21 01:35:05'),(28,3,'Phiếu đề xuất PRC-20260721-009 đã được duyệt','Phiếu PRC-20260721-009 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=9','proposal',9,1,'2026-07-21 01:35:08'),(29,3,'Phiếu đề xuất PRC-20260721-010 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=10','proposal',10,1,'2026-07-21 01:35:58'),(30,5,'Phiếu đề xuất PRC-20260721-010 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=10','proposal',10,0,'2026-07-21 01:35:58'),(31,3,'Phiếu đề xuất PRC-20260721-010 đã được duyệt','Phiếu PRC-20260721-010 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=10','proposal',10,1,'2026-07-21 01:36:00'),(32,3,'Phiếu đề xuất PRC-20260721-011 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=11','proposal',11,1,'2026-07-21 01:36:37'),(33,5,'Phiếu đề xuất PRC-20260721-011 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=11','proposal',11,0,'2026-07-21 01:36:37'),(34,3,'Phiếu đề xuất PRC-20260721-011 đã được duyệt','Phiếu PRC-20260721-011 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=11','proposal',11,1,'2026-07-21 01:36:39'),(35,3,'Phiếu mua PO-202607-002 đã được duyệt','Phiếu mua PO-202607-002 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=2','purchase_order',2,1,'2026-08-01 01:38:03'),(36,3,'Phiếu mua PO-202607-003 đã được duyệt','Phiếu mua PO-202607-003 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=3','purchase_order',3,1,'2026-08-02 01:41:56'),(37,3,'Phiếu mua PO-202607-004 đã được duyệt','Phiếu mua PO-202607-004 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=4','purchase_order',4,1,'2026-08-02 01:42:20'),(38,3,'Phiếu mua PO-202607-005 đã được duyệt','Phiếu mua PO-202607-005 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=5','purchase_order',5,1,'2026-08-04 01:43:52'),(39,3,'Phiếu mua PO-202607-006 đã được duyệt','Phiếu mua PO-202607-006 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=6','purchase_order',6,1,'2026-08-04 01:43:57'),(40,3,'Phiếu mua PO-202607-007 đã được duyệt','Phiếu mua PO-202607-007 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=7','purchase_order',7,1,'2026-08-04 01:44:02'),(41,3,'Phiếu mua PO-202607-008 đã được duyệt','Phiếu mua PO-202607-008 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=8','purchase_order',8,1,'2026-08-04 01:44:07'),(42,3,'Đơn hàng ORD-8294K2 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=1','order',1,1,'2026-07-21 01:56:03'),(43,5,'Đơn hàng ORD-8294K2 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=1','order',1,0,'2026-07-21 01:56:03'),(44,3,'Đơn hàng ORD-8294K2 đã được duyệt','Đơn hàng ORD-8294K2 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=1','order',1,1,'2026-07-21 01:56:19'),(45,3,'Đơn hàng ORD-4812M9 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=2','order',2,1,'2026-07-21 01:56:51'),(46,5,'Đơn hàng ORD-4812M9 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=2','order',2,0,'2026-07-21 01:56:51'),(47,3,'Đơn hàng ORD-7390X1 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=3','order',3,1,'2026-07-21 01:59:05'),(48,5,'Đơn hàng ORD-7390X1 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=3','order',3,0,'2026-07-21 01:59:05'),(49,3,'Đơn hàng ORD-2841P7 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=4','order',4,1,'2026-07-21 01:59:48'),(50,5,'Đơn hàng ORD-2841P7 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=4','order',4,0,'2026-07-21 01:59:48'),(51,3,'Đơn hàng ORD-9284V3 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=5','order',5,1,'2026-07-21 02:00:13'),(52,5,'Đơn hàng ORD-9284V3 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=5','order',5,0,'2026-07-21 02:00:13'),(53,3,'Đơn hàng ORD-9284V3 đã được duyệt','Đơn hàng ORD-9284V3 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=5','order',5,1,'2026-08-07 02:01:13'),(54,3,'Đơn hàng ORD-2841P7 đã được duyệt','Đơn hàng ORD-2841P7 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=4','order',4,1,'2026-08-07 02:01:17'),(55,3,'Đơn hàng ORD-7390X1 đã được duyệt','Đơn hàng ORD-7390X1 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=3','order',3,1,'2026-08-07 02:01:21'),(56,3,'Đơn hàng ORD-4812M9 đã được duyệt','Đơn hàng ORD-4812M9 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=2','order',2,1,'2026-08-07 02:01:24'),(57,3,'Phiếu đề xuất PRC-20260802-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=12','proposal',12,1,'2026-08-02 02:05:33'),(58,5,'Phiếu đề xuất PRC-20260802-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=12','proposal',12,0,'2026-08-02 02:05:33'),(59,3,'Phiếu đề xuất PRC-20260802-001 đã được duyệt','Phiếu PRC-20260802-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=12','proposal',12,1,'2026-08-02 02:05:36'),(60,3,'Phiếu đề xuất PRC-20260723-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=13','proposal',13,1,'2026-07-23 02:06:28'),(61,5,'Phiếu đề xuất PRC-20260723-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=13','proposal',13,0,'2026-07-23 02:06:28'),(62,3,'Phiếu đề xuất PRC-20260723-001 đã được duyệt','Phiếu PRC-20260723-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=13','proposal',13,1,'2026-07-23 02:06:33'),(63,3,'Phiếu mua PO-202607-009 đã được duyệt','Phiếu mua PO-202607-009 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=9','purchase_order',9,1,'2026-08-04 02:07:13'),(64,3,'Phiếu đề xuất PRC-21/07/2026-012 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=14','proposal',14,1,'2026-07-21 14:21:57'),(65,5,'Phiếu đề xuất PRC-21/07/2026-012 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=14','proposal',14,0,'2026-07-21 14:21:57'),(66,3,'Phiếu đề xuất PRC-21/07/2026-012 đã được duyệt','Phiếu PRC-21/07/2026-012 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=14','proposal',14,1,'2026-07-21 14:22:13'),(67,3,'Phiếu mua PO-202607-010 đã được duyệt','Phiếu mua PO-202607-010 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=10','purchase_order',10,1,'2026-08-04 14:29:58'),(68,3,'Phiếu đề xuất PRC-04/08/2026-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=15','proposal',15,1,'2026-08-04 14:40:03'),(69,5,'Phiếu đề xuất PRC-04/08/2026-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=15','proposal',15,1,'2026-08-04 14:40:03'),(70,3,'Phiếu đề xuất PRC-04/08/2026-001 đã được duyệt','Phiếu PRC-04/08/2026-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=15','proposal',15,1,'2026-08-04 14:40:06'),(71,3,'Phiếu mua PO-202608-001 đã được duyệt','Phiếu mua PO-202608-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=11','purchase_order',11,1,'2026-09-04 14:40:46'),(72,3,'Đơn hàng ORD-04/09/2026-001 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=6','order',6,1,'2026-09-04 14:54:27'),(73,5,'Đơn hàng ORD-04/09/2026-001 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=6','order',6,1,'2026-09-04 14:54:27'),(74,3,'Đơn hàng ORD-04/09/2026-001 đã được duyệt','Đơn hàng ORD-04/09/2026-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=6','order',6,1,'2026-09-04 14:54:38'),(75,3,'Phiếu đề xuất PRC-20260524-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=16','proposal',16,1,'2026-05-24 10:52:51'),(76,5,'Phiếu đề xuất PRC-20260524-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=16','proposal',16,0,'2026-05-24 10:52:51'),(77,3,'Phiếu đề xuất PRC-20260525-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=17','proposal',17,1,'2026-05-25 10:55:24'),(78,5,'Phiếu đề xuất PRC-20260525-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=17','proposal',17,0,'2026-05-25 10:55:24'),(79,3,'Phiếu đề xuất PRC-20260526-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=18','proposal',18,1,'2026-05-26 10:57:20'),(80,5,'Phiếu đề xuất PRC-20260526-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=18','proposal',18,0,'2026-05-26 10:57:20'),(81,3,'Phiếu đề xuất PRC-20260527-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=19','proposal',19,1,'2026-05-27 10:58:07'),(82,5,'Phiếu đề xuất PRC-20260527-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=19','proposal',19,0,'2026-05-27 10:58:07'),(83,14,'Phiếu đề xuất PRC-20260527-001 đã được duyệt','Phiếu PRC-20260527-001 đã được Trần Thị Hương duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=19','proposal',19,0,'2026-05-27 11:08:58'),(84,14,'Phiếu đề xuất PRC-20260526-001 đã được duyệt','Phiếu PRC-20260526-001 đã được Trần Thị Hương duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=18','proposal',18,0,'2026-05-27 11:09:13'),(85,14,'Phiếu đề xuất PRC-20260524-001 đã được duyệt','Phiếu PRC-20260524-001 đã được Trần Thị Hương duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=16','proposal',16,0,'2026-05-27 11:09:25'),(86,14,'Phiếu đề xuất PRC-20260525-001 đã được duyệt','Phiếu PRC-20260525-001 đã được Trần Thị Hương duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=17','proposal',17,0,'2026-05-27 11:09:35'),(87,5,'Phiếu mua PO-202605-001 đã được duyệt','Phiếu mua PO-202605-001 đã được CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=12','purchase_order',12,0,'2026-06-01 11:11:58'),(88,3,'Đơn hàng ORD-20260513-001 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=7','order',7,1,'2026-05-13 11:19:50'),(89,5,'Đơn hàng ORD-20260513-001 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=7','order',7,0,'2026-05-13 11:19:50'),(90,3,'Đơn hàng ORD-20260513-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=8','order',8,1,'2026-05-13 11:20:12'),(91,5,'Đơn hàng ORD-20260513-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=8','order',8,0,'2026-05-13 11:20:12'),(92,3,'Đơn hàng ORD-20260513-003 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=9','order',9,1,'2026-05-13 11:20:35'),(93,5,'Đơn hàng ORD-20260513-003 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=9','order',9,0,'2026-05-13 11:20:35'),(94,3,'Đơn hàng ORD-20260513-004 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=10','order',10,1,'2026-05-13 11:20:54'),(95,5,'Đơn hàng ORD-20260513-004 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=10','order',10,0,'2026-05-13 11:20:54'),(96,3,'Đơn hàng ORD-20260513-005 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=11','order',11,1,'2026-05-13 11:21:12'),(97,5,'Đơn hàng ORD-20260513-005 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=11','order',11,0,'2026-05-13 11:21:12'),(98,3,'Đơn hàng ORD-20260527-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=12','order',12,1,'2026-05-27 16:14:46'),(99,5,'Đơn hàng ORD-20260527-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=12','order',12,0,'2026-05-27 16:14:46'),(100,3,'Đơn hàng ORD-20260527-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=13','order',13,1,'2026-05-27 16:17:00'),(101,5,'Đơn hàng ORD-20260527-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=13','order',13,0,'2026-05-27 16:17:00'),(102,3,'Đơn hàng ORD-20260527-003 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=14','order',14,1,'2026-05-27 16:18:14'),(103,5,'Đơn hàng ORD-20260527-003 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=14','order',14,0,'2026-05-27 16:18:14'),(104,3,'Đơn hàng ORD-20260527-004 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=15','order',15,1,'2026-05-27 16:18:46'),(105,5,'Đơn hàng ORD-20260527-004 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=15','order',15,0,'2026-05-27 16:18:46'),(106,3,'Phiếu đề xuất PRC-20260527-002 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=20','proposal',20,1,'2026-05-27 16:19:44'),(107,5,'Phiếu đề xuất PRC-20260527-002 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=20','proposal',20,0,'2026-05-27 16:19:44'),(108,3,'Phiếu đề xuất PRC-20260727-001 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=21','proposal',21,1,'2026-07-27 18:55:49'),(109,5,'Phiếu đề xuất PRC-20260727-001 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=21','proposal',21,0,'2026-07-27 18:55:49'),(110,3,'Phiếu đề xuất PRC-20260727-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=22','proposal',22,1,'2026-07-27 18:56:27'),(111,5,'Phiếu đề xuất PRC-20260727-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=22','proposal',22,0,'2026-07-27 18:56:27'),(112,3,'Phiếu đề xuất PRC-20260727-003 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=23','proposal',23,1,'2026-07-27 18:59:17'),(113,5,'Phiếu đề xuất PRC-20260727-003 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=23','proposal',23,0,'2026-07-27 18:59:17'),(114,3,'Phiếu đề xuất PRC-20260727-004 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=24','proposal',24,1,'2026-07-27 18:59:46'),(115,5,'Phiếu đề xuất PRC-20260727-004 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=24','proposal',24,0,'2026-07-27 18:59:46'),(116,3,'Phiếu đề xuất PRC-20260727-005 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=25','proposal',25,1,'2026-07-27 19:00:20'),(117,5,'Phiếu đề xuất PRC-20260727-005 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=25','proposal',25,0,'2026-07-27 19:00:20'),(118,3,'Phiếu đề xuất PRC-20260727-006 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=26','proposal',26,1,'2026-07-27 19:01:04'),(119,5,'Phiếu đề xuất PRC-20260727-006 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=26','proposal',26,0,'2026-07-27 19:01:04'),(120,3,'Phiếu đề xuất PRC-20260727-007 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=27','proposal',27,1,'2026-07-27 19:01:35'),(121,5,'Phiếu đề xuất PRC-20260727-007 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=27','proposal',27,0,'2026-07-27 19:01:35'),(122,3,'Phiếu đề xuất PRC-20260727-008 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=28','proposal',28,1,'2026-07-27 19:02:06'),(123,5,'Phiếu đề xuất PRC-20260727-008 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=28','proposal',28,0,'2026-07-27 19:02:06'),(124,3,'Phiếu đề xuất PRC-20260727-009 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=29','proposal',29,1,'2026-07-27 19:02:31'),(125,5,'Phiếu đề xuất PRC-20260727-009 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=29','proposal',29,0,'2026-07-27 19:02:31'),(126,3,'Phiếu đề xuất PRC-20260727-010 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=30','proposal',30,1,'2026-07-27 19:02:52'),(127,5,'Phiếu đề xuất PRC-20260727-010 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=30','proposal',30,0,'2026-07-27 19:02:52'),(128,3,'Phiếu đề xuất PRC-20260613-001 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=31','proposal',31,1,'2026-06-13 19:03:53'),(129,5,'Phiếu đề xuất PRC-20260613-001 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=31','proposal',31,0,'2026-06-13 19:03:53'),(130,3,'Phiếu đề xuất PRC-20260613-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=32','proposal',32,1,'2026-06-13 19:04:12'),(131,5,'Phiếu đề xuất PRC-20260613-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=32','proposal',32,0,'2026-06-13 19:04:12'),(132,3,'Phiếu đề xuất PRC-20260613-003 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=33','proposal',33,1,'2026-06-13 19:04:39'),(133,5,'Phiếu đề xuất PRC-20260613-003 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=33','proposal',33,0,'2026-06-13 19:04:39'),(134,3,'Phiếu đề xuất PRC-20260613-004 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=34','proposal',34,1,'2026-06-13 19:05:12'),(135,5,'Phiếu đề xuất PRC-20260613-004 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=34','proposal',34,0,'2026-06-13 19:05:12'),(136,3,'Phiếu đề xuất PRC-20260613-005 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=35','proposal',35,1,'2026-06-13 19:05:41'),(137,5,'Phiếu đề xuất PRC-20260613-005 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=35','proposal',35,0,'2026-06-13 19:05:41'),(138,3,'Phiếu đề xuất PRC-20260613-006 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=36','proposal',36,1,'2026-06-13 19:06:47'),(139,5,'Phiếu đề xuất PRC-20260613-006 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=36','proposal',36,0,'2026-06-13 19:06:47'),(140,3,'Phiếu đề xuất PRC-20260613-007 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=37','proposal',37,1,'2026-06-13 19:07:03'),(141,5,'Phiếu đề xuất PRC-20260613-007 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=37','proposal',37,0,'2026-06-13 19:07:03'),(142,3,'Phiếu đề xuất PRC-20260613-008 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=38','proposal',38,1,'2026-06-13 19:07:19'),(143,5,'Phiếu đề xuất PRC-20260613-008 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=38','proposal',38,0,'2026-06-13 19:07:19'),(144,3,'Phiếu đề xuất PRC-20260613-009 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=39','proposal',39,1,'2026-06-13 19:07:42'),(145,5,'Phiếu đề xuất PRC-20260613-009 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=39','proposal',39,0,'2026-06-13 19:07:42'),(146,3,'Phiếu đề xuất PRC-20260613-010 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=40','proposal',40,1,'2026-06-13 19:08:08'),(147,5,'Phiếu đề xuất PRC-20260613-010 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=40','proposal',40,0,'2026-06-13 19:08:08'),(148,3,'Phiếu đề xuất PRC-20260513-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=41','proposal',41,1,'2026-05-13 19:08:49'),(149,5,'Phiếu đề xuất PRC-20260513-001 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=41','proposal',41,0,'2026-05-13 19:08:49'),(150,3,'Phiếu đề xuất PRC-20260513-002 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=42','proposal',42,1,'2026-05-13 19:09:12'),(151,5,'Phiếu đề xuất PRC-20260513-002 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=42','proposal',42,0,'2026-05-13 19:09:12'),(152,3,'Phiếu đề xuất PRC-20260513-003 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=43','proposal',43,1,'2026-05-13 19:09:45'),(153,5,'Phiếu đề xuất PRC-20260513-003 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=43','proposal',43,0,'2026-05-13 19:09:45'),(154,3,'Phiếu đề xuất PRC-20260513-004 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=44','proposal',44,1,'2026-05-13 19:10:02'),(155,5,'Phiếu đề xuất PRC-20260513-004 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=44','proposal',44,0,'2026-05-13 19:10:02'),(156,3,'Phiếu đề xuất PRC-20260513-005 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=45','proposal',45,1,'2026-05-13 19:10:18'),(157,5,'Phiếu đề xuất PRC-20260513-005 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=45','proposal',45,0,'2026-05-13 19:10:18'),(158,3,'Phiếu đề xuất PRC-20260513-006 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=46','proposal',46,1,'2026-05-13 19:10:31'),(159,5,'Phiếu đề xuất PRC-20260513-006 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=46','proposal',46,0,'2026-05-13 19:10:31'),(160,3,'Phiếu đề xuất PRC-20260513-007 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=47','proposal',47,1,'2026-05-13 19:11:02'),(161,5,'Phiếu đề xuất PRC-20260513-007 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=47','proposal',47,0,'2026-05-13 19:11:02'),(162,3,'Phiếu đề xuất PRC-20260513-008 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=48','proposal',48,1,'2026-05-13 19:11:15'),(163,5,'Phiếu đề xuất PRC-20260513-008 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=48','proposal',48,0,'2026-05-13 19:11:15'),(164,3,'Phiếu đề xuất PRC-20260513-009 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=49','proposal',49,1,'2026-05-13 19:11:27'),(165,5,'Phiếu đề xuất PRC-20260513-009 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=49','proposal',49,0,'2026-05-13 19:11:27'),(166,3,'Phiếu đề xuất PRC-20260513-010 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=50','proposal',50,1,'2026-05-13 19:11:40'),(167,5,'Phiếu đề xuất PRC-20260513-010 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=50','proposal',50,0,'2026-05-13 19:11:40'),(168,3,'Phiếu đề xuất PRC-20260513-011 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=51','proposal',51,1,'2026-05-13 19:12:01'),(169,5,'Phiếu đề xuất PRC-20260513-011 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=51','proposal',51,0,'2026-05-13 19:12:01'),(170,3,'Phiếu đề xuất PRC-20260520-001 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=52','proposal',52,1,'2026-05-20 19:16:29'),(171,5,'Phiếu đề xuất PRC-20260520-001 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=52','proposal',52,0,'2026-05-20 19:16:29'),(172,3,'Phiếu đề xuất PRC-20260520-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=53','proposal',53,1,'2026-05-20 19:17:03'),(173,5,'Phiếu đề xuất PRC-20260520-002 chờ duyệt','Nhân viên Nguyễn Linh vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=53','proposal',53,0,'2026-05-20 19:17:03'),(174,3,'Phiếu đề xuất PRC-20260520-003 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=54','proposal',54,1,'2026-05-20 19:17:38'),(175,5,'Phiếu đề xuất PRC-20260520-003 chờ duyệt','Nhân viên Nguyễn Thị B vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=54','proposal',54,0,'2026-05-20 19:17:38'),(176,14,'Phiếu đề xuất PRC-20260513-001 đã được duyệt','Phiếu PRC-20260513-001 đã được Trần Thị Hương duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=41','proposal',41,0,'2026-06-04 19:21:56'),(177,14,'Phiếu đề xuất PRC-20260513-002 đã được duyệt','Phiếu PRC-20260513-002 đã được Trần Thị Hương duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=42','proposal',42,0,'2026-06-04 19:22:49');
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
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=146 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES (1,'users','view','Xem danh sach nguoi dung','admin','Người dùng','READ'),(2,'users','create','Them nguoi dung moi','admin','Người dùng','CREATE'),(3,'users','update','Cap nhat thong tin nguoi dung','admin','Người dùng','UPDATE'),(4,'users','deactivate','Vo hieu hoa nguoi dung','admin','Người dùng','DELETE'),(5,'roles','view','Xem danh sach vai tro','admin','Vai trò','READ'),(6,'roles','create','Them vai tro moi','admin','Vai trò','CREATE'),(7,'roles','update','Cap nhat vai tro','admin','Vai trò','UPDATE'),(8,'roles','deactivate','Vo hieu hoa vai tro','admin','Vai trò','DELETE'),(9,'roles','edit_permissions','Chinh sua quyen cua vai tro','admin','Vai trò','UPDATE'),(10,'generators','view','Xem danh sach may phat dien','warehouse','Máy phát điện','READ'),(11,'generators','create','Them may phat dien moi','warehouse','Máy phát điện','CREATE'),(12,'generators','update','Cap nhat thong tin may','warehouse','Máy phát điện','UPDATE'),(22,'inventory','view','Xem ton kho','warehouse','Tồn kho','READ'),(24,'inventory','adjust','Dieu chinh ton kho','warehouse','Tồn kho','ADJUST'),(25,'warehouses','view','Xem thong tin kho','warehouse','Kho','READ'),(26,'warehouses','create','Them kho moi','warehouse','Kho','CREATE'),(27,'warehouses','update','Cap nhat thong tin kho','warehouse','Kho','UPDATE'),(45,'orders','view','Xem don hang','sales','Đơn hàng','READ'),(46,'orders','create','Tao don hang','sales','Đơn hàng','CREATE'),(47,'orders','update','Cap nhat don hang','sales','Đơn hàng','UPDATE'),(48,'orders','cancel','Huy don hang','sales','Đơn hàng','CANCEL'),(65,'reports','view','Xem bao cao','report','Báo cáo','READ'),(66,'reports','export','Xuat bao cao','report','Báo cáo','EXPORT'),(91,'dashboard','view','Xem dashboard','system','Dashboard','READ'),(95,'profile','view','Xem ho so ca nhan','account','Hồ sơ cá nhân','READ'),(96,'profile','edit','Sua ho so ca nhan','account','Hồ sơ cá nhân','UPDATE'),(97,'password','change','Doi mat khau','account','Mật khẩu','UPDATE'),(98,'forgot_pw','process','Xu ly yeu cau reset mat khau','account','Đặt lại mật khẩu','UPDATE'),(100,'orders','approve','Duyet don hang (sale_manager)','sales','Đơn hàng','APPROVE'),(101,'receipts','view','Xem phieu xuat/nhap kho','warehouse','Phiếu xuất/nhập','READ'),(102,'receipts','create','Tao phieu xuat/nhap kho','warehouse','Phiếu xuất/nhập','CREATE'),(103,'receipts','approve','Duyet phieu xuat/nhap kho (warehouse_manager)','warehouse','Phiếu xuất/nhập','APPROVE'),(104,'stock_card','view','Xem the kho','warehouse','Thẻ kho','READ'),(105,'orders','reject','Tu choi don hang (sale_manager)','sales','Đơn hàng','REJECT'),(106,'receipts','reject','Tu choi phieu xuat/nhap kho (warehouse_manager)','warehouse','Phiếu xuất/nhập','REJECT'),(107,'categories','view','Xem danh mục','system','Danh mục','READ'),(108,'categories','create','Tạo danh mục mới','system','Danh mục','CREATE'),(109,'categories','update','Sửa danh mục','system','Danh mục','UPDATE'),(110,'categories','delete','Xóa danh mục','system','Danh mục','DELETE'),(111,'activity_log','view','Xem lịch sử hoạt động','system','Lịch sử hoạt động','READ'),(112,'system_log','view','Xem nhật ký hệ thống','system','Nhật ký hệ thống','READ'),(113,'customers','view','Xem danh sách khách hàng','sales','Khách hàng','READ'),(114,'customers','create','Thêm khách hàng mới','sales','Khách hàng','CREATE'),(115,'customers','update','Sửa thông tin khách hàng','sales','Khách hàng','UPDATE'),(116,'customers','deactivate','Vô hiệu hóa khách hàng','sales','Khách hàng','DELETE'),(117,'proposals','view','Xem phiếu đề xuất nhập kho','sales','Đề xuất nhập kho','READ'),(118,'proposals','create','Tạo phiếu đề xuất nhập kho','sales','Đề xuất nhập kho','CREATE'),(119,'proposals','update','Cập nhật phiếu đề xuất nhập kho','sales','Đề xuất nhập kho','UPDATE'),(120,'proposals','cancel','Hủy phiếu đề xuất nhập kho','sales','Đề xuất nhập kho','CANCEL'),(121,'proposals','approve','Duyệt phiếu đề xuất nhập kho (sale_manager)','sales','Đề xuất nhập kho','APPROVE'),(122,'proposals','reject','Từ chối phiếu đề xuất nhập kho (sale_manager)','sales','Đề xuất nhập kho','REJECT'),(124,'liquidations','view','Xem danh sách đơn thanh lý','warehouse','Đơn thanh lý','READ'),(125,'liquidations','create','Tạo và quản lý đơn thanh lý','warehouse','Đơn thanh lý','CREATE'),(126,'liquidations','approve_manager','Duyệt và báo giá đơn thanh lý','warehouse','Đơn thanh lý','APPROVE'),(127,'liquidations','approve_ceo','Duyệt, từ chối hoặc yêu cầu sửa đơn thanh lý','warehouse','Đơn thanh lý','APPROVE'),(128,'transfers','view','Xem phiếu luân chuyển kho','warehouse','Phiếu luân chuyển','READ'),(129,'transfers','create','Tạo phiếu luân chuyển kho','warehouse','Phiếu luân chuyển','CREATE'),(130,'transfers','approve_manager','Duyệt phiếu luân chuyển (warehouse_manager)','warehouse','Phiếu luân chuyển','APPROVE'),(131,'transfers','approve_ceo','Duyệt phiếu luân chuyển (ceo)','warehouse','Phiếu luân chuyển','APPROVE'),(132,'purchase_orders','reject','Từ chối phiếu mua (CEO)','sales','Phiếu mua hàng','REJECT'),(133,'purchase_orders','view','Xem phiếu mua','sales','Phiếu mua hàng','READ'),(134,'purchase_orders','create','Tạo/gom phiếu mua (sale_manager)','sales','Phiếu mua hàng','CREATE'),(135,'purchase_orders','send_ceo','Gửi phiếu mua cho CEO','sales','Phiếu mua hàng','APPROVE'),(136,'purchase_orders','approve','Duyệt phiếu mua (CEO)','sales','Phiếu mua hàng','APPROVE'),(137,'suppliers','view','Xem danh sách nhà cung cấp','sales','Nhà cung cấp','READ'),(138,'suppliers','create','Thêm nhà cung cấp mới','sales','Nhà cung cấp','CREATE'),(139,'suppliers','update','Cập nhật thông tin nhà cung cấp','sales','Nhà cung cấp','UPDATE'),(140,'suppliers','deactivate','Vô hiệu hóa nhà cung cấp','sales','Nhà cung cấp','DELETE'),(141,'inventory_check','view','Xem phieu kiem ke','warehouse','Kiểm kê','READ'),(142,'inventory_check','create','Tao phieu kiem ke','warehouse','Kiểm kê','CREATE'),(143,'inventory_check','update','Cap nhat phieu kiem ke','warehouse','Kiểm kê','UPDATE'),(144,'inventory_check','complete','Hoan thanh kiem ke','warehouse','Kiểm kê','COMPLETE'),(145,'transfers','approve_dest','Nhân viên kho đích chấp nhận/từ chối phiếu luân chuyển','transfer',NULL,NULL);
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
  KEY `idx_po_status` (`status`),
  KEY `idx_po_created` (`created_by`),
  KEY `idx_po_approved` (`approved_by`),
  KEY `idx_po_warehouse` (`warehouse_id`),
  KEY `fk_po_rejected` (`rejected_by`),
  CONSTRAINT `fk_po_approved` FOREIGN KEY (`approved_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_po_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_po_rejected` FOREIGN KEY (`rejected_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_po_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `proposal_detail_id` int DEFAULT NULL COMMENT 'FK về import_proposal_detail - truy ngược đề xuất gốc',
  `generator_id` int NOT NULL,
  `proposed_quantity` int NOT NULL DEFAULT '0' COMMENT 'Tong SL tu cac proposal goc',
  `current_stock` int NOT NULL DEFAULT '0' COMMENT 'Ton kho luc gom',
  `unit_price` decimal(15,2) DEFAULT NULL COMMENT 'Giá duyệt tại PO, copy từ proposal detail',
  `final_quantity` int NOT NULL DEFAULT '0' COMMENT 'Sale manager chot',
  `note` text,
  PRIMARY KEY (`po_detail_id`),
  UNIQUE KEY `uk_pod_proposal_detail` (`proposal_detail_id`),
  KEY `idx_pod_po` (`po_id`),
  KEY `idx_pod_generator` (`generator_id`),
  KEY `idx_pod_proposal_detail` (`proposal_detail_id`),
  CONSTRAINT `fk_pod_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`),
  CONSTRAINT `fk_pod_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pod_proposal_detail` FOREIGN KEY (`proposal_detail_id`) REFERENCES `import_proposal_detail` (`proposal_detail_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=75 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `liquidation_id` int DEFAULT NULL,
  `linked_transfer_id` int DEFAULT NULL,
  `related_export_receipt_id` int DEFAULT NULL,
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
  KEY `fk_receipt_transfer` (`linked_transfer_id`),
  KEY `fk_receipt_related_export` (`related_export_receipt_id`),
  KEY `fk_receipt_liquidation` (`liquidation_id`),
  CONSTRAINT `fk_receipt_approved` FOREIGN KEY (`approved_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_receipt_liquidation` FOREIGN KEY (`liquidation_id`) REFERENCES `liquidation` (`liquidation_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_order` FOREIGN KEY (`order_id`) REFERENCES `sale_order` (`order_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_po` FOREIGN KEY (`purchase_order_id`) REFERENCES `purchase_order` (`po_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_related_export` FOREIGN KEY (`related_export_receipt_id`) REFERENCES `receipt` (`receipt_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_transfer` FOREIGN KEY (`linked_transfer_id`) REFERENCES `transfer` (`transfer_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT,
  CONSTRAINT `receipt_ibfk_1` FOREIGN KEY (`reason_id`) REFERENCES `category` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt`
--

LOCK TABLES `receipt` WRITE;
/*!40000 ALTER TABLE `receipt` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=129 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt_detail`
--

LOCK TABLES `receipt_detail` WRITE;
/*!40000 ALTER TABLE `receipt_detail` DISABLE KEYS */;
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
INSERT INTO `role` VALUES (1,'admin','Quản trị hệ thống','active','2026-05-15 16:43:03','2026-06-18 16:44:59'),(2,'warehouse_manager','Quản lý kho - Duyệt phiếu xuất/nhập','active','2026-05-15 16:43:03','2026-08-02 14:23:45'),(3,'warehouse_staff','Nhân viên kho - Tạo phiếu, quét serial','active','2026-05-15 16:43:03','2026-06-30 12:45:13'),(5,'sales_staff','Nhân viên kinh doanh - Tạo đơn hàng','active','2026-05-15 16:43:03','2026-06-26 02:13:15'),(10,'sale_manager','Trưởng phòng kinh doanh - Duyệt đơn hàng','active','2026-05-21 00:00:00','2026-06-30 12:44:57'),(13,'ceo','Giám đốc điều hành - Duyệt các đơn thanh lý và quyết định cấp cao','active','2026-06-09 21:49:56','2026-06-30 13:02:22');
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
INSERT INTO `role_permission` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(2,10),(3,10),(5,10),(10,10),(1,11),(1,12),(1,22),(2,22),(3,22),(5,22),(10,22),(1,24),(2,24),(1,25),(2,25),(3,25),(1,26),(2,26),(1,27),(2,27),(1,45),(2,45),(3,45),(5,45),(10,45),(1,46),(5,46),(1,47),(5,47),(1,48),(5,48),(1,65),(2,65),(1,66),(2,66),(1,91),(2,91),(3,91),(5,91),(10,91),(13,91),(1,95),(2,95),(3,95),(5,95),(10,95),(1,96),(2,96),(3,96),(5,96),(10,96),(1,97),(2,97),(3,97),(5,97),(10,97),(1,98),(1,100),(10,100),(1,101),(2,101),(3,101),(1,102),(2,102),(3,102),(1,103),(2,103),(1,104),(2,104),(1,105),(10,105),(1,106),(2,106),(1,107),(1,108),(1,109),(1,110),(1,111),(1,112),(1,113),(5,113),(10,113),(1,114),(5,114),(1,115),(5,115),(1,116),(5,116),(1,117),(2,117),(5,117),(10,117),(1,118),(5,118),(1,119),(5,119),(1,120),(5,120),(1,121),(10,121),(1,122),(10,122),(1,124),(2,124),(13,124),(1,125),(2,125),(1,126),(2,126),(1,127),(13,127),(1,128),(2,128),(3,128),(13,128),(1,129),(2,129),(3,129),(1,130),(2,130),(1,131),(13,131),(1,132),(13,132),(1,133),(10,133),(13,133),(1,134),(10,134),(1,135),(10,135),(1,136),(13,136),(1,137),(5,137),(10,137),(1,138),(5,138),(1,139),(5,139),(1,140),(5,140),(1,141),(1,142),(1,143),(1,144),(2,145),(3,145);
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
  `revision_reason` text,
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_order`
--

LOCK TABLES `sale_order` WRITE;
/*!40000 ALTER TABLE `sale_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_order` ENABLE KEYS */;
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
  `transaction_type` enum('IMPORT','EXPORT') NOT NULL,
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
  KEY `idx_sc_wh_gen_ctime_id` (`warehouse_id`,`generator_id`,`created_at`,`stock_card_id`),
  KEY `idx_sc_type_ctime_wh_gen` (`transaction_type`,`created_at`,`warehouse_id`,`generator_id`),
  CONSTRAINT `fk_sc_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`) ON DELETE SET NULL,
  CONSTRAINT `fk_sc_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `fk_sc_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `receipt` (`receipt_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_sc_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=84 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_card`
--

LOCK TABLES `stock_card` WRITE;
/*!40000 ALTER TABLE `stock_card` DISABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quản lý thông tin nhà cung cấp';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'Công ty Cổ phần Thiết bị Công nghiệp Ánh Dương','0912345678','contact@anhduongjsc.com','Số 12, Ngõ 45, Đường Cầu Giấy, Quận Cầu Giấy, Hà Nội','Công ty Cổ phần Thiết bị Công nghiệp Ánh Dương',32,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:16',NULL),(2,'Trần Thị Thảo','0987654321','thaott92@gmail.com','Tòa nhà Landmark 81, Phường 22, Quận Bình Thạnh, TP. Hồ Chí Minh','',33,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:36',3),(3,'Công ty TNHH Cơ khí & Tự động hóa DAT','0905123456','info@datautomation.vn','Số 88, Đường Nguyễn Văn Linh, Quận Hải Châu, Đà Nẵng','Công ty TNHH Cơ khí & Tự động hóa DAT',32,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:16',NULL),(4,'Phạm Đức Anh','0934567890','anhpd.supplier@gmail.com','Khu đô thị mới Mỹ Đình 2, Quận Nam Từ Liêm, Hà Nội','',32,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:42',3),(5,'Công ty Cổ phần Năng lượng Xanh Toàn Cầu','0971234567','sales@globalgreen.com.vn','Số 154, Đường Trần Hưng Đạo, Quận 1, TP. Hồ Chí Minh','Công ty Cổ phần Năng lượng Xanh Toàn Cầu',33,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:16',NULL),(6,'Phan Thanh Sơn','0968888999','sonpt.hanoi@gmail.com','Số 45, Đường Lê Lợi, Quận Ngô Quyền, Hải Phòng','',33,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:47',3),(7,'Công ty TNHH Giải pháp Công nghệ Minh Phát','0945678123','admin@minhphattech.vn','Số 23, Đại lộ Bình Dương, Thủ Dầu Một, Bình Dương','Công ty TNHH Giải pháp Công nghệ Minh Phát',33,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:16',NULL),(8,'Đặng Quốc Dũng','0911223344','dungdq.biotech@gmail.com','Số 67, Đường Hùng Vương, Ninh Kiều, Cần Thơ','',32,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:52',3),(9,'Tổng Công ty Vật tư & Thiết bị Điện lực','0988776655','vattu@electricity.com.vn','Khu công nghiệp VSIP, Huyện Thủy Nguyên, Hải Phòng','Tổng Công ty Vật tư & Thiết bị Điện lực',32,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:16',NULL),(10,'Bùi Minh Tuấn','0909090909','tuanbm.wood@gmail.com','Số 10, Lý Thường Kiệt, Thành phố Huế, Thừa Thiên Huế','',32,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:58',3),(11,'Công ty Cổ phần Thương mại Lâm Sản Việt','0955556666','contact@vietholzltd.com','Số 56, Đường Lê Duẩn, Quận Đống Đa, Hà Nội','Công ty Cổ phần Thương mại Lâm Sản Việt',32,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:16',NULL),(12,'Nguyễn Hải Vinh','0922334455','vinhnh.solar@gmail.com','Số 78, Đường Nguyễn Trãi, Quận Thanh Xuân, Hà Nội','',33,'active','2026-07-21 01:18:16',3,'2026-07-21 01:19:05',3),(13,'Tập đoàn Sản xuất & Chế tạo Máy động lực','0933445566','purchase@donglucgroup.vn','Số 234, Đường Điện Biên Phủ, Quận 3, TP. Hồ Chí Minh','Tập đoàn Sản xuất & Chế tạo Máy động lực',32,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:16',NULL),(14,'Lê Mai Phương','0977889900','phuonglm.logistic@gmail.com','Số 12, Đường Hoàng Văn Thụ, Thành phố Thái Nguyên','',33,'active','2026-07-21 01:18:16',3,'2026-07-21 01:19:13',3),(15,'Công ty TNHH Nhập khẩu Thiết bị Y tế Thành An','0966554433','thanhanmed@gmail.com','Số 89, Đường Hùng Vương, Thành phố Tuy Hòa, Phú Yên','Công ty TNHH Nhập khẩu Thiết bị Y tế Thành An',32,'active','2026-07-21 01:18:16',3,'2026-07-21 01:18:16',NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_log`
--

LOCK TABLES `system_log` WRITE;
/*!40000 ALTER TABLE `system_log` DISABLE KEYS */;
INSERT INTO `system_log` VALUES (1,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/inventory/list','Cannot invoke \"com.mysql.cj.protocol.ColumnDefinition.findColumn(String, boolean, int)\" because \"this.columnDefinition\" is null','java.lang.NullPointerException: Cannot invoke \"com.mysql.cj.protocol.ColumnDefinition.findColumn(String, boolean, int)\" because \"this.columnDefinition\" is null\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.findColumn(ResultSetImpl.java:581)\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.getString(ResultSetImpl.java:896)\r\n	at com.quanlymayphatdien.g1.dal.InventoryDAO.getFromResultSet(InventoryDAO.java:1196)\r\n	at com.quanlymayphatdien.g1.dal.InventoryDAO.findByFilters(InventoryDAO.java:158)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.inventory.InventoryController.handleSerialDetail(InventoryController.java:225)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.inventory.InventoryController.handleListView(InventoryController.java:150)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.inventory.InventoryController.doGet(InventoryController.java:68)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\n','2026-08-07 02:03:13'),(2,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/inventory/list','Cannot invoke \"com.mysql.cj.protocol.ColumnDefinition.findColumn(String, boolean, int)\" because \"this.columnDefinition\" is null','java.lang.NullPointerException: Cannot invoke \"com.mysql.cj.protocol.ColumnDefinition.findColumn(String, boolean, int)\" because \"this.columnDefinition\" is null\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.findColumn(ResultSetImpl.java:581)\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.getInt(ResultSetImpl.java:851)\r\n	at com.quanlymayphatdien.g1.dal.InventoryDAO.countItemsByWarehouseAndGenerator(InventoryDAO.java:935)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.inventory.InventoryController.doGet(InventoryController.java:56)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\n','2026-08-07 02:10:05'),(3,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/reports','An exception occurred processing [view/report/report.jsp] at line [140]\r\n\r\n137:                                 <tr>\r\n138:                                     <td>${st.index + 1 + (currentPage - 1) * 15}</td>\r\n139:                                     <td><c:out value=\"${r.receiptCode}\"/></td>\r\n140:                                     <td><fmt:formatDate value=\"${r.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n141:                                     <td><c:out value=\"${r.warehouseName}\"/></td>\r\n142:                                     <c:if test=\"${reportType == \'export\'}\"><td><c:out value=\"${r.customerName}\"/></td></c:if>\r\n143:                                     <c:if test=\"${reportType == \'import\'}\"><td><c:out value=\"${r.purchaseOrderCode}\"/></td></c:if>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [view/report/report.jsp] at line [140]\r\n\r\n137:                                 <tr>\r\n138:                                     <td>${st.index + 1 + (currentPage - 1) * 15}</td>\r\n139:                                     <td><c:out value=\"${r.receiptCode}\"/></td>\r\n140:                                     <td><fmt:formatDate value=\"${r.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n141:                                     <td><c:out value=\"${r.warehouseName}\"/></td>\r\n142:                                     <c:if test=\"${reportType == \'export\'}\"><td><c:out value=\"${r.customerName}\"/></td></c:if>\r\n143:                                     <c:if test=\"${reportType == \'import\'}\"><td><c:out value=\"${r.purchaseOrderCode}\"/></td></c:if>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.report.ReportController.showReport(ReportController.java:180)\r\n	at com.quanlymayphatdien.g1.controller.report.ReportController.doGet(ReportController.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-05T01:53:23] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_fmt_005fformatDate_005f0(report_jsp.java:1202)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_c_005fforEach_005f3(report_jsp.java:1130)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_c_005fwhen_005f7(report_jsp.java:1027)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_c_005fchoose_005f1(report_jsp.java:758)\r\n	at org.apache.jsp.view.report.report_jsp._jspService(report_jsp.java:256)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 02:18:20'),(4,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/reports','An exception occurred processing [view/report/report.jsp] at line [220]\r\n\r\n217:                                     <td><c:out value=\"${po.period}\"/></td>\r\n218:                                     <td class=\"num\">${po.totalQuantity}</td>\r\n219:                                     <td><c:out value=\"${po.createdByName}\"/></td>\r\n220:                                     <td><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n221:                                     <td><span class=\"status-badge status-${fn:toLowerCase(po.status)}\"><c:out value=\"${po.status}\"/></span></td>\r\n222:                                 </tr>\r\n223:                             </c:forEach>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [view/report/report.jsp] at line [220]\r\n\r\n217:                                     <td><c:out value=\"${po.period}\"/></td>\r\n218:                                     <td class=\"num\">${po.totalQuantity}</td>\r\n219:                                     <td><c:out value=\"${po.createdByName}\"/></td>\r\n220:                                     <td><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n221:                                     <td><span class=\"status-badge status-${fn:toLowerCase(po.status)}\"><c:out value=\"${po.status}\"/></span></td>\r\n222:                                 </tr>\r\n223:                             </c:forEach>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.report.ReportController.showReport(ReportController.java:180)\r\n	at com.quanlymayphatdien.g1.controller.report.ReportController.doGet(ReportController.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-04T02:06:58] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_fmt_005fformatDate_005f1(report_jsp.java:1820)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_c_005fforEach_005f5(report_jsp.java:1713)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_c_005fwhen_005f9(report_jsp.java:1647)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_c_005fchoose_005f1(report_jsp.java:768)\r\n	at org.apache.jsp.view.report.report_jsp._jspService(report_jsp.java:256)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 02:19:54'),(5,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/reports','An exception occurred processing [view/report/report.jsp] at line [220]\r\n\r\n217:                                     <td><c:out value=\"${po.period}\"/></td>\r\n218:                                     <td class=\"num\">${po.totalQuantity}</td>\r\n219:                                     <td><c:out value=\"${po.createdByName}\"/></td>\r\n220:                                     <td><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n221:                                     <td><span class=\"status-badge status-${fn:toLowerCase(po.status)}\"><c:out value=\"${po.status}\"/></span></td>\r\n222:                                 </tr>\r\n223:                             </c:forEach>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [view/report/report.jsp] at line [220]\r\n\r\n217:                                     <td><c:out value=\"${po.period}\"/></td>\r\n218:                                     <td class=\"num\">${po.totalQuantity}</td>\r\n219:                                     <td><c:out value=\"${po.createdByName}\"/></td>\r\n220:                                     <td><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n221:                                     <td><span class=\"status-badge status-${fn:toLowerCase(po.status)}\"><c:out value=\"${po.status}\"/></span></td>\r\n222:                                 </tr>\r\n223:                             </c:forEach>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.report.ReportController.showReport(ReportController.java:180)\r\n	at com.quanlymayphatdien.g1.controller.report.ReportController.doGet(ReportController.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-04T02:06:58] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_fmt_005fformatDate_005f1(report_jsp.java:1820)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_c_005fforEach_005f5(report_jsp.java:1713)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_c_005fwhen_005f9(report_jsp.java:1647)\r\n	at org.apache.jsp.view.report.report_jsp._jspx_meth_c_005fchoose_005f1(report_jsp.java:768)\r\n	at org.apache.jsp.view.report.report_jsp._jspService(report_jsp.java:256)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 02:20:47'),(6,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/reports','Uncompilable code - method queryInventoryReport in class com.quanlymayphatdien.g1.dal.InventoryReportDAO cannot be applied to given types;\n  required: java.lang.Integer,int,int,int,int,java.lang.String\n  found:    java.lang.Integer,int,int,int,int\n  reason: actual and formal argument lists differ in length','java.lang.RuntimeException: Uncompilable code - method queryInventoryReport in class com.quanlymayphatdien.g1.dal.InventoryReportDAO cannot be applied to given types;\n  required: java.lang.Integer,int,int,int,int,java.lang.String\n  found:    java.lang.Integer,int,int,int,int\n  reason: actual and formal argument lists differ in length\r\n	at com.quanlymayphatdien.g1.dal.InventoryReportDAO.getInventoryReport(InventoryReportDAO.java:1)\r\n	at com.quanlymayphatdien.g1.controller.report.ReportController.showReport(ReportController.java:122)\r\n	at com.quanlymayphatdien.g1.controller.report.ReportController.doGet(ReportController.java:61)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\n','2026-07-21 11:40:10'),(7,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/warehouse/suppliers','An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [154]\r\n\r\n151:                                         <td>${po.status}</td>\r\n152:                                         <td>${po.warehouseName}</td>\r\n153:                                         <td>${po.createdByName}</td>\r\n154:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n155:                                     </tr>\r\n156:                                 </c:forEach>\r\n157:                             </tbody>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [154]\r\n\r\n151:                                         <td>${po.status}</td>\r\n152:                                         <td>${po.warehouseName}</td>\r\n153:                                         <td>${po.createdByName}</td>\r\n154:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n155:                                     </tr>\r\n156:                                 </c:forEach>\r\n157:                             </tbody>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.viewDetail(SupplierController.java:188)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.doGet(SupplierController.java:46)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-02T01:41:36] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_fmt_005fformatDate_005f0(supplier_002ddetail_jsp.java:1069)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fforEach_005f0(supplier_002ddetail_jsp.java:1037)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fif_005f2(supplier_002ddetail_jsp.java:975)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspService(supplier_002ddetail_jsp.java:339)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 13:46:00'),(8,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/warehouse/suppliers','An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.viewDetail(SupplierController.java:188)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.doGet(SupplierController.java:46)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-02T01:41:36] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_fmt_005fformatDate_005f0(supplier_002ddetail_jsp.java:1075)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fforEach_005f0(supplier_002ddetail_jsp.java:1043)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fif_005f2(supplier_002ddetail_jsp.java:981)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspService(supplier_002ddetail_jsp.java:345)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 13:47:51'),(9,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/warehouse/suppliers','An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.viewDetail(SupplierController.java:188)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.doGet(SupplierController.java:46)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-02T01:41:36] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_fmt_005fformatDate_005f0(supplier_002ddetail_jsp.java:1075)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fforEach_005f0(supplier_002ddetail_jsp.java:1043)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fif_005f2(supplier_002ddetail_jsp.java:981)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspService(supplier_002ddetail_jsp.java:345)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 13:47:53'),(10,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/warehouse/suppliers','An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.viewDetail(SupplierController.java:188)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.doGet(SupplierController.java:46)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-02T01:41:36] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_fmt_005fformatDate_005f0(supplier_002ddetail_jsp.java:1075)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fforEach_005f0(supplier_002ddetail_jsp.java:1043)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fif_005f2(supplier_002ddetail_jsp.java:981)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspService(supplier_002ddetail_jsp.java:345)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 13:47:54'),(11,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/warehouse/suppliers','An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.viewDetail(SupplierController.java:188)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.doGet(SupplierController.java:46)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-02T01:41:36] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_fmt_005fformatDate_005f0(supplier_002ddetail_jsp.java:1075)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fforEach_005f0(supplier_002ddetail_jsp.java:1043)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fif_005f2(supplier_002ddetail_jsp.java:981)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspService(supplier_002ddetail_jsp.java:345)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 13:47:56'),(12,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/warehouse/suppliers','An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.viewDetail(SupplierController.java:188)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.doGet(SupplierController.java:46)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-02T01:41:36] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_fmt_005fformatDate_005f0(supplier_002ddetail_jsp.java:1075)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fforEach_005f0(supplier_002ddetail_jsp.java:1043)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fif_005f2(supplier_002ddetail_jsp.java:981)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspService(supplier_002ddetail_jsp.java:345)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 13:48:34'),(13,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/warehouse/suppliers','An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:','org.apache.jasper.JasperException: An exception occurred processing [/view/supplier/supplier-detail.jsp] at line [158]\r\n\r\n155:                                         <td>${po.status}</td>\r\n156:                                         <td>${po.warehouseName}</td>\r\n157:                                         <td>${po.createdByName}</td>\r\n158:                                         <td class=\"mono\"><fmt:formatDate value=\"${po.createdAt}\" pattern=\"dd/MM/yyyy\"/></td>\r\n159:                                     </tr>\r\n160:                                 </c:forEach>\r\n161:                             </tbody>\r\n\r\n\r\nStacktrace:\r\n	at org.apache.jasper.servlet.JspServletWrapper.handleJspException(JspServletWrapper.java:570)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:456)\r\n	at org.apache.jasper.servlet.JspServlet.serviceJspFile(JspServlet.java:350)\r\n	at org.apache.jasper.servlet.JspServlet.service(JspServlet.java:301)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.ApplicationDispatcher.invoke(ApplicationDispatcher.java:610)\r\n	at org.apache.catalina.core.ApplicationDispatcher.processRequest(ApplicationDispatcher.java:392)\r\n	at org.apache.catalina.core.ApplicationDispatcher.doForward(ApplicationDispatcher.java:321)\r\n	at org.apache.catalina.core.ApplicationDispatcher.forward(ApplicationDispatcher.java:266)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.viewDetail(SupplierController.java:188)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.SupplierController.doGet(SupplierController.java:46)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\nCaused by: jakarta.el.ELException: Cannot convert [2026-08-04T01:43:39] of type [class java.time.LocalDateTime] to [class java.util.Date]\r\n	at org.apache.el.lang.ELSupport.coerceToType(ELSupport.java:586)\r\n	at org.apache.el.ExpressionFactoryImpl.coerceToType(ExpressionFactoryImpl.java:43)\r\n	at jakarta.el.ELContext.convertToType(ELContext.java:326)\r\n	at org.apache.el.ValueExpressionImpl.getValue(ValueExpressionImpl.java:152)\r\n	at org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate(PageContextImpl.java:666)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_fmt_005fformatDate_005f0(supplier_002ddetail_jsp.java:1075)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fforEach_005f0(supplier_002ddetail_jsp.java:1043)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspx_meth_c_005fif_005f2(supplier_002ddetail_jsp.java:981)\r\n	at org.apache.jsp.view.supplier.supplier_002ddetail_jsp._jspService(supplier_002ddetail_jsp.java:345)\r\n	at org.apache.jasper.runtime.HttpJspBase.service(HttpJspBase.java:62)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.jasper.servlet.JspServletWrapper.service(JspServletWrapper.java:428)\r\n	... 47 more\r\n','2026-07-21 13:49:34'),(14,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/inventory/list','Cannot invoke \"com.mysql.cj.protocol.ColumnDefinition.findColumn(String, boolean, int)\" because \"this.columnDefinition\" is null','java.lang.NullPointerException: Cannot invoke \"com.mysql.cj.protocol.ColumnDefinition.findColumn(String, boolean, int)\" because \"this.columnDefinition\" is null\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.findColumn(ResultSetImpl.java:581)\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.getInt(ResultSetImpl.java:851)\r\n	at com.quanlymayphatdien.g1.dal.InventoryDAO.countItemsByWarehouseAndGenerator(InventoryDAO.java:943)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.inventory.InventoryController.doGet(InventoryController.java:56)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\n','2026-09-04 14:45:11'),(15,'ERROR','Hệ thống',NULL,'Loi Ngoai Le','Operation not allowed after ResultSet closed','java.sql.SQLException: Operation not allowed after ResultSet closed\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:130)\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:98)\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:90)\r\n	at com.mysql.cj.jdbc.exceptions.SQLError.createSQLException(SQLError.java:64)\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.checkClosed(ResultSetImpl.java:485)\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.checkRowPos(ResultSetImpl.java:529)\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.getObject(ResultSetImpl.java:1322)\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.getInt(ResultSetImpl.java:830)\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.getInt(ResultSetImpl.java:851)\r\n	at com.quanlymayphatdien.g1.dal.WarehouseDAO.getFromResultSet(WarehouseDAO.java:190)\r\n	at com.quanlymayphatdien.g1.dal.WarehouseDAO.findById(WarehouseDAO.java:116)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.inventory.InventoryController.handleListView(InventoryController.java:137)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.inventory.InventoryController.doGet(InventoryController.java:68)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\n','2026-09-04 14:45:42'),(16,'ERROR','Hệ thống',NULL,'GET /SWP391-QuanLyMayPhatDien-G1/inventory/list','Cannot invoke \"com.mysql.cj.protocol.ColumnDefinition.findColumn(String, boolean, int)\" because \"this.columnDefinition\" is null','java.lang.NullPointerException: Cannot invoke \"com.mysql.cj.protocol.ColumnDefinition.findColumn(String, boolean, int)\" because \"this.columnDefinition\" is null\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.findColumn(ResultSetImpl.java:581)\r\n	at com.mysql.cj.jdbc.result.ResultSetImpl.getInt(ResultSetImpl.java:851)\r\n	at com.quanlymayphatdien.g1.dal.WarehouseDAO.getFromResultSet(WarehouseDAO.java:190)\r\n	at com.quanlymayphatdien.g1.dal.WarehouseDAO.findById(WarehouseDAO.java:116)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.inventory.InventoryController.handleListView(InventoryController.java:137)\r\n	at com.quanlymayphatdien.g1.controller.warehouse.inventory.InventoryController.doGet(InventoryController.java:68)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:564)\r\n	at jakarta.servlet.http.HttpServlet.service(HttpServlet.java:658)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:193)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.tomcat.websocket.server.WsFilter.doFilter(WsFilter.java:51)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SystemLogFilter.doFilter(SystemLogFilter.java:23)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.SecurityFilter.doFilter(SecurityFilter.java:197)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at com.quanlymayphatdien.g1.filter.EncodingFilter.doFilter(EncodingFilter.java:22)\r\n	at org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:162)\r\n	at org.apache.catalina.core.ApplicationFilterChain.doFilter(ApplicationFilterChain.java:138)\r\n	at org.apache.catalina.core.StandardWrapperValve.invoke(StandardWrapperValve.java:165)\r\n	at org.apache.catalina.core.StandardContextValve.invoke(StandardContextValve.java:88)\r\n	at org.apache.catalina.authenticator.AuthenticatorBase.invoke(AuthenticatorBase.java:482)\r\n	at org.apache.catalina.core.StandardHostValve.invoke(StandardHostValve.java:113)\r\n	at org.apache.catalina.valves.ErrorReportValve.invoke(ErrorReportValve.java:83)\r\n	at org.apache.catalina.valves.AbstractAccessLogValve.invoke(AbstractAccessLogValve.java:654)\r\n	at org.apache.catalina.core.StandardEngineValve.invoke(StandardEngineValve.java:72)\r\n	at org.apache.catalina.connector.CoyoteAdapter.service(CoyoteAdapter.java:342)\r\n	at org.apache.coyote.http11.Http11Processor.service(Http11Processor.java:399)\r\n	at org.apache.coyote.AbstractProcessorLight.process(AbstractProcessorLight.java:63)\r\n	at org.apache.coyote.AbstractProtocol$ConnectionHandler.process(AbstractProtocol.java:903)\r\n	at org.apache.tomcat.util.net.NioEndpoint$SocketProcessor.doRun(NioEndpoint.java:1774)\r\n	at org.apache.tomcat.util.net.SocketProcessorBase.run(SocketProcessorBase.java:52)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:973)\r\n	at org.apache.tomcat.util.threads.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:491)\r\n	at org.apache.tomcat.util.threads.TaskThread$WrappingRunnable.run(TaskThread.java:63)\r\n	at java.base/java.lang.Thread.run(Thread.java:842)\r\n','2026-09-04 14:45:42');
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
  `export_receipt_id` int DEFAULT NULL,
  `import_receipt_id` int DEFAULT NULL,
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
  KEY `fk_tr_export_receipt` (`export_receipt_id`),
  KEY `fk_tr_import_receipt` (`import_receipt_id`),
  CONSTRAINT `fk_tr_ceo` FOREIGN KEY (`ceo_reviewed_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_tr_created` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_tr_dst` FOREIGN KEY (`dest_warehouse_id`) REFERENCES `warehouse` (`warehouse_id`),
  CONSTRAINT `fk_tr_export_receipt` FOREIGN KEY (`export_receipt_id`) REFERENCES `receipt` (`receipt_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_tr_final` FOREIGN KEY (`final_reviewed_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_tr_import_receipt` FOREIGN KEY (`import_receipt_id`) REFERENCES `receipt` (`receipt_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_tr_mgr1` FOREIGN KEY (`manager_reviewed_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_tr_src` FOREIGN KEY (`source_warehouse_id`) REFERENCES `warehouse` (`warehouse_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
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
  `warehouse_id` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`),
  UNIQUE KEY `uk_email` (`email`),
  KEY `idx_created_by` (`created_by`),
  KEY `idx_updated_by` (`updated_by`),
  KEY `fk_user_warehouse` (`warehouse_id`),
  CONSTRAINT `fk_user_created_by` FOREIGN KEY (`created_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_user_updated_by` FOREIGN KEY (`updated_by`) REFERENCES `user` (`id`),
  CONSTRAINT `fk_user_warehouse` FOREIGN KEY (`warehouse_id`) REFERENCES `warehouse` (`warehouse_id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (3,'Admin','admin','admin123','admin@warehouse.com','0846723771','30','active','2026-05-16 18:57:20','2026-07-27 16:54:39',NULL,NULL,NULL),(4,'Nguyễn Văn Nam','salestaff1','$2a$10$zBXM5qSw.D.8QN8Kdp8FZ.SJ33GhtgKXLlRcW1rFpH0N71LoF0hAK','salestaff1@warehouse.com','0912345678','Bắc Giang','active','2026-05-21 08:00:00','2026-06-09 10:24:54',3,NULL,NULL),(5,'Trần Thị Hương','salemanager1','123','salemanager1@warehouse.com','0912345679','Hà Nội','active','2026-05-21 08:00:00','2026-05-21 15:20:58',3,NULL,NULL),(6,'Lê Văn Cường','warehousestaff1','123','warehousestaff1@warehouse.com','0912345680','Hà Nội','active','2026-05-21 08:00:00','2026-07-01 13:40:26',3,NULL,1),(8,'Phạm Minh Tuấn','warehousemanager1','123','warehousemanager1@warehouse.com','0912345681','Hồ Chí Minh','active','2026-05-21 08:00:00','2026-07-27 16:34:59',3,NULL,NULL),(13,'CEO','ceo','$2a$10$fZ1zHDvp3bWhbIn/QPH5n.k3rENJEK7TAUt7WrbQ7QZvnnnnsragG','ceo@gmail.com','0846723711','30','active','2026-06-19 16:58:07','2026-06-29 21:51:21',1,NULL,1),(14,'Nguyễn Thị B','thib','123','thib@gmail.com','0914563286','Thái Nguyên','active','2026-07-27 10:48:32','2026-07-27 16:31:27',NULL,NULL,NULL),(15,'Nguyễn Linh','linh','123','linh@gmail.com','0861235469','','active','2026-05-13 11:13:15','2026-05-13 11:15:54',NULL,NULL,NULL),(20,'Thi C','ThiC','$2a$10$yPHMb0wDIeDrzmf/B/o4Wu4yr7H3g0VhSaB2n2kLy0xXkX6tvt3IG','van@gmail.com','0846723790','30','active','2026-07-27 16:52:11','2026-07-27 16:52:27',3,NULL,NULL);
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
INSERT INTO `user_permission` VALUES (14,45,'GRANT'),(14,46,'GRANT'),(14,47,'GRANT'),(14,48,'GRANT'),(14,91,'GRANT'),(14,95,'GRANT'),(14,96,'GRANT'),(14,97,'GRANT'),(14,98,'GRANT'),(14,111,'GRANT'),(14,113,'GRANT'),(14,114,'GRANT'),(14,115,'GRANT'),(14,116,'GRANT'),(14,117,'GRANT'),(14,118,'GRANT'),(14,119,'GRANT'),(14,120,'GRANT'),(14,137,'GRANT'),(14,138,'GRANT'),(14,139,'GRANT'),(14,140,'GRANT'),(15,10,'GRANT'),(15,11,'GRANT'),(15,12,'GRANT'),(15,22,'GRANT'),(15,45,'GRANT'),(15,46,'GRANT'),(15,47,'GRANT'),(15,48,'GRANT'),(15,91,'GRANT'),(15,95,'GRANT'),(15,96,'GRANT'),(15,97,'GRANT'),(15,98,'GRANT'),(15,111,'GRANT'),(15,113,'GRANT'),(15,114,'GRANT'),(15,115,'GRANT'),(15,116,'GRANT'),(15,117,'GRANT'),(15,118,'GRANT'),(15,119,'GRANT'),(15,120,'GRANT'),(15,137,'GRANT'),(15,138,'GRANT'),(15,139,'GRANT'),(15,140,'GRANT');
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
INSERT INTO `user_role` VALUES (3,1),(8,2),(6,3),(4,5),(14,5),(15,5),(5,10),(13,13),(20,13);
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

-- Dump completed on 2026-07-27 23:51:47
