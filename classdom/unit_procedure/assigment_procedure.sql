-- 과제 등록
DELIMITER //
CREATE PROCEDURE 과제등록(in 제목 varchar(255), in 내용 varchar(3000),
in 강좌ID bigint, in 시작일 datetime, in 마감일 datetime)
BEGIN
    insert into assignment(title, content, course_id, start_time, end_time)
    values (제목, 내용, 강좌ID, 시작일, 마감일);
END
// DELIMITER ;

-- 과제 전체 조회
DELIMITER //
CREATE PROCEDURE 과제전체조회()
BEGIN
        select * from assignment;
END
// DELIMITER ;

-- 과제 단일 조회
DELIMITER //
CREATE PROCEDURE 과제조회(in 과제ID bigint)
BEGIN
        select * from assignment where id=과제ID;
END
// DELIMITER ;

-- 과제 제출물 등록
DELIMITER //
CREATE PROCEDURE 과제제출(in 내용 varchar(3000), in 과제ID bigint, in 학생ID bigint)
BEGIN
    insert into assignment_output(content, assignment_id, student_id)
    values (내용, 과제ID, 학생ID);
END
// DELIMITER ;

-- 과제 제출물 점수 등록
DELIMITER //
CREATE PROCEDURE 과제점수등록(in 학생ID bigint, in 과제ID bigint,
in 점수 tinyint, in 피드백 varchar(300))
BEGIN
    update assignment_output set score = 점수, feedback = 피드백
    where student_id = 학생ID and assignment_id = 과제ID;
END
// DELIMITER ;


-- 과제 제출물 점수 조회
DELIMITER //
CREATE PROCEDURE 과제제출물조회(in 과제제출물ID bigint)
BEGIN
        select a.title, ao.content, ao.submit_date, ao.score, ao.feedback from assignment_output ao
        inner join assignment a on ao.assignment_id = a.id
        where ao.id=과제제출물ID AND ao.del_yn ='N';
END
// DELIMITER ;

