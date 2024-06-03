CREATE TABLE `user` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  `role` enum('학생','강사','관리자') NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `course` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` varchar(8000) NOT NULL,
  `price` int(11) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `instructor_id` bigint(20) unsigned NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  `max_student` int(11) DEFAULT 30,
  `approval` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `user_id_fk` (`instructor_id`),
  CONSTRAINT `user_id_fk` FOREIGN KEY (`instructor_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `lecture` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content` varchar(255) DEFAULT NULL,
  `course_id` bigint(20) unsigned NOT NULL,
  `running_time` time NOT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `course_id_fk` (`course_id`),
  CONSTRAINT `course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `exam` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` varchar(3000) DEFAULT NULL,
  `exam_date` datetime NOT NULL,
  `limited_time` datetime DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `exam_course_id_fk` (`course_id`),
  CONSTRAINT `exam_course_id_fk` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `exam_output` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `exam_id` bigint(20) unsigned NOT NULL,
  `student_id` bigint(20) unsigned NOT NULL,
  `content` varchar(3000) NOT NULL,
  `score` int(11) DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `exam_output_exam_id_idx` (`exam_id`),
  KEY `exam_output_student_id_idx` (`student_id`),
  CONSTRAINT `exam_output_exam_id` FOREIGN KEY (`exam_id`) REFERENCES `exam` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `exam_output_student_id` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `payment_method` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned NOT NULL,
  `card_category` varchar(45) DEFAULT NULL,
  `card_number` char(16) DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `payment_method_student_id_idx` (`student_id`),
  CONSTRAINT `payment_method_student_id` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `course_register` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned DEFAULT NULL,
  `course_id` bigint(20) unsigned DEFAULT NULL,
  `completed_state` char(1) DEFAULT 'N',
  `created_time` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `course_register_course_id_idx` (`course_id`),
  KEY `course_register_student_id_idx` (`student_id`),
  CONSTRAINT `course_register_course_id` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `course_register_student_id` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `payment` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `register_id` bigint(20) unsigned DEFAULT NULL,
  `payment_id` bigint(20) unsigned DEFAULT NULL,
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `register_id_idx` (`register_id`),
  KEY `payment_id_idx` (`payment_id`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`register_id`) REFERENCES `course_register` (`id`),
  CONSTRAINT `payment_ibfk_2` FOREIGN KEY (`payment_id`) REFERENCES `payment_method` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `review` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `course_id` bigint(20) unsigned DEFAULT NULL,
  `student_id` bigint(20) unsigned DEFAULT NULL,
  `content` text DEFAULT NULL,
  `star` int(11) DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `course_id_idx` (`course_id`),
  KEY `student_id_idx` (`student_id`),
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `attendance` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `student_id` bigint(20) unsigned DEFAULT NULL,
  `lecture_id` bigint(20) unsigned DEFAULT NULL,
  `state` char(1) DEFAULT 'N',
  `view_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `student_id_idx` (`student_id`),
  KEY `lecture_id_idx` (`lecture_id`),
  CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`),
  CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`lecture_id`) REFERENCES `lecture` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `fa` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `created_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) DEFAULT 'N',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `course_question` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` varchar(3000) DEFAULT NULL,
  `course_id` bigint(20) unsigned NOT NULL,
  `created_time` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) NOT NULL DEFAULT 'N',
  `writer` bigint(20) unsigned,
  PRIMARY KEY (`id`),
  KEY `course_cquestion_fk` (`course_id`),
  KEY `question_writer_fk` (`writer`),
  CONSTRAINT `course_cquestion_fk` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`),
  CONSTRAINT `question_writer_fk` FOREIGN KEY (`writer`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `course_response` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `content` varchar(3000) DEFAULT NULL,
  `c_question_id` bigint(20) unsigned NOT NULL,
  `created_time` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) NOT NULL DEFAULT 'N',
  `writer` bigint unsigned, 
  PRIMARY KEY (`id`),

  KEY `cquesiton_cresponse_fk` (`c_question_id`),
  KEY `question_response_fk` (`writer`),

  CONSTRAINT `cquesiton_cresponse_fk` FOREIGN KEY (`c_question_id`) REFERENCES `course_question` (`id`),
  CONSTRAINT `question_response_fk` FOREIGN KEY (`writer`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `assignment` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `content` varchar(3000) DEFAULT NULL,
  `course_id` bigint(20) unsigned NOT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `created_time` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `course_assignment_fk` (`course_id`),
  CONSTRAINT `course_assignment_fk` FOREIGN KEY (`course_id`) REFERENCES `course` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `assignment_output` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `content` varchar(3000) DEFAULT NULL,
  `assignment_id` bigint(20) unsigned NOT NULL,
  `student_id` bigint(20) unsigned NOT NULL,
  `score` tinyint(4) DEFAULT 0,
  `feedback` varchar(300) DEFAULT '피드백 등록 전입니다.',
  `submit_date` datetime DEFAULT current_timestamp(),
  `del_yn` char(1) NOT NULL DEFAULT 'N',
  PRIMARY KEY (`id`),
  KEY `assignment_aoutput_fk` (`assignment_id`),
  KEY `cquestion_aoutput_fk` (`student_id`),
  CONSTRAINT `assignment_aoutput_fk` FOREIGN KEY (`assignment_id`) REFERENCES `assignment` (`id`),
  CONSTRAINT `assignment_student_fk` FOREIGN KEY (`student_id`) REFERENCES `user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
