CREATE TABLE IF NOT EXISTS `pw_motels` (
  `rentalid` bigint(255) NOT NULL AUTO_INCREMENT,
  `ident` varchar(70) NOT NULL DEFAULT '0',
  `motelid` bigint(255) DEFAULT 0,
  `room` varchar(50) DEFAULT '0',
  PRIMARY KEY (`rentalid`),
  KEY `ident` (`ident`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;


INSERT INTO `pw_motels` (`rentalid`, `ident`, `motelid`, `room`) VALUES
	(1, 'steam:11000013c492722', 1, '1');
	
INSERT INTO `items` (`name`, `label`, `limit`) VALUES
('screwdriver','Screwdriver', -1),
('bobbypin','BobbyPin', -1),