-- 강사가 시험을 등록한다.
DELIMITER //
CREATE PROCEDURE `course_exam_register`(in 강좌ID bigint(20),in 제목 varchar(255),in 내용 varchar(3000),in 시험날짜 datetime,in 제한시간 datetime)
BEGIN
    insert into exam (course_id, title, content, exam_date,limited_time) values (강좌ID,제목,내용,시험날짜,제한시간);
END
// DELIMITER ;


-- 회원이 시험을 조회한다. 단일 조회
DELIMITER //
CREATE PROCEDURE `get_student_exam`(IN student_id BIGINT, IN course_name VARCHAR(255))
BEGIN
    SELECT
        e.title AS 시험_제목,
        e.content AS 시험_내용,
        e.exam_date AS 시험_날짜,
        e.limited_time AS 시험_마감_날짜
    FROM
        exam e
    INNER JOIN
        course c ON e.course_id = c.id
    INNER JOIN
        course_register cr ON c.id = cr.course_id
    WHERE
        cr.student_id = student_id
        AND c.course_name = course_name -- course_name이 문제인듯
        AND cr.del_yn = 'N'
        AND e.del_yn = 'N';
END
// DELIMITER ;


--회원이 시험을 조회한다. 전체 조회
DELIMITER //
CREATE PROCEDURE `get_user_exam_total`(IN student_id BIGINT)
BEGIN
    SELECT
        e.id AS exam_id,
        e.course_id as 강좌명 ,
        e.title as 제목 ,
        e.content as 내용 ,
        e.exam_date as 시험날,
        e.limited_time as 마감날
    FROM
        exam e
    JOIN
        course_register cr ON e.course_id = cr.course_id
    WHERE
        cr.student_id = student_id
        AND cr.del_yn = 'N'
        AND e.del_yn = 'N';
END
// DELIMITER ;

--회원이 시험 결과를 조회한다.
// DELIMITER
CREATE PROCEDURE `grade_exam`(
    IN exam_output_id BIGINT,
    IN exam_score INT
)
BEGIN
    UPDATE exam_output
    SET score = exam_score
    WHERE id = exam_output_id;
END
DELIMITER // ;

--회원이 시험 내용을 등록한다
// DELIMITER
CREATE PROCEDURE `submit_exam_answer`(
    IN student_id BIGINT,
    IN exam_id BIGINT,
    IN exam_answer VARCHAR(3000)
)
BEGIN
    INSERT INTO exam_output (exam_id, student_id, content, created_date)
    VALUES (exam_id, student_id, exam_answer, CURRENT_TIMESTAMP());
END
// DELIMITER ;



