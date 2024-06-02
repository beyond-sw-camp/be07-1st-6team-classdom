--회원이 특정 강좌의 리뷰를 조회한다.
DELIMITER //
CREATEN PROCEDURE `get_course_review_single`(
    IN course_name VARCHAR(255)
)
BEGIN
    SELECT
        c.name AS 강좌명,
        u.email AS 작성자_email,
        r.content AS 후기내용,
        r.star AS 별점,
        r.created_date AS 등록일자
    FROM
        review r
    JOIN
        course c ON r.course_id = c.id
    JOIN
        user u ON r.student_id = u.id
    WHERE
        c.name = course_name;
END
// DELIMITER ;

--회원이 강좌 리뷰를 등록한다.
DELIMITER //
CREATE PROCEDURE `submit_course_review`(
    IN student_id BIGINT,
    IN course_id BIGINT,
    IN review_content TEXT,
    IN review_star INT
)
BEGIN
    INSERT INTO review (course_id, student_id, content, star, created_date)
    VALUES (course_id, student_id, review_content, review_star, CURRENT_TIMESTAMP());
END
// DELIMITER ;