# 👑Class Dom👑
<p align="center"><img src="https://github.com/hjin111/be07-1st-6team-classdom/blob/main/classdom.jpg" width="1000" height="300"/></p>

<hr>

### 🤗 팀명 : 꿈은 거창하게
 
### 🤭 팀원

<p align="center">
	<img src="https://github.com/hjin111/be07-1st-6team-classdom/blob/main/min.jpg" width="200" height="200"/>
	<img src="https://github.com/hjin111/be07-1st-6team-classdom/blob/main/seung.jpg" width="200" height="200"/>
	<img src="https://github.com/hjin111/be07-1st-6team-classdom/blob/main/su.jpg" width="200" height="200"/>
	<img src="https://github.com/hjin111/be07-1st-6team-classdom/blob/main/hye.jpg" width="200" height="200"/>
</p>

<div align="center">
	
|   &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;  &nbsp;  &nbsp; 🐶 김민성  &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;  &nbsp;  &nbsp;    |      &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;  &nbsp;  &nbsp; 🐱신승현  &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;  &nbsp;  &nbsp;    |      &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;  &nbsp;  &nbsp; 🐹김수연  &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;  &nbsp;  &nbsp;    |     &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;  &nbsp;  &nbsp; 🐰이혜진B  &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;  &nbsp;  &nbsp;   | 
|------------------------------------------|--------------------------------------|------------------------------------------|-----------------------------------|
 
</div>

<hr>

### 👨‍🏫 프로젝트 개요
  
  ClassDom 시스템은 프리랜서 교육 강사들이 효율적이고 효과적으로 교육 활동을 수행할 수 있도록 지원하기 위해 기획된 서비스입니다.
  
  서비스를 통해 강사들은 수강생 관리 업무에 소모되는 에너지를 줄이고, 고품질 강의 콘텐츠 제작에 집중할 수 있습니다.
  
  ClassDom 서비스는 프리랜서 교육 강사들이 수강생 관리에 드는 불필요한 에너지를 절감하고, 교육의 질을 높이며, 교육 기회를 확대하는 것을 목표로 합니다.

<hr>

### 👩‍🏫 서비스 목표

  1.수강 생성 및 관리: 강사들이 쉽게 수강을 생성하고 체계적으로 관리할 수 있도록 지원.
  
  2.교육 자료 관리: 강의 노트, 슬라이드, 동영상 등 다양한 교육 자료를 효율적으로 저장하고 공유.
  
  3.수강생 출결 관리: 수강생의 출석 및 결석을 간편하게 관리.
  
  4.수강생 피드백 수집: 강의 후 수강생의 피드백을 체계적으로 수집하여 분석.
  
  5.교육 기회 확대: 강사들이 더 많은 교육 기회를 가질 수 있도록 지원.
  
  6.교육 품질 향상: 체계적인 관리와 피드백을 통해 지속적으로 교육 품질을 개선.

<hr>

### 🔨 기술 스택
<div>
<img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
<img src="https://img.shields.io/badge/git-F05032?style=for-the-badge&logo=git&logoColor=white">
<img src="https://img.shields.io/badge/github-181717?style=for-the-badge&logo=github&logoColor=white">
<img src="https://img.shields.io/badge/mariaDB-003545?style=for-the-badge&logo=mariaDB&logoColor=white">
</div>

<hr>

### 📝 WBS

<hr>

[WBS 바로가기](https://docs.google.com/spreadsheets/d/1eHBIEEkxueLymtcP5HVBi0v87ioZNQ4pFrXA9FRIbj0/edit#gid=0)
<img src="https://github.com/beyond-sw-camp/be07-1st-6team-classdom/blob/main/classdom/image/classdom%20project%20wbs.jpg">




### ✅ 요구사항 명세서

<hr>

### 💻 DB 테이블 - ERD 및 DDL

<p align="center"><img src="https://github.com/beyond-sw-camp/be07-1st-6team-classdom/blob/main/classdom/DB/classdom%20project%20ERD.png"/></p>

<details>
<summary><b>CLASSDOM DDL</b></summary>
	
```sql

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

```
</details>


<hr>

### 🧪 단위 테스트

<hr>

### 🌏 통합 테스트

<hr>
