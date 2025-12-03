-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 03, 2025 at 08:25 AM
-- Server version: 10.4.22-MariaDB
-- PHP Version: 7.3.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `portal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `icon_path` text DEFAULT NULL,
  `executable_path` text NOT NULL,
  `border_color_hex` varchar(10) NOT NULL,
  `app_group` varchar(50) DEFAULT NULL,
  `display_order` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `applications`
--

INSERT INTO `applications` (`id`, `name`, `description`, `icon_path`, `executable_path`, `border_color_hex`, `app_group`, `display_order`) VALUES
(1, 'Ascend', 'ERP System', 'http://192.168.10.100:3300/icons/1755244417329-Ascend.png', 'C:\\SmartUpdate-Bin\\SmartUpdate2008.exe', '#D32F2F', '1_main', 0),
(2, 'Utama Server', 'UTAMA', 'http://192.168.10.100:3300/icons/1755266276670-pngwing.com (1).png', '\\\\192.168.10.100\\temp\\', '#BDBDBD', '1_utility', 0),
(3, 'Utama Server', 'UTAMA', 'http://192.168.10.100:3300/icons/1755266276670-pngwing.com (1).png', '\\\\192.168.10.100\\temp\\', '#BDBDBD', '2_utility', 0),
(4, 'Utama Server', 'UTAMA', 'http://192.168.10.100:3300/icons/1755266276670-pngwing.com (1).png', '\\\\192.168.10.100\\temp\\', '#BDBDBD', '3_utility', 0),
(5, 'Ascend', 'ERP System', 'http://192.168.10.100:3300/icons/1755244417329-Ascend.png', 'C:\\SmartUpdate-Bin\\SmartUpdate2008.exe', '#D32F2F', '2_main', 0),
(6, 'Ascend', 'ERP System', 'http://192.168.10.100:3300/icons/1755244417329-Ascend.png', 'C:\\SmartUpdate-Bin\\SmartUpdate2008.exe', '#D32F2F', '3_main', 0),
(7, 'Ascend', 'ERP System', 'http://192.168.10.100:3300/icons/1755244417329-Ascend.png', 'C:\\SmartUpdate-Bin\\SmartUpdate2008.exe', '#D32F2F', '4_main', 0),
(8, 'Utama Server', 'UTAMA', 'http://192.168.10.100:3300/icons/1755266276670-pngwing.com (1).png', '\\\\192.168.10.100\\temp\\', '#BDBDBD', '4_utility', 0),
(9, 'PPS', 'Plastic Production System', 'http://192.168.10.100:3300/icons/1755244437551-PPS.png', 'C:\\PPS\\PPS.exe', '#D32F2F', '1_main', 1),
(10, 'Chrome', 'Web Browser', 'http://192.168.10.100:3300/icons/1755244476845-Google_Chrome_icon_(February_2022).svg.png', 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe', '#BDBDBD', '1_utility', 1),
(11, 'Chrome', 'Web Browser', 'http://192.168.10.100:3300/icons/1755244476845-Google_Chrome_icon_(February_2022).svg.png', 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe', '#BDBDBD', '2_utility', 1),
(12, 'Chrome', 'Web Browser', 'http://192.168.10.100:3300/icons/1755244476845-Google_Chrome_icon_(February_2022).svg.png', 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe', '#BDBDBD', '3_utility', 1),
(13, 'PPS', 'Plastic Production System', 'http://192.168.10.100:3300/icons/1755244437551-PPS.png', 'C:\\PPS\\PPS.exe', '#D32F2F', '2_main', 1),
(14, 'PPS', 'Plastic Production System', 'http://192.168.10.100:3300/icons/1755244437551-PPS.png', 'C:\\PPS\\PPS.exe', '#D32F2F', '3_main', 1),
(15, 'PPS', 'Plastic Production System', 'http://192.168.10.100:3300/icons/1755244437551-PPS.png', 'C:\\PPS\\PPS.exe', '#D32F2F', '4_main', 1),
(16, 'Chrome', 'Web Browser', 'http://192.168.10.100:3300/icons/1755244476845-Google_Chrome_icon_(February_2022).svg.png', 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe', '#BDBDBD', '4_utility', 1),
(17, 'WPS', 'Wood Processing System', 'http://192.168.10.100:3300/icons/1755244426811-WPS.png', 'C:\\WPS\\WPS.exe', '#D32F2F', '4_main', 2),
(18, 'Excel', 'Microsoft Excel', 'http://192.168.10.100:3300/icons/1755266109460-pngwing.com (2).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE', '#BDBDBD', '1_utility', 2),
(19, 'Excel', 'Microsoft Excel', 'http://192.168.10.100:3300/icons/1755266109460-pngwing.com (2).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE', '#BDBDBD', '2_utility', 2),
(20, 'Excel', 'Microsoft Excel', 'http://192.168.10.100:3300/icons/1755266109460-pngwing.com (2).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE', '#BDBDBD', '3_utility', 2),
(21, 'WPS', 'Wood Processing System', 'http://192.168.10.100:3300/icons/1755244426811-WPS.png', 'C:\\WPS\\WPS.exe', '#D32F2F', '2_main', 2),
(22, 'WPS', 'Wood Processing System', 'http://192.168.10.100:3300/icons/1755244426811-WPS.png', 'C:\\WPS\\WPS.exe', '#D32F2F', '3_main', 2),
(23, 'WPS', 'Wood Processing System', 'http://192.168.10.100:3300/icons/1755244426811-WPS.png', 'C:\\WPS\\WPS.exe', '#D32F2F', '1_main', 2),
(24, 'Excel', 'Microsoft Excel', 'http://192.168.10.100:3300/icons/1755266109460-pngwing.com (2).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\EXCEL.EXE', '#BDBDBD', '4_utility', 2),
(25, 'UCS', 'Utama Corp System', 'http://192.168.10.100:3300/icons/1758680045956-UCS-25.png', 'C:\\ucs\\UCS.exe', '#D32F2F', '1_main', 3),
(26, 'Word', 'Microsoft Word', 'http://192.168.10.100:3300/icons/1755244486896-pngwing.com (4).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE', '#BDBDBD', '1_utility', 3),
(27, 'Word', 'Microsoft Word', 'http://192.168.10.100:3300/icons/1755244486896-pngwing.com (4).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE', '#BDBDBD', '2_utility', 3),
(28, 'Word', 'Microsoft Word', 'http://192.168.10.100:3300/icons/1755244486896-pngwing.com (4).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE', '#BDBDBD', '3_utility', 3),
(29, 'UCS', 'Utama Corp System', 'http://192.168.10.100:3300/icons/1758680045956-UCS-25.png', 'C:\\ucs\\UCS.exe', '#D32F2F', '2_main', 3),
(30, 'UCS', 'Utama Corp System', 'http://192.168.10.100:3300/icons/1758680045956-UCS-25.png', 'C:\\ucs\\UCS.exe', '#D32F2F', '3_main', 3),
(31, 'UCS', 'Utama Corp System', 'http://192.168.10.100:3300/icons/1758680045956-UCS-25.png', 'C:\\ucs\\UCS.exe', '#D32F2F', '4_main', 3),
(32, 'Word', 'Microsoft Word', 'http://192.168.10.100:3300/icons/1755244486896-pngwing.com (4).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\WINWORD.EXE', '#BDBDBD', '4_utility', 3),
(33, 'MCS', 'Maintenance Control System', 'http://192.168.10.100:3300/icons/1755244442533-MCS.png', 'http://192.168.10.100:8888/mcs', '#D32F2F', '1_main', 4),
(34, 'Power Point', 'Microsoft Power Point', 'http://192.168.10.100:3300/icons/1755853004389-pngwing.com (3).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE', '#BDBDBD', '1_utility', 4),
(35, 'Power Point', 'Microsoft Power Point', 'http://192.168.10.100:3300/icons/1755853004389-pngwing.com (3).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE', '#BDBDBD', '2_utility', 4),
(36, 'Power Point', 'Microsoft Power Point', 'http://192.168.10.100:3300/icons/1755853004389-pngwing.com (3).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE', '#BDBDBD', '3_utility', 4),
(37, 'MCS', 'Maintenance Control System', 'http://192.168.10.100:3300/icons/1755244442533-MCS.png', 'http://192.168.10.100:8888/mcs', '#D32F2F', '2_main', 4),
(38, 'MCS', 'Maintenance Control System', 'http://192.168.10.100:3300/icons/1755244442533-MCS.png', 'http://192.168.10.100:8888/mcs', '#D32F2F', '3_main', 4),
(39, 'MCS', 'Maintenance Control System', 'http://192.168.10.100:3300/icons/1755244442533-MCS.png', 'http://192.168.10.100:8888/mcs', '#D32F2F', '4_main', 4),
(40, 'Power Point', 'Microsoft Power Point', 'http://192.168.10.100:3300/icons/1755853004389-pngwing.com (3).png', 'C:\\Program Files\\Microsoft Office\\root\\Office16\\POWERPNT.EXE', '#BDBDBD', '4_utility', 4),
(41, 'UMS', 'Utama Memo System', 'http://192.168.10.100:3300/icons/1755244449623-UMS.png', 'http://192.168.10.100:8888/ums', '#D32F2F', '1_main', 5),
(42, 'Anydesk', 'anydesk', 'http://192.168.10.100:3300/icons/1755853151458-1200x630wa.png', 'C:\\Program Files (x86)\\AnyDesk\\AnyDesk.exe', '#BDBDBD', '1_utility', 5),
(43, 'Anydesk', 'anydesk', 'http://192.168.10.100:3300/icons/1755853151458-1200x630wa.png', 'C:\\Program Files (x86)\\AnyDesk\\AnyDesk.exe', '#BDBDBD', '2_utility', 5),
(44, 'Anydesk', 'anydesk', 'http://192.168.10.100:3300/icons/1755853151458-1200x630wa.png', 'C:\\Program Files (x86)\\AnyDesk\\AnyDesk.exe', '#BDBDBD', '3_utility', 5),
(45, 'UMS', 'Utama Memo System', 'http://192.168.10.100:3300/icons/1755244449623-UMS.png', 'http://192.168.10.100:8888/ums', '#D32F2F', '2_main', 5),
(46, 'UMS', 'Utama Memo System', 'http://192.168.10.100:3300/icons/1755244449623-UMS.png', 'http://192.168.10.100:8888/ums', '#D32F2F', '3_main', 5),
(47, 'UMS', 'Utama Memo System', 'http://192.168.10.100:3300/icons/1755244449623-UMS.png', 'http://192.168.10.100:8888/ums', '#D32F2F', '4_main', 5),
(48, 'Anydesk', 'anydesk', 'http://192.168.10.100:3300/icons/1755853151458-1200x630wa.png', 'C:\\Program Files (x86)\\AnyDesk\\AnyDesk.exe', '#BDBDBD', '4_utility', 5),
(49, 'UPM', 'Utama Project Management', 'http://192.168.10.100:3300/icons/1755244462727-UPM.png', 'http://192.168.9.20', '#D32F2F', '4_main', 6),
(50, 'Chat AI', 'ChatGPT', 'http://192.168.10.100:3300/icons/1755853248863-download.png', 'https://chatgpt.com/', '#BDBDBD', '4_utility', 6),
(51, 'Chat AI', 'ChatGPT', 'http://192.168.10.100:3300/icons/1755853248863-download.png', 'https://chatgpt.com/', '#BDBDBD', '2_utility', 6),
(52, 'Chat AI', 'ChatGPT', 'http://192.168.10.100:3300/icons/1755853248863-download.png', 'https://chatgpt.com/', '#BDBDBD', '3_utility', 6),
(53, 'UPM', 'Utama Project Management', 'http://192.168.10.100:3300/icons/1755244462727-UPM.png', 'http://192.168.9.20', '#D32F2F', '2_main', 6),
(54, 'UPM', 'Utama Project Management', 'http://192.168.10.100:3300/icons/1755244462727-UPM.png', 'http://192.168.9.20', '#D32F2F', '3_main', 6),
(55, 'Chat AI', 'ChatGPT', 'http://192.168.10.100:3300/icons/1755853248863-download.png', 'https://chatgpt.com/', '#BDBDBD', '1_utility', 6),
(56, 'UPM', 'Utama Project Management', 'http://192.168.10.100:3300/icons/1755244462727-UPM.png', 'http://192.168.9.20', '#D32F2F', '1_main', 6),
(57, 'HRIS', 'Human Resource Information system', 'http://192.168.10.100:3300/icons/1756434976329-Logo-24.png', 'http://192.168.10.100:8855/hris', '#D32F2F', '1_main', 7),
(58, 'zoom', 'zoom', 'http://192.168.10.100:3300/icons/1755853165635-image.png', 'C:\\Zoom\\bin\\Zoom.exe', '#BDBDBD', '1_utility', 7),
(59, 'zoom', 'zoom', 'http://192.168.10.100:3300/icons/1755853165635-image.png', 'C:\\Zoom\\bin\\Zoom.exe', '#BDBDBD', '2_utility', 7),
(60, 'zoom', 'zoom', 'http://192.168.10.100:3300/icons/1755853165635-image.png', 'C:\\Zoom\\bin\\Zoom.exe', '#BDBDBD', '3_utility', 7),
(61, 'HRIS', 'Human Resource Information system', 'http://192.168.10.100:3300/icons/1756434976329-Logo-24.png', 'http://192.168.10.100:8855/hris', '#D32F2F', '2_main', 7),
(62, 'HRIS', 'Human Resource Information system', 'http://192.168.10.100:3300/icons/1756434976329-Logo-24.png', 'http://192.168.10.100:8855/hris', '#D32F2F', '3_main', 7),
(63, 'HRIS', 'Human Resource Information system', 'http://192.168.10.100:3300/icons/1756434976329-Logo-24.png', 'http://192.168.10.100:8855/hris', '#D32F2F', '4_main', 7),
(64, 'BCA-Internet Banking', 'Transaksi Payment Corporate', 'http://192.168.10.100:3300/icons/1764642697560-bca.png', 'https://vpn.klikbca.com/+CSCOE+/logon.html', '#F3E5F5', '4_utility', 7),
(65, 'KPIM', 'Key Peformance Index Management', 'http://192.168.10.100:3300/icons/1755244454736-KPIM.png', 'http://192.168.10.100:8888/kpi', '#D32F2F', '1_main', 8),
(66, 'KPIM', 'Key Peformance Index Management', 'http://192.168.10.100:3300/icons/1755244454736-KPIM.png', 'http://192.168.10.100:8888/kpi', '#D32F2F', '2_main', 8),
(67, 'KPIM', 'Key Peformance Index Management', 'http://192.168.10.100:3300/icons/1755244454736-KPIM.png', 'http://192.168.10.100:8888/kpi', '#D32F2F', '3_main', 8),
(68, 'KPIM', 'Key Peformance Index Management', 'http://192.168.10.100:3300/icons/1755244454736-KPIM.png', 'http://192.168.10.100:8888/kpi', '#D32F2F', '4_main', 8),
(69, 'BRI', 'BRI-Internet Banking', 'http://192.168.10.100:3300/icons/1764642735788-Bri.png', 'https://bricams.bri.co.id/main-page', '#F3E5F5', '4_utility', 8),
(70, 'UDM', 'Utama Dashboard Monitoring', 'http://192.168.10.100:3300/icons/1763777130256-UDM.png', 'http://192.168.10.100:8855/udm/', '#D32F2F', '1_main', 9),
(71, 'UDM', 'Utama Dashboard Monitoring', 'http://192.168.10.100:3300/icons/1763777130256-UDM.png', 'http://192.168.10.100:8855/udm/', '#D32F2F', '2_main', 9),
(72, 'UDM', 'Utama Dashboard Monitoring', 'http://192.168.10.100:3300/icons/1763777130256-UDM.png', 'http://192.168.10.100:8855/udm/', '#D32F2F', '3_main', 9),
(73, 'UDM', 'Utama Dashboard Monitoring', 'http://192.168.10.100:3300/icons/1763777130256-UDM.png', 'http://192.168.10.100:8855/udm/', '#D32F2F', '4_main', 9),
(74, 'Mandiri', 'Mandiri-Transaction', 'http://192.168.10.100:3300/icons/1764642937238-mandiri.png', 'https://koprabymandiri.com/', '#F3E5F5', '4_utility', 9),
(75, 'zoom', 'zoom', 'http://192.168.10.100:3300/icons/1755853165635-image.png', 'C:\\Zoom\\bin\\Zoom.exe', '#BDBDBD', '4_utility', 10);

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `keyword` varchar(50) NOT NULL,
  `background_color` varchar(7) DEFAULT '#E3F2FD',
  `display_order` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `keyword`, `background_color`, `display_order`, `created_at`) VALUES
(1, 'Portal', 'portal', '#E3F2FD', 0, '2025-12-01 09:00:34'),
(2, 'Tax', 'tax', '#F3E5F5', 1, '2025-12-01 09:00:34'),
(3, 'Creative', 'creative', '#E8F5E9', 2, '2025-12-01 09:00:34'),
(4, 'Finance & Accounting', 'acct', '#F3E5F5', 3, '2025-12-01 09:32:18');

-- --------------------------------------------------------

--
-- Table structure for table `installations`
--

CREATE TABLE `installations` (
  `id` int(11) NOT NULL,
  `pc_id` varchar(255) NOT NULL,
  `first_seen_at` datetime DEFAULT NULL,
  `last_seen_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `installations`
