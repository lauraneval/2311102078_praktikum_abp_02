-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 31, 2026 at 02:16 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_kampus`
--

-- --------------------------------------------------------

--
-- Table structure for table `mahasiswa`
--

CREATE TABLE `mahasiswa` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `nim` varchar(20) NOT NULL,
  `nilai_tugas` float NOT NULL DEFAULT 0,
  `nilai_uts` float NOT NULL DEFAULT 0,
  `nilai_uas` float NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `mahasiswa`
--

INSERT INTO `mahasiswa` (`id`, `nama`, `nim`, `nilai_tugas`, `nilai_uts`, `nilai_uas`) VALUES
(1, 'Naufal Thoriq Muzhaffar', '2311102078', 88, 82, 90),
(2, 'Siti Rahmawati', '2311102045', 75, 68, 72),
(3, 'Budi Santoso', '2311102031', 55, 60, 50),
(4, 'Dewi Anggraini', '2311102012', 92, 95, 97),
(5, 'Rizky Firmansyah', '2311102067', 40, 45, 38),
(6, 'Rafi Aditya', '2311102101', 95, 60, 85),
(7, 'Nadia Safira', '2311102102', 70, 92, 88),
(8, 'Iqbal Ramadhan', '2311102103', 50, 55, 90),
(9, 'Ayu Lestari', '2311102104', 88, 40, 75),
(10, 'Farhan Akbar', '2311102105', 30, 35, 40),
(11, 'Siska Amelia', '2311102106', 85, 87, 20),
(12, 'Rizal Maulana', '2311102107', 60, 78, 82),
(13, 'Tania Putri', '2311102108', 92, 93, 50),
(14, 'Doni Kurniawan', '2311102109', 55, 45, 70),
(15, 'Mega Puspita', '2311102110', 78, 80, 79),
(16, 'Yusuf Hidayat', '2311102111', 65, 30, 60),
(17, 'Anisa Rahman', '2311102112', 90, 88, 91),
(18, 'Bayu Saputro', '2311102113', 40, 85, 75),
(19, 'Novi Andriani', '2311102114', 82, 83, 84),
(20, 'Galih Prasetyo', '2311102115', 58, 62, 20),
(21, 'Putra Firmansyah', '2311102116', 76, 77, 78),
(22, 'Della Kartika', '2311102117', 89, 60, 92),
(23, 'Reza Saputra', '2311102118', 45, 70, 65),
(24, 'Wulan Sari', '2311102119', 91, 92, 93),
(25, 'Kevin Anggara', '2311102120', 35, 40, 45);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nim` (`nim`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `mahasiswa`
--
ALTER TABLE `mahasiswa`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
