-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: billetterie_jo_paris
-- ------------------------------------------------------
-- Server version	8.0.39

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `auth_group`
--

DROP TABLE IF EXISTS `auth_group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group`
--

LOCK TABLES `auth_group` WRITE;
/*!40000 ALTER TABLE `auth_group` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_group_permissions`
--

DROP TABLE IF EXISTS `auth_group_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_group_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_group_permissions`
--

LOCK TABLES `auth_group_permissions` WRITE;
/*!40000 ALTER TABLE `auth_group_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `auth_group_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `auth_permission`
--

DROP TABLE IF EXISTS `auth_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `auth_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `auth_permission`
--

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;
INSERT INTO `auth_permission` VALUES (1,'Can add log entry',1,'add_logentry'),(2,'Can change log entry',1,'change_logentry'),(3,'Can delete log entry',1,'delete_logentry'),(4,'Can view log entry',1,'view_logentry'),(5,'Can add permission',2,'add_permission'),(6,'Can change permission',2,'change_permission'),(7,'Can delete permission',2,'delete_permission'),(8,'Can view permission',2,'view_permission'),(9,'Can add group',3,'add_group'),(10,'Can change group',3,'change_group'),(11,'Can delete group',3,'delete_group'),(12,'Can view group',3,'view_group'),(13,'Can add content type',4,'add_contenttype'),(14,'Can change content type',4,'change_contenttype'),(15,'Can delete content type',4,'delete_contenttype'),(16,'Can view content type',4,'view_contenttype'),(17,'Can add session',5,'add_session'),(18,'Can change session',5,'change_session'),(19,'Can delete session',5,'delete_session'),(20,'Can view session',5,'view_session'),(21,'Can add user',6,'add_utilisateur'),(22,'Can change user',6,'change_utilisateur'),(23,'Can delete user',6,'delete_utilisateur'),(24,'Can view user',6,'view_utilisateur'),(25,'Can add application',7,'add_application'),(26,'Can change application',7,'change_application'),(27,'Can delete application',7,'delete_application'),(28,'Can view application',7,'view_application'),(29,'Can add access token',8,'add_accesstoken'),(30,'Can change access token',8,'change_accesstoken'),(31,'Can delete access token',8,'delete_accesstoken'),(32,'Can view access token',8,'view_accesstoken'),(33,'Can add grant',9,'add_grant'),(34,'Can change grant',9,'change_grant'),(35,'Can delete grant',9,'delete_grant'),(36,'Can view grant',9,'view_grant'),(37,'Can add refresh token',10,'add_refreshtoken'),(38,'Can change refresh token',10,'change_refreshtoken'),(39,'Can delete refresh token',10,'delete_refreshtoken'),(40,'Can view refresh token',10,'view_refreshtoken'),(41,'Can add id token',11,'add_idtoken'),(42,'Can change id token',11,'change_idtoken'),(43,'Can delete id token',11,'delete_idtoken'),(44,'Can view id token',11,'view_idtoken'),(45,'Can add ticket',12,'add_ticket'),(46,'Can change ticket',12,'change_ticket'),(47,'Can delete ticket',12,'delete_ticket'),(48,'Can view ticket',12,'view_ticket'),(49,'Can add transaction',13,'add_transaction'),(50,'Can change transaction',13,'change_transaction'),(51,'Can delete transaction',13,'delete_transaction'),(52,'Can view transaction',13,'view_transaction');
/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billetterie_ticket`
--

DROP TABLE IF EXISTS `billetterie_ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billetterie_ticket` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `description` longtext NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `nb_person` int unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  CONSTRAINT `billetterie_ticket_nb_person_6cd59831_check` CHECK ((`nb_person` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billetterie_ticket`
--

LOCK TABLES `billetterie_ticket` WRITE;
/*!40000 ALTER TABLE `billetterie_ticket` DISABLE KEYS */;
INSERT INTO `billetterie_ticket` VALUES (2,'SOLO','Acc├¿s ├á tous les ├®v├®nements d\'une journ├®e.',50.00,1,'2024-10-08 18:32:17.162332','2024-10-08 19:47:21.551706'),(3,'DUO','Acc├¿s ├á tous les ├®v├®nements d\'une journ├®e pour deux personnes.',90.00,2,'2024-10-08 18:33:01.900000','2024-10-08 19:47:14.981291'),(4,'FAMILLE','Acc├¿s ├á tous les ├®v├®nements d\'une journ├®e pour une famille de quatre.',160.00,4,'2024-10-08 18:33:28.269281','2024-10-08 19:47:09.417141');
/*!40000 ALTER TABLE `billetterie_ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billetterie_transaction`
--

DROP TABLE IF EXISTS `billetterie_transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billetterie_transaction` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `total_price` decimal(8,2) NOT NULL,
  `transaction_date` datetime(6) NOT NULL,
  `payment_status` varchar(10) NOT NULL,
  `payment_method` varchar(50) NOT NULL,
  `transaction_id` varchar(100) NOT NULL,
  `confirmation_code` varchar(20) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint NOT NULL,
  `quantity` int unsigned NOT NULL,
  `payment_intent` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `transaction_id` (`transaction_id`),
  UNIQUE KEY `confirmation_code` (`confirmation_code`),
  KEY `billetterie_transact_user_id_27058550_fk_billetter` (`user_id`),
  CONSTRAINT `billetterie_transact_user_id_27058550_fk_billetter` FOREIGN KEY (`user_id`) REFERENCES `billetterie_utilisateur` (`id`),
  CONSTRAINT `billetterie_transaction_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=65 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billetterie_transaction`
--

LOCK TABLES `billetterie_transaction` WRITE;
/*!40000 ALTER TABLE `billetterie_transaction` DISABLE KEYS */;
INSERT INTO `billetterie_transaction` VALUES (1,160.00,'2024-10-12 11:30:04.304780','COMPLETED','Carte de cr├®dit (fictive)','cs_test_b1moKPvv7xexFKH4QoWbr2UDc1zQ8mWdlhzEnk1rB0IfZtuPe0RQC6a6xs',NULL,'2024-10-12 11:30:17.907168',7,1,'no_intent_yet'),(2,160.00,'2024-10-12 11:34:03.843726','COMPLETED','Carte de cr├®dit (fictive)','cs_test_b19A9vtLRyQ9M8QGhuj29FRIK8dxw6rCLtWSp3GXQJogsOuZ6YtalpTxO0',NULL,'2024-10-12 11:34:14.591283',7,1,'no_intent_yet'),(3,180.00,'2024-10-12 12:40:23.500747','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1R2yzO8C2bFepHIy3XQ3GDr1K5l7rw5MjuV0CBgDrgkyidCcLbwPRxghT',NULL,'2024-10-12 12:40:51.779345',9,2,'no_intent_yet'),(4,160.00,'2024-10-12 12:42:19.240822','PENDING','Carte de cr├®dit (fictive)','cs_test_a1ZL4ppi5M636XLdGUEXbcbaj7deJGHdLQLaNsXTnFPlzznNYIqpFB9f4Y',NULL,'2024-10-12 12:42:19.240822',9,1,'no_intent_yet'),(5,160.00,'2024-10-12 12:53:13.782534','PENDING','Carte de cr├®dit (fictive)','cs_test_a1A4dSrApfuj4XqcQSj0wThwPybXJGJwSwVjDncElbwtnaXGh61XwKWYur',NULL,'2024-10-12 12:53:13.782534',9,1,'no_intent_yet'),(6,160.00,'2024-10-12 13:47:59.505198','PENDING','Carte de cr├®dit (fictive)','cs_test_a1YNDsA4LZhGnx1KGjEy4Y4IyXC7csb70xbL4sevTCqvn4x3QT5BUdk78V',NULL,'2024-10-12 13:47:59.505198',9,1,'no_intent_yet'),(7,160.00,'2024-10-12 14:01:12.636435','PENDING','Carte de cr├®dit (fictive)','cs_test_a18EfU8qRNWEnhOS1X0UmyFoh9t8xzH6pfStsXdmg2dCvSPFM6Y4ILMuRG',NULL,'2024-10-12 14:01:12.636435',9,1,'no_intent_yet'),(8,160.00,'2024-10-12 14:11:24.467079','PENDING','Carte de cr├®dit (fictive)','cs_test_a1I6o1LFWCB0GQ9DxQ9TO3Q6dS5xXgBnAhCtxFCys2tZ2d5Y8HXoRNLunF',NULL,'2024-10-12 14:11:24.467079',9,1,'no_intent_yet'),(9,160.00,'2024-10-12 14:23:35.530996','PENDING','Carte de cr├®dit (fictive)','cs_test_a1C6OJ3vSufOKFVzZQsbIuIqREjNnOtFxiL0YsCa8S0fgLfV0829dFUfq7',NULL,'2024-10-12 14:23:35.530996',6,1,'no_intent_yet'),(10,90.00,'2024-10-12 15:26:40.328262','PENDING','Carte de cr├®dit (fictive)','cs_test_a1OEO8xz7P8YBpO8mmYinPgryaDzSK6ispi6CqRNKUdSWufUfo7wCEdlEV',NULL,'2024-10-12 15:26:40.328262',7,1,'no_intent_yet'),(11,90.00,'2024-10-12 15:35:48.788542','PENDING','Carte de cr├®dit (fictive)','cs_test_a1p79til4zDeafyV7oqPN2bvR5yBCXvnQJ7ONfFR217uYCY4swjUHYNczH',NULL,'2024-10-12 15:35:48.789521',7,1,'no_intent_yet'),(12,90.00,'2024-10-12 15:41:14.403256','PENDING','Carte de cr├®dit (fictive)','cs_test_a1YRyuIJVTi7r6cn9VzfZIOjVVago1GrFX5vZZ4oLAu6KXia4lXkvYkXF5',NULL,'2024-10-12 15:41:14.403256',7,1,'no_intent_yet'),(13,90.00,'2024-10-12 15:43:19.976610','PENDING','Carte de cr├®dit (fictive)','cs_test_a1fjYjhgsNwq86W3OePBHYS9WbBAkickWuCs1ddFwiEQC7d7Fvi0eap8oV',NULL,'2024-10-12 15:43:19.977640',3,1,'no_intent_yet'),(14,90.00,'2024-10-12 15:47:57.282157','PENDING','Carte de cr├®dit (fictive)','cs_test_a1EvQ8KcyMW78Yjq9zaRsi9TMveBCV2GiYU1OK1pzn0zPPmpAMivJSCO3J',NULL,'2024-10-12 15:47:57.283156',3,1,'no_intent_yet'),(15,90.00,'2024-10-12 15:47:57.369154','PENDING','Carte de cr├®dit (fictive)','cs_test_a1GB0JnSlaZwvgIg56okK7eB7Lt6L7UjAKYlvcolYjIf6xRuruuxssH8y3',NULL,'2024-10-12 15:47:57.369154',3,1,'no_intent_yet'),(16,90.00,'2024-10-12 15:56:41.364020','PENDING','Carte de cr├®dit (fictive)','cs_test_a196UeCJYNfyzz2pmfs4yf0tcJNjbasKqLO6TkyXYdLggD3cnzcpAqU7r4',NULL,'2024-10-12 15:56:41.364020',6,1,'no_intent_yet'),(17,160.00,'2024-10-12 16:10:31.117068','PENDING','Carte de cr├®dit (fictive)','cs_test_a1MCpo1xhtdMo5lg5jCmWyamz44JCj129ankGX5fFqNqdYGSQQ7FVGEFMk',NULL,'2024-10-12 16:10:31.117068',4,1,'no_intent_yet'),(18,90.00,'2024-10-12 16:15:13.400395','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1ylD3UAiMNH6RO1NATBIYsSROe1k5nheUVjzwYSPuwGPIdEDFvCiGFJ6U',NULL,'2024-10-12 16:18:30.975160',7,1,'no_intent_yet'),(19,210.00,'2024-10-12 16:33:51.306784','PENDING','Carte de cr├®dit (fictive)','cs_test_b1KjgjfVPXBNTJwt7pnCdhWOEvIve545wbwlgaDHtjF00xWKfpSH8CEoio',NULL,'2024-10-12 16:33:51.306784',7,2,'no_intent_yet'),(20,460.00,'2024-10-12 16:35:55.615503','PENDING','Carte de cr├®dit (fictive)','cs_test_b1xjWVACjoNdovbQ49RZlByTfIc9ZrCvX460xYlrBM4s4VUkwijTlsAJLV',NULL,'2024-10-12 16:35:55.615503',9,4,'no_intent_yet'),(21,90.00,'2024-10-12 16:44:49.567711','PENDING','Carte de cr├®dit (fictive)','cs_test_a1ckC3ScfBmOFs8Ei3L2TxYZi8QQ2OK2EECzAssY52uMSVkBbosk4Aee5A',NULL,'2024-10-12 16:44:49.568711',6,1,'no_intent_yet'),(22,90.00,'2024-10-12 19:11:51.084234','PENDING','Carte de cr├®dit (fictive)','cs_test_a1ARSud666iTWEBc5eHzXpJ1P6G8kTB5SQpPMo1YhvTakuVOLsaUCNnAwL',NULL,'2024-10-12 19:11:51.085244',9,1,NULL),(23,90.00,'2024-10-12 19:48:29.234739','PENDING','Carte de cr├®dit (fictive)','JczTL1t9hUwO',NULL,'2024-10-12 19:48:29.234739',6,1,'cs_test_a1LJFN9TPCoMGwVjZ30QAH4EkIBU2X8rc8bv8Anl0tfZCJDnzVDOB90S4C'),(24,160.00,'2024-10-12 20:17:08.142603','PENDING','Carte de cr├®dit (fictive)','tXQCauS83Tmh',NULL,'2024-10-12 20:17:08.142603',9,1,'cs_test_a1wOvfKTnLs1sBEWO6A93GivUO2opuNs5AlZpRVAfg8xyLu93J2WaXqmba'),(25,160.00,'2024-10-12 20:44:20.346630','PENDING','Carte de cr├®dit (fictive)','cs_test_a11gtCTr79BG6gU97WSPdGkRsX4frL0oiZAwfGAAQKFQwz8vU9hK9M3Ds4',NULL,'2024-10-12 20:44:20.346630',7,1,NULL),(26,90.00,'2024-10-12 20:55:19.436479','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1JWwIyRN3xWrb3GWI9aiPMimJCjA2zqN2DTptehSE3MW8zOEnzXqz7YYE',NULL,'2024-10-12 21:55:55.211371',9,1,'pi_3Q9CLYRskpesRRvc1U4XHlLM'),(27,160.00,'2024-10-12 21:00:15.828963','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1p2aU9vqS91BpdagVyNUWuz0zPUealKye1AXqeCuKcfMyuG9PaGOrpnrT',NULL,'2024-10-12 21:00:39.821075',9,1,'pi_3Q9CQIRskpesRRvc0ntnl4SV'),(28,160.00,'2024-10-12 21:01:29.606751','PENDING','Carte de cr├®dit (fictive)','cs_test_a1YD49gzOnJJTUDLdF0Kaa1y8GVg2W3dLIZrBwtFnuER2NH11sVM8hRqPO',NULL,'2024-10-12 21:01:29.606751',9,1,NULL),(29,160.00,'2024-10-12 21:16:22.665198','PENDING','Carte de cr├®dit (fictive)','cs_test_a1b7o0QdXTo636bRhOnV7V8qTMJWtNFsqxCcRkajkUubMnLvWS7x7J8hM8',NULL,'2024-10-12 21:16:22.665198',9,1,NULL),(30,160.00,'2024-10-12 21:17:12.009131','PENDING','Carte de cr├®dit (fictive)','cs_test_a1KfiyppmHbFr9i76Qk3Us0o7AMRvpHWdBce7iBIEWBVnnNeYme37a24Tq',NULL,'2024-10-12 21:17:12.010131',9,1,NULL),(31,160.00,'2024-10-12 21:43:00.354630','PENDING','Carte de cr├®dit (fictive)','cs_test_a1YbkUqGmCtlMDhSAmyslN0dhRTfy0tghJwwZXuBiBmdYFh22EQ1WUExSe',NULL,'2024-10-12 21:43:00.355746',9,1,NULL),(32,160.00,'2024-10-12 21:46:33.793065','PENDING','Carte de cr├®dit (fictive)','cs_test_a1PusannRxkPgmkGCXOfZT2mbWeqW32RVrSvxHlg5h5gtBvzNS2QAL5PkB',NULL,'2024-10-12 21:46:33.793065',7,1,NULL),(33,50.00,'2024-10-12 21:58:14.692329','PENDING','Carte de cr├®dit (fictive)','cs_test_a1vnVRYVoPoq7iw82ISti9eWWlP411ZM9TwCwZd2UxGD02cHl2Hw5PYBPx',NULL,'2024-10-12 21:58:14.692329',6,1,NULL),(34,50.00,'2024-10-12 22:07:02.834216','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1LRKpktnBNsm2OKAE1vs4tJPTuW5WJSwfOlpKAei6IQYzQDmfuyg2IO9M',NULL,'2024-10-12 22:07:19.228978',6,1,'pi_3Q9DSwRskpesRRvc1syObzS1'),(35,160.00,'2024-10-12 22:07:43.796219','PENDING','Carte de cr├®dit (fictive)','cs_test_a1cmznMr4O6hVUYTemcBT7gl7bNspm9kGOVpt2nMyvypOAnTbgCRFNldX2',NULL,'2024-10-12 22:07:43.797222',6,1,NULL),(36,160.00,'2024-10-13 08:05:34.689711','PENDING','Carte de cr├®dit (fictive)','cs_test_a1Tytb9zYaYPOCvrIYmY1JJU5sdG8sPp8HKjw3z2jBDgoYmHfW6zGwe8T6',NULL,'2024-10-13 08:05:34.689711',9,1,NULL),(37,160.00,'2024-10-13 08:09:09.638070','PENDING','Carte de cr├®dit (fictive)','cs_test_a1sNKMow1DvlrXPdQh5trpUotmU9yhwxmCaZUcY7dEor7sGeGYxF51uKBa',NULL,'2024-10-13 08:09:09.638070',9,1,NULL),(38,160.00,'2024-10-13 08:13:48.454602','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1A1H93EvcSpns6RnJXpkxGyRd98D7tFxD5tiEUnMXy40TqVGkWd7endGf','GSNJZ7BTF9','2024-10-13 09:15:20.819557',9,1,'pi_3Q9Mw8RskpesRRvc1YnlgZfM'),(39,160.00,'2024-10-13 08:17:06.539300','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1MYayREEhiKiygiRGpLIZgCCZbhYDctiZB0u2519NboE3ACqcFh9SIlny','GUEHIJVJ9U','2024-10-13 09:16:50.079823',9,1,'pi_3Q9MzbRskpesRRvc0SJEFPqV'),(40,140.00,'2024-10-13 08:18:52.791723','COMPLETED','Carte de cr├®dit (fictive)','cs_test_b107rMfc6eNJvB66iMX9YJhgLYqZSgfKgfbizaqHpc0e33qUAAubErkzmK','GOTXAAK0J3','2024-10-13 09:19:30.253642',7,2,'pi_3Q9N11RskpesRRvc1BvFvGD8'),(41,140.00,'2024-10-13 08:21:22.634484','COMPLETED','Carte de cr├®dit (fictive)','cs_test_b1xEndrXApxkJw4BqZGHN2ym6X33oI93ak2NZh12Vv85Swc2hsukXLWTJI','GR0V8CYTOO','2024-10-13 09:23:02.142954',7,2,'pi_3Q9N3XRskpesRRvc1hiaifI5'),(42,140.00,'2024-10-13 08:24:35.396976','COMPLETED','Carte de cr├®dit (fictive)','cs_test_b1SAwSChybFWhVjKOvQM1dqjlxoM0hYYXRqNBKe81O2wMtM998sxSoi5Qv',NULL,'2024-10-13 08:24:48.535788',7,2,'pi_3Q9N6YRskpesRRvc0jIGejC4'),(43,100.00,'2024-10-13 08:38:04.520131','COMPLETED','','',NULL,'2024-10-13 08:38:04.802097',1,1,NULL),(51,90.00,'2024-10-13 09:05:41.526318','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a18FvHqfwE0KmfBldq4zp703Ek8ZpYrzA7zxVgOrcMA2MnOn6Ic8wDW1gY','0W6EFLS8PN','2024-10-13 09:05:56.008460',7,1,'pi_3Q9NkKRskpesRRvc1dipqhqW'),(52,90.00,'2024-10-13 11:21:54.108126','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a19NHKoUrDURfQmLsJSYUL3goyslTW04vYga1QDi3uJn7IEt7k9ogsN99n','DXTLGGWZT1','2024-10-13 11:22:10.232973',7,1,'pi_3Q9Ps9RskpesRRvc086Y3EdF'),(53,160.00,'2024-10-13 11:38:46.668221','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1rRAu34vNTWuPWMNnAzprvm4T8SB6kOcc5QF1iihh3slFH5Xnq9GRhejS','OTKX18J2YZ','2024-10-13 11:39:00.026909',1,1,'pi_3Q9Q8SRskpesRRvc09fSq1vp'),(54,160.00,'2024-10-13 11:40:02.578179','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1RhPQYftCF0tJJErR1BitQD9BVHRrfTTbhX6JLOFCJcLe3HzCF6s6Mq7h','XZ0GZLJTJD','2024-10-13 11:40:18.988537',1,1,'pi_3Q9Q9hRskpesRRvc0TvULSvm'),(55,160.00,'2024-10-13 11:42:24.309052','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a10soxu7pkBj3Y8Mz3tx5xP9p5NPCcJiSQHTECSWYHR7uYWtIUgfke7Biw','KPJ6VABYL8','2024-10-13 11:43:04.177098',1,1,'pi_3Q9QCGRskpesRRvc1aqIrZMP'),(56,160.00,'2024-10-13 11:44:32.978113','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1ZdrCMjqky8nQIIBbu1JEi3jGe6KxM60vJI6mOXuIKgFrYtEljb5e3uQP','MCIANOWYMB','2024-10-13 11:44:46.300828',1,1,'pi_3Q9QE2RskpesRRvc0oOY7kWI'),(57,160.00,'2024-10-13 11:45:50.937422','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1wUMnGC0YeOcXFCQ9U78V8Y6vuAyfJ9qIhX5pCOdFIqlFvzXCETQKXyDf','PPSPER9RSW','2024-10-13 11:46:04.109136',1,1,'pi_3Q9QFJRskpesRRvc1dxAMXaY'),(58,160.00,'2024-10-13 11:50:01.074579','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1pcrinmhWRbtUi1Jo0oQWDendlaF6ErDe5fvoXhWhqXbbyDtwaEFCT41t','LRBGDESCYQ','2024-10-13 11:50:15.259402',1,1,'pi_3Q9QJNRskpesRRvc0C64XRKC'),(59,160.00,'2024-10-13 11:51:33.957175','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1ElNvyT08FqxkZUmuZAkyWdjKKGSkphoZdnpfmBMYg2k63Ga8C0pkSkkN','P7OGEI4RHT','2024-10-13 11:53:20.990893',1,1,'pi_3Q9QMKRskpesRRvc1KSFUrps'),(60,210.00,'2024-10-13 11:57:18.380194','COMPLETED','Carte de cr├®dit (fictive)','cs_test_b1ziLK71Tn0o3mcWFoUhoTpG193vSrlGadjA61d69U3SeDWlMbnu4ce54o','QNAIQGVOHF','2024-10-13 11:57:30.160641',1,2,'pi_3Q9QQORskpesRRvc00VM533Q'),(61,90.00,'2024-10-13 12:16:11.785864','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1ccOIBrQ2M0hrdwHEkcbIM3w3mtswKV2za1V5BCZP45bSsICFcK6J2sSP','VLRDZEUMDD','2024-10-13 12:16:23.292625',9,1,'pi_3Q9QifRskpesRRvc0EY4qdCi'),(62,160.00,'2024-10-13 12:18:24.796430','COMPLETED','Carte de cr├®dit (fictive)','cs_test_a1yjSS3Ul9K0woo6ayFEFBtxWqPEnrkgudJkPQPMtCGeYeR5IlwnFsT7eZ','8NYYJQTKDD','2024-10-13 12:18:39.269205',9,1,'pi_3Q9QknRskpesRRvc0n7mLqZB'),(63,140.00,'2024-10-13 13:07:10.011154','COMPLETED','Carte de cr├®dit (fictive)','cs_test_b1j4Zs9S266TmKpTaoyoeeXI4HSqvaYyD3qbW4EXyZGvAbb815FIv6Z9M7','5WDH86HWYI','2024-10-13 13:07:21.792288',9,2,'pi_3Q9RVzRskpesRRvc05HfSleY'),(64,140.00,'2024-10-13 14:33:09.895181','COMPLETED','Carte de cr├®dit (fictive)','cs_test_b1RyeFNeGNU3eIlwPHt2UCjYYso3Cf2zNVLpGSsRe8onsQlv6cIRyj8J3a','QBMEQJKXNQ','2024-10-13 14:35:01.210044',12,2,'pi_3Q9SsoRskpesRRvc0C6izTKu');
/*!40000 ALTER TABLE `billetterie_transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billetterie_transaction_offer`
--

DROP TABLE IF EXISTS `billetterie_transaction_offer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billetterie_transaction_offer` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `transaction_id` bigint NOT NULL,
  `ticket_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `billetterie_transaction__transaction_id_ticket_id_e1d26d0a_uniq` (`transaction_id`,`ticket_id`),
  KEY `billetterie_transact_ticket_id_092c0c1a_fk_billetter` (`ticket_id`),
  CONSTRAINT `billetterie_transact_ticket_id_092c0c1a_fk_billetter` FOREIGN KEY (`ticket_id`) REFERENCES `billetterie_ticket` (`id`),
  CONSTRAINT `billetterie_transact_transaction_id_77129132_fk_billetter` FOREIGN KEY (`transaction_id`) REFERENCES `billetterie_transaction` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=62 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billetterie_transaction_offer`
--

LOCK TABLES `billetterie_transaction_offer` WRITE;
/*!40000 ALTER TABLE `billetterie_transaction_offer` DISABLE KEYS */;
INSERT INTO `billetterie_transaction_offer` VALUES (1,10,3),(2,11,3),(3,12,3),(4,13,3),(5,14,3),(6,15,3),(7,16,3),(8,17,4),(9,18,3),(10,19,2),(11,19,4),(12,20,2),(13,20,3),(14,20,4),(15,21,3),(16,22,3),(17,23,3),(18,24,4),(19,25,4),(20,26,3),(21,27,4),(22,28,4),(23,29,4),(24,30,4),(25,31,4),(26,32,4),(27,33,2),(28,34,2),(29,35,4),(30,36,4),(31,37,4),(32,38,4),(33,39,4),(34,40,2),(35,40,3),(36,41,2),(37,41,3),(38,42,2),(39,42,3),(40,43,2),(45,51,3),(46,52,3),(47,53,4),(48,54,4),(49,55,4),(50,56,4),(51,57,4),(52,58,4),(53,59,4),(54,60,2),(55,60,4),(56,61,3),(57,62,4),(58,63,2),(59,63,3),(60,64,2),(61,64,3);
/*!40000 ALTER TABLE `billetterie_transaction_offer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billetterie_utilisateur`
--

DROP TABLE IF EXISTS `billetterie_utilisateur`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billetterie_utilisateur` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `unique_key` varchar(32) NOT NULL,
  `first_name` varchar(150) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `password` varchar(128) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_key` (`unique_key`),
  UNIQUE KEY `billetterie_utilisateur_email_866f0284_uniq` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billetterie_utilisateur`
--

LOCK TABLES `billetterie_utilisateur` WRITE;
/*!40000 ALTER TABLE `billetterie_utilisateur` DISABLE KEYS */;
INSERT INTO `billetterie_utilisateur` VALUES (1,'2024-10-13 11:38:33.033664',0,0,1,'2024-10-06 11:36:13.405184','XhrFeAG26SjTbAE6Hi8dWr6OBtneAYpL','NICOLAS','BAYLOU','nicolasbaylou@gmail.com','pbkdf2_sha256$870000$MGaI27kHMrz35iavhPwH1d$0suKd2ynj5wa20TLl4nvsHNC+kpE/xCC9bONt1vcSIE='),(3,'2024-10-16 19:33:06.603116',0,0,1,'2024-10-09 15:52:58.261777','YPnCm0aGQc2VwKCuFlBbbK6BZSRsChAe','jean','jean','jean@gmail.com','pbkdf2_sha256$870000$Mv9Z8r1lM1MkRsvwQSCfhJ$moysQ1bIRzleybURSbYfnc3pszUytmUVnnvXRT/FqGg='),(4,'2024-10-16 19:36:49.837718',0,0,1,'2024-10-09 15:59:20.398986','sD6Ouc1TYch0YuJgkZV2KUvlTsZhwxJW','jeanne','jeanne','jeanne@gmail.com','pbkdf2_sha256$870000$IrdVNTF98mDRdZgSwoPNDi$o2+r/AqS1QwAJWFB4m7JbUMZ50yexA5Mh7bgCDBy39o='),(5,'2024-10-13 13:47:57.371853',1,1,1,'2024-10-09 18:28:03.038514','EYQA3kvZsLQNwatABDUVEJ9Uues4pNqp','','','admin@exemple.fr','pbkdf2_sha256$870000$TbmHIU5D1Lx6TX4bT2wyUq$BmniQn7IeJQF0/nq48VJ8uoEIT9ryIVX527gUg9stvA='),(6,'2024-10-16 19:35:57.537154',0,0,1,'2024-10-09 19:19:44.040872','vHsXwoGUrUMRwKPQqHK5IV6THCe8OxwH','test','test','test@test.fr','pbkdf2_sha256$870000$D1hHGdj6PqeACuu1vwVTHC$3pqJVFPsjGGw/3ctTFu4X8tJy91bqSwCrZj691vo6P4='),(7,'2024-10-16 19:29:34.640871',0,0,1,'2024-10-09 19:52:04.875997','cVFaPuvYi6wJ2LgBiJw0eNz64am6YXrm','','michel','michel@michel.com','pbkdf2_sha256$870000$Q5FeqM8U7Yj8OWb0GenVbV$Z4uO8OyR6jHJ9MN2ts6wn50udqDvEk362DSV22zuxOE='),(8,'2024-10-09 19:59:16.307274',0,0,1,'2024-10-09 19:59:15.180107','z8Tuohj0JdFQSpXbfgpkS7rE1S9j07wx','al','al','al@al.fr','pbkdf2_sha256$870000$2vCRSgJX4OhWXI3DxKQMlJ$8Yna+3Ijrcp5qLcQeikNyntsH2YxfG2guU75gi1Nbew='),(9,'2024-10-15 19:57:54.222258',0,0,1,'2024-10-10 16:08:50.560721','ZTvoqgQsbf7KOoXQEU6w83XBHSMj77pj','t','t','t@t.fr','pbkdf2_sha256$870000$WTOtsZtYHn4VdZSSAyyxhv$0MwB9b7VhUVV+5EB88fmRywhaJm9WkovSGksY3RyDpc='),(10,'2024-10-13 07:36:39.829951',0,0,1,'2024-10-13 07:36:13.452346','jPHRMSF0AJvJ58mUCvckauwWiyRZl8xD','nicolas','nicolas','nicolas@nicolas.com','pbkdf2_sha256$870000$HQzIiuXpsLsupXNOeFWlIL$+B2b3Wc/BVEKLzJOSNH7qqTwpaEZ5OuN7L8PZSPkmrA='),(11,'2024-10-13 07:42:09.973057',0,0,1,'2024-10-13 07:42:08.789283','LIKrwgCtyxtLAFDkkdxjuPuKQS0WAhH3','jl','jl','jl@gmail.com','pbkdf2_sha256$870000$iBJLx4kWllrlHvg7B6bnNK$yMnwud1qCElwdNnwx2ZKGMm0rNcdDW7vS1fx6ZvXM4Q='),(12,'2024-10-13 14:15:41.013295',0,0,1,'2024-10-13 14:13:38.308277','5N1u05JfQ3utyc9sR7s1DyYFCkFbDl4S','Alain','TERIEUR','alain974@gmail.com','pbkdf2_sha256$870000$2bOh7OKpeZiGAoVJF4SNVL$56vzPBU1qsLUWLECVHh8wSjfKDIRkcQtYfMZw5ZnqeU=');
/*!40000 ALTER TABLE `billetterie_utilisateur` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billetterie_utilisateur_groups`
--

DROP TABLE IF EXISTS `billetterie_utilisateur_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billetterie_utilisateur_groups` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `utilisateur_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `billetterie_utilisateur__utilisateur_id_group_id_69ba61db_uniq` (`utilisateur_id`,`group_id`),
  KEY `billetterie_utilisat_group_id_421f8fdf_fk_auth_grou` (`group_id`),
  CONSTRAINT `billetterie_utilisat_group_id_421f8fdf_fk_auth_grou` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `billetterie_utilisat_utilisateur_id_b1d5240d_fk_billetter` FOREIGN KEY (`utilisateur_id`) REFERENCES `billetterie_utilisateur` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billetterie_utilisateur_groups`
--

LOCK TABLES `billetterie_utilisateur_groups` WRITE;
/*!40000 ALTER TABLE `billetterie_utilisateur_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `billetterie_utilisateur_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `billetterie_utilisateur_user_permissions`
--

DROP TABLE IF EXISTS `billetterie_utilisateur_user_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `billetterie_utilisateur_user_permissions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `utilisateur_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `billetterie_utilisateur__utilisateur_id_permissio_ab2852fd_uniq` (`utilisateur_id`,`permission_id`),
  KEY `billetterie_utilisat_permission_id_91b13a80_fk_auth_perm` (`permission_id`),
  CONSTRAINT `billetterie_utilisat_permission_id_91b13a80_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `billetterie_utilisat_utilisateur_id_4ddbb054_fk_billetter` FOREIGN KEY (`utilisateur_id`) REFERENCES `billetterie_utilisateur` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `billetterie_utilisateur_user_permissions`
--

LOCK TABLES `billetterie_utilisateur_user_permissions` WRITE;
/*!40000 ALTER TABLE `billetterie_utilisateur_user_permissions` DISABLE KEYS */;
/*!40000 ALTER TABLE `billetterie_utilisateur_user_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_admin_log`
--

DROP TABLE IF EXISTS `django_admin_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_admin_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_billetterie_utilisateur_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_billetterie_utilisateur_id` FOREIGN KEY (`user_id`) REFERENCES `billetterie_utilisateur` (`id`),
  CONSTRAINT `django_admin_log_chk_1` CHECK ((`action_flag` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_admin_log`
--

LOCK TABLES `django_admin_log` WRITE;
/*!40000 ALTER TABLE `django_admin_log` DISABLE KEYS */;
INSERT INTO `django_admin_log` VALUES (14,'2024-10-09 18:31:17.608780','2','',3,'',6,5);
/*!40000 ALTER TABLE `django_admin_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_content_type`
--

DROP TABLE IF EXISTS `django_content_type`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_content_type` (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_content_type`
--

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;
INSERT INTO `django_content_type` VALUES (1,'admin','logentry'),(3,'auth','group'),(2,'auth','permission'),(12,'billetterie','ticket'),(13,'billetterie','transaction'),(6,'billetterie','utilisateur'),(4,'contenttypes','contenttype'),(8,'oauth2_provider','accesstoken'),(7,'oauth2_provider','application'),(9,'oauth2_provider','grant'),(11,'oauth2_provider','idtoken'),(10,'oauth2_provider','refreshtoken'),(5,'sessions','session');
/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_migrations`
--

DROP TABLE IF EXISTS `django_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_migrations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_migrations`
--

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;
INSERT INTO `django_migrations` VALUES (1,'contenttypes','0001_initial','2024-10-06 07:43:20.973487'),(2,'contenttypes','0002_remove_content_type_name','2024-10-06 07:43:22.387688'),(3,'auth','0001_initial','2024-10-06 07:43:27.397147'),(4,'auth','0002_alter_permission_name_max_length','2024-10-06 07:43:28.397148'),(5,'auth','0003_alter_user_email_max_length','2024-10-06 07:43:28.500147'),(6,'auth','0004_alter_user_username_opts','2024-10-06 07:43:28.550148'),(7,'auth','0005_alter_user_last_login_null','2024-10-06 07:43:28.592151'),(8,'auth','0006_require_contenttypes_0002','2024-10-06 07:43:28.688149'),(9,'auth','0007_alter_validators_add_error_messages','2024-10-06 07:43:28.808151'),(10,'auth','0008_alter_user_username_max_length','2024-10-06 07:43:28.873391'),(11,'auth','0009_alter_user_last_name_max_length','2024-10-06 07:43:28.916391'),(12,'auth','0010_alter_group_name_max_length','2024-10-06 07:43:29.138390'),(13,'auth','0011_update_proxy_permissions','2024-10-06 07:43:29.193391'),(14,'auth','0012_alter_user_first_name_max_length','2024-10-06 07:43:29.235392'),(15,'billetterie','0001_initial','2024-10-06 07:43:35.428833'),(16,'admin','0001_initial','2024-10-06 07:43:37.740337'),(17,'admin','0002_logentry_remove_auto_add','2024-10-06 07:43:37.852310'),(18,'admin','0003_logentry_add_action_flag_choices','2024-10-06 07:43:37.904476'),(19,'oauth2_provider','0001_initial','2024-10-06 07:43:52.415395'),(20,'oauth2_provider','0002_auto_20190406_1805','2024-10-06 07:43:53.576772'),(21,'oauth2_provider','0003_auto_20201211_1314','2024-10-06 07:43:55.393983'),(22,'oauth2_provider','0004_auto_20200902_2022','2024-10-06 07:44:02.273251'),(23,'oauth2_provider','0005_auto_20211222_2352','2024-10-06 07:44:02.381249'),(24,'oauth2_provider','0006_alter_application_client_secret','2024-10-06 07:44:02.458251'),(25,'oauth2_provider','0007_application_post_logout_redirect_uris','2024-10-06 07:44:03.109249'),(26,'oauth2_provider','0008_alter_accesstoken_token','2024-10-06 07:44:03.166799'),(27,'oauth2_provider','0009_add_hash_client_secret','2024-10-06 07:44:03.632671'),(28,'oauth2_provider','0010_application_allowed_origins','2024-10-06 07:44:04.138938'),(29,'oauth2_provider','0011_refreshtoken_token_family','2024-10-06 07:44:04.603395'),(30,'oauth2_provider','0012_add_token_checksum','2024-10-06 07:44:09.190419'),(31,'sessions','0001_initial','2024-10-06 07:44:10.172633'),(32,'billetterie','0002_alter_utilisateur_email_alter_utilisateur_first_name_and_more','2024-10-06 10:42:49.629574'),(33,'billetterie','0003_ticket_transaction','2024-10-08 17:55:49.337618'),(34,'billetterie','0004_rename_available_tickets_ticket_nb_person','2024-10-08 19:46:41.237435'),(35,'billetterie','0005_remove_utilisateur_username_alter_utilisateur_email','2024-10-09 17:49:12.818371'),(36,'billetterie','0006_alter_utilisateur_managers','2024-10-09 18:26:49.275848'),(37,'billetterie','0007_transaction_quantity','2024-10-12 11:09:40.740771'),(38,'billetterie','0008_remove_transaction_offer_transaction_offer','2024-10-12 14:47:01.448626'),(39,'billetterie','0009_alter_transaction_total_price','2024-10-12 15:06:19.709786'),(40,'billetterie','0010_transaction_payment_intent','2024-10-12 16:26:39.398990'),(41,'billetterie','0011_alter_transaction_transaction_id','2024-10-12 16:35:08.355286'),(42,'billetterie','0012_alter_transaction_transaction_id','2024-10-12 16:44:17.910150'),(43,'billetterie','0013_alter_transaction_payment_intent','2024-10-12 18:46:49.622707'),(44,'billetterie','0014_alter_transaction_payment_intent','2024-10-12 19:00:01.465401'),(45,'billetterie','0015_rename_payment_intent_transaction_payment_id','2024-10-12 19:44:56.354514'),(46,'billetterie','0016_alter_transaction_transaction_id','2024-10-12 19:48:02.017789'),(47,'billetterie','0017_rename_payment_id_transaction_payment_intent_and_more','2024-10-12 20:39:50.981248');
/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `django_session`
--

DROP TABLE IF EXISTS `django_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `django_session`
--

LOCK TABLES `django_session` WRITE;
/*!40000 ALTER TABLE `django_session` DISABLE KEYS */;
INSERT INTO `django_session` VALUES ('56mvldm5qanz25vv4tlu3h45vx3cpz2d','.eJylkMuS2jAQRf_F64QSFoby7AbEEHlQaxz8kLyhbGHG8mPGIILBqfx7RLLIB2TRi-7q27fv-enkSpXGOE9OeQ-qYqM01wGNRzoFTQ39-O6pFZ3TphfJKvAndgkV7qUtWh-VYtnS-lPLFOpMwEj1oDNRDXZ2s90MovUNiMLbVdBLEWperzGr36eMqBmMytCuR_nOHu_kjafUgzRoMiIHiEJPulDJOh5ltKxhIzHfSJeTcHh4HAS0qvX7zD7GMJpUe7TTa45MsAufITDJ9a0wCuXdous9dhPboRBtf4n3TDlfnHN5PJem-p_Aqks6W2O-soIumT0ELFJ3TmIPCMVwH3SevqB_IJ4x_wvidNg0D8MG3NiFlE2BhBaGRIxkjezimQ2NwJUDI-8ejxIt_zyVjJkIjnn6gAj-5DpfXLZavP7A7Nu1PfOvBvDSx6e3pnTXBw-O88VpfyDRC0bOr98Dl6BC:1sydrJ:UDS6eHdpa2-IlkrhWlHxc124UmXIR_L7Wbe38pmoW1A','2024-10-23 21:04:37.320384'),('af2tbqjervl2dyfjp5x1dygpt4r88846','.eJylkMtygjAUht-FdesEBQe6q4AYNIko12w6yD0Eb9gR6PTdG6aLPkAX_-KcOZf_-7-kJE3zrpPepHxwqpOd1qR2oD9CGdewg-eDmhpwCZtrFBiOPhND4DR_8BPXQR6tOGSXOg4xoxEeYf2saVQ9Ra8XlYI9a8CeP-wM5xpHbk2YtUCslJFZqtgTx9srSI7ieOvLOKQtsWNFqKem2yPmqvEcV6jFDQ5Rj7xURV4jTz-yCPOU61cqjJENmO27RVHsqkTDr9oWaPBMlnO2yBc7rNHP4RZAuPKWWfDh3p_Si3TPi3veVf8BTtugFRoTY4IIlGlBGByI6QswJCNhMgnX4C-Id4X8BnHL7EY8FD1WKjHDNWW8QbYLaIjbWEATb8XRaAlg-EShBfAwmQpGGjlFEk4hVvoM8ANnR-o_WgpNFmck9rZnM7PuSgnUwIesUDan_TrxL1D6_gFdXaE4:1sye8e:AI6R9wqITpD0xHVqrXiCxx5P-yUnEwnQT5hpZ5IzOkc','2024-10-23 21:22:32.375380'),('b5xakgwu3uzx6tt4lmt1jji4i2yawy62','.eJydUsuSojAU_RfXU1SAiDK7BhTDTEjZKgIbK-QhIA8Vu9V0zb9P6OpFz3YWqeQ-zjn3nsrH5EDfbuXhbRDXQ8UnPyfu5Mf3XEHZSXRjgde0O_YG67vbtSqMscX4qg4G7rlovK_efwhKOpQaXTjQ4kJOC-jMpMmdqeQF1a85g2AOGKUQ2LYtWCGlS202g1yK2ZzOJZ1TbjOpSSljYhg0l3hGZRGyilQR2ilkxhUaUPc6ZT5y0OmcJn7kGroJFNatKRoXiNRrUN1X2T6u8zRWqLpXeVrede6hIxhvj5BskfXbj85Zuq5IvbBxfTRJsFO4zgbUngHdaPIa2ZmFp3m7rOJwB0mwfsY6xha2SaC5A6wytQZ5m59GDZ7GDWvcc64HIykw1CVYPZb55hDkafdutYn3nkl_FR4URZSacNjSx3RFltICet-rkFfxad5_L8zapNVHUV8D2gSOALxlTxJk9njHeki6X4JvRphYfRpx4eFJCyIrVl6dt9jEIYZkvwCZYneyX4Osjeps-6J5MkACr8ajRpeoPI0k3Y8mNq7RXbzV4y4eoHFXxzN_kWa5STzHub788of1q_5M4aXvm-XCvk_-_AUhv9n1:1syy0X:mH839XK3LowGxeqNR3asT4ogsvHTdtFuZ0uc8nQVsy8','2024-10-24 18:35:29.265216'),('qq86cuywdrrvaq12w4ekim6umckig6fo','.eJylkMF2gjAQRf-FdetBBE_pzhKKSZsASpBkBxQlIbFWtAo9_ffGbvoBXcxi5sybN-9-WWVdN31vPVrNgNoqqkUsEKQjnBIBe7hfeXUA57A7FHmA_IlZsivnpCrl203xpKB8F2xDJC_ICMVF8KK9mNnVdC7JwoHI1H0N0IEVqYhlOMNyN8WguxCw66E-2OXaHNfYIzJXPEIdltTjIHXZiD2uqY0d6mDAFZe5ZA4ebh5vBVG18g_cPIZn9mQ8awcvcId80aiHMPVPUZg0boTpOkkejp9XAqf-4r5ZvnTWnXVstsemb_8TuNa5NjWWgRHo3L0JcFYPMaAeyVI7Di6i3DzbfyAWHga_ID7eos4YwoFkT12c1Q6WbEaACarZaEAKJqlDwEqQDeq45C0bbk_lIy_QttzcIBJ_0n5eTyyr6HKf-GM1aLA7X0VCw3ReoWG9reIXtrfJ_qzuofX9A0VfodA:1syeAC:psi_3pENjo4_A-1l0oNPMGyzUIvfAmTXKbmSJYeWdBU','2024-10-23 21:24:08.766854'),('ukx9irivzoex5mh4hzhajqz8ni7409n3','e30:1t19kH:qVumhBoVRvu-GbSCoPboyl5hlBpj6NliNtwus7ku3hY','2024-10-30 19:31:45.162929'),('xtot0txyl7qkrochn5skvzntccjmdwre','e30:1sxPYc:npjV_fsdam96DLMi0xUY8HYVu-_MKQiI0c3D7XCqih4','2024-10-20 11:36:14.352868'),('xyf6w91ggqytlels5l6x0yljkrzn8zun','.eJylUMFygjAQ_RfO1YmAztAbBcUgCWJBQi4OBjRBsFS0SDr990Yv_YAednb27b7dfe9byxkru0571crB53uPiVD4MJFwggXs4HkzZQ6cwVNLto5vjdUQ2OvXel9boCRvNaw-RJbiihIsoegFJbxX2F1VJo7nA5JQBo7fZiQSYTU3UHWcIPeoMupg04L8XS2vkIklFkjHHOk-p26k-raZVUiilAqqOKHLeSbt--NGQXDNaqul6rFwCcbJGl5H5w6QaWJP8CY-krWFiwMU7YjWroNuM_xV34Ju8mZrL9qlPFzKjv9HMGu2jQqZO4rQbM0HAcVsCN1k-hQ99CJPF-DPCFsJfBrxWXgndVBhzUagit2zuOY0jgDWIz1rFL9ZCJyquokM6kUgez61lZT4hzx9mMitsbsjMBhZs-I0GLRddrm52qQrFsh-R5Zen99sY27swc4bbO3nFzhPoW4:1sye4x:6Wb_Xftm0TrHJv9cpitOxDPjm32O61hGjEprm1qZv-c','2024-10-23 21:18:43.756505');
/*!40000 ALTER TABLE `django_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_accesstoken`
--

DROP TABLE IF EXISTS `oauth2_provider_accesstoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_accesstoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` longtext NOT NULL,
  `expires` datetime(6) NOT NULL,
  `scope` longtext NOT NULL,
  `application_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `source_refresh_token_id` bigint DEFAULT NULL,
  `id_token_id` bigint DEFAULT NULL,
  `token_checksum` varchar(64) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `oauth2_provider_accesstoken_token_checksum_85319a26_uniq` (`token_checksum`),
  UNIQUE KEY `source_refresh_token_id` (`source_refresh_token_id`),
  UNIQUE KEY `id_token_id` (`id_token_id`),
  KEY `oauth2_provider_acce_application_id_b22886e1_fk_oauth2_pr` (`application_id`),
  KEY `oauth2_provider_acce_user_id_6e4c9a65_fk_billetter` (`user_id`),
  CONSTRAINT `oauth2_provider_acce_application_id_b22886e1_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth2_provider_acce_id_token_id_85db651b_fk_oauth2_pr` FOREIGN KEY (`id_token_id`) REFERENCES `oauth2_provider_idtoken` (`id`),
  CONSTRAINT `oauth2_provider_acce_source_refresh_token_e66fbc72_fk_oauth2_pr` FOREIGN KEY (`source_refresh_token_id`) REFERENCES `oauth2_provider_refreshtoken` (`id`),
  CONSTRAINT `oauth2_provider_acce_user_id_6e4c9a65_fk_billetter` FOREIGN KEY (`user_id`) REFERENCES `billetterie_utilisateur` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_accesstoken`
--

LOCK TABLES `oauth2_provider_accesstoken` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_accesstoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_accesstoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_application`
--

DROP TABLE IF EXISTS `oauth2_provider_application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_application` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `client_id` varchar(100) NOT NULL,
  `redirect_uris` longtext NOT NULL,
  `client_type` varchar(32) NOT NULL,
  `authorization_grant_type` varchar(32) NOT NULL,
  `client_secret` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `skip_authorization` tinyint(1) NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `algorithm` varchar(5) NOT NULL,
  `post_logout_redirect_uris` longtext NOT NULL,
  `hash_client_secret` tinyint(1) NOT NULL,
  `allowed_origins` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `client_id` (`client_id`),
  KEY `oauth2_provider_appl_user_id_79829054_fk_billetter` (`user_id`),
  KEY `oauth2_provider_application_client_secret_53133678` (`client_secret`),
  CONSTRAINT `oauth2_provider_appl_user_id_79829054_fk_billetter` FOREIGN KEY (`user_id`) REFERENCES `billetterie_utilisateur` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_application`
--

LOCK TABLES `oauth2_provider_application` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_application` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_grant`
--

DROP TABLE IF EXISTS `oauth2_provider_grant`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_grant` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `code` varchar(255) NOT NULL,
  `expires` datetime(6) NOT NULL,
  `redirect_uri` longtext NOT NULL,
  `scope` longtext NOT NULL,
  `application_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `code_challenge` varchar(128) NOT NULL,
  `code_challenge_method` varchar(10) NOT NULL,
  `nonce` varchar(255) NOT NULL,
  `claims` longtext NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `oauth2_provider_gran_application_id_81923564_fk_oauth2_pr` (`application_id`),
  KEY `oauth2_provider_gran_user_id_e8f62af8_fk_billetter` (`user_id`),
  CONSTRAINT `oauth2_provider_gran_application_id_81923564_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth2_provider_gran_user_id_e8f62af8_fk_billetter` FOREIGN KEY (`user_id`) REFERENCES `billetterie_utilisateur` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_grant`
--

LOCK TABLES `oauth2_provider_grant` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_grant` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_grant` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_idtoken`
--

DROP TABLE IF EXISTS `oauth2_provider_idtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_idtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `jti` char(32) NOT NULL,
  `expires` datetime(6) NOT NULL,
  `scope` longtext NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `application_id` bigint DEFAULT NULL,
  `user_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `jti` (`jti`),
  KEY `oauth2_provider_idto_application_id_08c5ff4f_fk_oauth2_pr` (`application_id`),
  KEY `oauth2_provider_idto_user_id_dd512b59_fk_billetter` (`user_id`),
  CONSTRAINT `oauth2_provider_idto_application_id_08c5ff4f_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth2_provider_idto_user_id_dd512b59_fk_billetter` FOREIGN KEY (`user_id`) REFERENCES `billetterie_utilisateur` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_idtoken`
--

LOCK TABLES `oauth2_provider_idtoken` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_idtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_idtoken` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oauth2_provider_refreshtoken`
--

DROP TABLE IF EXISTS `oauth2_provider_refreshtoken`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `oauth2_provider_refreshtoken` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `token` varchar(255) NOT NULL,
  `access_token_id` bigint DEFAULT NULL,
  `application_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `created` datetime(6) NOT NULL,
  `updated` datetime(6) NOT NULL,
  `revoked` datetime(6) DEFAULT NULL,
  `token_family` char(32) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `access_token_id` (`access_token_id`),
  UNIQUE KEY `oauth2_provider_refreshtoken_token_revoked_af8a5134_uniq` (`token`,`revoked`),
  KEY `oauth2_provider_refr_application_id_2d1c311b_fk_oauth2_pr` (`application_id`),
  KEY `oauth2_provider_refr_user_id_da837fce_fk_billetter` (`user_id`),
  CONSTRAINT `oauth2_provider_refr_access_token_id_775e84e8_fk_oauth2_pr` FOREIGN KEY (`access_token_id`) REFERENCES `oauth2_provider_accesstoken` (`id`),
  CONSTRAINT `oauth2_provider_refr_application_id_2d1c311b_fk_oauth2_pr` FOREIGN KEY (`application_id`) REFERENCES `oauth2_provider_application` (`id`),
  CONSTRAINT `oauth2_provider_refr_user_id_da837fce_fk_billetter` FOREIGN KEY (`user_id`) REFERENCES `billetterie_utilisateur` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oauth2_provider_refreshtoken`
--

LOCK TABLES `oauth2_provider_refreshtoken` WRITE;
/*!40000 ALTER TABLE `oauth2_provider_refreshtoken` DISABLE KEYS */;
/*!40000 ALTER TABLE `oauth2_provider_refreshtoken` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-10-18 21:50:49
