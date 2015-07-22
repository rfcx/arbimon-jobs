begin;

-- phpMyAdmin SQL Dump
-- version 4.2.9
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 20, 2015 at 09:22 AM
-- Server version: 5.5.43-0ubuntu0.14.04.1
-- PHP Version: 5.5.9-1ubuntu4.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

--
-- Database: `arbimon2`
--

-- --------------------------------------------------------

--
-- Table structure for table `classification_results`
--

CREATE TABLE IF NOT EXISTS `classification_results` (
  `job_id` int(11) NOT NULL,
  `recording_id` int(11) NOT NULL,
  `species_id` int(11) NOT NULL,
  `songtype_id` int(11) NOT NULL,
  `present` tinyint(4) NOT NULL,
  `max_vector_value` float DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `classification_stats`
--

CREATE TABLE IF NOT EXISTS `classification_stats` (
  `job_id` int(11) NOT NULL,
  `json_stats` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `invalid_logins`
--

CREATE TABLE IF NOT EXISTS `invalid_logins` (
  `ip` varchar(40) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `user` varchar(32) NOT NULL,
  `reason` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `invalid_logins`
--

INSERT INTO `invalid_logins` (`ip`, `time`, `user`, `reason`) VALUES
('127.0.0.1', '2015-07-08 14:39:44', 'rafa', 'invalid_username');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE IF NOT EXISTS `jobs` (
`job_id` bigint(20) unsigned NOT NULL,
  `job_type_id` int(10) unsigned NOT NULL,
  `date_created` datetime NOT NULL,
  `last_update` datetime NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `uri` varchar(255) NOT NULL,
  `state` enum('waiting','initializing','ready','processing','completed','error','canceled','stalled') NOT NULL DEFAULT 'waiting',
  `cancel_requested` int(11) NOT NULL DEFAULT '0',
  `progress` double NOT NULL DEFAULT '0',
  `completed` tinyint(1) NOT NULL DEFAULT '0',
  `remarks` text NOT NULL,
  `progress_steps` int(11) NOT NULL DEFAULT '0',
  `hidden` tinyint(4) NOT NULL,
  `ncpu` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=907 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`job_id`, `job_type_id`, `date_created`, `last_update`, `project_id`, `user_id`, `uri`, `state`, `cancel_requested`, `progress`, `completed`, `remarks`, `progress_steps`, `hidden`, `ncpu`) VALUES
(891, 1, '2015-07-08 11:57:53', '2015-07-10 10:48:33', 33, 1, '', 'processing', 0, 62, 1, '', 77, 0, 0),
(892, 1, '2015-07-08 12:07:50', '2015-07-10 10:49:58', 33, 1, '', 'processing', 0, 7, 1, '', 77, 0, 0),
(893, 1, '2015-07-08 12:47:57', '2015-07-10 10:52:26', 33, 1, '', 'processing', 0, 7, 1, '', 77, 0, 0),
(894, 1, '2015-07-08 12:49:12', '2015-07-10 10:53:58', 33, 1, '', 'processing', 0, 7, 1, '', 77, 0, 0),
(895, 1, '2015-07-10 12:33:20', '2015-07-10 13:09:44', 33, 1, '', 'processing', 0, 6, 1, '', 136, 0, 0),
(896, 1, '2015-07-10 12:33:44', '2015-07-10 13:09:36', 33, 1, '', 'processing', 0, 6, 1, '', 136, 0, 0),
(897, 1, '2015-07-10 12:34:15', '2015-07-10 13:09:21', 33, 1, '', 'processing', 0, 6, 1, '', 136, 0, 0),
(898, 1, '2015-07-10 12:34:45', '2015-07-10 12:54:35', 33, 1, '', 'processing', 0, 121, 1, 'Error: cannot create training csvs files or access training data from db', 136, 0, 0),
(899, 1, '2015-07-10 13:25:05', '2015-07-10 13:35:33', 33, 1, '', 'processing', 0, 9, 1, '', 49, 0, 0),
(900, 1, '2015-07-10 13:25:23', '2015-07-10 13:35:12', 33, 1, '', 'processing', 0, 9, 1, '', 49, 0, 0),
(901, 1, '2015-07-10 13:25:40', '2015-07-10 13:35:04', 33, 1, '', 'processing', 0, 9, 1, '', 49, 0, 0),
(902, 1, '2015-07-10 13:26:02', '2015-07-10 13:29:43', 33, 1, '', 'processing', 0, 34, 1, 'Error: cannot create training csvs files or access training data from db', 49, 0, 0),
(903, 1, '2015-07-17 12:19:52', '2015-07-17 13:11:28', 33, 1, '', 'completed', 0, 61, 1, '', 61, 0, 0),
(904, 1, '2015-07-17 12:20:13', '2015-07-17 13:10:45', 33, 1, '', 'completed', 0, 61, 1, '', 61, 0, 0),
(905, 1, '2015-07-17 12:20:49', '2015-07-17 13:04:25', 33, 1, '', 'completed', 0, 61, 1, '', 61, 0, 0),
(906, 1, '2015-07-17 12:21:16', '2015-07-17 13:01:01', 33, 1, '', 'completed', 0, 54, 1, '', 54, 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `job_params_classification`
--

CREATE TABLE IF NOT EXISTS `job_params_classification` (
  `job_id` bigint(20) unsigned NOT NULL,
  `model_id` int(10) unsigned NOT NULL,
  `playlist_id` int(10) unsigned DEFAULT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `job_params_soundscape`
--

CREATE TABLE IF NOT EXISTS `job_params_soundscape` (
  `job_id` bigint(11) unsigned NOT NULL,
  `playlist_id` int(10) unsigned NOT NULL,
  `max_hertz` int(11) NOT NULL,
  `bin_size` int(11) NOT NULL,
  `soundscape_aggregation_type_id` int(10) unsigned NOT NULL,
  `name` text NOT NULL,
  `threshold` float NOT NULL DEFAULT '0',
  `frequency` int(11) NOT NULL DEFAULT '0',
  `normalize` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `job_params_training`
--

CREATE TABLE IF NOT EXISTS `job_params_training` (
  `job_id` bigint(20) unsigned NOT NULL,
  `model_type_id` int(10) unsigned NOT NULL,
  `training_set_id` bigint(20) unsigned NOT NULL,
  `validation_set_id` int(10) unsigned DEFAULT NULL,
  `trained_model_id` int(10) unsigned DEFAULT NULL,
  `use_in_training_present` int(11) NOT NULL,
  `use_in_training_notpresent` int(11) NOT NULL,
  `use_in_validation_present` int(11) NOT NULL,
  `use_in_validation_notpresent` int(11) NOT NULL,
  `name` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `job_params_training`
--

INSERT INTO `job_params_training` (`job_id`, `model_type_id`, `training_set_id`, `validation_set_id`, `trained_model_id`, `use_in_training_present`, `use_in_training_notpresent`, `use_in_validation_present`, `use_in_validation_notpresent`, `name`) VALUES
(891, 4, 129, 1263, 509, 5, 5, 25, 25, 'simple matchtemplate 1'),
(892, 1, 129, 1267, 506, 5, 5, 25, 25, 'simple slow 1'),
(893, 2, 129, 1268, 507, 5, 5, 25, 25, 'simple fast 1'),
(894, 3, 129, 1269, 508, 5, 5, 25, 25, 'simple search match 1'),
(895, 1, 130, 1275, 513, 5, 5, 55, 55, 'sp2 slow 1'),
(896, 2, 130, 1277, 512, 5, 5, 55, 55, 'sp2 fast 1'),
(897, 3, 130, 1276, 511, 5, 5, 55, 55, 'sp2 search match 1'),
(898, 4, 130, 1278, 510, 5, 5, 55, 55, 'sp2 matchtemplate 1'),
(899, 1, 133, 1288, 517, 5, 5, 10, 10, 'garbage slow 1'),
(900, 2, 133, 1287, 516, 5, 5, 10, 10, 'garbage fast 1'),
(901, 3, 133, 1286, 515, 5, 5, 10, 10, 'garbage search match 1'),
(902, 4, 133, 1284, 514, 5, 5, 10, 10, 'garbage matchtemplate 1'),
(903, 1, 134, 1293, 521, 10, 10, 9, 9, 'Eleutherodactylus cooki slow 1'),
(904, 2, 134, 1292, 520, 10, 10, 9, 9, 'Eleutherodactylus cooki fast 1'),
(905, 3, 134, 1291, 519, 10, 10, 9, 9, 'Eleutherodactylus cooki search match 1'),
(906, 4, 134, 1289, 518, 10, 10, 9, 9, 'Eleutherodactylus cooki matchtemplate 1');

-- --------------------------------------------------------

--
-- Table structure for table `job_queues`
--

CREATE TABLE IF NOT EXISTS `job_queues` (
`job_queue_id` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `host` varchar(256) NOT NULL,
  `platform` varchar(255) NOT NULL,
  `arch` varchar(255) NOT NULL,
  `cpus` int(11) NOT NULL,
  `freemem` int(11) NOT NULL,
  `heartbeat` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_alive` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `job_queue_enqueued_jobs`
--

CREATE TABLE IF NOT EXISTS `job_queue_enqueued_jobs` (
`enqueued_job_id` bigint(20) unsigned NOT NULL,
  `job_queue_id` int(11) NOT NULL,
  `job_id` bigint(20) unsigned NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `job_types`
--

CREATE TABLE IF NOT EXISTS `job_types` (
`job_type_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `enabled` int(11) NOT NULL,
  `script` varchar(255) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `job_types`
--

INSERT INTO `job_types` (`job_type_id`, `name`, `identifier`, `description`, `enabled`, `script`) VALUES
(1, 'Model training', 'training', 'Fitting of a model using training data. Model results are then validated using a validation data set.', 1, 'PatternMatching/train.py'),
(2, 'Model classification', 'classification', 'Classification of project data using a specified model and parameters.', 1, 'PatternMatching/classify.py'),
(3, 'Upload processing', 'audioprocess', 'Uploaded recordings to server are converted to flac and save', 0, ''),
(4, 'Soundscape analysis', 'peak-soundscape', 'The creation of a peak soundscape using a playlist, an aggregation function and a thershold or peak limiting value.', 1, 'Soundscapes/playlist2soundscape.py');

-- --------------------------------------------------------

--
-- Table structure for table `models`
--

CREATE TABLE IF NOT EXISTS `models` (
`model_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `model_type_id` int(10) unsigned NOT NULL,
  `uri` varchar(255) NOT NULL,
  `date_created` datetime NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `training_set_id` bigint(20) unsigned NOT NULL,
  `validation_set_id` int(11) NOT NULL,
  `deleted` tinyint(4) NOT NULL DEFAULT '0',
  `threshold` float DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=522 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `models`
--

INSERT INTO `models` (`model_id`, `name`, `model_type_id`, `uri`, `date_created`, `project_id`, `user_id`, `training_set_id`, `validation_set_id`, `deleted`, `threshold`) VALUES
(503, 'simple matchtemplate 1', 4, 'project_33/models/job_891_16771_1.mod', '2015-07-08 12:00:06', 33, 1, 129, 1242, 0, NULL),
(504, 'simple slow 1', 1, 'project_33/models/job_892_16771_1.mod', '2015-07-08 12:39:34', 33, 1, 129, 1245, 1, NULL),
(505, 'simple slow 1', 1, 'project_33/models/job_892_16771_1.mod', '2015-07-08 12:41:23', 33, 1, 129, 1245, 1, NULL),
(506, 'simple slow 1', 1, 'project_33/models/job_892_16771_1.mod', '2015-07-08 12:46:29', 33, 1, 129, 1245, 0, NULL),
(507, 'simple fast 1', 2, 'project_33/models/job_893_16771_1.mod', '2015-07-08 12:48:45', 33, 1, 129, 1254, 0, NULL),
(508, 'simple search match 1', 3, 'project_33/models/job_894_16771_1.mod', '2015-07-08 12:49:48', 33, 1, 129, 1255, 0, NULL),
(509, 'simple matchtemplate 1', 4, 'project_33/models/job_891_16771_1.mod', '2015-07-10 10:08:19', 33, 1, 129, 1256, 0, NULL),
(510, 'sp2 matchtemplate 1', 4, 'project_33/models/job_898_16772_1.mod', '2015-07-10 12:54:35', 33, 1, 130, 1270, 0, NULL),
(511, 'sp2 search match 1', 3, 'project_33/models/job_897_16772_1.mod', '2015-07-10 12:58:19', 33, 1, 130, 1271, 0, NULL),
(512, 'sp2 fast 1', 2, 'project_33/models/job_896_16772_1.mod', '2015-07-10 12:58:58', 33, 1, 130, 1273, 0, NULL),
(513, 'sp2 slow 1', 1, 'project_33/models/job_895_16772_1.mod', '2015-07-10 12:59:54', 33, 1, 130, 1274, 0, NULL),
(514, 'garbage matchtemplate 1', 4, 'project_33/models/job_902_16774_1.mod', '2015-07-10 13:29:43', 33, 1, 133, 1279, 0, NULL),
(515, 'garbage search match 1', 3, 'project_33/models/job_901_16774_1.mod', '2015-07-10 13:30:44', 33, 1, 133, 1280, 0, NULL),
(516, 'garbage fast 1', 2, 'project_33/models/job_900_16774_1.mod', '2015-07-10 13:30:59', 33, 1, 133, 1282, 0, NULL),
(517, 'garbage slow 1', 1, 'project_33/models/job_899_16774_1.mod', '2015-07-10 13:31:24', 33, 1, 133, 1283, 0, NULL),
(518, 'Eleutherodactylus cooki matchtemplate 1', 4, 'project_33/models/job_906_16775_1.mod', '2015-07-17 13:01:01', 33, 1, 134, 1289, 0, NULL),
(519, 'Eleutherodactylus cooki search match 1', 3, 'project_33/models/job_905_16775_1.mod', '2015-07-17 13:04:25', 33, 1, 134, 1290, 0, NULL),
(520, 'Eleutherodactylus cooki fast 1', 2, 'project_33/models/job_904_16775_1.mod', '2015-07-17 13:10:45', 33, 1, 134, 1292, 0, NULL),
(521, 'Eleutherodactylus cooki slow 1', 1, 'project_33/models/job_903_16775_1.mod', '2015-07-17 13:11:28', 33, 1, 134, 1293, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `model_classes`
--

CREATE TABLE IF NOT EXISTS `model_classes` (
  `model_id` int(10) unsigned NOT NULL,
  `species_id` int(10) NOT NULL,
  `songtype_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `model_classes`
--

INSERT INTO `model_classes` (`model_id`, `species_id`, `songtype_id`) VALUES
(503, 16771, 1),
(504, 16771, 1),
(505, 16771, 1),
(506, 16771, 1),
(507, 16771, 1),
(508, 16771, 1),
(509, 16771, 1),
(510, 16772, 1),
(511, 16772, 1),
(512, 16772, 1),
(513, 16772, 1),
(514, 16774, 1),
(515, 16774, 1),
(516, 16774, 1),
(517, 16774, 1),
(518, 16775, 1),
(519, 16775, 1),
(520, 16775, 1),
(521, 16775, 1);

-- --------------------------------------------------------

--
-- Table structure for table `model_stats`
--

CREATE TABLE IF NOT EXISTS `model_stats` (
  `model_id` int(10) unsigned NOT NULL,
  `json_stats` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `model_stats`
--

INSERT INTO `model_stats` (`model_id`, `json_stats`) VALUES
(503, '{"roicount":2 , "roilength":0.442307692308 , "roilowfreq":5319.07894737 , "roihighfreq":8542.76315789,"accuracy":1.0 ,"precision":1.0,"sensitivity":1.0, "forestoobscore" :1.0 , "roisamplerate" : 44100.0 , "roipng":"project_33/models/job_891_16771_1.png", "specificity":1.0 , "tp":25.0 , "fp":0.0 , "tn":25.0 , "fn":0.0 , "minv": -0.132160335779, "maxv": 1647.0}'),
(504, '{"roicount":2 , "roilength":0.442307692308 , "roilowfreq":5319.07894737 , "roihighfreq":8542.76315789,"accuracy":0.961538461538 ,"precision":0.0,"sensitivity":0.0, "forestoobscore" :0.833333333333 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_892_16771_1.png", "specificity":1.0 , "tp":0.0 , "fp":0.0 , "tn":25.0 , "fn":1.0 , "minv": -8.57202762075e-22, "maxv": 1719.0}'),
(505, '{"roicount":2 , "roilength":0.442307692308 , "roilowfreq":5319.07894737 , "roihighfreq":8542.76315789,"accuracy":0.96 ,"precision":1.0,"sensitivity":0.92, "forestoobscore" :0.9 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_892_16771_1.png", "specificity":1.0 , "tp":23.0 , "fp":0.0 , "tn":25.0 , "fn":2.0 , "minv": -1.42144951699e-21, "maxv": 1719.0}'),
(506, '{"roicount":2 , "roilength":0.442307692308 , "roilowfreq":5319.07894737 , "roihighfreq":8542.76315789,"accuracy":1.0 ,"precision":1.0,"sensitivity":1.0, "forestoobscore" :1.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_892_16771_1.png", "specificity":1.0 , "tp":25.0 , "fp":0.0 , "tn":25.0 , "fn":0.0 , "minv": 0.0, "maxv": 1719.0}'),
(507, '{"roicount":2 , "roilength":0.442307692308 , "roilowfreq":5319.07894737 , "roihighfreq":8542.76315789,"accuracy":1.0 ,"precision":1.0,"sensitivity":1.0, "forestoobscore" :1.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_893_16771_1.png", "specificity":1.0 , "tp":25.0 , "fp":0.0 , "tn":25.0 , "fn":0.0 , "minv": -1.67043202794e+20, "maxv": 4.17777210746e+22}'),
(508, '{"roicount":2 , "roilength":0.442307692308 , "roilowfreq":5319.07894737 , "roihighfreq":8542.76315789,"accuracy":1.0 ,"precision":1.0,"sensitivity":1.0, "forestoobscore" :1.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_894_16771_1.png", "specificity":1.0 , "tp":25.0 , "fp":0.0 , "tn":25.0 , "fn":0.0 , "minv": 0.0, "maxv": 1719.0}'),
(509, '{"roicount":2 , "roilength":0.442307692308 , "roilowfreq":5319.07894737 , "roihighfreq":8542.76315789,"accuracy":1.0 ,"precision":1.0,"sensitivity":1.0, "forestoobscore" :1.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_891_16771_1.png", "specificity":1.0 , "tp":25.0 , "fp":0.0 , "tn":25.0 , "fn":0.0 , "minv": -0.109293915331, "maxv": 1645.0}'),
(510, '{"roicount":1 , "roilength":0.578431372549 , "roilowfreq":545.792079208 , "roihighfreq":2547.02970297,"accuracy":1.0 ,"precision":1.0,"sensitivity":1.0, "forestoobscore" :1.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_898_16772_1.png", "specificity":1.0 , "tp":54.0 , "fp":0.0 , "tn":55.0 , "fn":0.0 , "minv": -0.490993734037, "maxv": 1622.0}'),
(511, '{"roicount":1 , "roilength":0.578431372549 , "roilowfreq":545.792079208 , "roihighfreq":2547.02970297,"accuracy":0.981818181818 ,"precision":1.0,"sensitivity":0.963636363636, "forestoobscore" :1.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_897_16772_1.png", "specificity":1.0 , "tp":53.0 , "fp":0.0 , "tn":55.0 , "fn":2.0 , "minv": 0.0, "maxv": 1719.0}'),
(512, '{"roicount":1 , "roilength":0.578431372549 , "roilowfreq":545.792079208 , "roihighfreq":2547.02970297,"accuracy":1.0 ,"precision":1.0,"sensitivity":1.0, "forestoobscore" :1.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_896_16772_1.png", "specificity":1.0 , "tp":55.0 , "fp":0.0 , "tn":55.0 , "fn":0.0 , "minv": -4.81228303899e+16, "maxv": 4.72251767737e+18}'),
(513, '{"roicount":1 , "roilength":0.578431372549 , "roilowfreq":545.792079208 , "roihighfreq":2547.02970297,"accuracy":1.0 ,"precision":1.0,"sensitivity":1.0, "forestoobscore" :1.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_895_16772_1.png", "specificity":1.0 , "tp":55.0 , "fp":0.0 , "tn":55.0 , "fn":0.0 , "minv": 0.0, "maxv": 1719.0}'),
(514, '{"roicount":4 , "roilength":0.480392156863 , "roilowfreq":2001.23762376 , "roihighfreq":4148.01980198,"accuracy":0.5 ,"precision":0.0,"sensitivity":0.0, "forestoobscore" :0.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_902_16774_1.png", "specificity":1.0 , "tp":0.0 , "fp":0.0 , "tn":10.0 , "fn":10.0 , "minv": -0.00108243641444, "maxv": 1646.0}'),
(515, '{"roicount":4 , "roilength":0.480392156863 , "roilowfreq":2001.23762376 , "roihighfreq":4148.01980198,"accuracy":0.5 ,"precision":0.5,"sensitivity":1.0, "forestoobscore" :0.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_901_16774_1.png", "specificity":0.0 , "tp":10.0 , "fp":10.0 , "tn":0.0 , "fn":0.0 , "minv": 0.0, "maxv": 1719.0}'),
(516, '{"roicount":4 , "roilength":0.480392156863 , "roilowfreq":2001.23762376 , "roihighfreq":4148.01980198,"accuracy":0.5 ,"precision":0.0,"sensitivity":0.0, "forestoobscore" :0.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_900_16774_1.png", "specificity":1.0 , "tp":0.0 , "fp":0.0 , "tn":10.0 , "fn":10.0 , "minv": -1.02496331016e+15, "maxv": 6.76624420614e+16}'),
(517, '{"roicount":4 , "roilength":0.480392156863 , "roilowfreq":2001.23762376 , "roihighfreq":4148.01980198,"accuracy":0.5 ,"precision":0.0,"sensitivity":0.0, "forestoobscore" :0.0 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_899_16774_1.png", "specificity":1.0 , "tp":0.0 , "fp":0.0 , "tn":10.0 , "fn":10.0 , "minv": 0.0, "maxv": 1719.0}'),
(518, '{"roicount":1 , "roilength":0.858321751216 , "roilowfreq":1488.03680982 , "roihighfreq":1893.86503067,"accuracy":0.888888888889 ,"precision":1.0,"sensitivity":0.777777777778, "forestoobscore" :0.85 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_906_16775_1.png", "specificity":1.0 , "tp":7.0 , "fp":0.0 , "tn":9.0 , "fn":2.0 , "minv": -0.319357987747, "maxv": 2556.0}'),
(519, '{"roicount":1 , "roilength":0.858321751216 , "roilowfreq":1488.03680982 , "roihighfreq":1893.86503067,"accuracy":0.944444444444 ,"precision":1.0,"sensitivity":0.888888888889, "forestoobscore" :0.95 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_905_16775_1.png", "specificity":1.0 , "tp":8.0 , "fp":0.0 , "tn":9.0 , "fn":1.0 , "minv": 0.0, "maxv": 2590.0}'),
(520, '{"roicount":1 , "roilength":0.858321751216 , "roilowfreq":1488.03680982 , "roihighfreq":1893.86503067,"accuracy":0.888888888889 ,"precision":1.0,"sensitivity":0.777777777778, "forestoobscore" :0.95 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_904_16775_1.png", "specificity":1.0 , "tp":7.0 , "fp":0.0 , "tn":9.0 , "fn":2.0 , "minv": -1.1755858052e+18, "maxv": 1.93086895105e+20}'),
(521, '{"roicount":1 , "roilength":0.858321751216 , "roilowfreq":1488.03680982 , "roihighfreq":1893.86503067,"accuracy":0.777777777778 ,"precision":0.857142857143,"sensitivity":0.666666666667, "forestoobscore" :0.95 , "roisamplerate" : 48000.0 , "roipng":"project_33/models/job_903_16775_1.png", "specificity":0.888888888889 , "tp":6.0 , "fp":1.0 , "tn":8.0 , "fn":3.0 , "minv": -0.368180705642, "maxv": 2590.0}');

-- --------------------------------------------------------

--
-- Table structure for table `model_types`
--

CREATE TABLE IF NOT EXISTS `model_types` (
`model_type_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `training_set_type_id` int(10) unsigned NOT NULL,
  `usesSsim` tinyint(4) NOT NULL DEFAULT '0',
  `usesRansac` tinyint(1) NOT NULL DEFAULT '0',
  `enabled` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `model_types`
--

INSERT INTO `model_types` (`model_type_id`, `name`, `description`, `training_set_type_id`, `usesSsim`, `usesRansac`, `enabled`) VALUES
(1, 'Pattern Matching (slow)', 'Pattern Matching using ROIs. Matrix comparisons computed using SSIM (Structural similarity index).', 1, 1, 0, 1),
(2, 'Pattern Matching (fast)', 'Pattern Matching using ROIs. Matrix comparisons computed using matrix norms.', 1, 0, 0, 1),
(3, 'Search and Match', 'Pattern Matching using ROIs. Search interesting areas and compute matrix comparisons using SSIM (Structural similarity index).', 1, 0, 1, 1),
(4, 'Pattern Matching', 'Pattern Matching', 1, 0, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE IF NOT EXISTS `permissions` (
`permission_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `security_level` int(10) unsigned NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `permissions`
--

INSERT INTO `permissions` (`permission_id`, `name`, `description`, `security_level`) VALUES
(1, 'view project', 'user can view project execept settings, user access and billing sections', 0),
(2, 'delete project', 'user can delete a project from system, this permission is only available to the project owner', 0),
(4, 'manage project billing', 'user can view and edit project billing info', 0),
(5, 'manage project settings', 'user can edit project info, settings and user access', 0),
(6, 'manage project sites', 'user can view edit and remove sites from project', 0),
(7, 'manage project species', 'user can add and remove species from project species list', 0),
(8, 'manage playlists', 'user can edit and delete project playlists', 0),
(9, 'manage project recordings', 'user can upload, edit and remove recordings', 0),
(10, 'manage project jobs', 'user can view jobs and cancel them', 0),
(11, 'validate species', 'user can validate species in project recordings', 0),
(12, 'invalidate species', 'user can invalidate species from project recordings validated by other users', 0),
(13, 'manage models and classification', 'user can create, edit and run models', 0),
(14, 'manage validation sets', 'user can create, edit and delete validation sets', 0),
(15, 'manage training sets', 'user can create, edit and delete training sets', 0),
(16, 'manage soundscapes', 'user can create and work with soundscapes', 0);

-- --------------------------------------------------------

--
-- Table structure for table `playlists`
--

CREATE TABLE IF NOT EXISTS `playlists` (
`playlist_id` int(10) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `playlist_type_id` int(10) unsigned NOT NULL,
  `uri` varchar(255) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=432 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `playlists`
--

INSERT INTO `playlists` (`playlist_id`, `project_id`, `name`, `playlist_type_id`, `uri`) VALUES
(424, 33, 'simple', 1, NULL),
(425, 33, 'sp2', 1, NULL),
(426, 33, 'sp3', 1, NULL),
(427, 33, 'sp2_3', 1, NULL),
(428, 33, 'garbage', 1, NULL),
(429, 33, 'Eleutherodactylus cooki', 1, NULL),
(430, 33, 'Epinephelus guttatus', 1, NULL),
(431, 33, 'Percnostola lophotes', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `playlist_recordings`
--

CREATE TABLE IF NOT EXISTS `playlist_recordings` (
  `playlist_id` int(10) unsigned NOT NULL,
  `recording_id` bigint(20) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `playlist_recordings`
--

INSERT INTO `playlist_recordings` (`playlist_id`, `recording_id`) VALUES
(424, 10096632),
(424, 10096633),
(424, 10096634),
(424, 10096635),
(424, 10096636),
(424, 10096637),
(424, 10096638),
(424, 10096639),
(424, 10096640),
(424, 10096641),
(424, 10096642),
(424, 10096643),
(424, 10096644),
(424, 10096645),
(424, 10096646),
(424, 10096647),
(424, 10096648),
(424, 10096649),
(424, 10096650),
(424, 10096651),
(424, 10096652),
(424, 10096653),
(424, 10096654),
(424, 10096655),
(424, 10096656),
(424, 10096657),
(424, 10096658),
(424, 10096659),
(424, 10096660),
(424, 10096661),
(424, 10096662),
(424, 10096663),
(424, 10096664),
(424, 10096665),
(424, 10096666),
(424, 10096667),
(424, 10096668),
(424, 10096669),
(424, 10096670),
(424, 10096671),
(424, 10096672),
(424, 10096673),
(424, 10096674),
(424, 10096675),
(424, 10096676),
(424, 10096677),
(424, 10096678),
(424, 10096679),
(424, 10096680),
(424, 10096681),
(424, 10096682),
(424, 10096683),
(424, 10096684),
(424, 10096685),
(424, 10096686),
(424, 10096687),
(424, 10096688),
(424, 10096689),
(424, 10096690),
(424, 10096691),
(425, 10096692),
(425, 10096693),
(425, 10096694),
(425, 10096695),
(425, 10096696),
(425, 10096697),
(425, 10096698),
(425, 10096699),
(425, 10096700),
(425, 10096701),
(425, 10096702),
(425, 10096703),
(425, 10096704),
(425, 10096705),
(425, 10096706),
(425, 10096707),
(425, 10096708),
(425, 10096709),
(425, 10096710),
(425, 10096711),
(425, 10096712),
(425, 10096713),
(425, 10096714),
(425, 10096715),
(425, 10096716),
(425, 10096717),
(425, 10096718),
(425, 10096719),
(425, 10096720),
(425, 10096721),
(425, 10096722),
(425, 10096723),
(425, 10096724),
(425, 10096725),
(425, 10096726),
(425, 10096727),
(425, 10096728),
(425, 10096729),
(425, 10096730),
(425, 10096731),
(425, 10096732),
(425, 10096733),
(425, 10096734),
(425, 10096735),
(425, 10096736),
(425, 10096737),
(425, 10096738),
(425, 10096739),
(425, 10096740),
(425, 10096741),
(425, 10096742),
(425, 10096743),
(425, 10096744),
(425, 10096745),
(425, 10096746),
(425, 10096747),
(425, 10096748),
(425, 10096749),
(425, 10096750),
(425, 10096751),
(426, 10096752),
(426, 10096753),
(426, 10096754),
(426, 10096755),
(426, 10096756),
(426, 10096757),
(426, 10096758),
(426, 10096759),
(426, 10096760),
(426, 10096761),
(426, 10096762),
(426, 10096763),
(426, 10096764),
(426, 10096765),
(426, 10096766),
(426, 10096767),
(426, 10096768),
(426, 10096769),
(426, 10096770),
(426, 10096771),
(426, 10096772),
(426, 10096773),
(426, 10096774),
(426, 10096775),
(426, 10096776),
(426, 10096777),
(426, 10096778),
(426, 10096779),
(426, 10096780),
(426, 10096781),
(426, 10096782),
(426, 10096783),
(426, 10096784),
(426, 10096785),
(426, 10096786),
(426, 10096787),
(426, 10096788),
(426, 10096789),
(426, 10096790),
(426, 10096791),
(426, 10096792),
(426, 10096793),
(426, 10096794),
(426, 10096795),
(426, 10096796),
(426, 10096797),
(426, 10096798),
(426, 10096799),
(426, 10096800),
(426, 10096801),
(426, 10096802),
(426, 10096803),
(426, 10096804),
(426, 10096805),
(426, 10096806),
(426, 10096807),
(426, 10096808),
(426, 10096809),
(426, 10096810),
(426, 10096811),
(427, 10096812),
(427, 10096813),
(427, 10096814),
(427, 10096815),
(427, 10096816),
(427, 10096817),
(427, 10096818),
(427, 10096819),
(427, 10096820),
(427, 10096821),
(427, 10096822),
(427, 10096823),
(427, 10096824),
(427, 10096825),
(427, 10096826),
(427, 10096827),
(427, 10096828),
(427, 10096829),
(427, 10096830),
(427, 10096831),
(427, 10096832),
(427, 10096833),
(427, 10096834),
(427, 10096835),
(427, 10096836),
(427, 10096837),
(427, 10096838),
(427, 10096839),
(427, 10096840),
(427, 10096841),
(427, 10096842),
(427, 10096843),
(427, 10096844),
(427, 10096845),
(427, 10096846),
(427, 10096847),
(427, 10096848),
(427, 10096849),
(427, 10096850),
(427, 10096851),
(427, 10096852),
(427, 10096853),
(427, 10096854),
(427, 10096855),
(427, 10096856),
(427, 10096857),
(427, 10096858),
(427, 10096859),
(427, 10096860),
(427, 10096861),
(427, 10096862),
(427, 10096863),
(427, 10096864),
(427, 10096865),
(427, 10096866),
(427, 10096867),
(427, 10096868),
(427, 10096869),
(427, 10096870),
(427, 10096871),
(428, 10096872),
(428, 10096873),
(428, 10096874),
(428, 10096875),
(428, 10096876),
(428, 10096877),
(428, 10096878),
(428, 10096879),
(428, 10096880),
(428, 10096881),
(428, 10096882),
(428, 10096883),
(428, 10096884),
(428, 10096885),
(428, 10096886),
(428, 10096887),
(428, 10096888),
(428, 10096889),
(428, 10096890),
(428, 10096891),
(428, 10096892),
(428, 10096893),
(428, 10096894),
(428, 10096895),
(428, 10096896),
(428, 10096897),
(428, 10096898),
(428, 10096899),
(428, 10096900),
(428, 10096901),
(429, 10096902),
(429, 10096903),
(429, 10096904),
(429, 10096905),
(429, 10096906),
(429, 10096907),
(429, 10096908),
(429, 10096909),
(429, 10096910),
(429, 10096911),
(429, 10096912),
(429, 10096913),
(429, 10096914),
(429, 10096915),
(429, 10096916),
(429, 10096917),
(429, 10096918),
(429, 10096919),
(429, 10096920),
(429, 10096921),
(429, 10096922),
(429, 10096923),
(429, 10096924),
(429, 10096925),
(429, 10096926),
(429, 10096927),
(429, 10096928),
(429, 10096929),
(429, 10096930),
(429, 10096931),
(429, 10096932),
(429, 10096933),
(429, 10096934),
(429, 10096935),
(429, 10096936),
(429, 10096937),
(429, 10096938),
(429, 10096939),
(429, 10096940),
(429, 10096941),
(429, 10096942),
(429, 10096943),
(429, 10096944),
(429, 10096945),
(429, 10096946),
(430, 10096947),
(430, 10096948),
(430, 10096949),
(430, 10096950),
(430, 10096951),
(430, 10096952),
(430, 10096953),
(430, 10096954),
(430, 10096955),
(430, 10096956),
(430, 10096957),
(430, 10096958),
(430, 10096959),
(430, 10096960),
(430, 10096961),
(430, 10096962),
(430, 10096963),
(430, 10096964),
(430, 10096965),
(430, 10096966),
(430, 10096967),
(430, 10096968),
(430, 10096969),
(430, 10096970),
(430, 10096971),
(430, 10096972),
(430, 10096973),
(430, 10096974),
(430, 10096975),
(430, 10096976),
(430, 10096977),
(430, 10096978),
(430, 10096979),
(430, 10096980),
(430, 10096981),
(430, 10096982),
(430, 10096983),
(430, 10096984),
(430, 10096985),
(430, 10096986),
(430, 10096987),
(430, 10096988),
(430, 10096989),
(430, 10096990),
(430, 10096991),
(430, 10096992),
(430, 10096993),
(430, 10096994),
(430, 10096995),
(430, 10096996),
(430, 10096997),
(430, 10096998),
(430, 10096999),
(430, 10097000),
(430, 10097001),
(430, 10097002),
(430, 10097003),
(430, 10097004),
(430, 10097005),
(430, 10097006),
(430, 10097007),
(430, 10097008),
(430, 10097009),
(430, 10097010),
(430, 10097011),
(430, 10097012),
(430, 10097013),
(430, 10097014),
(430, 10097015),
(430, 10097016),
(430, 10097017),
(430, 10097018),
(430, 10097019),
(430, 10097020),
(430, 10097021),
(430, 10097022),
(430, 10097023),
(430, 10097024),
(430, 10097025),
(430, 10097026),
(430, 10097027),
(430, 10097028),
(430, 10097029),
(430, 10097030),
(430, 10097031),
(430, 10097032),
(430, 10097033),
(430, 10097034),
(430, 10097035),
(430, 10097036),
(430, 10097037),
(430, 10097038),
(430, 10097039),
(430, 10097040),
(430, 10097041),
(430, 10097042),
(430, 10097043),
(430, 10097044),
(430, 10097045),
(430, 10097046),
(430, 10097047),
(430, 10097048),
(430, 10097049),
(430, 10097050),
(430, 10097051),
(430, 10097052),
(430, 10097053),
(430, 10097054),
(430, 10097055),
(430, 10097056),
(430, 10097057),
(430, 10097058),
(430, 10097059),
(430, 10097060),
(430, 10097061),
(430, 10097062),
(430, 10097063),
(430, 10097064),
(430, 10097065),
(430, 10097066),
(430, 10097067),
(430, 10097068),
(430, 10097069),
(430, 10097070),
(430, 10097071),
(430, 10097072),
(430, 10097073),
(430, 10097074),
(430, 10097075),
(430, 10097076),
(430, 10097077),
(430, 10097078),
(430, 10097079),
(430, 10097080),
(430, 10097081),
(430, 10097082),
(430, 10097083),
(430, 10097084),
(430, 10097085),
(430, 10097086),
(430, 10097087),
(430, 10097088),
(430, 10097089),
(430, 10097090),
(430, 10097091),
(430, 10097092),
(430, 10097093),
(430, 10097094),
(430, 10097095),
(430, 10097096),
(430, 10097097),
(430, 10097098),
(431, 10097099),
(431, 10097100),
(431, 10097101),
(431, 10097102),
(431, 10097103),
(431, 10097104),
(431, 10097105),
(431, 10097106),
(431, 10097107),
(431, 10097108),
(431, 10097109),
(431, 10097110),
(431, 10097111),
(431, 10097112),
(431, 10097113),
(431, 10097114),
(431, 10097115),
(431, 10097116),
(431, 10097117),
(431, 10097118),
(431, 10097119),
(431, 10097120),
(431, 10097121),
(431, 10097122),
(431, 10097123),
(431, 10097124),
(431, 10097125),
(431, 10097126),
(431, 10097127),
(431, 10097128),
(431, 10097129),
(431, 10097130),
(431, 10097131),
(431, 10097132),
(431, 10097133),
(431, 10097134),
(431, 10097135),
(431, 10097136),
(431, 10097137),
(431, 10097138),
(431, 10097139),
(431, 10097140),
(431, 10097141),
(431, 10097142),
(431, 10097143),
(431, 10097144),
(431, 10097145),
(431, 10097146),
(431, 10097147),
(431, 10097148),
(431, 10097149),
(431, 10097150),
(431, 10097151),
(431, 10097152),
(431, 10097153),
(431, 10097154),
(431, 10097155),
(431, 10097156),
(431, 10097157),
(431, 10097158),
(431, 10097159),
(431, 10097160),
(431, 10097161),
(431, 10097162),
(431, 10097163),
(431, 10097164),
(431, 10097165),
(431, 10097166),
(431, 10097167),
(431, 10097168),
(431, 10097169),
(431, 10097170),
(431, 10097171),
(431, 10097172),
(431, 10097173),
(431, 10097174),
(431, 10097175),
(431, 10097176),
(431, 10097177),
(431, 10097178),
(431, 10097179),
(431, 10097180),
(431, 10097181),
(431, 10097182),
(431, 10097183),
(431, 10097184),
(431, 10097185),
(431, 10097186),
(431, 10097187),
(431, 10097188),
(431, 10097189),
(431, 10097190),
(431, 10097191),
(431, 10097192),
(431, 10097193),
(431, 10097194),
(431, 10097195),
(431, 10097196),
(431, 10097197),
(431, 10097198);

-- --------------------------------------------------------

--
-- Table structure for table `playlist_types`
--

CREATE TABLE IF NOT EXISTS `playlist_types` (
`playlist_type_id` int(11) unsigned NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `playlist_types`
--

INSERT INTO `playlist_types` (`playlist_type_id`, `name`) VALUES
(1, 'normal'),
(2, 'soundscape region');

-- --------------------------------------------------------

--
-- Table structure for table `projects`
--

CREATE TABLE IF NOT EXISTS `projects` (
`project_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `url` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  `project_type_id` int(10) unsigned NOT NULL,
  `is_private` tinyint(1) NOT NULL,
  `is_enabled` tinyint(4) NOT NULL DEFAULT '1',
  `recording_limit` int(10) unsigned NOT NULL DEFAULT '50000'
) ENGINE=InnoDB AUTO_INCREMENT=34 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `projects`
--

INSERT INTO `projects` (`project_id`, `name`, `url`, `description`, `owner_id`, `project_type_id`, `is_private`, `is_enabled`, `recording_limit`) VALUES
(33, 'data-sets', 'data-sets', 'data-sets data-sets data-sets data-sets data-sets.', 1, 1, 1, 1, 50000);

-- --------------------------------------------------------

--
-- Table structure for table `project_classes`
--

CREATE TABLE IF NOT EXISTS `project_classes` (
`project_class_id` int(10) unsigned NOT NULL,
  `project_id` int(11) unsigned NOT NULL,
  `species_id` int(11) NOT NULL,
  `songtype_id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `project_classes`
--

INSERT INTO `project_classes` (`project_class_id`, `project_id`, `species_id`, `songtype_id`) VALUES
(75, 33, 16771, 1),
(76, 33, 16772, 1),
(77, 33, 16773, 1),
(78, 33, 16774, 1),
(79, 33, 16775, 1),
(80, 33, 16776, 1),
(81, 33, 16777, 1),
(82, 33, 16778, 1),
(83, 33, 16779, 1),
(84, 33, 16780, 1);

-- --------------------------------------------------------

--
-- Table structure for table `project_imported_sites`
--

CREATE TABLE IF NOT EXISTS `project_imported_sites` (
  `site_id` int(10) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='published sites added to projects';

-- --------------------------------------------------------

--
-- Table structure for table `project_news`
--

CREATE TABLE IF NOT EXISTS `project_news` (
`news_feed_id` bigint(20) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `data` text NOT NULL,
  `news_type_id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=604 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `project_news`
--

INSERT INTO `project_news` (`news_feed_id`, `user_id`, `project_id`, `timestamp`, `data`, `news_type_id`) VALUES
(563, 1, 33, '2015-07-08 14:46:26', '{}', 1),
(564, 1, 33, '2015-07-08 14:52:31', '{"site":"simple"}', 2),
(565, 1, 33, '2015-07-08 14:54:19', '{"species":"dummy","song":"Common Song"}', 5),
(566, 1, 33, '2015-07-08 15:54:17', '{"playlist":"simple"}', 10),
(567, 1, 33, '2015-07-08 15:54:44', '{"training_set":"simple"}', 7),
(568, 1, 33, '2015-07-10 15:54:41', '{"site":"sp2"}', 2),
(569, 1, 33, '2015-07-10 15:54:57', '{"site":"sp3"}', 2),
(570, 1, 33, '2015-07-10 15:55:24', '{"site":"sp2_3"}', 2),
(571, 1, 33, '2015-07-10 16:06:39', '{"playlist":"sp2"}', 10),
(572, 1, 33, '2015-07-10 16:06:48', '{"playlist":"sp3"}', 10),
(573, 1, 33, '2015-07-10 16:06:57', '{"playlist":"sp2_3"}', 10),
(574, 1, 33, '2015-07-10 16:12:11', '{"species":"dummy2","song":"Common Song"}', 5),
(575, 1, 33, '2015-07-10 16:12:45', '{"species":"dummy3","song":"Common Song"}', 5),
(576, 1, 33, '2015-07-10 16:13:00', '{"training_set":"dummy2"}', 7),
(577, 1, 33, '2015-07-10 16:13:07', '{"training_set":"dummy3"}', 7),
(578, 1, 33, '2015-07-10 17:10:59', '{"site":"garbage"}', 2),
(579, 1, 33, '2015-07-10 17:13:48', '{"species":"garbage","song":"Common Song"}', 5),
(580, 1, 33, '2015-07-10 17:13:57', '{"training_set":"garbage"}', 7),
(581, 1, 33, '2015-07-10 17:17:37', '{"playlist":"garbage"}', 10),
(582, 1, 33, '2015-07-10 17:18:10', '{"training_set":"garb"}', 7),
(583, 1, 33, '2015-07-17 14:34:03', '{"site":"Eleutherodactylus cooki"}', 2),
(584, 1, 33, '2015-07-17 14:35:05', '{"species":" Eleutherodactylus cooki","song":"Common Song"}', 5),
(585, 1, 33, '2015-07-17 14:36:33', '{"training_set":"Eleutherodactylus cooki"}', 7),
(586, 1, 33, '2015-07-17 14:44:44', '{"site":"Red HInt- Epinephelus guttatus"}', 2),
(587, 1, 33, '2015-07-17 14:45:27', '{"species":"Epinephelus guttatus","song":"Common Song"}', 5),
(588, 1, 33, '2015-07-17 14:45:40', '{"training_set":"Epinephelus guttatus"}', 7),
(589, 1, 33, '2015-07-17 14:49:41', '{"site":"Percnostola lophotes"}', 2),
(590, 1, 33, '2015-07-17 14:50:20', '{"species":"Percnostola lophotes","song":"Common Song"}', 5),
(591, 1, 33, '2015-07-17 14:50:27', '{"training_set":"Percnostola lophotes"}', 7),
(592, 1, 33, '2015-07-17 14:53:07', '{"playlist":"Eleutherodactylus cooki"}', 10),
(593, 1, 33, '2015-07-17 14:53:42', '{"playlist":"Epinephelus guttatus"}', 10),
(594, 1, 33, '2015-07-17 14:57:02', '{"site":"Hypocnemis subflava"}', 2),
(595, 1, 33, '2015-07-17 14:58:02', '{"species":"Hypocnemis subflava","song":"Common Song"}', 5),
(596, 1, 33, '2015-07-17 14:58:38', '{"training_set":"Hypocnemis subflava"}', 7),
(597, 1, 33, '2015-07-17 15:01:06', '{"site":"Thamnophilus schistaceus"}', 2),
(598, 1, 33, '2015-07-17 15:01:24', '{"species":"Thamnophilus schistaceus","song":"Common Song"}', 5),
(599, 1, 33, '2015-07-17 15:01:34', '{"training_set":"Thamnophilus schistaceus"}', 7),
(600, 1, 33, '2015-07-17 15:06:52', '{"site":"Myrmeciza hemimelaena"}', 2),
(601, 1, 33, '2015-07-17 15:06:59', '{"species":"Myrmeciza hemimelaena","song":"Common Song"}', 5),
(602, 1, 33, '2015-07-17 15:07:06', '{"training_set":"Myrmeciza hemimelaena"}', 7),
(603, 1, 33, '2015-07-17 15:17:23', '{"playlist":"Percnostola lophotes"}', 10);

-- --------------------------------------------------------

--
-- Table structure for table `project_news_types`
--

CREATE TABLE IF NOT EXISTS `project_news_types` (
`news_type_id` int(11) NOT NULL,
  `name` varchar(30) NOT NULL,
  `description` text NOT NULL,
  `message_format` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `project_news_types`
--

INSERT INTO `project_news_types` (`news_type_id`, `name`, `description`, `message_format`) VALUES
(1, 'project created', 'A user created a project', 'created project "%(project)s"'),
(2, 'site created', 'a site was created in the project', 'added site "%(site)s" to project "%(project)s"'),
(3, 'site updated', 'user updated site ', 'updated site "%(site)s" on project "%(project)s"'),
(4, 'site deleted', 'user deleted site', 'deleted sites "%(sites)s" from project "%(project)s"'),
(5, 'class added', 'user added a species song', 'added "%(species)s %(song)s" to project "%(project)s" species'),
(6, 'class removed', 'user removed a species song', 'removed "%(classes)s" from project "%(project)s" species'),
(7, 'training set created', 'Training set created ', 'created training set "%(training_set)s" on project "%(project)s"'),
(8, 'model trained ', 'user created and train a model', 'created model "%(model)s" with the training set "%(training_set)s" on project %(project)s'),
(9, 'model run', 'user run a model over a set of recordings', 'run classification "%(classi)s" of model"%(model)s" on project "%(project)s"'),
(10, 'playlist created', 'user created a playlist', 'created playlist "%(playlist)s" on project "%(project)s"'),
(11, 'soundscape created', 'user created soundscape', 'created soundscape "%(soundscape)s" on project "%(project)s"');

-- --------------------------------------------------------

--
-- Table structure for table `project_types`
--

CREATE TABLE IF NOT EXISTS `project_types` (
`project_type_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `project_types`
--

INSERT INTO `project_types` (`project_type_id`, `name`, `description`) VALUES
(1, 'normal', 'regular project created by user');

-- --------------------------------------------------------

--
-- Table structure for table `recanalizer_stats`
--

CREATE TABLE IF NOT EXISTS `recanalizer_stats` (
  `job_id` int(11) NOT NULL,
  `rec_id` int(11) NOT NULL,
  `exec_time` float NOT NULL,
`id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4297 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `recanalizer_stats`
--

INSERT INTO `recanalizer_stats` (`job_id`, `rec_id`, `exec_time`, `id`) VALUES
(891, 10096685, 0.0634751, 3421),
(891, 10096684, 0.062604, 3422),
(891, 10096686, 0.063271, 3423),
(891, 10096680, 0.0654168, 3424),
(891, 10096667, 0.0583038, 3425),
(891, 10096675, 0.0598412, 3426),
(891, 10096663, 0.040242, 3427),
(891, 10096669, 0.040153, 3428),
(891, 10096673, 0.041297, 3429),
(891, 10096664, 0.0401781, 3430),
(891, 10096679, 0.0390949, 3431),
(891, 10096683, 0.0408092, 3432),
(891, 10096677, 0.0410261, 3433),
(891, 10096687, 0.041436, 3434),
(891, 10096668, 0.0426369, 3435),
(891, 10096666, 0.047194, 3436),
(891, 10096691, 0.0415769, 3437),
(891, 10096681, 0.0414538, 3438),
(891, 10096682, 0.0584781, 3439),
(891, 10096690, 0.0387299, 3440),
(891, 10096678, 0.039546, 3441),
(891, 10096688, 0.0394199, 3442),
(891, 10096665, 0.043292, 3443),
(891, 10096674, 0.039922, 3444),
(891, 10096662, 0.0397511, 3445),
(891, 10096676, 0.039818, 3446),
(891, 10096672, 0.0420952, 3447),
(891, 10096671, 0.0421839, 3448),
(891, 10096670, 0.039757, 3449),
(891, 10096689, 0.041522, 3450),
(891, 10096637, 0.0580339, 3451),
(891, 10096644, 0.0420871, 3452),
(891, 10096636, 0.0590069, 3453),
(891, 10096650, 0.0398989, 3454),
(891, 10096638, 0.0587881, 3455),
(891, 10096635, 0.039716, 3456),
(891, 10096646, 0.0391481, 3457),
(891, 10096655, 0.0446441, 3458),
(891, 10096652, 0.041692, 3459),
(891, 10096658, 0.0412428, 3460),
(891, 10096641, 0.0400379, 3461),
(891, 10096642, 0.0400581, 3462),
(891, 10096634, 0.039782, 3463),
(891, 10096648, 0.0437229, 3464),
(891, 10096647, 0.0435209, 3465),
(891, 10096639, 0.0581551, 3466),
(891, 10096656, 0.0425901, 3467),
(891, 10096632, 0.0405121, 3468),
(891, 10096651, 0.041261, 3469),
(891, 10096661, 0.0420001, 3470),
(891, 10096653, 0.0417261, 3471),
(891, 10096659, 0.039696, 3472),
(891, 10096654, 0.0392299, 3473),
(891, 10096660, 0.042079, 3474),
(891, 10096657, 0.040777, 3475),
(891, 10096640, 0.0414321, 3476),
(891, 10096645, 0.03966, 3477),
(891, 10096649, 0.0405269, 3478),
(891, 10096643, 0.0428011, 3479),
(891, 10096633, 0.043519, 3480),
(891, 10096676, 0.086448, 3481),
(891, 10096681, 0.130099, 3482),
(891, 10096662, 0.076601, 3483),
(891, 10096679, 0.079406, 3484),
(891, 10096672, 0.13737, 3485),
(891, 10096666, 0.078068, 3486),
(891, 10096670, 0.076576, 3487),
(891, 10096675, 0.0775049, 3488),
(891, 10096688, 0.0776799, 3489),
(891, 10096685, 0.129763, 3490),
(891, 10096686, 0.0780249, 3491),
(891, 10096671, 0.0752921, 3492),
(891, 10096677, 0.081146, 3493),
(891, 10096683, 0.0783298, 3494),
(891, 10096674, 0.0780189, 3495),
(891, 10096684, 0.077203, 3496),
(891, 10096665, 0.078577, 3497),
(891, 10096689, 0.0793331, 3498),
(891, 10096678, 0.0811729, 3499),
(891, 10096669, 0.077615, 3500),
(891, 10096673, 0.0779719, 3501),
(891, 10096668, 0.0772469, 3502),
(891, 10096680, 0.0799541, 3503),
(891, 10096664, 0.0786209, 3504),
(891, 10096687, 0.078392, 3505),
(891, 10096667, 0.0774348, 3506),
(891, 10096690, 0.076798, 3507),
(891, 10096691, 0.0787511, 3508),
(891, 10096663, 0.111842, 3509),
(891, 10096642, 0.0782859, 3510),
(891, 10096633, 0.0767641, 3511),
(891, 10096646, 0.0772951, 3512),
(891, 10096643, 0.0810869, 3513),
(891, 10096648, 0.0769141, 3514),
(891, 10096634, 0.0762382, 3515),
(891, 10096682, 0.0761111, 3516),
(891, 10096651, 0.0763509, 3517),
(891, 10096653, 0.080205, 3518),
(891, 10096650, 0.0772941, 3519),
(891, 10096647, 0.0777431, 3520),
(891, 10096635, 0.0768409, 3521),
(891, 10096658, 0.07739, 3522),
(891, 10096657, 0.0774908, 3523),
(891, 10096660, 0.0793262, 3524),
(891, 10096661, 0.0803351, 3525),
(891, 10096639, 0.077045, 3526),
(891, 10096659, 0.0761461, 3527),
(891, 10096649, 0.0776279, 3528),
(891, 10096654, 0.081826, 3529),
(891, 10096644, 0.080637, 3530),
(891, 10096641, 0.076165, 3531),
(891, 10096640, 0.076247, 3532),
(891, 10096636, 0.077131, 3533),
(891, 10096656, 0.076498, 3534),
(891, 10096632, 0.077879, 3535),
(891, 10096638, 0.076319, 3536),
(891, 10096655, 0.0768421, 3537),
(891, 10096645, 0.076519, 3538),
(891, 10096637, 0.0761092, 3539),
(891, 10096652, 0.081727, 3540),
(891, 10096668, 0.076906, 3541),
(891, 10096688, 0.0759132, 3542),
(891, 10096671, 0.075913, 3543),
(891, 10096687, 0.0769329, 3544),
(891, 10096675, 0.0825751, 3545),
(891, 10096683, 0.079288, 3546),
(891, 10096676, 0.076364, 3547),
(891, 10096672, 0.0764551, 3548),
(891, 10096665, 0.0767519, 3549),
(891, 10096673, 0.08288, 3550),
(891, 10096682, 0.076314, 3551),
(891, 10096689, 0.0764251, 3552),
(891, 10096691, 0.076431, 3553),
(891, 10096666, 0.078018, 3554),
(891, 10096690, 0.0777349, 3555),
(891, 10096680, 0.0806391, 3556),
(891, 10096684, 0.078491, 3557),
(891, 10096670, 0.078306, 3558),
(891, 10096674, 0.0773151, 3559),
(891, 10096667, 0.0771971, 3560),
(891, 10096677, 0.0826161, 3561),
(891, 10096662, 0.07956, 3562),
(891, 10096669, 0.081861, 3563),
(891, 10096679, 0.0804021, 3564),
(891, 10096663, 0.0781209, 3565),
(891, 10096681, 0.0790222, 3566),
(891, 10096651, 0.0791588, 3567),
(891, 10096678, 0.0814259, 3568),
(891, 10096636, 0.076597, 3569),
(891, 10096650, 0.0774832, 3570),
(891, 10096647, 0.0808921, 3571),
(891, 10096686, 0.0775979, 3572),
(891, 10096652, 0.0856221, 3573),
(891, 10096664, 0.0780659, 3574),
(891, 10096685, 0.077292, 3575),
(891, 10096649, 0.077873, 3576),
(891, 10096660, 0.077564, 3577),
(891, 10096642, 0.0821061, 3578),
(891, 10096638, 0.0776269, 3579),
(891, 10096635, 0.0772991, 3580),
(891, 10096655, 0.0775111, 3581),
(891, 10096648, 0.076206, 3582),
(891, 10096657, 0.0790851, 3583),
(891, 10096661, 0.0759418, 3584),
(891, 10096653, 0.0785799, 3585),
(891, 10096633, 0.0776448, 3586),
(891, 10096646, 0.0760701, 3587),
(891, 10096632, 0.0822611, 3588),
(891, 10096645, 0.0817671, 3589),
(891, 10096654, 0.0831809, 3590),
(891, 10096637, 0.080477, 3591),
(891, 10096658, 0.0805619, 3592),
(891, 10096656, 0.077333, 3593),
(891, 10096644, 0.07675, 3594),
(891, 10096634, 0.0771401, 3595),
(891, 10096641, 0.078474, 3596),
(891, 10096643, 0.076333, 3597),
(891, 10096659, 0.0811081, 3598),
(891, 10096640, 0.0756221, 3599),
(891, 10096639, 0.0807099, 3600),
(891, 10096679, 0.137802, 3601),
(891, 10096689, 0.13732, 3602),
(891, 10096686, 0.0826919, 3603),
(891, 10096691, 0.080512, 3604),
(891, 10096663, 0.137667, 3605),
(891, 10096675, 0.0831079, 3606),
(891, 10096684, 0.075536, 3607),
(891, 10096688, 0.0782659, 3608),
(891, 10096682, 0.13884, 3609),
(891, 10096665, 0.0893469, 3610),
(891, 10096683, 0.138569, 3611),
(891, 10096670, 0.0815861, 3612),
(891, 10096678, 0.079648, 3613),
(891, 10096680, 0.0774739, 3614),
(891, 10096666, 0.0768621, 3615),
(891, 10096690, 0.077944, 3616),
(891, 10096667, 0.082963, 3617),
(891, 10096674, 0.0773649, 3618),
(891, 10096685, 0.131984, 3619),
(891, 10096672, 0.115062, 3620),
(891, 10096681, 0.0770011, 3621),
(891, 10096668, 0.080374, 3622),
(891, 10096673, 0.0771179, 3623),
(891, 10096687, 0.0782371, 3624),
(891, 10096676, 0.0840518, 3625),
(891, 10096669, 0.080461, 3626),
(891, 10096677, 0.0760422, 3627),
(891, 10096671, 0.078285, 3628),
(891, 10096662, 0.0786171, 3629),
(891, 10096653, 0.0832989, 3630),
(891, 10096632, 0.080066, 3631),
(891, 10096633, 0.083673, 3632),
(891, 10096641, 0.083595, 3633),
(891, 10096661, 0.0769701, 3634),
(891, 10096643, 0.083415, 3635),
(891, 10096635, 0.139518, 3636),
(891, 10096652, 0.0861709, 3637),
(891, 10096647, 0.077739, 3638),
(891, 10096664, 0.077245, 3639),
(891, 10096637, 0.0799379, 3640),
(891, 10096642, 0.0781481, 3641),
(891, 10096656, 0.0776279, 3642),
(891, 10096651, 0.0775049, 3643),
(891, 10096639, 0.0787852, 3644),
(891, 10096638, 0.0778198, 3645),
(891, 10096659, 0.0827498, 3646),
(891, 10096646, 0.0805979, 3647),
(891, 10096640, 0.084383, 3648),
(891, 10096660, 0.138573, 3649),
(891, 10096645, 0.0774639, 3650),
(891, 10096649, 0.140347, 3651),
(891, 10096636, 0.0768001, 3652),
(891, 10096655, 0.0809841, 3653),
(891, 10096657, 0.082165, 3654),
(891, 10096658, 0.0784159, 3655),
(891, 10096648, 0.0792401, 3656),
(891, 10096644, 0.083765, 3657),
(891, 10096654, 0.0791969, 3658),
(891, 10096634, 0.079277, 3659),
(891, 10096650, 0.0794289, 3660),
(891, 10096682, 0.095006, 3661),
(891, 10096680, 0.136623, 3662),
(891, 10096677, 0.131509, 3663),
(891, 10096685, 0.077126, 3664),
(891, 10096666, 0.104438, 3665),
(891, 10096665, 0.137672, 3666),
(891, 10096688, 0.077112, 3667),
(891, 10096663, 0.0775938, 3668),
(891, 10096674, 0.0790389, 3669),
(891, 10096684, 0.095109, 3670),
(891, 10096676, 0.139519, 3671),
(891, 10096691, 0.0766931, 3672),
(891, 10096679, 0.138214, 3673),
(891, 10096686, 0.0750349, 3674),
(891, 10096678, 0.0794961, 3675),
(891, 10096673, 0.0799232, 3676),
(891, 10096683, 0.0763021, 3677),
(891, 10096675, 0.098599, 3678),
(891, 10096670, 0.0920689, 3679),
(891, 10096668, 0.080518, 3680),
(891, 10096690, 0.137684, 3681),
(891, 10096667, 0.074719, 3682),
(891, 10096664, 0.0767779, 3683),
(891, 10096689, 0.075496, 3684),
(891, 10096687, 0.141202, 3685),
(891, 10096681, 0.120233, 3686),
(891, 10096662, 0.0771849, 3687),
(891, 10096671, 0.0796068, 3688),
(891, 10096672, 0.082154, 3689),
(891, 10096669, 0.0757999, 3690),
(891, 10096649, 0.0759461, 3691),
(891, 10096652, 0.083163, 3692),
(891, 10096635, 0.086328, 3693),
(891, 10096648, 0.077719, 3694),
(891, 10096653, 0.0787289, 3695),
(891, 10096636, 0.136575, 3696),
(891, 10096660, 0.0795739, 3697),
(891, 10096640, 0.0774069, 3698),
(891, 10096654, 0.0769691, 3699),
(891, 10096646, 0.076313, 3700),
(891, 10096655, 0.0773091, 3701),
(891, 10096634, 0.0787568, 3702),
(891, 10096643, 0.077224, 3703),
(891, 10096657, 0.0775099, 3704),
(891, 10096639, 0.0759282, 3705),
(891, 10096651, 0.080718, 3706),
(891, 10096633, 0.139333, 3707),
(891, 10096659, 0.077271, 3708),
(891, 10096641, 0.076776, 3709),
(891, 10096632, 0.075007, 3710),
(891, 10096638, 0.077503, 3711),
(891, 10096650, 0.0763412, 3712),
(891, 10096647, 0.086868, 3713),
(891, 10096644, 0.0806761, 3714),
(891, 10096642, 0.14159, 3715),
(891, 10096661, 0.077693, 3716),
(891, 10096645, 0.080127, 3717),
(891, 10096658, 0.077148, 3718),
(891, 10096637, 0.085109, 3719),
(891, 10096656, 0.075799, 3720),
(891, 10096677, 0.13668, 3721),
(891, 10096681, 0.137087, 3722),
(891, 10096690, 0.0799601, 3723),
(891, 10096685, 0.133175, 3724),
(891, 10096670, 0.0972161, 3725),
(891, 10096669, 0.127742, 3726),
(891, 10096676, 0.125342, 3727),
(891, 10096688, 0.0812731, 3728),
(891, 10096666, 0.0818412, 3729),
(891, 10096674, 0.0787389, 3730),
(891, 10096664, 0.142792, 3731),
(891, 10096687, 0.0766549, 3732),
(891, 10096691, 0.0835738, 3733),
(891, 10096678, 0.075551, 3734),
(891, 10096689, 0.0769539, 3735),
(891, 10096675, 0.076165, 3736),
(891, 10096683, 0.082571, 3737),
(891, 10096662, 0.075985, 3738),
(891, 10096668, 0.075577, 3739),
(891, 10096686, 0.0794151, 3740),
(891, 10096672, 0.078526, 3741),
(891, 10096679, 0.0763481, 3742),
(891, 10096680, 0.082463, 3743),
(891, 10096684, 0.08201, 3744),
(891, 10096682, 0.132375, 3745),
(891, 10096665, 0.11279, 3746),
(891, 10096667, 0.0809839, 3747),
(891, 10096663, 0.0777321, 3748),
(891, 10096671, 0.0763428, 3749),
(891, 10096653, 0.078228, 3750),
(891, 10096673, 0.0772729, 3751),
(891, 10096658, 0.080663, 3752),
(891, 10096632, 0.138115, 3753),
(891, 10096639, 0.129133, 3754),
(891, 10096634, 0.128459, 3755),
(891, 10096644, 0.077579, 3756),
(891, 10096648, 0.0771639, 3757),
(891, 10096650, 0.07745, 3758),
(891, 10096633, 0.077224, 3759),
(891, 10096656, 0.077462, 3760),
(891, 10096637, 0.076982, 3761),
(891, 10096643, 0.076885, 3762),
(891, 10096655, 0.075681, 3763),
(891, 10096638, 0.07776, 3764),
(891, 10096654, 0.078114, 3765),
(891, 10096640, 0.0772309, 3766),
(891, 10096645, 0.082247, 3767),
(891, 10096660, 0.0757239, 3768),
(891, 10096642, 0.0786951, 3769),
(891, 10096652, 0.0792181, 3770),
(891, 10096659, 0.0775492, 3771),
(891, 10096647, 0.0805809, 3772),
(891, 10096657, 0.0785749, 3773),
(891, 10096646, 0.13878, 3774),
(891, 10096635, 0.078001, 3775),
(891, 10096661, 0.0765119, 3776),
(891, 10096651, 0.077137, 3777),
(891, 10096641, 0.136583, 3778),
(891, 10096649, 0.136383, 3779),
(891, 10096636, 0.076755, 3780),
(891, 10096675, 0.0807261, 3781),
(891, 10096664, 0.136799, 3782),
(891, 10096663, 0.075068, 3783),
(891, 10096665, 0.075568, 3784),
(891, 10096662, 0.129555, 3785),
(891, 10096681, 0.120405, 3786),
(891, 10096677, 0.0786231, 3787),
(891, 10096685, 0.143668, 3788),
(891, 10096668, 0.098824, 3789),
(891, 10096676, 0.0782549, 3790),
(891, 10096672, 0.076483, 3791),
(891, 10096686, 0.138573, 3792),
(891, 10096690, 0.075995, 3793),
(891, 10096684, 0.077251, 3794),
(891, 10096689, 0.0778372, 3795),
(891, 10096679, 0.0800619, 3796),
(891, 10096674, 0.081641, 3797),
(891, 10096683, 0.076606, 3798),
(891, 10096682, 0.079787, 3799),
(891, 10096691, 0.0772631, 3800),
(891, 10096678, 0.0773749, 3801),
(891, 10096688, 0.0759661, 3802),
(891, 10096666, 0.0771689, 3803),
(891, 10096669, 0.0762532, 3804),
(891, 10096671, 0.0756071, 3805),
(891, 10096670, 0.076757, 3806),
(891, 10096680, 0.0767241, 3807),
(891, 10096637, 0.0765309, 3808),
(891, 10096673, 0.077688, 3809),
(891, 10096654, 0.0747032, 3810),
(891, 10096687, 0.076263, 3811),
(891, 10096667, 0.077574, 3812),
(891, 10096643, 0.075999, 3813),
(891, 10096652, 0.0757132, 3814),
(891, 10096641, 0.132341, 3815),
(891, 10096659, 0.106212, 3816),
(891, 10096650, 0.0771761, 3817),
(891, 10096639, 0.0778739, 3818),
(891, 10096644, 0.081156, 3819),
(891, 10096633, 0.0775211, 3820),
(891, 10096634, 0.077549, 3821),
(891, 10096660, 0.0781949, 3822),
(891, 10096645, 0.138102, 3823),
(891, 10096655, 0.075789, 3824),
(891, 10096632, 0.0820971, 3825),
(891, 10096649, 0.0833881, 3826),
(891, 10096661, 0.083734, 3827),
(891, 10096638, 0.077131, 3828),
(891, 10096636, 0.0797579, 3829),
(891, 10096648, 0.081732, 3830),
(891, 10096656, 0.0778012, 3831),
(891, 10096658, 0.0781391, 3832),
(891, 10096657, 0.076479, 3833),
(891, 10096653, 0.0766642, 3834),
(891, 10096642, 0.0796471, 3835),
(891, 10096647, 0.138004, 3836),
(891, 10096651, 0.076715, 3837),
(891, 10096640, 0.0779331, 3838),
(891, 10096646, 0.076709, 3839),
(891, 10096635, 0.076956, 3840),
(891, 10096670, 0.137608, 3841),
(891, 10096687, 0.0748439, 3842),
(891, 10096674, 0.0761938, 3843),
(891, 10096681, 0.0760889, 3844),
(891, 10096669, 0.0761371, 3845),
(891, 10096690, 0.0778239, 3846),
(891, 10096668, 0.0817211, 3847),
(891, 10096689, 0.0752759, 3848),
(891, 10096686, 0.076055, 3849),
(891, 10096675, 0.0765991, 3850),
(891, 10096673, 0.0763011, 3851),
(891, 10096683, 0.0771251, 3852),
(891, 10096691, 0.075455, 3853),
(891, 10096677, 0.0778599, 3854),
(891, 10096679, 0.0769739, 3855),
(891, 10096682, 0.0812969, 3856),
(891, 10096672, 0.076597, 3857),
(891, 10096678, 0.0766721, 3858),
(891, 10096688, 0.137754, 3859),
(891, 10096664, 0.0766962, 3860),
(891, 10096671, 0.0781372, 3861),
(891, 10096662, 0.0763891, 3862),
(891, 10096685, 0.135639, 3863),
(891, 10096667, 0.099261, 3864),
(891, 10096680, 0.14215, 3865),
(891, 10096666, 0.0856521, 3866),
(891, 10096665, 0.0778899, 3867),
(891, 10096676, 0.138763, 3868),
(891, 10096684, 0.0765018, 3869),
(891, 10096663, 0.076916, 3870),
(891, 10096637, 0.079659, 3871),
(891, 10096641, 0.079077, 3872),
(891, 10096660, 0.136852, 3873),
(891, 10096640, 0.0774269, 3874),
(891, 10096642, 0.0771899, 3875),
(891, 10096652, 0.0766442, 3876),
(891, 10096636, 0.076731, 3877),
(891, 10096653, 0.0785651, 3878),
(891, 10096633, 0.078779, 3879),
(891, 10096644, 0.0769732, 3880),
(891, 10096639, 0.0761461, 3881),
(891, 10096638, 0.07762, 3882),
(891, 10096659, 0.0773959, 3883),
(891, 10096649, 0.0769398, 3884),
(891, 10096655, 0.0763299, 3885),
(891, 10096651, 0.082799, 3886),
(891, 10096634, 0.138455, 3887),
(891, 10096646, 0.0768712, 3888),
(891, 10096645, 0.07603, 3889),
(891, 10096656, 0.081681, 3890),
(891, 10096632, 0.0791259, 3891),
(891, 10096658, 0.0773039, 3892),
(891, 10096647, 0.0793781, 3893),
(891, 10096635, 0.0779951, 3894),
(891, 10096643, 0.13711, 3895),
(891, 10096648, 0.0763049, 3896),
(891, 10096661, 0.0760601, 3897),
(891, 10096654, 0.0769751, 3898),
(891, 10096650, 0.0755341, 3899),
(891, 10096657, 0.075943, 3900),
(891, 10096670, 0.0787108, 3901),
(891, 10096665, 0.0766208, 3902),
(891, 10096673, 0.136035, 3903),
(891, 10096691, 0.137863, 3904),
(891, 10096684, 0.0888078, 3905),
(891, 10096676, 0.0786569, 3906),
(891, 10096668, 0.076072, 3907),
(891, 10096687, 0.0819931, 3908),
(891, 10096683, 0.0767939, 3909),
(891, 10096672, 0.0809219, 3910),
(891, 10096681, 0.125237, 3911),
(891, 10096688, 0.0772669, 3912),
(891, 10096663, 0.139395, 3913),
(891, 10096669, 0.079093, 3914),
(891, 10096666, 0.0763412, 3915),
(891, 10096682, 0.075994, 3916),
(891, 10096675, 0.0763409, 3917),
(891, 10096674, 0.0806189, 3918),
(891, 10096690, 0.0812192, 3919),
(891, 10096686, 0.0806148, 3920),
(891, 10096667, 0.141844, 3921),
(891, 10096677, 0.0801179, 3922),
(891, 10096662, 0.083627, 3923),
(891, 10096664, 0.0769739, 3924),
(891, 10096689, 0.081876, 3925),
(891, 10096671, 0.0755482, 3926),
(891, 10096680, 0.0772989, 3927),
(891, 10096678, 0.0835509, 3928),
(891, 10096679, 0.0784791, 3929),
(891, 10096635, 0.0769551, 3930),
(891, 10096661, 0.0773261, 3931),
(891, 10096647, 0.0761471, 3932),
(891, 10096685, 0.083859, 3933),
(891, 10096656, 0.082916, 3934),
(891, 10096639, 0.079525, 3935),
(891, 10096651, 0.077523, 3936),
(891, 10096648, 0.0765181, 3937),
(891, 10096641, 0.0771949, 3938),
(891, 10096653, 0.0780392, 3939),
(891, 10096644, 0.138218, 3940),
(891, 10096640, 0.0859818, 3941),
(891, 10096642, 0.0791159, 3942),
(891, 10096634, 0.07514, 3943),
(891, 10096636, 0.076649, 3944),
(891, 10096658, 0.0765481, 3945),
(891, 10096637, 0.0819099, 3946),
(891, 10096660, 0.0772798, 3947),
(891, 10096652, 0.07671, 3948),
(891, 10096633, 0.077292, 3949),
(891, 10096657, 0.08318, 3950),
(891, 10096649, 0.0783429, 3951),
(891, 10096638, 0.0774279, 3952),
(891, 10096646, 0.076647, 3953),
(891, 10096632, 0.077266, 3954),
(891, 10096655, 0.0774632, 3955),
(891, 10096659, 0.076951, 3956),
(891, 10096643, 0.076791, 3957),
(891, 10096645, 0.076303, 3958),
(891, 10096650, 0.0764282, 3959),
(891, 10096654, 0.0756202, 3960),
(898, 10096734, 0.0793021, 3961),
(898, 10096871, 0.140481, 3962),
(898, 10096724, 0.139501, 3963),
(898, 10096742, 0.075614, 3964),
(898, 10096741, 0.139047, 3965),
(898, 10096740, 0.0757351, 3966),
(898, 10096750, 0.078613, 3967),
(898, 10096845, 0.078541, 3968),
(898, 10096852, 0.075181, 3969),
(898, 10096736, 0.0746531, 3970),
(898, 10096848, 0.0814281, 3971),
(898, 10096870, 0.0808821, 3972),
(898, 10096731, 0.0763862, 3973),
(898, 10096856, 0.123719, 3974),
(898, 10096853, 0.0789311, 3975),
(898, 10096748, 0.0793819, 3976),
(898, 10096745, 0.077023, 3977),
(898, 10096843, 0.0769761, 3978),
(898, 10096751, 0.080776, 3979),
(898, 10096723, 0.0787098, 3980),
(898, 10096730, 0.0809681, 3981),
(898, 10096743, 0.077733, 3982),
(898, 10096727, 0.078675, 3983),
(898, 10096726, 0.0781, 3984),
(898, 10096860, 0.121627, 3985),
(898, 10096850, 0.0773702, 3986),
(898, 10096744, 0.143108, 3987),
(898, 10096863, 0.0856609, 3988),
(898, 10096729, 0.077708, 3989),
(898, 10096869, 0.14003, 3990),
(898, 10096732, 0.0777209, 3991),
(898, 10096725, 0.0762939, 3992),
(898, 10096739, 0.0763991, 3993),
(898, 10096844, 0.0838649, 3994),
(898, 10096861, 0.076097, 3995),
(898, 10096865, 0.0764639, 3996),
(898, 10096733, 0.0771132, 3997),
(898, 10096842, 0.0813708, 3998),
(898, 10096868, 0.0785389, 3999),
(898, 10096855, 0.126258, 4000),
(898, 10096728, 0.0785491, 4001),
(898, 10096747, 0.13319, 4002),
(898, 10096854, 0.0989399, 4003),
(898, 10096864, 0.0775812, 4004),
(898, 10096859, 0.0775709, 4005),
(898, 10096735, 0.0832441, 4006),
(898, 10096862, 0.075743, 4007),
(898, 10096867, 0.079699, 4008),
(898, 10096738, 0.12386, 4009),
(898, 10096849, 0.0831251, 4010),
(898, 10096851, 0.080775, 4011),
(898, 10096847, 0.134607, 4012),
(898, 10096858, 0.079658, 4013),
(898, 10096857, 0.0803821, 4014),
(898, 10096746, 0.120954, 4015),
(898, 10096737, 0.0790002, 4016),
(898, 10096749, 0.144743, 4017),
(898, 10096833, 0.087733, 4018),
(898, 10096866, 0.0792532, 4019),
(898, 10096704, 0.0818269, 4020),
(898, 10096824, 0.0801451, 4021),
(898, 10096722, 0.078239, 4022),
(898, 10096823, 0.124814, 4023),
(898, 10096712, 0.0823491, 4024),
(898, 10096721, 0.0830822, 4025),
(898, 10096825, 0.0803931, 4026),
(898, 10096708, 0.0793009, 4027),
(898, 10096834, 0.094888, 4028),
(898, 10096829, 0.0817912, 4029),
(898, 10096831, 0.0833681, 4030),
(898, 10096693, 0.0857999, 4031),
(898, 10096692, 0.086776, 4032),
(898, 10096694, 0.123708, 4033),
(898, 10096837, 0.0816731, 4034),
(898, 10096841, 0.082633, 4035),
(898, 10096827, 0.0909371, 4036),
(898, 10096705, 0.086762, 4037),
(898, 10096716, 0.082556, 4038),
(898, 10096715, 0.077821, 4039),
(898, 10096812, 0.0836759, 4040),
(898, 10096836, 0.0824311, 4041),
(898, 10096832, 0.0799441, 4042),
(898, 10096706, 0.08354, 4043),
(898, 10096720, 0.0785499, 4044),
(898, 10096813, 0.078438, 4045),
(898, 10096709, 0.0871449, 4046),
(898, 10096815, 0.0882809, 4047),
(898, 10096710, 0.140442, 4048),
(898, 10096819, 0.0832801, 4049),
(898, 10096838, 0.0858068, 4050),
(898, 10096697, 0.0822599, 4051),
(898, 10096840, 0.0932291, 4052),
(898, 10096839, 0.083678, 4053),
(898, 10096826, 0.145032, 4054),
(898, 10096717, 0.0788219, 4055),
(898, 10096696, 0.0771189, 4056),
(898, 10096822, 0.079077, 4057),
(898, 10096820, 0.0773859, 4058),
(898, 10096830, 0.0824611, 4059),
(898, 10096719, 0.0837541, 4060),
(898, 10096821, 0.0808821, 4061),
(898, 10096703, 0.149329, 4062),
(898, 10096695, 0.0842109, 4063),
(898, 10096701, 0.0793989, 4064),
(898, 10096814, 0.0787849, 4065),
(898, 10096818, 0.0816581, 4066),
(898, 10096702, 0.0831912, 4067),
(898, 10096817, 0.08459, 4068),
(898, 10096714, 0.0837829, 4069),
(898, 10096835, 0.149109, 4070),
(898, 10096828, 0.0877609, 4071),
(898, 10096713, 0.088331, 4072),
(898, 10096718, 0.0814941, 4073),
(898, 10096707, 0.07862, 4074),
(898, 10096698, 0.0786951, 4075),
(898, 10096700, 0.0772688, 4076),
(898, 10096699, 0.077862, 4077),
(898, 10096816, 0.0754271, 4078),
(898, 10096711, 0.0746, 4079),
(898, 10096851, 0.166412, 4080),
(898, 10096848, 0.114357, 4081),
(898, 10096855, 0.168783, 4082),
(898, 10096740, 0.104127, 4083),
(898, 10096732, 0.185102, 4084),
(898, 10096723, 0.150726, 4085),
(898, 10096871, 0.176277, 4086),
(898, 10096845, 0.285087, 4087),
(898, 10096746, 0.358901, 4088),
(898, 10096739, 0.386136, 4089),
(898, 10096736, 0.198195, 4090),
(898, 10096747, 0.278595, 4091),
(898, 10096865, 0.227267, 4092),
(898, 10096862, 0.188193, 4093),
(898, 10096850, 0.163596, 4094),
(898, 10096866, 0.0901051, 4095),
(898, 10096722, 0.0808299, 4096),
(898, 10096857, 0.089452, 4097),
(898, 10096856, 0.0969551, 4098),
(898, 10096854, 0.08952, 4099),
(898, 10096724, 0.140936, 4100),
(898, 10096733, 0.1319, 4101),
(898, 10096844, 0.089242, 4102),
(898, 10096727, 0.08675, 4103),
(898, 10096743, 0.0875139, 4104),
(898, 10096870, 0.086416, 4105),
(898, 10096748, 0.083276, 4106),
(898, 10096726, 0.0830889, 4107),
(898, 10096858, 0.0897529, 4108),
(898, 10096730, 0.0831971, 4109),
(898, 10096852, 0.082171, 4110),
(898, 10096751, 0.0780802, 4111),
(898, 10096742, 0.0783429, 4112),
(898, 10096745, 0.0832641, 4113),
(898, 10096847, 0.083889, 4114),
(898, 10096744, 0.147487, 4115),
(898, 10096750, 0.0885201, 4116),
(898, 10096859, 0.087451, 4117),
(898, 10096842, 0.0806499, 4118),
(898, 10096843, 0.0811989, 4119),
(898, 10096737, 0.083571, 4120),
(898, 10096738, 0.081121, 4121),
(898, 10096860, 0.0765471, 4122),
(898, 10096869, 0.0845671, 4123),
(898, 10096863, 0.0841649, 4124),
(898, 10096861, 0.0952301, 4125),
(898, 10096846, 0.0797069, 4126),
(898, 10096849, 0.0797639, 4127),
(898, 10096867, 0.081728, 4128),
(898, 10096741, 0.080128, 4129),
(898, 10096735, 0.0878489, 4130),
(898, 10096729, 0.079042, 4131),
(898, 10096749, 0.0825808, 4132),
(898, 10096728, 0.0775602, 4133),
(898, 10096864, 0.0802901, 4134),
(898, 10096734, 0.0802059, 4135),
(898, 10096725, 0.0815091, 4136),
(898, 10096868, 0.081943, 4137),
(898, 10096833, 0.0879631, 4138),
(898, 10096823, 0.0794649, 4139),
(898, 10096694, 0.0799429, 4140),
(898, 10096825, 0.0877512, 4141),
(898, 10096704, 0.153192, 4142),
(898, 10096836, 0.0843589, 4143),
(898, 10096819, 0.0824101, 4144),
(898, 10096713, 0.143602, 4145),
(898, 10096829, 0.079972, 4146),
(898, 10096853, 0.078681, 4147),
(898, 10096831, 0.0877342, 4148),
(898, 10096821, 0.080441, 4149),
(898, 10096824, 0.211496, 4150),
(898, 10096699, 0.106888, 4151),
(898, 10096696, 0.0781181, 4152),
(898, 10096710, 0.138696, 4153),
(898, 10096717, 0.076088, 4154),
(898, 10096721, 0.0799532, 4155),
(898, 10096697, 0.0796371, 4156),
(898, 10096715, 0.082808, 4157),
(898, 10096818, 0.07833, 4158),
(898, 10096834, 0.080276, 4159),
(898, 10096720, 0.08126, 4160),
(898, 10096822, 0.0787969, 4161),
(898, 10096838, 0.090719, 4162),
(898, 10096714, 0.0860438, 4163),
(898, 10096827, 0.0813189, 4164),
(898, 10096703, 0.0878298, 4165),
(898, 10096701, 0.080008, 4166),
(898, 10096700, 0.0791621, 4167),
(898, 10096828, 0.0788188, 4168),
(898, 10096841, 0.0765021, 4169),
(898, 10096718, 0.0863678, 4170),
(898, 10096711, 0.087378, 4171),
(898, 10096692, 0.147653, 4172),
(898, 10096814, 0.082334, 4173),
(898, 10096706, 0.0803909, 4174),
(898, 10096719, 0.0840361, 4175),
(898, 10096705, 0.0780132, 4176),
(898, 10096698, 0.077843, 4177),
(898, 10096708, 0.0817149, 4178),
(898, 10096835, 0.0798261, 4179),
(898, 10096716, 0.145262, 4180),
(898, 10096840, 0.146672, 4181),
(898, 10096812, 0.091898, 4182),
(898, 10096695, 0.154498, 4183),
(898, 10096709, 0.081342, 4184),
(898, 10096830, 0.0839071, 4185),
(898, 10096712, 0.0794311, 4186),
(898, 10096817, 0.0768561, 4187),
(898, 10096816, 0.0785429, 4188),
(898, 10096815, 0.0845771, 4189),
(898, 10096693, 0.0788128, 4190),
(898, 10096813, 0.0756638, 4191),
(898, 10096832, 0.077028, 4192),
(898, 10096826, 0.0817919, 4193),
(898, 10096837, 0.087816, 4194),
(898, 10096839, 0.084554, 4195),
(898, 10096820, 0.0866411, 4196),
(898, 10096702, 0.0757391, 4197),
(898, 10096707, 0.084228, 4198),
(902, 10096896, 0.135796, 4199),
(902, 10096888, 0.132569, 4200),
(902, 10096898, 0.139918, 4201),
(902, 10096892, 0.120422, 4202),
(902, 10096899, 0.0755451, 4203),
(902, 10096897, 0.080039, 4204),
(902, 10096889, 0.0761571, 4205),
(902, 10096890, 0.12049, 4206),
(902, 10096887, 0.076638, 4207),
(902, 10096900, 0.076014, 4208),
(902, 10096894, 0.0808139, 4209),
(902, 10096893, 0.13033, 4210),
(902, 10096901, 0.127386, 4211),
(902, 10096895, 0.0758801, 4212),
(902, 10096891, 0.078501, 4213),
(902, 10096876, 0.0770221, 4214),
(902, 10096886, 0.0832748, 4215),
(902, 10096879, 0.143889, 4216),
(902, 10096882, 0.134557, 4217),
(902, 10096880, 0.143195, 4218),
(902, 10096878, 0.086576, 4219),
(902, 10096881, 0.079263, 4220),
(902, 10096877, 0.0769188, 4221),
(902, 10096873, 0.075624, 4222),
(902, 10096874, 0.077317, 4223),
(902, 10096872, 0.0781858, 4224),
(902, 10096883, 0.14019, 4225),
(902, 10096875, 0.075907, 4226),
(902, 10096885, 0.0754199, 4227),
(902, 10096884, 0.0807219, 4228),
(902, 10096900, 0.084754, 4229),
(902, 10096898, 0.138233, 4230),
(902, 10096888, 0.076663, 4231),
(902, 10096901, 0.125226, 4232),
(902, 10096892, 0.130803, 4233),
(902, 10096894, 0.128164, 4234),
(902, 10096895, 0.0756879, 4235),
(902, 10096890, 0.120754, 4236),
(902, 10096887, 0.0781679, 4237),
(902, 10096893, 0.0789421, 4238),
(902, 10096889, 0.0779719, 4239),
(902, 10096891, 0.122417, 4240),
(902, 10096896, 0.137432, 4241),
(902, 10096878, 0.0755022, 4242),
(902, 10096885, 0.0831668, 4243),
(902, 10096886, 0.0783319, 4244),
(902, 10096884, 0.0781991, 4245),
(902, 10096883, 0.0825398, 4246),
(902, 10096897, 0.077944, 4247),
(902, 10096879, 0.12131, 4248),
(902, 10096875, 0.143005, 4249),
(902, 10096872, 0.0766919, 4250),
(902, 10096881, 0.0757949, 4251),
(902, 10096873, 0.0764718, 4252),
(902, 10096874, 0.12608, 4253),
(902, 10096876, 0.0778301, 4254),
(902, 10096877, 0.0772932, 4255),
(902, 10096880, 0.076318, 4256),
(902, 10096882, 0.0760188, 4257),
(902, 10096899, 0.0757451, 4258),
(906, 10096918, 1.75446, 4259),
(906, 10096912, 2.18834, 4260),
(906, 10096920, 1.58336, 4261),
(906, 10096916, 2.06767, 4262),
(906, 10096911, 1.33192, 4263),
(906, 10096906, 1.10942, 4264),
(906, 10096923, 0.743374, 4265),
(906, 10096922, 0.676544, 4266),
(906, 10096913, 1.40961, 4267),
(906, 10096925, 1.05835, 4268),
(906, 10096908, 1.04623, 4269),
(906, 10096921, 0.863699, 4270),
(906, 10096915, 1.55302, 4271),
(906, 10096910, 1.01411, 4272),
(906, 10096914, 0.951023, 4273),
(906, 10096917, 0.741213, 4274),
(906, 10096924, 0.837933, 4275),
(906, 10096909, 1.33259, 4276),
(906, 10096919, 1.39977, 4277),
(906, 10096942, 1.28065, 4278),
(906, 10096943, 1.34559, 4279),
(906, 10096935, 1.58941, 4280),
(906, 10096940, 1.31781, 4281),
(906, 10096931, 0.762535, 4282),
(906, 10096945, 0.873673, 4283),
(906, 10096933, 1.12876, 4284),
(906, 10096905, 0.986957, 4285),
(906, 10096944, 1.54681, 4286),
(906, 10096930, 3.0691, 4287),
(906, 10096926, 1.72389, 4288),
(906, 10096929, 2.68788, 4289),
(906, 10096904, 2.53039, 4290),
(906, 10096907, 1.30934, 4291),
(906, 10096946, 1.11063, 4292),
(906, 10096903, 1.93823, 4293),
(906, 10096941, 1.88768, 4294),
(906, 10096934, 0.98465, 4295),
(906, 10096937, 1.05334, 4296);

-- --------------------------------------------------------

--
-- Table structure for table `recordings`
--

CREATE TABLE IF NOT EXISTS `recordings` (
`recording_id` bigint(20) unsigned NOT NULL,
  `site_id` int(10) unsigned NOT NULL,
  `uri` varchar(255) NOT NULL,
  `datetime` datetime NOT NULL,
  `mic` varchar(255) NOT NULL,
  `recorder` varchar(255) NOT NULL,
  `version` varchar(255) NOT NULL,
  `sample_rate` mediumint(8) unsigned DEFAULT NULL,
  `precision` tinyint(3) unsigned DEFAULT NULL,
  `duration` float DEFAULT NULL,
  `samples` bigint(20) unsigned DEFAULT NULL,
  `file_size` varchar(45) DEFAULT NULL,
  `bit_rate` varchar(45) DEFAULT NULL,
  `sample_encoding` varchar(45) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=10097579 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `recordings`
--

INSERT INTO `recordings` (`recording_id`, `site_id`, `uri`, `datetime`, `mic`, `recorder`, `version`, `sample_rate`, `precision`, `duration`, `samples`, `file_size`, `bit_rate`, `sample_encoding`) VALUES
(10096632, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-29.flac', '2010-12-14 10:29:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096633, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-28.flac', '2010-12-14 10:28:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096634, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-27.flac', '2010-12-14 10:27:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096635, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-26.flac', '2010-12-14 10:26:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096636, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-25.flac', '2010-12-14 10:25:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096637, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-24.flac', '2010-12-14 10:24:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096638, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-23.flac', '2010-12-14 10:23:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096639, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-22.flac', '2010-12-14 10:22:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096640, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-21.flac', '2010-12-14 10:21:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096641, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-20.flac', '2010-12-14 10:20:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096642, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-19.flac', '2010-12-14 10:19:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096643, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-18.flac', '2010-12-14 10:18:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096644, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-17.flac', '2010-12-14 10:17:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096645, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-16.flac', '2010-12-14 10:16:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096646, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-15.flac', '2010-12-14 10:15:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096647, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-14.flac', '2010-12-14 10:14:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096648, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-13.flac', '2010-12-14 10:13:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096649, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-12.flac', '2010-12-14 10:12:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096650, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-11.flac', '2010-12-14 10:11:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096651, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-10.flac', '2010-12-14 10:10:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096652, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-09.flac', '2010-12-14 10:09:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096653, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-08.flac', '2010-12-14 10:08:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096654, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-07.flac', '2010-12-14 10:07:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096655, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-06.flac', '2010-12-14 10:06:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096656, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-05.flac', '2010-12-14 10:05:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096657, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-04.flac', '2010-12-14 10:04:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096658, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-03.flac', '2010-12-14 10:03:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096659, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-02.flac', '2010-12-14 10:02:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096660, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-01.flac', '2010-12-14 10:01:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096661, 772, 'project_33/site_772/2010/12/rec-2010-12-14_10-00.flac', '2010-12-14 10:00:00', 'none', 'species generator', '1.1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096662, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-29.flac', '2010-12-14 00:29:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '470k', '376k', '24-bit FLAC'),
(10096663, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-28.flac', '2010-12-14 00:28:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '510k', '408k', '24-bit FLAC'),
(10096664, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-27.flac', '2010-12-14 00:27:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '453k', '362k', '24-bit FLAC'),
(10096665, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-26.flac', '2010-12-14 00:26:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '483k', '387k', '24-bit FLAC'),
(10096666, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-25.flac', '2010-12-14 00:25:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '482k', '385k', '24-bit FLAC'),
(10096667, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-24.flac', '2010-12-14 00:24:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '487k', '389k', '24-bit FLAC'),
(10096668, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-23.flac', '2010-12-14 00:23:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '495k', '396k', '24-bit FLAC'),
(10096669, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-22.flac', '2010-12-14 00:22:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '464k', '371k', '24-bit FLAC'),
(10096670, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-21.flac', '2010-12-14 00:21:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '516k', '413k', '24-bit FLAC'),
(10096671, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-20.flac', '2010-12-14 00:20:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '470k', '376k', '24-bit FLAC'),
(10096672, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-19.flac', '2010-12-14 00:19:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '464k', '371k', '24-bit FLAC'),
(10096673, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-18.flac', '2010-12-14 00:18:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '464k', '371k', '24-bit FLAC'),
(10096674, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-17.flac', '2010-12-14 00:17:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '472k', '377k', '24-bit FLAC'),
(10096675, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-16.flac', '2010-12-14 00:16:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '453k', '362k', '24-bit FLAC'),
(10096676, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-15.flac', '2010-12-14 00:15:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '476k', '380k', '24-bit FLAC'),
(10096677, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-14.flac', '2010-12-14 00:14:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '472k', '377k', '24-bit FLAC'),
(10096678, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-13.flac', '2010-12-14 00:13:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '475k', '380k', '24-bit FLAC'),
(10096679, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-12.flac', '2010-12-14 00:12:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '476k', '380k', '24-bit FLAC'),
(10096680, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-11.flac', '2010-12-14 00:11:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '475k', '380k', '24-bit FLAC'),
(10096681, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-10.flac', '2010-12-14 00:10:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '528k', '423k', '24-bit FLAC'),
(10096682, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-09.flac', '2010-12-14 00:09:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '476k', '381k', '24-bit FLAC'),
(10096683, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-08.flac', '2010-12-14 00:08:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '475k', '380k', '24-bit FLAC'),
(10096684, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-07.flac', '2010-12-14 00:07:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '476k', '380k', '24-bit FLAC'),
(10096685, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-06.flac', '2010-12-14 00:06:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '498k', '399k', '24-bit FLAC'),
(10096686, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-05.flac', '2010-12-14 00:05:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '453k', '362k', '24-bit FLAC'),
(10096687, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-04.flac', '2010-12-14 00:04:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '464k', '371k', '24-bit FLAC'),
(10096688, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-03.flac', '2010-12-14 00:03:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '493k', '395k', '24-bit FLAC'),
(10096689, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-02.flac', '2010-12-14 00:02:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '475k', '380k', '24-bit FLAC'),
(10096690, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-01.flac', '2010-12-14 00:01:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '468k', '375k', '24-bit FLAC'),
(10096691, 772, 'project_33/site_772/2010/12/rec-2010-12-14_00-00.flac', '2010-12-14 00:00:00', 'none', 'species generator', '1.1', 44100, 24, 10, 441000, '474k', '379k', '24-bit FLAC'),
(10096692, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-29.flac', '2010-12-14 10:29:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096693, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-28.flac', '2010-12-14 10:28:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096694, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-27.flac', '2010-12-14 10:27:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096695, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-26.flac', '2010-12-14 10:26:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096696, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-25.flac', '2010-12-14 10:25:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096697, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-24.flac', '2010-12-14 10:24:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096698, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-23.flac', '2010-12-14 10:23:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096699, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-22.flac', '2010-12-14 10:22:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096700, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-21.flac', '2010-12-14 10:21:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096701, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-20.flac', '2010-12-14 10:20:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096702, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-19.flac', '2010-12-14 10:19:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096703, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-18.flac', '2010-12-14 10:18:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096704, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-17.flac', '2010-12-14 10:17:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096705, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-16.flac', '2010-12-14 10:16:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096706, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-15.flac', '2010-12-14 10:15:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096707, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-14.flac', '2010-12-14 10:14:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096708, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-13.flac', '2010-12-14 10:13:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096709, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-12.flac', '2010-12-14 10:12:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096710, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-11.flac', '2010-12-14 10:11:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096711, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-10.flac', '2010-12-14 10:10:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096712, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-09.flac', '2010-12-14 10:09:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096713, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-08.flac', '2010-12-14 10:08:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096714, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-07.flac', '2010-12-14 10:07:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096715, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-06.flac', '2010-12-14 10:06:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096716, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-05.flac', '2010-12-14 10:05:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096717, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-04.flac', '2010-12-14 10:04:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096718, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-03.flac', '2010-12-14 10:03:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096719, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-02.flac', '2010-12-14 10:02:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096720, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-01.flac', '2010-12-14 10:01:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096721, 773, 'project_33/site_773/2010/12/rec-2010-12-14_10-00.flac', '2010-12-14 10:00:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096722, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-29.flac', '2010-12-14 00:29:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '551k', '441k', '24-bit FLAC'),
(10096723, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-28.flac', '2010-12-14 00:28:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '473k', '379k', '24-bit FLAC'),
(10096724, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-27.flac', '2010-12-14 00:27:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '466k', '373k', '24-bit FLAC'),
(10096725, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-26.flac', '2010-12-14 00:26:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '515k', '412k', '24-bit FLAC'),
(10096726, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-25.flac', '2010-12-14 00:25:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '506k', '405k', '24-bit FLAC'),
(10096727, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-24.flac', '2010-12-14 00:24:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '536k', '428k', '24-bit FLAC'),
(10096728, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-23.flac', '2010-12-14 00:23:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '511k', '409k', '24-bit FLAC'),
(10096729, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-22.flac', '2010-12-14 00:22:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '511k', '409k', '24-bit FLAC'),
(10096730, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-21.flac', '2010-12-14 00:21:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '478k', '383k', '24-bit FLAC'),
(10096731, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-20.flac', '2010-12-14 00:20:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '533k', '426k', '24-bit FLAC'),
(10096732, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-19.flac', '2010-12-14 00:19:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '496k', '397k', '24-bit FLAC'),
(10096733, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-18.flac', '2010-12-14 00:18:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '544k', '435k', '24-bit FLAC'),
(10096734, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-17.flac', '2010-12-14 00:17:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '557k', '446k', '24-bit FLAC'),
(10096735, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-16.flac', '2010-12-14 00:16:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '508k', '406k', '24-bit FLAC'),
(10096736, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-15.flac', '2010-12-14 00:15:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '507k', '406k', '24-bit FLAC'),
(10096737, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-14.flac', '2010-12-14 00:14:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '493k', '394k', '24-bit FLAC'),
(10096738, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-13.flac', '2010-12-14 00:13:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '511k', '409k', '24-bit FLAC'),
(10096739, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-12.flac', '2010-12-14 00:12:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '539k', '431k', '24-bit FLAC'),
(10096740, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-11.flac', '2010-12-14 00:11:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '543k', '434k', '24-bit FLAC'),
(10096741, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-10.flac', '2010-12-14 00:10:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '511k', '409k', '24-bit FLAC'),
(10096742, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-09.flac', '2010-12-14 00:09:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '511k', '409k', '24-bit FLAC'),
(10096743, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-08.flac', '2010-12-14 00:08:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '504k', '403k', '24-bit FLAC'),
(10096744, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-07.flac', '2010-12-14 00:07:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '496k', '397k', '24-bit FLAC'),
(10096745, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-06.flac', '2010-12-14 00:06:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '540k', '432k', '24-bit FLAC'),
(10096746, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-05.flac', '2010-12-14 00:05:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '511k', '409k', '24-bit FLAC'),
(10096747, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-04.flac', '2010-12-14 00:04:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '496k', '397k', '24-bit FLAC'),
(10096748, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-03.flac', '2010-12-14 00:03:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '506k', '405k', '24-bit FLAC'),
(10096749, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-02.flac', '2010-12-14 00:02:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '515k', '412k', '24-bit FLAC'),
(10096750, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-01.flac', '2010-12-14 00:01:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '543k', '434k', '24-bit FLAC'),
(10096751, 773, 'project_33/site_773/2010/12/rec-2010-12-14_00-00.flac', '2010-12-14 00:00:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '515k', '412k', '24-bit FLAC'),
(10096752, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-29.flac', '2010-12-14 10:29:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096753, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-28.flac', '2010-12-14 10:28:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096754, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-27.flac', '2010-12-14 10:27:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096755, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-26.flac', '2010-12-14 10:26:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096756, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-25.flac', '2010-12-14 10:25:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096757, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-24.flac', '2010-12-14 10:24:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096758, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-23.flac', '2010-12-14 10:23:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096759, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-22.flac', '2010-12-14 10:22:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096760, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-21.flac', '2010-12-14 10:21:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096761, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-20.flac', '2010-12-14 10:20:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096762, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-19.flac', '2010-12-14 10:19:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096763, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-18.flac', '2010-12-14 10:18:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096764, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-17.flac', '2010-12-14 10:17:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096765, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-16.flac', '2010-12-14 10:16:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096766, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-15.flac', '2010-12-14 10:15:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096767, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-14.flac', '2010-12-14 10:14:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096768, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-13.flac', '2010-12-14 10:13:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096769, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-12.flac', '2010-12-14 10:12:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096770, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-11.flac', '2010-12-14 10:11:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096771, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-10.flac', '2010-12-14 10:10:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096772, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-09.flac', '2010-12-14 10:09:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096773, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-08.flac', '2010-12-14 10:08:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096774, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-07.flac', '2010-12-14 10:07:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096775, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-06.flac', '2010-12-14 10:06:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096776, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-05.flac', '2010-12-14 10:05:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096777, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-04.flac', '2010-12-14 10:04:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096778, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-03.flac', '2010-12-14 10:03:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096779, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-02.flac', '2010-12-14 10:02:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096780, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-01.flac', '2010-12-14 10:01:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096781, 774, 'project_33/site_774/2010/12/rec-2010-12-14_10-00.flac', '2010-12-14 10:00:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096782, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-29.flac', '2010-12-14 00:29:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '500k', '400k', '24-bit FLAC'),
(10096783, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-28.flac', '2010-12-14 00:28:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '478k', '382k', '24-bit FLAC'),
(10096784, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-27.flac', '2010-12-14 00:27:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '463k', '371k', '24-bit FLAC'),
(10096785, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-26.flac', '2010-12-14 00:26:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '471k', '377k', '24-bit FLAC'),
(10096786, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-25.flac', '2010-12-14 00:25:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '507k', '406k', '24-bit FLAC'),
(10096787, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-24.flac', '2010-12-14 00:24:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '502k', '402k', '24-bit FLAC'),
(10096788, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-23.flac', '2010-12-14 00:23:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '449k', '359k', '24-bit FLAC'),
(10096789, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-22.flac', '2010-12-14 00:22:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '453k', '362k', '24-bit FLAC'),
(10096790, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-21.flac', '2010-12-14 00:21:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '463k', '371k', '24-bit FLAC'),
(10096791, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-20.flac', '2010-12-14 00:20:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '449k', '359k', '24-bit FLAC'),
(10096792, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-19.flac', '2010-12-14 00:19:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '449k', '359k', '24-bit FLAC'),
(10096793, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-18.flac', '2010-12-14 00:18:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '477k', '381k', '24-bit FLAC'),
(10096794, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-17.flac', '2010-12-14 00:17:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '471k', '377k', '24-bit FLAC'),
(10096795, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-16.flac', '2010-12-14 00:16:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '467k', '374k', '24-bit FLAC'),
(10096796, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-15.flac', '2010-12-14 00:15:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '463k', '371k', '24-bit FLAC'),
(10096797, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-14.flac', '2010-12-14 00:14:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '449k', '359k', '24-bit FLAC'),
(10096798, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-13.flac', '2010-12-14 00:13:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '478k', '382k', '24-bit FLAC'),
(10096799, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-12.flac', '2010-12-14 00:12:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '507k', '406k', '24-bit FLAC'),
(10096800, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-11.flac', '2010-12-14 00:11:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '449k', '359k', '24-bit FLAC'),
(10096801, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-10.flac', '2010-12-14 00:10:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '482k', '385k', '24-bit FLAC'),
(10096802, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-09.flac', '2010-12-14 00:09:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '449k', '359k', '24-bit FLAC'),
(10096803, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-08.flac', '2010-12-14 00:08:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '449k', '359k', '24-bit FLAC'),
(10096804, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-07.flac', '2010-12-14 00:07:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '492k', '394k', '24-bit FLAC'),
(10096805, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-06.flac', '2010-12-14 00:06:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '458k', '367k', '24-bit FLAC'),
(10096806, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-05.flac', '2010-12-14 00:05:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '456k', '365k', '24-bit FLAC'),
(10096807, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-04.flac', '2010-12-14 00:04:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '449k', '359k', '24-bit FLAC'),
(10096808, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-03.flac', '2010-12-14 00:03:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '514k', '411k', '24-bit FLAC'),
(10096809, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-02.flac', '2010-12-14 00:02:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '491k', '393k', '24-bit FLAC'),
(10096810, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-01.flac', '2010-12-14 00:01:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '507k', '406k', '24-bit FLAC'),
(10096811, 774, 'project_33/site_774/2010/12/rec-2010-12-14_00-00.flac', '2010-12-14 00:00:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '456k', '365k', '24-bit FLAC'),
(10096812, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-29.flac', '2010-12-14 10:29:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096813, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-28.flac', '2010-12-14 10:28:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096814, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-27.flac', '2010-12-14 10:27:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096815, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-26.flac', '2010-12-14 10:26:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096816, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-25.flac', '2010-12-14 10:25:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096817, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-24.flac', '2010-12-14 10:24:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096818, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-23.flac', '2010-12-14 10:23:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096819, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-22.flac', '2010-12-14 10:22:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096820, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-21.flac', '2010-12-14 10:21:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096821, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-20.flac', '2010-12-14 10:20:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096822, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-19.flac', '2010-12-14 10:19:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096823, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-18.flac', '2010-12-14 10:18:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096824, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-17.flac', '2010-12-14 10:17:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096825, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-16.flac', '2010-12-14 10:16:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096826, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-15.flac', '2010-12-14 10:15:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096827, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-14.flac', '2010-12-14 10:14:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096828, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-13.flac', '2010-12-14 10:13:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096829, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-12.flac', '2010-12-14 10:12:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096830, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-11.flac', '2010-12-14 10:11:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096831, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-10.flac', '2010-12-14 10:10:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096832, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-09.flac', '2010-12-14 10:09:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096833, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-08.flac', '2010-12-14 10:08:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096834, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-07.flac', '2010-12-14 10:07:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096835, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-06.flac', '2010-12-14 10:06:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096836, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-05.flac', '2010-12-14 10:05:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096837, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-04.flac', '2010-12-14 10:04:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096838, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-03.flac', '2010-12-14 10:03:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096839, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-02.flac', '2010-12-14 10:02:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096840, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-01.flac', '2010-12-14 10:01:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096841, 775, 'project_33/site_775/2010/12/rec-2010-12-14_10-00.flac', '2010-12-14 10:00:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096842, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-29.flac', '2010-12-14 00:29:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '583k', '466k', '24-bit FLAC'),
(10096843, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-28.flac', '2010-12-14 00:28:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '502k', '401k', '24-bit FLAC'),
(10096844, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-27.flac', '2010-12-14 00:27:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '487k', '390k', '24-bit FLAC'),
(10096845, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-26.flac', '2010-12-14 00:26:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '535k', '428k', '24-bit FLAC'),
(10096846, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-25.flac', '2010-12-14 00:25:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '570k', '456k', '24-bit FLAC'),
(10096847, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-24.flac', '2010-12-14 00:24:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '570k', '456k', '24-bit FLAC'),
(10096848, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-23.flac', '2010-12-14 00:23:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '517k', '414k', '24-bit FLAC'),
(10096849, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-22.flac', '2010-12-14 00:22:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '510k', '408k', '24-bit FLAC'),
(10096850, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-21.flac', '2010-12-14 00:21:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '492k', '394k', '24-bit FLAC'),
(10096851, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-20.flac', '2010-12-14 00:20:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '532k', '426k', '24-bit FLAC'),
(10096852, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-19.flac', '2010-12-14 00:19:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '503k', '402k', '24-bit FLAC'),
(10096853, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-18.flac', '2010-12-14 00:18:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '567k', '453k', '24-bit FLAC'),
(10096854, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-17.flac', '2010-12-14 00:17:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '578k', '462k', '24-bit FLAC'),
(10096855, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-16.flac', '2010-12-14 00:16:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '525k', '420k', '24-bit FLAC'),
(10096856, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-15.flac', '2010-12-14 00:15:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '525k', '420k', '24-bit FLAC'),
(10096857, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-14.flac', '2010-12-14 00:14:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '499k', '400k', '24-bit FLAC'),
(10096858, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-13.flac', '2010-12-14 00:13:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '539k', '431k', '24-bit FLAC'),
(10096859, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-12.flac', '2010-12-14 00:12:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '588k', '471k', '24-bit FLAC'),
(10096860, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-11.flac', '2010-12-14 00:11:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '549k', '439k', '24-bit FLAC'),
(10096861, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-10.flac', '2010-12-14 00:10:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '543k', '434k', '24-bit FLAC'),
(10096862, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-09.flac', '2010-12-14 00:09:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '517k', '414k', '24-bit FLAC'),
(10096863, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-08.flac', '2010-12-14 00:08:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '507k', '405k', '24-bit FLAC'),
(10096864, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-07.flac', '2010-12-14 00:07:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '539k', '431k', '24-bit FLAC'),
(10096865, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-06.flac', '2010-12-14 00:06:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '556k', '445k', '24-bit FLAC'),
(10096866, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-05.flac', '2010-12-14 00:05:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '525k', '420k', '24-bit FLAC'),
(10096867, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-04.flac', '2010-12-14 00:04:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '496k', '397k', '24-bit FLAC'),
(10096868, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-03.flac', '2010-12-14 00:03:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '577k', '462k', '24-bit FLAC'),
(10096869, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-02.flac', '2010-12-14 00:02:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '542k', '433k', '24-bit FLAC'),
(10096870, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-01.flac', '2010-12-14 00:01:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '585k', '468k', '24-bit FLAC'),
(10096871, 775, 'project_33/site_775/2010/12/rec-2010-12-14_00-00.flac', '2010-12-14 00:00:00', '1', 'species generator', '1', 44100, 24, 10, 441000, '521k', '417k', '24-bit FLAC'),
(10096872, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-29.flac', '2010-12-14 10:29:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096873, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-28.flac', '2010-12-14 10:28:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096874, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-27.flac', '2010-12-14 10:27:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096875, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-26.flac', '2010-12-14 10:26:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096876, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-25.flac', '2010-12-14 10:25:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096877, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-24.flac', '2010-12-14 10:24:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096878, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-23.flac', '2010-12-14 10:23:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096879, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-22.flac', '2010-12-14 10:22:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096880, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-21.flac', '2010-12-14 10:21:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096881, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-20.flac', '2010-12-14 10:20:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096882, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-19.flac', '2010-12-14 10:19:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096883, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-18.flac', '2010-12-14 10:18:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096884, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-17.flac', '2010-12-14 10:17:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096885, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-16.flac', '2010-12-14 10:16:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096886, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-15.flac', '2010-12-14 10:15:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096887, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-14.flac', '2010-12-14 10:14:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096888, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-13.flac', '2010-12-14 10:13:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096889, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-12.flac', '2010-12-14 10:12:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096890, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-11.flac', '2010-12-14 10:11:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096891, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-10.flac', '2010-12-14 10:10:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096892, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-09.flac', '2010-12-14 10:09:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096893, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-08.flac', '2010-12-14 10:08:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096894, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-07.flac', '2010-12-14 10:07:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096895, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-06.flac', '2010-12-14 10:06:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096896, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-05.flac', '2010-12-14 10:05:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096897, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-04.flac', '2010-12-14 10:04:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096898, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-03.flac', '2010-12-14 10:03:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096899, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-02.flac', '2010-12-14 10:02:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096900, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-01.flac', '2010-12-14 10:01:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096901, 776, 'project_33/site_776/2010/12/rec-2010-12-14_10-00.flac', '2010-12-14 10:00:00', '1', 'species generator', '1', 44100, 16, 10, 441000, '441k', '353k', '16-bit FLAC'),
(10096902, 777, 'project_33/site_777/2015/1/carite1-2015-01-02_19-40.flac', '2015-01-02 19:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.93M', '256k', '16-bit FLAC'),
(10096903, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_14-50.flac', '2014-10-18 14:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.63M', '349k', '16-bit FLAC'),
(10096904, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_15-00.flac', '2014-10-18 15:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.64M', '350k', '16-bit FLAC'),
(10096905, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_15-20.flac', '2014-10-18 15:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.63M', '349k', '16-bit FLAC'),
(10096906, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_15-40.flac', '2014-10-18 15:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.64M', '351k', '16-bit FLAC');
INSERT INTO `recordings` (`recording_id`, `site_id`, `uri`, `datetime`, `mic`, `recorder`, `version`, `sample_rate`, `precision`, `duration`, `samples`, `file_size`, `bit_rate`, `sample_encoding`) VALUES
(10096907, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_16-00.flac', '2014-10-18 16:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.65M', '351k', '16-bit FLAC'),
(10096908, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_16-40.flac', '2014-10-18 16:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.65M', '352k', '16-bit FLAC'),
(10096909, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_17-10.flac', '2014-10-18 17:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.65M', '352k', '16-bit FLAC'),
(10096910, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_17-40.flac', '2014-10-18 17:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.41M', '320k', '16-bit FLAC'),
(10096911, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_18-10.flac', '2014-10-18 18:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.56M', '341k', '16-bit FLAC'),
(10096912, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_18-20.flac', '2014-10-18 18:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.58M', '343k', '16-bit FLAC'),
(10096913, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_18-30.flac', '2014-10-18 18:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.60M', '345k', '16-bit FLAC'),
(10096914, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_19-10.flac', '2014-10-18 19:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.66M', '353k', '16-bit FLAC'),
(10096915, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_19-20.flac', '2014-10-18 19:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.67M', '355k', '16-bit FLAC'),
(10096916, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_19-30.flac', '2014-10-18 19:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.67M', '355k', '16-bit FLAC'),
(10096917, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_19-40.flac', '2014-10-18 19:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.68M', '355k', '16-bit FLAC'),
(10096918, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_20-00.flac', '2014-10-18 20:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.68M', '356k', '16-bit FLAC'),
(10096919, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_20-10.flac', '2014-10-18 20:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.68M', '356k', '16-bit FLAC'),
(10096920, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_20-20.flac', '2014-10-18 20:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.68M', '356k', '16-bit FLAC'),
(10096921, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_20-40.flac', '2014-10-18 20:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.68M', '356k', '16-bit FLAC'),
(10096922, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_21-00.flac', '2014-10-18 21:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.68M', '356k', '16-bit FLAC'),
(10096923, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_21-20.flac', '2014-10-18 21:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.67M', '355k', '16-bit FLAC'),
(10096924, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-18_21-40.flac', '2014-10-18 21:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.67M', '355k', '16-bit FLAC'),
(10096925, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-19_05-40.flac', '2014-10-19 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.69M', '357k', '16-bit FLAC'),
(10096926, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-19_07-50.flac', '2014-10-19 07:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.67M', '354k', '16-bit FLAC'),
(10096927, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-19_08-00.flac', '2014-10-19 08:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.67M', '355k', '16-bit FLAC'),
(10096928, 777, 'project_33/site_777/2014/10/lascasa_2-2014-10-19_08-50.flac', '2014-10-19 08:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.67M', '355k', '16-bit FLAC'),
(10096929, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_13-00.flac', '2014-10-18 13:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.70M', '225k', '16-bit FLAC'),
(10096930, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_13-10.flac', '2014-10-18 13:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10096931, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_13-20.flac', '2014-10-18 13:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10096932, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_13-30.flac', '2014-10-18 13:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.70M', '225k', '16-bit FLAC'),
(10096933, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_13-40.flac', '2014-10-18 13:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.70M', '226k', '16-bit FLAC'),
(10096934, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_13-50.flac', '2014-10-18 13:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10096935, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_14-30.flac', '2014-10-18 14:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10096936, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_15-10.flac', '2014-10-18 15:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10096937, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_17-30.flac', '2014-10-18 17:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10096938, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_19-30.flac', '2014-10-18 19:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.97M', '262k', '16-bit FLAC'),
(10096939, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_20-40.flac', '2014-10-18 20:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.97M', '262k', '16-bit FLAC'),
(10096940, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_20-50.flac', '2014-10-18 20:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.97M', '261k', '16-bit FLAC'),
(10096941, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_21-30.flac', '2014-10-18 21:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.95M', '259k', '16-bit FLAC'),
(10096942, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_23-40.flac', '2014-10-18 23:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.94M', '257k', '16-bit FLAC'),
(10096943, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-18_23-50.flac', '2014-10-18 23:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.93M', '256k', '16-bit FLAC'),
(10096944, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-19_02-30.flac', '2014-10-19 02:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.91M', '253k', '16-bit FLAC'),
(10096945, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-19_03-30.flac', '2014-10-19 03:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.90M', '253k', '16-bit FLAC'),
(10096946, 777, 'project_33/site_777/2014/10/lascasas_1-2014-10-19_05-30.flac', '2014-10-19 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.91M', '253k', '16-bit FLAC'),
(10096947, 778, 'project_33/site_778/2012/12/Mona_DSG_1014-2012-12-29_07-25.flac', '2012-12-29 07:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '191k', '73.1k', '16-bit FLAC'),
(10096948, 778, 'project_33/site_778/2012/12/Mona_DSG_1014-2012-12-31_20-20.flac', '2012-12-31 20:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '75.9k', '16-bit FLAC'),
(10096949, 778, 'project_33/site_778/2012/12/Mona_DSG_1014-2012-12-31_22-10.flac', '2012-12-31 22:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '204k', '77.9k', '16-bit FLAC'),
(10096950, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-03_07-25.flac', '2013-01-03 07:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '198k', '75.7k', '16-bit FLAC'),
(10096951, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-08_14-05.flac', '2013-01-08 14:05:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '205k', '78.3k', '16-bit FLAC'),
(10096952, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-08_14-10.flac', '2013-01-08 14:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '207k', '79.3k', '16-bit FLAC'),
(10096953, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-08_14-15.flac', '2013-01-08 14:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '207k', '79.0k', '16-bit FLAC'),
(10096954, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_14-10.flac', '2013-01-10 14:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '203k', '77.7k', '16-bit FLAC'),
(10096955, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_14-15.flac', '2013-01-10 14:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '207k', '79.1k', '16-bit FLAC'),
(10096956, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_14-25.flac', '2013-01-10 14:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '204k', '78.1k', '16-bit FLAC'),
(10096957, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_14-35.flac', '2013-01-10 14:35:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '202k', '77.4k', '16-bit FLAC'),
(10096958, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_14-40.flac', '2013-01-10 14:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '202k', '77.3k', '16-bit FLAC'),
(10096959, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_14-45.flac', '2013-01-10 14:45:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '203k', '77.3k', '16-bit FLAC'),
(10096960, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_14-50.flac', '2013-01-10 14:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '205k', '78.4k', '16-bit FLAC'),
(10096961, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_14-55.flac', '2013-01-10 14:55:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '203k', '77.7k', '16-bit FLAC'),
(10096962, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_15-00.flac', '2013-01-10 15:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '206k', '78.7k', '16-bit FLAC'),
(10096963, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_15-05.flac', '2013-01-10 15:05:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '205k', '78.4k', '16-bit FLAC'),
(10096964, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_15-15.flac', '2013-01-10 15:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '213k', '81.3k', '16-bit FLAC'),
(10096965, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-10_15-20.flac', '2013-01-10 15:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '206k', '78.7k', '16-bit FLAC'),
(10096966, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-17_13-30.flac', '2013-01-17 13:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.8k', '16-bit FLAC'),
(10096967, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-17_13-35.flac', '2013-01-17 13:35:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.3k', '16-bit FLAC'),
(10096968, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-17_13-50.flac', '2013-01-17 13:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '192k', '73.4k', '16-bit FLAC'),
(10096969, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-17_13-55.flac', '2013-01-17 13:55:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.5k', '16-bit FLAC'),
(10096970, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-17_14-10.flac', '2013-01-17 14:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '189k', '72.1k', '16-bit FLAC'),
(10096971, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-17_14-15.flac', '2013-01-17 14:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '189k', '72.3k', '16-bit FLAC'),
(10096972, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-17_14-25.flac', '2013-01-17 14:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '190k', '72.5k', '16-bit FLAC'),
(10096973, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-18_18-10.flac', '2013-01-18 18:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '189k', '72.0k', '16-bit FLAC'),
(10096974, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-25_22-20.flac', '2013-01-25 22:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '204k', '78.0k', '16-bit FLAC'),
(10096975, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_02-35.flac', '2013-01-26 02:35:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '201k', '76.6k', '16-bit FLAC'),
(10096976, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_03-40.flac', '2013-01-26 03:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '76.1k', '16-bit FLAC'),
(10096977, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_03-50.flac', '2013-01-26 03:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '202k', '77.0k', '16-bit FLAC'),
(10096978, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_03-55.flac', '2013-01-26 03:55:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '200k', '76.2k', '16-bit FLAC'),
(10096979, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_04-00.flac', '2013-01-26 04:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '203k', '77.6k', '16-bit FLAC'),
(10096980, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_04-10.flac', '2013-01-26 04:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '76.2k', '16-bit FLAC'),
(10096981, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_04-15.flac', '2013-01-26 04:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '202k', '77.1k', '16-bit FLAC'),
(10096982, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_04-20.flac', '2013-01-26 04:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '198k', '75.7k', '16-bit FLAC'),
(10096983, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_04-35.flac', '2013-01-26 04:35:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '199k', '75.7k', '16-bit FLAC'),
(10096984, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_04-40.flac', '2013-01-26 04:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '198k', '75.7k', '16-bit FLAC'),
(10096985, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_04-50.flac', '2013-01-26 04:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '75.0k', '16-bit FLAC'),
(10096986, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_05-00.flac', '2013-01-26 05:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.2k', '16-bit FLAC'),
(10096987, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_05-10.flac', '2013-01-26 05:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '74.7k', '16-bit FLAC'),
(10096988, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_05-15.flac', '2013-01-26 05:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '76.0k', '16-bit FLAC'),
(10096989, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_05-20.flac', '2013-01-26 05:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.6k', '16-bit FLAC'),
(10096990, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_05-25.flac', '2013-01-26 05:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.4k', '16-bit FLAC'),
(10096991, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_05-30.flac', '2013-01-26 05:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '75.9k', '16-bit FLAC'),
(10096992, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_05-50.flac', '2013-01-26 05:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '74.9k', '16-bit FLAC'),
(10096993, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_06-10.flac', '2013-01-26 06:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.3k', '16-bit FLAC'),
(10096994, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_06-15.flac', '2013-01-26 06:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.5k', '16-bit FLAC'),
(10096995, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_06-30.flac', '2013-01-26 06:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.2k', '16-bit FLAC'),
(10096996, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_06-40.flac', '2013-01-26 06:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.3k', '16-bit FLAC'),
(10096997, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_06-55.flac', '2013-01-26 06:55:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '74.8k', '16-bit FLAC'),
(10096998, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_07-00.flac', '2013-01-26 07:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.2k', '16-bit FLAC'),
(10096999, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_07-10.flac', '2013-01-26 07:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '74.8k', '16-bit FLAC'),
(10097000, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_07-30.flac', '2013-01-26 07:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '74.7k', '16-bit FLAC'),
(10097001, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_11-00.flac', '2013-01-26 11:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '206k', '78.6k', '16-bit FLAC'),
(10097002, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_18-55.flac', '2013-01-26 18:55:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '192k', '73.3k', '16-bit FLAC'),
(10097003, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_19-05.flac', '2013-01-26 19:05:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '191k', '73.1k', '16-bit FLAC'),
(10097004, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_19-15.flac', '2013-01-26 19:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.2k', '16-bit FLAC'),
(10097005, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_19-40.flac', '2013-01-26 19:40:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '192k', '73.1k', '16-bit FLAC'),
(10097006, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_19-50.flac', '2013-01-26 19:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '74.7k', '16-bit FLAC'),
(10097007, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_20-00.flac', '2013-01-26 20:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.1k', '16-bit FLAC'),
(10097008, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_20-10.flac', '2013-01-26 20:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.1k', '16-bit FLAC'),
(10097009, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_20-15.flac', '2013-01-26 20:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.2k', '16-bit FLAC'),
(10097010, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_20-30.flac', '2013-01-26 20:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.2k', '16-bit FLAC'),
(10097011, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_20-35.flac', '2013-01-26 20:35:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '76.0k', '16-bit FLAC'),
(10097012, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_20-45.flac', '2013-01-26 20:45:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '198k', '75.3k', '16-bit FLAC'),
(10097013, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_20-50.flac', '2013-01-26 20:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '198k', '75.6k', '16-bit FLAC'),
(10097014, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_20-55.flac', '2013-01-26 20:55:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '198k', '75.8k', '16-bit FLAC'),
(10097015, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_21-15.flac', '2013-01-26 21:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '201k', '76.8k', '16-bit FLAC'),
(10097016, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_21-20.flac', '2013-01-26 21:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '200k', '76.3k', '16-bit FLAC'),
(10097017, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_21-35.flac', '2013-01-26 21:35:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '201k', '76.7k', '16-bit FLAC'),
(10097018, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_21-45.flac', '2013-01-26 21:45:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '201k', '76.9k', '16-bit FLAC'),
(10097019, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_22-15.flac', '2013-01-26 22:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '204k', '78.0k', '16-bit FLAC'),
(10097020, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_22-25.flac', '2013-01-26 22:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '206k', '78.6k', '16-bit FLAC'),
(10097021, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_22-30.flac', '2013-01-26 22:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '204k', '78.0k', '16-bit FLAC'),
(10097022, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_22-50.flac', '2013-01-26 22:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '203k', '77.7k', '16-bit FLAC'),
(10097023, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_23-20.flac', '2013-01-26 23:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '75.9k', '16-bit FLAC'),
(10097024, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_23-40.flac', '2013-01-26 23:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '198k', '75.5k', '16-bit FLAC'),
(10097025, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-26_23-45.flac', '2013-01-26 23:45:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.7k', '16-bit FLAC'),
(10097026, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-27_03-20.flac', '2013-01-27 03:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '185k', '70.8k', '16-bit FLAC'),
(10097027, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-27_07-55.flac', '2013-01-27 07:55:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '187k', '71.3k', '16-bit FLAC'),
(10097028, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-29_07-20.flac', '2013-01-29 07:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.0k', '16-bit FLAC'),
(10097029, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-29_11-20.flac', '2013-01-29 11:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '202k', '77.0k', '16-bit FLAC'),
(10097030, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-29_19-10.flac', '2013-01-29 19:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '189k', '72.1k', '16-bit FLAC'),
(10097031, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_02-50.flac', '2013-01-30 02:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '201k', '76.9k', '16-bit FLAC'),
(10097032, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_03-15.flac', '2013-01-30 03:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '201k', '76.6k', '16-bit FLAC'),
(10097033, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_03-35.flac', '2013-01-30 03:35:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '75.9k', '16-bit FLAC'),
(10097034, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_03-45.flac', '2013-01-30 03:45:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '76.0k', '16-bit FLAC'),
(10097035, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_04-00.flac', '2013-01-30 04:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.7k', '16-bit FLAC'),
(10097036, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_04-05.flac', '2013-01-30 04:05:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.7k', '16-bit FLAC'),
(10097037, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_04-10.flac', '2013-01-30 04:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.2k', '16-bit FLAC'),
(10097038, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_04-20.flac', '2013-01-30 04:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.6k', '16-bit FLAC'),
(10097039, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_04-40.flac', '2013-01-30 04:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.1k', '16-bit FLAC'),
(10097040, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_04-55.flac', '2013-01-30 04:55:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.6k', '16-bit FLAC'),
(10097041, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_05-05.flac', '2013-01-30 05:05:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.9k', '16-bit FLAC'),
(10097042, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_05-40.flac', '2013-01-30 05:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.2k', '16-bit FLAC'),
(10097043, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_07-45.flac', '2013-01-30 07:45:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '190k', '72.6k', '16-bit FLAC'),
(10097044, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-30_18-50.flac', '2013-01-30 18:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '192k', '73.3k', '16-bit FLAC'),
(10097045, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_02-45.flac', '2013-01-31 02:45:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '206k', '78.7k', '16-bit FLAC'),
(10097046, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_03-05.flac', '2013-01-31 03:05:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '206k', '78.8k', '16-bit FLAC'),
(10097047, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_03-15.flac', '2013-01-31 03:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '204k', '77.8k', '16-bit FLAC'),
(10097048, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_03-25.flac', '2013-01-31 03:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '208k', '79.3k', '16-bit FLAC'),
(10097049, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_03-40.flac', '2013-01-31 03:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '210k', '80.0k', '16-bit FLAC'),
(10097050, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_03-45.flac', '2013-01-31 03:45:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '210k', '79.8k', '16-bit FLAC'),
(10097051, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_03-50.flac', '2013-01-31 03:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '207k', '79.3k', '16-bit FLAC'),
(10097052, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_08-05.flac', '2013-01-31 08:05:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.5k', '16-bit FLAC'),
(10097053, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_09-35.flac', '2013-01-31 09:35:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '74.8k', '16-bit FLAC'),
(10097054, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_11-30.flac', '2013-01-31 11:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.3k', '16-bit FLAC'),
(10097055, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_11-35.flac', '2013-01-31 11:35:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.6k', '16-bit FLAC'),
(10097056, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_11-40.flac', '2013-01-31 11:40:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '195k', '74.5k', '16-bit FLAC'),
(10097057, 778, 'project_33/site_778/2013/1/Mona_DSG_1014-2013-01-31_12-15.flac', '2013-01-31 12:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.8k', '16-bit FLAC'),
(10097058, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_12-40.flac', '2013-02-06 12:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.3k', '16-bit FLAC'),
(10097059, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_12-45.flac', '2013-02-06 12:45:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.0k', '16-bit FLAC'),
(10097060, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_12-50.flac', '2013-02-06 12:50:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.8k', '16-bit FLAC'),
(10097061, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_13-00.flac', '2013-02-06 13:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.8k', '16-bit FLAC'),
(10097062, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_13-05.flac', '2013-02-06 13:05:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.8k', '16-bit FLAC'),
(10097063, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_13-10.flac', '2013-02-06 13:10:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '194k', '73.9k', '16-bit FLAC'),
(10097064, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_13-15.flac', '2013-02-06 13:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.8k', '16-bit FLAC'),
(10097065, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_13-20.flac', '2013-02-06 13:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.2k', '16-bit FLAC'),
(10097066, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_13-25.flac', '2013-02-06 13:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '192k', '73.3k', '16-bit FLAC'),
(10097067, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-06_13-30.flac', '2013-02-06 13:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.8k', '16-bit FLAC'),
(10097068, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-18_01-10.flac', '2013-02-18 01:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '189k', '72.1k', '16-bit FLAC'),
(10097069, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-18_02-05.flac', '2013-02-18 02:05:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '190k', '72.6k', '16-bit FLAC'),
(10097070, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-18_03-00.flac', '2013-02-18 03:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '190k', '72.7k', '16-bit FLAC'),
(10097071, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-20_00-00.flac', '2013-02-20 00:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '199k', '76.0k', '16-bit FLAC'),
(10097072, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-20_03-20.flac', '2013-02-20 03:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.6k', '16-bit FLAC'),
(10097073, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-20_11-25.flac', '2013-02-20 11:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '200k', '76.5k', '16-bit FLAC'),
(10097074, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-20_14-20.flac', '2013-02-20 14:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '192k', '73.4k', '16-bit FLAC'),
(10097075, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-20_21-00.flac', '2013-02-20 21:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '202k', '77.0k', '16-bit FLAC'),
(10097076, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-24_10-30.flac', '2013-02-24 10:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '200k', '76.3k', '16-bit FLAC'),
(10097077, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-24_18-40.flac', '2013-02-24 18:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '187k', '71.3k', '16-bit FLAC'),
(10097078, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-26_04-55.flac', '2013-02-26 04:55:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '190k', '72.8k', '16-bit FLAC'),
(10097079, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-26_05-15.flac', '2013-02-26 05:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '189k', '72.3k', '16-bit FLAC'),
(10097080, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-27_04-15.flac', '2013-02-27 04:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '193k', '73.7k', '16-bit FLAC'),
(10097081, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-27_05-00.flac', '2013-02-27 05:00:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '196k', '74.5k', '16-bit FLAC'),
(10097082, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-27_06-30.flac', '2013-02-27 06:30:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.0k', '16-bit FLAC'),
(10097083, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-27_08-10.flac', '2013-02-27 08:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '192k', '73.2k', '16-bit FLAC'),
(10097084, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-27_08-25.flac', '2013-02-27 08:25:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '199k', '75.9k', '16-bit FLAC'),
(10097085, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-27_22-40.flac', '2013-02-27 22:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '205k', '78.2k', '16-bit FLAC'),
(10097086, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_05-00.flac', '2013-02-28 05:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '75.0k', '16-bit FLAC'),
(10097087, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_05-10.flac', '2013-02-28 05:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '198k', '75.8k', '16-bit FLAC'),
(10097088, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_05-25.flac', '2013-02-28 05:25:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '196k', '74.8k', '16-bit FLAC'),
(10097089, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_05-40.flac', '2013-02-28 05:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '195k', '74.3k', '16-bit FLAC'),
(10097090, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_06-00.flac', '2013-02-28 06:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '189k', '72.1k', '16-bit FLAC'),
(10097091, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_06-30.flac', '2013-02-28 06:30:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '192k', '73.3k', '16-bit FLAC'),
(10097092, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_06-40.flac', '2013-02-28 06:40:00', 'u', 'u', 'u', 10000, 16, 20.99, 209920, '196k', '74.9k', '16-bit FLAC'),
(10097093, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_10-00.flac', '2013-02-28 10:00:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.4k', '16-bit FLAC'),
(10097094, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_10-20.flac', '2013-02-28 10:20:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '202k', '77.1k', '16-bit FLAC'),
(10097095, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_18-10.flac', '2013-02-28 18:10:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '194k', '74.3k', '16-bit FLAC'),
(10097096, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_20-40.flac', '2013-02-28 20:40:00', 'u', 'u', 'u', 10000, 16, 21.04, 210432, '196k', '74.6k', '16-bit FLAC'),
(10097097, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_21-40.flac', '2013-02-28 21:40:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '197k', '75.2k', '16-bit FLAC'),
(10097098, 778, 'project_33/site_778/2013/2/Mona_DSG_1014-2013-02-28_22-15.flac', '2013-02-28 22:15:00', 'u', 'u', 'u', 10000, 16, 20.94, 209408, '203k', '77.4k', '16-bit FLAC'),
(10097099, 779, 'project_33/site_779/2015/2/100B-2015-02-01_05-40.flac', '2015-02-01 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.80M', '239k', '16-bit FLAC'),
(10097100, 779, 'project_33/site_779/2015/2/100B-2015-02-02_05-40.flac', '2015-02-02 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10097101, 779, 'project_33/site_779/2015/2/100B-2015-02-02_06-10.flac', '2015-02-02 06:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097102, 779, 'project_33/site_779/2015/2/100N-2015-02-05_05-50.flac', '2015-02-05 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.84M', '245k', '16-bit FLAC'),
(10097103, 779, 'project_33/site_779/2015/2/100N-2015-02-06_05-50.flac', '2015-02-06 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.92M', '255k', '16-bit FLAC'),
(10097104, 779, 'project_33/site_779/2015/2/100W-2015-02-09_05-40.wav.flac', '2015-02-09 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097105, 779, 'project_33/site_779/2015/2/175A-2015-02-13_06-30.wav.flac', '2015-02-13 06:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.98M', '263k', '16-bit FLAC'),
(10097106, 779, 'project_33/site_779/2015/2/175B-2015-02-08_06-00.wav.flac', '2015-02-08 06:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10097107, 779, 'project_33/site_779/2015/2/175B-2015-02-09_07-50.wav.flac', '2015-02-09 07:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10097108, 779, 'project_33/site_779/2015/2/250B-2015-02-10_06-10.flac', '2015-02-10 06:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.47M', '328k', '16-bit FLAC'),
(10097109, 779, 'project_33/site_779/2015/2/250N-2015-02-01_05-20.wav.flac', '2015-02-01 05:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097110, 779, 'project_33/site_779/2015/2/250W-2015-02-09_01-10.wav.flac', '2015-02-09 01:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.88M', '250k', '16-bit FLAC'),
(10097111, 779, 'project_33/site_779/2015/2/250W-2015-02-09_05-50.wav.flac', '2015-02-09 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097112, 779, 'project_33/site_779/2015/2/500A-2015-02-12_08-30.wav.flac', '2015-02-12 08:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.84M', '245k', '16-bit FLAC'),
(10097113, 779, 'project_33/site_779/2015/2/750A-2015-02-05_09-10.flac', '2015-02-05 09:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.83M', '243k', '16-bit FLAC'),
(10097114, 779, 'project_33/site_779/2015/2/750A-2015-02-10_06-30.flac', '2015-02-10 06:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.19M', '291k', '16-bit FLAC'),
(10097115, 779, 'project_33/site_779/2015/2/750B-2015-02-06_06-40.flac', '2015-02-06 06:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.76M', '233k', '16-bit FLAC'),
(10097116, 779, 'project_33/site_779/2015/2/750B-2015-02-06_10-40.flac', '2015-02-06 10:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.73M', '230k', '16-bit FLAC'),
(10097117, 779, 'project_33/site_779/2015/2/750B-2015-02-12_06-30.flac', '2015-02-12 06:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.06M', '274k', '16-bit FLAC'),
(10097118, 779, 'project_33/site_779/2015/1/1000A-2015-01-30_05-30.flac', '2015-01-30 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097119, 779, 'project_33/site_779/2015/1/1000A-2015-01-30_06-40.flac', '2015-01-30 06:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10097120, 779, 'project_33/site_779/2015/1/1000A-2015-01-30_09-10.flac', '2015-01-30 09:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10097121, 779, 'project_33/site_779/2015/1/1000A-2015-01-30_10-00.flac', '2015-01-30 10:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097122, 779, 'project_33/site_779/2015/1/1000A-2015-01-31_06-20.flac', '2015-01-31 06:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.62M', '214k', '16-bit FLAC'),
(10097123, 779, 'project_33/site_779/2015/2/1000A-2015-02-01_05-30.flac', '2015-02-01 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.72M', '228k', '16-bit FLAC'),
(10097124, 779, 'project_33/site_779/2015/2/1000A-2015-02-01_05-50.flac', '2015-02-01 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.68M', '224k', '16-bit FLAC'),
(10097125, 779, 'project_33/site_779/2015/2/1000A-2015-02-01_06-40.flac', '2015-02-01 06:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.66M', '221k', '16-bit FLAC'),
(10097126, 779, 'project_33/site_779/2015/2/1000A-2015-02-03_05-50.flac', '2015-02-03 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.68M', '224k', '16-bit FLAC'),
(10097127, 779, 'project_33/site_779/2015/2/1000A-2015-02-03_06-10.flac', '2015-02-03 06:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.66M', '220k', '16-bit FLAC'),
(10097128, 779, 'project_33/site_779/2015/2/1000A-2015-02-05_06-40.flac', '2015-02-05 06:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097129, 779, 'project_33/site_779/2015/2/1000A-2015-02-06_06-30.flac', '2015-02-06 06:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.80M', '238k', '16-bit FLAC'),
(10097130, 779, 'project_33/site_779/2015/2/1000A-2015-02-08_06-20.flac', '2015-02-08 06:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097131, 779, 'project_33/site_779/2015/2/1000A-2015-02-09_05-40.flac', '2015-02-09 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.74M', '232k', '16-bit FLAC'),
(10097132, 779, 'project_33/site_779/2015/2/1000A-2015-02-09_05-50.flac', '2015-02-09 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.67M', '221k', '16-bit FLAC'),
(10097133, 779, 'project_33/site_779/2015/2/1000A-2015-02-09_06-00.flac', '2015-02-09 06:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097134, 779, 'project_33/site_779/2015/2/1000A-2015-02-11_05-50.flac', '2015-02-11 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.85M', '246k', '16-bit FLAC'),
(10097135, 779, 'project_33/site_779/2015/2/1000A-2015-02-11_06-10.flac', '2015-02-11 06:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10097136, 779, 'project_33/site_779/2015/2/1000A-2015-02-11_07-50.flac', '2015-02-11 07:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097137, 779, 'project_33/site_779/2015/2/1000A-2015-02-11_09-40.flac', '2015-02-11 09:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.78M', '236k', '16-bit FLAC'),
(10097138, 779, 'project_33/site_779/2015/2/1000A-2015-02-11_10-10.flac', '2015-02-11 10:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.73M', '229k', '16-bit FLAC'),
(10097139, 779, 'project_33/site_779/2015/2/1000A-2015-02-11_12-40.flac', '2015-02-11 12:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097140, 779, 'project_33/site_779/2015/2/1000A-2015-02-11_18-20.flac', '2015-02-11 18:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.84M', '244k', '16-bit FLAC'),
(10097141, 779, 'project_33/site_779/2015/2/1000A-2015-02-12_11-20.flac', '2015-02-12 11:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097142, 779, 'project_33/site_779/2015/2/1000A-2015-02-12_11-40.flac', '2015-02-12 11:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.84M', '244k', '16-bit FLAC'),
(10097143, 779, 'project_33/site_779/2015/2/1000A-2015-02-12_12-40.flac', '2015-02-12 12:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.75M', '233k', '16-bit FLAC'),
(10097144, 779, 'project_33/site_779/2015/2/1000A-2015-02-12_13-30.flac', '2015-02-12 13:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.81M', '240k', '16-bit FLAC'),
(10097145, 779, 'project_33/site_779/2015/2/1000A-2015-02-12_16-40.flac', '2015-02-12 16:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097146, 779, 'project_33/site_779/2015/1/1000B-2015-01-30_06-10.flac', '2015-01-30 06:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.78M', '237k', '16-bit FLAC'),
(10097147, 779, 'project_33/site_779/2015/2/1000B-2015-02-04_06-50.wav.flac', '2015-02-04 06:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10097148, 779, 'project_33/site_779/2015/2/1000B-2015-02-09_05-30.flac', '2015-02-09 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.85M', '246k', '16-bit FLAC'),
(10097149, 779, 'project_33/site_779/2015/2/1000B-2015-02-10_05-20.flac', '2015-02-10 05:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.25M', '298k', '16-bit FLAC'),
(10097150, 779, 'project_33/site_779/2014/9/gb002-2014-09-30_05-30.flac', '2014-09-30 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.83M', '243k', '16-bit FLAC'),
(10097151, 779, 'project_33/site_779/2014/10/gb002-2014-10-01_05-40.flac', '2014-10-01 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.81M', '241k', '16-bit FLAC'),
(10097152, 779, 'project_33/site_779/2014/10/gb002-2014-10-01_06-20.flac', '2014-10-01 06:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.93M', '257k', '16-bit FLAC'),
(10097153, 779, 'project_33/site_779/2014/10/gb002-2014-10-02_05-30.flac', '2014-10-02 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.92M', '256k', '16-bit FLAC'),
(10097154, 779, 'project_33/site_779/2014/10/gb002-2014-10-02_05-50.flac', '2014-10-02 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.79M', '238k', '16-bit FLAC'),
(10097155, 779, 'project_33/site_779/2014/10/gb002-2014-10-03_06-50.flac', '2014-10-03 06:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.77M', '236k', '16-bit FLAC'),
(10097156, 779, 'project_33/site_779/2014/10/gb002-2014-10-09_05-40.flac', '2014-10-09 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097157, 779, 'project_33/site_779/2014/9/gb003-2014-09-28_06-10.flac', '2014-09-28 06:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.94M', '258k', '16-bit FLAC'),
(10097158, 779, 'project_33/site_779/2014/9/gb006-2014-09-28_05-30.flac', '2014-09-28 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.60M', '213k', '16-bit FLAC'),
(10097159, 779, 'project_33/site_779/2014/10/gb006-2014-10-08_05-30.flac', '2014-10-08 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097160, 779, 'project_33/site_779/2014/10/gb007-2014-10-03_05-50.flac', '2014-10-03 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097161, 779, 'project_33/site_779/2014/10/gb007-2014-10-05_06-10.flac', '2014-10-05 06:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.66M', '220k', '16-bit FLAC'),
(10097162, 779, 'project_33/site_779/2014/10/gb009-2014-10-04_06-50.flac', '2014-10-04 06:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.91M', '253k', '16-bit FLAC'),
(10097163, 779, 'project_33/site_779/2014/10/gb009-2014-10-05_05-10.flac', '2014-10-05 05:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097164, 779, 'project_33/site_779/2014/10/gb009-2014-10-05_06-30.flac', '2014-10-05 06:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.71M', '226k', '16-bit FLAC'),
(10097165, 779, 'project_33/site_779/1970/1/gb010-1970-01-05_07-30.flac', '1970-01-05 07:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.93M', '256k', '16-bit FLAC'),
(10097166, 779, 'project_33/site_779/1970/1/gb010-1970-01-06_07-50.flac', '1970-01-06 07:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.99M', '264k', '16-bit FLAC'),
(10097167, 779, 'project_33/site_779/2014/10/gb010-2014-10-03_05-40.flac', '2014-10-03 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097168, 779, 'project_33/site_779/2014/10/gb010-2014-10-04_05-40.flac', '2014-10-04 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.60M', '213k', '16-bit FLAC'),
(10097169, 779, 'project_33/site_779/2014/10/gb010-2014-10-04_06-50.flac', '2014-10-04 06:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.62M', '216k', '16-bit FLAC'),
(10097170, 779, 'project_33/site_779/2014/10/gb010-2014-10-04_07-10.flac', '2014-10-04 07:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.64M', '217k', '16-bit FLAC'),
(10097171, 779, 'project_33/site_779/2014/10/gb010-2014-10-04_08-00.flac', '2014-10-04 08:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.70M', '225k', '16-bit FLAC'),
(10097172, 779, 'project_33/site_779/2014/10/gb010-2014-10-05_07-10.flac', '2014-10-05 07:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097173, 779, 'project_33/site_779/2014/10/gb010-2014-10-05_08-20.flac', '2014-10-05 08:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.60M', '212k', '16-bit FLAC'),
(10097174, 779, 'project_33/site_779/2014/10/gb010-2014-10-05_09-10.flac', '2014-10-05 09:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097175, 779, 'project_33/site_779/2014/10/gb010-2014-10-06_05-30.flac', '2014-10-06 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097176, 779, 'project_33/site_779/2014/10/gb010-2014-10-07_05-30.flac', '2014-10-07 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.63M', '216k', '16-bit FLAC'),
(10097177, 779, 'project_33/site_779/2014/10/gb010-2014-10-07_05-40.flac', '2014-10-07 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097178, 779, 'project_33/site_779/2014/10/gb010-2014-10-07_06-20.flac', '2014-10-07 06:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097179, 779, 'project_33/site_779/2014/10/gb010-2014-10-07_07-40.flac', '2014-10-07 07:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.68M', '224k', '16-bit FLAC'),
(10097180, 779, 'project_33/site_779/2014/9/Gb001-2014-09-27_06-00.flac', '2014-09-27 06:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097181, 779, 'project_33/site_779/2014/9/Gb001-2014-09-30_05-50.flac', '2014-09-30 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097182, 779, 'project_33/site_779/2014/10/Gb001-2014-10-01_06-00.flac', '2014-10-01 06:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097183, 779, 'project_33/site_779/2014/10/Gb001-2014-10-05_05-20.flac', '2014-10-05 05:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097184, 779, 'project_33/site_779/2014/10/Gb001-2014-10-07_06-10.flac', '2014-10-07 06:10:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097185, 779, 'project_33/site_779/2014/10/Gb004-2014-10-03_05-40.flac', '2014-10-03 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.73M', '229k', '16-bit FLAC'),
(10097186, 779, 'project_33/site_779/2014/9/Gb005-2014-09-28_07-50.flac', '2014-09-28 07:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.80M', '239k', '16-bit FLAC'),
(10097187, 779, 'project_33/site_779/2014/9/Gb005-2014-09-30_05-20.flac', '2014-09-30 05:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.94M', '257k', '16-bit FLAC'),
(10097188, 779, 'project_33/site_779/2014/10/Gb005-2014-10-01_05-30.flac', '2014-10-01 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097189, 779, 'project_33/site_779/2014/10/Gb005-2014-10-01_08-20.flac', '2014-10-01 08:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.12M', '282k', '16-bit FLAC'),
(10097190, 779, 'project_33/site_779/2014/10/Gb005-2014-10-03_05-30.flac', '2014-10-03 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.72M', '229k', '16-bit FLAC'),
(10097191, 779, 'project_33/site_779/2014/10/Gb005-2014-10-05_05-30.flac', '2014-10-05 05:30:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.61M', '213k', '16-bit FLAC');
INSERT INTO `recordings` (`recording_id`, `site_id`, `uri`, `datetime`, `mic`, `recorder`, `version`, `sample_rate`, `precision`, `duration`, `samples`, `file_size`, `bit_rate`, `sample_encoding`) VALUES
(10097192, 779, 'project_33/site_779/2014/10/Gb005-2014-10-05_06-50.flac', '2014-10-05 06:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.82M', '241k', '16-bit FLAC'),
(10097193, 779, 'project_33/site_779/2014/10/Gb005-2014-10-06_05-20.flac', '2014-10-06 05:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '2.00M', '265k', '16-bit FLAC'),
(10097194, 779, 'project_33/site_779/2014/10/Gb005-2014-10-06_05-50.flac', '2014-10-06 05:50:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097195, 779, 'project_33/site_779/2014/10/Gb005-2014-10-06_06-00.flac', '2014-10-06 06:00:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.70M', '225k', '16-bit FLAC'),
(10097196, 779, 'project_33/site_779/2014/10/Gb005-2014-10-08_05-20.flac', '2014-10-08 05:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.54M', '205k', '16-bit FLAC'),
(10097197, 779, 'project_33/site_779/2014/10/Gb005-2014-10-08_05-40.flac', '2014-10-08 05:40:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.55M', '206k', '16-bit FLAC'),
(10097198, 779, 'project_33/site_779/2014/10/Gb005-2014-10-08_06-20.flac', '2014-10-08 06:20:00', 'u', 'u', 'u', 44100, 16, 60.25, 2657025, '1.55M', '205k', '16-bit FLAC'),
(10097199, 780, 'project_33/site_780/2015/1/100B-2015-01-31_06-50.wav.flac', '2015-01-31 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.94M', '258k', '16-bit FLAC'),
(10097200, 780, 'project_33/site_780/2015/2/100B-2015-02-01_05-30.flac', '2015-02-01 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '241k', '16-bit FLAC'),
(10097201, 780, 'project_33/site_780/2015/2/100B-2015-02-01_05-40.flac', '2015-02-01 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.80M', '239k', '16-bit FLAC'),
(10097202, 780, 'project_33/site_780/2015/2/100B-2015-02-01_06-20.flac', '2015-02-01 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.99M', '264k', '16-bit FLAC'),
(10097203, 780, 'project_33/site_780/2015/2/100B-2015-02-01_06-40.flac', '2015-02-01 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.87M', '248k', '16-bit FLAC'),
(10097204, 780, 'project_33/site_780/2015/2/100B-2015-02-01_08-20.flac', '2015-02-01 08:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10097205, 780, 'project_33/site_780/2015/2/100B-2015-02-02_05-00.flac', '2015-02-02 05:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '222k', '16-bit FLAC'),
(10097206, 780, 'project_33/site_780/2015/2/100B-2015-02-02_05-30.flac', '2015-02-02 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '230k', '16-bit FLAC'),
(10097207, 780, 'project_33/site_780/2015/2/100B-2015-02-02_05-40.flac', '2015-02-02 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10097208, 780, 'project_33/site_780/2015/2/100B-2015-02-02_06-00.flac', '2015-02-02 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097209, 780, 'project_33/site_780/2015/2/100B-2015-02-03_05-20.flac', '2015-02-03 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '230k', '16-bit FLAC'),
(10097210, 780, 'project_33/site_780/2015/2/100B-2015-02-03_06-10.flac', '2015-02-03 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '242k', '16-bit FLAC'),
(10097211, 780, 'project_33/site_780/2015/2/100B-2015-02-04_05-50.flac', '2015-02-04 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.88M', '249k', '16-bit FLAC'),
(10097212, 780, 'project_33/site_780/2015/2/100N-2015-02-04_05-40.flac', '2015-02-04 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '237k', '16-bit FLAC'),
(10097213, 780, 'project_33/site_780/2015/2/100W-2015-02-08_06-50.wav.flac', '2015-02-08 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.70M', '225k', '16-bit FLAC'),
(10097214, 780, 'project_33/site_780/2015/2/100W-2015-02-09_05-40.wav.flac', '2015-02-09 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097215, 780, 'project_33/site_780/2015/2/175A-2015-02-03_05-30.wav.flac', '2015-02-03 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.89M', '251k', '16-bit FLAC'),
(10097216, 780, 'project_33/site_780/2015/2/175B-2015-02-03_06-50.wav.flac', '2015-02-03 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.70M', '225k', '16-bit FLAC'),
(10097217, 780, 'project_33/site_780/2015/2/175B-2015-02-07_05-10.wav.flac', '2015-02-07 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.81M', '240k', '16-bit FLAC'),
(10097218, 780, 'project_33/site_780/2015/2/175B-2015-02-09_05-20.wav.flac', '2015-02-09 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10097219, 780, 'project_33/site_780/2015/2/175B-2015-02-09_08-00.wav.flac', '2015-02-09 08:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.71M', '228k', '16-bit FLAC'),
(10097220, 780, 'project_33/site_780/2015/2/175B-2015-02-09_08-10.wav.flac', '2015-02-09 08:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10097221, 780, 'project_33/site_780/2015/2/250A-2015-02-08_05-40.wav.flac', '2015-02-08 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.96M', '260k', '16-bit FLAC'),
(10097222, 780, 'project_33/site_780/2015/2/250B-2015-02-01_05-30.flac', '2015-02-01 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '221k', '16-bit FLAC'),
(10097223, 780, 'project_33/site_780/2015/2/250B-2015-02-10_06-00.flac', '2015-02-10 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.54M', '337k', '16-bit FLAC'),
(10097224, 780, 'project_33/site_780/2015/1/250N-2015-01-31_05-00.wav.flac', '2015-01-31 05:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097225, 780, 'project_33/site_780/2015/1/250N-2015-01-31_06-10.wav.flac', '2015-01-31 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.64M', '218k', '16-bit FLAC'),
(10097226, 780, 'project_33/site_780/2015/2/250N-2015-02-01_07-00.wav.flac', '2015-02-01 07:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '233k', '16-bit FLAC'),
(10097227, 780, 'project_33/site_780/2015/2/250N-2015-02-02_05-40.wav.flac', '2015-02-02 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '221k', '16-bit FLAC'),
(10097228, 780, 'project_33/site_780/2015/2/250N-2015-02-05_06-20.wav.flac', '2015-02-05 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097229, 780, 'project_33/site_780/2015/2/250W-2015-02-08_05-50.wav.flac', '2015-02-08 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097230, 780, 'project_33/site_780/2015/2/250W-2015-02-09_00-20.wav.flac', '2015-02-09 00:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.93M', '256k', '16-bit FLAC'),
(10097231, 780, 'project_33/site_780/2015/2/250W-2015-02-09_06-00.wav.flac', '2015-02-09 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '220k', '16-bit FLAC'),
(10097232, 780, 'project_33/site_780/2015/2/250W-2015-02-12_06-00.wav.flac', '2015-02-12 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.79M', '237k', '16-bit FLAC'),
(10097233, 780, 'project_33/site_780/2015/2/250W-2015-02-12_09-50.wav.flac', '2015-02-12 09:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '236k', '16-bit FLAC'),
(10097234, 780, 'project_33/site_780/2015/2/250W-2015-02-12_10-10.wav.flac', '2015-02-12 10:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '236k', '16-bit FLAC'),
(10097235, 780, 'project_33/site_780/2015/2/250W-2015-02-12_14-40.wav.flac', '2015-02-12 14:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.81M', '240k', '16-bit FLAC'),
(10097236, 780, 'project_33/site_780/2015/2/500A-2015-02-06_05-20.wav.flac', '2015-02-06 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097237, 780, 'project_33/site_780/2015/2/500A-2015-02-06_06-50.wav.flac', '2015-02-06 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10097238, 780, 'project_33/site_780/2015/2/500A-2015-02-08_06-00.wav.flac', '2015-02-08 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.64M', '218k', '16-bit FLAC'),
(10097239, 780, 'project_33/site_780/2015/2/500A-2015-02-09_05-50.wav.flac', '2015-02-09 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.72M', '229k', '16-bit FLAC'),
(10097240, 780, 'project_33/site_780/2015/2/500A-2015-02-09_06-10.wav.flac', '2015-02-09 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.70M', '226k', '16-bit FLAC'),
(10097241, 780, 'project_33/site_780/2015/2/500A-2015-02-12_08-20.wav.flac', '2015-02-12 08:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.84M', '245k', '16-bit FLAC'),
(10097242, 780, 'project_33/site_780/2015/2/500A-2015-02-12_13-20.wav.flac', '2015-02-12 13:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '236k', '16-bit FLAC'),
(10097243, 780, 'project_33/site_780/2015/2/500B-2015-02-01_05-30.wav.flac', '2015-02-01 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.87M', '249k', '16-bit FLAC'),
(10097244, 780, 'project_33/site_780/2015/2/500B-2015-02-02_06-00.wav.flac', '2015-02-02 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097245, 780, 'project_33/site_780/2015/2/500B-2015-02-05_06-40.wav.flac', '2015-02-05 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.86M', '248k', '16-bit FLAC'),
(10097246, 780, 'project_33/site_780/2015/2/750A-2015-02-05_06-30.flac', '2015-02-05 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.84M', '245k', '16-bit FLAC'),
(10097247, 780, 'project_33/site_780/2015/2/750A-2015-02-10_05-00.flac', '2015-02-10 05:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.21M', '294k', '16-bit FLAC'),
(10097248, 780, 'project_33/site_780/2015/1/750B-2015-01-31_05-50.flac', '2015-01-31 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.79M', '238k', '16-bit FLAC'),
(10097249, 780, 'project_33/site_780/2015/2/750B-2015-02-06_09-10.flac', '2015-02-06 09:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '230k', '16-bit FLAC'),
(10097250, 780, 'project_33/site_780/2015/2/750B-2015-02-06_16-30.flac', '2015-02-06 16:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.94M', '257k', '16-bit FLAC'),
(10097251, 780, 'project_33/site_780/2015/2/750B-2015-02-09_06-50.flac', '2015-02-09 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.85M', '245k', '16-bit FLAC'),
(10097252, 780, 'project_33/site_780/2015/2/750B-2015-02-12_06-00.flac', '2015-02-12 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.07M', '274k', '16-bit FLAC'),
(10097253, 780, 'project_33/site_780/2015/2/750B-2015-02-12_06-30.flac', '2015-02-12 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.06M', '274k', '16-bit FLAC'),
(10097254, 780, 'project_33/site_780/2015/1/1000A-2015-01-31_06-20.flac', '2015-01-31 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.62M', '214k', '16-bit FLAC'),
(10097255, 780, 'project_33/site_780/2015/2/1000A-2015-02-01_05-30.flac', '2015-02-01 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.72M', '228k', '16-bit FLAC'),
(10097256, 780, 'project_33/site_780/2015/2/1000A-2015-02-01_05-40.flac', '2015-02-01 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '231k', '16-bit FLAC'),
(10097257, 780, 'project_33/site_780/2015/2/1000A-2015-02-01_06-40.flac', '2015-02-01 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '221k', '16-bit FLAC'),
(10097258, 780, 'project_33/site_780/2015/2/1000A-2015-02-03_06-00.flac', '2015-02-03 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '224k', '16-bit FLAC'),
(10097259, 780, 'project_33/site_780/2015/2/1000A-2015-02-03_06-10.flac', '2015-02-03 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '220k', '16-bit FLAC'),
(10097260, 780, 'project_33/site_780/2015/2/1000A-2015-02-05_06-40.flac', '2015-02-05 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097261, 780, 'project_33/site_780/2015/2/1000A-2015-02-06_06-30.flac', '2015-02-06 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.80M', '238k', '16-bit FLAC'),
(10097262, 780, 'project_33/site_780/2015/2/1000A-2015-02-09_05-50.flac', '2015-02-09 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '221k', '16-bit FLAC'),
(10097263, 780, 'project_33/site_780/2015/2/1000A-2015-02-09_06-00.flac', '2015-02-09 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097264, 780, 'project_33/site_780/2015/2/1000A-2015-02-10_06-00.flac', '2015-02-10 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.02M', '269k', '16-bit FLAC'),
(10097265, 780, 'project_33/site_780/2015/2/1000A-2015-02-11_06-10.flac', '2015-02-11 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10097266, 780, 'project_33/site_780/2015/2/1000A-2015-02-11_07-50.flac', '2015-02-11 07:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097267, 780, 'project_33/site_780/2015/2/1000A-2015-02-11_10-20.flac', '2015-02-11 10:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097268, 780, 'project_33/site_780/2015/2/1000A-2015-02-12_11-20.flac', '2015-02-12 11:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097269, 780, 'project_33/site_780/2015/2/1000A-2015-02-12_12-20.flac', '2015-02-12 12:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '230k', '16-bit FLAC'),
(10097270, 780, 'project_33/site_780/2015/2/1000A-2015-02-12_12-40.flac', '2015-02-12 12:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '233k', '16-bit FLAC'),
(10097271, 780, 'project_33/site_780/2015/2/1000A-2015-02-12_15-10.flac', '2015-02-12 15:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '237k', '16-bit FLAC'),
(10097272, 780, 'project_33/site_780/2015/1/1000B-2015-01-31_05-40.flac', '2015-01-31 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.83M', '243k', '16-bit FLAC'),
(10097273, 780, 'project_33/site_780/2015/2/1000B-2015-02-05_05-50.flac', '2015-02-05 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.83M', '243k', '16-bit FLAC'),
(10097274, 780, 'project_33/site_780/2015/2/1000B-2015-02-09_05-30.flac', '2015-02-09 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.85M', '246k', '16-bit FLAC'),
(10097275, 780, 'project_33/site_780/2015/2/1000B-2015-02-09_05-50.flac', '2015-02-09 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.87M', '248k', '16-bit FLAC'),
(10097276, 780, 'project_33/site_780/2014/9/gb002-2014-09-30_05-50.flac', '2014-09-30 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.81M', '241k', '16-bit FLAC'),
(10097277, 780, 'project_33/site_780/2014/10/gb002-2014-10-01_05-40.flac', '2014-10-01 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.81M', '241k', '16-bit FLAC'),
(10097278, 780, 'project_33/site_780/2014/10/gb002-2014-10-01_06-20.flac', '2014-10-01 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.93M', '257k', '16-bit FLAC'),
(10097279, 780, 'project_33/site_780/2014/10/gb002-2014-10-01_06-40.flac', '2014-10-01 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.00M', '266k', '16-bit FLAC'),
(10097280, 780, 'project_33/site_780/2014/10/gb002-2014-10-02_05-30.flac', '2014-10-02 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.92M', '256k', '16-bit FLAC'),
(10097281, 780, 'project_33/site_780/2014/10/gb002-2014-10-02_06-00.flac', '2014-10-02 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.79M', '238k', '16-bit FLAC'),
(10097282, 780, 'project_33/site_780/2014/10/gb002-2014-10-02_07-10.flac', '2014-10-02 07:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.03M', '270k', '16-bit FLAC'),
(10097283, 780, 'project_33/site_780/2014/10/gb002-2014-10-03_06-00.flac', '2014-10-03 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10097284, 780, 'project_33/site_780/2014/10/gb002-2014-10-03_06-40.flac', '2014-10-03 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097285, 780, 'project_33/site_780/2014/10/gb002-2014-10-05_05-10.flac', '2014-10-05 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '232k', '16-bit FLAC'),
(10097286, 780, 'project_33/site_780/2014/10/gb002-2014-10-06_05-30.flac', '2014-10-06 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.91M', '253k', '16-bit FLAC'),
(10097287, 780, 'project_33/site_780/2014/10/gb002-2014-10-06_05-40.flac', '2014-10-06 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.81M', '240k', '16-bit FLAC'),
(10097288, 780, 'project_33/site_780/2014/10/gb002-2014-10-06_05-50.flac', '2014-10-06 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.80M', '239k', '16-bit FLAC'),
(10097289, 780, 'project_33/site_780/2014/10/gb002-2014-10-09_05-40.flac', '2014-10-09 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097290, 780, 'project_33/site_780/2014/10/gb002-2014-10-09_06-40.flac', '2014-10-09 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.87M', '249k', '16-bit FLAC'),
(10097291, 780, 'project_33/site_780/2014/10/gb003-2014-10-05_05-30.flac', '2014-10-05 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '207k', '16-bit FLAC'),
(10097292, 780, 'project_33/site_780/2014/9/gb006-2014-09-28_05-20.flac', '2014-09-28 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097293, 780, 'project_33/site_780/2014/9/gb006-2014-09-28_05-30.flac', '2014-09-28 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.60M', '213k', '16-bit FLAC'),
(10097294, 780, 'project_33/site_780/2014/10/gb006-2014-10-05_05-50.flac', '2014-10-05 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '207k', '16-bit FLAC'),
(10097295, 780, 'project_33/site_780/2014/10/gb006-2014-10-07_05-20.flac', '2014-10-07 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.58M', '210k', '16-bit FLAC'),
(10097296, 780, 'project_33/site_780/2014/10/gb006-2014-10-08_05-30.flac', '2014-10-08 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097297, 780, 'project_33/site_780/2014/9/gb007-2014-09-28_05-50.flac', '2014-09-28 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.04M', '270k', '16-bit FLAC'),
(10097298, 780, 'project_33/site_780/2014/10/gb007-2014-10-03_05-30.flac', '2014-10-03 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '224k', '16-bit FLAC'),
(10097299, 780, 'project_33/site_780/2014/10/gb009-2014-10-02_05-30.flac', '2014-10-02 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.83M', '243k', '16-bit FLAC'),
(10097300, 780, 'project_33/site_780/2014/10/gb009-2014-10-05_05-50.flac', '2014-10-05 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.64M', '218k', '16-bit FLAC'),
(10097301, 780, 'project_33/site_780/2014/10/gb009-2014-10-07_06-10.flac', '2014-10-07 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.05M', '272k', '16-bit FLAC'),
(10097302, 780, 'project_33/site_780/2014/10/gb009-2014-10-09_05-10.flac', '2014-10-09 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.88M', '250k', '16-bit FLAC'),
(10097303, 780, 'project_33/site_780/2014/10/gb010-2014-10-03_05-20.flac', '2014-10-03 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097304, 780, 'project_33/site_780/2014/10/gb010-2014-10-03_23-50.flac', '2014-10-03 23:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097305, 780, 'project_33/site_780/2014/10/gb010-2014-10-04_05-20.flac', '2014-10-04 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.63M', '217k', '16-bit FLAC'),
(10097306, 780, 'project_33/site_780/2014/10/gb010-2014-10-04_06-40.flac', '2014-10-04 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097307, 780, 'project_33/site_780/2014/10/gb010-2014-10-05_05-00.flac', '2014-10-05 05:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.59M', '211k', '16-bit FLAC'),
(10097308, 780, 'project_33/site_780/2014/10/gb010-2014-10-05_05-30.flac', '2014-10-05 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.59M', '212k', '16-bit FLAC'),
(10097309, 780, 'project_33/site_780/2014/10/gb010-2014-10-06_06-40.flac', '2014-10-06 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.59M', '210k', '16-bit FLAC'),
(10097310, 780, 'project_33/site_780/2014/9/Gb001-2014-09-27_07-30.flac', '2014-09-27 07:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097311, 780, 'project_33/site_780/2014/9/Gb001-2014-09-28_06-10.flac', '2014-09-28 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '208k', '16-bit FLAC'),
(10097312, 780, 'project_33/site_780/2014/9/Gb001-2014-09-29_05-10.flac', '2014-09-29 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097313, 780, 'project_33/site_780/2014/9/Gb001-2014-09-29_05-20.flac', '2014-09-29 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.63M', '216k', '16-bit FLAC'),
(10097314, 780, 'project_33/site_780/2014/9/Gb001-2014-09-29_05-50.flac', '2014-09-29 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '209k', '16-bit FLAC'),
(10097315, 780, 'project_33/site_780/2014/9/Gb001-2014-09-30_05-10.flac', '2014-09-30 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.80M', '239k', '16-bit FLAC'),
(10097316, 780, 'project_33/site_780/2014/10/Gb001-2014-10-01_06-20.flac', '2014-10-01 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '241k', '16-bit FLAC'),
(10097317, 780, 'project_33/site_780/2014/10/Gb001-2014-10-01_06-50.flac', '2014-10-01 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10097318, 780, 'project_33/site_780/2014/10/Gb001-2014-10-02_05-30.flac', '2014-10-02 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097319, 780, 'project_33/site_780/2014/10/Gb001-2014-10-03_05-30.flac', '2014-10-03 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '208k', '16-bit FLAC'),
(10097320, 780, 'project_33/site_780/2014/10/Gb001-2014-10-06_05-20.flac', '2014-10-06 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097321, 780, 'project_33/site_780/2014/10/Gb001-2014-10-06_05-50.flac', '2014-10-06 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '207k', '16-bit FLAC'),
(10097322, 780, 'project_33/site_780/2014/10/Gb004-2014-10-01_08-40.flac', '2014-10-01 08:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.70M', '226k', '16-bit FLAC'),
(10097323, 780, 'project_33/site_780/2014/10/Gb004-2014-10-01_09-10.flac', '2014-10-01 09:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.83M', '243k', '16-bit FLAC'),
(10097324, 780, 'project_33/site_780/2014/10/Gb004-2014-10-02_06-20.flac', '2014-10-02 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.89M', '251k', '16-bit FLAC'),
(10097325, 780, 'project_33/site_780/2014/10/Gb004-2014-10-02_07-40.flac', '2014-10-02 07:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '220k', '16-bit FLAC'),
(10097326, 780, 'project_33/site_780/2014/10/Gb004-2014-10-03_06-00.flac', '2014-10-03 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '236k', '16-bit FLAC'),
(10097327, 780, 'project_33/site_780/2014/10/Gb004-2014-10-05_05-40.flac', '2014-10-05 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '209k', '16-bit FLAC'),
(10097328, 780, 'project_33/site_780/2014/9/Gb005-2014-09-28_05-30.flac', '2014-09-28 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.79M', '237k', '16-bit FLAC'),
(10097329, 780, 'project_33/site_780/2014/9/Gb005-2014-09-28_05-50.flac', '2014-09-28 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097330, 780, 'project_33/site_780/2014/9/Gb005-2014-09-29_05-40.flac', '2014-09-29 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097331, 780, 'project_33/site_780/2014/9/Gb005-2014-09-30_05-20.flac', '2014-09-30 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.94M', '257k', '16-bit FLAC'),
(10097332, 780, 'project_33/site_780/2014/10/Gb005-2014-10-01_05-20.flac', '2014-10-01 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.98M', '262k', '16-bit FLAC'),
(10097333, 780, 'project_33/site_780/2014/10/Gb005-2014-10-01_05-30.flac', '2014-10-01 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097334, 780, 'project_33/site_780/2014/10/Gb005-2014-10-06_05-50.flac', '2014-10-06 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097335, 780, 'project_33/site_780/2014/10/Gb005-2014-10-06_06-10.flac', '2014-10-06 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '230k', '16-bit FLAC'),
(10097336, 780, 'project_33/site_780/2014/10/Gb005-2014-10-08_05-30.flac', '2014-10-08 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.53M', '204k', '16-bit FLAC'),
(10097337, 780, 'project_33/site_780/2014/10/Gb008-2014-10-01_05-40.flac', '2014-10-01 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.91M', '253k', '16-bit FLAC'),
(10097338, 780, 'project_33/site_780/2014/10/Gb008-2014-10-04_06-20.flac', '2014-10-04 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.00M', '265k', '16-bit FLAC'),
(10097339, 781, 'project_33/site_781/2015/2/100B-2015-02-01_05-30.flac', '2015-02-01 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '241k', '16-bit FLAC'),
(10097340, 781, 'project_33/site_781/2015/2/100B-2015-02-01_07-00.flac', '2015-02-01 07:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.72M', '229k', '16-bit FLAC'),
(10097341, 781, 'project_33/site_781/2015/2/100B-2015-02-02_05-50.flac', '2015-02-02 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097342, 781, 'project_33/site_781/2015/2/100B-2015-02-03_06-10.flac', '2015-02-03 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '242k', '16-bit FLAC'),
(10097343, 781, 'project_33/site_781/2015/2/100B-2015-02-09_06-40.wav.flac', '2015-02-09 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '236k', '16-bit FLAC'),
(10097344, 781, 'project_33/site_781/2015/2/100N-2015-02-05_07-30.flac', '2015-02-05 07:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.86M', '247k', '16-bit FLAC'),
(10097345, 781, 'project_33/site_781/2015/1/175B-2015-01-31_06-30.wav.flac', '2015-01-31 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.87M', '248k', '16-bit FLAC'),
(10097346, 781, 'project_33/site_781/2015/2/175B-2015-02-09_06-50.wav.flac', '2015-02-09 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '229k', '16-bit FLAC'),
(10097347, 781, 'project_33/site_781/2015/2/175B-2015-02-09_08-10.wav.flac', '2015-02-09 08:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10097348, 781, 'project_33/site_781/2015/1/250N-2015-01-31_06-10.wav.flac', '2015-01-31 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.64M', '218k', '16-bit FLAC'),
(10097349, 781, 'project_33/site_781/2015/2/250N-2015-02-01_08-40.wav.flac', '2015-02-01 08:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '222k', '16-bit FLAC'),
(10097350, 781, 'project_33/site_781/2015/2/250N-2015-02-05_06-10.wav.flac', '2015-02-05 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '220k', '16-bit FLAC'),
(10097351, 781, 'project_33/site_781/2015/2/250N-2015-02-05_06-20.wav.flac', '2015-02-05 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097352, 781, 'project_33/site_781/2015/2/250W-2015-02-09_00-30.wav.flac', '2015-02-09 00:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.94M', '257k', '16-bit FLAC'),
(10097353, 781, 'project_33/site_781/2015/2/250W-2015-02-09_06-10.wav.flac', '2015-02-09 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097354, 781, 'project_33/site_781/2015/2/250W-2015-02-12_09-40.wav.flac', '2015-02-12 09:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '237k', '16-bit FLAC'),
(10097355, 781, 'project_33/site_781/2015/2/500A-2015-02-02_05-30.wav.flac', '2015-02-02 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.58M', '210k', '16-bit FLAC'),
(10097356, 781, 'project_33/site_781/2015/2/500A-2015-02-06_06-50.wav.flac', '2015-02-06 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10097357, 781, 'project_33/site_781/2015/2/500A-2015-02-09_05-50.wav.flac', '2015-02-09 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.72M', '229k', '16-bit FLAC'),
(10097358, 781, 'project_33/site_781/2015/2/500A-2015-02-12_06-10.wav.flac', '2015-02-12 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.88M', '250k', '16-bit FLAC'),
(10097359, 781, 'project_33/site_781/2015/2/750A-2015-02-05_06-50.flac', '2015-02-05 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '241k', '16-bit FLAC'),
(10097360, 781, 'project_33/site_781/2015/2/750A-2015-02-07_07-30.flac', '2015-02-07 07:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.34M', '310k', '16-bit FLAC'),
(10097361, 781, 'project_33/site_781/2015/1/1000A-2015-01-30_10-00.flac', '2015-01-30 10:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097362, 781, 'project_33/site_781/2015/1/1000A-2015-01-31_06-20.flac', '2015-01-31 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.62M', '214k', '16-bit FLAC'),
(10097363, 781, 'project_33/site_781/2015/2/1000A-2015-02-01_05-30.flac', '2015-02-01 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.72M', '228k', '16-bit FLAC'),
(10097364, 781, 'project_33/site_781/2015/2/1000A-2015-02-01_05-40.flac', '2015-02-01 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '231k', '16-bit FLAC'),
(10097365, 781, 'project_33/site_781/2015/2/1000A-2015-02-01_05-50.flac', '2015-02-01 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '224k', '16-bit FLAC'),
(10097366, 781, 'project_33/site_781/2015/2/1000A-2015-02-03_06-10.flac', '2015-02-03 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '220k', '16-bit FLAC'),
(10097367, 781, 'project_33/site_781/2015/2/1000A-2015-02-06_06-30.flac', '2015-02-06 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.80M', '238k', '16-bit FLAC'),
(10097368, 781, 'project_33/site_781/2015/2/1000A-2015-02-08_06-20.flac', '2015-02-08 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097369, 781, 'project_33/site_781/2015/2/1000A-2015-02-11_05-40.flac', '2015-02-11 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '242k', '16-bit FLAC'),
(10097370, 781, 'project_33/site_781/2015/2/1000A-2015-02-12_12-40.flac', '2015-02-12 12:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '233k', '16-bit FLAC'),
(10097371, 781, 'project_33/site_781/2015/2/1000A-2015-02-12_15-10.flac', '2015-02-12 15:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '237k', '16-bit FLAC'),
(10097372, 781, 'project_33/site_781/2015/2/1000A-2015-02-12_16-40.flac', '2015-02-12 16:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097373, 781, 'project_33/site_781/2015/2/1000B-2015-02-09_05-40.flac', '2015-02-09 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.89M', '250k', '16-bit FLAC'),
(10097374, 781, 'project_33/site_781/2014/10/gb003-2014-10-06_05-30.flac', '2014-10-06 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '209k', '16-bit FLAC'),
(10097375, 781, 'project_33/site_781/2014/9/gb006-2014-09-28_06-20.flac', '2014-09-28 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.60M', '213k', '16-bit FLAC'),
(10097376, 781, 'project_33/site_781/2014/9/gb006-2014-09-28_06-30.flac', '2014-09-28 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.60M', '213k', '16-bit FLAC'),
(10097377, 781, 'project_33/site_781/2014/9/gb006-2014-09-28_07-00.flac', '2014-09-28 07:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.53M', '203k', '16-bit FLAC'),
(10097378, 781, 'project_33/site_781/2014/9/gb006-2014-09-28_08-00.flac', '2014-09-28 08:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.89M', '250k', '16-bit FLAC'),
(10097379, 781, 'project_33/site_781/2014/10/gb006-2014-10-03_05-20.flac', '2014-10-03 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.58M', '209k', '16-bit FLAC'),
(10097380, 781, 'project_33/site_781/2014/10/gb006-2014-10-03_06-30.flac', '2014-10-03 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '208k', '16-bit FLAC'),
(10097381, 781, 'project_33/site_781/2014/10/gb006-2014-10-03_06-40.flac', '2014-10-03 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '208k', '16-bit FLAC'),
(10097382, 781, 'project_33/site_781/2014/10/gb006-2014-10-05_05-00.flac', '2014-10-05 05:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.59M', '212k', '16-bit FLAC'),
(10097383, 781, 'project_33/site_781/2014/10/gb006-2014-10-05_05-30.flac', '2014-10-05 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '208k', '16-bit FLAC'),
(10097384, 781, 'project_33/site_781/2014/10/gb006-2014-10-05_06-20.flac', '2014-10-05 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '208k', '16-bit FLAC'),
(10097385, 781, 'project_33/site_781/2014/10/gb010-2014-10-05_06-00.flac', '2014-10-05 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.60M', '212k', '16-bit FLAC'),
(10097386, 781, 'project_33/site_781/2014/10/gb010-2014-10-05_08-20.flac', '2014-10-05 08:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.60M', '212k', '16-bit FLAC'),
(10097387, 781, 'project_33/site_781/2014/10/gb010-2014-10-07_05-20.flac', '2014-10-07 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097388, 781, 'project_33/site_781/2014/10/gb010-2014-10-07_05-30.flac', '2014-10-07 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.63M', '216k', '16-bit FLAC'),
(10097389, 781, 'project_33/site_781/2014/10/Gb001-2014-10-06_05-50.flac', '2014-10-06 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '207k', '16-bit FLAC'),
(10097390, 781, 'project_33/site_781/2014/10/Gb001-2014-10-07_05-30.flac', '2014-10-07 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '209k', '16-bit FLAC'),
(10097391, 781, 'project_33/site_781/2014/10/Gb001-2014-10-07_05-40.flac', '2014-10-07 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '207k', '16-bit FLAC'),
(10097392, 781, 'project_33/site_781/2014/10/Gb001-2014-10-08_10-50.flac', '2014-10-08 10:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10097393, 781, 'project_33/site_781/2014/9/Gb004-2014-09-27_06-20.flac', '2014-09-27 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.19M', '291k', '16-bit FLAC'),
(10097394, 781, 'project_33/site_781/2014/10/Gb004-2014-10-01_09-10.flac', '2014-10-01 09:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.83M', '243k', '16-bit FLAC'),
(10097395, 781, 'project_33/site_781/2014/10/Gb004-2014-10-02_08-50.flac', '2014-10-02 08:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '220k', '16-bit FLAC'),
(10097396, 781, 'project_33/site_781/2014/10/Gb004-2014-10-06_06-00.flac', '2014-10-06 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.92M', '255k', '16-bit FLAC'),
(10097397, 781, 'project_33/site_781/2014/9/Gb005-2014-09-28_05-20.flac', '2014-09-28 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.89M', '251k', '16-bit FLAC'),
(10097398, 781, 'project_33/site_781/2014/10/Gb008-2014-10-02_05-50.flac', '2014-10-02 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.85M', '246k', '16-bit FLAC'),
(10097399, 782, 'project_33/site_782/2015/1/100B-2015-01-31_06-30.wav.flac', '2015-01-31 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097400, 782, 'project_33/site_782/2015/2/100B-2015-02-01_05-50.flac', '2015-02-01 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.81M', '241k', '16-bit FLAC'),
(10097401, 782, 'project_33/site_782/2015/2/100B-2015-02-01_07-50.flac', '2015-02-01 07:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.98M', '263k', '16-bit FLAC'),
(10097402, 782, 'project_33/site_782/2015/2/100B-2015-02-02_06-00.flac', '2015-02-02 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097403, 782, 'project_33/site_782/2015/2/100B-2015-02-02_06-10.flac', '2015-02-02 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097404, 782, 'project_33/site_782/2015/2/100B-2015-02-02_06-30.flac', '2015-02-02 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '229k', '16-bit FLAC'),
(10097405, 782, 'project_33/site_782/2015/2/100B-2015-02-03_06-10.flac', '2015-02-03 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '242k', '16-bit FLAC'),
(10097406, 782, 'project_33/site_782/2015/2/100B-2015-02-04_05-50.flac', '2015-02-04 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.88M', '249k', '16-bit FLAC'),
(10097407, 782, 'project_33/site_782/2015/2/100B-2015-02-06_05-50.wav.flac', '2015-02-06 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '229k', '16-bit FLAC'),
(10097408, 782, 'project_33/site_782/2015/1/100N-2015-01-31_06-20.flac', '2015-01-31 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '230k', '16-bit FLAC'),
(10097409, 782, 'project_33/site_782/2015/2/100N-2015-02-05_07-30.flac', '2015-02-05 07:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.86M', '247k', '16-bit FLAC'),
(10097410, 782, 'project_33/site_782/2015/2/100N-2015-02-06_05-50.flac', '2015-02-06 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.92M', '255k', '16-bit FLAC'),
(10097411, 782, 'project_33/site_782/2015/2/100W-2015-02-12_06-10.wav.flac', '2015-02-12 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.83M', '243k', '16-bit FLAC'),
(10097412, 782, 'project_33/site_782/2015/2/100W-2015-02-12_06-30.wav.flac', '2015-02-12 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.80M', '239k', '16-bit FLAC'),
(10097413, 782, 'project_33/site_782/2015/2/175A-2015-02-13_06-30.wav.flac', '2015-02-13 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.98M', '263k', '16-bit FLAC'),
(10097414, 782, 'project_33/site_782/2015/2/175B-2015-02-03_06-50.wav.flac', '2015-02-03 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.70M', '225k', '16-bit FLAC'),
(10097415, 782, 'project_33/site_782/2015/2/175B-2015-02-04_06-00.wav.flac', '2015-02-04 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '221k', '16-bit FLAC'),
(10097416, 782, 'project_33/site_782/2015/2/175B-2015-02-04_06-30.wav.flac', '2015-02-04 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '221k', '16-bit FLAC'),
(10097417, 782, 'project_33/site_782/2015/2/175B-2015-02-07_05-10.wav.flac', '2015-02-07 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.81M', '240k', '16-bit FLAC'),
(10097418, 782, 'project_33/site_782/2015/2/175B-2015-02-09_05-20.wav.flac', '2015-02-09 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10097419, 782, 'project_33/site_782/2015/2/175B-2015-02-09_06-30.wav.flac', '2015-02-09 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.70M', '226k', '16-bit FLAC'),
(10097420, 782, 'project_33/site_782/2015/2/175B-2015-02-09_06-50.wav.flac', '2015-02-09 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '229k', '16-bit FLAC'),
(10097421, 782, 'project_33/site_782/2015/2/175B-2015-02-09_07-20.wav.flac', '2015-02-09 07:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.71M', '228k', '16-bit FLAC'),
(10097422, 782, 'project_33/site_782/2015/2/175B-2015-02-09_08-10.wav.flac', '2015-02-09 08:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.71M', '227k', '16-bit FLAC'),
(10097423, 782, 'project_33/site_782/2015/2/175B-2015-02-09_09-00.wav.flac', '2015-02-09 09:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.72M', '229k', '16-bit FLAC'),
(10097424, 782, 'project_33/site_782/2015/2/175B-2015-02-09_09-10.wav.flac', '2015-02-09 09:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '233k', '16-bit FLAC'),
(10097425, 782, 'project_33/site_782/2015/2/175B-2015-02-10_05-40.wav.flac', '2015-02-10 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.60M', '345k', '16-bit FLAC'),
(10097426, 782, 'project_33/site_782/2015/1/250A-2015-01-30_05-30.wav.flac', '2015-01-30 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.91M', '254k', '16-bit FLAC'),
(10097427, 782, 'project_33/site_782/2015/2/250A-2015-02-08_05-40.wav.flac', '2015-02-08 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.96M', '260k', '16-bit FLAC'),
(10097428, 782, 'project_33/site_782/2015/2/250B-2015-02-03_05-40.flac', '2015-02-03 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097429, 782, 'project_33/site_782/2015/2/250B-2015-02-10_06-00.flac', '2015-02-10 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.54M', '337k', '16-bit FLAC'),
(10097430, 782, 'project_33/site_782/2015/2/250B-2015-02-11_05-20.flac', '2015-02-11 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '231k', '16-bit FLAC'),
(10097431, 782, 'project_33/site_782/2015/1/250N-2015-01-31_05-20.wav.flac', '2015-01-31 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097432, 782, 'project_33/site_782/2015/2/250N-2015-02-01_07-00.wav.flac', '2015-02-01 07:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '233k', '16-bit FLAC'),
(10097433, 782, 'project_33/site_782/2015/2/250N-2015-02-02_05-40.wav.flac', '2015-02-02 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '221k', '16-bit FLAC'),
(10097434, 782, 'project_33/site_782/2015/2/250W-2015-02-08_05-50.wav.flac', '2015-02-08 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097435, 782, 'project_33/site_782/2015/2/250W-2015-02-09_00-10.wav.flac', '2015-02-09 00:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.93M', '257k', '16-bit FLAC'),
(10097436, 782, 'project_33/site_782/2015/2/250W-2015-02-09_00-30.wav.flac', '2015-02-09 00:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.94M', '257k', '16-bit FLAC'),
(10097437, 782, 'project_33/site_782/2015/2/250W-2015-02-09_05-50.wav.flac', '2015-02-09 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097438, 782, 'project_33/site_782/2015/2/250W-2015-02-09_06-00.wav.flac', '2015-02-09 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '220k', '16-bit FLAC'),
(10097439, 782, 'project_33/site_782/2015/2/250W-2015-02-09_06-40.wav.flac', '2015-02-09 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.63M', '217k', '16-bit FLAC'),
(10097440, 782, 'project_33/site_782/2015/2/250W-2015-02-09_09-20.wav.flac', '2015-02-09 09:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097441, 782, 'project_33/site_782/2015/2/250W-2015-02-09_16-40.wav.flac', '2015-02-09 16:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10097442, 782, 'project_33/site_782/2015/2/250W-2015-02-11_05-30.wav.flac', '2015-02-11 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.89M', '251k', '16-bit FLAC'),
(10097443, 782, 'project_33/site_782/2015/2/250W-2015-02-11_06-10.wav.flac', '2015-02-11 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.87M', '248k', '16-bit FLAC'),
(10097444, 782, 'project_33/site_782/2015/2/250W-2015-02-12_06-20.wav.flac', '2015-02-12 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '231k', '16-bit FLAC'),
(10097445, 782, 'project_33/site_782/2015/2/250W-2015-02-12_06-30.wav.flac', '2015-02-12 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.72M', '228k', '16-bit FLAC'),
(10097446, 782, 'project_33/site_782/2015/2/250W-2015-02-12_10-10.wav.flac', '2015-02-12 10:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '236k', '16-bit FLAC'),
(10097447, 782, 'project_33/site_782/2015/2/500A-2015-02-12_08-30.wav.flac', '2015-02-12 08:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.84M', '245k', '16-bit FLAC'),
(10097448, 782, 'project_33/site_782/2015/2/500A-2015-02-12_13-20.wav.flac', '2015-02-12 13:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '236k', '16-bit FLAC'),
(10097449, 782, 'project_33/site_782/2015/2/500B-2015-02-02_06-30.wav.flac', '2015-02-02 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097450, 782, 'project_33/site_782/2015/2/750A-2015-02-05_06-50.flac', '2015-02-05 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '241k', '16-bit FLAC'),
(10097451, 782, 'project_33/site_782/2015/2/750A-2015-02-07_07-00.flac', '2015-02-07 07:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.36M', '313k', '16-bit FLAC'),
(10097452, 782, 'project_33/site_782/2015/2/750A-2015-02-11_07-00.flac', '2015-02-11 07:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.88M', '250k', '16-bit FLAC'),
(10097453, 782, 'project_33/site_782/2015/1/750B-2015-01-31_05-50.flac', '2015-01-31 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.79M', '238k', '16-bit FLAC'),
(10097454, 782, 'project_33/site_782/2015/2/750B-2015-02-01_05-40.flac', '2015-02-01 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.86M', '247k', '16-bit FLAC'),
(10097455, 782, 'project_33/site_782/2015/2/750B-2015-02-02_06-50.flac', '2015-02-02 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '231k', '16-bit FLAC'),
(10097456, 782, 'project_33/site_782/2015/2/750B-2015-02-06_06-30.flac', '2015-02-06 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '232k', '16-bit FLAC'),
(10097457, 782, 'project_33/site_782/2015/2/750B-2015-02-06_10-40.flac', '2015-02-06 10:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '230k', '16-bit FLAC'),
(10097458, 782, 'project_33/site_782/2015/2/750B-2015-02-06_16-30.flac', '2015-02-06 16:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.94M', '257k', '16-bit FLAC'),
(10097459, 782, 'project_33/site_782/2015/2/750B-2015-02-12_06-00.flac', '2015-02-12 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.07M', '274k', '16-bit FLAC'),
(10097460, 782, 'project_33/site_782/2015/1/1000A-2015-01-30_05-30.flac', '2015-01-30 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097461, 782, 'project_33/site_782/2015/2/1000A-2015-02-01_05-50.flac', '2015-02-01 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '224k', '16-bit FLAC'),
(10097462, 782, 'project_33/site_782/2015/2/1000A-2015-02-01_06-40.flac', '2015-02-01 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '221k', '16-bit FLAC'),
(10097463, 782, 'project_33/site_782/2015/2/1000A-2015-02-08_06-20.flac', '2015-02-08 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097464, 782, 'project_33/site_782/2015/2/1000A-2015-02-09_06-00.flac', '2015-02-09 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097465, 782, 'project_33/site_782/2015/2/1000A-2015-02-11_05-40.flac', '2015-02-11 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '242k', '16-bit FLAC'),
(10097466, 782, 'project_33/site_782/2015/2/1000A-2015-02-11_06-10.flac', '2015-02-11 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10097467, 782, 'project_33/site_782/2015/2/1000A-2015-02-11_06-50.flac', '2015-02-11 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.79M', '238k', '16-bit FLAC'),
(10097468, 782, 'project_33/site_782/2015/2/1000A-2015-02-11_09-40.flac', '2015-02-11 09:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '236k', '16-bit FLAC'),
(10097469, 782, 'project_33/site_782/2015/2/1000A-2015-02-11_10-20.flac', '2015-02-11 10:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097470, 782, 'project_33/site_782/2015/2/1000A-2015-02-11_11-10.flac', '2015-02-11 11:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '231k', '16-bit FLAC'),
(10097471, 782, 'project_33/site_782/2015/2/1000A-2015-02-11_18-20.flac', '2015-02-11 18:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.84M', '244k', '16-bit FLAC'),
(10097472, 782, 'project_33/site_782/2015/2/1000A-2015-02-12_10-40.flac', '2015-02-12 10:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '237k', '16-bit FLAC'),
(10097473, 782, 'project_33/site_782/2015/2/1000A-2015-02-12_16-40.flac', '2015-02-12 16:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097474, 782, 'project_33/site_782/2015/2/1000A-2015-02-12_17-30.flac', '2015-02-12 17:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '233k', '16-bit FLAC'),
(10097475, 782, 'project_33/site_782/2015/1/1000B-2015-01-30_06-00.flac', '2015-01-30 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.85M', '245k', '16-bit FLAC'),
(10097476, 782, 'project_33/site_782/2015/2/1000B-2015-02-01_06-20.wav.flac', '2015-02-01 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.91M', '254k', '16-bit FLAC'),
(10097477, 782, 'project_33/site_782/2015/2/1000B-2015-02-04_06-50.wav.flac', '2015-02-04 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10097478, 782, 'project_33/site_782/2015/2/1000B-2015-02-05_05-50.flac', '2015-02-05 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.83M', '243k', '16-bit FLAC'),
(10097479, 782, 'project_33/site_782/2015/2/1000B-2015-02-05_06-10.flac', '2015-02-05 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.85M', '246k', '16-bit FLAC'),
(10097480, 782, 'project_33/site_782/2015/2/1000B-2015-02-08_06-10.flac', '2015-02-08 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '234k', '16-bit FLAC'),
(10097481, 782, 'project_33/site_782/2015/2/1000B-2015-02-09_05-40.flac', '2015-02-09 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.89M', '250k', '16-bit FLAC'),
(10097482, 782, 'project_33/site_782/2015/2/1000B-2015-02-09_05-50.flac', '2015-02-09 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.87M', '248k', '16-bit FLAC');
INSERT INTO `recordings` (`recording_id`, `site_id`, `uri`, `datetime`, `mic`, `recorder`, `version`, `sample_rate`, `precision`, `duration`, `samples`, `file_size`, `bit_rate`, `sample_encoding`) VALUES
(10097483, 782, 'project_33/site_782/2015/2/1000B-2015-02-09_06-00.flac', '2015-02-09 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.81M', '240k', '16-bit FLAC'),
(10097484, 782, 'project_33/site_782/2014/10/gb002-2014-10-02_06-10.flac', '2014-10-02 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.81M', '240k', '16-bit FLAC'),
(10097485, 782, 'project_33/site_782/2014/10/gb002-2014-10-02_07-10.flac', '2014-10-02 07:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.03M', '270k', '16-bit FLAC'),
(10097486, 782, 'project_33/site_782/2014/10/gb002-2014-10-03_05-30.flac', '2014-10-03 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '232k', '16-bit FLAC'),
(10097487, 782, 'project_33/site_782/2014/10/gb002-2014-10-03_06-40.flac', '2014-10-03 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097488, 782, 'project_33/site_782/2014/10/gb002-2014-10-05_05-10.flac', '2014-10-05 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '232k', '16-bit FLAC'),
(10097489, 782, 'project_33/site_782/2014/10/gb002-2014-10-05_06-20.flac', '2014-10-05 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097490, 782, 'project_33/site_782/2014/10/gb002-2014-10-09_06-40.flac', '2014-10-09 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.87M', '249k', '16-bit FLAC'),
(10097491, 782, 'project_33/site_782/2014/10/gb003-2014-10-02_05-40.flac', '2014-10-02 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '209k', '16-bit FLAC'),
(10097492, 782, 'project_33/site_782/2014/10/gb003-2014-10-03_07-20.flac', '2014-10-03 07:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.59M', '211k', '16-bit FLAC'),
(10097493, 782, 'project_33/site_782/2014/10/gb003-2014-10-04_06-20.flac', '2014-10-04 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.58M', '210k', '16-bit FLAC'),
(10097494, 782, 'project_33/site_782/2014/10/gb003-2014-10-08_05-30.flac', '2014-10-08 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.18M', '289k', '16-bit FLAC'),
(10097495, 782, 'project_33/site_782/2014/9/gb006-2014-09-27_05-50.flac', '2014-09-27 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.59M', '211k', '16-bit FLAC'),
(10097496, 782, 'project_33/site_782/2014/9/gb006-2014-09-28_05-00.flac', '2014-09-28 05:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.64M', '218k', '16-bit FLAC'),
(10097497, 782, 'project_33/site_782/2014/9/gb006-2014-09-28_05-40.flac', '2014-09-28 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '207k', '16-bit FLAC'),
(10097498, 782, 'project_33/site_782/2014/9/gb006-2014-09-28_05-50.flac', '2014-09-28 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '208k', '16-bit FLAC'),
(10097499, 782, 'project_33/site_782/2014/9/gb006-2014-09-28_06-20.flac', '2014-09-28 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.60M', '213k', '16-bit FLAC'),
(10097500, 782, 'project_33/site_782/2014/10/gb006-2014-10-03_05-00.flac', '2014-10-03 05:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097501, 782, 'project_33/site_782/2014/10/gb006-2014-10-05_05-30.flac', '2014-10-05 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '208k', '16-bit FLAC'),
(10097502, 782, 'project_33/site_782/2014/10/gb006-2014-10-05_06-20.flac', '2014-10-05 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '208k', '16-bit FLAC'),
(10097503, 782, 'project_33/site_782/2014/10/gb006-2014-10-07_06-00.flac', '2014-10-07 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '208k', '16-bit FLAC'),
(10097504, 782, 'project_33/site_782/2014/10/gb006-2014-10-08_06-30.flac', '2014-10-08 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '236k', '16-bit FLAC'),
(10097505, 782, 'project_33/site_782/2014/9/gb007-2014-09-27_06-00.flac', '2014-09-27 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.96M', '260k', '16-bit FLAC'),
(10097506, 782, 'project_33/site_782/2014/9/gb007-2014-09-27_06-40.flac', '2014-09-27 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.11M', '280k', '16-bit FLAC'),
(10097507, 782, 'project_33/site_782/2014/9/gb007-2014-09-27_06-50.flac', '2014-09-27 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.10M', '279k', '16-bit FLAC'),
(10097508, 782, 'project_33/site_782/2014/9/gb007-2014-09-27_07-20.flac', '2014-09-27 07:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.08M', '276k', '16-bit FLAC'),
(10097509, 782, 'project_33/site_782/2014/9/gb007-2014-09-27_07-30.flac', '2014-09-27 07:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.20M', '292k', '16-bit FLAC'),
(10097510, 782, 'project_33/site_782/2014/9/gb007-2014-09-27_07-40.flac', '2014-09-27 07:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.19M', '291k', '16-bit FLAC'),
(10097511, 782, 'project_33/site_782/2014/9/gb007-2014-09-28_05-50.flac', '2014-09-28 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.04M', '270k', '16-bit FLAC'),
(10097512, 782, 'project_33/site_782/2014/10/gb007-2014-10-05_06-10.flac', '2014-10-05 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '220k', '16-bit FLAC'),
(10097513, 782, 'project_33/site_782/2014/10/gb007-2014-10-05_06-30.flac', '2014-10-05 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.64M', '218k', '16-bit FLAC'),
(10097514, 782, 'project_33/site_782/2014/9/gb009-2014-09-27_06-20.flac', '2014-09-27 06:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.93M', '256k', '16-bit FLAC'),
(10097515, 782, 'project_33/site_782/2014/10/gb009-2014-10-04_06-50.flac', '2014-10-04 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.91M', '253k', '16-bit FLAC'),
(10097516, 782, 'project_33/site_782/2014/10/gb009-2014-10-09_05-10.flac', '2014-10-09 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.88M', '250k', '16-bit FLAC'),
(10097517, 782, 'project_33/site_782/2014/10/gb010-2014-10-03_05-20.flac', '2014-10-03 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097518, 782, 'project_33/site_782/2014/10/gb010-2014-10-04_05-30.flac', '2014-10-04 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097519, 782, 'project_33/site_782/2014/10/gb010-2014-10-04_05-40.flac', '2014-10-04 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.60M', '213k', '16-bit FLAC'),
(10097520, 782, 'project_33/site_782/2014/10/gb010-2014-10-04_06-30.flac', '2014-10-04 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097521, 782, 'project_33/site_782/2014/10/gb010-2014-10-04_06-40.flac', '2014-10-04 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097522, 782, 'project_33/site_782/2014/10/gb010-2014-10-04_06-50.flac', '2014-10-04 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.62M', '216k', '16-bit FLAC'),
(10097523, 782, 'project_33/site_782/2014/10/gb010-2014-10-05_05-00.flac', '2014-10-05 05:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.59M', '211k', '16-bit FLAC'),
(10097524, 782, 'project_33/site_782/2014/10/gb010-2014-10-07_05-30.flac', '2014-10-07 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.63M', '216k', '16-bit FLAC'),
(10097525, 782, 'project_33/site_782/2014/10/gb010-2014-10-07_07-40.flac', '2014-10-07 07:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '224k', '16-bit FLAC'),
(10097526, 782, 'project_33/site_782/2014/9/Gb001-2014-09-27_05-30.flac', '2014-09-27 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.61M', '214k', '16-bit FLAC'),
(10097527, 782, 'project_33/site_782/2014/9/Gb001-2014-09-27_06-00.flac', '2014-09-27 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097528, 782, 'project_33/site_782/2014/9/Gb001-2014-09-28_05-20.flac', '2014-09-28 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.60M', '213k', '16-bit FLAC'),
(10097529, 782, 'project_33/site_782/2014/9/Gb001-2014-09-28_06-10.flac', '2014-09-28 06:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '208k', '16-bit FLAC'),
(10097530, 782, 'project_33/site_782/2014/9/Gb001-2014-09-28_07-50.flac', '2014-09-28 07:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.59M', '211k', '16-bit FLAC'),
(10097531, 782, 'project_33/site_782/2014/9/Gb001-2014-09-29_05-20.flac', '2014-09-29 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.63M', '216k', '16-bit FLAC'),
(10097532, 782, 'project_33/site_782/2014/9/Gb001-2014-09-29_05-40.flac', '2014-09-29 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '207k', '16-bit FLAC'),
(10097533, 782, 'project_33/site_782/2014/9/Gb001-2014-09-29_05-50.flac', '2014-09-29 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '209k', '16-bit FLAC'),
(10097534, 782, 'project_33/site_782/2014/9/Gb001-2014-09-30_07-10.flac', '2014-09-30 07:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.91M', '254k', '16-bit FLAC'),
(10097535, 782, 'project_33/site_782/2014/10/Gb001-2014-10-01_05-20.flac', '2014-10-01 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.73M', '230k', '16-bit FLAC'),
(10097536, 782, 'project_33/site_782/2014/10/Gb001-2014-10-01_06-00.flac', '2014-10-01 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097537, 782, 'project_33/site_782/2014/10/Gb001-2014-10-01_09-00.flac', '2014-10-01 09:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.80M', '239k', '16-bit FLAC'),
(10097538, 782, 'project_33/site_782/2014/10/Gb001-2014-10-01_10-10.flac', '2014-10-01 10:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '221k', '16-bit FLAC'),
(10097539, 782, 'project_33/site_782/2014/10/Gb001-2014-10-01_11-00.flac', '2014-10-01 11:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097540, 782, 'project_33/site_782/2014/10/Gb001-2014-10-02_05-30.flac', '2014-10-02 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.67M', '222k', '16-bit FLAC'),
(10097541, 782, 'project_33/site_782/2014/10/Gb001-2014-10-02_05-50.flac', '2014-10-02 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.64M', '218k', '16-bit FLAC'),
(10097542, 782, 'project_33/site_782/2014/10/Gb001-2014-10-03_05-30.flac', '2014-10-03 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '208k', '16-bit FLAC'),
(10097543, 782, 'project_33/site_782/2014/10/Gb001-2014-10-03_06-50.flac', '2014-10-03 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.66M', '220k', '16-bit FLAC'),
(10097544, 782, 'project_33/site_782/2014/10/Gb001-2014-10-03_07-00.flac', '2014-10-03 07:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.62M', '215k', '16-bit FLAC'),
(10097545, 782, 'project_33/site_782/2014/10/Gb001-2014-10-03_14-10.flac', '2014-10-03 14:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.53M', '203k', '16-bit FLAC'),
(10097546, 782, 'project_33/site_782/2014/10/Gb001-2014-10-04_05-30.flac', '2014-10-04 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '208k', '16-bit FLAC'),
(10097547, 782, 'project_33/site_782/2014/10/Gb001-2014-10-04_06-50.flac', '2014-10-04 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '225k', '16-bit FLAC'),
(10097548, 782, 'project_33/site_782/2014/10/Gb001-2014-10-05_05-20.flac', '2014-10-05 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.68M', '223k', '16-bit FLAC'),
(10097549, 782, 'project_33/site_782/2014/10/Gb001-2014-10-05_05-30.flac', '2014-10-05 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.63M', '216k', '16-bit FLAC'),
(10097550, 782, 'project_33/site_782/2014/10/Gb001-2014-10-06_05-30.flac', '2014-10-06 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.64M', '218k', '16-bit FLAC'),
(10097551, 782, 'project_33/site_782/2014/10/Gb001-2014-10-06_05-50.flac', '2014-10-06 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '207k', '16-bit FLAC'),
(10097552, 782, 'project_33/site_782/2014/10/Gb001-2014-10-06_06-00.flac', '2014-10-06 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.58M', '210k', '16-bit FLAC'),
(10097553, 782, 'project_33/site_782/2014/10/Gb001-2014-10-07_05-30.flac', '2014-10-07 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '209k', '16-bit FLAC'),
(10097554, 782, 'project_33/site_782/2014/10/Gb001-2014-10-07_05-40.flac', '2014-10-07 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '207k', '16-bit FLAC'),
(10097555, 782, 'project_33/site_782/2014/10/Gb001-2014-10-08_05-20.flac', '2014-10-08 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.76M', '233k', '16-bit FLAC'),
(10097556, 782, 'project_33/site_782/2014/10/Gb001-2014-10-08_05-30.flac', '2014-10-08 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.72M', '229k', '16-bit FLAC'),
(10097557, 782, 'project_33/site_782/2014/10/Gb001-2014-10-08_06-40.flac', '2014-10-08 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097558, 782, 'project_33/site_782/2014/10/Gb001-2014-10-09_06-50.flac', '2014-10-09 06:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.78M', '237k', '16-bit FLAC'),
(10097559, 782, 'project_33/site_782/2014/10/Gb004-2014-10-01_06-30.flac', '2014-10-01 06:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.93M', '257k', '16-bit FLAC'),
(10097560, 782, 'project_33/site_782/2014/10/Gb004-2014-10-03_05-50.flac', '2014-10-03 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.77M', '235k', '16-bit FLAC'),
(10097561, 782, 'project_33/site_782/2014/10/Gb004-2014-10-05_05-40.flac', '2014-10-05 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.57M', '209k', '16-bit FLAC'),
(10097562, 782, 'project_33/site_782/2014/10/Gb004-2014-10-05_05-50.flac', '2014-10-05 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.56M', '208k', '16-bit FLAC'),
(10097563, 782, 'project_33/site_782/2014/9/Gb005-2014-09-28_05-20.flac', '2014-09-28 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.89M', '251k', '16-bit FLAC'),
(10097564, 782, 'project_33/site_782/2014/9/Gb005-2014-09-28_05-30.flac', '2014-09-28 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.79M', '237k', '16-bit FLAC'),
(10097565, 782, 'project_33/site_782/2014/9/Gb005-2014-09-29_05-10.flac', '2014-09-29 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.89M', '251k', '16-bit FLAC'),
(10097566, 782, 'project_33/site_782/2014/10/Gb005-2014-10-01_05-20.flac', '2014-10-01 05:20:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.98M', '262k', '16-bit FLAC'),
(10097567, 782, 'project_33/site_782/2014/10/Gb005-2014-10-01_06-40.flac', '2014-10-01 06:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.90M', '253k', '16-bit FLAC'),
(10097568, 782, 'project_33/site_782/2014/10/Gb005-2014-10-06_05-50.flac', '2014-10-06 05:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.69M', '224k', '16-bit FLAC'),
(10097569, 782, 'project_33/site_782/2014/10/Gb005-2014-10-08_05-10.flac', '2014-10-08 05:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.58M', '209k', '16-bit FLAC'),
(10097570, 782, 'project_33/site_782/2014/10/Gb005-2014-10-08_05-30.flac', '2014-10-08 05:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.53M', '204k', '16-bit FLAC'),
(10097571, 782, 'project_33/site_782/2014/10/Gb005-2014-10-08_05-40.flac', '2014-10-08 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.55M', '206k', '16-bit FLAC'),
(10097572, 782, 'project_33/site_782/2014/10/Gb005-2014-10-09_05-40.flac', '2014-10-09 05:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.54M', '204k', '16-bit FLAC'),
(10097573, 782, 'project_33/site_782/2014/10/Gb008-2014-10-01_09-10.flac', '2014-10-01 09:10:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.74M', '232k', '16-bit FLAC'),
(10097574, 782, 'project_33/site_782/2014/10/Gb008-2014-10-01_09-30.flac', '2014-10-01 09:30:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.82M', '242k', '16-bit FLAC'),
(10097575, 782, 'project_33/site_782/2014/10/Gb008-2014-10-02_07-40.flac', '2014-10-02 07:40:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.75M', '232k', '16-bit FLAC'),
(10097576, 782, 'project_33/site_782/2014/10/Gb008-2014-10-02_07-50.flac', '2014-10-02 07:50:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '1.65M', '219k', '16-bit FLAC'),
(10097577, 782, 'project_33/site_782/2014/10/Gb008-2014-10-03_06-00.flac', '2014-10-03 06:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.19M', '291k', '16-bit FLAC'),
(10097578, 782, 'project_33/site_782/2014/10/Gb008-2014-10-07_05-00.flac', '2014-10-07 05:00:00', 'U', 'U', 'U', 44100, 16, 60.25, 2657025, '2.06M', '273k', '16-bit FLAC');

-- --------------------------------------------------------

--
-- Table structure for table `recordings_errors`
--

CREATE TABLE IF NOT EXISTS `recordings_errors` (
  `recording_id` int(11) NOT NULL,
  `job_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `recordings_errors`
--

INSERT INTO `recordings_errors` (`recording_id`, `job_id`) VALUES
(10096691, 891),
(10096691, 891),
(10096690, 891),
(10096846, 898),
(10096731, 898),
(10096872, 902),
(10096872, 902),
(10096872, 902),
(10096872, 901),
(10096872, 901),
(10096872, 901),
(10096872, 900),
(10096872, 900),
(10096872, 900),
(10096872, 899),
(10096872, 899),
(10096872, 899),
(10096872, 902),
(10096872, 902),
(10096872, 901),
(10096872, 901),
(10096872, 901),
(10096872, 900),
(10096872, 900),
(10096872, 900),
(10096872, 899),
(10096872, 899),
(10096872, 899);

-- --------------------------------------------------------

--
-- Table structure for table `recording_validations`
--

CREATE TABLE IF NOT EXISTS `recording_validations` (
`recording_validation_id` bigint(20) unsigned NOT NULL,
  `recording_id` bigint(20) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `species_id` int(11) NOT NULL,
  `songtype_id` int(11) NOT NULL,
  `present` tinyint(1) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=52819 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `recording_validations`
--

INSERT INTO `recording_validations` (`recording_validation_id`, `recording_id`, `project_id`, `user_id`, `species_id`, `songtype_id`, `present`) VALUES
(51981, 10096661, 33, 1, 16771, 1, 0),
(51982, 10096660, 33, 1, 16771, 1, 0),
(51983, 10096659, 33, 1, 16771, 1, 0),
(51984, 10096658, 33, 1, 16771, 1, 0),
(51985, 10096657, 33, 1, 16771, 1, 0),
(51986, 10096656, 33, 1, 16771, 1, 0),
(51987, 10096655, 33, 1, 16771, 1, 0),
(51988, 10096654, 33, 1, 16771, 1, 0),
(51989, 10096653, 33, 1, 16771, 1, 0),
(51990, 10096652, 33, 1, 16771, 1, 0),
(51991, 10096651, 33, 1, 16771, 1, 0),
(51992, 10096650, 33, 1, 16771, 1, 0),
(51993, 10096649, 33, 1, 16771, 1, 0),
(51994, 10096648, 33, 1, 16771, 1, 0),
(51995, 10096647, 33, 1, 16771, 1, 0),
(51996, 10096646, 33, 1, 16771, 1, 0),
(51997, 10096645, 33, 1, 16771, 1, 0),
(51998, 10096644, 33, 1, 16771, 1, 0),
(51999, 10096643, 33, 1, 16771, 1, 0),
(52000, 10096642, 33, 1, 16771, 1, 0),
(52001, 10096641, 33, 1, 16771, 1, 0),
(52002, 10096640, 33, 1, 16771, 1, 0),
(52003, 10096639, 33, 1, 16771, 1, 0),
(52004, 10096638, 33, 1, 16771, 1, 0),
(52005, 10096637, 33, 1, 16771, 1, 0),
(52006, 10096636, 33, 1, 16771, 1, 0),
(52007, 10096635, 33, 1, 16771, 1, 0),
(52008, 10096634, 33, 1, 16771, 1, 0),
(52009, 10096633, 33, 1, 16771, 1, 0),
(52010, 10096632, 33, 1, 16771, 1, 0),
(52012, 10096691, 33, 1, 16771, 1, 1),
(52013, 10096690, 33, 1, 16771, 1, 1),
(52014, 10096689, 33, 1, 16771, 1, 1),
(52015, 10096688, 33, 1, 16771, 1, 1),
(52016, 10096687, 33, 1, 16771, 1, 1),
(52017, 10096686, 33, 1, 16771, 1, 1),
(52018, 10096685, 33, 1, 16771, 1, 1),
(52019, 10096684, 33, 1, 16771, 1, 1),
(52020, 10096683, 33, 1, 16771, 1, 1),
(52021, 10096682, 33, 1, 16771, 1, 1),
(52022, 10096681, 33, 1, 16771, 1, 1),
(52023, 10096680, 33, 1, 16771, 1, 1),
(52024, 10096679, 33, 1, 16771, 1, 1),
(52025, 10096678, 33, 1, 16771, 1, 1),
(52026, 10096677, 33, 1, 16771, 1, 1),
(52027, 10096676, 33, 1, 16771, 1, 1),
(52028, 10096675, 33, 1, 16771, 1, 1),
(52029, 10096674, 33, 1, 16771, 1, 1),
(52030, 10096673, 33, 1, 16771, 1, 1),
(52031, 10096672, 33, 1, 16771, 1, 1),
(52032, 10096671, 33, 1, 16771, 1, 1),
(52033, 10096670, 33, 1, 16771, 1, 1),
(52034, 10096669, 33, 1, 16771, 1, 1),
(52035, 10096668, 33, 1, 16771, 1, 1),
(52036, 10096667, 33, 1, 16771, 1, 1),
(52037, 10096666, 33, 1, 16771, 1, 1),
(52038, 10096665, 33, 1, 16771, 1, 1),
(52039, 10096664, 33, 1, 16771, 1, 1),
(52040, 10096663, 33, 1, 16771, 1, 1),
(52041, 10096662, 33, 1, 16771, 1, 1),
(52043, 10096692, 33, 1, 16772, 1, 0),
(52044, 10096693, 33, 1, 16772, 1, 0),
(52045, 10096694, 33, 1, 16772, 1, 0),
(52046, 10096695, 33, 1, 16772, 1, 0),
(52047, 10096696, 33, 1, 16772, 1, 0),
(52048, 10096697, 33, 1, 16772, 1, 0),
(52049, 10096698, 33, 1, 16772, 1, 0),
(52050, 10096699, 33, 1, 16772, 1, 0),
(52051, 10096700, 33, 1, 16772, 1, 0),
(52052, 10096701, 33, 1, 16772, 1, 0),
(52053, 10096702, 33, 1, 16772, 1, 0),
(52054, 10096703, 33, 1, 16772, 1, 0),
(52055, 10096704, 33, 1, 16772, 1, 0),
(52056, 10096705, 33, 1, 16772, 1, 0),
(52057, 10096706, 33, 1, 16772, 1, 0),
(52058, 10096707, 33, 1, 16772, 1, 0),
(52059, 10096708, 33, 1, 16772, 1, 0),
(52060, 10096709, 33, 1, 16772, 1, 0),
(52061, 10096710, 33, 1, 16772, 1, 0),
(52062, 10096711, 33, 1, 16772, 1, 0),
(52063, 10096712, 33, 1, 16772, 1, 0),
(52064, 10096713, 33, 1, 16772, 1, 0),
(52065, 10096714, 33, 1, 16772, 1, 0),
(52066, 10096715, 33, 1, 16772, 1, 0),
(52067, 10096716, 33, 1, 16772, 1, 0),
(52068, 10096717, 33, 1, 16772, 1, 0),
(52069, 10096718, 33, 1, 16772, 1, 0),
(52070, 10096719, 33, 1, 16772, 1, 0),
(52071, 10096720, 33, 1, 16772, 1, 0),
(52072, 10096721, 33, 1, 16772, 1, 0),
(52074, 10096722, 33, 1, 16772, 1, 1),
(52075, 10096723, 33, 1, 16772, 1, 1),
(52076, 10096724, 33, 1, 16772, 1, 1),
(52077, 10096725, 33, 1, 16772, 1, 1),
(52078, 10096726, 33, 1, 16772, 1, 1),
(52079, 10096727, 33, 1, 16772, 1, 1),
(52080, 10096728, 33, 1, 16772, 1, 1),
(52081, 10096729, 33, 1, 16772, 1, 1),
(52082, 10096730, 33, 1, 16772, 1, 1),
(52083, 10096731, 33, 1, 16772, 1, 1),
(52084, 10096732, 33, 1, 16772, 1, 1),
(52085, 10096733, 33, 1, 16772, 1, 1),
(52086, 10096734, 33, 1, 16772, 1, 1),
(52087, 10096735, 33, 1, 16772, 1, 1),
(52088, 10096736, 33, 1, 16772, 1, 1),
(52089, 10096737, 33, 1, 16772, 1, 1),
(52090, 10096738, 33, 1, 16772, 1, 1),
(52091, 10096739, 33, 1, 16772, 1, 1),
(52092, 10096740, 33, 1, 16772, 1, 1),
(52093, 10096741, 33, 1, 16772, 1, 1),
(52094, 10096742, 33, 1, 16772, 1, 1),
(52095, 10096743, 33, 1, 16772, 1, 1),
(52096, 10096744, 33, 1, 16772, 1, 1),
(52097, 10096745, 33, 1, 16772, 1, 1),
(52098, 10096746, 33, 1, 16772, 1, 1),
(52099, 10096747, 33, 1, 16772, 1, 1),
(52100, 10096748, 33, 1, 16772, 1, 1),
(52101, 10096749, 33, 1, 16772, 1, 1),
(52102, 10096750, 33, 1, 16772, 1, 1),
(52103, 10096751, 33, 1, 16772, 1, 1),
(52105, 10096782, 33, 1, 16773, 1, 1),
(52106, 10096783, 33, 1, 16773, 1, 1),
(52107, 10096784, 33, 1, 16773, 1, 1),
(52108, 10096785, 33, 1, 16773, 1, 1),
(52109, 10096786, 33, 1, 16773, 1, 1),
(52110, 10096787, 33, 1, 16773, 1, 1),
(52111, 10096788, 33, 1, 16773, 1, 1),
(52112, 10096789, 33, 1, 16773, 1, 1),
(52113, 10096790, 33, 1, 16773, 1, 1),
(52114, 10096791, 33, 1, 16773, 1, 1),
(52115, 10096792, 33, 1, 16773, 1, 1),
(52116, 10096793, 33, 1, 16773, 1, 1),
(52117, 10096794, 33, 1, 16773, 1, 1),
(52118, 10096795, 33, 1, 16773, 1, 1),
(52119, 10096796, 33, 1, 16773, 1, 1),
(52120, 10096797, 33, 1, 16773, 1, 1),
(52121, 10096798, 33, 1, 16773, 1, 1),
(52122, 10096799, 33, 1, 16773, 1, 1),
(52123, 10096800, 33, 1, 16773, 1, 1),
(52124, 10096801, 33, 1, 16773, 1, 1),
(52125, 10096802, 33, 1, 16773, 1, 1),
(52126, 10096803, 33, 1, 16773, 1, 1),
(52127, 10096804, 33, 1, 16773, 1, 1),
(52128, 10096805, 33, 1, 16773, 1, 1),
(52129, 10096806, 33, 1, 16773, 1, 1),
(52130, 10096807, 33, 1, 16773, 1, 1),
(52131, 10096808, 33, 1, 16773, 1, 1),
(52132, 10096809, 33, 1, 16773, 1, 1),
(52133, 10096810, 33, 1, 16773, 1, 1),
(52134, 10096811, 33, 1, 16773, 1, 1),
(52136, 10096752, 33, 1, 16773, 1, 0),
(52137, 10096753, 33, 1, 16773, 1, 0),
(52138, 10096754, 33, 1, 16773, 1, 0),
(52139, 10096755, 33, 1, 16773, 1, 0),
(52140, 10096756, 33, 1, 16773, 1, 0),
(52141, 10096757, 33, 1, 16773, 1, 0),
(52142, 10096758, 33, 1, 16773, 1, 0),
(52143, 10096759, 33, 1, 16773, 1, 0),
(52144, 10096760, 33, 1, 16773, 1, 0),
(52145, 10096761, 33, 1, 16773, 1, 0),
(52146, 10096762, 33, 1, 16773, 1, 0),
(52147, 10096763, 33, 1, 16773, 1, 0),
(52148, 10096764, 33, 1, 16773, 1, 0),
(52149, 10096765, 33, 1, 16773, 1, 0),
(52150, 10096766, 33, 1, 16773, 1, 0),
(52151, 10096767, 33, 1, 16773, 1, 0),
(52152, 10096768, 33, 1, 16773, 1, 0),
(52153, 10096769, 33, 1, 16773, 1, 0),
(52154, 10096770, 33, 1, 16773, 1, 0),
(52155, 10096771, 33, 1, 16773, 1, 0),
(52156, 10096772, 33, 1, 16773, 1, 0),
(52157, 10096773, 33, 1, 16773, 1, 0),
(52158, 10096774, 33, 1, 16773, 1, 0),
(52159, 10096775, 33, 1, 16773, 1, 0),
(52160, 10096776, 33, 1, 16773, 1, 0),
(52161, 10096777, 33, 1, 16773, 1, 0),
(52162, 10096778, 33, 1, 16773, 1, 0),
(52163, 10096779, 33, 1, 16773, 1, 0),
(52164, 10096780, 33, 1, 16773, 1, 0),
(52165, 10096781, 33, 1, 16773, 1, 0),
(52167, 10096812, 33, 1, 16773, 1, 0),
(52168, 10096813, 33, 1, 16773, 1, 0),
(52169, 10096814, 33, 1, 16773, 1, 0),
(52170, 10096815, 33, 1, 16773, 1, 0),
(52171, 10096816, 33, 1, 16773, 1, 0),
(52172, 10096817, 33, 1, 16773, 1, 0),
(52173, 10096818, 33, 1, 16773, 1, 0),
(52174, 10096819, 33, 1, 16773, 1, 0),
(52175, 10096820, 33, 1, 16773, 1, 0),
(52176, 10096821, 33, 1, 16773, 1, 0),
(52177, 10096822, 33, 1, 16773, 1, 0),
(52178, 10096823, 33, 1, 16773, 1, 0),
(52179, 10096824, 33, 1, 16773, 1, 0),
(52180, 10096825, 33, 1, 16773, 1, 0),
(52181, 10096826, 33, 1, 16773, 1, 0),
(52182, 10096827, 33, 1, 16773, 1, 0),
(52183, 10096828, 33, 1, 16773, 1, 0),
(52184, 10096829, 33, 1, 16773, 1, 0),
(52185, 10096830, 33, 1, 16773, 1, 0),
(52186, 10096831, 33, 1, 16773, 1, 0),
(52187, 10096832, 33, 1, 16773, 1, 0),
(52188, 10096833, 33, 1, 16773, 1, 0),
(52189, 10096834, 33, 1, 16773, 1, 0),
(52190, 10096835, 33, 1, 16773, 1, 0),
(52191, 10096836, 33, 1, 16773, 1, 0),
(52192, 10096837, 33, 1, 16773, 1, 0),
(52193, 10096838, 33, 1, 16773, 1, 0),
(52194, 10096839, 33, 1, 16773, 1, 0),
(52195, 10096840, 33, 1, 16773, 1, 0),
(52196, 10096841, 33, 1, 16773, 1, 0),
(52198, 10096842, 33, 1, 16773, 1, 1),
(52199, 10096843, 33, 1, 16773, 1, 1),
(52200, 10096844, 33, 1, 16773, 1, 1),
(52201, 10096845, 33, 1, 16773, 1, 1),
(52202, 10096846, 33, 1, 16773, 1, 1),
(52203, 10096847, 33, 1, 16773, 1, 1),
(52204, 10096848, 33, 1, 16773, 1, 1),
(52205, 10096849, 33, 1, 16773, 1, 1),
(52206, 10096850, 33, 1, 16773, 1, 1),
(52207, 10096851, 33, 1, 16773, 1, 1),
(52208, 10096852, 33, 1, 16773, 1, 1),
(52209, 10096853, 33, 1, 16773, 1, 1),
(52210, 10096854, 33, 1, 16773, 1, 1),
(52211, 10096855, 33, 1, 16773, 1, 1),
(52212, 10096856, 33, 1, 16773, 1, 1),
(52213, 10096857, 33, 1, 16773, 1, 1),
(52214, 10096858, 33, 1, 16773, 1, 1),
(52215, 10096859, 33, 1, 16773, 1, 1),
(52216, 10096860, 33, 1, 16773, 1, 1),
(52217, 10096861, 33, 1, 16773, 1, 1),
(52218, 10096862, 33, 1, 16773, 1, 1),
(52219, 10096863, 33, 1, 16773, 1, 1),
(52220, 10096864, 33, 1, 16773, 1, 1),
(52221, 10096865, 33, 1, 16773, 1, 1),
(52222, 10096866, 33, 1, 16773, 1, 1),
(52223, 10096867, 33, 1, 16773, 1, 1),
(52224, 10096868, 33, 1, 16773, 1, 1),
(52225, 10096869, 33, 1, 16773, 1, 1),
(52226, 10096870, 33, 1, 16773, 1, 1),
(52227, 10096871, 33, 1, 16773, 1, 1),
(52229, 10096812, 33, 1, 16772, 1, 0),
(52230, 10096813, 33, 1, 16772, 1, 0),
(52231, 10096814, 33, 1, 16772, 1, 0),
(52232, 10096815, 33, 1, 16772, 1, 0),
(52233, 10096816, 33, 1, 16772, 1, 0),
(52234, 10096817, 33, 1, 16772, 1, 0),
(52235, 10096818, 33, 1, 16772, 1, 0),
(52236, 10096819, 33, 1, 16772, 1, 0),
(52237, 10096820, 33, 1, 16772, 1, 0),
(52238, 10096821, 33, 1, 16772, 1, 0),
(52239, 10096822, 33, 1, 16772, 1, 0),
(52240, 10096823, 33, 1, 16772, 1, 0),
(52241, 10096824, 33, 1, 16772, 1, 0),
(52242, 10096825, 33, 1, 16772, 1, 0),
(52243, 10096826, 33, 1, 16772, 1, 0),
(52244, 10096827, 33, 1, 16772, 1, 0),
(52245, 10096828, 33, 1, 16772, 1, 0),
(52246, 10096829, 33, 1, 16772, 1, 0),
(52247, 10096830, 33, 1, 16772, 1, 0),
(52248, 10096831, 33, 1, 16772, 1, 0),
(52249, 10096832, 33, 1, 16772, 1, 0),
(52250, 10096833, 33, 1, 16772, 1, 0),
(52251, 10096834, 33, 1, 16772, 1, 0),
(52252, 10096835, 33, 1, 16772, 1, 0),
(52253, 10096836, 33, 1, 16772, 1, 0),
(52254, 10096837, 33, 1, 16772, 1, 0),
(52255, 10096838, 33, 1, 16772, 1, 0),
(52256, 10096839, 33, 1, 16772, 1, 0),
(52257, 10096840, 33, 1, 16772, 1, 0),
(52258, 10096841, 33, 1, 16772, 1, 0),
(52260, 10096842, 33, 1, 16772, 1, 1),
(52261, 10096843, 33, 1, 16772, 1, 1),
(52262, 10096844, 33, 1, 16772, 1, 1),
(52263, 10096845, 33, 1, 16772, 1, 1),
(52264, 10096846, 33, 1, 16772, 1, 1),
(52265, 10096847, 33, 1, 16772, 1, 1),
(52266, 10096848, 33, 1, 16772, 1, 1),
(52267, 10096849, 33, 1, 16772, 1, 1),
(52268, 10096850, 33, 1, 16772, 1, 1),
(52269, 10096851, 33, 1, 16772, 1, 1),
(52270, 10096852, 33, 1, 16772, 1, 1),
(52271, 10096853, 33, 1, 16772, 1, 1),
(52272, 10096854, 33, 1, 16772, 1, 1),
(52273, 10096855, 33, 1, 16772, 1, 1),
(52274, 10096856, 33, 1, 16772, 1, 1),
(52275, 10096857, 33, 1, 16772, 1, 1),
(52276, 10096858, 33, 1, 16772, 1, 1),
(52277, 10096859, 33, 1, 16772, 1, 1),
(52278, 10096860, 33, 1, 16772, 1, 1),
(52279, 10096861, 33, 1, 16772, 1, 1),
(52280, 10096862, 33, 1, 16772, 1, 1),
(52281, 10096863, 33, 1, 16772, 1, 1),
(52282, 10096864, 33, 1, 16772, 1, 1),
(52283, 10096865, 33, 1, 16772, 1, 1),
(52284, 10096866, 33, 1, 16772, 1, 1),
(52285, 10096867, 33, 1, 16772, 1, 1),
(52286, 10096868, 33, 1, 16772, 1, 1),
(52287, 10096869, 33, 1, 16772, 1, 1),
(52288, 10096870, 33, 1, 16772, 1, 1),
(52289, 10096871, 33, 1, 16772, 1, 1),
(52291, 10096887, 33, 1, 16774, 1, 1),
(52292, 10096888, 33, 1, 16774, 1, 1),
(52293, 10096889, 33, 1, 16774, 1, 1),
(52294, 10096890, 33, 1, 16774, 1, 1),
(52295, 10096891, 33, 1, 16774, 1, 1),
(52296, 10096892, 33, 1, 16774, 1, 1),
(52297, 10096893, 33, 1, 16774, 1, 1),
(52298, 10096894, 33, 1, 16774, 1, 1),
(52299, 10096895, 33, 1, 16774, 1, 1),
(52300, 10096896, 33, 1, 16774, 1, 1),
(52301, 10096897, 33, 1, 16774, 1, 1),
(52302, 10096898, 33, 1, 16774, 1, 1),
(52303, 10096899, 33, 1, 16774, 1, 1),
(52304, 10096900, 33, 1, 16774, 1, 1),
(52305, 10096901, 33, 1, 16774, 1, 1),
(52306, 10096872, 33, 1, 16774, 1, 0),
(52307, 10096873, 33, 1, 16774, 1, 0),
(52308, 10096874, 33, 1, 16774, 1, 0),
(52309, 10096875, 33, 1, 16774, 1, 0),
(52310, 10096876, 33, 1, 16774, 1, 0),
(52311, 10096877, 33, 1, 16774, 1, 0),
(52312, 10096878, 33, 1, 16774, 1, 0),
(52313, 10096879, 33, 1, 16774, 1, 0),
(52314, 10096880, 33, 1, 16774, 1, 0),
(52315, 10096881, 33, 1, 16774, 1, 0),
(52316, 10096882, 33, 1, 16774, 1, 0),
(52317, 10096883, 33, 1, 16774, 1, 0),
(52318, 10096884, 33, 1, 16774, 1, 0),
(52319, 10096885, 33, 1, 16774, 1, 0),
(52320, 10096886, 33, 1, 16774, 1, 0),
(52321, 10096903, 33, 1, 16775, 1, 0),
(52322, 10096904, 33, 1, 16775, 1, 0),
(52323, 10096905, 33, 1, 16775, 1, 0),
(52324, 10096906, 33, 1, 16775, 1, 1),
(52325, 10096908, 33, 1, 16775, 1, 1),
(52326, 10096909, 33, 1, 16775, 1, 1),
(52327, 10096915, 33, 1, 16775, 1, 1),
(52328, 10096916, 33, 1, 16775, 1, 1),
(52329, 10096917, 33, 1, 16775, 1, 1),
(52330, 10096923, 33, 1, 16775, 1, 1),
(52331, 10096924, 33, 1, 16775, 1, 1),
(52332, 10096927, 33, 1, 16775, 1, 0),
(52333, 10096926, 33, 1, 16775, 1, 0),
(52334, 10096925, 33, 1, 16775, 1, 1),
(52335, 10096928, 33, 1, 16775, 1, 0),
(52336, 10096929, 33, 1, 16775, 1, 0),
(52337, 10096930, 33, 1, 16775, 1, 0),
(52338, 10096933, 33, 1, 16775, 1, 0),
(52339, 10096937, 33, 1, 16775, 1, 0),
(52340, 10096938, 33, 1, 16775, 1, 0),
(52341, 10096939, 33, 1, 16775, 1, 0),
(52342, 10096940, 33, 1, 16775, 1, 0),
(52343, 10096941, 33, 1, 16775, 1, 0),
(52344, 10096931, 33, 1, 16775, 1, 0),
(52345, 10096934, 33, 1, 16775, 1, 0),
(52346, 10096943, 33, 1, 16775, 1, 0),
(52347, 10096912, 33, 1, 16775, 1, 1),
(52348, 10096918, 33, 1, 16775, 1, 1),
(52349, 10096920, 33, 1, 16775, 1, 1),
(52350, 10096921, 33, 1, 16775, 1, 1),
(52351, 10096922, 33, 1, 16775, 1, 1),
(52352, 10096932, 33, 1, 16775, 1, 0),
(52353, 10096911, 33, 1, 16775, 1, 1),
(52354, 10096935, 33, 1, 16775, 1, 0),
(52355, 10096936, 33, 1, 16775, 1, 0),
(52356, 10096942, 33, 1, 16775, 1, 0),
(52357, 10096944, 33, 1, 16775, 1, 0),
(52358, 10096945, 33, 1, 16775, 1, 0),
(52359, 10096946, 33, 1, 16775, 1, 0),
(52360, 10096907, 33, 1, 16775, 1, 0),
(52361, 10096913, 33, 1, 16775, 1, 1),
(52362, 10096914, 33, 1, 16775, 1, 1),
(52363, 10096919, 33, 1, 16775, 1, 1),
(52364, 10096910, 33, 1, 16775, 1, 1),
(52365, 10096902, 33, 1, 16775, 1, 0),
(52366, 10097053, 33, 1, 16776, 1, 1),
(52367, 10096950, 33, 1, 16776, 1, 1),
(52368, 10096975, 33, 1, 16776, 1, 1),
(52369, 10096984, 33, 1, 16776, 1, 1),
(52370, 10097001, 33, 1, 16776, 1, 1),
(52371, 10096973, 33, 1, 16776, 1, 1),
(52372, 10097026, 33, 1, 16776, 1, 1),
(52373, 10096949, 33, 1, 16776, 1, 1),
(52374, 10097044, 33, 1, 16776, 1, 1),
(52375, 10097043, 33, 1, 16776, 1, 1),
(52376, 10097028, 33, 1, 16776, 1, 1),
(52377, 10097004, 33, 1, 16776, 1, 1),
(52378, 10097027, 33, 1, 16776, 1, 1),
(52379, 10097029, 33, 1, 16776, 1, 1),
(52380, 10097052, 33, 1, 16776, 1, 1),
(52381, 10096947, 33, 1, 16776, 1, 1),
(52382, 10096976, 33, 1, 16776, 1, 1),
(52383, 10096977, 33, 1, 16776, 1, 1),
(52384, 10096978, 33, 1, 16776, 1, 0),
(52385, 10096979, 33, 1, 16776, 1, 1),
(52386, 10096980, 33, 1, 16776, 1, 0),
(52387, 10096981, 33, 1, 16776, 1, 1),
(52388, 10096982, 33, 1, 16776, 1, 1),
(52389, 10096983, 33, 1, 16776, 1, 0),
(52390, 10096985, 33, 1, 16776, 1, 0),
(52391, 10096986, 33, 1, 16776, 1, 1),
(52392, 10096987, 33, 1, 16776, 1, 1),
(52393, 10096988, 33, 1, 16776, 1, 1),
(52394, 10096989, 33, 1, 16776, 1, 1),
(52395, 10096990, 33, 1, 16776, 1, 1),
(52396, 10096991, 33, 1, 16776, 1, 0),
(52397, 10096992, 33, 1, 16776, 1, 0),
(52398, 10096993, 33, 1, 16776, 1, 1),
(52399, 10096994, 33, 1, 16776, 1, 0),
(52400, 10096995, 33, 1, 16776, 1, 1),
(52401, 10096996, 33, 1, 16776, 1, 0),
(52402, 10096997, 33, 1, 16776, 1, 1),
(52403, 10096998, 33, 1, 16776, 1, 0),
(52404, 10096999, 33, 1, 16776, 1, 0),
(52405, 10097000, 33, 1, 16776, 1, 0),
(52406, 10097002, 33, 1, 16776, 1, 1),
(52407, 10097003, 33, 1, 16776, 1, 1),
(52408, 10097005, 33, 1, 16776, 1, 1),
(52409, 10097006, 33, 1, 16776, 1, 1),
(52410, 10097007, 33, 1, 16776, 1, 1),
(52411, 10097008, 33, 1, 16776, 1, 1),
(52412, 10097009, 33, 1, 16776, 1, 1),
(52413, 10097010, 33, 1, 16776, 1, 0),
(52414, 10097011, 33, 1, 16776, 1, 0),
(52415, 10097012, 33, 1, 16776, 1, 1),
(52416, 10097013, 33, 1, 16776, 1, 1),
(52417, 10097014, 33, 1, 16776, 1, 1),
(52418, 10097015, 33, 1, 16776, 1, 1),
(52419, 10097016, 33, 1, 16776, 1, 0),
(52420, 10097017, 33, 1, 16776, 1, 1),
(52421, 10097018, 33, 1, 16776, 1, 0),
(52422, 10097019, 33, 1, 16776, 1, 1),
(52423, 10097020, 33, 1, 16776, 1, 1),
(52424, 10097021, 33, 1, 16776, 1, 0),
(52425, 10097022, 33, 1, 16776, 1, 1),
(52426, 10097023, 33, 1, 16776, 1, 0),
(52427, 10097024, 33, 1, 16776, 1, 0),
(52428, 10097025, 33, 1, 16776, 1, 0),
(52429, 10097058, 33, 1, 16776, 1, 0),
(52430, 10097059, 33, 1, 16776, 1, 0),
(52431, 10097060, 33, 1, 16776, 1, 0),
(52432, 10097061, 33, 1, 16776, 1, 0),
(52433, 10097062, 33, 1, 16776, 1, 0),
(52434, 10097063, 33, 1, 16776, 1, 0),
(52435, 10097064, 33, 1, 16776, 1, 0),
(52436, 10097065, 33, 1, 16776, 1, 0),
(52437, 10097066, 33, 1, 16776, 1, 0),
(52438, 10097067, 33, 1, 16776, 1, 0),
(52439, 10096966, 33, 1, 16776, 1, 0),
(52440, 10096967, 33, 1, 16776, 1, 1),
(52441, 10096968, 33, 1, 16776, 1, 0),
(52442, 10096969, 33, 1, 16776, 1, 0),
(52443, 10096970, 33, 1, 16776, 1, 0),
(52444, 10096971, 33, 1, 16776, 1, 0),
(52445, 10096972, 33, 1, 16776, 1, 0),
(52446, 10096954, 33, 1, 16776, 1, 0),
(52447, 10096955, 33, 1, 16776, 1, 0),
(52448, 10096956, 33, 1, 16776, 1, 0),
(52449, 10096957, 33, 1, 16776, 1, 0),
(52450, 10096958, 33, 1, 16776, 1, 0),
(52451, 10096959, 33, 1, 16776, 1, 1),
(52452, 10096960, 33, 1, 16776, 1, 0),
(52453, 10096961, 33, 1, 16776, 1, 0),
(52454, 10096962, 33, 1, 16776, 1, 0),
(52455, 10096963, 33, 1, 16776, 1, 0),
(52456, 10096964, 33, 1, 16776, 1, 0),
(52457, 10096965, 33, 1, 16776, 1, 0),
(52458, 10096948, 33, 1, 16776, 1, 1),
(52459, 10096974, 33, 1, 16776, 1, 1),
(52460, 10097030, 33, 1, 16776, 1, 1),
(52461, 10096951, 33, 1, 16776, 1, 0),
(52462, 10096952, 33, 1, 16776, 1, 0),
(52463, 10096953, 33, 1, 16776, 1, 0),
(52464, 10097031, 33, 1, 16776, 1, 1),
(52465, 10097032, 33, 1, 16776, 1, 1),
(52466, 10097033, 33, 1, 16776, 1, 1),
(52467, 10097034, 33, 1, 16776, 1, 1),
(52468, 10097035, 33, 1, 16776, 1, 1),
(52469, 10097036, 33, 1, 16776, 1, 1),
(52470, 10097037, 33, 1, 16776, 1, 1),
(52471, 10097038, 33, 1, 16776, 1, 1),
(52472, 10097039, 33, 1, 16776, 1, 1),
(52473, 10097040, 33, 1, 16776, 1, 1),
(52474, 10097041, 33, 1, 16776, 1, 1),
(52475, 10097042, 33, 1, 16776, 1, 1),
(52476, 10097045, 33, 1, 16776, 1, 1),
(52477, 10097046, 33, 1, 16776, 1, 1),
(52478, 10097047, 33, 1, 16776, 1, 0),
(52479, 10097048, 33, 1, 16776, 1, 0),
(52480, 10097049, 33, 1, 16776, 1, 0),
(52481, 10097050, 33, 1, 16776, 1, 0),
(52482, 10097051, 33, 1, 16776, 1, 1),
(52483, 10097054, 33, 1, 16776, 1, 0),
(52484, 10097055, 33, 1, 16776, 1, 1),
(52485, 10097056, 33, 1, 16776, 1, 1),
(52486, 10097057, 33, 1, 16776, 1, 0),
(52487, 10097068, 33, 1, 16776, 1, 0),
(52488, 10097069, 33, 1, 16776, 1, 0),
(52489, 10097070, 33, 1, 16776, 1, 0),
(52490, 10097071, 33, 1, 16776, 1, 0),
(52491, 10097072, 33, 1, 16776, 1, 0),
(52492, 10097074, 33, 1, 16776, 1, 0),
(52493, 10097073, 33, 1, 16776, 1, 0),
(52494, 10097075, 33, 1, 16776, 1, 0),
(52495, 10097076, 33, 1, 16776, 1, 0),
(52496, 10097077, 33, 1, 16776, 1, 0),
(52497, 10097086, 33, 1, 16776, 1, 1),
(52498, 10097087, 33, 1, 16776, 1, 0),
(52499, 10097088, 33, 1, 16776, 1, 1),
(52500, 10097089, 33, 1, 16776, 1, 1),
(52501, 10097090, 33, 1, 16776, 1, 1),
(52502, 10097091, 33, 1, 16776, 1, 1),
(52503, 10097092, 33, 1, 16776, 1, 0),
(52504, 10097095, 33, 1, 16776, 1, 0),
(52505, 10097097, 33, 1, 16776, 1, 1),
(52506, 10097098, 33, 1, 16776, 1, 0),
(52507, 10097082, 33, 1, 16776, 1, 1),
(52508, 10097080, 33, 1, 16776, 1, 1),
(52509, 10097081, 33, 1, 16776, 1, 0),
(52510, 10097083, 33, 1, 16776, 1, 0),
(52511, 10097084, 33, 1, 16776, 1, 0),
(52512, 10097085, 33, 1, 16776, 1, 0),
(52513, 10097078, 33, 1, 16776, 1, 1),
(52514, 10097079, 33, 1, 16776, 1, 0),
(52515, 10097096, 33, 1, 16776, 1, 1),
(52516, 10097093, 33, 1, 16776, 1, 0),
(52517, 10097094, 33, 1, 16776, 1, 0),
(52518, 10097164, 33, 1, 16777, 1, 1),
(52519, 10097152, 33, 1, 16777, 1, 1),
(52520, 10097192, 33, 1, 16777, 1, 1),
(52521, 10097169, 33, 1, 16777, 1, 1),
(52522, 10097196, 33, 1, 16777, 1, 1),
(52523, 10097189, 33, 1, 16777, 1, 1),
(52524, 10097128, 33, 1, 16777, 1, 1),
(52525, 10097144, 33, 1, 16777, 1, 1),
(52526, 10097166, 33, 1, 16777, 1, 1),
(52527, 10097135, 33, 1, 16777, 1, 1),
(52528, 10097170, 33, 1, 16777, 1, 1),
(52529, 10097198, 33, 1, 16777, 1, 1),
(52530, 10097187, 33, 1, 16777, 1, 1),
(52531, 10097132, 33, 1, 16777, 1, 1),
(52532, 10097193, 33, 1, 16777, 1, 1),
(52533, 10097119, 33, 1, 16777, 1, 1),
(52534, 10097124, 33, 1, 16777, 1, 1),
(52535, 10097155, 33, 1, 16777, 1, 1),
(52536, 10097123, 33, 1, 16777, 1, 1),
(52537, 10097111, 33, 1, 16777, 1, 1),
(52538, 10097133, 33, 1, 16777, 1, 1),
(52539, 10097131, 33, 1, 16777, 1, 1),
(52540, 10097186, 33, 1, 16777, 1, 1),
(52541, 10097188, 33, 1, 16777, 1, 1),
(52542, 10097177, 33, 1, 16777, 1, 1),
(52543, 10097191, 33, 1, 16777, 1, 1),
(52544, 10097150, 33, 1, 16777, 1, 1),
(52545, 10097134, 33, 1, 16777, 1, 1),
(52546, 10097138, 33, 1, 16777, 1, 1),
(52547, 10097172, 33, 1, 16777, 1, 1),
(52548, 10097174, 33, 1, 16777, 1, 1),
(52549, 10097165, 33, 1, 16777, 1, 1),
(52550, 10097171, 33, 1, 16777, 1, 1),
(52551, 10097136, 33, 1, 16777, 1, 1),
(52552, 10097121, 33, 1, 16777, 1, 1),
(52553, 10097153, 33, 1, 16777, 1, 1),
(52554, 10097197, 33, 1, 16777, 1, 1),
(52555, 10097168, 33, 1, 16777, 1, 1),
(52556, 10097195, 33, 1, 16777, 1, 1),
(52557, 10097176, 33, 1, 16777, 1, 1),
(52558, 10097117, 33, 1, 16777, 1, 1),
(52559, 10097118, 33, 1, 16777, 1, 1),
(52560, 10097175, 33, 1, 16777, 1, 1),
(52561, 10097127, 33, 1, 16777, 1, 1),
(52562, 10097122, 33, 1, 16777, 1, 1),
(52563, 10097173, 33, 1, 16777, 1, 1),
(52564, 10097120, 33, 1, 16777, 1, 1),
(52565, 10097190, 33, 1, 16777, 1, 1),
(52566, 10097129, 33, 1, 16777, 1, 1),
(52567, 10097130, 33, 1, 16777, 1, 1),
(52568, 10097156, 33, 1, 16777, 1, 0),
(52569, 10097167, 33, 1, 16777, 1, 0),
(52570, 10097125, 33, 1, 16777, 1, 0),
(52571, 10097185, 33, 1, 16777, 1, 0),
(52572, 10097149, 33, 1, 16777, 1, 0),
(52573, 10097162, 33, 1, 16777, 1, 0),
(52574, 10097110, 33, 1, 16777, 1, 0),
(52575, 10097105, 33, 1, 16777, 1, 0),
(52576, 10097141, 33, 1, 16777, 1, 0),
(52577, 10097146, 33, 1, 16777, 1, 0),
(52578, 10097139, 33, 1, 16777, 1, 0),
(52579, 10097100, 33, 1, 16777, 1, 0),
(52580, 10097106, 33, 1, 16777, 1, 0),
(52581, 10097183, 33, 1, 16777, 1, 0),
(52582, 10097126, 33, 1, 16777, 1, 0),
(52583, 10097145, 33, 1, 16777, 1, 0),
(52584, 10097113, 33, 1, 16777, 1, 0),
(52585, 10097178, 33, 1, 16777, 1, 0),
(52586, 10097101, 33, 1, 16777, 1, 0),
(52587, 10097147, 33, 1, 16777, 1, 0),
(52588, 10097102, 33, 1, 16777, 1, 0),
(52589, 10097194, 33, 1, 16777, 1, 0),
(52590, 10097099, 33, 1, 16777, 1, 0),
(52591, 10097161, 33, 1, 16777, 1, 0),
(52592, 10097159, 33, 1, 16777, 1, 0),
(52593, 10097140, 33, 1, 16777, 1, 0),
(52594, 10097109, 33, 1, 16777, 1, 0),
(52595, 10097108, 33, 1, 16777, 1, 0),
(52596, 10097114, 33, 1, 16777, 1, 0),
(52597, 10097158, 33, 1, 16777, 1, 0),
(52598, 10097107, 33, 1, 16777, 1, 0),
(52599, 10097103, 33, 1, 16777, 1, 0),
(52600, 10097116, 33, 1, 16777, 1, 0),
(52601, 10097151, 33, 1, 16777, 1, 0),
(52602, 10097104, 33, 1, 16777, 1, 0),
(52603, 10097115, 33, 1, 16777, 1, 0),
(52604, 10097154, 33, 1, 16777, 1, 0),
(52605, 10097143, 33, 1, 16777, 1, 0),
(52606, 10097112, 33, 1, 16777, 1, 0),
(52607, 10097182, 33, 1, 16777, 1, 0),
(52608, 10097137, 33, 1, 16777, 1, 0),
(52609, 10097142, 33, 1, 16777, 1, 0),
(52610, 10097181, 33, 1, 16777, 1, 0),
(52611, 10097163, 33, 1, 16777, 1, 0),
(52612, 10097179, 33, 1, 16777, 1, 0),
(52613, 10097180, 33, 1, 16777, 1, 0),
(52614, 10097160, 33, 1, 16777, 1, 0),
(52615, 10097157, 33, 1, 16777, 1, 0),
(52616, 10097184, 33, 1, 16777, 1, 0),
(52617, 10097148, 33, 1, 16777, 1, 0),
(52618, 10097251, 33, 1, 16778, 1, 1),
(52619, 10097123, 33, 1, 16778, 1, 1),
(52620, 10097210, 33, 1, 16778, 1, 1),
(52621, 10097312, 33, 1, 16778, 1, 1),
(52622, 10097275, 33, 1, 16778, 1, 1),
(52623, 10097248, 33, 1, 16778, 1, 1),
(52624, 10097318, 33, 1, 16778, 1, 1),
(52625, 10097311, 33, 1, 16778, 1, 1),
(52626, 10097290, 33, 1, 16778, 1, 1),
(52627, 10097329, 33, 1, 16778, 1, 1),
(52628, 10097208, 33, 1, 16778, 1, 1),
(52629, 10097273, 33, 1, 16778, 1, 1),
(52630, 10097129, 33, 1, 16778, 1, 1),
(52631, 10097322, 33, 1, 16778, 1, 1),
(52632, 10097316, 33, 1, 16778, 1, 1),
(52633, 10097272, 33, 1, 16778, 1, 1),
(52634, 10097100, 33, 1, 16778, 1, 1),
(52635, 10097314, 33, 1, 16778, 1, 1),
(52636, 10097327, 33, 1, 16778, 1, 1),
(52637, 10097276, 33, 1, 16778, 1, 1),
(52638, 10097135, 33, 1, 16778, 1, 1),
(52639, 10097152, 33, 1, 16778, 1, 1),
(52640, 10097127, 33, 1, 16778, 1, 1),
(52641, 10097203, 33, 1, 16778, 1, 1),
(52642, 10097315, 33, 1, 16778, 1, 1),
(52643, 10097244, 33, 1, 16778, 1, 1),
(52644, 10097219, 33, 1, 16778, 1, 1),
(52645, 10097187, 33, 1, 16778, 1, 1),
(52646, 10097282, 33, 1, 16778, 1, 1),
(52647, 10097220, 33, 1, 16778, 1, 1),
(52648, 10097320, 33, 1, 16778, 1, 1),
(52649, 10097308, 33, 1, 16778, 1, 1),
(52650, 10097212, 33, 1, 16778, 1, 1),
(52651, 10097188, 33, 1, 16778, 1, 1),
(52652, 10097153, 33, 1, 16778, 1, 1),
(52653, 10097286, 33, 1, 16778, 1, 1),
(52654, 10097283, 33, 1, 16778, 1, 1),
(52655, 10097213, 33, 1, 16778, 1, 1),
(52656, 10097241, 33, 1, 16778, 1, 1),
(52657, 10097310, 33, 1, 16778, 1, 1),
(52658, 10097232, 33, 1, 16778, 1, 1),
(52659, 10097323, 33, 1, 16778, 1, 1),
(52660, 10097300, 33, 1, 16778, 1, 1),
(52661, 10097211, 33, 1, 16778, 1, 1),
(52662, 10097243, 33, 1, 16778, 1, 1),
(52663, 10097332, 33, 1, 16778, 1, 1),
(52664, 10097133, 33, 1, 16778, 1, 1),
(52665, 10097234, 33, 1, 16778, 1, 1),
(52666, 10097336, 33, 1, 16778, 1, 1),
(52667, 10097151, 33, 1, 16778, 1, 1),
(52668, 10097288, 33, 1, 16778, 1, 1),
(52669, 10097099, 33, 1, 16778, 1, 1),
(52670, 10097317, 33, 1, 16778, 1, 1),
(52671, 10097287, 33, 1, 16778, 1, 1),
(52672, 10097122, 33, 1, 16778, 1, 1),
(52673, 10097227, 33, 1, 16778, 1, 1),
(52674, 10097202, 33, 1, 16778, 1, 1),
(52675, 10097321, 33, 1, 16778, 1, 1),
(52676, 10097256, 33, 1, 16778, 1, 1),
(52677, 10097324, 33, 1, 16778, 1, 1),
(52678, 10097233, 33, 1, 16778, 1, 1),
(52679, 10097206, 33, 1, 16778, 1, 1),
(52680, 10097279, 33, 1, 16778, 1, 1),
(52681, 10097216, 33, 1, 16778, 1, 1),
(52682, 10097319, 33, 1, 16778, 1, 1),
(52683, 10097104, 33, 1, 16778, 1, 1),
(52684, 10097258, 33, 1, 16778, 1, 1),
(52685, 10097240, 33, 1, 16778, 1, 1),
(52686, 10097326, 33, 1, 16778, 1, 1),
(52687, 10097309, 33, 1, 16778, 1, 1),
(52688, 10097236, 33, 1, 16778, 1, 0),
(52689, 10097222, 33, 1, 16778, 1, 0),
(52690, 10097136, 33, 1, 16778, 1, 0),
(52691, 10097231, 33, 1, 16778, 1, 0),
(52692, 10097269, 33, 1, 16778, 1, 0),
(52693, 10097125, 33, 1, 16778, 1, 0),
(52694, 10097264, 33, 1, 16778, 1, 0),
(52695, 10097215, 33, 1, 16778, 1, 0),
(52696, 10097271, 33, 1, 16778, 1, 0),
(52697, 10097303, 33, 1, 16778, 1, 0),
(52698, 10097132, 33, 1, 16778, 1, 0),
(52699, 10097159, 33, 1, 16778, 1, 0),
(52700, 10097225, 33, 1, 16778, 1, 0),
(52701, 10097335, 33, 1, 16778, 1, 0),
(52702, 10097299, 33, 1, 16778, 1, 0),
(52703, 10097301, 33, 1, 16778, 1, 0),
(52704, 10097194, 33, 1, 16778, 1, 0),
(52705, 10097156, 33, 1, 16778, 1, 0),
(52706, 10097205, 33, 1, 16778, 1, 0),
(52707, 10097158, 33, 1, 16778, 1, 0),
(52708, 10097306, 33, 1, 16778, 1, 0),
(52709, 10097249, 33, 1, 16778, 1, 0),
(52710, 10097221, 33, 1, 16778, 1, 0),
(52711, 10097302, 33, 1, 16778, 1, 0),
(52712, 10097338, 33, 1, 16778, 1, 0),
(52713, 10097281, 33, 1, 16778, 1, 0),
(52714, 10097242, 33, 1, 16778, 1, 0),
(52715, 10097304, 33, 1, 16778, 1, 0),
(52716, 10097250, 33, 1, 16778, 1, 0),
(52717, 10097224, 33, 1, 16778, 1, 0),
(52718, 10097328, 33, 1, 16778, 1, 0),
(52719, 10097252, 33, 1, 16778, 1, 0),
(52720, 10097141, 33, 1, 16778, 1, 0),
(52721, 10097292, 33, 1, 16778, 1, 0),
(52722, 10097267, 33, 1, 16778, 1, 0),
(52723, 10097148, 33, 1, 16778, 1, 0),
(52724, 10097294, 33, 1, 16778, 1, 0),
(52725, 10097209, 33, 1, 16778, 1, 0),
(52726, 10097284, 33, 1, 16778, 1, 0),
(52727, 10097330, 33, 1, 16778, 1, 0),
(52728, 10097295, 33, 1, 16778, 1, 0),
(52729, 10097117, 33, 1, 16778, 1, 0),
(52730, 10097238, 33, 1, 16778, 1, 0),
(52731, 10097325, 33, 1, 16778, 1, 0),
(52732, 10097128, 33, 1, 16778, 1, 0),
(52733, 10097298, 33, 1, 16778, 1, 0),
(52734, 10097307, 33, 1, 16778, 1, 0),
(52735, 10097246, 33, 1, 16778, 1, 0),
(52736, 10097199, 33, 1, 16778, 1, 0),
(52737, 10097235, 33, 1, 16778, 1, 0),
(52738, 10097245, 33, 1, 16778, 1, 0),
(52739, 10097337, 33, 1, 16778, 1, 0),
(52740, 10097230, 33, 1, 16778, 1, 0),
(52741, 10097204, 33, 1, 16778, 1, 0),
(52742, 10097143, 33, 1, 16778, 1, 0),
(52743, 10097297, 33, 1, 16778, 1, 0),
(52744, 10097247, 33, 1, 16778, 1, 0),
(52745, 10097237, 33, 1, 16778, 1, 0),
(52746, 10097223, 33, 1, 16778, 1, 0),
(52747, 10097313, 33, 1, 16778, 1, 0),
(52748, 10097218, 33, 1, 16778, 1, 0),
(52749, 10097226, 33, 1, 16778, 1, 0),
(52750, 10097200, 33, 1, 16778, 1, 0),
(52751, 10097291, 33, 1, 16778, 1, 0),
(52752, 10097285, 33, 1, 16778, 1, 0),
(52753, 10097305, 33, 1, 16778, 1, 0),
(52754, 10097239, 33, 1, 16778, 1, 0),
(52755, 10097228, 33, 1, 16778, 1, 0),
(52756, 10097229, 33, 1, 16778, 1, 0),
(52757, 10097217, 33, 1, 16778, 1, 0),
(52758, 10097323, 33, 1, 16779, 1, 1),
(52759, 10097397, 33, 1, 16779, 1, 1),
(52760, 10097355, 33, 1, 16779, 1, 1),
(52761, 10097346, 33, 1, 16779, 1, 1),
(52762, 10097145, 33, 1, 16779, 1, 1),
(52763, 10097239, 33, 1, 16779, 1, 1),
(52764, 10097390, 33, 1, 16779, 1, 1),
(52765, 10097345, 33, 1, 16779, 1, 1),
(52766, 10097349, 33, 1, 16779, 1, 1),
(52767, 10097350, 33, 1, 16779, 1, 1),
(52768, 10097375, 33, 1, 16779, 1, 1),
(52769, 10097256, 33, 1, 16779, 1, 1),
(52770, 10097124, 33, 1, 16779, 1, 1),
(52771, 10097129, 33, 1, 16779, 1, 1),
(52772, 10097381, 33, 1, 16779, 1, 1),
(52773, 10097200, 33, 1, 16779, 1, 1),
(52774, 10097377, 33, 1, 16779, 1, 1),
(52775, 10097321, 33, 1, 16779, 1, 1),
(52776, 10097225, 33, 1, 16779, 1, 1),
(52777, 10097228, 33, 1, 16779, 1, 1),
(52778, 10097358, 33, 1, 16779, 1, 1),
(52779, 10097392, 33, 1, 16779, 1, 1),
(52780, 10097237, 33, 1, 16779, 1, 1),
(52781, 10097121, 33, 1, 16779, 1, 1),
(52782, 10097123, 33, 1, 16779, 1, 1),
(52783, 10097122, 33, 1, 16779, 1, 1),
(52784, 10097376, 33, 1, 16779, 1, 1),
(52785, 10097380, 33, 1, 16779, 1, 1),
(52786, 10097378, 33, 1, 16779, 1, 1),
(52787, 10097391, 33, 1, 16779, 1, 1),
(52788, 10097220, 33, 1, 16779, 1, 0),
(52789, 10097340, 33, 1, 16779, 1, 0),
(52790, 10097387, 33, 1, 16779, 1, 0),
(52791, 10097360, 33, 1, 16779, 1, 0),
(52792, 10097373, 33, 1, 16779, 1, 0),
(52793, 10097393, 33, 1, 16779, 1, 0),
(52794, 10097352, 33, 1, 16779, 1, 0),
(52795, 10097395, 33, 1, 16779, 1, 0),
(52796, 10097210, 33, 1, 16779, 1, 0),
(52797, 10097354, 33, 1, 16779, 1, 0),
(52798, 10097383, 33, 1, 16779, 1, 0),
(52799, 10097341, 33, 1, 16779, 1, 0),
(52800, 10097379, 33, 1, 16779, 1, 0),
(52801, 10097353, 33, 1, 16779, 1, 0),
(52802, 10097385, 33, 1, 16779, 1, 0),
(52803, 10097176, 33, 1, 16779, 1, 0),
(52804, 10097398, 33, 1, 16779, 1, 0),
(52805, 10097271, 33, 1, 16779, 1, 0),
(52806, 10097143, 33, 1, 16779, 1, 0),
(52807, 10097396, 33, 1, 16779, 1, 0),
(52808, 10097344, 33, 1, 16779, 1, 0),
(52809, 10097127, 33, 1, 16779, 1, 0),
(52810, 10097359, 33, 1, 16779, 1, 0),
(52811, 10097343, 33, 1, 16779, 1, 0),
(52812, 10097374, 33, 1, 16779, 1, 0),
(52813, 10097369, 33, 1, 16779, 1, 0),
(52814, 10097130, 33, 1, 16779, 1, 0),
(52815, 10097382, 33, 1, 16779, 1, 0),
(52816, 10097384, 33, 1, 16779, 1, 0),
(52817, 10097173, 33, 1, 16779, 1, 0);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
`role_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `icon` varchar(64) NOT NULL,
  `level` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `name`, `description`, `icon`, `level`) VALUES
(1, 'Admin', 'Project Administrator - can do anything but delete the project', '', 2),
(2, 'User', 'Normal user - can do anything except manage settings, billing or delete the project', '', 4),
(3, 'Guest ', 'Guest user - can only view the project', '', 6),
(4, 'Owner', 'Project Owner - can do anything on the project', '', 1),
(5, 'Data Entry', 'Data Entry user - can manage project data but can not view or edit settings nor make models and classification', '', 5),
(6, 'Expert', 'Expert User - can do anything a user can do plus can invalidate species from recordings', '', 3);

-- --------------------------------------------------------

--
-- Table structure for table `role_permissions`
--

CREATE TABLE IF NOT EXISTS `role_permissions` (
  `role_id` int(10) unsigned NOT NULL,
  `permission_id` int(10) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `role_permissions`
--

INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(4, 2),
(4, 4),
(1, 5),
(4, 5),
(1, 6),
(2, 6),
(4, 6),
(5, 6),
(6, 6),
(1, 7),
(2, 7),
(4, 7),
(5, 7),
(6, 7),
(1, 8),
(2, 8),
(4, 8),
(6, 8),
(1, 9),
(2, 9),
(4, 9),
(5, 9),
(6, 9),
(1, 10),
(2, 10),
(4, 10),
(6, 10),
(1, 11),
(2, 11),
(4, 11),
(6, 11),
(1, 12),
(4, 12),
(6, 12),
(1, 13),
(2, 13),
(4, 13),
(6, 13),
(1, 14),
(2, 14),
(4, 14),
(6, 14),
(1, 15),
(2, 15),
(4, 15),
(6, 15),
(1, 16),
(2, 16),
(4, 16),
(6, 16);

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE IF NOT EXISTS `sessions` (
  `session_id` varchar(255) COLLATE utf8_bin NOT NULL,
  `expires` int(11) unsigned NOT NULL,
  `data` text COLLATE utf8_bin
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`session_id`, `expires`, `data`) VALUES
('3vVS2itb9LYz_gtzfOr5A4YL_F4ZLoFG', 1437239651, '{"cookie":{"originalMaxAge":null,"expires":null,"httpOnly":true,"path":"/"},"loggedIn":true,"user":{"id":1,"username":"rafa","email":"rafa.ccom@gmail.com","firstname":"Rafael","lastname":"Alvarez","isSuper":1,"imageUrl":"http://www.gravatar.com/avatar/3a04fab5a5087e1b55c2cc838cfbcf7e?d=monsterid&s=60","projectLimit":1,"permissions":{"33":[{"id":2,"name":"delete project"},{"id":12,"name":"invalidate species"},{"id":13,"name":"manage models and classification"},{"id":8,"name":"manage playlists"},{"id":4,"name":"manage project billing"},{"id":10,"name":"manage project jobs"},{"id":9,"name":"manage project recordings"},{"id":5,"name":"manage project settings"},{"id":6,"name":"manage project sites"},{"id":7,"name":"manage project species"},{"id":16,"name":"manage soundscapes"},{"id":15,"name":"manage training sets"},{"id":14,"name":"manage validation sets"},{"id":11,"name":"validate species"},{"id":1,"name":"view project"}]}}}');

-- --------------------------------------------------------

--
-- Table structure for table `sites`
--

CREATE TABLE IF NOT EXISTS `sites` (
`site_id` int(10) unsigned NOT NULL,
  `site_type_id` int(10) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `lat` double NOT NULL,
  `lon` double NOT NULL,
  `alt` double NOT NULL,
  `published` tinyint(1) NOT NULL DEFAULT '0',
  `token_created_on` bigint(20) DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=783 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `sites`
--

INSERT INTO `sites` (`site_id`, `site_type_id`, `project_id`, `name`, `lat`, `lon`, `alt`, `published`, `token_created_on`) VALUES
(772, 2, 33, 'simple', -10, -10, -10, 0, NULL),
(773, 2, 33, 'sp2', 1, 1, 1, 0, NULL),
(774, 2, 33, 'sp3', 100, 100, 100, 0, NULL),
(775, 2, 33, 'sp2_3', 50, 50, 50, 0, NULL),
(776, 2, 33, 'garbage', 25, 25, 25, 0, NULL),
(777, 2, 33, 'Eleutherodactylus cooki', 12.5, 12.5, 12.5, 0, NULL),
(778, 2, 33, 'Red HInt- Epinephelus guttatus', 55, 55, 55, 0, NULL),
(779, 2, 33, 'Percnostola lophotes', 75, 75, 75, 0, NULL),
(780, 2, 33, 'Hypocnemis subflava', 17, 17, 17, 0, NULL),
(781, 2, 33, 'Thamnophilus schistaceus', 70, 18, 100, 0, NULL),
(782, 2, 33, 'Myrmeciza hemimelaena', 20, 70, 70, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `site_types`
--

CREATE TABLE IF NOT EXISTS `site_types` (
`site_type_id` int(11) unsigned NOT NULL,
  `name` varchar(40) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `site_types`
--

INSERT INTO `site_types` (`site_type_id`, `name`, `description`) VALUES
(1, 'Permanent Recording Station', 'A fixed installation that generates recordings and other events, which it later sends to a base station'),
(2, 'Mobile Recorder', 'A mobile device that gets sent into the field and generates recordings and other events, but later needs to be picked up and it''s data extracted manually.');

-- --------------------------------------------------------

--
-- Table structure for table `songtypes`
--

CREATE TABLE IF NOT EXISTS `songtypes` (
`songtype_id` int(11) NOT NULL,
  `songtype` varchar(20) NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `songtypes`
--

INSERT INTO `songtypes` (`songtype_id`, `songtype`, `description`) VALUES
(1, 'Common Song', 'Most commonly used song'),
(2, 'Courtship Song', 'Song used in courtship, distinguished from the common song'),
(3, 'Territorial Song', 'A territorial song'),
(4, 'Simple Call', 'Relatively Simple Call'),
(5, 'Simple Call 2', 'Relatively Simple Call (other)'),
(6, 'Alternative Song', 'Alternate song'),
(7, 'Alternative Song 2', 'Alternate song (other)'),
(8, 'Mechanical Song', 'Song produced by mechanic (non-vocal) means'),
(9, 'Nocturnal Song', 'Song produced mostly at night');

-- --------------------------------------------------------

--
-- Table structure for table `soundscapes`
--

CREATE TABLE IF NOT EXISTS `soundscapes` (
`soundscape_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `soundscape_aggregation_type_id` int(10) unsigned NOT NULL,
  `bin_size` int(11) NOT NULL,
  `uri` text,
  `min_t` int(11) NOT NULL,
  `max_t` int(11) NOT NULL,
  `min_f` int(11) NOT NULL,
  `max_f` int(11) NOT NULL,
  `min_value` int(11) NOT NULL,
  `max_value` int(11) NOT NULL,
  `visual_max_value` int(11) DEFAULT NULL,
  `visual_palette` int(11) NOT NULL DEFAULT '1' COMMENT 'integer representing the color palette for the soundscape',
  `date_created` datetime NOT NULL,
  `playlist_id` int(10) unsigned NOT NULL,
  `frequency` int(11) DEFAULT '0',
  `threshold` float DEFAULT '0',
  `normalized` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `soundscape_aggregation_types`
--

CREATE TABLE IF NOT EXISTS `soundscape_aggregation_types` (
`soundscape_aggregation_type_id` int(11) unsigned NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `name` text NOT NULL,
  `scale` varchar(50) NOT NULL COMMENT 'json array',
  `description` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `soundscape_aggregation_types`
--

INSERT INTO `soundscape_aggregation_types` (`soundscape_aggregation_type_id`, `identifier`, `name`, `scale`, `description`) VALUES
(1, 'time_of_day', 'Hour of the day', '["00:00", "01:00", "......", "22:00", "23:00"]', 'Aggregates the data by each hour of the day'),
(2, 'day_of_month', 'Day of the month', '["1", "2", "......", "30", "31"]', 'Aggregates the data by each day of the month'),
(3, 'day_of_year', 'Day of the year', '["1", "2", "......", "365", "366"]', 'Aggregates the data by each day of the year'),
(4, 'month_in_year', 'Month of the year', '["Jan", "Feb", "......", "Nov", "Dec"]', 'Aggregates the data by each month of the year'),
(5, 'day_of_week', 'Day of the week', '["Sun", "Mon", "......", "Fri", "Sat"]', 'Aggregates the data by each day of the week'),
(6, 'year', 'Year by year', '["2010", "2011", "......", "2016", "2017"]', 'Aggregates the data by each year');

-- --------------------------------------------------------

--
-- Table structure for table `soundscape_regions`
--

CREATE TABLE IF NOT EXISTS `soundscape_regions` (
`soundscape_region_id` int(10) unsigned NOT NULL,
  `soundscape_id` int(11) unsigned NOT NULL,
  `name` varchar(256) NOT NULL,
  `x1` int(11) NOT NULL,
  `y1` int(11) NOT NULL,
  `x2` int(11) NOT NULL,
  `y2` int(11) NOT NULL,
  `count` int(11) unsigned NOT NULL,
  `sample_playlist_id` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `soundscape_region_tags`
--

CREATE TABLE IF NOT EXISTS `soundscape_region_tags` (
`soundscape_region_tag_id` int(10) unsigned NOT NULL,
  `soundscape_region_id` int(10) unsigned NOT NULL,
  `recording_id` bigint(20) unsigned NOT NULL,
  `soundscape_tag_id` int(11) unsigned NOT NULL,
  `user_id` int(11) unsigned NOT NULL,
  `timestamp` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `soundscape_tags`
--

CREATE TABLE IF NOT EXISTS `soundscape_tags` (
`soundscape_tag_id` int(10) unsigned NOT NULL,
  `tag` varchar(256) NOT NULL,
  `type` enum('normal','species_sound','','') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `species`
--

CREATE TABLE IF NOT EXISTS `species` (
`species_id` int(11) NOT NULL,
  `scientific_name` varchar(100) NOT NULL,
  `code_name` varchar(10) NOT NULL,
  `taxon_id` int(11) NOT NULL,
  `family_id` int(11) DEFAULT NULL,
  `image` varchar(200) DEFAULT NULL,
  `description` text,
  `biotab_id` int(11) DEFAULT NULL,
  `defined_by` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=16781 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `species`
--

INSERT INTO `species` (`species_id`, `scientific_name`, `code_name`, `taxon_id`, `family_id`, `image`, `description`, `biotab_id`, `defined_by`) VALUES
(16771, 'dummy', 'dummy', 1, 2, NULL, 'dummy', NULL, NULL),
(16772, 'dummy2', 'dummy2', 1, 2, NULL, NULL, NULL, NULL),
(16773, 'dummy3', 'dummy3', 1, 2, NULL, NULL, NULL, NULL),
(16774, 'garbage', 'garbage', 1, 2, NULL, NULL, NULL, NULL),
(16775, ' Eleutherodactylus cooki', ' Eleuthero', 1, 1, NULL, NULL, NULL, NULL),
(16776, 'Epinephelus guttatus', 'Epinephelu', 1, 1, NULL, NULL, NULL, NULL),
(16777, 'Percnostola lophotes', 'Percnostol', 1, 1, NULL, NULL, NULL, NULL),
(16778, 'Hypocnemis subflava', 'Hypocnemis', 1, 1, NULL, NULL, NULL, NULL),
(16779, 'Thamnophilus schistaceus', 'Thamnophil', 1, 1, NULL, NULL, NULL, NULL),
(16780, 'Myrmeciza hemimelaena', 'Myrmeciza ', 1, 1, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `species_aliases`
--

CREATE TABLE IF NOT EXISTS `species_aliases` (
`alias_id` int(11) NOT NULL,
  `species_id` int(11) NOT NULL,
  `alias` varchar(50) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=10546 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `species_aliases`
--

INSERT INTO `species_aliases` (`alias_id`, `species_id`, `alias`) VALUES
(10542, 16771, 'dummy'),
(10543, 16772, 'dummy2'),
(10544, 16773, 'dummy3'),
(10545, 16774, 'garbage');

-- --------------------------------------------------------

--
-- Table structure for table `species_families`
--

CREATE TABLE IF NOT EXISTS `species_families` (
`family_id` int(11) NOT NULL,
  `family` varchar(300) NOT NULL,
  `taxon_id` int(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=272 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `species_families`
--

INSERT INTO `species_families` (`family_id`, `family`, `taxon_id`) VALUES
(1, 'Tinamidae', 1),
(2, 'Struthionidae', 1),
(3, 'Rheidae', 1),
(4, 'Casuariidae', 1),
(5, 'Dromaiidae', 1),
(6, 'Apterygidae', 1),
(7, 'Megapodiidae', 1),
(8, 'Cracidae', 1),
(9, 'Numididae', 1),
(10, 'Odontophoridae', 1),
(11, 'Phasianidae', 1),
(12, 'Anhimidae', 1),
(13, 'Anseranatidae', 1),
(14, 'Anatidae', 1),
(15, 'Spheniscidae', 1),
(16, 'Gaviidae', 1),
(17, 'Diomedeidae', 1),
(18, 'Procellariidae', 1),
(19, 'Hydrobatidae', 1),
(20, 'Pelecanoididae', 1),
(21, 'Podicipedidae', 1),
(22, 'Phoenicopteridae', 1),
(23, 'Ciconiidae', 1),
(24, 'Threskiornithidae', 1),
(25, 'Ardeidae', 1),
(26, 'Phaethontidae', 1),
(27, 'Fregatidae', 1),
(28, 'Scopidae', 1),
(29, 'Balaenicipitidae', 1),
(30, 'Pelecanidae', 1),
(31, 'Sulidae', 1),
(32, 'Phalacrocoracidae', 1),
(33, 'Anhingidae', 1),
(34, 'Cathartidae', 1),
(35, 'Falconidae', 1),
(36, 'Accipitridae', 1),
(37, 'Otididae', 1),
(38, 'Mesitornithidae', 1),
(39, 'Cariamidae', 1),
(40, 'Rhynochetidae', 1),
(41, 'Eurypygidae', 1),
(42, 'Rallidae', 1),
(43, 'Heliornithidae', 1),
(44, 'Psophiidae', 1),
(45, 'Gruidae', 1),
(46, 'Aramidae', 1),
(47, 'Turnicidae', 1),
(48, 'Burhinidae', 1),
(49, 'Chionidae', 1),
(50, 'Haematopodidae', 1),
(51, 'Dromadidae', 1),
(52, 'Ibidorhynchidae', 1),
(53, 'Recurvirostridae', 1),
(54, 'Charadriidae', 1),
(55, 'Rostratulidae', 1),
(56, 'Jacanidae', 1),
(57, 'Pedionomidae', 1),
(58, 'Thinocoridae', 1),
(59, 'Scolopacidae', 1),
(60, 'Glareolidae', 1),
(61, 'Laridae', 1),
(62, 'Stercorariidae', 1),
(63, 'Alcidae', 1),
(64, 'Pteroclididae', 1),
(65, 'Raphidae', 1),
(66, 'Columbidae', 1),
(67, 'Psittacidae', 1),
(68, 'Opisthocomidae', 1),
(69, 'Musophagidae', 1),
(70, 'Cuculidae', 1),
(71, 'Tytonidae', 1),
(72, 'Strigidae', 1),
(73, 'Podargidae', 1),
(74, 'Steatornithidae', 1),
(75, 'Nyctibiidae', 1),
(76, 'Caprimulgidae', 1),
(77, 'Aegothelidae', 1),
(78, 'Apodidae', 1),
(79, 'Hemiprocnidae', 1),
(80, 'Trochilidae', 1),
(81, 'Coliidae', 1),
(82, 'Trogonidae', 1),
(83, 'Coraciidae', 1),
(84, 'Brachypteraciidae', 1),
(85, 'Leptosomidae', 1),
(86, 'Alcedinidae', 1),
(87, 'Todidae', 1),
(88, 'Momotidae', 1),
(89, 'Meropidae', 1),
(90, 'Upupidae', 1),
(91, 'Phoeniculidae', 1),
(92, 'Bucerotidae', 1),
(93, 'Bucorvidae', 1),
(94, 'Ramphastidae', 1),
(95, 'Indicatoridae', 1),
(96, 'Picidae', 1),
(97, 'Galbulidae', 1),
(98, 'Bucconidae', 1),
(99, 'Acanthisittidae', 1),
(100, 'Eurylaimidae', 1),
(101, 'Philepittidae', 1),
(102, 'Sapayoaidae', 1),
(103, 'Pittidae', 1),
(104, 'Pipridae', 1),
(105, 'Cotingidae', 1),
(106, 'Tyrannidae', 1),
(107, 'Thamnophilidae', 1),
(108, 'Conopophagidae', 1),
(109, 'Rhinocryptidae', 1),
(110, 'Formicariidae', 1),
(111, 'Furnariidae', 1),
(112, 'Dendrocolaptidae', 1),
(113, 'Menuridae', 1),
(114, 'Atrichornithidae', 1),
(115, 'Ptilonorhynchidae', 1),
(116, 'Climacteridae', 1),
(117, 'Maluridae', 1),
(118, 'Meliphagidae', 1),
(119, 'Dasyornithidae', 1),
(120, 'Pardalotidae', 1),
(121, 'Acanthizidae', 1),
(122, 'Pomatostomidae', 1),
(123, 'Orthonychidae', 1),
(124, 'Cnemophilidae', 1),
(125, 'Melanocharitidae', 1),
(126, 'Callaeatidae', 1),
(127, 'Eupetidae', 1),
(128, 'Cinclosomatidae', 1),
(129, 'Platysteiridae', 1),
(130, 'Malaconotidae', 1),
(131, 'Machaerirhynchidae', 1),
(132, 'Vangidae', 1),
(133, 'Cracticidae', 1),
(134, 'Artamidae', 1),
(135, 'Aegithinidae', 1),
(136, 'Pityriaseidae', 1),
(137, 'Campephagidae', 1),
(138, 'Neosittidae', 1),
(139, 'Falcunculidae', 1),
(140, 'Pachycephalidae', 1),
(141, 'Laniidae', 1),
(142, 'Vireonidae', 1),
(143, 'Oriolidae', 1),
(144, 'Colluricinclidae', 1),
(145, 'Turnagridae', 1),
(146, 'Dicruridae', 1),
(147, 'Rhipiduridae', 1),
(148, 'Monarchidae', 1),
(149, 'Corvidae', 1),
(150, 'Corcoracidae', 1),
(151, 'Paradisaeidae', 1),
(152, 'Petroicidae', 1),
(153, 'Picathartidae', 1),
(154, 'Bombycillidae', 1),
(155, 'Dulidae', 1),
(156, 'Paridae', 1),
(157, 'Remizidae', 1),
(158, 'Hirundinidae', 1),
(159, 'Aegithalidae', 1),
(160, 'Alaudidae', 1),
(161, 'Cisticolidae', 1),
(162, 'Pycnonotidae', 1),
(163, 'Sylviidae', 1),
(164, 'Timaliidae', 1),
(165, 'Zosteropidae', 1),
(166, 'Irenidae', 1),
(167, 'Reguliidae', 1),
(168, 'Troglodytidae', 1),
(169, 'Polioptilidae', 1),
(170, 'Sittidae', 1),
(171, 'Certhiidae', 1),
(172, 'Mimidae', 1),
(173, 'Rhabdornithidae', 1),
(174, 'Sturnidae', 1),
(175, 'Turdidae', 1),
(176, 'Muscicapidae', 1),
(177, 'Cinclidae', 1),
(178, 'Chloropseidae', 1),
(179, 'Dicaeidae', 1),
(180, 'Nectariniidae', 1),
(181, 'Promeropidae', 1),
(182, 'Passeridae', 1),
(183, 'Ploceidae', 1),
(184, 'Estrildidae', 1),
(185, 'Viduidae', 1),
(186, 'Prunellidae', 1),
(187, 'Peucedramidae', 1),
(188, 'Motacillidae', 1),
(189, 'Fringillidae', 1),
(190, 'Parulidae', 1),
(191, 'Icteridae', 1),
(192, 'Coerebidae', 1),
(193, 'Emberizidae', 1),
(194, 'Thraupidae', 1),
(195, 'Cardinalidae', 1),
(196, 'Eleutherodactylidae', 2),
(197, 'Leptodactylidae', 2),
(198, 'Alytidae', 2),
(199, 'Ambystomatidae', 2),
(200, 'Amphignathodontidae', 2),
(201, 'Amphiumidae', 2),
(202, 'Aromobatidae', 2),
(203, 'Arthroleptidae', 2),
(204, 'Bombinatoridae', 2),
(205, 'Brachycephalidae', 2),
(206, 'Brevicipitidae', 2),
(207, 'Bufonidae', 2),
(208, 'Caeciliidae', 2),
(209, 'Calyptocephalellidae', 2),
(210, 'Centrolenidae', 2),
(211, 'Ceratobatrachidae', 2),
(212, 'Ceratophryidae', 2),
(213, 'Craugastoridae', 2),
(214, 'Cryptobatrachidae', 2),
(215, 'Cryptobranchidae', 2),
(216, 'Cycloramphidae', 2),
(217, 'Dendrobatidae', 2),
(218, 'Dicroglossidae', 2),
(219, 'Heleophrynidae', 2),
(220, 'Hemiphractidae', 2),
(221, 'Hemisotidae', 2),
(222, 'Hylidae', 2),
(223, 'Hylodidae', 2),
(224, 'Hynobiidae', 2),
(225, 'Hyperoliidae', 2),
(226, 'Ichthyophiidae', 2),
(227, 'Leiopelmatidae', 2),
(228, 'Leiuperidae', 2),
(229, 'Limnodynastidae', 2),
(230, 'Mantellidae', 2),
(231, 'Megophryidae', 2),
(232, 'Micrixalidae', 2),
(233, 'Microhylidae', 2),
(234, 'Myobatrachidae', 2),
(235, 'Nyctibatrachidae', 2),
(236, 'Pelobatidae', 2),
(237, 'Pelodytidae', 2),
(238, 'Petropedetidae', 2),
(239, 'Phrynobatrachidae', 2),
(240, 'Pipidae', 2),
(241, 'Plethodontidae', 2),
(242, 'Proteidae', 2),
(243, 'Ptychadenidae', 2),
(244, 'Pyxicephalidae', 2),
(245, 'Ranidae', 2),
(246, 'Ranixalidae', 2),
(247, 'Rhacophoridae', 2),
(248, 'Rhinatrematidae', 2),
(249, 'Rhinophrynidae', 2),
(250, 'Rhyacotritonidae', 2),
(251, 'Salamandridae', 2),
(252, 'Scaphiopodidae', 2),
(253, 'Sirenidae', 2),
(254, 'Sooglossidae', 2),
(255, 'Strabomantidae', 2),
(256, 'Atelidae', 5),
(257, 'Cebidae', 5),
(258, 'Pitheciidae', 5),
(259, 'Dasyproctidae', 5),
(260, 'Callitrichidae', 5),
(261, 'Tayassuidae', 5),
(262, 'Desconocitae', 3),
(263, 'Caviidae', 5),
(264, 'Cuniculidae', 5),
(265, 'Procyonidae', 5),
(266, 'Canidae', 5),
(267, 'Fish', 6),
(268, 'ECHIMYIDAE', 5),
(269, 'Balaenopteridae', 5),
(270, 'Serranidae', 6),
(271, 'Serranidae', 8);

-- --------------------------------------------------------

--
-- Table structure for table `species_taxons`
--

CREATE TABLE IF NOT EXISTS `species_taxons` (
`taxon_id` int(11) NOT NULL,
  `taxon` varchar(30) NOT NULL,
  `image` varchar(30) NOT NULL,
  `taxon_order` int(11) NOT NULL,
  `enabled` tinyint(11) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `species_taxons`
--

INSERT INTO `species_taxons` (`taxon_id`, `taxon`, `image`, `taxon_order`, `enabled`) VALUES
(1, 'Birds', 'birds.png', 3, 1),
(2, 'Amphibians', 'amphibians.png', 1, 1),
(3, 'Insects', 'insects.png', 4, 1),
(4, 'Bats', 'bats.png', 2, 1),
(5, 'Mammals', 'mammals.png', 5, 1),
(6, 'Others', 'misc.png', 7, 1),
(7, 'Test_Taxon', 'test.png', 1000, 0),
(8, 'Fish', 'fish.png', 6, 1);

-- --------------------------------------------------------

--
-- Table structure for table `training_sets`
--

CREATE TABLE IF NOT EXISTS `training_sets` (
`training_set_id` bigint(20) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `date_created` date NOT NULL,
  `training_set_type_id` int(10) unsigned NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=140 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `training_sets`
--

INSERT INTO `training_sets` (`training_set_id`, `project_id`, `name`, `date_created`, `training_set_type_id`) VALUES
(129, 33, 'simple', '2015-07-08', 1),
(130, 33, 'dummy2', '2015-07-10', 1),
(131, 33, 'dummy3', '2015-07-10', 1),
(133, 33, 'garb', '2015-07-10', 1),
(134, 33, 'Eleutherodactylus cooki', '2015-07-17', 1),
(135, 33, 'Epinephelus guttatus', '2015-07-17', 1),
(136, 33, 'Percnostola lophotes', '2015-07-17', 1),
(137, 33, 'Hypocnemis subflava', '2015-07-17', 1),
(138, 33, 'Thamnophilus schistaceus', '2015-07-17', 1),
(139, 33, 'Myrmeciza hemimelaena', '2015-07-17', 1);

-- --------------------------------------------------------

--
-- Table structure for table `training_sets_roi_set`
--

CREATE TABLE IF NOT EXISTS `training_sets_roi_set` (
  `training_set_id` bigint(20) unsigned NOT NULL,
  `species_id` int(11) NOT NULL,
  `songtype_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `training_sets_roi_set`
--

INSERT INTO `training_sets_roi_set` (`training_set_id`, `species_id`, `songtype_id`) VALUES
(129, 16771, 1),
(130, 16772, 1),
(131, 16773, 1),
(133, 16774, 1),
(134, 16775, 1),
(135, 16776, 1),
(136, 16777, 1),
(137, 16778, 1),
(138, 16779, 1),
(139, 16780, 1);

-- --------------------------------------------------------

--
-- Table structure for table `training_set_roi_set_data`
--

CREATE TABLE IF NOT EXISTS `training_set_roi_set_data` (
`roi_set_data_id` bigint(20) unsigned NOT NULL,
  `training_set_id` bigint(20) unsigned NOT NULL,
  `recording_id` bigint(20) unsigned NOT NULL,
  `species_id` int(11) NOT NULL,
  `songtype_id` int(11) NOT NULL,
  `x1` double NOT NULL COMMENT 'initial time in seconds',
  `y1` double NOT NULL COMMENT 'min frequency in hertz',
  `x2` double NOT NULL COMMENT 'final time in seconds',
  `y2` double NOT NULL COMMENT 'max frequency in hertz',
  `uri` text
) ENGINE=InnoDB AUTO_INCREMENT=2307 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `training_set_roi_set_data`
--

INSERT INTO `training_set_roi_set_data` (`roi_set_data_id`, `training_set_id`, `recording_id`, `species_id`, `songtype_id`, `x1`, `y1`, `x2`, `y2`, `uri`) VALUES
(2298, 129, 10096691, 16771, 1, 4.934295067420373, 5415.78947368421, 5.309295067420373, 8478.28947368421, 'project_33/training_sets/129/2298.png'),
(2299, 129, 10096690, 16771, 1, 0.7323719904972956, 5319.078947368421, 1.174679682804988, 8542.763157894737, 'project_33/training_sets/129/2299.png'),
(2300, 130, 10096751, 16772, 1, 5.756536147173713, 545.7920792079208, 6.334967519722733, 2547.029702970297, 'project_33/training_sets/130/2300.png'),
(2301, 131, 10096809, 16773, 1, 2.2663400687423407, 909.6534653465346, 2.531045951095282, 2437.871287128713, 'project_33/training_sets/131/2301.png'),
(2302, 133, 10096872, 16774, 1, 0.47222242168351714, 2001.2376237623762, 0.9526145785462623, 4002.4752475247524, 'project_33/training_sets/133/2302.png'),
(2303, 133, 10096872, 16774, 1, 1.0506537942325367, 2001.2376237623762, 1.491830264820772, 3966.089108910891, 'project_33/training_sets/133/2303.png'),
(2304, 133, 10096872, 16774, 1, 1.6584969314874387, 2001.2376237623762, 2.099673402075674, 3966.089108910891, 'project_33/training_sets/133/2304.png'),
(2305, 133, 10096872, 16774, 1, 2.354575362859988, 2074.009900990099, 2.7859479118795956, 4148.019801980198, 'project_33/training_sets/133/2305.png'),
(2306, 134, 10096918, 16775, 1, 2.587177361441288, 1488.0368098159508, 3.4454991126574104, 1893.8650306748466, 'project_33/training_sets/134/2306.png');

-- --------------------------------------------------------

--
-- Table structure for table `training_set_types`
--

CREATE TABLE IF NOT EXISTS `training_set_types` (
`training_set_type_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `description` text NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `training_set_types`
--

INSERT INTO `training_set_types` (`training_set_type_id`, `name`, `identifier`, `description`) VALUES
(1, 'ROI set', 'roi_set', 'Regions of interest (ROI) used to create a pattern matching model');

-- --------------------------------------------------------

--
-- Table structure for table `uploads_processing`
--

CREATE TABLE IF NOT EXISTS `uploads_processing` (
`upload_id` int(10) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `site_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `upload_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `filename` varchar(100) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=678 DEFAULT CHARSET=utf8 COMMENT='recording uploaded and being process';

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
`user_id` int(11) unsigned NOT NULL,
  `login` varchar(32) NOT NULL,
  `password` varchar(64) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `lastname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `last_login` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `is_super` tinyint(1) NOT NULL DEFAULT '0',
  `project_limit` int(10) unsigned NOT NULL DEFAULT '1',
  `created_on` datetime DEFAULT NULL,
  `login_tries` tinyint(4) NOT NULL DEFAULT '0',
  `disabled_until` datetime DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `login`, `password`, `firstname`, `lastname`, `email`, `last_login`, `is_super`, `project_limit`, `created_on`, `login_tries`, `disabled_until`) VALUES
(1, 'rafa', '98ddbaf3f1ef587cf7833374f88390327259fc5c027d8f122e424d8f0109ad3a', 'Rafael', 'Alvarez', 'rafa.ccom@gmail.com', '2015-07-16 13:32:36', 1, 1, NULL, 0, NULL),
(2, 'rafa2', '98ddbaf3f1ef587cf7833374f88390327259fc5c027d8f122e424d8f0109ad3a', 'Rafael', 'Alvarez', 'rafa.ccom1@gmail.com', '2015-07-08 15:15:34', 0, 1, NULL, 0, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_account_support_request`
--

CREATE TABLE IF NOT EXISTS `user_account_support_request` (
`support_request_id` bigint(20) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `support_type_id` int(10) unsigned NOT NULL,
  `hash` varchar(64) NOT NULL,
  `params` text,
  `consumed` tinyint(1) NOT NULL DEFAULT '0',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `expires` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `user_account_support_type`
--

CREATE TABLE IF NOT EXISTS `user_account_support_type` (
`account_support_type_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `max_lifetime` int(11) DEFAULT NULL COMMENT 'maximum lifetime in seconds of this support type'
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_account_support_type`
--

INSERT INTO `user_account_support_type` (`account_support_type_id`, `name`, `description`, `max_lifetime`) VALUES
(1, 'account_activation', 'Activates a new user''s account.', 259200),
(2, 'password_recovery', 'Allows a user to change it''s forgotten passwords', 86400);

-- --------------------------------------------------------

--
-- Table structure for table `user_project_role`
--

CREATE TABLE IF NOT EXISTS `user_project_role` (
  `user_id` int(10) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_project_role`
--

INSERT INTO `user_project_role` (`user_id`, `project_id`, `role_id`) VALUES
(1, 33, 4);

-- --------------------------------------------------------

--
-- Table structure for table `validation_set`
--

CREATE TABLE IF NOT EXISTS `validation_set` (
`validation_set_id` int(10) unsigned NOT NULL,
  `project_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `uri` varchar(255) NOT NULL,
  `params` text NOT NULL,
  `job_id` bigint(20) unsigned NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=1294 DEFAULT CHARSET=utf8;

--
-- Dumping data for table `validation_set`
--

INSERT INTO `validation_set` (`validation_set_id`, `project_id`, `user_id`, `name`, `uri`, `params`, `job_id`) VALUES
(1242, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1243, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1244, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1245, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1246, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1247, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1248, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1249, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1250, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1251, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1252, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1253, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1254, 33, 1, 'simple fast 1 validation', 'project_33/validations/job_893.csv', '{"name": "simple fast 1"}', 893),
(1255, 33, 1, 'simple search match 1 validation', 'project_33/validations/job_894.csv', '{"name": "simple search match 1"}', 894),
(1256, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1257, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1258, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1259, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1260, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1261, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1262, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1263, 33, 1, 'simple matchtemplate 1 validation', 'project_33/validations/job_891.csv', '{"name": "simple matchtemplate 1"}', 891),
(1264, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1265, 33, 1, 'simple fast 1 validation', 'project_33/validations/job_893.csv', '{"name": "simple fast 1"}', 893),
(1266, 33, 1, 'simple search match 1 validation', 'project_33/validations/job_894.csv', '{"name": "simple search match 1"}', 894),
(1267, 33, 1, 'simple slow 1 validation', 'project_33/validations/job_892.csv', '{"name": "simple slow 1"}', 892),
(1268, 33, 1, 'simple fast 1 validation', 'project_33/validations/job_893.csv', '{"name": "simple fast 1"}', 893),
(1269, 33, 1, 'simple search match 1 validation', 'project_33/validations/job_894.csv', '{"name": "simple search match 1"}', 894),
(1270, 33, 1, 'sp2 matchtemplate 1 validation', 'project_33/validations/job_898.csv', '{"name": "sp2 matchtemplate 1"}', 898),
(1271, 33, 1, 'sp2 search match 1 validation', 'project_33/validations/job_897.csv', '{"name": "sp2 search match 1"}', 897),
(1272, 33, 1, 'sp2 search match 1 validation', 'project_33/validations/job_897.csv', '{"name": "sp2 search match 1"}', 897),
(1273, 33, 1, 'sp2 fast 1 validation', 'project_33/validations/job_896.csv', '{"name": "sp2 fast 1"}', 896),
(1274, 33, 1, 'sp2 slow 1 validation', 'project_33/validations/job_895.csv', '{"name": "sp2 slow 1"}', 895),
(1275, 33, 1, 'sp2 slow 1 validation', 'project_33/validations/job_895.csv', '{"name": "sp2 slow 1"}', 895),
(1276, 33, 1, 'sp2 search match 1 validation', 'project_33/validations/job_897.csv', '{"name": "sp2 search match 1"}', 897),
(1277, 33, 1, 'sp2 fast 1 validation', 'project_33/validations/job_896.csv', '{"name": "sp2 fast 1"}', 896),
(1278, 33, 1, 'sp2 matchtemplate 1 validation', 'project_33/validations/job_898.csv', '{"name": "sp2 matchtemplate 1"}', 898),
(1279, 33, 1, 'garbage matchtemplate 1 validation', 'project_33/validations/job_902.csv', '{"name": "garbage matchtemplate 1"}', 902),
(1280, 33, 1, 'garbage search match 1 validation', 'project_33/validations/job_901.csv', '{"name": "garbage search match 1"}', 901),
(1281, 33, 1, 'garbage search match 1 validation', 'project_33/validations/job_901.csv', '{"name": "garbage search match 1"}', 901),
(1282, 33, 1, 'garbage fast 1 validation', 'project_33/validations/job_900.csv', '{"name": "garbage fast 1"}', 900),
(1283, 33, 1, 'garbage slow 1 validation', 'project_33/validations/job_899.csv', '{"name": "garbage slow 1"}', 899),
(1284, 33, 1, 'garbage matchtemplate 1 validation', 'project_33/validations/job_902.csv', '{"name": "garbage matchtemplate 1"}', 902),
(1285, 33, 1, 'garbage search match 1 validation', 'project_33/validations/job_901.csv', '{"name": "garbage search match 1"}', 901),
(1286, 33, 1, 'garbage search match 1 validation', 'project_33/validations/job_901.csv', '{"name": "garbage search match 1"}', 901),
(1287, 33, 1, 'garbage fast 1 validation', 'project_33/validations/job_900.csv', '{"name": "garbage fast 1"}', 900),
(1288, 33, 1, 'garbage slow 1 validation', 'project_33/validations/job_899.csv', '{"name": "garbage slow 1"}', 899),
(1289, 33, 1, 'Eleutherodactylus cooki matchtemplate 1 validation', 'project_33/validations/job_906.csv', '{"name": "Eleutherodactylus cooki matchtemplate 1"}', 906),
(1290, 33, 1, 'Eleutherodactylus cooki search match 1 validation', 'project_33/validations/job_905.csv', '{"name": "Eleutherodactylus cooki search match 1"}', 905),
(1291, 33, 1, 'Eleutherodactylus cooki search match 1 validation', 'project_33/validations/job_905.csv', '{"name": "Eleutherodactylus cooki search match 1"}', 905),
(1292, 33, 1, 'Eleutherodactylus cooki fast 1 validation', 'project_33/validations/job_904.csv', '{"name": "Eleutherodactylus cooki fast 1"}', 904),
(1293, 33, 1, 'Eleutherodactylus cooki slow 1 validation', 'project_33/validations/job_903.csv', '{"name": "Eleutherodactylus cooki slow 1"}', 903);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `classification_results`
--
ALTER TABLE `classification_results`
 ADD KEY `job_id` (`job_id`), ADD KEY `recording_id` (`recording_id`), ADD KEY `species_id` (`species_id`), ADD KEY `songtype_id` (`songtype_id`);

--
-- Indexes for table `invalid_logins`
--
ALTER TABLE `invalid_logins`
 ADD PRIMARY KEY (`ip`,`time`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
 ADD PRIMARY KEY (`job_id`), ADD KEY `user_id` (`user_id`), ADD KEY `project_id` (`project_id`), ADD KEY `job_type_id` (`job_type_id`);

--
-- Indexes for table `job_params_classification`
--
ALTER TABLE `job_params_classification`
 ADD PRIMARY KEY (`job_id`), ADD KEY `playlist_id` (`playlist_id`), ADD KEY `model_id` (`model_id`);

--
-- Indexes for table `job_params_soundscape`
--
ALTER TABLE `job_params_soundscape`
 ADD UNIQUE KEY `job_id` (`job_id`), ADD KEY `playlist_id` (`playlist_id`), ADD KEY `soundscape_aggregation_type_id` (`soundscape_aggregation_type_id`);

--
-- Indexes for table `job_params_training`
--
ALTER TABLE `job_params_training`
 ADD PRIMARY KEY (`job_id`), ADD KEY `model_type_id` (`model_type_id`), ADD KEY `training_set_id` (`training_set_id`), ADD KEY `validation_set_id` (`validation_set_id`), ADD KEY `trained_model_id` (`trained_model_id`);

--
-- Indexes for table `job_queues`
--
ALTER TABLE `job_queues`
 ADD PRIMARY KEY (`job_queue_id`);

--
-- Indexes for table `job_queue_enqueued_jobs`
--
ALTER TABLE `job_queue_enqueued_jobs`
 ADD PRIMARY KEY (`enqueued_job_id`), ADD UNIQUE KEY `job_id` (`job_id`), ADD KEY `job_queue_id` (`job_queue_id`);

--
-- Indexes for table `job_types`
--
ALTER TABLE `job_types`
 ADD PRIMARY KEY (`job_type_id`);

--
-- Indexes for table `models`
--
ALTER TABLE `models`
 ADD PRIMARY KEY (`model_id`), ADD KEY `model_type_id` (`model_type_id`), ADD KEY `user_id` (`user_id`), ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `model_classes`
--
ALTER TABLE `model_classes`
 ADD PRIMARY KEY (`model_id`,`species_id`,`songtype_id`), ADD KEY `species_id` (`species_id`), ADD KEY `songtype_id` (`songtype_id`);

--
-- Indexes for table `model_stats`
--
ALTER TABLE `model_stats`
 ADD UNIQUE KEY `model_id` (`model_id`);

--
-- Indexes for table `model_types`
--
ALTER TABLE `model_types`
 ADD PRIMARY KEY (`model_type_id`), ADD KEY `training_set_type` (`training_set_type_id`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
 ADD PRIMARY KEY (`permission_id`), ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `playlists`
--
ALTER TABLE `playlists`
 ADD PRIMARY KEY (`playlist_id`), ADD UNIQUE KEY `project_id_2` (`project_id`,`name`), ADD KEY `project_id` (`project_id`), ADD KEY `playlist_type_id` (`playlist_type_id`);

--
-- Indexes for table `playlist_recordings`
--
ALTER TABLE `playlist_recordings`
 ADD PRIMARY KEY (`playlist_id`,`recording_id`), ADD KEY `recording_id` (`recording_id`);

--
-- Indexes for table `playlist_types`
--
ALTER TABLE `playlist_types`
 ADD PRIMARY KEY (`playlist_type_id`);

--
-- Indexes for table `projects`
--
ALTER TABLE `projects`
 ADD PRIMARY KEY (`project_id`), ADD UNIQUE KEY `name` (`name`), ADD UNIQUE KEY `url` (`url`), ADD KEY `owner_id` (`owner_id`), ADD KEY `project_type_id` (`project_type_id`);

--
-- Indexes for table `project_classes`
--
ALTER TABLE `project_classes`
 ADD PRIMARY KEY (`project_class_id`), ADD UNIQUE KEY `project_id` (`project_id`,`species_id`,`songtype_id`), ADD KEY `species_id` (`species_id`), ADD KEY `songtype_id` (`songtype_id`);

--
-- Indexes for table `project_imported_sites`
--
ALTER TABLE `project_imported_sites`
 ADD PRIMARY KEY (`site_id`,`project_id`), ADD KEY `project_id` (`project_id`);

--
-- Indexes for table `project_news`
--
ALTER TABLE `project_news`
 ADD PRIMARY KEY (`news_feed_id`), ADD KEY `user_id` (`user_id`), ADD KEY `project_id` (`project_id`), ADD KEY `news_type_id` (`news_type_id`), ADD KEY `timestamp` (`timestamp`);

--
-- Indexes for table `project_news_types`
--
ALTER TABLE `project_news_types`
 ADD PRIMARY KEY (`news_type_id`), ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `project_types`
--
ALTER TABLE `project_types`
 ADD PRIMARY KEY (`project_type_id`);

--
-- Indexes for table `recanalizer_stats`
--
ALTER TABLE `recanalizer_stats`
 ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `recordings`
--
ALTER TABLE `recordings`
 ADD PRIMARY KEY (`recording_id`), ADD UNIQUE KEY `unique_uri` (`uri`), ADD KEY `site_id` (`site_id`);

--
-- Indexes for table `recording_validations`
--
ALTER TABLE `recording_validations`
 ADD PRIMARY KEY (`recording_validation_id`), ADD UNIQUE KEY `recording_id_2` (`recording_id`,`species_id`,`songtype_id`), ADD KEY `recording_id` (`recording_id`), ADD KEY `user_id` (`user_id`), ADD KEY `species_id` (`species_id`), ADD KEY `songtype_id` (`songtype_id`), ADD KEY `project_id` (`project_id`), ADD KEY `project_id_2` (`project_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
 ADD PRIMARY KEY (`role_id`), ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `role_permissions`
--
ALTER TABLE `role_permissions`
 ADD PRIMARY KEY (`role_id`,`permission_id`), ADD KEY `permission_id` (`permission_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
 ADD PRIMARY KEY (`session_id`);

--
-- Indexes for table `sites`
--
ALTER TABLE `sites`
 ADD PRIMARY KEY (`site_id`), ADD KEY `project_id` (`project_id`), ADD KEY `site_type_id` (`site_type_id`);

--
-- Indexes for table `site_types`
--
ALTER TABLE `site_types`
 ADD PRIMARY KEY (`site_type_id`), ADD KEY `type` (`name`);

--
-- Indexes for table `songtypes`
--
ALTER TABLE `songtypes`
 ADD PRIMARY KEY (`songtype_id`), ADD UNIQUE KEY `songtype` (`songtype`);

--
-- Indexes for table `soundscapes`
--
ALTER TABLE `soundscapes`
 ADD PRIMARY KEY (`soundscape_id`), ADD KEY `	soundscape_aggregation_type_id` (`soundscape_aggregation_type_id`);

--
-- Indexes for table `soundscape_aggregation_types`
--
ALTER TABLE `soundscape_aggregation_types`
 ADD PRIMARY KEY (`soundscape_aggregation_type_id`);

--
-- Indexes for table `soundscape_regions`
--
ALTER TABLE `soundscape_regions`
 ADD PRIMARY KEY (`soundscape_region_id`), ADD UNIQUE KEY `sample_playlist_id` (`sample_playlist_id`), ADD KEY `soundscape_id` (`soundscape_id`);

--
-- Indexes for table `soundscape_region_tags`
--
ALTER TABLE `soundscape_region_tags`
 ADD PRIMARY KEY (`soundscape_region_tag_id`), ADD UNIQUE KEY `soundscape_region_id_2` (`soundscape_region_id`,`recording_id`,`soundscape_tag_id`), ADD KEY `user_id` (`user_id`), ADD KEY `soundscape_tag_id` (`soundscape_tag_id`), ADD KEY `soundscape_region_id` (`soundscape_region_id`), ADD KEY `recording_id` (`recording_id`);

--
-- Indexes for table `soundscape_tags`
--
ALTER TABLE `soundscape_tags`
 ADD PRIMARY KEY (`soundscape_tag_id`);

--
-- Indexes for table `species`
--
ALTER TABLE `species`
 ADD PRIMARY KEY (`species_id`), ADD UNIQUE KEY `scientific_name` (`scientific_name`), ADD KEY `taxon_id` (`taxon_id`), ADD KEY `code_name` (`code_name`), ADD KEY `biotab_id` (`biotab_id`), ADD KEY `family_id` (`family_id`), ADD KEY `defined_by` (`defined_by`);

--
-- Indexes for table `species_aliases`
--
ALTER TABLE `species_aliases`
 ADD PRIMARY KEY (`alias_id`), ADD KEY `species_id` (`species_id`), ADD KEY `alias` (`alias`);

--
-- Indexes for table `species_families`
--
ALTER TABLE `species_families`
 ADD PRIMARY KEY (`family_id`), ADD KEY `taxon_id` (`taxon_id`);

--
-- Indexes for table `species_taxons`
--
ALTER TABLE `species_taxons`
 ADD PRIMARY KEY (`taxon_id`);

--
-- Indexes for table `training_sets`
--
ALTER TABLE `training_sets`
 ADD PRIMARY KEY (`training_set_id`), ADD UNIQUE KEY `project_id_2` (`project_id`,`name`), ADD KEY `project_id` (`project_id`), ADD KEY `training_set_type_id` (`training_set_type_id`);

--
-- Indexes for table `training_sets_roi_set`
--
ALTER TABLE `training_sets_roi_set`
 ADD PRIMARY KEY (`training_set_id`), ADD KEY `species_id` (`species_id`), ADD KEY `songtype_id` (`songtype_id`);

--
-- Indexes for table `training_set_roi_set_data`
--
ALTER TABLE `training_set_roi_set_data`
 ADD PRIMARY KEY (`roi_set_data_id`), ADD KEY `recording_id` (`recording_id`), ADD KEY `training_set_id` (`training_set_id`), ADD KEY `species_id` (`species_id`), ADD KEY `songtype_id` (`songtype_id`);

--
-- Indexes for table `training_set_types`
--
ALTER TABLE `training_set_types`
 ADD PRIMARY KEY (`training_set_type_id`);

--
-- Indexes for table `uploads_processing`
--
ALTER TABLE `uploads_processing`
 ADD PRIMARY KEY (`upload_id`), ADD UNIQUE KEY `filename` (`filename`), ADD KEY `project_id` (`project_id`), ADD KEY `site_id` (`site_id`), ADD KEY `user_id` (`user_id`), ADD KEY `upload_time` (`upload_time`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`user_id`), ADD UNIQUE KEY `email` (`email`), ADD UNIQUE KEY `login` (`login`);

--
-- Indexes for table `user_account_support_request`
--
ALTER TABLE `user_account_support_request`
 ADD PRIMARY KEY (`support_request_id`), ADD KEY `user_id` (`user_id`), ADD KEY `support_type_id` (`support_type_id`), ADD KEY `hash` (`hash`);

--
-- Indexes for table `user_account_support_type`
--
ALTER TABLE `user_account_support_type`
 ADD PRIMARY KEY (`account_support_type_id`);

--
-- Indexes for table `user_project_role`
--
ALTER TABLE `user_project_role`
 ADD PRIMARY KEY (`user_id`,`project_id`), ADD KEY `project_id` (`project_id`), ADD KEY `role_id` (`role_id`);

--
-- Indexes for table `validation_set`
--
ALTER TABLE `validation_set`
 ADD PRIMARY KEY (`validation_set_id`), ADD KEY `job_id` (`job_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
MODIFY `job_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=907;
--
-- AUTO_INCREMENT for table `job_queues`
--
ALTER TABLE `job_queues`
MODIFY `job_queue_id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `job_queue_enqueued_jobs`
--
ALTER TABLE `job_queue_enqueued_jobs`
MODIFY `enqueued_job_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `job_types`
--
ALTER TABLE `job_types`
MODIFY `job_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `models`
--
ALTER TABLE `models`
MODIFY `model_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=522;
--
-- AUTO_INCREMENT for table `model_types`
--
ALTER TABLE `model_types`
MODIFY `model_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
MODIFY `permission_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=17;
--
-- AUTO_INCREMENT for table `playlists`
--
ALTER TABLE `playlists`
MODIFY `playlist_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=432;
--
-- AUTO_INCREMENT for table `playlist_types`
--
ALTER TABLE `playlist_types`
MODIFY `playlist_type_id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `projects`
--
ALTER TABLE `projects`
MODIFY `project_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=34;
--
-- AUTO_INCREMENT for table `project_classes`
--
ALTER TABLE `project_classes`
MODIFY `project_class_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=85;
--
-- AUTO_INCREMENT for table `project_news`
--
ALTER TABLE `project_news`
MODIFY `news_feed_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=604;
--
-- AUTO_INCREMENT for table `project_news_types`
--
ALTER TABLE `project_news_types`
MODIFY `news_type_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=12;
--
-- AUTO_INCREMENT for table `project_types`
--
ALTER TABLE `project_types`
MODIFY `project_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `recanalizer_stats`
--
ALTER TABLE `recanalizer_stats`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4297;
--
-- AUTO_INCREMENT for table `recordings`
--
ALTER TABLE `recordings`
MODIFY `recording_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10097579;
--
-- AUTO_INCREMENT for table `recording_validations`
--
ALTER TABLE `recording_validations`
MODIFY `recording_validation_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=52819;
--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
MODIFY `role_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `sites`
--
ALTER TABLE `sites`
MODIFY `site_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=783;
--
-- AUTO_INCREMENT for table `site_types`
--
ALTER TABLE `site_types`
MODIFY `site_type_id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `songtypes`
--
ALTER TABLE `songtypes`
MODIFY `songtype_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `soundscapes`
--
ALTER TABLE `soundscapes`
MODIFY `soundscape_id` int(10) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `soundscape_aggregation_types`
--
ALTER TABLE `soundscape_aggregation_types`
MODIFY `soundscape_aggregation_type_id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=7;
--
-- AUTO_INCREMENT for table `soundscape_regions`
--
ALTER TABLE `soundscape_regions`
MODIFY `soundscape_region_id` int(10) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `soundscape_region_tags`
--
ALTER TABLE `soundscape_region_tags`
MODIFY `soundscape_region_tag_id` int(10) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `soundscape_tags`
--
ALTER TABLE `soundscape_tags`
MODIFY `soundscape_tag_id` int(10) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `species`
--
ALTER TABLE `species`
MODIFY `species_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16781;
--
-- AUTO_INCREMENT for table `species_aliases`
--
ALTER TABLE `species_aliases`
MODIFY `alias_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10546;
--
-- AUTO_INCREMENT for table `species_families`
--
ALTER TABLE `species_families`
MODIFY `family_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=272;
--
-- AUTO_INCREMENT for table `species_taxons`
--
ALTER TABLE `species_taxons`
MODIFY `taxon_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `training_sets`
--
ALTER TABLE `training_sets`
MODIFY `training_set_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=140;
--
-- AUTO_INCREMENT for table `training_set_roi_set_data`
--
ALTER TABLE `training_set_roi_set_data`
MODIFY `roi_set_data_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2307;
--
-- AUTO_INCREMENT for table `training_set_types`
--
ALTER TABLE `training_set_types`
MODIFY `training_set_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `uploads_processing`
--
ALTER TABLE `uploads_processing`
MODIFY `upload_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=678;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
MODIFY `user_id` int(11) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `user_account_support_request`
--
ALTER TABLE `user_account_support_request`
MODIFY `support_request_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT for table `user_account_support_type`
--
ALTER TABLE `user_account_support_type`
MODIFY `account_support_type_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `validation_set`
--
ALTER TABLE `validation_set`
MODIFY `validation_set_id` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=1294;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `jobs`
--
ALTER TABLE `jobs`
ADD CONSTRAINT `jobs_ibfk_1` FOREIGN KEY (`job_type_id`) REFERENCES `job_types` (`job_type_id`),
ADD CONSTRAINT `jobs_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE,
ADD CONSTRAINT `jobs_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `job_params_classification`
--
ALTER TABLE `job_params_classification`
ADD CONSTRAINT `job_params_classification_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `models` (`model_id`),
ADD CONSTRAINT `job_params_classification_ibfk_2` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`playlist_id`) ON DELETE SET NULL,
ADD CONSTRAINT `job_params_classification_ibfk_3` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`) ON DELETE CASCADE;

--
-- Constraints for table `job_params_soundscape`
--
ALTER TABLE `job_params_soundscape`
ADD CONSTRAINT `job_params_soundscape_ibfk_1` FOREIGN KEY (`soundscape_aggregation_type_id`) REFERENCES `soundscape_aggregation_types` (`soundscape_aggregation_type_id`),
ADD CONSTRAINT `job_params_soundscape_ibfk_2` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`) ON DELETE CASCADE,
ADD CONSTRAINT `job_params_soundscape_ibfk_3` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`playlist_id`) ON DELETE NO ACTION;

--
-- Constraints for table `job_params_training`
--
ALTER TABLE `job_params_training`
ADD CONSTRAINT `job_params_training_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`),
ADD CONSTRAINT `job_params_training_ibfk_2` FOREIGN KEY (`model_type_id`) REFERENCES `model_types` (`model_type_id`),
ADD CONSTRAINT `job_params_training_ibfk_3` FOREIGN KEY (`training_set_id`) REFERENCES `training_sets` (`training_set_id`),
ADD CONSTRAINT `job_params_training_ibfk_4` FOREIGN KEY (`validation_set_id`) REFERENCES `validation_set` (`validation_set_id`),
ADD CONSTRAINT `job_params_training_ibfk_5` FOREIGN KEY (`trained_model_id`) REFERENCES `models` (`model_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `job_queue_enqueued_jobs`
--
ALTER TABLE `job_queue_enqueued_jobs`
ADD CONSTRAINT `job_queue_enqueued_jobs_ibfk_1` FOREIGN KEY (`job_queue_id`) REFERENCES `job_queues` (`job_queue_id`) ON DELETE CASCADE,
ADD CONSTRAINT `job_queue_enqueued_jobs_ibfk_2` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`) ON DELETE CASCADE;

--
-- Constraints for table `models`
--
ALTER TABLE `models`
ADD CONSTRAINT `models_ibfk_1` FOREIGN KEY (`model_type_id`) REFERENCES `model_types` (`model_type_id`),
ADD CONSTRAINT `models_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
ADD CONSTRAINT `models_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`);

--
-- Constraints for table `model_classes`
--
ALTER TABLE `model_classes`
ADD CONSTRAINT `model_classes_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`),
ADD CONSTRAINT `model_classes_ibfk_2` FOREIGN KEY (`songtype_id`) REFERENCES `songtypes` (`songtype_id`),
ADD CONSTRAINT `model_classes_ibfk_3` FOREIGN KEY (`model_id`) REFERENCES `models` (`model_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `model_stats`
--
ALTER TABLE `model_stats`
ADD CONSTRAINT `model_stats_ibfk_1` FOREIGN KEY (`model_id`) REFERENCES `models` (`model_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `model_types`
--
ALTER TABLE `model_types`
ADD CONSTRAINT `model_types_ibfk_1` FOREIGN KEY (`training_set_type_id`) REFERENCES `training_set_types` (`training_set_type_id`);

--
-- Constraints for table `playlist_recordings`
--
ALTER TABLE `playlist_recordings`
ADD CONSTRAINT `playlist_recordings_ibfk_1` FOREIGN KEY (`playlist_id`) REFERENCES `playlists` (`playlist_id`) ON DELETE CASCADE,
ADD CONSTRAINT `playlist_recordings_ibfk_2` FOREIGN KEY (`recording_id`) REFERENCES `recordings` (`recording_id`) ON DELETE CASCADE;

--
-- Constraints for table `projects`
--
ALTER TABLE `projects`
ADD CONSTRAINT `projects_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `users` (`user_id`),
ADD CONSTRAINT `projects_ibfk_2` FOREIGN KEY (`project_type_id`) REFERENCES `project_types` (`project_type_id`);

--
-- Constraints for table `project_classes`
--
ALTER TABLE `project_classes`
ADD CONSTRAINT `project_classes_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`) ON DELETE CASCADE,
ADD CONSTRAINT `project_classes_ibfk_2` FOREIGN KEY (`songtype_id`) REFERENCES `songtypes` (`songtype_id`) ON DELETE CASCADE,
ADD CONSTRAINT `project_classes_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE;

--
-- Constraints for table `project_imported_sites`
--
ALTER TABLE `project_imported_sites`
ADD CONSTRAINT `project_imported_sites_ibfk_1` FOREIGN KEY (`site_id`) REFERENCES `sites` (`site_id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `project_imported_sites_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `project_news`
--
ALTER TABLE `project_news`
ADD CONSTRAINT `project_news_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
ADD CONSTRAINT `project_news_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE,
ADD CONSTRAINT `project_news_ibfk_3` FOREIGN KEY (`news_type_id`) REFERENCES `project_news_types` (`news_type_id`);

--
-- Constraints for table `recordings`
--
ALTER TABLE `recordings`
ADD CONSTRAINT `recordings_ibfk_1` FOREIGN KEY (`site_id`) REFERENCES `sites` (`site_id`);

--
-- Constraints for table `recording_validations`
--
ALTER TABLE `recording_validations`
ADD CONSTRAINT `recording_validations_ibfk_2` FOREIGN KEY (`recording_id`) REFERENCES `recordings` (`recording_id`),
ADD CONSTRAINT `recording_validations_ibfk_5` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
ADD CONSTRAINT `recording_validations_ibfk_6` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`),
ADD CONSTRAINT `recording_validations_ibfk_7` FOREIGN KEY (`songtype_id`) REFERENCES `songtypes` (`songtype_id`),
ADD CONSTRAINT `recording_validations_ibfk_8` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`);

--
-- Constraints for table `role_permissions`
--
ALTER TABLE `role_permissions`
ADD CONSTRAINT `role_permissions_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`) ON DELETE CASCADE,
ADD CONSTRAINT `role_permissions_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`permission_id`) ON DELETE CASCADE;

--
-- Constraints for table `sites`
--
ALTER TABLE `sites`
ADD CONSTRAINT `sites_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE,
ADD CONSTRAINT `sites_ibfk_2` FOREIGN KEY (`site_type_id`) REFERENCES `site_types` (`site_type_id`);

--
-- Constraints for table `soundscapes`
--
ALTER TABLE `soundscapes`
ADD CONSTRAINT `soundscapes_ibfk_1` FOREIGN KEY (`soundscape_aggregation_type_id`) REFERENCES `soundscape_aggregation_types` (`soundscape_aggregation_type_id`);

--
-- Constraints for table `soundscape_regions`
--
ALTER TABLE `soundscape_regions`
ADD CONSTRAINT `soundscape_regions_ibfk_1` FOREIGN KEY (`soundscape_id`) REFERENCES `soundscapes` (`soundscape_id`) ON DELETE CASCADE,
ADD CONSTRAINT `soundscape_regions_ibfk_2` FOREIGN KEY (`sample_playlist_id`) REFERENCES `playlists` (`playlist_id`) ON DELETE SET NULL;

--
-- Constraints for table `soundscape_region_tags`
--
ALTER TABLE `soundscape_region_tags`
ADD CONSTRAINT `soundscape_region_tags_ibfk_1` FOREIGN KEY (`soundscape_region_id`) REFERENCES `soundscape_regions` (`soundscape_region_id`) ON DELETE CASCADE,
ADD CONSTRAINT `soundscape_region_tags_ibfk_2` FOREIGN KEY (`recording_id`) REFERENCES `recordings` (`recording_id`) ON DELETE CASCADE,
ADD CONSTRAINT `soundscape_region_tags_ibfk_3` FOREIGN KEY (`soundscape_tag_id`) REFERENCES `soundscape_tags` (`soundscape_tag_id`),
ADD CONSTRAINT `soundscape_region_tags_ibfk_4` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `species`
--
ALTER TABLE `species`
ADD CONSTRAINT `species_ibfk_1` FOREIGN KEY (`taxon_id`) REFERENCES `species_taxons` (`taxon_id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `species_ibfk_2` FOREIGN KEY (`family_id`) REFERENCES `species_families` (`family_id`) ON DELETE CASCADE,
ADD CONSTRAINT `species_ibfk_3` FOREIGN KEY (`defined_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `species_aliases`
--
ALTER TABLE `species_aliases`
ADD CONSTRAINT `species_aliases_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `species_families`
--
ALTER TABLE `species_families`
ADD CONSTRAINT `species_families_ibfk_1` FOREIGN KEY (`taxon_id`) REFERENCES `species_taxons` (`taxon_id`) ON DELETE CASCADE;

--
-- Constraints for table `training_sets`
--
ALTER TABLE `training_sets`
ADD CONSTRAINT `training_sets_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE,
ADD CONSTRAINT `training_sets_ibfk_2` FOREIGN KEY (`training_set_type_id`) REFERENCES `training_set_types` (`training_set_type_id`);

--
-- Constraints for table `training_sets_roi_set`
--
ALTER TABLE `training_sets_roi_set`
ADD CONSTRAINT `training_sets_roi_set_ibfk_1` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`),
ADD CONSTRAINT `training_sets_roi_set_ibfk_2` FOREIGN KEY (`songtype_id`) REFERENCES `songtypes` (`songtype_id`),
ADD CONSTRAINT `training_sets_roi_set_ibfk_3` FOREIGN KEY (`training_set_id`) REFERENCES `training_sets` (`training_set_id`) ON DELETE CASCADE;

--
-- Constraints for table `training_set_roi_set_data`
--
ALTER TABLE `training_set_roi_set_data`
ADD CONSTRAINT `training_set_roi_set_data_ibfk_1` FOREIGN KEY (`training_set_id`) REFERENCES `training_sets` (`training_set_id`) ON DELETE CASCADE,
ADD CONSTRAINT `training_set_roi_set_data_ibfk_2` FOREIGN KEY (`recording_id`) REFERENCES `recordings` (`recording_id`),
ADD CONSTRAINT `training_set_roi_set_data_ibfk_3` FOREIGN KEY (`species_id`) REFERENCES `species` (`species_id`),
ADD CONSTRAINT `training_set_roi_set_data_ibfk_4` FOREIGN KEY (`songtype_id`) REFERENCES `songtypes` (`songtype_id`);

--
-- Constraints for table `uploads_processing`
--
ALTER TABLE `uploads_processing`
ADD CONSTRAINT `uploads_processing_ibfk_1` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE ON UPDATE CASCADE,
ADD CONSTRAINT `uploads_processing_ibfk_2` FOREIGN KEY (`site_id`) REFERENCES `sites` (`site_id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `user_account_support_request`
--
ALTER TABLE `user_account_support_request`
ADD CONSTRAINT `user_account_support_request_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
ADD CONSTRAINT `user_account_support_request_ibfk_2` FOREIGN KEY (`support_type_id`) REFERENCES `user_account_support_type` (`account_support_type_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_project_role`
--
ALTER TABLE `user_project_role`
ADD CONSTRAINT `user_project_role_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
ADD CONSTRAINT `user_project_role_ibfk_2` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE,
ADD CONSTRAINT `user_project_role_ibfk_3` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`);

--
-- Constraints for table `validation_set`
--
ALTER TABLE `validation_set`
ADD CONSTRAINT `validation_set_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE TABLE IF NOT EXISTS `k_fold_Validations` (
  `job_id` bigint(20) unsigned NOT NULL,
  `totaln` int(11) NOT NULL,
  `pos_n` int(11) NOT NULL,
  `neg_n` int(11) NOT NULL,
  `k_folds` int(11) NOT NULL,
  `accuracy` float NOT NULL,
  `precision` float NOT NULL,
  `sensitivity` float NOT NULL,
  `specificity` float NOT NULL,
  KEY `job_id` (`job_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `k_fold_Validations`
--
ALTER TABLE `k_fold_Validations`
  ADD CONSTRAINT `k_fold_Validations_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`job_id`) ON DELETE NO ACTION ON UPDATE NO ACTION;

commit;