-- MySQL dump 10.13  Distrib 5.1.62, for debian-linux-gnu (i486)
--
-- Host: localhost    Database: centrojusticia
-- ------------------------------------------------------
-- Server version	5.1.62-0ubuntu0.10.04.1-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `adjuntos`
--

DROP TABLE IF EXISTS `adjuntos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `adjuntos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(120) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_size` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_type` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tipodoc_id` int(11) DEFAULT NULL,
  `tramite_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tramite` (`tramite_id`),
  KEY `tipodoc` (`tipodoc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `adjuntos`
--

LOCK TABLES `adjuntos` WRITE;
/*!40000 ALTER TABLE `adjuntos` DISABLE KEYS */;
/*!40000 ALTER TABLE `adjuntos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comparecencias`
--

DROP TABLE IF EXISTS `comparecencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `comparecencias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fechahora` datetime DEFAULT NULL,
  `procedencia` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `caracter` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hora_preferencia` int(11) DEFAULT NULL,
  `dia_preferencia` int(11) DEFAULT NULL,
  `conocimiento` tinyint(1) DEFAULT NULL,
  `datos` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `asunto` text COLLATE utf8_unicode_ci,
  `observaciones` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `tramite_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comparecencias`
--

LOCK TABLES `comparecencias` WRITE;
/*!40000 ALTER TABLE `comparecencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `comparecencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estatus`
--

DROP TABLE IF EXISTS `estatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estatus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `clave` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT NULL,
  `is_finish` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `clave_estatus` (`clave`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estatus`
--

LOCK TABLES `estatus` WRITE;
/*!40000 ALTER TABLE `estatus` DISABLE KEYS */;
INSERT INTO `estatus` VALUES (1,'Trámite iniciado vía internet','tram-inte',0,0),(2,'Trámite iniciado','tram-inic',1,0),(3,'Comparecencia no levantada','no-compar',0,0),(4,'Comparecencia concluida','comp-conc',0,0),(5,'Tramite admitido','tram-admi',0,0),(6,'Tramite no admitido','tram-noad',0,0),(7,'Materia asignada','mate-asig',0,0),(8,'Especialista y comediador asignados','espe-asig',0,0),(9,'Especialista y comediador validados','vali-espe',0,0),(10,'Fecha de sesión asignada','fech-asig',0,0),(11,'Invitaciones firmadas por subdirector','invi-firm',0,0),(12,'Invitaciones en proceso de entrega','invi-proc',0,0),(13,'Invitaciones razonadas','invi-razo',0,0),(14,'Cambio de fecha de sesión','camb-sesi',0,0),(15,'Se firmo compromiso de participación','comp-firm',0,0),(16,'En sesión','en-sesion',0,0),(17,'Acuerdo finalizado','acue-fina',0,0),(18,'Sin acuerdo logrado','sin-acuer',0,0),(19,'En proceso de elaboración de convenio','proc-conv',0,0),(20,'Convenio validado','conv-vali',0,0),(21,'Convenio Ratificado','conv-rati',0,0),(22,'Trámite finalizado','tram-fina',0,1);
/*!40000 ALTER TABLE `estatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estatus_roles`
--

DROP TABLE IF EXISTS `estatus_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estatus_roles` (
  `role_id` int(11) DEFAULT NULL,
  `estatu_id` int(11) DEFAULT NULL,
  KEY `index_estatus_roles_on_role_id` (`role_id`),
  KEY `index_estatus_roles_on_estatu_id` (`estatu_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estatus_roles`
--

LOCK TABLES `estatus_roles` WRITE;
/*!40000 ALTER TABLE `estatus_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `estatus_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estatus_sesions`
--

DROP TABLE IF EXISTS `estatus_sesions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estatus_sesions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estatus_sesions`
--

LOCK TABLES `estatus_sesions` WRITE;
/*!40000 ALTER TABLE `estatus_sesions` DISABLE KEYS */;
INSERT INTO `estatus_sesions` VALUES (1,'En proceso'),(2,'Realizada en tiempo y forma'),(3,'No se presento solicitante'),(4,'Solo se presento solicitante'),(5,'Por mal comportamiento se suspendio sesíón'),(6,'Se reprogramo sesión'),(7,'Otro');
/*!40000 ALTER TABLE `estatus_sesions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flujos`
--

DROP TABLE IF EXISTS `flujos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `flujos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `old_status_id` int(11) DEFAULT NULL,
  `new_status_id` int(11) DEFAULT NULL,
  `role_id` int(11) DEFAULT NULL,
  `descripcion` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flujos`
--

LOCK TABLES `flujos` WRITE;
/*!40000 ALTER TABLE `flujos` DISABLE KEYS */;
INSERT INTO `flujos` VALUES (6,2,4,9,'Levantar comparecencia','2012-12-11 10:46:28','2012-12-11 10:46:28'),(7,4,5,4,'Admitir trámite','2012-12-11 10:49:25','2012-12-11 10:49:25'),(8,5,7,12,'Asignar materia','2012-12-11 10:49:44','2012-12-11 10:49:44'),(10,7,8,4,'Asignar especialistas','2012-12-11 11:05:44','2012-12-11 11:05:44'),(11,8,9,4,'Validar especialistas','2012-12-13 12:35:06','2012-12-13 12:35:06'),(12,9,11,4,'Firmar invitaciones','2012-12-13 12:35:27','2012-12-13 12:35:27'),(13,11,12,10,'Generar invitaciones','2012-12-13 12:36:37','2012-12-13 12:36:37'),(14,12,13,10,'Invitaciones Entregadas','2013-02-13 14:53:58','2013-02-13 14:53:58'),(15,13,15,9,'Firmar compromiso de participación','2013-02-13 14:54:44','2013-02-13 14:54:44');
/*!40000 ALTER TABLE `flujos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historias`
--

DROP TABLE IF EXISTS `historias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `historias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tramite_id` int(11) DEFAULT NULL,
  `estatu_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tramite` (`tramite_id`),
  KEY `estatus` (`estatu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historias`
--

LOCK TABLES `historias` WRITE;
/*!40000 ALTER TABLE `historias` DISABLE KEYS */;
INSERT INTO `historias` VALUES (1,18,2,21,'2013-03-05 15:53:25','2013-03-05 15:53:25');
/*!40000 ALTER TABLE `historias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horarios`
--

DROP TABLE IF EXISTS `horarios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `horarios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hora` int(11) DEFAULT NULL,
  `minutos` int(11) DEFAULT NULL,
  `descripcion` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sala_id` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horarios`
--

LOCK TABLES `horarios` WRITE;
/*!40000 ALTER TABLE `horarios` DISABLE KEYS */;
INSERT INTO `horarios` VALUES (1,9,0,'',1,1),(2,10,30,'',1,1),(3,12,0,'',1,1),(4,13,30,'',1,1),(5,15,0,'',1,1),(6,16,30,'',1,1),(7,17,30,'',1,1),(8,18,30,'',1,1),(9,9,0,'',2,1),(10,10,30,'',2,1),(11,12,0,'',2,1),(12,13,30,'',2,1),(13,15,0,'',2,1),(14,16,30,'',2,1),(15,17,30,'',2,1),(16,18,30,'',2,1),(17,9,0,'',3,1),(18,10,30,'',3,1),(19,12,0,'',3,1),(20,13,30,'',3,1),(21,15,0,'',3,1),(22,16,30,'',3,1),(23,17,30,'',3,1),(24,18,30,'',3,1),(25,9,0,'',4,1),(26,10,30,'',4,1),(27,12,0,'',4,1),(28,13,30,'',4,1),(29,15,0,'',4,1),(30,16,30,'',4,1),(31,17,30,'',4,1),(32,18,30,'',4,1),(33,9,0,'',5,1),(34,10,30,'',5,1),(35,12,0,'',5,1),(36,13,30,'',5,1),(37,15,0,'',5,1),(38,16,30,'',5,1),(39,17,30,'',5,1),(40,18,30,'',5,1);
/*!40000 ALTER TABLE `horarios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invitacions`
--

DROP TABLE IF EXISTS `invitacions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `invitacions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `sesion_id` int(11) DEFAULT NULL,
  `entregada` tinyint(1) DEFAULT NULL,
  `justificacion` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `fecha_hora_entrega` datetime DEFAULT NULL,
  `invitador_id` int(11) DEFAULT NULL,
  `printed_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sesion` (`sesion_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invitacions`
--

LOCK TABLES `invitacions` WRITE;
/*!40000 ALTER TABLE `invitacions` DISABLE KEYS */;
/*!40000 ALTER TABLE `invitacions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materias`
--

DROP TABLE IF EXISTS `materias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `materias` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materias`
--

LOCK TABLES `materias` WRITE;
/*!40000 ALTER TABLE `materias` DISABLE KEYS */;
INSERT INTO `materias` VALUES (1,'CIVIL'),(2,'PENAL'),(3,'MERCANTIL'),(4,'FISCAL'),(5,'OTRA');
/*!40000 ALTER TABLE `materias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `materias_users`
--

DROP TABLE IF EXISTS `materias_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `materias_users` (
  `user_id` int(11) DEFAULT NULL,
  `materia_id` int(11) DEFAULT NULL,
  KEY `index_materias_users_on_user_id` (`user_id`),
  KEY `index_materias_users_on_materia_id` (`materia_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `materias_users`
--

LOCK TABLES `materias_users` WRITE;
/*!40000 ALTER TABLE `materias_users` DISABLE KEYS */;
INSERT INTO `materias_users` VALUES (1,2),(4,2),(5,2),(14,2),(2,2),(3,2),(7,2),(9,2),(13,2),(12,2),(16,2),(17,2),(10,2),(1,1),(4,1),(7,1),(8,1);
/*!40000 ALTER TABLE `materias_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `municipios`
--

DROP TABLE IF EXISTS `municipios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `municipios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=121 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `municipios`
--

LOCK TABLES `municipios` WRITE;
/*!40000 ALTER TABLE `municipios` DISABLE KEYS */;
INSERT INTO `municipios` VALUES (1,'ACACOYAGUA'),(2,'ACALA'),(3,'ACAPETAHUA'),(4,'ALTAMIRANO'),(5,'AMATAN'),(6,'AMATENANGO DE LA FRONTERA'),(7,'AMATENANGO DEL VALLE'),(8,'ANGEL ALBINO CORZO'),(9,'ARRIAGA'),(10,'BEJUCAL DE OCAMPO'),(11,'BELLA VISTA'),(12,'BERRIOZABAL'),(13,'BOCHIL'),(14,'EL BOSQUE'),(15,'CACAHOATAN'),(16,'CATAZAJA'),(17,'CINTALAPA'),(18,'COAPILLA'),(19,'COMITAN DE DOMINGUEZ'),(20,'LA CONCORDIA'),(21,'COPAINALA'),(22,'CHALCHIHUITAN'),(23,'CHAMULA'),(24,'CHANAL'),(25,'CHAPULTENANGO'),(26,'CHENALHO'),(27,'CHIAPA DE CORZO'),(28,'CHIAPILLA'),(29,'CHICOASEN'),(30,'CHICOMUSELO'),(31,'CHILON'),(32,'ESCUINTLA'),(33,'FRANCISCO LEON'),(34,'FRONTERA COMALAPA'),(35,'FRONTERA HIDALGO'),(36,'LA GRANDEZA'),(37,'HUEHUETAN'),(38,'HUIXTAN'),(39,'HUITIUPAN'),(40,'HUIXTLA'),(41,'LA INDEPENDENCIA'),(42,'IXHUATAN'),(43,'IXTACOMITAN'),(44,'IXTAPA'),(45,'IXTAPANGAJOYA'),(46,'JIQUIPILAS'),(47,'JITOTOL'),(48,'JUAREZ'),(49,'LARRAINZAR'),(50,'LA LIBERTAD'),(51,'MAPASTEPEC'),(52,'LAS MARGARITAS'),(53,'MAZAPA DE MADERO'),(54,'MAZATAN'),(55,'METAPA'),(56,'MITONTIC'),(57,'MOTOZINTLA'),(58,'NICOLAS RUIZ'),(59,'OCOSINGO'),(60,'OCOTEPEC'),(61,'OCOZOCOAUTLA DE ESPINOSA'),(62,'OSTUACAN'),(63,'OSUMACINTA'),(64,'OXCHUC'),(65,'PALENQUE'),(66,'PANTELHO'),(67,'PANTEPEC'),(68,'PICHUCALCO'),(69,'PIJIJIAPAN'),(70,'EL PORVENIR'),(71,'VILLA COMALTITLAN'),(72,'PUEBLO NUEVO SOLISTAHUACAN'),(73,'RAYON'),(74,'REFORMA'),(75,'LAS ROSAS'),(76,'SABANILLA'),(77,'SALTO DE AGUA'),(78,'SAN CRISTOBAL DE LAS CASAS'),(79,'SAN FERNANDO'),(80,'SILTEPEC'),(81,'SIMOJOVEL'),(82,'SITALA'),(83,'SOCOLTENANGO'),(84,'SOLOSUCHIAPA'),(85,'SOYALO'),(86,'SUCHIAPA'),(87,'SUCHIATE'),(88,'SUNUAPA'),(89,'TAPACHULA'),(90,'TAPALAPA'),(91,'TAPILULA'),(92,'TECPATAN'),(93,'TENEJAPA'),(94,'TEOPISCA'),(95,'TILA'),(96,'TONALA'),(97,'TOTOLAPA'),(98,'LA TRINITARIA'),(99,'TUMBALA'),(100,'TUXTLA GUTIERREZ'),(101,'TUXTLA CHICO'),(102,'TUZANTAN'),(103,'TZIMOL'),(104,'UNION JUAREZ'),(105,'VENUSTIANO CARRANZA'),(106,'VILLA CORZO'),(107,'VILLAFLORES'),(108,'YAJALON'),(109,'SAN LUCAS'),(110,'ZINACANTAN'),(111,'SAN JUAN CANCUC'),(112,'ALDAMA'),(113,'BENEMERITO DE LAS AMERICAS'),(114,'MARAVILLA TENEJAPA'),(115,'MARQUES DE COMILLAS'),(116,'MONTE CRISTO DE GUERRERO'),(117,'SAN ANDRES DURAZNAL'),(118,'SANTIAGO EL PINAR'),(119,'OTRO MUNICIPIO'),(120,'OTRA ENTIDAD FEDERATIVA');
/*!40000 ALTER TABLE `municipios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orientacions`
--

DROP TABLE IF EXISTS `orientacions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orientacions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fechahora` datetime DEFAULT NULL,
  `observaciones` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `paterno` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `materno` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nombre` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sexo` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `direccion` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `telefono` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `correo` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `municipio_id` int(11) DEFAULT NULL,
  `tramite_id` int(11) DEFAULT NULL,
  `notificacion` tinyint(1) DEFAULT NULL,
  `especialista_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orientacions`
--

LOCK TABLES `orientacions` WRITE;
/*!40000 ALTER TABLE `orientacions` DISABLE KEYS */;
INSERT INTO `orientacions` VALUES (1,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(3,NULL,NULL,2,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,NULL,NULL,3,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(5,NULL,NULL,5,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(6,NULL,NULL,4,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(7,NULL,NULL,1,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(8,'2013-03-01 12:00:00','',7,'ARAUJO','PEREZ','ERNETO','M','AVENIDA AGUILA 234, COL. BUENAVISTA','961234567','',14,18,0,NULL,'2013-03-05 15:53:25','2013-03-05 15:53:25');
/*!40000 ALTER TABLE `orientacions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `participantes`
--

DROP TABLE IF EXISTS `participantes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `participantes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `paterno` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `materno` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `nombre` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fecha_nac` date DEFAULT NULL,
  `sexo` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  `domicilio` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `telefono_particular` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `telefono_celular` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `correo` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `municipio_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `comparecencia_id` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `participantes`
--

LOCK TABLES `participantes` WRITE;
/*!40000 ALTER TABLE `participantes` DISABLE KEYS */;
/*!40000 ALTER TABLE `participantes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles`
--

DROP TABLE IF EXISTS `roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `descripcion` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `prioridad` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles`
--

LOCK TABLES `roles` WRITE;
/*!40000 ALTER TABLE `roles` DISABLE KEYS */;
INSERT INTO `roles` VALUES (1,'consejo','Consejo de la Judicatura',1),(2,'admin','Administrador global',2),(3,'direccion','Dirección General',3),(4,'subdireccion','Subdirección Regional',4),(5,'controlagenda','Control de agenda',5),(6,'lecturaagenda','Control de agenda',6),(7,'jefeatencionpublico','Jefatura de área de Atención al público',7),(8,'atencionpublico','Area de Atención al público',8),(9,'especialistas','Especialistas públicos',9),(10,'invitadores','Invitadores',10),(11,'reportes','Reportes',11),(12,'convenios','Área de convenios',12),(13,'solicitantes','Solicitantes',13),(14,'invitados','Invitados',14);
/*!40000 ALTER TABLE `roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `roles_users`
--

DROP TABLE IF EXISTS `roles_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `roles_users` (
  `role_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  KEY `index_roles_users_on_role_id` (`role_id`),
  KEY `index_roles_users_on_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `roles_users`
--

LOCK TABLES `roles_users` WRITE;
/*!40000 ALTER TABLE `roles_users` DISABLE KEYS */;
INSERT INTO `roles_users` VALUES (9,1),(9,2),(9,3),(9,4),(9,5),(9,6),(9,7),(9,8),(9,9),(9,10),(9,11),(9,12),(9,13),(9,14),(9,15),(9,16),(9,17),(9,18),(9,19),(2,21),(8,22),(4,21),(12,23),(10,24),(10,25),(4,26),(5,27);
/*!40000 ALTER TABLE `roles_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salas`
--

DROP TABLE IF EXISTS `salas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `salas` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `capacidad` int(11) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `subdireccion_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salas`
--

LOCK TABLES `salas` WRITE;
/*!40000 ALTER TABLE `salas` DISABLE KEYS */;
INSERT INTO `salas` VALUES (1,'SALA DE SESIONES A',4,1,1),(2,'SALA DE SESIONES B',2,1,1),(3,'SALA DE SESIONES C',5,1,1),(4,'SALA DE SESIONES D',3,1,1),(5,'SALA DE SESIONES E',3,1,1);
/*!40000 ALTER TABLE `salas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `unique_schema_migrations` (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20120530154405'),('20120530190914'),('20120531140012'),('20120531155447'),('20120601195609'),('20120605183732'),('20120605192218'),('20120606154602'),('20120612193447'),('20120625154756'),('20120625160154'),('20120625182414'),('20120710165447'),('20120710173629'),('20120713184620'),('20120713190926'),('20120716150646'),('20120815144449'),('20120827151402'),('20120828190049'),('20120925192334'),('20120926173716'),('20121226161646'),('20130102174026'),('20130103155420'),('20130211182804'),('20130214174040'),('20130305212059');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sesions`
--

DROP TABLE IF EXISTS `sesions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sesions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `observaciones` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `resultado` varchar(120) COLLATE utf8_unicode_ci DEFAULT NULL,
  `num_tramite` varchar(9) COLLATE utf8_unicode_ci DEFAULT NULL,
  `clave` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` int(11) DEFAULT NULL,
  `minutos` int(11) DEFAULT NULL,
  `sala_id` int(11) DEFAULT NULL,
  `tramite_id` int(11) DEFAULT NULL,
  `mediador_id` int(11) DEFAULT NULL,
  `comediador_id` int(11) DEFAULT NULL,
  `horario_id` int(11) DEFAULT NULL,
  `estatus_sesion_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `tiposesion_id` int(11) DEFAULT NULL,
  `activa` tinyint(1) DEFAULT NULL,
  `notificacion` tinyint(1) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `signed_at` datetime DEFAULT NULL,
  `signer_id` int(11) DEFAULT NULL,
  `concluida` tinyint(1) DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `tramite` (`tramite_id`),
  KEY `mediador` (`mediador_id`),
  KEY `comediador` (`comediador_id`),
  KEY `horario` (`horario_id`),
  KEY `clave` (`clave`),
  KEY `tiposesion` (`tiposesion_id`),
  KEY `busqueda_diaria` (`hora`,`minutos`,`sala_id`),
  KEY `fecha` (`fecha`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sesions`
--

LOCK TABLES `sesions` WRITE;
/*!40000 ALTER TABLE `sesions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sesions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `data` text COLLATE utf8_unicode_ci,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sessions_on_session_id` (`session_id`),
  KEY `index_sessions_on_updated_at` (`updated_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sessions`
--

LOCK TABLES `sessions` WRITE;
/*!40000 ALTER TABLE `sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `subdireccions`
--

DROP TABLE IF EXISTS `subdireccions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `subdireccions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(60) COLLATE utf8_unicode_ci DEFAULT NULL,
  `titular` varchar(70) COLLATE utf8_unicode_ci DEFAULT NULL,
  `direccion` varchar(120) COLLATE utf8_unicode_ci DEFAULT NULL,
  `codigo_postal` varchar(5) COLLATE utf8_unicode_ci DEFAULT NULL,
  `telefonos` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `municipio_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `subdireccions`
--

LOCK TABLES `subdireccions` WRITE;
/*!40000 ALTER TABLE `subdireccions` DISABLE KEYS */;
INSERT INTO `subdireccions` VALUES (1,'Subdirección Regional Centro','Lic. Rodrigo Dominguez Moscoso','Calle Candoquis número 290 esq. con Avenida Pino, Fraccionamiento el bosque','29047','6178700, ext 8863, 8864 y 8865',100),(2,'Subdirección Regional Istmo-Costa','Lic. Ivan Méndez Soriano','Calle Nube número 280 esq. con Avenida Encino, Fraccionamiento las flores','32047','6278700, ext 8863, 8864 y 8865',89);
/*!40000 ALTER TABLE `subdireccions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipodocs`
--

DROP TABLE IF EXISTS `tipodocs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipodocs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipodocs`
--

LOCK TABLES `tipodocs` WRITE;
/*!40000 ALTER TABLE `tipodocs` DISABLE KEYS */;
INSERT INTO `tipodocs` VALUES (1,'COPIA DE ACTA DE NACIMIENTO'),(2,'COPIA DE ACTA DE MATRIMONIO'),(3,'COPIA DE ACTA DE DEFUNCION'),(4,'COPIA DE CREDENCIAL DE ELECTOR'),(5,'COPIA DE FACTURA AUTOMOTRIZ'),(6,'COPIA DE SENTENCIA');
/*!40000 ALTER TABLE `tipodocs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tiposesions`
--

DROP TABLE IF EXISTS `tiposesions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tiposesions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tiposesions`
--

LOCK TABLES `tiposesions` WRITE;
/*!40000 ALTER TABLE `tiposesions` DISABLE KEYS */;
INSERT INTO `tiposesions` VALUES (1,'ORIENTACION CONJUNTA'),(2,'SESION CONSECUTIVA'),(3,'FORMA DE CONVENIO'),(4,'MODIFICACION DE CONVENIO');
/*!40000 ALTER TABLE `tiposesions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tramites`
--

DROP TABLE IF EXISTS `tramites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tramites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `anio` varchar(4) COLLATE utf8_unicode_ci DEFAULT NULL,
  `folio` varchar(6) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subdireccion_id` int(11) DEFAULT NULL,
  `estatu_id` int(11) DEFAULT NULL,
  `materia_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `busqueda` (`anio`,`folio`),
  KEY `estatus` (`estatu_id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tramites`
--

LOCK TABLES `tramites` WRITE;
/*!40000 ALTER TABLE `tramites` DISABLE KEYS */;
INSERT INTO `tramites` VALUES (17,'2013','200',1,9,2,22,NULL,'2013-03-04 19:27:05','2013-03-04 19:37:48'),(18,'2013','201',1,2,NULL,21,NULL,'2013-03-05 15:53:25','2013-03-05 15:53:26');
/*!40000 ALTER TABLE `tramites` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `login` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `crypted_password` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `salt` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `remember_token` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `remember_token_expires_at` datetime DEFAULT NULL,
  `activation_code` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activated_at` datetime DEFAULT NULL,
  `last_login` datetime DEFAULT NULL,
  `nombre` varchar(100) COLLATE utf8_unicode_ci DEFAULT '',
  `paterno` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `materno` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `direccion` varchar(120) COLLATE utf8_unicode_ci DEFAULT NULL,
  `tel_celular` int(11) DEFAULT NULL,
  `subdireccion_id` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  `admin` tinyint(1) DEFAULT '0',
  `sexo` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_login` (`login`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'nhernandez','nhernandez@correo.com','960ba37cf4a3b153f59fe465d9934d811fe6ec12','140eb38550258d5ccdc31690fe4ad38feb2b8ed0','2012-12-10 11:03:57','2013-03-04 20:01:14',NULL,NULL,'19f1b353bf5362a18a4fffe74e14eb6d34e1fcc1','2012-12-10 11:03:57','2013-03-04 20:01:14','Néstor Elí','Hernández','Gálvez',NULL,NULL,1,1,0,'M'),(2,'clicea','clicea@correo.com','5945b9918075139134ae3c7ea6c5815300764f3d','2c7afb99d7f96d31621b84ddc246af50c1ed3a55','2012-12-10 11:04:13','2012-12-10 11:04:13',NULL,NULL,'9ab864c2a44cd06915048247857c3e61bafd8396','2012-12-10 11:04:13',NULL,'Cyntia Carolina','Licea','Bonilla',NULL,NULL,1,1,0,'F'),(3,'lcordova','lcordova@correo.com','a78246539a53afe4cc7c955826e23651cec8a847','95c25083198e9fbc90a7d93d11f9a42ed2183dc5','2012-12-10 11:04:16','2013-02-25 12:22:10',NULL,NULL,'58438a4eaf2871b5a42711fe329555f77c7b817c','2012-12-10 11:04:16','2013-02-25 12:22:10','Legna Patricia','Córdova','Solís',NULL,NULL,1,1,0,'F'),(4,'mlopez','mlopez@correo.com','1d6a0c2eccb9a5c8c8015f859adddd5fd28ec4a0','3ac1b671e95f1ce5bde8f5780d8c5a9146f075e7','2012-12-10 11:04:19','2012-12-10 11:04:19',NULL,NULL,'7b73a49b0ef4609e0efe3c30115c557caddc7435','2012-12-10 11:04:19',NULL,'María Lourdes','López','Sánchez',NULL,NULL,1,1,0,'F'),(5,'mtorres','mtorres@correo.com','6449652d1a30170a1c5e6af4335f2d1d5c475351','a1304bee65ffae77a1449fa42625023e41b553c3','2012-12-10 11:04:24','2012-12-10 11:04:24',NULL,NULL,'8c72c7a9d5e9372fb469b2397cfade2c254a18c4','2012-12-10 11:04:24',NULL,'Maricela','Torres','Dávila',NULL,NULL,1,1,0,'F'),(6,'lalfonso','lalfonso@correo.com','ae00a9b2116344d54dfe6ccaf7da76b9d840b25f','5f020fffeb261358653ac31fd43a3aac60b49136','2012-12-10 11:04:29','2013-01-03 15:06:53',NULL,NULL,'88c8b851a81b51cd3272cea97d28d78e369ab82f','2012-12-10 11:04:29','2013-01-03 15:06:53','Lucia Guadalupe','Alfonso','Ontiveros',NULL,NULL,1,1,0,NULL),(7,'ldominguez','ldominguez@correo.com','a3488f0c04875ffb183eba95f5844ef75da58766','6472487223dbe8947fc0e2c8e614b21e4a0939f3','2012-12-10 11:04:29','2012-12-10 11:04:29',NULL,NULL,'144cdc831009834aa30425f8cc5e45f1d7243e62','2012-12-10 11:04:29',NULL,'Laura Guadalupe','Domínguez','Rodríguez',NULL,NULL,1,1,0,NULL),(8,'egoldhaber','egoldhaber@correo.com','d437bf2aa06f8e6acada0cde5c5bca9f7ca774af','93a2470c005daa938e2307ee4fee15f83edec836','2012-12-10 11:04:43','2012-12-10 11:04:43',NULL,NULL,'cf399dc707fc13715afd7004a906cf04d63f3ed5','2012-12-10 11:04:43',NULL,'Elisheba','Goldhaber','Pasillas',NULL,NULL,1,1,0,NULL),(9,'lperez','lperez@correo.com','6fd4b61fc0681ab7dcc496cc4c68ba73d5a3e11e','dc24bdcc83f59679eaf6f745f6f9f4ae575210d7','2012-12-10 11:05:14','2013-01-02 13:09:55',NULL,NULL,'1e4eae1529869b12dd39043e329ea8217527622b','2012-12-10 11:05:14','2013-01-02 13:09:55','Laura Sabrina','Pérez','Muñoz',NULL,NULL,1,1,0,NULL),(10,'apalacios','apalacios@correo.com','002b95af1e5c08e93fc7e2b42e801b700208abf9','4a16111df48e5cdf43c8bd79a00ad098a9984aac','2012-12-10 11:05:14','2013-03-04 10:15:30',NULL,NULL,'5f7917bb84788f7f454e193e722ef8d11b24558e','2012-12-10 11:05:14','2013-03-04 10:15:30','Amauri','Palacios','Aquino',NULL,NULL,1,1,0,NULL),(11,'rrobles','rrobles@correo.com','b3a1be32492a4269cb47a3b85958aa81af1133ef','0c794557bb31f53ea49427a01607b9bc3534261f','2012-12-10 11:05:15','2012-12-10 11:05:15',NULL,NULL,'59a85e6f27bc1822e395ed0ad2622afbde1a6f3b','2012-12-10 11:05:15',NULL,'Roxana','Robles','Dávila',NULL,NULL,1,1,0,NULL),(12,'aruvalcaba','aruvalcaba@correo.com','1cfcf78f06a3a1bf83e2f003edd3de0bc8090081','484d2a69486f819fdae87d194ff04c5759d1c5fe','2012-12-10 11:05:17','2013-03-04 19:27:34',NULL,NULL,'9570b234071322389bab1c7c423b0e86cb55b405','2012-12-10 11:05:17','2013-03-04 19:27:34','Alexandra','Ruvalcaba','Aguilar',NULL,NULL,1,1,0,NULL),(13,'cmartinez','cmartinez@correo.com','def6bfd7d37edbeaf68a29be5362ef512dd7d563','443f1714969b9669f8410bdb6cd6bc2dc926891a','2012-12-10 11:05:20','2012-12-10 11:05:20',NULL,NULL,'9a3a2dd732f6795f8320769b8f3e4ecc5eac494d','2012-12-10 11:05:20',NULL,'Carolina','Martínez','González',NULL,NULL,1,1,0,NULL),(14,'bvazquez','bvazquez@correo.com','d1cd6a4f7d3485d442e4ea0423a19c0a72133f57','be493ba88708934e426950ca4b8f34bde3917c32','2012-12-10 11:05:21','2013-02-18 10:11:36',NULL,NULL,'931e981dc7b8fe06691629808f82fa1de9365130','2012-12-10 11:05:21',NULL,'Brenda María','Vázquez2','Ruiz','',NULL,1,1,0,NULL),(15,'ygutierrez','ygutierrez@correo.com','ca78d9649498438e33b3891970b50762d10f57e8','cc7f4b1de6a01ad7229fc8763337f20ff2065d66','2012-12-10 11:05:34','2012-12-10 11:05:34',NULL,NULL,'2a9d4920b192cb272307532e6185b141f0b7b4d9','2012-12-10 11:05:34',NULL,'Yesenia','Gutiérrez','Lazos',NULL,NULL,1,1,0,NULL),(16,'fdominguez','fdominguez@correo.com','1e09e2366f338cd88cdf6b53acf322c4dd841f33','e65127af453a2307819b8e509f7553e18901f96a','2012-12-10 11:05:34','2012-12-10 11:05:34',NULL,NULL,'75ca48ec0221268a5f09c105541a94777c92eca3','2012-12-10 11:05:34',NULL,'Flor Guadalupe','Domínguez','Solórzano',NULL,NULL,1,1,0,NULL),(17,'gaguilar','gaguilar@correo.com','146885db3bd1ff8f74fc4f5558b5f11034163d25','2a013460022f6117308b3132b2cf23a7df2b38da','2012-12-10 11:05:35','2013-02-08 15:52:30',NULL,NULL,'f1116555d2a5ed66d1161566e4a672b5eed4bd01','2012-12-10 11:05:35','2012-12-11 10:43:34','Gabriela','Aguilar','Gamboa',NULL,NULL,1,1,0,NULL),(18,'lrocha','lrocha@correo.com','3b52ab6116cceecb62bf08a5892dea15bbc8150f','b2f3cffc46134d6fe697d032cc0e1cbc15d1f61e','2012-12-10 11:05:39','2013-02-11 10:49:39',NULL,NULL,'1ec877f48b907eb9b7a0139512f5426bc604e083','2012-12-10 11:05:39','2013-02-11 10:49:39','Laura Patricia','Rocha','Macías',NULL,NULL,1,1,0,NULL),(19,'xosorio','xosorio@correo.com','faf8d9a9290446077c7e37e0f22a5933ed31bb66','d0165367b175224a37b6ce62640839167491bc2a','2012-12-10 11:05:39','2012-12-10 11:05:39',NULL,NULL,'b4ead82bd3ab3d8d30afd76cee969960f8f3a174','2012-12-10 11:05:39',NULL,'Xochilt Guadalupe','Osorio','Luna',NULL,NULL,1,1,0,NULL),(21,'cmonterrosa','cmonterrosa@poderjudicialchiapas.gob.mx','2dcba31ea51bc9cab47ecfde4832196c8a16a438','c450f9a0c7df64cf9b0e6a4b35016d44b8b9923a','2012-12-10 11:08:32','2013-03-05 15:23:19',NULL,NULL,NULL,'2012-12-10 17:09:09','2013-03-05 15:23:19','Carlos','Monterrosa','López','9a Oriente Norte 1098',NULL,1,1,0,NULL),(22,'atencionpublico','atencionpublico2222@gmail.com','6142a92bb3ef5d4e4f76d6754202e2ae47b91cfa','729a71abddf1708be98f05a303bfcb55b596e247','2012-12-10 11:14:54','2013-03-04 19:25:33',NULL,NULL,'bdd116cf56e55cc6a49e3c020351bea5731427eb','2012-12-10 11:14:54','2013-03-04 19:25:33','Area','atencion al publico','','Calle 8 poniente sur',2147483647,1,1,0,NULL),(23,'convenios','xrandi@hotmail.com','e6afee272800557e4966ef19ab123de96d018657','8ad54f9063c5d1603e2d8638e81babc5dc4c3a1c','2012-12-11 11:09:40','2013-03-04 19:33:52',NULL,NULL,'623e622872de4c5959d9eda4d2cfa3803ff23b7a','2012-12-11 11:09:40','2013-03-04 19:33:52','area','convenios','','xxxx',9999,1,1,0,NULL),(24,'invitador1','invitadores@gmail.com','be60fee9c517306477ecc5a267f8449d58c2853c','0b3a09226860ff1689a0ec11c048756eb8079b99','2012-12-13 12:33:38','2013-02-11 11:43:24',NULL,NULL,'5a4b6f73bf98605f8114b3561c4d994cbd64231f','2012-12-13 12:33:38','2013-02-11 11:43:24','invitador','ceja','','xxxxx',0,1,1,0,NULL),(25,'invitador2','atencionpublico3226@gmail.com','cbe3f04ebe6e6b80f167069f536d5bb721d3e592','784322d018f2fccedb5d2315432f9b0e4da1a5c9','2013-01-03 14:15:09','2013-03-04 19:42:17',NULL,NULL,'73c4e62d5ff41c2698731235ab2d8e0124eff91c','2013-01-03 14:15:09','2013-03-04 19:42:17','Juan','perez','perez','xxxx',0,1,1,0,NULL),(26,'rdominguez','rodrigo@gmail.com','b6fbe147b8d36bb703c1950e61dbaf6fc01f1f20','133ae5242aa6d8a49d9f848aa343d9c060052df0','2013-02-08 12:39:30','2013-03-04 19:38:56',NULL,NULL,'c7714f1857d5953ede9b35c3b49ca1d39209a4da','2013-02-08 12:39:30','2013-03-04 19:38:56','Rodrigo','dominguez','moscoso','xxxx',0,1,1,0,NULL),(27,'controlagenda','rodrig33o@gmail.com','e90cc60d914e5caaf7d74a560bc1be969379939b','931ce3acaf7adf02ef7e5d96b7e0f5d98a78c325','2013-02-14 12:19:46','2013-02-19 10:46:48',NULL,NULL,'c5e5fb8cadebf398351497151c2b9d13e31c02b4','2013-02-14 12:19:46','2013-02-19 10:46:48','Control','agenda','','xxxx',0,1,1,0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-05 16:05:10
