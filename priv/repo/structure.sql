-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.18 - MySQL Community Server - GPL
-- Server OS:                    Linux
-- HeidiSQL Version:             10.1.0.5464
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping structure for table nordref.activate
DROP TABLE IF EXISTS `activate`;
CREATE TABLE IF NOT EXISTS `activate` (
  `activateid` int(11) NOT NULL AUTO_INCREMENT,
  `uid` int(11) NOT NULL DEFAULT '0',
  `email` varchar(90) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `akey` varchar(90) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`activateid`)
) ENGINE=MyISAM AUTO_INCREMENT=3922 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='Tabelle zur E-Mail ??pr??g';

-- Data exporting was unselected.
-- Dumping structure for table nordref.anmeldung
DROP TABLE IF EXISTS `anmeldung`;
CREATE TABLE IF NOT EXISTS `anmeldung` (
  `kid` int(11) NOT NULL DEFAULT '0',
  `srid` int(11) NOT NULL DEFAULT '0',
  `zeitpunkt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `angdurch` int(11) NOT NULL DEFAULT '0',
  `fehler` int(11) NOT NULL DEFAULT '0',
  `bestanden` enum('1','0') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
  `teilgen` enum('1','0') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
  `abgemeldet` enum('1','0') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
  PRIMARY KEY (`kid`,`srid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- Data exporting was unselected.
-- Dumping structure for table nordref.clubs
DROP TABLE IF EXISTS `clubs`;
CREATE TABLE IF NOT EXISTS `clubs` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `short_name` varchar(10) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `regional_association` enum('FVN','FLV-SH','BFB','FBHH','FD') CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=98 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table nordref.courses
DROP TABLE IF EXISTS `courses`;
CREATE TABLE IF NOT EXISTS `courses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `max_participants` int(11) NOT NULL DEFAULT '20',
  `max_per_club` int(11) NOT NULL DEFAULT '6',
  `organizer_participants` int(11) NOT NULL DEFAULT '6',
  `organizer` bigint(20) NOT NULL,
  `type` enum('F','J','G2','G3') COLLATE utf8_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `released` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table nordref.kurs
DROP TABLE IF EXISTS `kurs`;
CREATE TABLE IF NOT EXISTS `kurs` (
  `kid` int(11) NOT NULL AUTO_INCREMENT,
  `kursname` varchar(30) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `kursort` varchar(100) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `datum` date NOT NULL DEFAULT '0000-00-00',
  `kurstyp` enum('J','G','F','N','NT','O','I','G2','G3') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'J',
  `fehlerpunkte` int(11) NOT NULL DEFAULT '0',
  `fp_l1` int(11) NOT NULL DEFAULT '0',
  `fp_l2` int(11) NOT NULL DEFAULT '0',
  `fp_lj` int(11) NOT NULL DEFAULT '0',
  `kapa` int(11) NOT NULL DEFAULT '20',
  PRIMARY KEY (`kid`)
) ENGINE=MyISAM AUTO_INCREMENT=292 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

-- Data exporting was unselected.
-- Dumping structure for table nordref.licenses
DROP TABLE IF EXISTS `licenses`;
CREATE TABLE IF NOT EXISTS `licenses` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `club_id` bigint(20) DEFAULT NULL,
  `license_number` int(11) NOT NULL,
  `license_type` enum('N1','N2','N3','N4','L1','L2','L3','LJ') COLLATE utf8_unicode_ci NOT NULL,
  `year_of_birth` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` bigint(20) DEFAULT NULL,
  `season` int(11) NOT NULL DEFAULT '2019',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=487 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Dumping structure for table nordref.lizenz
DROP TABLE IF EXISTS `lizenz`;
CREATE TABLE IF NOT EXISTS `lizenz` (
  `lid` int(11) NOT NULL AUTO_INCREMENT,
  `srid` int(11) NOT NULL DEFAULT '0',
  `liznr` int(11) NOT NULL DEFAULT '0',
  `saison` year(4) NOT NULL DEFAULT '0000',
  `liztyp` enum('LJ','L3','L2','L1','NR','N4','N3','N2','N1','O','I') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT 'LJ',
  PRIMARY KEY (`lid`)
) ENGINE=MyISAM AUTO_INCREMENT=4229 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PACK_KEYS=0;

-- Data exporting was unselected.
-- Dumping structure for table nordref.registrations
DROP TABLE IF EXISTS `registrations`;
CREATE TABLE IF NOT EXISTS `registrations` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `first_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `birthday` date NOT NULL,
  `license_number` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  `club_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `course_id` bigint(20) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user_id` bigint(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=630 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Data exporting was unselected.
-- Dumping structure for table nordref.spiele
DROP TABLE IF EXISTS `spiele`;
CREATE TABLE IF NOT EXISTS `spiele` (
  `srid` int(11) NOT NULL DEFAULT '0',
  `saison` int(11) NOT NULL DEFAULT '0',
  `anzahl` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`srid`,`saison`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci COMMENT='Tabelle enth? die Spiele eines Spielers';

-- Data exporting was unselected.
-- Dumping structure for table nordref.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vorname` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `name` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `user` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `pass` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `recht` int(11) NOT NULL DEFAULT '5',
  `strasse` varchar(40) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `plz` varchar(5) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `ort` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `gebdatum` date NOT NULL DEFAULT '0000-00-00',
  `telhandy` varchar(20) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `vid` int(11) NOT NULL DEFAULT '0',
  `email` varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '',
  `emailbest` enum('1','0') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
  `schiri` enum('1','0') CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL DEFAULT '0',
  `session` varchar(32) CHARACTER SET latin1 COLLATE latin1_swedish_ci DEFAULT NULL,
  `approval` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `user` (`user`)
) ENGINE=MyISAM AUTO_INCREMENT=2172 DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci PACK_KEYS=0 COMMENT='Usertabelle NUB Ref!';

-- Data exporting was unselected.
-- Dumping structure for table nordref.users
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `first_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `birthday` date DEFAULT NULL,
  `mobile` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `role` enum('SUPER_ADMIN','ADMIN','CLUB_ADMIN','INSTRUCTOR','USER') COLLATE utf8_unicode_ci NOT NULL DEFAULT 'USER',
  `club_id` bigint(20) DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4290 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
