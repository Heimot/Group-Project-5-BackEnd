-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 03.05.2021 klo 10:45
-- Palvelimen versio: 10.4.17-MariaDB
-- PHP Version: 8.0.1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `digifemma`
--

-- --------------------------------------------------------

--
-- Rakenne taululle `category`
--

CREATE TABLE `category` (
  `id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Vedos taulusta `category`
--

INSERT INTO `category` (`id`, `name`) VALUES
(1, '<ei valittu>'),
(6, 'Komponentit'),
(7, 'Tietokoneet'),
(8, 'Pelit'),
(9, 'Oheislaitteet'),
(10, 'Ohjelmistot'),
(11, 'Audiohifi'),
(12, 'Alelaari');

--
-- Herättimet `category`
--
DELIMITER $$
CREATE TRIGGER `OnCategoryDelecte` BEFORE DELETE ON `category` FOR EACH ROW UPDATE product 
SET categoryID = 1 
WHERE categoryID IN ( 
SELECT categoryID 
FROM product P
WHERE P.categoryID = Old.id)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `OnCategoryDeleteSUB` BEFORE DELETE ON `category` FOR EACH ROW UPDATE subcategory 
SET categoryID = 1 
WHERE categoryID IN ( 
SELECT categoryID 
FROM subcategory S
WHERE S.categoryID = Old.id)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trgInsteadOfDeleteCategory` BEFORE DELETE ON `category` FOR EACH ROW IF(old.id=1) THEN 
SIGNAL sqlstate '45001' set message_text = "Default value cannot be deleted!"; 
END IF
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Rakenne taululle `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `productID` int(11) DEFAULT NULL,
  `customerID` int(11) DEFAULT NULL,
  `comments` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Rakenne taululle `customers`
--

CREATE TABLE `customers` (
  `id` int(11) NOT NULL,
  `email` varchar(256) NOT NULL,
  `password` varchar(256) NOT NULL,
  `firstName` varchar(256) NOT NULL,
  `lastName` varchar(256) NOT NULL,
  `address` varchar(128) DEFAULT NULL,
  `postalcode` varchar(16) DEFAULT NULL,
  `city` varchar(64) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `active` int(1) DEFAULT NULL,
  `role` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Vedos taulusta `customers`
--

INSERT INTO `customers` (`id`, `email`, `password`, `firstName`, `lastName`, `address`, `postalcode`, `city`, `phone`, `active`, `role`) VALUES
(15, 'hei2@hei.com', '$2y$10$wUYeyfwVOjLTqnpUT2WunOIpMnfi0GzvRThyKZM5s//TfWCkzrFRm', 'Joonas', 'Testi', 'Testikatu 12', '909090', 'Oulu', '04040400', NULL, 2),
(16, '', '$2y$10$jXaNL32zeKHUsb.A9gLE5eOl11qI.wcGMdb/lKmmrBfi9DZmvG9Si', '', '', '', '', '', '', NULL, 1),
(17, 'testi@testi.com', '$2y$10$sNcRnzjhjbMfEr38cA5Xwu3hQOfIPBMlF6FlM40l9q2ww7zVO6JFW', 'Testi', 'Testaaja', 'Saat 2', '909099', 'Oulu', '044040404', NULL, 1);

-- --------------------------------------------------------

--
-- Rakenne taululle `orderdetails`
--

CREATE TABLE `orderdetails` (
  `orderid` int(11) NOT NULL,
  `productid` int(11) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Vedos taulusta `orderdetails`
--

INSERT INTO `orderdetails` (`orderid`, `productid`, `amount`) VALUES
(33, 10, 3),
(33, 11, 1),
(33, 12, 1);

-- --------------------------------------------------------

--
-- Rakenne taululle `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `customerId` int(11) DEFAULT NULL,
  `price` decimal(6,2) DEFAULT NULL,
  `shipping` int(11) DEFAULT NULL,
  `email` varchar(256) NOT NULL,
  `firstName` varchar(256) NOT NULL,
  `lastName` varchar(256) NOT NULL,
  `address` varchar(128) DEFAULT NULL,
  `postalcode` varchar(16) DEFAULT NULL,
  `city` varchar(64) DEFAULT NULL,
  `phone` varchar(16) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `shipped` int(1) DEFAULT NULL,
  `orderComment` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Vedos taulusta `orders`
--

INSERT INTO `orders` (`id`, `customerId`, `price`, `shipping`, `email`, `firstName`, `lastName`, `address`, `postalcode`, `city`, `phone`, `date`, `shipped`, `orderComment`) VALUES
(33, 15, '1589.50', 1, 'hei2@hei.com', 'Joonas', 'Testi', 'Testikatu 12', '909090', 'Oulu', '04040400', '2021-05-03 08:19:23', NULL, 'Toimita mieluusti ');

-- --------------------------------------------------------

--
-- Rakenne taululle `postaltypes`
--

CREATE TABLE `postaltypes` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `cost` decimal(6,2) NOT NULL,
  `moreInfo` text DEFAULT NULL,
  `extraInfo` text DEFAULT NULL,
  `paymentMethods` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Vedos taulusta `postaltypes`
--

INSERT INTO `postaltypes` (`id`, `name`, `cost`, `moreInfo`, `extraInfo`, `paymentMethods`) VALUES
(1, 'Nouto paikan päältä', '0.00', 'Nouto Turun noutopalvelumyymälästämme.', NULL, 'Verkkopankki, mobiilimaksu, pankki/luottokortti, ja lasku/osamaksu.'),
(2, 'Matkahuolto, lähellä paketti', '0.00', 'Toimitus valitsemaasi Matkahuollon noutopisteeseen.', 'Tilauksesi toimitetaan osoitettasi lähimpään tai valitsemaasi Matkahuoltoon, Matkahuolto-asiamiespisteeseen tai Matkahuollon Noutopisteeseen (K-Marketit, R-kioskit, Pakettiautomaatit, Tokmannit ja monet muut yritykset). Saat tekstiviestin tai sähköpostin heti, kun tilaus on noudettavissa.', 'Verkkopankki, mobiilimaksu, pankki/luottokortti ja lasku/osamaksu.'),
(3, 'Matkahuolto, bussipaketti', '0.00', 'Toimitus matkahuollon toimipisteeseen.', NULL, 'Verkkopankki, mobiilimaksu, pankki/luottokortti ja lasku/osamaksu.'),
(4, 'Pakettiautomaatti', '0.00', 'Toimitus valitsemaasi pakettiautomaattiin.', NULL, 'Verkkopankki, mobiilimaksu, pankki/luottokortti ja lasku/osamaksu.'),
(5, 'Nouto postista', '0.00', 'Toimitus lähimpään postin toimipisteeseen.', NULL, 'Verkkopankki, mobiilimaksu, pankki/luottokortti, postiennakko ja lasku/osamaksu.'),
(6, 'Matkahuolto, kotijakelu', '12.50', 'Toimitus suoraan kotiovelle sovittuna ajankohtana.', NULL, 'Verkkopankki, mobiilimaksu, pankki/luottokortti sekä lasku/osamaksu'),
(7, 'Postin kotiinkuljetus', '12.50', 'Toimitus suoraan kotiovelle sovittuna ajankohtana.', NULL, 'Ennakkomaksu, postiennakko ja Klarna lasku/tili');

-- --------------------------------------------------------

--
-- Rakenne taululle `product`
--

CREATE TABLE `product` (
  `id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `categoryID` int(11) NOT NULL,
  `subCategoryID` int(11) NOT NULL,
  `description` text DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `stock` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Vedos taulusta `product`
--

INSERT INTO `product` (`id`, `name`, `price`, `categoryID`, `subCategoryID`, `description`, `weight`, `stock`) VALUES
(7, 'Asus ROG STRIX B550-F GAMING', '239.90', 6, 6, 'ROG Strix B550 Gaming series motherboards offer a feature-set usually found in the higher-end ROG Strix X570 Gaming series, including the latest PCIe® 4.0. With robust power delivery and effective cooling, ROG Strix B550 Gaming is well-equipped to handle 3rd Gen AMD Ryzen™ CPUs. Boasting futuristic aesthetics and intuitive ROG software, ROG Strix B550-I Gaming is ready to become your next compact gaming build.​', 1, 10),
(8, 'Asus ROG STRIX Z490-E GAMING', '339.90', 6, 6, 'The ROG Strix Z490-E Gaming motherboard is designed to cope with the demands of 10th Generation Intel® Core™ processors, with boosted power delivery and an optimized cooling design providing more surface area for heat dissipation. ROG Strix Z490-E Gaming features AI enhancements and intuitive dashboards to help you overclock and tweak various parameters easily. Performance aside, ROG Strix Z490-E Gaming catches the eye, sporting cyberpunk inspired aesthetics including a mirrored stainless steel finish.', 1, 10),
(9, 'NZXT H510', '99.90', 6, 7, 'NZXT H510 on täydellinen ratkaisu tietokoneen rakentajalle. Kompakti ATX-formaatti ja sulavalinjainen muotoilu takaavat, että kotelo sopii mille tahansa työpöydälle.\r\n\r\n', 5, 20),
(10, 'Samsung 1TB 970 EVO Plus SSD', '199.90', 6, 8, 'Erittäin nopea Samsung 970 EVO Plus M.2 SSD-muisti tehostaa pöytäkoneen tai kannettavan suorituskykyä. Pienikokoinen muisti mahtuu 80 mm M.2 -avainpaikkaan ja tarjoaa poikkeuksellisen 3,5 / 3,3 GB/s luku- ja kirjoitusnopeuden.\r\n\r\n', 0.1, 200),
(11, 'Kingston 16GB (2 x 8GB) HyperX FURY DDR4 RGB, 3600MHz, CL17, 1.35V', '139.90', 6, 9, 'Kingston HyperX Fury Black RGB DDR4 RAM -keskusmuisteilla parannat pelitietokoneesi suorituskykyä ja vähennät virrankulutusta. Moduuleissa on RGB-valaistus ja tyylikkäät jäähdytyselementit, jotka takaavat tehokkaan jäähdytyksen.\r\n\r\n', 0.1, 100),
(12, 'MSI GeForce RTX 3060 GAMING X TRIO -näytönohjain, 12GB GDDR6', '849.90', 6, 10, 'GeForce RTX™ 30 -sarjan grafiikkasuorittimet antavat äärimmäisen suorituskyvyn niin pelaajien kuin luovan työn tekijöidenkin käyttöön Tehon salaisuus on Ampere – NVIDIAN toisen sukupolven RTX-arkkitehtuuri, jonka uudistetut RT- ja Tensor-ytimet sekä SM-monisuorittimet varmistavat tähän asti realistisimman säteenseurantagrafiikan ja huippuluokan tekoälytoiminnot.', 2, 20),
(13, 'Asus GeForce RTX 3070 DUAL - OC Edition -näytönohjain, 8GB GDDR6', '1039.90', 6, 10, 'ASUS Dual GeForce RTX™ 3070 tarjoaa uusimman NVIDIA Ampere -arkkitehtuurin puhtaimmassa muodossaan yhdistäen suorituskyvyn ja yksinkertaisuuden parhaalla tavalla. Dual hyödyntää huipputason näytönohjaimien edistyneitä jäähdytysteknologioita. Siinä painotetaan tyylin sijaan sisältöä, joten se on täydellinen valinta tasapainoiseen kokoonpanoon. Lähde mukaan nauttimaan huippuluokan pelitehosta. ', 2, 10),
(14, 'Asus Radeon RX 5500 XT ROG Strix OC Edition -näytönohjain, 8GB GDDR6', '434.90', 6, 10, 'The ROG Strix Radeon ™ RX 5500 XT on aseistettu dominoimaan PC-pelaamista. Komponentit PCB:n päällä on tarkasti juotettu Auto-Extreme teknologialla ja kaksi voimakasta Axial-tech tuuletinta tuovat huomattavasti parannettua jäähdytystä. Lisäominaisuuksia 0dB tila, IP5X pölynvastustus, suojaava takalevy ja paljon muuta.', 2, 20),
(15, 'MSI GeForce RTX 2060 VENTUS GP OC -näytönohjain, 6GB GDDR6', '574.90', 6, 10, 'ASUS Dual GeForce® RTX 2060 6G -näytönohjaimessa suorituskyky ja yksinkertaisuus yhdistyvät ennennäkemättömällä tavalla, ja se tarjoaa uusimman NVIDIA Turing™ -pelikokemuksen aidoimmillaan. Dual GeForce® RTX 2060 6G -näytönohjaimessa hyödynnetään STRIX-lippulaivanäytönohjaimesta johdettua edistyksellistä jäähdytystekniikkaa, ja teho on nostettu tyylin yläpuolelle. Siksi se on täydellinen valinta tasapainotettuun kokoonpanoon. Valmistaudu huippuluokan pelielämykseen.\r\n', 2, 20),
(16, 'Asus Radeon RX 6900 XT ROG Strix LC - OC Edition -näytönohjain, 16GB GDDR6', '2099.90', 6, 10, 'AUTO-EXTREME -tekniikka, metalliin kääritty taustalevy, MaxContact technology, GPU Tweak II, variable rate shading (VRS), Axial-tech Fan Design, Radeon Boost, Radeon kuvan terävöitys, Radeon Anti-Lag, AMD FidelityFx, 2,9-paikkainen tuuletusjäädytin, RDNA 2 Architecture, AMD Infinity Cache, DirectX Raytracing (DXR), Contrast Adaptive Sharpening (CAS), HDCP', 2, 10),
(17, 'Gigabyte Radeon RX 6700X XT GAMING OC -näytönohjain, 12GB GDDR6', '989.90', 6, 10, 'Näytönohjain, Gigabyte Radeon RX 6700 XT Overclocked (Core clock 2514 MHz / Boost clock 2622 MHz), 2560 Stream ydintä, 12 GB GDDR6 (Memory clock 16 GHz) - 192-bit, PCI Express 4.0 x16, 2 x DisplayPort 1.4 / 2 x HDMI 2.1 liitännät, tukee AMD FreeSync, 1 x 6-pins & 1 x 8-pins virtaliitin, lyhyt pituus: 281mm - Gigabyte WindForce 3X low noise cooler kanssa RGB valo - GV-R67XTGAMING OC-12GD', 2, 10),
(18, 'AMD Ryzen 5 3600, AM4, 3.6 GHz, 6-core', '229.90', 6, 11, '3. sukupolven Ryzen on viimein täällä ja tuo mukanaan tuen PCIe 4.0 -väylälle!\r\n', 1, 15),
(19, 'AMD Ryzen 5 5600X, AM4, 3.7 GHz, 6-Core', '364.90', 6, 11, 'Prosessori (CPU), 3.7 GHz (4.6 GHz Turbo), Unlocked (voi ylikellottaa), 6 ydintä (Hexa Core), 12 säiettä, 32 MB cache, tukee: Dual Channel DDR4-3200 RAM, 24 PCI Express Gen 4.0 Lanes, AM4 Socket, 65 watt TDP, Box (sisältää Wraith Stealth -jäähdyttimen) - Zen 3\r\n\r\n', 1, 15),
(20, 'Intel Core i5-11500, LGA1200, 2.70 GHz, 12MB', '239.90', 6, 11, 'Intel Core i5-11500 on 6-ytiminen LGA1200-kantaan suunniteltu suoritin Rocket Lake -arkkitehtuurilla ja PCIe 4.0 -tuella, integroidulla näytönohjaimella sekä 2,8 Ghz peruskellotaajuudella. 11. sukupolven i5-11500 on optimoitu pelaamiseen, luomiseen ja tuottavuuteen. i5-11500-suoritin sisältää tuulettimen.\r\n\r\n', 1, 15),
(21, 'Nintendo Switch 2019 pelikonsoli + Joy-Con ohjaimet', '329.90', 8, 25, 'Nintendo Switch 2019 -pelikonsoli muuntuu käsikonsolista telakoiduksi konsoliksi, joten voit pelata sillä kotona tai ottaa sen mukaan matkalle. Liitä kaksiosaisen Joy-Con -ohjaimen molemmat puolet näyttö-osaan ja tee siitä käsikonsoli. Kun ohjainosat ovat erillään, voit käyttää niitä monipuolisesti - voit joko yhdistää ne perinteiseksi peliohjaimeksi, pitää osia kummassakin kädessä, tai pelata vaikka kaksinpeliä ystäväsi kanssa. Telakkayksikön voi liittää HD-televisioon ja voit nauttia HD-laatuisista peleistä kotisohvaltasi.\r\n', 3, 20),
(22, 'Logitech G403 HERO -pelihiiri, 25 000 dpi, musta', '59.90', 9, 29, 'Logitech G403 Prodigy -pelihiiri suunniteltu tarkkaan pelaamiseen. Hiiressä on edistynyt optinen tunnistin, ohjelmoitava RGB-valaistu ja säädettävä paino.\r\n\r\n', 1, 100),
(23, 'BenQ 23,8\" GW2475H, Full HD -monitori, musta', '149.90', 9, 30, 'BenQ GW2475H on tyylikäs ja elegantti näyttö niin kotiin kuin toimistolle. Sen minimaaliset reunat ja tyylikäs harjattu jalusta ovat visuaalisesti upea näky. Sen IPS-paneelilla saavutetaan kirkas ja tarkka kuva laajalla katselukulmalla. BenQ:n Flicker-free, Low Blue Light-teknologia ja Eye-Care ominaisuudet vähentävät silmien rasitusta.\r\n\r\n', 10, 22);

-- --------------------------------------------------------

--
-- Rakenne taululle `productpictures`
--

CREATE TABLE `productpictures` (
  `id` int(11) NOT NULL,
  `picture` varchar(255) DEFAULT NULL,
  `productId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Vedos taulusta `productpictures`
--

INSERT INTO `productpictures` (`id`, `picture`, `productId`) VALUES
(1, 'b550f.png', 7),
(3, 'b550f2.png', 7),
(4, 'z490e.png', 8),
(5, 'z490e2.png', 8),
(8, 'ryzen53600.png', 18),
(9, 'ryzen536002.png', 18),
(10, 'ryzen55600x.png', 19),
(11, 'ryzen55600x2.png', 19),
(12, 'asusrtx3070dual.png', 13),
(13, 'asusrtx3070dual2.png', 13),
(14, 'asusrx5500xt.png', 14),
(15, 'asusrx5500xt2.png', 14),
(16, 'asusrx6900xtlc.png', 16),
(17, 'asusrx6900xtlc2.png', 16),
(18, 'benq2475h.png', 23),
(19, 'benq2475h2.png', 23),
(20, 'gigabyterx6700xt.png', 17),
(21, 'gigabyterx6700xt2.png', 17),
(22, 'inteli511500.png', 20),
(23, 'inteli5115002.png', 20),
(26, '2x8hyperxfury.png', 11),
(27, '2x8hyperxfury2.png', 11),
(28, 'g403.png', 22),
(29, 'g4032.png', 22),
(30, 'msirtx2060ventus.png', 15),
(31, 'msirtx2060ventus2.png', 15),
(32, 'msirtx3060.png', 12),
(33, 'msirtx30602.png', 12),
(34, 'switch.png', 21),
(35, 'switch2.png', 21),
(36, 'switch3.png', 21),
(39, 'nzxth510.png', 9),
(40, 'nzxth5102.png', 9),
(41, 'samsung970.png', 10),
(42, 'samsung9702.png', 10);

-- --------------------------------------------------------

--
-- Rakenne taululle `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `role` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Vedos taulusta `roles`
--

INSERT INTO `roles` (`id`, `role`) VALUES
(1, 'User'),
(2, 'Admin');

-- --------------------------------------------------------

--
-- Rakenne taululle `subcategory`
--

CREATE TABLE `subcategory` (
  `id` int(11) NOT NULL,
  `name` varchar(256) NOT NULL,
  `categoryID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Vedos taulusta `subcategory`
--

INSERT INTO `subcategory` (`id`, `name`, `categoryID`) VALUES
(1, '<ei valittu>', 1),
(4, 'Asemat', 6),
(5, 'Asennus ja jäähdytys', 6),
(6, 'Emolevyt', 6),
(7, 'Kotelot', 6),
(8, 'Kovalevyt', 6),
(9, 'Muistit', 6),
(10, 'Näytönohjaimet', 6),
(11, 'Prosessorit', 6),
(12, 'Virtalähteet', 6),
(13, 'Äänikortit', 6),
(14, 'Pelitietokoneet', 7),
(15, 'Työtietokoneet', 7),
(16, 'Peliläppärit', 7),
(17, 'Työläppärit', 7),
(18, 'Kevyeen käyttöön', 7),
(19, 'PS4', 8),
(20, 'PS5', 8),
(21, 'Xbox One', 8),
(22, 'Xbox series X', 8),
(23, 'PC', 8),
(24, 'Nintendo Wii', 8),
(25, 'Nintendo Switch', 8),
(26, 'Hiiret', 9),
(27, 'Mikrofonit', 9),
(28, 'Muut', 9),
(29, 'Näppäimistöt', 9),
(30, 'Näytöt', 9),
(31, 'Jäähdytysalustat', 9),
(32, 'Tulostimet', 9),
(33, 'Massamuisti', 9),
(34, 'VR', 9),
(35, 'Webbikamerat', 9),
(36, 'Kuvat ja video', 10),
(37, 'Musiikki', 10),
(38, 'Tietoturva', 10),
(39, 'Käyttöjärjestelmät', 10),
(40, 'Toimisto', 10);

--
-- Herättimet `subcategory`
--
DELIMITER $$
CREATE TRIGGER `OnSubCategoryDelete` BEFORE DELETE ON `subcategory` FOR EACH ROW UPDATE product 
SET subcategoryID = 1 
WHERE subcategoryID IN ( 
SELECT subcategoryID 
FROM product P
WHERE P.subcategoryID = Old.id)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trgInsteadOfDeleteSubCategory` BEFORE DELETE ON `subcategory` FOR EACH ROW IF(old.id=1) THEN SIGNAL sqlstate '45001' set message_text = "Default value cannot be deleted!"; END IF
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `productID` (`productID`),
  ADD KEY `customerID` (`customerID`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `role` (`role`);

--
-- Indexes for table `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD PRIMARY KEY (`orderid`,`productid`),
  ADD KEY `orderid` (`orderid`),
  ADD KEY `productid` (`productid`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `userId` (`customerId`),
  ADD KEY `shipping` (`shipping`);

--
-- Indexes for table `postaltypes`
--
ALTER TABLE `postaltypes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoryID` (`categoryID`),
  ADD KEY `product_subcat_idx1` (`subCategoryID`);

--
-- Indexes for table `productpictures`
--
ALTER TABLE `productpictures`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`picture`),
  ADD KEY `productId` (`productId`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `subcategory`
--
ALTER TABLE `subcategory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categoryID` (`categoryID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `postaltypes`
--
ALTER TABLE `postaltypes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `product`
--
ALTER TABLE `product`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `productpictures`
--
ALTER TABLE `productpictures`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=59;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `subcategory`
--
ALTER TABLE `subcategory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- Rajoitteet vedostauluille
--

--
-- Rajoitteet taululle `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`productID`) REFERENCES `product` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`customerID`) REFERENCES `customers` (`id`);

--
-- Rajoitteet taululle `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `customers_ibfk_1` FOREIGN KEY (`role`) REFERENCES `roles` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Rajoitteet taululle `orderdetails`
--
ALTER TABLE `orderdetails`
  ADD CONSTRAINT `orderdetails_ibfk_1` FOREIGN KEY (`orderid`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `orderdetails_ibfk_2` FOREIGN KEY (`productid`) REFERENCES `product` (`id`);

--
-- Rajoitteet taululle `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `customer_ibfk_1` FOREIGN KEY (`customerId`) REFERENCES `customers` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`shipping`) REFERENCES `postaltypes` (`id`);

--
-- Rajoitteet taululle `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`categoryID`) REFERENCES `category` (`id`),
  ADD CONSTRAINT `product_subcat_idx1` FOREIGN KEY (`subCategoryID`) REFERENCES `subcategory` (`id`);

--
-- Rajoitteet taululle `productpictures`
--
ALTER TABLE `productpictures`
  ADD CONSTRAINT `productpictures_ibfk_1` FOREIGN KEY (`productId`) REFERENCES `product` (`id`) ON DELETE CASCADE;

--
-- Rajoitteet taululle `subcategory`
--
ALTER TABLE `subcategory`
  ADD CONSTRAINT `subcategory_ibfk_1` FOREIGN KEY (`categoryID`) REFERENCES `category` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
