
DROP TABLE IF EXISTS `accounts`;
CREATE TABLE `accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(60) NOT NULL,
  `hash` varchar(500) NOT NULL,
  `email` varchar(255) NOT NULL,
  `utype` varchar(40) NOT NULL,
  `subtype` varchar(45) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `accounts` WRITE;
UNLOCK TABLES;
DROP TABLE IF EXISTS `complaints`;
CREATE TABLE `complaints` (
  `complaintid` int NOT NULL AUTO_INCREMENT,
  `email` varchar(50) NOT NULL,
  `block` varchar(45) NOT NULL,
  `floor` int NOT NULL,
  `roomno` varchar(25) NOT NULL,
  `complaint` varchar(300) NOT NULL,
  `complainttype` varchar(30) NOT NULL,
  `status` varchar(20) NOT NULL,
  `cts` varchar(30) NOT NULL,
  `uts` varchar(50) NOT NULL,
  `utype` varchar(50) NOT NULL,
  PRIMARY KEY (`complaintid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
LOCK TABLES `complaints` WRITE;
UNLOCK TABLES;
DROP TABLE IF EXISTS `complaintslist`;
CREATE TABLE `complaintslist` (
  `complaints` varchar(100) NOT NULL,
  `complainttype` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `complaintslist` WRITE;
INSERT INTO `complaintslist` VALUES ('Lights Not Working','electrician'),('Fans Not Working','electrician'),('Switches Not Working','electrician'),('Fan Regulators Not Working','electrician'),('Benches Broken','civil and maintenance'),('Benches Nails Came out','civil and maintenance'),('Board Broken','civil and maintenance'),('Board Problem','civil and maintenance'),('Windows Broken','civil and maintenance'),('Floor Tiles Broken','civil and maintenance'),('Window Grills Broken','civil and maintenance'),('Door Broken','civil and maintenance'),('No Chalks and Duster','education aid'),('No Projector','education aid'),('Projector Not Working','education aid'),('No Markers','education aid'),('Switch Board Problem','electrician');
UNLOCK TABLES;
DROP TABLE IF EXISTS `hcomplaints`;
CREATE TABLE `hcomplaints` (
  `complaintid` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `block` varchar(100) NOT NULL,
  `floor` int NOT NULL,
  `roomno` varchar(45) NOT NULL,
  `complaint` varchar(100) NOT NULL,
  `complainttype` varchar(45) NOT NULL,
  `status` varchar(45) NOT NULL,
  `cts` varchar(45) NOT NULL,
  `uts` varchar(45) NOT NULL,
  `utype` varchar(45) NOT NULL,
  PRIMARY KEY (`complaintid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
LOCK TABLES `hcomplaints` WRITE;
UNLOCK TABLES;
DROP TABLE IF EXISTS `hcomplaintslist`;
CREATE TABLE `hcomplaintslist` (
  `complaints` varchar(100) NOT NULL,
  `complainttype` varchar(45) NOT NULL,
  PRIMARY KEY (`complaints`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

LOCK TABLES `hcomplaintslist` WRITE;
INSERT INTO `hcomplaintslist` VALUES ('Benches Broken','civil and maintenance'),('Benches Nails Came out','civil and maintenance'),('Board Broken','civil and maintenance'),('Board Problem','civil and maintenance'),('Door Broken','civil and maintenance'),('Fan Regulators Not Working','electrician'),('Fans Not Working','electrician'),('Floor Tiles Broken','civil and maintenance'),('Lights Not Working','electrician'),('Switch Board Problem','electrician'),('Switches Not Working','electrician'),('Window Grills Broken','civil and maintenance'),('Windows Broken','civil and maintenance');
UNLOCK TABLES;
DROP TABLE IF EXISTS `hroomdata`;
CREATE TABLE `hroomdata` (
  `block` varchar(100) NOT NULL,
  `floor` int NOT NULL,
  `roomno` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
LOCK TABLES `hroomdata` WRITE;
INSERT INTO `hroomdata` VALUES ('kurunji',0,'k001'),('kurunji',0,'k002'),('kurunji',0,'k003'),('kurunji',0,'k004'),('kurunji',0,'k005'),('kurunji',0,'k006'),('kurunji',0,'k007'),('kurunji',0,'k008'),('kurunji',0,'k009'),('kurunji',0,'k010'),('kurunji',0,'k011'),('kurunji',0,'k012'),('kurunji',0,'k013'),('kurunji',0,'k014'),('kurunji',0,'k015'),('kurunji',0,'k016'),('kurunji',0,'k017'),('kurunji',0,'k018'),('kurunji',0,'k019'),('kurunji',1,'k101'),('kurunji',1,'k102'),('kurunji',1,'k103'),('kurunji',1,'k104'),('kurunji',1,'k105'),('kurunji',1,'k106'),('kurunji',1,'k107'),('kurunji',1,'k108'),('kurunji',1,'k109'),('kurunji',1,'k110'),('kurunji',1,'k111'),('kurunji',1,'k112'),('kurunji',1,'k113'),('kurunji',1,'k114'),('kurunji',1,'k115'),('kurunji',1,'k116'),('kurunji',1,'k117'),('kurunji',1,'k118'),('kurunji',1,'k119'),('kurunji',1,'Library'),('kurunji',2,'k201'),('kurunji',2,'k202'),('kurunji',2,'k203'),('kurunji',2,'k204'),('kurunji',2,'k205'),('kurunji',2,'k206'),('kurunji',2,'k207'),('kurunji',2,'k208'),('kurunji',2,'k209'),('kurunji',2,'k210'),('kurunji',2,'k211'),('kurunji',2,'k212'),('kurunji',2,'k213'),('kurunji',2,'k214'),('kurunji',2,'k215'),('kurunji',2,'k216'),('kurunji',2,'k217'),('kurunji',2,'k218'),('kurunji',2,'k219'),('kurunji',2,'TV Room'),('kurunji',3,'k301'),('kurunji',3,'k302'),('kurunji',3,'k303'),('kurunji',3,'k304'),('kurunji',3,'k305'),('kurunji',3,'k306'),('kurunji',3,'k307'),('kurunji',3,'k308'),('kurunji',3,'k309'),('kurunji',3,'k310'),('kurunji',3,'k311'),('kurunji',3,'k312'),('kurunji',3,'k313'),('kurunji',3,'k314'),('kurunji',3,'k315'),('kurunji',3,'k316'),('kurunji',3,'k317'),('kurunji',3,'k318'),('kurunji',3,'k319'),('kurunji',3,'k320'),('Marutham',0,'8001'),('Marutham',0,'8002'),('Marutham',0,'8003'),('Marutham',0,'8004'),('Marutham',0,'8005'),('Marutham',0,'8006'),('Marutham',0,'8007'),('Marutham',0,'8008'),('Marutham',0,'8009'),('Marutham',0,'8010'),('Marutham',0,'8011'),('Marutham',0,'8012'),('Marutham',0,'8013'),('Marutham',0,'8014'),('Marutham',0,'8015'),('Marutham',0,'8016'),('Marutham',0,'8017'),('Marutham',0,'8018'),('Marutham',0,'8019'),('Marutham',0,'8020'),('Marutham',0,'8021'),('Marutham',0,'8022'),('Marutham',0,'8023'),('Marutham',0,'8024'),('Marutham',0,'8025'),('Marutham',0,'8026'),('Marutham',0,'8027'),('Marutham',0,'8028'),('Marutham',1,'8101'),('Marutham',1,'8102'),('Marutham',1,'8103'),('Marutham',1,'8104'),('Marutham',1,'8105'),('Marutham',1,'8106'),('Marutham',1,'8107'),('Marutham',1,'8108'),('Marutham',1,'8109'),('Marutham',1,'8110'),('Marutham',1,'8111'),('Marutham',1,'8112'),('Marutham',1,'8113'),('Marutham',1,'8114'),('Marutham',1,'8115'),('Marutham',1,'8116'),('Marutham',1,'8117'),('Marutham',1,'8118'),('Marutham',1,'8119'),('Marutham',1,'8120'),('Marutham',1,'8121'),('Marutham',1,'8122'),('Marutham',1,'8123'),('Marutham',1,'8124'),('Marutham',1,'8125'),('Marutham',1,'8126'),('Marutham',1,'8127'),('Marutham',1,'8128'),('Marutham',1,'Living Room'),('Marutham',2,'8201'),('Marutham',2,'8202'),('Marutham',2,'8203'),('Marutham',2,'8204'),('Marutham',2,'8205'),('Marutham',2,'8206'),('Marutham',2,'8207'),('Marutham',2,'8208'),('Marutham',2,'8209'),('Marutham',2,'8210'),('Marutham',2,'8211'),('Marutham',2,'8212'),('Marutham',2,'8213'),('Marutham',2,'8214'),('Marutham',2,'8215'),('Marutham',2,'8216'),('Marutham',2,'8217'),('Marutham',2,'8218'),('Marutham',2,'8219'),('Marutham',2,'8220'),('Marutham',2,'8221'),('Marutham',2,'8222'),('Marutham',2,'8223'),('Marutham',2,'8224'),('Marutham',2,'8225'),('Marutham',2,'8226'),('Marutham',2,'8227'),('Marutham',2,'8228'),('Marutham',2,'Indoor Games'),('Marutham',3,'8301'),('Marutham',3,'8302'),('Marutham',3,'8303'),('Marutham',3,'8304'),('Marutham',3,'8305'),('Marutham',3,'8306'),('Marutham',3,'8307'),('Marutham',3,'8308'),('Marutham',3,'8309'),('Marutham',3,'8310'),('Marutham',3,'8311'),('Marutham',3,'8312'),('Marutham',3,'8313'),('Marutham',3,'8314'),('Marutham',3,'8315'),('Marutham',3,'8316'),('Marutham',3,'8317'),('Marutham',3,'8318'),('Marutham',3,'8319'),('Marutham',3,'8320'),('Marutham',3,'8321'),('Marutham',3,'8322'),('Marutham',3,'8323'),('Marutham',3,'8324'),('Marutham',3,'8325'),('Marutham',3,'8326'),('Marutham',3,'8327'),('Marutham',3,'8328'),('Marutham',3,'TV Room');
UNLOCK TABLES;
DROP TABLE IF EXISTS `roomdata`;
CREATE TABLE `roomdata` (
  `block` varchar(45) NOT NULL,
  `floor` int NOT NULL,
  `roomno` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
LOCK TABLES `roomdata` WRITE;
INSERT INTO `roomdata` VALUES ('CB BLOCK',1,'103'),('CB BLOCK',2,'203'),('CB BLOCK',2,'206'),('CB BLOCK',3,'303'),('RAJAM LECTURE HALL',0,'1'),('RAJAM LECTURE HALL',0,'CONFERENCE HALL'),('RAJAM LECTURE HALL',0,'2'),('RAJAM LECTURE HALL',0,'3'),('RAJAM LECTURE HALL',0,'4'),('RAJAM LECTURE HALL',1,'101'),('RAJAM LECTURE HALL',1,'102'),('RAJAM LECTURE HALL',1,'103'),('RAJAM LECTURE HALL',1,'104'),('RAJAM LECTURE HALL',1,'105'),('RAJAM LECTURE HALL',1,'106'),('RAJAM LECTURE HALL',1,'107'),('RAJAM LECTURE HALL',2,'201'),('RAJAM LECTURE HALL',2,'202'),('RAJAM LECTURE HALL',2,'203'),('RAJAM LECTURE HALL',2,'204'),('RAJAM LECTURE HALL',2,'205'),('RAJAM LECTURE HALL',2,'206'),('RAJAM LECTURE HALL',2,'207'),('RAJAM LECTURE HALL',3,'301'),('RAJAM LECTURE HALL',3,'DRAWING HALL 1'),('RAJAM LECTURE HALL',3,'DRAWING HALL 2'),('RAJAM LECTURE HALL',3,'DRAWING HALL 3'),('RAJAM LECTURE HALL',3,'302'),('RAJAM LECTURE HALL',3,'303'),('RAJAM LECTURE HALL',3,'304'),('ABDUL KALAM LECTURE HALL',0,'1'),('ABDUL KALAM LECTURE HALL',0,'2'),('ABDUL KALAM LECTURE HALL',0,'3'),('ABDUL KALAM LECTURE HALL',0,'4'),('ABDUL KALAM LECTURE HALL',0,'5'),('ABDUL KALAM LECTURE HALL',0,'6'),('ABDUL KALAM LECTURE HALL',0,'7'),('ABDUL KALAM LECTURE HALL',0,'8'),('ABDUL KALAM LECTURE HALL',0,'9'),('ABDUL KALAM LECTURE HALL',1,'101'),('ABDUL KALAM LECTURE HALL',1,'102'),('ABDUL KALAM LECTURE HALL',1,'103'),('ABDUL KALAM LECTURE HALL',1,'104'),('ABDUL KALAM LECTURE HALL',1,'105'),('ABDUL KALAM LECTURE HALL',1,'106'),('ABDUL KALAM LECTURE HALL',1,'107'),('ABDUL KALAM LECTURE HALL',1,'108'),('ABDUL KALAM LECTURE HALL',1,'109'),('ABDUL KALAM LECTURE HALL',2,'201'),('ABDUL KALAM LECTURE HALL',2,'202'),('ABDUL KALAM LECTURE HALL',2,'203'),('ABDUL KALAM LECTURE HALL',2,'204'),('ABDUL KALAM LECTURE HALL',2,'205'),('ABDUL KALAM LECTURE HALL',2,'206'),('ABDUL KALAM LECTURE HALL',2,'207'),('ABDUL KALAM LECTURE HALL',2,'208'),('ABDUL KALAM LECTURE HALL',3,'301'),('ABDUL KALAM LECTURE HALL',3,'302'),('ABDUL KALAM LECTURE HALL',3,'303'),('ABDUL KALAM LECTURE HALL',3,'304'),('ABDUL KALAM LECTURE HALL',3,'305'),('ABDUL KALAM LECTURE HALL',3,'306');
UNLOCK TABLES;
DROP TABLE IF EXISTS `utype`;
CREATE TABLE `utype` (
  `utype` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
LOCK TABLES `utype` WRITE;
INSERT INTO `utype` VALUES ('admin'),('cthod'),('ithod'),('student'),('common');
UNLOCK TABLES;