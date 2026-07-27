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
) ENGINE=InnoDB AUTO_INCREMENT=261 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `activity_log`
--

LOCK TABLES `activity_log` WRITE;
/*!40000 ALTER TABLE `activity_log` DISABLE KEYS */;
INSERT INTO `activity_log` VALUES (78,2,'import_proposal','CREATE',7,'PRC-20260630-001','Tạo phiếu đề xuất từ Excel (gửi duyệt) — 3 dòng','2026-06-30 13:35:58'),(79,5,'import_proposal','APPROVE',7,'PRC-20260630-001','Duyệt phiếu đề xuất','2026-06-30 13:37:00'),(80,3,'user','UPDATE',6,'Lê Văn Cường','Cập nhật người dùng #6 (Lê Văn Cường): kho: \"Kho Hồ Chí Minh\" → \"Kho Hà Nội\"','2026-07-01 13:40:28'),(81,6,'receipt','CREATE',14,'RX-IM-20260701-399','Tạo phiếu nhập kho và cập nhật tồn kho','2026-07-01 13:45:37'),(82,6,'receipt','CREATE',15,'RX-EX-20260701-973','Tạo phiếu xuất kho và cập nhật tồn kho','2026-07-01 13:53:21'),(83,8,'receipt','SCAN_EXPORT',16,'scan:1233223','Quet barcode xuat serial 1233223','2026-07-01 13:57:54'),(84,8,'receipt','SUBMIT_DRAFT',16,'RX-EX-20260701-946','Tạo phiếu xuất kho và cập nhật tồn kho','2026-07-01 13:58:19'),(85,8,'receipt','SCAN_EXPORT',17,'scan:123213213','Quet barcode xuat serial 123213213','2026-07-01 14:02:13'),(86,8,'receipt','SCAN_EXPORT',17,'scan:21321323213','Quet barcode xuat serial 21321323213','2026-07-01 14:02:21'),(87,3,'categories','CREATE',84,'E05','Thêm mới: \'E05\' (Nhiên liệu) — Trạng thái: Hoạt động | module:quản lý vật tư','2026-07-01 14:16:18'),(88,3,'transfer','CREATE',2,'TRF-20260701-319','Tao phieu luan chuyen (PENDING_CEO)','2026-07-01 14:42:41'),(89,3,'inventory_check','CREATE',3,'IC-20260701-534','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-01 14:44:47'),(90,3,'inventory_check','UPDATE',3,'IC-20260701-534','Cập nhật số lượng kiểm kê','2026-07-01 14:45:09'),(91,3,'inventory_check','COMPLETE',3,'IC-20260701-534','Hoàn thành kiểm kê','2026-07-01 14:45:12'),(92,3,'liquidation','CREATE',8,'LIQ1782891960010','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1782891960010','2026-07-01 14:46:00'),(93,3,'receipt','AUTO_CREATE',18,'PX-LIQ-1782891992615','He thong tu dong tao phieu xuat kho cho duyet sau khi CEO duyet don thanh ly LIQ1782891960010','2026-07-01 14:46:33'),(94,3,'liquidation','CEO_APPROVE',8,'LIQ1782891960010','CEO duyet don thanh ly va tu dong sinh Phieu Xuat Kho cho duyet: PX-LIQ-1782891992615','2026-07-01 14:46:33'),(95,3,'liquidation','CREATE',9,'LIQ1782916474251','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1782916474251','2026-07-01 21:34:34'),(96,3,'liquidation','CEO_REQUEST_EDIT',9,'LIQ1782916474251','CEO yêu cầu sửa đơn thanh lý','2026-07-01 21:34:54'),(97,3,'liquidation','EDIT_SUBMIT',9,'LIQ1782916474251','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-07-01 21:35:00'),(98,3,'receipt','AUTO_CREATE',19,'PX-LIQ-1782916523932','He thong tu dong tao phieu xuat kho cho duyet sau khi CEO duyet don thanh ly LIQ1782916474251','2026-07-01 21:35:24'),(99,3,'liquidation','CEO_APPROVE',9,'LIQ1782916474251','CEO duyet don thanh ly va tu dong sinh Phieu Xuat Kho cho duyet: PX-LIQ-1782916523932','2026-07-01 21:35:24'),(100,3,'import_proposal','CREATE',8,'PRC-20260701-001','Tạo phiếu đề xuất từ Excel (gửi duyệt) — 1 dòng','2026-07-01 23:59:08'),(101,3,'import_proposal','APPROVE',8,'PRC-20260701-001','Duyệt phiếu đề xuất','2026-08-01 23:59:32'),(102,3,'receipt','CREATE',20,'RX-IM-20260802-244','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-02 00:00:00'),(103,3,'inventory_check','CREATE',4,'IC-20260802-910','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-08-02 00:00:23'),(104,3,'inventory_check','UPDATE',4,'IC-20260802-910','Cập nhật số lượng kiểm kê','2026-08-02 00:00:38'),(105,3,'inventory_check','COMPLETE',4,'IC-20260802-910','Hoàn thành kiểm kê','2026-08-02 00:00:40'),(106,3,'liquidation','REJECTED_BY_CEO',10,'LIQ1782933734007','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-07-02 13:05:18'),(107,3,'liquidation','CREATE',11,'LIQ1782973081788','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1782973081788','2026-07-02 13:18:02'),(108,3,'liquidation','CEO_REQUEST_EDIT',11,'LIQ1782973081788','CEO yêu cầu sửa đơn thanh lý','2026-07-02 13:18:06'),(109,3,'liquidation','EDIT_SUBMIT',11,'LIQ1782973081788','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-07-02 13:58:11'),(110,3,'liquidation','REJECTED_BY_CEO',11,'LIQ1782973081788','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-07-02 14:00:34'),(111,3,'liquidation','CREATE',12,'LIQ1782976121003','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1782976121003','2026-07-02 14:08:41'),(112,3,'liquidation','REJECTED_BY_CEO',12,'LIQ1782976121003','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-07-02 14:09:14'),(113,3,'inventory_check','CREATE',5,'IC-20260702-874','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-02 14:10:01'),(114,3,'import_proposal','CREATE',9,'PRC-20260702-001','Tạo phiếu đề xuất từ Excel (gửi duyệt) — 1 dòng','2026-07-02 14:11:22'),(115,3,'import_proposal','APPROVE',9,'PRC-20260702-001','Duyệt phiếu đề xuất','2026-07-02 14:11:29'),(116,3,'receipt','CREATE',21,'RX-IM-20260802-425','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-02 14:12:24'),(117,3,'inventory_check','CREATE',6,'IC-20260802-838','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-08-02 14:12:48'),(118,3,'inventory_check','UPDATE',6,'IC-20260802-838','Cập nhật số lượng kiểm kê','2026-08-02 14:13:15'),(119,3,'inventory_check','COMPLETE',6,'IC-20260802-838','Hoàn thành kiểm kê','2026-08-02 14:13:17'),(120,3,'liquidation','CREATE',13,'LIQ1785654824979','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1785654824979','2026-08-02 14:13:45'),(121,3,'liquidation','REJECTED_BY_CEO',13,'LIQ1785654824979','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-08-02 14:14:19'),(122,3,'liquidation','CREATE',14,'LIQ1785654936327','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1785654936327','2026-08-02 14:15:36'),(123,3,'roles','UPDATE_ROLE',2,'warehouse_manager','Cập nhật vai trò \'warehouse_manager\'','2026-08-02 14:23:45'),(124,3,'roles','UPDATE_PERMISSIONS',2,'warehouse_manager','Thêm: liquidations.create','2026-08-02 14:23:45'),(125,8,'liquidation','CREATE',15,'LIQ1785656105972','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1785656105972','2026-08-02 14:35:06'),(126,3,'liquidation','CREATE',16,'LIQ1783367956785','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783367956785','2026-07-07 02:59:17'),(127,3,'liquidation','CREATE',17,'LIQ1783368819822','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783368819822','2026-07-07 03:13:40'),(128,3,'receipt','AUTO_CREATE',22,'PX-LIQ-1783369174874','He thong tu dong tao phieu xuat kho cho duyet sau khi CEO duyet don thanh ly LIQ1785656105972','2026-07-07 03:19:35'),(129,3,'liquidation','CEO_APPROVE',15,'LIQ1785656105972','CEO duyet don thanh ly va tu dong sinh Phieu Xuat Kho cho duyet: PX-LIQ-1783369174874','2026-07-07 03:19:35'),(130,3,'liquidation','REJECTED_BY_CEO',14,'LIQ1785654936327','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-07-07 13:07:35'),(131,3,'liquidation','REJECTED_BY_CEO',16,'LIQ1783367956785','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-07-07 13:08:03'),(132,3,'liquidation','REJECTED_BY_CEO',17,'LIQ1783368819822','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-07-07 13:08:13'),(133,3,'liquidation','CREATE',18,'LIQ1783408861714','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783408861714','2026-07-07 14:21:02'),(134,3,'receipt','AUTO_CREATE',23,'PX-LIQ-1786121360781','He thong tu dong tao phieu xuat kho cho duyet sau khi CEO duyet don thanh ly LIQ1783408861714','2026-08-07 23:49:21'),(135,3,'liquidation','CEO_APPROVE',18,'LIQ1783408861714','CEO duyet don thanh ly va tu dong sinh Phieu Xuat Kho cho duyet: PX-LIQ-1786121360781','2026-08-07 23:49:21'),(136,3,'liquidation','CREATE',19,'LIQ1786122786759','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1786122786759','2026-08-08 00:13:07'),(137,3,'receipt','AUTO_CREATE',24,'PX-LIQ-1786122791110','He thong tu dong tao phieu xuat kho cho duyet sau khi CEO duyet don thanh ly LIQ1786122786759','2026-08-08 00:13:11'),(138,3,'liquidation','CEO_APPROVE',19,'LIQ1786122786759','CEO duyet don thanh ly va tu dong sinh Phieu Xuat Kho cho duyet: PX-LIQ-1786122791110','2026-08-08 00:13:11'),(139,3,'liquidation','CREATE',20,'LIQ1786124920144','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1786124920144','2026-08-08 00:48:40'),(140,3,'liquidation','CEO_REQUEST_EDIT',20,'LIQ1786124920144','CEO yêu cầu sửa đơn thanh lý','2026-08-08 00:48:48'),(141,3,'liquidation','EDIT_SUBMIT',20,'LIQ1786124920144','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-08-08 00:49:39'),(142,3,'receipt','AUTO_CREATE',25,'PX-LIQ-1786124983190','He thong tu dong tao phieu xuat kho cho duyet sau khi CEO duyet don thanh ly LIQ1786124920144','2026-08-08 00:49:43'),(143,3,'liquidation','CEO_APPROVE',20,'LIQ1786124920144','CEO duyet don thanh ly va tu dong sinh Phieu Xuat Kho cho duyet: PX-LIQ-1786124983190','2026-08-08 00:49:43'),(144,3,'liquidation','CREATE',21,'LIQ1783452444719','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783452444719','2026-07-08 02:27:25'),(145,3,'liquidation','CEO_REQUEST_EDIT',21,'LIQ1783452444719','CEO yêu cầu sửa đơn thanh lý','2026-07-08 02:27:31'),(146,3,'liquidation','EDIT_SUBMIT',21,'LIQ1783452444719','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-07-08 02:51:17'),(147,3,'liquidation','CEO_REQUEST_EDIT',21,'LIQ1783452444719','CEO yêu cầu sửa đơn thanh lý','2026-07-08 02:51:22'),(148,3,'liquidation','EDIT_SUBMIT',21,'LIQ1783452444719','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-07-08 02:58:16'),(149,3,'liquidation','CREATE',22,'LIQ1783454877354','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783454877354','2026-07-08 03:07:57'),(150,3,'liquidation','CEO_REQUEST_EDIT',22,'LIQ1783454877354','CEO yêu cầu sửa đơn thanh lý','2026-07-08 03:08:07'),(151,3,'liquidation','EDIT_SUBMIT',22,'LIQ1783454877354','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-07-08 03:08:13'),(152,3,'liquidation','CANCELLED',22,'LIQ1783454877354','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-07-08 03:08:19'),(153,3,'receipt','AUTO_CREATE',26,'PX-LIQ-1783454907977','He thong tu dong tao phieu xuat kho cho duyet sau khi CEO duyet don thanh ly LIQ1783452444719','2026-07-08 03:08:28'),(154,3,'liquidation','CEO_APPROVE',21,'LIQ1783452444719','CEO duyet don thanh ly va tu dong sinh Phieu Xuat Kho cho duyet: PX-LIQ-1783454907977','2026-07-08 03:08:28'),(155,3,'liquidation','CREATE',23,'LIQ1783455502305','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783455502305','2026-07-08 03:18:22'),(156,3,'receipt','AUTO_CREATE',27,'PX-LIQ-1783455506425','Hệ thống tự động tạo phiếu xuất kho cho duyệt sau khi CEO duyệt đơn thanh lý LIQ1783455502305','2026-07-08 03:18:26'),(157,3,'liquidation','CEO_APPROVE',23,'LIQ1783455502305','CEO duyệt đơn thanh lý và tự động sinh <a href=\"/SWP391-QuanLyMayPhatDien-G1/export-receipt?action=detail&id=27\">Phiếu Xuất Kho PX-LIQ-1783455506425</a> cho duyệt','2026-07-08 03:18:26'),(158,3,'liquidation','CREATE',24,'LIQ1783455668245','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783455668245','2026-07-08 03:21:08'),(159,3,'liquidation','CEO_REQUEST_EDIT',24,'LIQ1783455668245','CEO yêu cầu sửa đơn thanh lý','2026-07-08 03:21:16'),(160,3,'liquidation','EDIT_SUBMIT',24,'LIQ1783455668245','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-07-08 03:21:23'),(161,3,'receipt','AUTO_CREATE',28,'PX-LIQ-1783455688493','Hệ thống tự động tạo phiếu xuất kho cho duyệt sau khi CEO duyệt đơn thanh lý LIQ1783455668245','2026-07-08 03:21:29'),(162,3,'liquidation','CEO_APPROVE',24,'LIQ1783455668245','CEO duyệt đơn thanh lý và tự động sinh <a href=\"/SWP391-QuanLyMayPhatDien-G1/export-receipt?action=detail&id=28\">Phiếu Xuất Kho PX-LIQ-1783455688493</a> cho duyệt','2026-07-08 03:21:29'),(163,3,'liquidation','CREATE',25,'LIQ1783862672511','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783862672511','2026-07-12 20:24:33'),(164,13,'receipt','AUTO_CREATE',29,'PX-LIQ-1783863179251','Hệ thống tự động tạo phiếu xuất kho cho duyệt sau khi CEO duyệt đơn thanh lý LIQ1783862672511','2026-07-12 20:32:59'),(165,13,'liquidation','CEO_APPROVE',25,'LIQ1783862672511','CEO duyệt đơn thanh lý và tự động sinh <a href=\"/SWP391-QuanLyMayPhatDien-G1/export-receipt?action=detail&id=29\">Phiếu Xuất Kho PX-LIQ-1783863179251</a> cho duyệt','2026-07-12 20:32:59'),(166,8,'liquidation','CREATE',26,'LIQ1783863743215','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783863743215','2026-07-12 20:42:23'),(167,13,'liquidation','CEO_REQUEST_EDIT',26,'LIQ1783863743215','CEO yêu cầu sửa đơn thanh lý','2026-07-12 21:09:44'),(168,8,'liquidation','EDIT_SUBMIT',26,'LIQ1783863743215','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-07-12 23:20:10'),(169,3,'liquidation','CEO_REQUEST_EDIT',26,'LIQ1783863743215','CEO yêu cầu sửa đơn thanh lý','2026-07-13 00:56:13'),(170,8,'liquidation','CREATE',27,'LIQ1783917585889','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1783917585889','2026-07-13 11:39:46'),(171,3,'liquidation','CANCELLED',27,'LIQ1783917585889','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-07-13 11:41:42'),(172,3,'import_proposal','CREATE',10,'PRC-20260714-001','Tạo phiếu đề xuất (gửi duyệt)','2026-07-14 13:30:36'),(173,3,'liquidation','CREATE',28,'LIQ1784141737073','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1784141737073','2026-07-16 01:55:37'),(174,3,'liquidation','CEO_APPROVE',28,'LIQ1784141737073','CEO duyệt đơn thanh lý, chờ tạo phiếu xuất kho','2026-07-16 01:55:45'),(175,3,'inventory_check','CREATE',7,'IC-20260716-713','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-16 03:54:38'),(176,3,'import_proposal','APPROVE',10,'PRC-20260714-001','Duyệt phiếu đề xuất','2026-07-17 04:55:08'),(177,3,'receipt','CREATE',30,'RX-IM-20260803-325','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-03 05:08:18'),(178,3,'liquidation','EDIT_SUBMIT',26,'LIQ1783863743215','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-07-17 05:47:32'),(179,3,'liquidation','CANCELLED',26,'LIQ1783863743215','CEO từ chối và huỷ bỏ đơn thanh lý vĩnh viễn','2026-07-17 05:47:37'),(180,3,'inventory_check','CREATE',8,'IC-20260717-482','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-17 05:49:03'),(181,3,'inventory_check','UPDATE',8,'IC-20260717-482','Cập nhật số lượng kiểm kê','2026-07-17 05:49:23'),(182,3,'inventory_check','COMPLETE',8,'IC-20260717-482','Hoàn thành kiểm kê','2026-07-17 05:49:26'),(183,3,'inventory_check','CREATE',9,'IC-20260717-771','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-17 06:12:33'),(184,3,'inventory_check','UPDATE',9,'IC-20260717-771','Cập nhật số lượng kiểm kê','2026-07-17 06:12:47'),(185,3,'inventory_check','CREATE',10,'IC-20260717-567','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-17 06:16:18'),(186,3,'inventory_check','UPDATE',9,'IC-20260717-771','Cập nhật số lượng kiểm kê','2026-07-17 06:16:30'),(187,3,'inventory_check','UPDATE',9,'IC-20260717-771','Cập nhật số lượng kiểm kê','2026-07-17 06:18:32'),(188,3,'inventory_check','CREATE',11,'IC-20260717-848','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-17 06:25:25'),(189,3,'inventory_check','UPDATE',11,'IC-20260717-848','Cập nhật số lượng kiểm kê','2026-07-17 06:25:40'),(190,3,'inventory_check','COMPLETE',11,'IC-20260717-848','Hoàn thành kiểm kê','2026-07-17 06:25:43'),(191,3,'inventory_check','CREATE',12,'IC-20260717-715','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-17 06:43:30'),(192,3,'inventory_check','UPDATE',12,'IC-20260717-715','Cập nhật số lượng kiểm kê','2026-07-17 06:43:45'),(193,3,'inventory_check','COMPLETE',12,'IC-20260717-715','Hoàn thành kiểm kê','2026-07-17 06:43:47'),(194,3,'inventory_check','CREATE',13,'IC-20260717-241','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-17 06:51:19'),(195,3,'inventory_check','UPDATE',13,'IC-20260717-241','Cập nhật số lượng kiểm kê','2026-07-17 06:51:32'),(196,3,'inventory_check','COMPLETE',13,'IC-20260717-241','Hoàn thành kiểm kê','2026-07-17 06:51:35'),(197,8,'liquidation','CREATE',29,'LIQ1784246170590','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1784246170590','2026-07-17 06:56:11'),(198,13,'liquidation','CEO_APPROVE',29,'LIQ1784246170590','CEO duyệt đơn thanh lý, chờ tạo phiếu xuất kho','2026-07-17 06:56:46'),(199,8,'liquidation','EXPORT_APPROVE',29,'RX-EX-20260717-462','Hoàn tất xuất kho cho đơn thanh lý RX-EX-20260717-462.','2026-07-17 06:57:27'),(200,8,'receipt','CREATE',31,'RX-EX-20260717-462','Tạo phiếu xuất kho và cập nhật tồn kho','2026-07-17 06:57:27'),(201,6,'liquidation','EXPORT_APPROVE',28,'RX-EX-20260717-844','Hoàn tất xuất kho cho đơn thanh lý RX-EX-20260717-844.','2026-07-17 07:13:05'),(202,6,'receipt','CREATE',32,'RX-EX-20260717-844','Tạo phiếu xuất kho và cập nhật tồn kho','2026-07-17 07:13:05'),(203,3,'liquidation','CREATE',30,'LIQ1784270036789','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1784270036789','2026-07-17 13:33:57'),(204,3,'liquidation','CEO_APPROVE',30,'LIQ1784270036789','CEO duyệt đơn thanh lý, chờ tạo phiếu xuất kho','2026-07-17 13:34:04'),(205,3,'inventory_check','CREATE',14,'IC-20260717-252','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-17 13:38:43'),(206,3,'import_proposal','CREATE',11,'PRC-20260717-001','Tạo phiếu đề xuất (gửi duyệt)','2026-07-17 14:52:12'),(207,3,'import_proposal','APPROVE',11,'PRC-20260717-001','Duyệt phiếu đề xuất','2026-07-17 14:52:59'),(208,3,'receipt','CREATE',33,'RX-IM-20260803-833','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-03 14:58:01'),(209,3,'receipt','CREATE',34,'RX-EX-20260803-971','Tạo phiếu xuất kho và cập nhật tồn kho','2026-08-03 15:00:00'),(210,3,'liquidation','CREATE',31,'LIQ1785744734580','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1785744734580','2026-08-03 15:12:15'),(211,3,'liquidation','CEO_APPROVE',31,'LIQ1785744734580','CEO duyệt đơn thanh lý, chờ tạo phiếu xuất kho','2026-08-03 15:12:20'),(212,3,'liquidation','EXPORT_APPROVE',31,'RX-EX-20260803-754','Hoàn tất xuất kho cho đơn thanh lý RX-EX-20260803-754.','2026-08-03 15:12:32'),(213,3,'liquidation','EXPORT_APPROVE',31,'RX-EX-20260803-754','Hoàn tất xuất kho cho phiếu thanh lý RX-EX-20260803-754.','2026-08-03 15:12:32'),(214,3,'receipt','CREATE',35,'RX-EX-20260803-754','Tạo phiếu xuất kho và cập nhật tồn kho','2026-08-03 15:12:32'),(215,6,'transfer','CREATE',3,'TRF-20260803-056','Tao phieu de xuat luan chuyen (PENDING_CEO)','2026-08-03 15:20:18'),(216,3,'transfer','CE_APPROVE',3,'TRF-20260803-056','CEO duyet phieu luan chuyen (PENDING_CEO -> APPROVED)','2026-08-03 15:20:37'),(217,3,'user','UPDATE',2,'Trần Thị B','Cập nhật người dùng #2 (Trần Thị B): kho: \"—\" → \"Kho Hồ Chí Minh\"; roles: +warehouse_staff -sales_staff','2026-08-03 15:22:18'),(218,6,'receipt','CREATE',36,'RX-EX-20260803-618','Tạo phiếu xuất kho và cập nhật tồn kho','2026-08-03 15:24:06'),(219,6,'transfer','EXPORT_CREATED',3,'TRF-20260803-056','Phieu xuat RX-EX-20260803-618 da duoc tao tu phieu luan chuyen (APPROVED -> EXPORTED)','2026-08-03 15:24:06'),(220,2,'receipt','CREATE',37,'RX-IM-20260803-597','Tao phieu nhap theo phieu luan chuyen TRF-20260803-056','2026-08-03 15:24:40'),(221,2,'transfer','IMPORT_CREATED',3,'TRF-20260803-056','Phieu nhap RX-IM-20260803-597 da hoan tat (EXPORTED -> COMPLETED)','2026-08-03 15:24:40'),(222,3,'inventory_check','CREATE',15,'IC-20260803-218','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-08-03 15:32:18'),(223,3,'import_proposal','CREATE',12,'PRC-20260717-002','Tạo phiếu đề xuất (gửi duyệt)','2026-07-17 16:02:09'),(224,3,'import_proposal','APPROVE',12,'PRC-20260717-002','Duyệt phiếu đề xuất','2026-07-17 16:02:16'),(225,3,'liquidation','CREATE',32,'LIQ1784281199276','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1784281199276','2026-07-17 16:39:59'),(226,3,'liquidation','CEO_APPROVE',32,'LIQ1784281199276','CEO duyệt đơn thanh lý, chờ tạo phiếu xuất kho','2026-07-17 16:40:04'),(227,3,'receipt','CREATE',38,'RX-IM-20260817-109','Tạo phiếu nhập kho và cập nhật tồn kho','2026-08-17 16:46:37'),(228,3,'user','UPDATE',3,'Admin','Cập nhật người dùng #3 (Admin): kho: \"Kho Hà Nội\" → \"—\"','2026-07-17 16:50:32'),(229,3,'liquidation','CREATE',33,'LIQ1784323195638','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1784323195638','2026-07-18 04:19:56'),(230,13,'liquidation','CEO_APPROVE',33,'LIQ1784323195638','CEO duyệt đơn thanh lý, chờ tạo phiếu xuất kho','2026-07-18 04:56:04'),(231,3,'liquidation','CREATE',34,'LIQ1784326418771','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1784326418771','2026-07-18 05:13:39'),(232,3,'liquidation','CEO_REQUEST_EDIT',34,'LIQ1784326418771','CEO yêu cầu sửa đơn thanh lý','2026-07-18 05:13:44'),(233,3,'liquidation','EDIT_SUBMIT',34,'LIQ1784326418771','Nhân viên đã cập nhật lại thông tin đơn thanh lý theo yêu cầu','2026-07-18 05:15:45'),(234,3,'liquidation','CEO_APPROVE',34,'LIQ1784326418771','CEO duyệt đơn thanh lý, chờ tạo phiếu xuất kho','2026-07-18 05:15:49'),(235,3,'inventory_check','UPDATE',15,'IC-20260803-218','Cập nhật số lượng kiểm kê','2026-07-20 13:33:46'),(236,3,'inventory_check','UPDATE',15,'IC-20260803-218','Cập nhật số lượng kiểm kê','2026-07-20 13:34:14'),(237,3,'inventory_check','COMPLETE',15,'IC-20260803-218','Hoàn thành kiểm kê','2026-07-20 13:34:18'),(238,3,'inventory_check','CREATE',16,'IC-20260720-524','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-20 14:05:16'),(239,3,'inventory_check','UPDATE',16,'IC-20260720-524','Cập nhật số lượng kiểm kê','2026-07-20 14:09:17'),(240,3,'inventory_check','COMPLETE',16,'IC-20260720-524','Hoàn thành kiểm kê','2026-07-20 14:12:01'),(241,3,'inventory_check','CREATE',17,'IC-20260720-858','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-20 14:19:08'),(242,3,'inventory_check','UPDATE',17,'IC-20260720-858','Cập nhật số lượng kiểm kê','2026-07-20 14:19:36'),(243,3,'inventory_check','UPDATE',17,'IC-20260720-858','Cập nhật số lượng kiểm kê','2026-07-20 14:19:57'),(244,3,'inventory_check','UPDATE',17,'IC-20260720-858','Cập nhật số lượng kiểm kê','2026-07-20 14:26:18'),(245,3,'inventory_check','COMPLETE',17,'IC-20260720-858','Hoàn thành kiểm kê','2026-07-20 14:26:21'),(246,3,'categories','CREATE',85,'Nhập bù','Thêm mới: \'Nhập bù\' (Lý do xuất nhập) — Trạng thái: Hoạt động | module:quản lý phiếu xuất nhập','2026-07-20 14:46:01'),(247,3,'categories','CREATE',86,'Xuất bù','Thêm mới: \'Xuất bù\' (Lý do xuất nhập) — Trạng thái: Hoạt động | module:quản lý phiếu xuất nhập','2026-07-20 14:46:08'),(248,3,'inventory_check','CREATE',18,'IC-20260720-226','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-20 15:10:55'),(249,3,'inventory_check','UPDATE',18,'IC-20260720-226','Cập nhật số lượng kiểm kê','2026-07-20 15:10:59'),(250,3,'inventory_check','CREATE',19,'IC-20260720-479','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-20 15:11:49'),(251,3,'inventory_check','UPDATE',19,'IC-20260720-479','Cập nhật số lượng kiểm kê','2026-07-20 15:11:52'),(252,3,'inventory_check','CREATE',20,'IC-20260720-928','Tạo phiếu kiểm kê tại kho Kho Hà Nội','2026-07-20 15:22:23'),(253,3,'inventory_check','UPDATE',20,'IC-20260720-928','Cập nhật số lượng kiểm kê','2026-07-20 15:22:30'),(254,3,'inventory_check','COMPLETE',20,'IC-20260720-928','Hoàn thành kiểm kê','2026-07-20 15:22:32'),(255,3,'liquidation','CREATE',35,'LIQ1784536268859','Quản lý kho tạo đơn thanh lý, báo giá & gửi CEO duyệt: LIQ1784536268859','2026-07-20 15:31:09'),(256,3,'liquidation','CEO_APPROVE',35,'LIQ1784536268859','CEO duyệt đơn thanh lý, chờ tạo phiếu xuất kho','2026-07-20 15:31:37'),(257,3,'liquidation','EXPORT_APPROVE',35,'RX-EX-20260720-556','Hoàn tất xuất kho cho đơn thanh lý RX-EX-20260720-556.','2026-07-20 15:37:58'),(258,3,'liquidation','EXPORT_APPROVE',35,'RX-EX-20260720-556','Hoàn tất xuất kho cho phiếu thanh lý RX-EX-20260720-556.','2026-07-20 15:37:58'),(259,3,'receipt','CREATE',39,'RX-EX-20260720-556','Tạo phiếu xuất kho và cập nhật tồn kho','2026-07-20 15:37:58'),(260,3,'categories','UPDATE',30,'Thanh lý','Admin đã cập nhật \'Thanh lý\' (Lý do xuất nhập) — Trạng thái: Không hoạt động -> Hoạt động | module:quản lý phiếu xuất nhập','2026-07-20 15:39:32');
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
INSERT INTO `category` VALUES (1,'quản lý vật tư','Honda','brand','Hãng sản xuất máy phát điện Honda','active','2026-05-23 19:15:54','2026-05-27 22:41:32'),(2,'quản lý vật tư','Yamaha','brand','Hãng sản xuất máy phát điện Yamaha','active','2026-05-23 19:15:54','2026-05-27 22:41:54'),(3,'quản lý vật tư','Hyundai','brand','Hãng sản xuất máy phát điện Hyundai','active','2026-05-23 19:15:54','2026-05-27 22:41:40'),(4,'quản lý vật tư','Cummins','brand','Hãng sản xuất máy phát điện Cummins','active','2026-05-23 19:15:54','2026-05-30 08:40:53'),(5,'quản lý vật tư','Xăng','fuel_type','Máy phát điện chạy xăng','active','2026-05-23 19:15:54','2026-05-28 08:09:36'),(6,'quản lý vật tư','Dầu Diesel','fuel_type','Máy phát điện chạy dầu diesel','active','2026-05-23 19:15:54','2026-05-29 09:58:26'),(11,'quản lý vật tư','Inverter','generator_type','Máy phát điện Inverter','active','2026-05-23 19:15:54',NULL),(12,'quản lý vật tư','Công nghiệp','generator_type','Máy phát điện công nghiệp','active','2026-05-23 19:15:54',NULL),(13,'quản lý vật tư','Dân dụng','generator_type','Máy phát điện dân dụng','active','2026-05-23 19:15:54',NULL),(14,'quản lý vật tư','1 pha','phase','Máy phát điện 1 pha','active','2026-05-23 19:15:54',NULL),(15,'quản lý vật tư','3 pha','phase','Máy phát điện 3 pha','active','2026-05-23 19:15:54',NULL),(16,'quản lý vật tư','Mới','condition','Máy mới 100%','active','2026-05-23 19:15:54','2026-06-01 07:12:11'),(17,'quản lý vật tư','Đã qua sử dụng','condition','Máy đã qua sử dụng','active','2026-05-23 19:15:54','2026-05-27 22:46:02'),(18,'quản lý vật tư','Nhật Bản','origin','Xuất xứ Nhật Bản','active','2026-05-23 19:15:54',NULL),(19,'quản lý vật tư','Trung Quốc','origin','Xuất xứ Trung Quốc','active','2026-05-23 19:15:54',NULL),(20,'quản lý vật tư','Việt Nam','origin','Xuất xứ Việt Nam','active','2026-05-23 19:15:54',NULL),(21,'quản lý vật tư','Hàn Quốc','origin','Xuất xứ Hàn Quốc','active','2026-05-23 19:15:54','2026-06-01 07:12:34'),(22,'quản lý vật tư','Mỹ','origin','Xuất xứ Mỹ','active','2026-05-23 19:15:54',NULL),(25,'quản lý phiếu xuất nhập','Bảo hành','receipt_reason','Bảo hành sản phẩm','active','2026-05-28 04:28:53','2026-06-01 08:32:47'),(26,'quản lý phiếu xuất nhập','Bảo trì','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(27,'quản lý phiếu xuất nhập','Hư hỏng','receipt_reason','','active','2026-05-28 04:28:53','2026-05-28 08:07:58'),(28,'quản lý phiếu xuất nhập','Hết hạn sử dụng','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(29,'quản lý phiếu xuất nhập','Điều chuyển kho','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(30,'quản lý phiếu xuất nhập','Thanh lý','receipt_reason','','active','2026-05-28 04:28:53','2026-07-20 08:39:32'),(31,'quản lý phiếu xuất nhập','Khác','receipt_reason',NULL,'active','2026-05-28 04:28:53',NULL),(32,'quản lý phiếu mua bán','Cá nhân','customer_type','Khách hàng cá nhân','active','2026-05-23 19:15:54','2026-05-27 22:49:17'),(33,'quản lý phiếu mua bán','Doanh nghiệp','customer_type','Khách hàng doanh nghiệp','active','2026-05-23 19:15:54',NULL),(34,'quản lý kiểm kê','Hao hụt','adjust_reason','Lý do hao hụt','active','2026-05-23 19:15:54',NULL),(35,'quản lý kiểm kê','Hư hỏng','adjust_reason','Lý do hư hỏng','active','2026-05-23 19:15:54',NULL),(36,'quản lý kiểm kê','Điều chỉnh khác','adjust_reason','Lý do điều chỉnh khác','active','2026-05-23 19:15:54',NULL),(44,'quản lý vật tư','Mitsubishi','brand','H?ng s?n xu?t m?y ph?t ?i?n Mitsubishi','active','2026-05-26 21:07:30','2026-05-27 22:41:47'),(66,'quản lý vật tư','Cummi','brand','Group 1','active','2026-05-27 22:24:30','2026-06-01 07:11:59'),(67,'quản lý vật tư','2 pha','phase','Máy phát điện 2 pha','active','2026-05-27 22:48:06','2026-05-27 22:48:06'),(68,'quản lý phiếu mua bán','Nhà nước','customer_type','Nhà nước tài trợ','active','2026-05-27 22:49:02','2026-05-27 22:49:02'),(69,'quản lý vật tư','Test','brand','Test','active','2026-05-29 07:18:53','2026-05-29 07:18:53'),(70,'quản lý thanh lý','Máy quá cũ, hỏng nặng','liquidation_reason','Máy đã sử dụng lâu năm, không thể sửa chữa','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(71,'quản lý thanh lý','Chi phí sửa chữa quá cao','liquidation_reason','Chi phí bảo trì tốn kém hơn mua máy mới','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(72,'quản lý thanh lý','Thay đổi mục đích sử dụng','liquidation_reason','Không còn nhu cầu sử dụng loại máy này','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(73,'quản lý thanh lý','Giá đề xuất quá thấp','manager_reject_reason','Giá đề xuất quá thấp','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(74,'quản lý thanh lý','Thiết bị không thuộc diện thanh lý','manager_reject_reason','Thiết bị không thuộc diện thanh lý','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(75,'quản lý thanh lý','Sai thông tin series','manager_request_edit_reason','Sai thông tin series','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(76,'quản lý thanh lý','Cập nhật lại giá thanh lý','manager_request_edit_reason','Cập nhật lại giá thanh lý','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(77,'quản lý thanh lý','Không được phép thanh lý lúc này','ceo_reject_reason','Không được phép thanh lý lúc này','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(78,'quản lý thanh lý','Sai chiến lược giá','ceo_reject_reason','Sai chiến lược giá','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(79,'quản lý thanh lý','Cần xem xét lại giá thấp nhất','ceo_request_edit_reason','Cần xem xét lại giá thấp nhất','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(80,'quản lý thanh lý','Yêu cầu bổ sung chứng từ','ceo_request_edit_reason','Yêu cầu bổ sung chứng từ','active','2026-06-09 18:58:53','2026-06-09 18:58:53'),(81,NULL,'Cummis','brand',NULL,'active','2026-06-22 14:38:12','2026-06-22 14:38:12'),(82,'quản lý phiếu xuất nhập','Xuất kho','receipt_reason','','active','2026-06-25 18:53:46','2026-06-25 18:53:46'),(83,'quản lý phiếu xuất nhập','Nhập kho','receipt_reason','','active','2026-06-25 18:53:56','2026-06-25 18:53:56'),(84,'quản lý vật tư','E05','fuel_type','','active','2026-07-01 07:16:18','2026-07-01 07:16:18'),(85,'quản lý phiếu xuất nhập','Nhập bù','receipt_reason','','active','2026-07-20 07:46:01','2026-07-20 07:46:01'),(86,'quản lý phiếu xuất nhập','Xuất bù','receipt_reason','','active','2026-07-20 07:46:08','2026-07-20 07:46:08');
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
INSERT INTO `category_fuel_type` VALUES (5,'lít',25000.00),(6,'lít',22000.00),(84,'lít',2500.00);
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quản lý thông tin khách hàng';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customer`
--

LOCK TABLES `customer` WRITE;
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` VALUES (1,'Công ty TNHH Xây Dựng ABC','0988123456','abc@xaydungabc.com','12 Trần Duy Hưng, Cầu Giấy, Hà Nội','Công ty TNHH Xây Dựng ABC',33,'active','2026-05-21 09:00:00',4,NULL,NULL),(2,'Công ty CP Điện Máy XYZ','0977123456','xyz@dienmayxyz.com','56 Nguyễn Huệ, Quận 1, TP. Hồ Chí Minh','Công ty CP Điện Máy XYZ',33,'active','2026-05-21 10:00:00',4,'2026-06-30 02:33:25',3),(3,'123','123','123@gmail.com','123','123',32,'active','2026-06-07 03:40:43',3,'2026-08-03 14:58:40',3),(4,'1','1','123@gmail.com','123','1',32,'active','2026-06-07 04:30:08',3,'2026-06-26 01:57:32',3),(5,'123','0944727285','123@gmail.com','ninh bình','Công ty 123',33,'active','2026-06-07 05:15:24',3,'2026-07-17 13:35:15',3),(6,'Linh Hoàng','0978287102','123@gmail.com',' Hà Nội','',32,'active','2026-06-07 15:36:06',3,'2026-06-08 00:07:39',2),(7,'Thị Thu Hiền Hoàng','0981059011','12345@gmail.com','Hà Nội','',32,'active','2026-06-09 12:07:22',2,'2026-06-09 12:07:22',NULL),(8,'Nguyễn Văn Khánh','02938434','vankhan@gmail.com','23434','FPT University',32,'active','2026-06-19 15:14:36',3,'2026-06-19 15:14:36',NULL),(9,'Khánh Nguyễn Văn','0846723234','vankhanhak54@gmail.com','TP HN','FPT University',32,'active','2026-06-19 15:28:34',3,'2026-07-01 13:50:16',2),(10,'Khánh Nguyễn Văn','0846723771','vankhanhak54@gmail.com','TP HN','FPT University',32,'active','2026-06-19 15:29:38',3,'2026-06-19 15:29:37',NULL),(11,'Test abc','0846723711','vankhanhabc@gmail.com','Bắc Giang','FPT University',33,'active','2026-06-30 12:36:07',3,'2026-06-30 12:36:07',NULL),(12,'Hlinh','1000000000','linhlinhlinh582006@gmail.com','abc','abc',NULL,'active','2026-07-12 23:51:36',8,'2026-07-12 23:51:35',NULL),(13,'abcd','1000000001','linhlinhlinh582006@gmail.com','abc','abc',NULL,'active','2026-07-12 23:53:22',8,'2026-07-12 23:53:22',NULL),(14,'abcde','10000000012','linhlinhlinh582006@gmail.com','abc','abc',32,'active','2026-07-12 23:54:04',8,'2026-07-12 23:54:04',NULL),(15,'s3','08467237721','54@gmail.com',NULL,'FPT University',32,'active','2026-07-17 07:16:18',8,'2026-07-17 07:16:17',NULL);
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
INSERT INTO `generator_category` VALUES (1,1),(2,2),(3,3),(1,5),(2,5),(3,6),(4,6),(5,6),(3,12),(4,12),(5,12),(1,13),(2,13),(1,14),(2,14),(3,15),(4,15),(5,15),(1,16),(2,16),(3,16),(4,16),(5,16),(1,18),(2,18),(4,18),(5,44),(4,81);
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_proposal`
--

LOCK TABLES `import_proposal` WRITE;
/*!40000 ALTER TABLE `import_proposal` DISABLE KEYS */;
INSERT INTO `import_proposal` VALUES (7,'PRC-20260630-001','APPROVED',1,2,2,5,NULL,'SM','2026-06-30 13:35:57','202606',3,'',NULL,'2026-06-30 13:36:59',NULL,'2026-06-30 13:35:57','2026-07-13 23:57:50'),(8,'PRC-20260701-001','APPROVED',1,2,3,3,NULL,'SM','2026-07-01 23:59:08','202607',4,'',NULL,'2026-08-01 23:59:31',NULL,'2026-07-01 23:59:08','2026-07-13 23:57:50'),(9,'PRC-20260702-001','APPROVED',1,2,3,3,NULL,'SM','2026-07-02 14:11:22','202607',5,'',NULL,'2026-07-02 14:11:28',NULL,'2026-07-02 14:11:21','2026-07-13 23:57:50'),(10,'PRC-20260714-001','APPROVED',1,2,3,3,NULL,'SM','2026-07-14 13:30:35','202607',6,'',NULL,'2026-07-17 04:55:07',NULL,'2026-07-14 13:30:35','2026-08-03 05:07:22'),(11,'PRC-20260717-001','APPROVED',1,2,3,3,NULL,'SM','2026-07-17 14:52:12','202607',7,'',NULL,'2026-07-17 14:52:58',NULL,'2026-07-17 14:52:11','2026-08-03 14:57:03'),(12,'PRC-20260717-002','APPROVED',1,2,3,3,NULL,'SM','2026-07-17 16:02:09','202607',NULL,'',NULL,'2026-07-17 16:02:15',NULL,'2026-07-17 16:02:09','2026-07-17 16:02:15');
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
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `import_proposal_detail`
--

LOCK TABLES `import_proposal_detail` WRITE;
/*!40000 ALTER TABLE `import_proposal_detail` DISABLE KEYS */;
INSERT INTO `import_proposal_detail` VALUES (7,7,1,2,1,0,18000000.00,''),(8,7,2,2,2,0,15000000.00,''),(9,7,4,2,3,0,20000000.00,''),(10,8,1,2,2,0,18000000.00,''),(11,9,1,2,12,0,18000000.00,''),(12,10,1,2,4,1,10000000.00,NULL),(13,10,4,2,1,0,12000000.00,NULL),(14,10,2,2,1,0,12000000.00,NULL),(15,11,2,2,3,0,10000000.00,NULL),(16,11,4,2,1,1,20000000.00,NULL),(17,11,1,2,1,4,50000000.00,NULL),(18,12,4,2,5,0,1000000.00,NULL),(19,12,2,2,5,3,2000000.00,NULL),(20,12,1,2,5,3,3000000.00,NULL),(21,12,5,2,5,0,1000000.00,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (16,'45436456576768789',1,1,'SOLD',NULL,'2026-07-01 13:45:37','2026-07-01 13:53:21'),(17,'45436456576768783443',2,1,'SOLD','DAMAGED','2026-07-01 13:45:37','2026-07-16 04:05:31'),(18,'4543645657676878',2,1,'SOLD','GOOD','2026-07-01 13:45:37','2026-07-16 04:05:31'),(19,'1233223',4,1,'SOLD',NULL,'2026-07-01 13:45:37','2026-07-01 13:58:19'),(20,'123213213',4,1,'RESERVED_EXPORT',NULL,'2026-07-01 13:45:37','2026-07-01 14:02:12'),(21,'21321323213',4,1,'RESERVED_EXPORT',NULL,'2026-07-01 13:45:37','2026-07-01 14:02:20'),(22,'1243235434623',1,1,'PENDING_LIQUIDATION','POOR','2026-08-02 00:00:00','2026-07-16 04:05:31'),(23,'2334354565756',1,1,'PENDING_LIQUIDATION','POOR','2026-08-02 00:00:00','2026-07-16 04:05:31'),(24,'2132142',1,1,'SOLD','POOR','2026-08-02 14:12:24','2026-07-16 04:05:31'),(25,'2132143',1,1,'SOLD','POOR','2026-08-02 14:12:24','2026-07-16 04:05:31'),(26,'213',1,1,'SOLD','POOR','2026-08-02 14:12:24','2026-07-16 04:05:31'),(27,'778',1,1,'SOLD','POOR','2026-08-02 14:12:24','2026-07-16 04:05:31'),(28,'567',1,1,'SOLD','GOOD','2026-08-02 14:12:24','2026-07-16 04:05:31'),(29,'876',1,1,'SOLD','GOOD','2026-08-02 14:12:24','2026-07-16 04:05:31'),(31,'456',1,1,'SOLD','DAMAGED','2026-08-02 14:12:24','2026-07-16 04:05:31'),(32,'35',1,1,'SOLD','DAMAGED','2026-08-02 14:12:24','2026-07-16 04:05:31'),(33,'237',1,1,'SOLD','DAMAGED','2026-08-02 14:12:24','2026-07-16 04:05:31'),(34,'543',1,1,'SOLD','DAMAGED','2026-08-02 14:12:24','2026-07-17 06:57:26'),(35,'2324',1,1,'SOLD','GOOD','2026-08-02 14:12:24','2026-07-17 07:13:04'),(36,'123124',1,1,'SOLD','GOOD','2026-08-03 05:08:18','2026-08-03 15:00:00'),(37,'5435643',1,1,'PENDING_LIQUIDATION','GOOD','2026-08-03 05:08:18','2026-07-20 13:34:17'),(38,'3453543',1,1,'PENDING_LIQUIDATION','POOR','2026-08-03 05:08:18','2026-07-18 05:15:44'),(39,'45465656',1,1,'PENDING_LIQUIDATION','DAMAGED','2026-08-03 05:08:18','2026-07-20 13:34:17'),(40,'45345454',4,1,'SOLD','POOR','2026-08-03 05:08:18','2026-08-03 15:12:31'),(41,'45454545',2,1,'PENDING_LIQUIDATION','DAMAGED','2026-08-03 05:08:18','2026-07-17 13:33:56'),(42,'2132',2,1,'IN_STOCK','GOOD','2026-08-03 14:58:00','2026-07-20 13:34:18'),(43,'2323',2,1,'SOLD','POOR','2026-08-03 14:58:00','2026-07-20 15:37:57'),(44,'11',2,1,'IN_STOCK','DAMAGED','2026-08-03 14:58:00','2026-07-20 15:22:31'),(45,'23',4,2,'IN_STOCK',NULL,'2026-08-03 14:58:00','2026-08-03 15:24:39'),(46,'43',1,1,'SOLD',NULL,'2026-08-03 14:58:00','2026-08-03 14:59:59'),(47,'9870',2,2,'IN_STOCK',NULL,'2026-08-17 16:46:37','2026-08-17 16:46:37');
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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_check`
--

LOCK TABLES `inventory_check` WRITE;
/*!40000 ALTER TABLE `inventory_check` DISABLE KEYS */;
INSERT INTO `inventory_check` VALUES (3,'IC-20260701-534',1,'completed','',3,'2026-07-01 14:44:47','2026-07-01 14:45:12','2026-07-01 14:44:47','2026-07-01 14:45:12'),(4,'IC-20260802-910',1,'completed','',3,'2026-08-02 00:00:23','2026-08-02 00:00:40','2026-08-02 00:00:23','2026-08-02 00:00:39'),(5,'IC-20260702-874',1,'doing','',3,'2026-07-02 14:10:01',NULL,'2026-07-02 14:10:01','2026-07-02 14:10:00'),(6,'IC-20260802-838',1,'completed','',3,'2026-08-02 14:12:48','2026-08-02 14:13:17','2026-08-02 14:12:48','2026-08-02 14:13:16'),(7,'IC-20260716-713',1,'doing','',3,'2026-07-16 03:54:38',NULL,'2026-07-16 03:54:38','2026-07-16 03:54:37'),(8,'IC-20260717-482',1,'completed','',3,'2026-07-17 05:49:02','2026-07-17 05:49:25','2026-07-17 05:49:02','2026-07-17 05:49:25'),(9,'IC-20260717-771',1,'doing','',3,'2026-07-17 06:12:33',NULL,'2026-07-17 06:12:33','2026-07-17 06:12:32'),(10,'IC-20260717-567',1,'doing','',3,'2026-07-17 06:16:18',NULL,'2026-07-17 06:16:18','2026-07-17 06:16:17'),(11,'IC-20260717-848',1,'completed','',3,'2026-07-17 06:25:25','2026-07-17 06:25:42','2026-07-17 06:25:25','2026-07-17 06:25:42'),(12,'IC-20260717-715',1,'completed','',3,'2026-07-17 06:43:30','2026-07-17 06:43:47','2026-07-17 06:43:30','2026-07-17 06:43:46'),(13,'IC-20260717-241',1,'completed','',3,'2026-07-17 06:51:19','2026-07-17 06:51:35','2026-07-17 06:51:19','2026-07-17 06:51:34'),(14,'IC-20260717-252',1,'doing','',3,'2026-07-17 13:38:43',NULL,'2026-07-17 13:38:43','2026-07-17 13:38:43'),(15,'IC-20260803-218',1,'completed','',3,'2026-08-03 15:32:18','2026-07-20 13:34:18','2026-08-03 15:32:18','2026-07-20 13:34:17'),(16,'IC-20260720-524',1,'completed','',3,'2026-07-20 14:05:16','2026-07-20 14:12:01','2026-07-20 14:05:16','2026-07-20 14:12:00'),(17,'IC-20260720-858',1,'completed','',3,'2026-07-20 14:19:08','2026-07-20 14:26:20','2026-07-20 14:19:08','2026-07-20 14:26:20'),(18,'IC-20260720-226',1,'doing','',3,'2026-07-20 15:10:55',NULL,'2026-07-20 15:10:55','2026-07-20 15:10:55'),(19,'IC-20260720-479',1,'doing','',3,'2026-07-20 15:11:48',NULL,'2026-07-20 15:11:48','2026-07-20 15:11:48'),(20,'IC-20260720-928',1,'completed','',3,'2026-07-20 15:22:23','2026-07-20 15:22:31','2026-07-20 15:22:23','2026-07-20 15:22:31');
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
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_check_detail`
--

LOCK TABLES `inventory_check_detail` WRITE;
/*!40000 ALTER TABLE `inventory_check_detail` DISABLE KEYS */;
INSERT INTO `inventory_check_detail` VALUES (3,3,1,0,0,''),(4,3,2,2,2,''),(5,3,4,0,0,''),(6,4,1,2,2,''),(7,4,2,0,0,''),(8,4,4,0,0,''),(9,5,1,0,NULL,NULL),(10,5,2,0,NULL,NULL),(11,5,4,0,NULL,NULL),(12,6,1,12,12,''),(13,6,2,0,0,''),(14,6,4,0,0,''),(15,7,1,0,NULL,NULL),(16,8,1,5,5,''),(17,8,2,1,1,''),(18,8,4,1,1,''),(19,9,1,5,5,''),(20,9,2,1,1,''),(21,9,4,1,1,''),(22,10,1,5,NULL,NULL),(23,10,2,1,NULL,NULL),(24,10,4,1,NULL,NULL),(25,11,1,5,5,''),(26,11,2,1,1,''),(27,11,4,1,1,''),(28,12,1,5,5,''),(29,12,2,1,1,''),(30,12,4,1,1,''),(31,13,1,5,5,''),(32,13,2,1,1,''),(33,13,4,1,1,''),(34,14,1,4,NULL,NULL),(35,14,4,1,NULL,NULL),(36,15,1,3,3,''),(37,15,2,3,3,''),(38,16,2,3,3,''),(39,17,2,3,1,''),(40,18,2,3,3,''),(41,19,2,3,3,''),(42,20,2,3,3,'');
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
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_check_serial`
--

LOCK TABLES `inventory_check_serial` WRITE;
/*!40000 ALTER TABLE `inventory_check_serial` DISABLE KEYS */;
INSERT INTO `inventory_check_serial` VALUES (21,4,'45436456576768783443','DAMAGED',''),(22,4,'4543645657676878','GOOD',''),(23,6,'1243235434623','POOR',''),(24,6,'2334354565756','POOR',''),(25,12,'2132142','POOR',''),(26,12,'2132143','POOR',''),(27,12,'213','POOR',''),(28,12,'778','POOR',''),(29,12,'567','GOOD',''),(30,12,'876','GOOD',''),(31,12,'5765','DAMAGED',''),(32,12,'456','DAMAGED',''),(33,12,'35','DAMAGED',''),(34,12,'237','DAMAGED',''),(35,12,'543','GOOD',''),(36,12,'2324','GOOD',''),(37,18,'45345454','POOR',''),(38,17,'45454545','DAMAGED',''),(39,16,'543','GOOD',''),(40,16,'123124','POOR',''),(41,16,'5435643','DAMAGED',''),(42,16,'3453543','GOOD',''),(43,16,'45465656','GOOD',''),(44,21,'45345454','DAMAGED',''),(45,20,'45454545','GOOD',''),(46,19,'543','GOOD',''),(47,19,'123124','POOR',''),(48,19,'5435643',NULL,''),(49,19,'3453543','DAMAGED',''),(50,19,'45465656','POOR',''),(51,24,'45345454',NULL,NULL),(52,23,'45454545',NULL,NULL),(53,22,'543',NULL,NULL),(54,22,'123124',NULL,NULL),(55,22,'5435643',NULL,NULL),(56,22,'3453543',NULL,NULL),(57,22,'45465656',NULL,NULL),(58,27,'45345454','GOOD',''),(59,26,'45454545','POOR',''),(60,25,'543','POOR',''),(61,25,'123124','POOR',''),(62,25,'5435643','DAMAGED',''),(63,25,'3453543','DAMAGED',''),(64,25,'45465656','GOOD',''),(65,30,'45345454','POOR',''),(66,29,'45454545','DAMAGED',''),(67,28,'543','GOOD',''),(68,28,'123124','DAMAGED',''),(69,28,'5435643','POOR',''),(70,28,'3453543','POOR',''),(71,28,'45465656','POOR',''),(72,33,'45345454','POOR',''),(73,32,'45454545','DAMAGED',''),(74,31,'543','DAMAGED',''),(75,31,'123124','GOOD',''),(76,31,'5435643','POOR',''),(77,31,'3453543','POOR',''),(78,31,'45465656','POOR',''),(79,35,'45345454',NULL,NULL),(80,34,'123124',NULL,NULL),(81,34,'5435643',NULL,NULL),(82,34,'3453543',NULL,NULL),(83,34,'45465656',NULL,NULL),(84,37,'2132','GOOD',''),(85,37,'2323','GOOD',''),(86,37,'11','GOOD',''),(87,36,'5435643','GOOD',''),(88,36,'3453543','POOR',''),(89,36,'45465656','DAMAGED',''),(90,38,'2132','GOOD',''),(91,38,'2323','GOOD',''),(92,38,'11','GOOD',''),(93,39,'2132','GOOD',''),(94,39,'2323','GOOD','không có'),(95,39,'11','GOOD','không có'),(96,40,'2132',NULL,''),(97,40,'2323',NULL,''),(98,40,'11',NULL,''),(99,41,'2132',NULL,''),(100,41,'2323',NULL,''),(101,41,'11',NULL,''),(102,42,'2132','GOOD',''),(103,42,'2323','POOR',''),(104,42,'11','DAMAGED','');
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
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `liquidation`
--

LOCK TABLES `liquidation` WRITE;
/*!40000 ALTER TABLE `liquidation` DISABLE KEYS */;
INSERT INTO `liquidation` VALUES (8,'LIQ1782891960010',3,'COMPLETED',70,3,'2026-07-01 14:46:00',3,'2026-07-01 14:46:33',NULL,NULL,18,'2026-07-01 14:46:00','2026-07-01 14:46:33',1,2),(9,'LIQ1782916474251',3,'COMPLETED',71,NULL,NULL,3,'2026-07-01 21:35:24',NULL,NULL,19,'2026-07-01 21:34:34','2026-07-01 21:35:24',1,2),(10,'LIQ1782933734007',3,'CANCELLED',71,3,'2026-07-02 02:22:14',3,'2026-07-02 13:05:18',77,NULL,NULL,'2026-07-02 02:22:14','2026-07-08 03:04:29',1,2),(11,'LIQ1782973081788',3,'CANCELLED',71,NULL,NULL,3,'2026-07-02 14:00:34',77,NULL,NULL,'2026-07-02 13:18:02','2026-07-08 03:04:29',1,2),(12,'LIQ1782976121003',3,'CANCELLED',71,3,'2026-07-02 14:08:41',3,'2026-07-02 14:09:13',77,NULL,NULL,'2026-07-02 14:08:41','2026-07-08 03:04:29',1,5),(13,'LIQ1785654824979',3,'CANCELLED',71,3,'2026-08-02 14:13:45',3,'2026-08-02 14:14:19',77,NULL,NULL,'2026-08-02 14:13:45','2026-07-08 03:04:29',1,3),(14,'LIQ1785654936327',3,'CANCELLED',71,3,'2026-08-02 14:15:36',3,'2026-07-07 13:07:35',78,NULL,NULL,'2026-08-02 14:15:36','2026-07-08 03:04:29',1,5),(15,'LIQ1785656105972',8,'COMPLETED',71,8,'2026-08-02 14:35:06',3,'2026-07-07 03:19:35',NULL,NULL,22,'2026-08-02 14:35:06','2026-07-07 03:19:35',1,5),(16,'LIQ1783367956785',3,'CANCELLED',72,NULL,NULL,3,'2026-07-07 13:08:03',77,NULL,NULL,'2026-07-07 02:59:17','2026-07-08 03:04:29',1,5),(17,'LIQ1783368819822',3,'CANCELLED',70,NULL,NULL,3,'2026-07-07 13:08:13',77,NULL,NULL,'2026-07-07 03:13:40','2026-07-08 03:04:29',1,10),(18,'LIQ1783408861714',3,'COMPLETED',71,NULL,NULL,3,'2026-08-07 23:49:21',NULL,NULL,23,'2026-07-07 14:21:02','2026-08-07 23:49:21',1,5),(19,'LIQ1786122786759',3,'COMPLETED',71,NULL,NULL,3,'2026-08-08 00:13:11',NULL,NULL,24,'2026-08-08 00:13:07','2026-08-08 00:13:11',1,2),(20,'LIQ1786124920144',3,'COMPLETED',71,NULL,NULL,3,'2026-08-08 00:49:43',NULL,NULL,25,'2026-08-08 00:48:40','2026-08-08 00:49:43',1,5),(21,'LIQ1783452444719',3,'COMPLETED',71,NULL,NULL,3,'2026-07-08 03:08:28',NULL,NULL,26,'2026-07-08 02:27:25','2026-07-08 03:08:28',1,5),(22,'LIQ1783454877354',3,'CANCELLED',71,NULL,NULL,3,'2026-07-08 03:08:19',78,NULL,NULL,'2026-07-08 03:07:57','2026-07-08 03:08:19',1,2),(23,'LIQ1783455502305',3,'COMPLETED',71,NULL,NULL,3,'2026-07-08 03:18:26',NULL,NULL,27,'2026-07-08 03:18:22','2026-07-08 03:18:26',1,3),(24,'LIQ1783455668245',3,'COMPLETED',71,NULL,NULL,3,'2026-07-08 03:21:29',NULL,NULL,28,'2026-07-08 03:21:08','2026-07-08 03:21:29',1,5),(25,'LIQ1783862672511',3,'COMPLETED',71,NULL,NULL,13,'2026-07-12 20:32:59',NULL,NULL,29,'2026-07-12 20:24:33','2026-07-12 20:32:59',1,2),(26,'LIQ1783863743215',8,'CANCELLED',71,NULL,NULL,3,'2026-07-17 05:47:37',77,NULL,NULL,'2026-07-12 20:42:23','2026-07-17 05:47:37',1,2),(27,'LIQ1783917585889',8,'CANCELLED',71,NULL,NULL,3,'2026-07-13 11:41:42',77,NULL,NULL,'2026-07-13 11:39:46','2026-07-13 11:41:42',1,2),(28,'LIQ1784141737073',3,'COMPLETED',71,NULL,NULL,6,'2026-07-17 07:13:05',NULL,NULL,32,'2026-07-16 01:55:37','2026-07-17 07:13:05',1,2),(29,'LIQ1784246170590',8,'COMPLETED',70,NULL,NULL,8,'2026-07-17 06:57:26',NULL,NULL,31,'2026-07-17 06:56:11','2026-07-17 06:57:26',1,13),(30,'LIQ1784270036789',3,'APPROVED',71,NULL,NULL,3,'2026-07-17 13:34:04',NULL,NULL,NULL,'2026-07-17 13:33:57','2026-07-17 13:34:04',1,3),(31,'LIQ1785744734580',3,'COMPLETED',71,NULL,NULL,3,'2026-08-03 15:12:32',NULL,NULL,35,'2026-08-03 15:12:15','2026-08-03 15:12:32',1,5),(32,'LIQ1784281199276',3,'APPROVED',71,NULL,NULL,3,'2026-07-17 16:40:04',NULL,NULL,NULL,'2026-07-17 16:39:59','2026-07-17 16:40:04',1,13),(33,'LIQ1784323195638',3,'APPROVED',71,NULL,NULL,13,'2026-07-18 04:56:04',NULL,NULL,NULL,'2026-07-18 04:19:56','2026-07-18 04:56:04',1,4),(34,'LIQ1784326418771',3,'APPROVED',70,NULL,NULL,3,'2026-07-18 05:15:49',NULL,NULL,NULL,'2026-07-18 05:13:39','2026-07-18 05:15:49',1,13),(35,'LIQ1784536268859',3,'COMPLETED',71,NULL,NULL,3,'2026-07-20 15:37:58',NULL,NULL,39,'2026-07-20 15:31:09','2026-07-20 15:37:58',1,3);
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
) ENGINE=InnoDB AUTO_INCREMENT=63 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `liquidation_detail`
--

LOCK TABLES `liquidation_detail` WRITE;
/*!40000 ALTER TABLE `liquidation_detail` DISABLE KEYS */;
INSERT INTO `liquidation_detail` VALUES (25,8,2,'45436456576768783443',15000000.00,10000000.00),(27,9,2,'4543645657676878',15000000.00,20000000.00),(31,13,1,'5765',18000000.00,2000000.00),(32,14,1,'213',18000000.00,2323.00),(33,15,1,'2132142',18000000.00,2000000.00),(34,16,1,'2132143',18000000.00,20000000.00),(35,17,1,'456',18000000.00,5000000.00),(36,18,1,'456',18000000.00,222222.00),(37,19,1,'213',18000000.00,2000000.00),(38,19,1,'778',18000000.00,2000000.00),(40,20,1,'237',18000000.00,2000000.00),(43,21,1,'35',18000000.00,10000000.00),(45,22,1,'567',18000000.00,2000000.00),(46,23,1,'876',18000000.00,20000.00),(48,24,1,'2132143',18000000.00,5000000.00),(49,25,1,'567',18000000.00,10000000.00),(52,27,1,'2324',18000000.00,11111000.00),(53,28,1,'2324',18000000.00,20000000.00),(54,26,1,'543',10000000.00,12111000.00),(55,29,1,'543',10000000.00,2000000.00),(56,30,2,'45454545',12000000.00,12000000.00),(57,31,4,'45345454',20000000.00,15000000.00),(58,32,1,'5435643',50000000.00,2000000.00),(59,33,1,'45465656',50000000.00,10000000.00),(61,34,1,'3453543',50000000.00,200000.00),(62,35,2,'2323',10000000.00,12000000.00);
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
) ENGINE=InnoDB AUTO_INCREMENT=236 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification`
--

LOCK TABLES `notification` WRITE;
/*!40000 ALTER TABLE `notification` DISABLE KEYS */;
INSERT INTO `notification` VALUES (1,7,'Phiếu nhập kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu nhập RX-IM-20260626-199 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/import-receipt?action=detail&id=1','import_receipt',1,0,'2026-06-26 01:55:33'),(2,8,'Phiếu nhập kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu nhập RX-IM-20260626-199 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/import-receipt?action=detail&id=1','import_receipt',1,0,'2026-06-26 01:55:33'),(3,9,'Phiếu nhập kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu nhập RX-IM-20260626-199 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/import-receipt?action=detail&id=1','import_receipt',1,0,'2026-06-26 01:55:33'),(4,7,'Phiếu xuất kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu xuất RX-EX-20260627-280 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/export-receipt?action=detail&id=2','export_receipt',2,0,'2026-06-27 02:02:37'),(5,8,'Phiếu xuất kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu xuất RX-EX-20260627-280 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/export-receipt?action=detail&id=2','export_receipt',2,0,'2026-06-27 02:02:37'),(6,9,'Phiếu xuất kho mới chờ duyệt','Nhân viên Admin đã tạo phiếu xuất RX-EX-20260627-280 cần bạn duyệt.','/SWP391-QuanLyMayPhatDien-G1/export-receipt?action=detail&id=2','export_receipt',2,0,'2026-06-27 02:02:37'),(7,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 01:42:00'),(8,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 01:42:00'),(9,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 01:42:00'),(10,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 01:42:00'),(11,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783190520476 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 01:42:16'),(12,3,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 01:42:25'),(13,5,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 01:42:25'),(14,12,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 01:42:25'),(15,13,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 01:42:25'),(16,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783190520476 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 01:50:46'),(17,3,'Quản lý đã duyệt đơn thanh lý','Đơn thanh lý LIQ1783190520476 đã được quản lý Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 01:54:22'),(18,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 01:54:22'),(19,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 01:54:22'),(20,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 01:54:22'),(21,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 01:54:22'),(22,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783190520476 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 01:54:46'),(23,3,'Quản lý đã duyệt đơn thanh lý','Đơn thanh lý LIQ1783190520476 đã được quản lý Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 02:03:07'),(24,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 02:03:07'),(25,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 02:03:07'),(26,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 02:03:07'),(27,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1783190520476 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 02:03:07'),(28,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783190520476 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 02:03:19'),(29,3,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 02:03:29'),(30,5,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 02:03:29'),(31,12,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 02:03:29'),(32,13,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 02:03:29'),(33,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783190520476 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 02:04:48'),(34,3,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-07-05 02:06:47'),(35,5,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 02:06:47'),(36,12,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 02:06:47'),(37,13,'Đơn thanh lý LIQ1783190520476 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,0,'2026-07-05 02:06:47'),(38,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1783190520476 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=1','liquidation',1,1,'2026-06-30 02:24:46'),(39,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782762862438 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,1,'2026-06-30 02:54:22'),(40,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782762862438 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,0,'2026-06-30 02:54:22'),(41,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782762862438 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,0,'2026-06-30 02:54:22'),(42,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782762862438 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,0,'2026-06-30 02:54:22'),(43,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1782762862438 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,1,'2026-06-30 02:54:35'),(44,3,'Quản lý đã duyệt đơn thanh lý','Đơn thanh lý LIQ1782762862438 đã được quản lý Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,1,'2026-06-30 02:54:54'),(45,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1782762862438 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,1,'2026-06-30 02:54:54'),(46,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1782762862438 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,0,'2026-06-30 02:54:54'),(47,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1782762862438 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,0,'2026-06-30 02:54:54'),(48,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã trình lên đơn thanh lý LIQ1782762862438 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,0,'2026-06-30 02:54:54'),(49,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1782762862438 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=2','liquidation',2,1,'2026-06-30 02:55:03'),(50,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782763385765 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=3','liquidation',3,1,'2026-06-30 03:03:05'),(51,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782763385765 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=3','liquidation',3,0,'2026-06-30 03:03:05'),(52,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782763385765 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=3','liquidation',3,0,'2026-06-30 03:03:05'),(53,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782763385765 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=3','liquidation',3,0,'2026-06-30 03:03:05'),(54,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1782763385765 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=3','liquidation',3,1,'2026-06-30 03:09:05'),(55,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782794438503 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=4','liquidation',4,1,'2026-06-30 11:40:38'),(56,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782794438503 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=4','liquidation',4,0,'2026-06-30 11:40:38'),(57,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782794438503 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=4','liquidation',4,0,'2026-06-30 11:40:38'),(58,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782794438503 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=4','liquidation',4,0,'2026-06-30 11:40:38'),(59,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1782794438503 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=4','liquidation',4,1,'2026-06-30 11:40:52'),(60,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782794952332 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,1,'2026-06-30 11:49:12'),(61,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782794952332 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,0,'2026-06-30 11:49:12'),(62,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782794952332 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,0,'2026-06-30 11:49:12'),(63,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782794952332 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,0,'2026-06-30 11:49:12'),(64,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1782794952332 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,1,'2026-06-30 11:49:18'),(65,3,'Đơn thanh lý LIQ1782794952332 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,1,'2026-06-30 12:00:21'),(66,5,'Đơn thanh lý LIQ1782794952332 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,0,'2026-06-30 12:00:21'),(67,12,'Đơn thanh lý LIQ1782794952332 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,0,'2026-06-30 12:00:21'),(68,13,'Đơn thanh lý LIQ1782794952332 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,0,'2026-06-30 12:00:21'),(69,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1782794952332 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=5','liquidation',5,1,'2026-06-30 12:00:28'),(70,13,'Phieu luan chuyen moi cho duyet','Nhan vien Admin da tao phieu luan chuyen TRF-20260630-155 can CEO duyet.','/SWP391-QuanLyMayPhatDien-G1/transfers?action=detail&id=1','transfer',1,0,'2026-06-30 12:02:34'),(71,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782795900474 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,1,'2026-06-30 12:05:00'),(72,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782795900474 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:05:00'),(73,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782795900474 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:05:00'),(74,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782795900474 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:05:00'),(75,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1782795900474 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,1,'2026-06-30 12:05:08'),(76,3,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,1,'2026-06-30 12:15:44'),(77,5,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:15:44'),(78,12,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:15:44'),(79,13,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:15:44'),(80,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1782795900474 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,1,'2026-06-30 12:16:02'),(81,3,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,1,'2026-06-30 12:18:37'),(82,5,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:18:37'),(83,12,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:18:37'),(84,13,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:18:37'),(85,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1782795900474 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,1,'2026-06-30 12:18:58'),(86,3,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,1,'2026-06-30 12:19:00'),(87,5,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:19:00'),(88,12,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:19:00'),(89,13,'Đơn thanh lý LIQ1782795900474 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,0,'2026-06-30 12:19:00'),(90,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1782795900474 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=6','liquidation',6,1,'2026-06-30 12:19:05'),(91,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782797804302 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=7','liquidation',7,1,'2026-06-30 12:36:44'),(92,5,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782797804302 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=7','liquidation',7,0,'2026-06-30 12:36:44'),(93,12,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782797804302 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=7','liquidation',7,0,'2026-06-30 12:36:44'),(94,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782797804302 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=7','liquidation',7,0,'2026-06-30 12:36:44'),(95,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1782797804302 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=7','liquidation',7,1,'2026-06-30 12:37:13'),(96,13,'Phieu luan chuyen moi cho duyet','Nhan vien Admin da tao phieu luan chuyen TRF-20260701-319 can CEO duyet.','/SWP391-QuanLyMayPhatDien-G1/transfers?action=detail&id=2','transfer',2,0,'2026-07-01 14:42:41'),(97,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782891960010 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=8','liquidation',8,1,'2026-07-01 14:46:00'),(98,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782891960010 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=8','liquidation',8,0,'2026-07-01 14:46:00'),(99,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1782891960010 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=8','liquidation',8,1,'2026-07-01 14:46:32'),(100,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782916474251 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=9','liquidation',9,1,'2026-07-01 21:34:34'),(101,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782916474251 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=9','liquidation',9,0,'2026-07-01 21:34:34'),(102,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1782916474251 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=9','liquidation',9,1,'2026-07-01 21:34:54'),(103,3,'Đơn thanh lý LIQ1782916474251 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=9','liquidation',9,1,'2026-07-01 21:34:59'),(104,13,'Đơn thanh lý LIQ1782916474251 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=9','liquidation',9,0,'2026-07-01 21:34:59'),(105,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1782916474251 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=9','liquidation',9,1,'2026-07-01 21:35:24'),(106,3,'CEO từ chối đơn thanh lý','Đơn LIQ1782933734007 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=10','liquidation',10,1,'2026-07-02 13:05:17'),(107,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782973081788 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=11','liquidation',11,1,'2026-07-02 13:18:01'),(108,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782973081788 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=11','liquidation',11,0,'2026-07-02 13:18:01'),(109,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1782973081788 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=11','liquidation',11,1,'2026-07-02 13:18:06'),(110,3,'Đơn thanh lý LIQ1782973081788 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=11','liquidation',11,1,'2026-07-02 13:58:10'),(111,13,'Đơn thanh lý LIQ1782973081788 đã được sửa lại — chờ Sếp duyệt','Nhân viên Admin đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=11','liquidation',11,0,'2026-07-02 13:58:10'),(112,3,'CEO từ chối đơn thanh lý','Đơn LIQ1782973081788 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=11','liquidation',11,1,'2026-07-02 14:00:34'),(113,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782976121003 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=12','liquidation',12,1,'2026-07-02 14:08:41'),(114,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1782976121003 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=12','liquidation',12,0,'2026-07-02 14:08:41'),(115,3,'CEO từ chối đơn thanh lý','Đơn LIQ1782976121003 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=12','liquidation',12,1,'2026-07-02 14:09:13'),(116,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1785654824979 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=13','liquidation',13,1,'2026-08-02 14:13:45'),(117,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1785654824979 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=13','liquidation',13,0,'2026-08-02 14:13:45'),(118,3,'CEO từ chối đơn thanh lý','Đơn LIQ1785654824979 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=13','liquidation',13,1,'2026-08-02 14:14:19'),(119,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1785654936327 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=14','liquidation',14,1,'2026-08-02 14:15:36'),(120,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1785654936327 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=14','liquidation',14,0,'2026-08-02 14:15:36'),(121,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Phạm Minh Tuấn đã tạo và trình lên đơn thanh lý LIQ1785656105972 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=15','liquidation',15,1,'2026-08-02 14:35:06'),(122,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Phạm Minh Tuấn đã tạo và trình lên đơn thanh lý LIQ1785656105972 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=15','liquidation',15,0,'2026-08-02 14:35:06'),(123,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783367956785 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=16','liquidation',16,1,'2026-07-07 02:59:16'),(124,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783367956785 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=16','liquidation',16,0,'2026-07-07 02:59:16'),(125,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783368819822 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=17','liquidation',17,1,'2026-07-07 03:13:39'),(126,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783368819822 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=17','liquidation',17,0,'2026-07-07 03:13:39'),(127,8,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1785656105972 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=15','liquidation',15,0,'2026-07-07 03:19:34'),(128,3,'CEO từ chối đơn thanh lý','Đơn LIQ1785654936327 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=14','liquidation',14,1,'2026-07-07 13:07:35'),(129,3,'CEO từ chối đơn thanh lý','Đơn LIQ1783367956785 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=16','liquidation',16,1,'2026-07-07 13:08:02'),(130,3,'CEO từ chối đơn thanh lý','Đơn LIQ1783368819822 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=17','liquidation',17,1,'2026-07-07 13:08:12'),(131,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783408861714 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=18','liquidation',18,1,'2026-07-07 14:21:01'),(132,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783408861714 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=18','liquidation',18,0,'2026-07-07 14:21:01'),(133,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1783408861714 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=18','liquidation',18,1,'2026-08-07 23:49:20'),(134,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1786122786759 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=19','liquidation',19,1,'2026-08-08 00:13:06'),(135,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1786122786759 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=19','liquidation',19,0,'2026-08-08 00:13:06'),(136,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1786122786759 đã được CEO duyệt và chuyển sang chờ xuất kho.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=19','liquidation',19,1,'2026-08-08 00:13:11'),(137,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1786124920144 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=20','liquidation',20,1,'2026-08-08 00:48:40'),(138,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1786124920144 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=20','liquidation',20,0,'2026-08-08 00:48:40'),(139,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1786124920144 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=20','liquidation',20,1,'2026-08-08 00:48:47'),(140,3,'Đơn thanh lý LIQ1786124920144 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=20','liquidation',20,1,'2026-08-08 00:49:39'),(141,13,'Đơn thanh lý LIQ1786124920144 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=20','liquidation',20,1,'2026-08-08 00:49:39'),(142,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1786124920144 đã được CEO duyệt. Phiếu xuất kho đã được tạo tự động.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=20','liquidation',20,1,'2026-08-08 00:49:43'),(143,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783452444719 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=21','liquidation',21,1,'2026-07-08 02:27:24'),(144,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783452444719 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=21','liquidation',21,0,'2026-07-08 02:27:24'),(145,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783452444719 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=21','liquidation',21,1,'2026-07-08 02:27:30'),(146,3,'Đơn thanh lý LIQ1783452444719 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=21','liquidation',21,1,'2026-07-08 02:51:16'),(147,13,'Đơn thanh lý LIQ1783452444719 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=21','liquidation',21,0,'2026-07-08 02:51:16'),(148,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783452444719 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=21','liquidation',21,1,'2026-07-08 02:51:22'),(149,3,'Đơn thanh lý LIQ1783452444719 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=21','liquidation',21,1,'2026-07-08 02:58:15'),(150,13,'Đơn thanh lý LIQ1783452444719 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=21','liquidation',21,0,'2026-07-08 02:58:15'),(151,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783454877354 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=22','liquidation',22,1,'2026-07-08 03:07:57'),(152,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783454877354 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=22','liquidation',22,0,'2026-07-08 03:07:57'),(153,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783454877354 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=22','liquidation',22,1,'2026-07-08 03:08:06'),(154,3,'Đơn thanh lý LIQ1783454877354 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=22','liquidation',22,1,'2026-07-08 03:08:12'),(155,13,'Đơn thanh lý LIQ1783454877354 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=22','liquidation',22,0,'2026-07-08 03:08:12'),(156,3,'CEO từ chối đơn thanh lý','Đơn LIQ1783454877354 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=22','liquidation',22,1,'2026-07-08 03:08:19'),(157,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1783452444719 đã được CEO duyệt. Phiếu xuất kho đã được tạo tự động.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=21','liquidation',21,1,'2026-07-08 03:08:28'),(158,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783455502305 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=23','liquidation',23,1,'2026-07-08 03:18:22'),(159,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783455502305 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=23','liquidation',23,0,'2026-07-08 03:18:22'),(160,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1783455502305 đã được CEO duyệt. Phiếu xuất kho đã được tạo tự động.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=23','liquidation',23,1,'2026-07-08 03:18:26'),(161,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783455668245 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=24','liquidation',24,1,'2026-07-08 03:21:08'),(162,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783455668245 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=24','liquidation',24,0,'2026-07-08 03:21:08'),(163,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783455668245 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=24','liquidation',24,1,'2026-07-08 03:21:15'),(164,3,'Đơn thanh lý LIQ1783455668245 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=24','liquidation',24,1,'2026-07-08 03:21:23'),(165,13,'Đơn thanh lý LIQ1783455668245 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=24','liquidation',24,0,'2026-07-08 03:21:23'),(166,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1783455668245 đã được CEO duyệt. Phiếu xuất kho đã được tạo tự động.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=24','liquidation',24,1,'2026-07-08 03:21:28'),(167,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783862672511 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=25','liquidation',25,1,'2026-07-12 20:24:32'),(168,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1783862672511 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=25','liquidation',25,0,'2026-07-12 20:24:32'),(169,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1783862672511 đã được CEO duyệt. Phiếu xuất kho đã được tạo tự động.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=25','liquidation',25,1,'2026-07-12 20:32:59'),(170,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Phạm Minh Tuấn đã tạo và trình lên đơn thanh lý LIQ1783863743215 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=26','liquidation',26,1,'2026-07-12 20:42:23'),(171,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Phạm Minh Tuấn đã tạo và trình lên đơn thanh lý LIQ1783863743215 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=26','liquidation',26,0,'2026-07-12 20:42:23'),(172,8,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783863743215 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=26','liquidation',26,0,'2026-07-12 21:09:44'),(173,3,'Đơn thanh lý LIQ1783863743215 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=26','liquidation',26,1,'2026-07-12 23:20:10'),(174,13,'Đơn thanh lý LIQ1783863743215 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=26','liquidation',26,0,'2026-07-12 23:20:10'),(175,8,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1783863743215 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=26','liquidation',26,0,'2026-07-13 00:56:13'),(176,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Phạm Minh Tuấn đã tạo và trình lên đơn thanh lý LIQ1783917585889 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=27','liquidation',27,1,'2026-07-13 11:39:46'),(177,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Phạm Minh Tuấn đã tạo và trình lên đơn thanh lý LIQ1783917585889 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=27','liquidation',27,0,'2026-07-13 11:39:46'),(178,8,'CEO từ chối đơn thanh lý','Đơn LIQ1783917585889 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=27','liquidation',27,0,'2026-07-13 11:41:41'),(179,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784141737073 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=28','liquidation',28,0,'2026-07-16 01:55:37'),(180,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784141737073 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=28','liquidation',28,0,'2026-07-16 01:55:37'),(181,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1784141737073 đã được CEO duyệt. Hãy tạo phiếu xuất kho cho đơn này.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=28','liquidation',28,0,'2026-07-16 01:55:44'),(182,3,'Đơn thanh lý LIQ1783863743215 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=26','liquidation',26,0,'2026-07-17 05:47:31'),(183,13,'Đơn thanh lý LIQ1783863743215 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=26','liquidation',26,0,'2026-07-17 05:47:31'),(184,8,'CEO từ chối đơn thanh lý','Đơn LIQ1783863743215 đã bị CEO từ chối và huỷ.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=26','liquidation',26,0,'2026-07-17 05:47:36'),(185,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Phạm Minh Tuấn đã tạo và trình lên đơn thanh lý LIQ1784246170590 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=29','liquidation',29,0,'2026-07-17 06:56:10'),(186,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Phạm Minh Tuấn đã tạo và trình lên đơn thanh lý LIQ1784246170590 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=29','liquidation',29,0,'2026-07-17 06:56:10'),(187,8,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1784246170590 đã được CEO duyệt. Hãy tạo phiếu xuất kho cho đơn này.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=29','liquidation',29,0,'2026-07-17 06:56:46'),(188,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784270036789 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=30','liquidation',30,0,'2026-07-17 13:33:56'),(189,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784270036789 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=30','liquidation',30,0,'2026-07-17 13:33:56'),(190,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1784270036789 đã được CEO duyệt. Hãy tạo phiếu xuất kho cho đơn này.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=30','liquidation',30,0,'2026-07-17 13:34:04'),(191,3,'Đơn hàng ORD-20260717-001 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=7','order',7,0,'2026-07-17 13:35:14'),(192,5,'Đơn hàng ORD-20260717-001 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=7','order',7,0,'2026-07-17 13:35:14'),(193,12,'Đơn hàng ORD-20260717-001 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=7','order',7,0,'2026-07-17 13:35:14'),(194,3,'Đơn hàng ORD-20260717-001 đã được duyệt','Đơn hàng ORD-20260717-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=7','order',7,0,'2026-07-17 13:35:20'),(195,3,'Phiếu đề xuất PRC-20260717-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=11','proposal',11,0,'2026-07-17 14:52:12'),(196,5,'Phiếu đề xuất PRC-20260717-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=11','proposal',11,0,'2026-07-17 14:52:12'),(197,12,'Phiếu đề xuất PRC-20260717-001 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=11','proposal',11,0,'2026-07-17 14:52:12'),(198,3,'Phiếu đề xuất PRC-20260717-001 đã được duyệt','Phiếu PRC-20260717-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=11','proposal',11,0,'2026-07-17 14:52:58'),(199,3,'Phiếu mua PO-202607-004 đã được duyệt','Phiếu mua PO-202607-004 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/purchase-order?action=detail&id=7','purchase_order',7,0,'2026-08-03 14:57:03'),(200,3,'Đơn hàng ORD-20260803-001 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=8','order',8,0,'2026-08-03 14:58:40'),(201,5,'Đơn hàng ORD-20260803-001 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=8','order',8,0,'2026-08-03 14:58:40'),(202,12,'Đơn hàng ORD-20260803-001 chờ duyệt','Nhân viên Admin vừa tạo đơn hàng cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=8','order',8,0,'2026-08-03 14:58:40'),(203,3,'Đơn hàng ORD-20260803-001 đã được duyệt','Đơn hàng ORD-20260803-001 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/order?action=detail&id=8','order',8,0,'2026-08-03 14:59:33'),(204,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1785744734580 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=31','liquidation',31,0,'2026-08-03 15:12:14'),(205,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1785744734580 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=31','liquidation',31,0,'2026-08-03 15:12:14'),(206,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1785744734580 đã được CEO duyệt. Hãy tạo phiếu xuất kho cho đơn này.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=31','liquidation',31,0,'2026-08-03 15:12:20'),(207,13,'Phieu luan chuyen moi cho duyet','Nhan vien Lê Văn Cường da tao phieu luan chuyen TRF-20260803-056 can CEO duyet.','/SWP391-QuanLyMayPhatDien-G1/transfers?action=detail&id=3','transfer',3,0,'2026-08-03 15:20:18'),(208,6,'Phieu luan chuyen da duoc CEO duyet','CEO da duyet phieu luan chuyen TRF-20260803-056. Ban co the tao phieu xuat tu kho nguon.','/SWP391-QuanLyMayPhatDien-G1/transfers?action=detail&id=3','transfer',3,0,'2026-08-03 15:20:37'),(209,8,'Phieu luan chuyen da duoc CEO duyet','CEO da duyet phieu luan chuyen TRF-20260803-056. Ban co the tao phieu xuat tu kho nguon.','/SWP391-QuanLyMayPhatDien-G1/transfers?action=detail&id=3','transfer',3,0,'2026-08-03 15:20:37'),(210,2,'Phieu xuat moi tu kho nguon','Kho nguon da tao phieu xuat RX-EX-20260803-618 tu phieu luan chuyen TRF-20260803-056. Ban co the tao phieu nhap tai kho dich.','/SWP391-QuanLyMayPhatDien-G1/transfers?action=detail&id=3','transfer',3,0,'2026-08-03 15:24:05'),(211,6,'Phíếu nhập đã hoàn tất','Kho đích đã tạo phíếu nhập RX-IM-20260803-597 cho phiếu luân chuyển TRF-20260803-056. Quá trình luân chuyển đã hoàn tất.','/SWP391-QuanLyMayPhatDien-G1/transfers?action=detail&id=3','transfer',3,0,'2026-08-03 15:24:39'),(212,8,'Phíếu nhập đã hoàn tất','Kho đích đã tạo phíếu nhập RX-IM-20260803-597 cho phiếu luân chuyển TRF-20260803-056. Quá trình luân chuyển đã hoàn tất.','/SWP391-QuanLyMayPhatDien-G1/transfers?action=detail&id=3','transfer',3,0,'2026-08-03 15:24:39'),(213,3,'Phiếu đề xuất PRC-20260717-002 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=12','proposal',12,0,'2026-07-17 16:02:09'),(214,5,'Phiếu đề xuất PRC-20260717-002 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=12','proposal',12,0,'2026-07-17 16:02:09'),(215,12,'Phiếu đề xuất PRC-20260717-002 chờ duyệt','Nhân viên Admin vừa tạo phiếu đề xuất cần duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=12','proposal',12,0,'2026-07-17 16:02:09'),(216,3,'Phiếu đề xuất PRC-20260717-002 đã được duyệt','Phiếu PRC-20260717-002 đã được Admin duyệt.','/SWP391-QuanLyMayPhatDien-G1/proposal?action=detail&id=12','proposal',12,0,'2026-07-17 16:02:15'),(217,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784281199276 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=32','liquidation',32,0,'2026-07-17 16:39:59'),(218,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784281199276 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=32','liquidation',32,0,'2026-07-17 16:39:59'),(219,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1784281199276 đã được CEO duyệt. Hãy tạo phiếu xuất kho cho đơn này.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=32','liquidation',32,0,'2026-07-17 16:40:04'),(220,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784323195638 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=33','liquidation',33,0,'2026-07-18 04:19:55'),(221,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784323195638 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=33','liquidation',33,0,'2026-07-18 04:19:55'),(222,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1784323195638 đã được CEO duyệt. Hãy tạo phiếu xuất kho cho đơn này.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=33','liquidation',33,0,'2026-07-18 04:56:04'),(223,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784326418771 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=34','liquidation',34,0,'2026-07-18 05:13:38'),(224,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784326418771 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=34','liquidation',34,0,'2026-07-18 05:13:38'),(225,3,'CEO yêu cầu sửa đơn thanh lý','Đơn LIQ1784326418771 bị CEO yêu cầu sửa lại.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=34','liquidation',34,0,'2026-07-18 05:13:44'),(226,3,'Đơn thanh lý LIQ1784326418771 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=34','liquidation',34,0,'2026-07-18 05:15:44'),(227,13,'Đơn thanh lý LIQ1784326418771 đã được sửa lại — chờ Sếp duyệt','Người dùng đã cập nhật lại đơn thanh lý theo yêu cầu sửa.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=34','liquidation',34,0,'2026-07-18 05:15:44'),(228,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1784326418771 đã được CEO duyệt. Hãy tạo phiếu xuất kho cho đơn này.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=34','liquidation',34,0,'2026-07-18 05:15:49'),(229,10,'Chênh lệch kiểm kê - IC-20260720-858','Phiếu kiểm kê IC-20260720-858 tại Kho Hà Nội phát hiện chênh lệch máy EF6000 (thiếu 2). Vui lòng kiểm tra và tạo phiếu nhập/xuất bù.','/inventory-check?action=detail&id=17','inventory_check',17,0,'2026-07-20 14:26:20'),(230,6,'Chênh lệch kiểm kê - IC-20260720-858','Phiếu kiểm kê IC-20260720-858 tại Kho Hà Nội phát hiện chênh lệch máy EF6000 (thiếu 2). Vui lòng kiểm tra và tạo phiếu nhập/xuất bù.','/inventory-check?action=detail&id=17','inventory_check',17,1,'2026-07-20 14:26:20'),(231,1,'Chênh lệch kiểm kê - IC-20260720-858','Phiếu kiểm kê IC-20260720-858 tại Kho Hà Nội phát hiện chênh lệch máy EF6000 (thiếu 2). Vui lòng kiểm tra và tạo phiếu nhập/xuất bù.','/inventory-check?action=detail&id=17','inventory_check',17,0,'2026-07-20 14:26:20'),(232,2,'Chênh lệch kiểm kê - IC-20260720-858','Phiếu kiểm kê IC-20260720-858 tại Kho Hà Nội phát hiện chênh lệch máy EF6000 (thiếu 2). Vui lòng kiểm tra và tạo phiếu nhập/xuất bù.','/inventory-check?action=detail&id=17','inventory_check',17,0,'2026-07-20 14:26:20'),(233,3,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784536268859 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=35','liquidation',35,0,'2026-07-20 15:31:08'),(234,13,'Đơn thanh lý chờ CEO duyệt','Quản lý Admin đã tạo và trình lên đơn thanh lý LIQ1784536268859 cần CEO duyệt.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=35','liquidation',35,0,'2026-07-20 15:31:08'),(235,3,'CEO đã duyệt đơn thanh lý','Đơn thanh lý LIQ1784536268859 đã được CEO duyệt. Hãy tạo phiếu xuất kho cho đơn này.','/SWP391-QuanLyMayPhatDien-G1/liquidations?action=detail&id=35','liquidation',35,0,'2026-07-20 15:31:36');
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
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_detail`
--

LOCK TABLES `order_detail` WRITE;
/*!40000 ALTER TABLE `order_detail` DISABLE KEYS */;
INSERT INTO `order_detail` VALUES (9,6,1,1,20000000.00,NULL),(10,7,1,1,10000000.00,NULL),(11,8,1,2,100.00,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order`
--

LOCK TABLES `purchase_order` WRITE;
/*!40000 ALTER TABLE `purchase_order` DISABLE KEYS */;
INSERT INTO `purchase_order` VALUES (3,'PO-202606-001','202606','2026-06-01','2026-06-30',1,'APPROVED',5,13,NULL,NULL,NULL,1,6,'',NULL,'2026-07-01 13:38:58',NULL,'2026-07-01 13:38:36','2026-07-01 13:38:58'),(4,'PO-202607-001','202607','2026-07-01','2026-07-31',1,'APPROVED',3,3,NULL,NULL,NULL,1,2,'',NULL,'2026-08-01 23:59:40',NULL,'2026-08-01 23:59:38','2026-08-01 23:59:40'),(5,'PO-202607-002','202607','2026-07-01','2026-07-31',1,'APPROVED',3,3,NULL,NULL,NULL,1,12,'',NULL,'2026-08-02 14:11:48',NULL,'2026-08-02 14:11:46','2026-08-02 14:11:48'),(6,'PO-202607-003','202607','2026-07-01','2026-07-31',1,'APPROVED',3,3,NULL,NULL,NULL,1,6,'',NULL,'2026-08-03 05:07:22',NULL,'2026-08-03 05:07:17','2026-08-03 05:07:22'),(7,'PO-202607-004','202607','2026-07-01','2026-07-31',1,'APPROVED',3,3,NULL,NULL,NULL,1,5,'','2026-08-03 14:54:05','2026-08-03 14:57:03',NULL,'2026-08-03 14:54:05','2026-08-03 14:57:03');
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
  UNIQUE KEY `uk_po_detail_proposal_detail` (`po_id`,`proposal_detail_id`),
  KEY `idx_pod_po` (`po_id`),
  KEY `idx_pod_generator` (`generator_id`),
  KEY `idx_pod_proposal_detail` (`proposal_detail_id`),
  CONSTRAINT `fk_pod_generator` FOREIGN KEY (`generator_id`) REFERENCES `generator` (`id`),
  CONSTRAINT `fk_pod_po` FOREIGN KEY (`po_id`) REFERENCES `purchase_order` (`po_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_pod_proposal_detail` FOREIGN KEY (`proposal_detail_id`) REFERENCES `import_proposal_detail` (`proposal_detail_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_order_detail`
--

LOCK TABLES `purchase_order_detail` WRITE;
/*!40000 ALTER TABLE `purchase_order_detail` DISABLE KEYS */;
INSERT INTO `purchase_order_detail` VALUES (3,3,7,1,1,0,18000000.00,1,NULL),(4,3,8,2,2,0,15000000.00,2,NULL),(5,3,9,4,3,0,20000000.00,3,NULL),(6,4,10,1,2,0,18000000.00,2,NULL),(7,5,11,1,12,0,18000000.00,12,NULL),(8,6,12,1,4,0,10000000.00,4,NULL),(9,6,13,4,1,0,12000000.00,1,NULL),(10,6,14,2,1,0,12000000.00,1,NULL),(11,7,15,2,3,0,10000000.00,3,NULL),(12,7,16,4,1,1,20000000.00,1,NULL),(13,7,17,1,1,4,50000000.00,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt`
--

LOCK TABLES `receipt` WRITE;
/*!40000 ALTER TABLE `receipt` DISABLE KEYS */;
INSERT INTO `receipt` VALUES (14,'RX-IM-20260701-399','IMPORT',NULL,3,NULL,NULL,NULL,1,6,6,'COMPLETED','','2026-07-01 13:45:37','2026-07-01 13:45:37','2026-07-01 13:45:37',83,NULL),(15,'RX-EX-20260701-973','EXPORT',6,NULL,NULL,NULL,NULL,1,6,6,'COMPLETED','Tạo từ đơn ORD-20260701-001','2026-07-01 13:53:21','2026-07-01 13:53:21','2026-07-01 13:53:20',82,NULL),(16,'RX-EX-20260701-946','EXPORT',NULL,NULL,NULL,NULL,NULL,1,8,8,'COMPLETED','','2026-07-01 13:58:19','2026-07-01 13:57:54','2026-07-01 13:58:19',82,NULL),(17,'RX-EX-20260701-696','EXPORT',NULL,NULL,NULL,NULL,NULL,1,8,NULL,'DRAFT','Tao tu quet barcode',NULL,'2026-07-01 14:02:13','2026-07-01 14:02:12',NULL,NULL),(18,'PX-LIQ-1782891992615','EXPORT',NULL,NULL,8,NULL,NULL,1,3,3,'COMPLETED','Phieu xuat cho don thanh ly ID: 8','2026-07-01 14:46:33','2026-07-01 14:46:33','2026-07-16 01:51:30',70,NULL),(19,'PX-LIQ-1782916523932','EXPORT',NULL,NULL,9,NULL,NULL,1,3,3,'COMPLETED','Phieu xuat cho don thanh ly ID: 9','2026-07-01 21:35:24','2026-07-01 21:35:24','2026-07-16 01:51:30',71,NULL),(20,'RX-IM-20260802-244','IMPORT',NULL,4,NULL,NULL,NULL,1,3,3,'COMPLETED','','2026-08-02 00:00:00','2026-08-02 00:00:00','2026-08-02 00:00:00',25,NULL),(21,'RX-IM-20260802-425','IMPORT',NULL,5,NULL,NULL,NULL,1,3,3,'COMPLETED','','2026-08-02 14:12:24','2026-08-02 14:12:24','2026-08-02 14:12:24',26,NULL),(22,'PX-LIQ-1783369174874','EXPORT',NULL,NULL,15,NULL,NULL,1,8,3,'COMPLETED','Phieu xuat cho don thanh ly ID: 15','2026-07-07 03:19:35','2026-07-07 03:19:35','2026-07-16 01:51:30',71,NULL),(23,'PX-LIQ-1786121360781','EXPORT',NULL,NULL,18,NULL,NULL,1,3,3,'COMPLETED','Phieu xuat cho don thanh ly ID: 18','2026-08-07 23:49:21','2026-08-07 23:49:21','2026-07-16 01:51:30',71,NULL),(24,'PX-LIQ-1786122791110','EXPORT',NULL,NULL,19,NULL,NULL,1,3,3,'COMPLETED','Phieu xuat cho don thanh ly ID: 19','2026-08-08 00:13:11','2026-08-08 00:13:11','2026-07-16 01:51:30',71,NULL),(25,'PX-LIQ-1786124983190','EXPORT',NULL,NULL,20,NULL,NULL,1,3,3,'COMPLETED','Phieu xuat cho don thanh ly ID: 20','2026-08-08 00:49:43','2026-08-08 00:49:43','2026-07-16 01:51:30',71,NULL),(26,'PX-LIQ-1783454907977','EXPORT',NULL,NULL,21,NULL,NULL,1,3,3,'COMPLETED','Phieu xuat cho don thanh ly ID: 21','2026-07-08 03:08:28','2026-07-08 03:08:28','2026-07-16 01:51:30',71,NULL),(27,'PX-LIQ-1783455506425','EXPORT',NULL,NULL,23,NULL,NULL,1,3,3,'COMPLETED','Phiếu xuất cho đơn thanh lý ID: 23','2026-07-08 03:18:26','2026-07-08 03:18:26','2026-07-16 01:51:30',71,NULL),(28,'PX-LIQ-1783455688493','EXPORT',NULL,NULL,24,NULL,NULL,1,3,3,'COMPLETED','Phiếu xuất cho đơn thanh lý ID: 24','2026-07-08 03:21:28','2026-07-08 03:21:29','2026-07-16 01:51:30',71,NULL),(29,'PX-LIQ-1783863179251','EXPORT',NULL,NULL,25,NULL,NULL,1,3,13,'COMPLETED','Phiếu xuất cho đơn thanh lý ID: 25','2026-07-12 20:32:59','2026-07-12 20:32:59','2026-07-16 01:51:30',71,NULL),(30,'RX-IM-20260803-325','IMPORT',NULL,6,NULL,NULL,NULL,1,3,3,'COMPLETED','','2026-08-03 05:08:18','2026-08-03 05:08:18','2026-08-03 05:08:18',25,NULL),(31,'RX-EX-20260717-462','EXPORT',NULL,NULL,29,NULL,NULL,1,8,8,'COMPLETED','Tạo từ đơn thanh lý LIQ1784246170590','2026-07-17 06:57:26','2026-07-17 06:57:26','2026-07-17 06:57:26',70,NULL),(32,'RX-EX-20260717-844','EXPORT',NULL,NULL,28,NULL,NULL,1,6,6,'COMPLETED','Tạo từ đơn thanh lý LIQ1784141737073','2026-07-17 07:13:05','2026-07-17 07:13:05','2026-07-17 07:13:04',71,NULL),(33,'RX-IM-20260803-833','IMPORT',NULL,7,NULL,NULL,NULL,1,3,3,'COMPLETED','','2026-08-03 14:58:01','2026-08-03 14:58:01','2026-08-03 14:58:00',26,NULL),(34,'RX-EX-20260803-971','EXPORT',8,NULL,NULL,NULL,NULL,1,3,3,'COMPLETED','Tạo từ đơn ORD-20260803-001','2026-08-03 15:00:00','2026-08-03 15:00:00','2026-08-03 14:59:59',26,NULL),(35,'RX-EX-20260803-754','EXPORT',NULL,NULL,31,NULL,NULL,1,3,3,'COMPLETED','Tạo từ đơn thanh lý LIQ1785744734580','2026-08-03 15:12:32','2026-08-03 15:12:32','2026-08-03 15:12:31',71,NULL),(36,'RX-EX-20260803-618','EXPORT',NULL,NULL,NULL,3,NULL,1,6,6,'COMPLETED','Xuat kho theo phieu luan chuyen TRF-20260803-056 | Xuất kho theo phiếu luân chuyển TRF-20260803-056','2026-08-03 15:24:06','2026-08-03 15:24:06','2026-08-03 15:24:05',26,NULL),(37,'RX-IM-20260803-597','IMPORT',NULL,NULL,NULL,3,36,2,2,2,'COMPLETED','','2026-08-03 15:24:40','2026-08-03 15:24:40','2026-08-03 15:24:39',25,NULL),(38,'RX-IM-20260817-109','IMPORT',NULL,NULL,NULL,NULL,NULL,2,3,3,'COMPLETED','','2026-08-17 16:46:37','2026-08-17 16:46:37','2026-08-17 16:46:37',26,NULL),(39,'RX-EX-20260720-556','EXPORT',NULL,NULL,35,NULL,NULL,1,3,3,'COMPLETED','Tạo từ đơn thanh lý LIQ1784536268859','2026-07-20 15:37:58','2026-07-20 15:37:58','2026-07-20 15:37:57',71,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt_detail`
--

LOCK TABLES `receipt_detail` WRITE;
/*!40000 ALTER TABLE `receipt_detail` DISABLE KEYS */;
INSERT INTO `receipt_detail` VALUES (30,14,16,''),(31,14,17,''),(32,14,18,''),(33,14,19,''),(34,14,20,''),(35,14,21,''),(36,15,16,''),(37,16,19,NULL),(38,17,20,NULL),(39,17,21,NULL),(40,18,17,'Thanh ly gia: 10000000.00'),(41,19,18,'Thanh ly gia: 20000000.00'),(42,20,22,''),(43,20,23,''),(44,21,24,''),(45,21,25,''),(46,21,26,''),(47,21,27,''),(48,21,28,''),(49,21,29,''),(51,21,31,''),(52,21,32,''),(53,21,33,''),(54,21,34,''),(55,21,35,''),(56,22,24,'Thanh ly gia: 2000000.00'),(57,23,31,'Thanh ly gia: 222222.00'),(58,24,26,'Thanh ly gia: 2000000.00'),(59,24,27,'Thanh ly gia: 2000000.00'),(60,25,33,'Thanh ly gia: 2000000.00'),(61,26,32,'Thanh ly gia: 10000000.00'),(62,27,29,'Thanh lý giá: 20000.00'),(63,28,25,'Thanh lý giá: 5000000.00'),(64,29,28,'Thanh lý giá: 10000000.00'),(65,30,36,''),(66,30,37,''),(67,30,38,''),(68,30,39,''),(69,30,40,''),(70,30,41,''),(71,31,34,'Thanh lý: 2000000.00'),(72,32,35,'Thanh lý: 20000000.00'),(73,33,42,''),(74,33,43,''),(75,33,44,''),(76,33,45,''),(77,33,46,''),(78,34,46,''),(79,34,36,''),(80,35,40,'Thanh lý: 15000000.00'),(81,36,45,''),(82,37,45,''),(83,38,47,''),(84,39,43,'Thanh lý: 12000000.00');
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
INSERT INTO `role_permission` VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,7),(1,8),(1,9),(1,10),(2,10),(3,10),(5,10),(10,10),(1,11),(1,12),(1,22),(2,22),(3,22),(5,22),(10,22),(1,24),(2,24),(1,25),(2,25),(3,25),(1,26),(2,26),(1,27),(2,27),(1,45),(2,45),(3,45),(5,45),(10,45),(1,46),(5,46),(1,47),(5,47),(1,48),(5,48),(1,65),(2,65),(10,65),(1,66),(2,66),(10,66),(1,91),(2,91),(3,91),(5,91),(10,91),(13,91),(1,95),(2,95),(3,95),(5,95),(10,95),(1,96),(2,96),(3,96),(5,96),(10,96),(1,97),(2,97),(3,97),(5,97),(10,97),(1,98),(1,100),(10,100),(1,101),(2,101),(3,101),(1,102),(2,102),(3,102),(1,103),(2,103),(1,104),(2,104),(1,105),(10,105),(1,106),(2,106),(1,107),(1,108),(1,109),(1,110),(1,111),(1,113),(5,113),(10,113),(1,114),(5,114),(1,115),(5,115),(1,116),(5,116),(1,117),(2,117),(5,117),(10,117),(1,118),(5,118),(1,119),(5,119),(1,120),(5,120),(1,121),(10,121),(1,122),(10,122),(1,124),(2,124),(13,124),(1,125),(2,125),(1,126),(2,126),(1,127),(13,127),(1,128),(2,128),(3,128),(13,128),(1,129),(2,129),(3,129),(1,130),(2,130),(1,131),(13,131),(1,132),(13,132),(1,133),(10,133),(13,133),(1,134),(10,134),(1,135),(10,135),(1,136),(13,136),(1,137),(5,137),(10,137),(1,138),(5,138),(1,139),(5,139),(1,140),(5,140),(1,141),(1,142),(1,143),(1,144),(2,145),(3,145);
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_order`
--

LOCK TABLES `sale_order` WRITE;
/*!40000 ALTER TABLE `sale_order` DISABLE KEYS */;
INSERT INTO `sale_order` VALUES (6,'ORD-20260701-001',9,2,5,'APPROVED',20000000.00,NULL,'','2026-07-01 13:50:16','2026-07-01 13:51:00','2026-07-01 13:50:15','2026-07-01 13:51:00',NULL,NULL,NULL,NULL,NULL,NULL),(7,'ORD-20260717-001',5,3,3,'APPROVED',10000000.00,NULL,'','2026-07-17 13:35:15','2026-07-17 13:35:20','2026-07-17 13:35:14','2026-07-17 13:35:20',NULL,NULL,NULL,NULL,NULL,NULL),(8,'ORD-20260803-001',3,3,3,'APPROVED',200.00,NULL,'','2026-08-03 14:58:40','2026-08-03 14:59:33','2026-08-03 14:58:40','2026-08-03 14:59:33',NULL,NULL,NULL,NULL,NULL,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_card`
--

LOCK TABLES `stock_card` WRITE;
/*!40000 ALTER TABLE `stock_card` DISABLE KEYS */;
INSERT INTO `stock_card` VALUES (8,1,1,14,'IMPORT',1,1,'Phiếu RX-IM-20260701-399','2026-07-01 13:45:37',6),(9,1,2,14,'IMPORT',2,2,'Phiếu RX-IM-20260701-399','2026-07-01 13:45:37',6),(10,1,4,14,'IMPORT',3,3,'Phiếu RX-IM-20260701-399','2026-07-01 13:45:37',6),(11,1,1,15,'EXPORT',-1,0,'Phiếu RX-EX-20260701-973','2026-07-01 13:53:21',6),(12,1,4,16,'EXPORT',-1,2,'Phiếu RX-EX-20260701-946','2026-07-01 13:58:19',8),(13,1,1,20,'IMPORT',2,2,'Phiếu RX-IM-20260802-244','2026-08-02 00:00:00',3),(14,1,1,21,'IMPORT',12,12,'Phiếu RX-IM-20260802-425','2026-08-02 14:12:24',3),(15,1,1,30,'IMPORT',4,4,'Phiếu RX-IM-20260803-325','2026-08-03 05:08:18',3),(16,1,4,30,'IMPORT',1,1,'Phiếu RX-IM-20260803-325','2026-08-03 05:08:18',3),(17,1,2,30,'IMPORT',1,1,'Phiếu RX-IM-20260803-325','2026-08-03 05:08:18',3),(18,1,1,31,'EXPORT',-1,4,'Phiếu RX-EX-20260717-462','2026-07-17 06:57:26',8),(19,1,1,32,'EXPORT',-1,4,'Phiếu RX-EX-20260717-844','2026-07-17 07:13:05',6),(20,1,2,33,'IMPORT',3,3,'Phiếu RX-IM-20260803-833','2026-08-03 14:58:01',3),(21,1,4,33,'IMPORT',1,2,'Phiếu RX-IM-20260803-833','2026-08-03 14:58:01',3),(22,1,1,33,'IMPORT',1,5,'Phiếu RX-IM-20260803-833','2026-08-03 14:58:01',3),(23,1,1,34,'EXPORT',-2,3,'Phiếu RX-EX-20260803-971','2026-08-03 15:00:00',3),(24,1,4,35,'EXPORT',-1,1,'Phiếu RX-EX-20260803-754','2026-08-03 15:12:32',3),(25,1,4,36,'TRANSFER_OUT',-1,0,'Phieu xuat RX-EX-20260803-618 (luan chuyen)','2026-08-03 15:24:06',6),(26,2,4,37,'IMPORT',1,1,'Phiếu RX-IM-20260803-597','2026-08-03 15:24:40',2),(27,2,2,38,'IMPORT',1,1,'Phiếu RX-IM-20260817-109','2026-08-17 16:46:37',3),(28,1,2,39,'EXPORT',-1,2,'Phiếu RX-EX-20260720-556','2026-07-20 15:37:58',3);
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
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='Quản lý thông tin nhà cung cấp';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `supplier`
--

LOCK TABLES `supplier` WRITE;
/*!40000 ALTER TABLE `supplier` DISABLE KEYS */;
INSERT INTO `supplier` VALUES (1,'Công ty TNHH Thiết Bị Điện Hoàng Gia','02412345678','info@hoanggia.com','Số 15 Lý Thường Kiệt, Hoàn Kiếm, Hà Nội','Công ty TNHH Thiết Bị Điện Hoàng Gia',33,'active','2026-05-20 08:00:00',3,NULL,NULL),(2,'Công ty CP Máy Phát Điện Đông Dương','02898765432','sales@dongduong.com','120 Nguyễn Văn Linh, Quận 7, TP. Hồ Chí Minh','Công ty CP Máy Phát Điện Đông Dương',33,'active','2026-05-20 08:00:00',3,NULL,NULL),(3,'Trần Văn Minh - Đại lý Honda','0912345670','minhtran@gmail.com','45 Cầu Giấy, Hà Nội',NULL,32,'active','2026-05-20 08:00:00',3,NULL,NULL),(4,'Linh Hoàng','0981059011','linhlinhlinh582006@gmail.com',' Hà Nội','Linh Hoàng',33,'active','2026-06-16 21:38:16',3,'2026-06-16 21:38:16',NULL),(5,'Thị Thu Hiền Hoàng','0981059012','linhlinhlinh582006@gmail.com',' Hà Nội','',33,'active','2026-06-16 21:40:40',3,'2026-06-16 21:40:40',NULL),(6,'abc','0981059099','abc@gmail.com','Hà Nội','ABC',33,'active','2026-06-26 10:38:48',3,'2026-06-26 10:38:48',NULL),(7,'abcd','0981059088','abc@gmail.com',' Hà Nội','ABC',33,'active','2026-06-26 10:49:12',3,'2026-06-26 10:49:12',NULL);
/*!40000 ALTER TABLE `supplier` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transfer`
--
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
--

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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer`
--

LOCK TABLES `transfer` WRITE;
/*!40000 ALTER TABLE `transfer` DISABLE KEYS */;
INSERT INTO `transfer` VALUES (2,'TRF-20260701-319',1,2,'PENDING_CEO',3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-07-01 14:42:41','2026-07-01 14:42:41'),(3,'TRF-20260803-056',1,2,'COMPLETED',6,NULL,NULL,NULL,3,'2026-08-03 15:20:37',NULL,2,'2026-08-03 15:24:40',36,37,'2026-08-03 15:24:06',NULL,'2026-08-03 15:20:18','2026-08-03 15:24:40');
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transfer_detail`
--

LOCK TABLES `transfer_detail` WRITE;
/*!40000 ALTER TABLE `transfer_detail` DISABLE KEYS */;
INSERT INTO `transfer_detail` VALUES (2,2,2,'4543645657676878',1,NULL),(3,3,4,NULL,1,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'Nguyễn Văn A','vana','','vana@gmail.com','0944727281','Hà Nội','active','2026-05-16 18:57:20','2026-05-21 15:18:35',NULL,NULL,NULL),(2,'Trần Thị B','thib','123','thib@gmail.com','08467237727','Hà Nội','active','2026-05-16 18:57:20','2026-08-03 15:22:18',NULL,NULL,2),(3,'Admin','admin','admin123','admin@warehouse.com','0846723771','30','active','2026-05-16 18:57:20','2026-07-17 16:50:32',NULL,NULL,NULL),(4,'Nguyễn Văn Nam','salestaff1','$2a$10$zBXM5qSw.D.8QN8Kdp8FZ.SJ33GhtgKXLlRcW1rFpH0N71LoF0hAK','salestaff1@warehouse.com','0912345678','Bắc Giang','active','2026-05-21 08:00:00','2026-06-09 10:24:54',3,NULL,NULL),(5,'Trần Thị Hương','salemanager1','123','salemanager1@warehouse.com','0912345679','Hà Nội','active','2026-05-21 08:00:00','2026-05-21 15:20:58',3,NULL,NULL),(6,'Lê Văn Cường','warehousestaff1','123','warehousestaff1@warehouse.com','0912345680','Hà Nội','active','2026-05-21 08:00:00','2026-07-01 13:40:26',3,NULL,1),(7,'Khánh Nguyễn Văn','vanb','$2a$10$QbvQzIVNH/osQwDyFc6x3.AzYpVtYgyn6ADGSjP.DiGqKnF4eCJbq','vankhanhak54@gmail.com','0846723779','Hà Nội','active','2026-05-18 14:20:02','2026-05-21 15:18:28',1,NULL,NULL),(8,'Phạm Minh Tuấn','warehousemanager1','123','warehousemanager1@warehouse.com','0912345681','Hồ Chí Minh','active','2026-05-21 08:00:00','2026-06-30 02:27:16',3,NULL,1),(9,'Nguyễn Văn B','vanVB','$2a$10$RWSZe8R4XFrSUfHQe7CrYOym8.ysXZvUi3jEm.BBpcZcCrmpXIK2O','vanvb@gmail.com','0846723661','Bắc Giang','active','2026-05-22 04:02:50','2026-05-22 04:02:50',1,NULL,NULL),(10,'Khánh Nguyễn Văn','sale123_','$2a$10$XtG49C3Og360orC82gkEaOIoPTzGmx/P/YywjI5p3YLMoJpoaM0xS','khanh@gmail.com','0846723781','Hà Nội','active','2026-05-22 13:03:56','2026-05-22 13:03:56',1,NULL,NULL),(11,'1','a_v_g','$2a$10$/Lx1V/dM4vMwkRmi15zAQON4xWuYDWpFtK7y1BQCRP/1KPZ0D56WG','ABC@gmail.com','0846733771','Bắc Giang','active','2026-05-22 13:06:09','2026-05-22 17:15:52',1,NULL,NULL),(12,'Nguyen Van A','Anhcad','ncikanfc','ntf@gmail.com','0836786867','ha noi','active','2026-05-22 17:23:05','2026-05-28 17:28:27',NULL,NULL,NULL),(13,'CEO','ceo','$2a$10$fZ1zHDvp3bWhbIn/QPH5n.k3rENJEK7TAUt7WrbQ7QZvnnnnsragG','ceo@gmail.com','0846723711','30','active','2026-06-19 16:58:07','2026-06-29 21:51:21',1,NULL,1);
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
INSERT INTO `user_role` VALUES (3,1),(7,2),(8,2),(9,2),(1,3),(2,3),(6,3),(10,3),(4,5),(11,5),(5,10),(12,10),(13,13);
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

-- Dump completed on 2026-07-21  0:09:38