--

INSERT INTO `installations` (`id`, `pc_id`, `first_seen_at`, `last_seen_at`) VALUES
(104, 'BSN12345678901234567', '2025-08-30 17:03:53', '2025-10-30 16:06:23'),
(107, 'f6c6b748-01ef-4cfa-88a8-7616153c04f9', '2025-08-31 21:58:49', '2025-08-31 21:58:49'),
(108, '9d3f9262-fa48-493b-92d0-e6540b95c10b', '2025-08-31 22:01:54', '2025-08-31 22:01:54'),
(109, 'a35a643e-ccff-49d7-abca-c2650a27c359', '2025-09-01 06:56:40', '2025-09-01 06:56:40'),
(110, '54B1BF00-EC1F-1015-BB99-9CF4EFDF36AF', '2025-09-01 06:56:58', '2025-12-03 01:01:44'),
(111, '6cb8a3f5-4d53-4098-9c16-3822dee26ccc', '2025-09-01 07:10:21', '2025-12-02 12:38:13'),
(112, '504b045a-e769-4664-969f-c8a929f0326c', '2025-09-01 07:10:55', '2025-09-02 06:58:42'),
(113, '508dedd3-61fd-4308-8033-2eae3620a694', '2025-09-01 07:11:15', '2025-09-02 16:04:07'),
(114, 'e0eb414e-fad4-4388-9b25-340a7fa61e3f', '2025-09-01 07:22:39', '2025-09-01 07:22:39'),
(115, '8C1CC0E3-D037-F891-4070-8E6791288C74', '2025-09-01 07:22:47', '2025-12-03 08:17:16'),
(116, '4c466d55-2f12-4c16-ab2a-4478e167d58f', '2025-09-01 07:47:22', '2025-09-01 07:47:22'),
(117, 'PGHNU0DCYAL3OU', '2025-09-01 07:47:32', '2025-12-03 14:19:46'),
(118, '8e2cf9f3-ed54-401b-842f-3e942e04b81c', '2025-09-01 07:51:41', '2025-09-01 07:51:41'),
(119, '470dbfc5-b379-449d-8bf1-49da17fec6f1', '2025-09-01 07:52:22', '2025-10-04 10:10:04'),
(120, 'bad89cd7-9b62-42dc-8740-88315ee64beb', '2025-09-01 07:57:25', '2025-09-01 07:57:25'),
(121, '84A25A5E-3068-748A-7EC2-3A14BEAC3C54', '2025-09-01 07:57:35', '2025-12-03 08:01:29'),
(122, 'fbfa8e7b-0d89-430d-b877-c5d9614447a9', '2025-09-01 07:57:37', '2025-09-01 07:57:37'),
(123, '8A56A92F-0000-F445-B642-ACF6624CC2BE', '2025-09-01 07:58:00', '2025-12-03 09:59:16'),
(124, '1bfddcf6-74aa-4367-85bf-06d099523c86', '2025-09-01 07:58:20', '2025-09-01 07:58:20'),
(125, 'B954FF80-F4E4-1015-9A91-BBB052AB26BB', '2025-09-01 07:59:12', '2025-12-03 08:00:47'),
(126, '9b81f60c-c3b3-42ae-a40e-d5c0d90fbe49', '2025-09-01 08:04:31', '2025-11-27 13:02:15'),
(127, '9371934f-7496-490b-9f58-30125658318e', '2025-09-01 08:08:44', '2025-12-01 08:14:20'),
(128, 'e813f26d-5185-4314-ae74-0c5c2dc77a6f', '2025-09-01 08:10:49', '2025-09-01 08:10:49'),
(129, 'PGHNU0CCYA783I', '2025-09-01 08:10:59', '2025-12-03 08:09:34'),
(130, 'ba5c1b5a-4b7f-4e61-ba1d-d2f9f5d8a726', '2025-09-01 08:11:17', '2025-12-03 08:13:29'),
(131, '6dc8a0bb-b6c4-4ef5-a46b-d3bbcd851f48', '2025-09-01 08:13:21', '2025-09-01 08:13:21'),
(132, '996D2F24-54EC-87ED-ADAD-C77A146DADED', '2025-09-01 08:13:38', '2025-12-03 09:32:48'),
(133, '57e78766-4297-4570-8c5d-d45fd11ab5fc', '2025-09-01 08:15:40', '2025-09-03 11:20:54'),
(134, 'cdcd0fe8-8710-40d3-905b-924a88d149fa', '2025-09-01 08:23:13', '2025-12-02 13:54:49'),
(135, 'e29472d6-6262-45a2-af09-f21df8b23935', '2025-09-01 08:23:59', '2025-12-02 13:58:08'),
(136, '14d9017b-ff3d-498d-88bd-3d69c4e006a5', '2025-09-01 08:24:44', '2025-11-26 08:24:29'),
(137, '08c81255-2a98-42d2-88d1-5e3096595f0e', '2025-09-01 08:25:00', '2025-09-01 08:25:00'),
(138, '6EE45A29-1561-A90E-D121-8A1D425DBDB3', '2025-09-01 08:25:28', '2025-12-03 08:35:28'),
(139, '73376045-0f9c-42ab-94b2-8e825bd944a7', '2025-09-01 08:28:25', '2025-09-01 08:54:07'),
(140, 'PGHNU0GCYBN5BX', '2025-09-01 08:33:41', '2025-12-03 07:29:55'),
(141, '9e120a84-9444-4c78-94bd-fe0f83e8a358', '2025-09-01 08:41:49', '2025-09-01 08:41:49'),
(142, '03B38ECD-892F-570F-BD33-BB986F737D65', '2025-09-01 08:42:08', '2025-12-03 08:56:04'),
(143, '43ce663a-483d-4da7-86f5-80d16f8d5309', '2025-09-01 08:54:12', '2025-12-03 10:12:00'),
(144, '85e70d7c-c859-40a6-b2de-eb5ec106137a', '2025-09-01 08:55:32', '2025-09-01 08:55:32'),
(145, 'ce00b015-cc9f-459f-9a11-4055ea3a97af', '2025-09-01 08:56:04', '2025-09-01 08:56:04'),
(146, 'PGHNU0GCYBN69P', '2025-09-01 08:56:32', '2025-12-03 09:17:37'),
(147, '907c6c5a-8cb0-48ab-b9ec-ec05d6c86148', '2025-09-01 08:57:49', '2025-09-02 13:50:51'),
(148, '3ABA6F53-8D73-C157-8763-3D98311CC53A', '2025-09-01 08:58:46', '2025-12-03 08:27:38'),
(149, 'bb77e73c-6f45-4bbe-81dc-bf90ebab8f53', '2025-09-01 09:06:21', '2025-09-16 14:47:51'),
(150, 'd635697d-f49c-4e07-9804-c05564f0e936', '2025-09-01 09:12:33', '2025-09-01 09:12:33'),
(151, '0B6CF0C6-CB35-DDDB-C707-61537943AD6B', '2025-09-01 09:13:01', '2025-12-03 07:59:51'),
(152, '3e200498-e232-4f47-b1cc-7f720ebe0f7d', '2025-09-01 09:47:35', '2025-12-03 08:18:39'),
(153, '55ff6b4a-298b-413e-93e7-a56caa9623e0', '2025-09-01 09:57:05', '2025-09-11 08:31:29'),
(154, '08eb62f9-184f-46dd-ab9c-394a7a4a631b', '2025-09-01 09:59:44', '2025-12-02 13:29:05'),
(155, 'e9833a50-e36a-442f-a2d1-eaf6b79da77d', '2025-09-01 10:01:28', '2025-09-01 10:01:28'),
(156, '5FB62080-EC1A-1015-85CA-9A4F14CB6E78', '2025-09-01 10:01:42', '2025-12-03 08:02:37'),
(157, '25c11a80-fdb4-4c84-a105-5f60e4bbaaf8', '2025-09-01 10:17:26', '2025-09-02 11:20:35'),
(158, '78629255-6907-4a3a-99e4-680ac8812b95', '2025-09-01 10:44:39', '2025-09-01 10:44:39'),
(159, 'FCF1C006-58F1-DC85-BA2F-A85068564232', '2025-09-01 10:44:50', '2025-12-03 08:41:08'),
(160, 'd1442421-09f3-46df-80c7-482dff594339', '2025-09-01 11:06:32', '2025-09-01 11:06:32'),
(161, '6825f426-5744-44d5-916e-4f3c82eb33fd', '2025-09-01 13:06:51', '2025-12-01 17:14:46'),
(162, '811bfe0c-a4a8-4ca0-980e-f627f6224c7a', '2025-09-01 13:08:23', '2025-10-04 08:16:18'),
(163, 'PGHNU0GCYBP9M7', '2025-09-01 17:08:49', '2025-12-02 10:25:56'),
(164, '70cc0154-5516-4f9e-bfe7-d16d8c7dd44c', '2025-09-02 08:05:48', '2025-09-10 08:36:26'),
(165, 'fb8f5dd1-5f23-43ed-8758-e9638a526430', '2025-09-02 08:10:45', '2025-09-02 08:10:45'),
(166, 'D3C06594-06DC-654B-E17F-217A9446B078', '2025-09-02 08:12:42', '2025-12-03 08:54:44'),
(167, 'B326346F-E22D-B526-FC22-9E4698BC13CE', '2025-09-02 08:33:58', '2025-12-03 03:16:04'),
(168, 'ca74b0c7-3379-4f21-b036-4835c0300ef0', '2025-09-02 09:52:49', '2025-09-04 09:46:11'),
(169, '84e38818-ce4b-4b0f-bc10-da3072c6b885', '2025-09-02 11:22:48', '2025-09-02 11:22:48'),
(170, 'PGHNU0CCYA660C', '2025-09-02 11:23:07', '2025-09-04 17:12:37'),
(171, '62ad9137-3993-4efb-adb1-fa8e363eb692', '2025-09-02 13:28:03', '2025-09-02 13:28:03'),
(172, 'PGHNU0CCYA688Q', '2025-09-02 13:28:15', '2025-11-29 11:15:45'),
(173, '5c5370b0-b168-4d8f-96c6-7479b4c5d5d9', '2025-09-02 13:58:50', '2025-09-02 13:58:50'),
(174, '890FC71A-4B73-6B77-B7EB-2F67531BA760', '2025-09-02 13:59:03', '2025-12-03 08:29:58'),
(175, 'e740fd4d-451f-4171-8b55-b9d6cad92f66', '2025-09-02 14:19:05', '2025-09-16 08:38:34'),
(176, '5010200d-8268-4f49-bdcb-d482cbd0f526', '2025-09-02 14:19:08', '2025-09-02 14:19:08'),
(177, '7c577a8e-1f33-46e5-85a2-bf6a8772c653', '2025-09-02 14:19:18', '2025-11-28 08:56:41'),
(178, 'Default string', '2025-09-02 14:19:20', '2025-10-25 12:06:07'),
(179, '80f16e38-53ff-4ed1-8808-8414bda51ed4', '2025-09-02 14:20:29', '2025-09-03 13:48:04'),
(180, '0a0648d7-ab3c-43b0-9a0b-505754541702', '2025-09-02 14:20:35', '2025-11-18 08:45:48'),
(181, '0e851c2e-c512-4b4b-88e8-36bd3d074041', '2025-09-02 14:24:16', '2025-09-03 13:49:55'),
(182, '2cd91f5c-5bcd-47c2-b246-b79d15f5790c', '2025-09-02 15:47:48', '2025-12-01 09:12:33'),
(184, 'ee595686-60b6-4f32-8795-84bd879f6ca4', '2025-09-02 15:50:44', '2025-09-02 15:51:20'),
(185, 'aec14471-5337-4c18-b820-ecbc38dbdb2b', '2025-09-02 15:52:48', '2025-09-02 15:53:11'),
(186, 'e0100264-a2bc-4e12-a40a-e970a2d16d5e', '2025-09-02 15:54:20', '2025-09-02 15:54:37'),
(187, '724dac86-439f-498f-bf34-86cd528fe5ca', '2025-09-02 16:03:23', '2025-09-02 16:03:23'),
(188, 'AD33FF5F-630B-534D-9FCC-6248FAC48F7D', '2025-09-02 16:03:40', '2025-12-02 15:11:09'),
(189, '34186cbc-03d7-4839-a086-cd671ac61ed3', '2025-09-02 16:04:05', '2025-09-02 16:04:23'),
(190, 'f819c263-077b-4940-893c-ed83d5361480', '2025-09-02 16:05:14', '2025-09-02 16:08:36'),
(191, 'AA702D5C-751B-EF6F-BB73-578B2F99D3F7', '2025-09-02 16:08:49', '2025-12-01 07:22:18'),
(192, '7faec695-73ed-427b-b129-0db8da05dd3a', '2025-09-02 16:11:43', '2025-09-02 16:11:43'),
(193, '637EC343-EB20-D336-AA77-598ED426F020', '2025-09-02 16:11:58', '2025-12-03 14:23:10'),
(194, '96B1F0A8-1B6E-B6B5-9784-C8BA59AF23E9', '2025-09-02 16:17:03', '2025-12-03 14:17:10'),
(195, '43942B80-98A6-1060-A8CE-E66F42C2CC5A', '2025-09-02 16:19:37', '2025-12-03 14:17:43'),
(196, '0343329F-8B63-076F-2F73-DAB6FF9FDBD7', '2025-09-03 07:48:23', '2025-12-01 09:54:55'),
(197, '39077c8e-fd36-42bb-9a7e-9b2538ed2965', '2025-09-03 08:52:48', '2025-09-08 08:04:40'),
(198, '303bd19b-cd07-47be-a289-231b58ce6241', '2025-09-03 13:52:45', '2025-09-03 13:52:45'),
(199, '7f68f003-b689-47b6-81cd-ab6cdff65a54', '2025-09-04 08:58:48', '2025-11-29 11:36:02'),
(200, 'ce63b20a-454e-4fcf-9702-5d0d3ddbe843', '2025-09-04 10:06:59', '2025-11-22 11:40:56'),
(201, 'PGHNU0GCYBN68D', '2025-09-08 08:37:56', '2025-11-29 14:32:56'),
(202, 'PGHNU0BCY7903D', '2025-09-08 08:53:03', '2025-11-28 11:09:11'),
(203, 'PGHNU0DCYALFO2', '2025-09-08 09:06:03', '2025-09-08 15:09:33'),
(204, 'E82E5BB4-6175-E2FF-70D2-47034A07C987', '2025-09-08 09:29:23', '2025-11-22 08:20:31'),
(205, '4ACB1D2F-9DB1-7DCB-6418-30D8FD4BCBE7', '2025-09-08 09:30:57', '2025-10-11 09:35:43'),
(206, '09d0637d-cafb-4683-90c4-f012ec3929de', '2025-09-08 10:33:56', '2025-09-08 10:33:56'),
(207, 'ACF82F1F-D278-92AC-ECC5-05522C9292EC', '2025-09-08 13:29:36', '2025-12-03 08:31:36'),
(208, '442B9213-3790-AADD-6A43-C44410441044', '2025-09-08 13:35:43', '2025-12-02 11:09:02'),
(209, 'C01872D2-77FC-D868-88CF-9000B088672F', '2025-09-08 13:36:44', '2025-12-03 08:11:41'),
(210, '4794D000-EC1F-1015-99CE-8EEA21E64A99', '2025-09-08 13:37:21', '2025-12-01 15:12:50'),
(211, '3C8B7100-EC1A-1015-B89A-ABBDA9F5CA17', '2025-09-08 13:41:25', '2025-11-12 10:45:34'),
(212, 'FF639CFC-9203-A745-B5CD-4E8C331F49B6', '2025-09-08 13:43:41', '2025-11-29 11:09:09'),
(213, 'PGHNU0GCYBN5H6', '2025-09-08 13:46:20', '2025-12-03 08:15:05'),
(214, 'PGHNU0GCYBP7EP', '2025-09-08 15:04:29', '2025-10-13 13:48:09'),
(215, 'C3D15D83-2664-0BD3-9D0A-449A33B8BCB2', '2025-09-08 15:16:27', '2025-12-02 11:46:34'),
(216, '22BF9BD0-1342-C7AF-CCD4-A567B1349C7B', '2025-09-08 15:21:22', '2025-12-03 09:42:19'),
(217, '65ed6c31-722a-488b-9414-e5ec9f3464a8', '2025-09-08 17:29:14', '2025-09-08 17:29:14'),
(218, '90823226-0A53-6A72-1E96-E306BA43A5F8', '2025-09-09 08:00:01', '2025-11-29 08:00:35'),
(219, 'PGHNU0DCYALE9C', '2025-09-09 08:25:06', '2025-11-24 16:05:40'),
(220, 'f1505ab3-bff1-46f6-af1d-47ffde0acd45', '2025-09-09 08:29:06', '2025-09-30 13:43:42'),
(221, 'SGH241QJ3M', '2025-09-11 08:48:19', '2025-12-03 10:27:56'),
(222, 'PGHNU0GCYBN79O', '2025-09-11 08:53:39', '2025-11-28 08:46:29'),
(223, 'SGH241QPHS', '2025-09-11 09:01:18', '2025-12-03 13:23:17'),
(224, 'PGHNU0GCYBPARZ', '2025-09-11 09:34:28', '2025-10-08 10:38:26'),
(225, 'A71B0301-9742-43FF-BF3B-938BF737832F', '2025-09-12 14:33:57', '2025-11-28 11:07:15'),
(226, 'b1d62111-69e9-41be-b241-4a2e76a7b0eb', '2025-09-12 15:32:00', '2025-11-26 11:51:25'),
(227, '50fd6021-ad1f-4266-9069-0a5be1b4603a', '2025-09-13 08:57:51', '2025-11-18 08:37:23'),
(228, '00ee4b55-03a7-4cc5-b7d9-2140a0029580', '2025-09-17 17:58:16', '2025-11-24 08:50:57'),
(229, '96c9b193-a669-423e-8e88-5e2739592a3a', '2025-09-18 07:29:31', '2025-10-23 09:10:32'),
(230, 'b8af7842-c73e-4b47-ab6f-2134213ce754', '2025-10-03 09:30:36', '2025-10-03 09:30:36'),
(231, 'ef2b78e8-2565-480f-99b8-8f006e506dac', '2025-10-03 15:37:52', '2025-10-03 15:37:52'),
(232, 'c7856a3f-586f-405e-8230-cf986f54c127', '2025-10-03 15:54:37', '2025-10-03 16:39:07'),
(233, '9281600f-09b5-48d5-9efd-b4c005a97dbe', '2025-10-03 18:00:13', '2025-10-03 18:00:13'),
(234, '4bb603a5-2f38-4c3b-a8d4-49bd32a4c08b', '2025-10-06 08:20:22', '2025-12-03 08:10:49'),
(235, '8bab2380-f1c1-4930-a736-b9ccf49db716', '2025-10-08 09:13:02', '2025-11-25 13:35:44'),
(236, 'PGHNU0GCYBN58U', '2025-10-08 12:45:00', '2025-11-04 16:55:34'),
(237, 'D3DBA880-F4E5-1015-8FF4-9E71A4ABB297', '2025-10-10 08:20:06', '2025-12-02 08:54:43'),
(238, '2AEFC890-D7C1-11DD-A154-862B25A00D00', '2025-10-11 12:15:07', '2025-10-12 12:50:39'),
(239, 'D6C16B2D-6D9A-496C-B08E-923760D0928C', '2025-10-11 16:45:39', '2025-10-12 13:00:38'),
(240, '45570234-7332-0B43-B482-468099AE701A', '2025-10-12 12:19:23', '2025-10-12 12:34:15'),
(241, '01DBAEC0-CC6F-11DF-9426-0024BED7B185', '2025-10-13 10:41:01', '2025-12-03 08:14:58'),
(242, '798cd57e-9f98-4763-99ff-d2620fb3c36e', '2025-10-14 19:05:25', '2025-10-14 19:05:25'),
(243, '8c1237e2-9d20-4e71-a145-852cbfe89df0', '2025-10-16 10:16:51', '2025-10-16 10:16:51'),
(244, '24b0e44d-d01a-40e7-92de-0da3c256017a', '2025-10-20 14:30:27', '2025-10-20 14:30:27'),
(245, 'e56144f2-b063-4a87-a2d8-5a2fbc753cc0', '2025-10-24 09:17:55', '2025-12-03 08:29:49'),
(246, 'a9b076eb-fed3-4996-bde3-96cf2f242ff5', '2025-10-25 12:23:16', '2025-10-25 12:23:16'),
(247, 'cab50c31-8032-4c30-aaa1-188d655a1397', '2025-10-31 10:46:57', '2025-10-31 10:46:57'),
(248, '5731e5fb-290a-4a91-81a3-309444c9d11e', '2025-11-01 14:25:23', '2025-11-27 13:26:55'),
(249, 'e20edeb7-4cd7-4ccb-8d3b-2b5e511faec9', '2025-11-03 09:50:46', '2025-11-03 14:19:46'),
(250, 'PGHNU0GCYBP5T9', '2025-11-04 13:07:54', '2025-11-10 14:55:56'),
(251, '1c392bd9-8053-44b2-9f4d-8d477af25978', '2025-11-05 08:14:00', '2025-11-05 08:14:00'),
(252, '017db02e-9fe0-4c5e-99a1-01baba0268f5', '2025-11-06 09:38:02', '2025-11-06 09:38:02'),
(253, 'c8bf1dc5-c8f7-4fda-8d0c-8fe67007b10c', '2025-11-10 15:12:01', '2025-11-19 13:43:07'),
(254, '67731fe1-95b8-414b-aec9-2fee8c65b6b8', '2025-11-17 09:12:10', '2025-11-17 09:12:10'),
(255, '68c282ab-a404-4db2-951b-80da9aaed0e0', '2025-11-20 14:11:57', '2025-11-20 14:11:57'),
(256, 'e1e04437-0e19-44aa-99f8-a60ba68491ef', '2025-11-21 09:10:38', '2025-11-21 09:10:38'),
(257, 'ba85057d-70a4-4556-9170-8ac7a1c393f9', '2025-11-21 09:19:18', '2025-11-21 09:46:11'),
(258, '232DBEF1-084D-C6ED-2738-9B976BEEBE4F', '2025-11-22 09:08:03', '2025-12-02 14:31:50'),
(259, '46df9728-3849-4a8a-b5fc-d9b22ef8d3e0', '2025-11-24 09:30:32', '2025-11-26 08:06:51'),
(260, 'BFEC8A00-78F4-1B77-D4DB-7E08F31C6610', '2025-11-27 16:26:05', '2025-12-03 08:43:29'),
(261, '340A24D4-325E-2E64-9894-8A00FE80F2D4', '2025-12-01 08:25:36', '2025-12-02 13:45:25'),
(262, '051CC480-EC1A-1015-B575-95F8EFC81603', '2025-12-02 09:09:44', '2025-12-03 10:12:21'),
(263, 'PGHNU0ECYAQ8CE', '2025-12-02 09:25:19', '2025-12-02 09:25:19'),
(264, 'F4429AAE-FEB7-F4D8-8289-F2FEA3F23C69', '2025-12-02 10:18:48', '2025-12-03 10:28:58'),
(265, 'AD613E72-3DE7-D509-3D09-D5FCD4119D0D', '2025-12-02 12:38:31', '2025-12-03 07:16:16'),
(266, 'PGHNU0DCYAL368', '2025-12-02 13:29:14', '2025-12-03 08:24:21'),
(267, 'AF410FAB-EF73-13C7-E5B2-E7DFB3CFCBF0', '2025-12-02 13:59:33', '2025-12-03 08:36:59'),
(268, 'EACF60CE-E9E2-2A6B-4AE5-DB360E994ECC', '2025-12-03 08:01:59', '2025-12-03 14:21:55'),
(269, 'BFF24F00-08B7-1016-9122-F23DDCD91ACA', '2025-12-03 08:11:48', '2025-12-03 08:11:48'),
(270, '17A3A28B-34FD-0500-B46C-29BAA69761F0', '2025-12-03 08:13:41', '2025-12-03 08:13:41'),
(271, 'DE932E9A-9CB8-5208-FC14-90C232AA047E', '2025-12-03 08:18:50', '2025-12-03 11:43:39'),
(272, 'PGHNU0DCYALF4J', '2025-12-03 09:12:07', '2025-12-03 09:12:07');

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `setting_key` varchar(50) NOT NULL,
  `setting_value` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`setting_key`, `setting_value`) VALUES
('admin_keyword', 'admin'),
('admin_password', '1234'),
('help_image_path', 'http://192.168.10.100:3300/help/1755779741597-LS - Oraet Labora.png'),
('help_keyword', 'tolong');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `keyword` (`keyword`);

--
-- Indexes for table `installations`
--
ALTER TABLE `installations`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pc_id` (`pc_id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`setting_key`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `applications`
--
ALTER TABLE `applications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `installations`
--
ALTER TABLE `installations`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=273;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
