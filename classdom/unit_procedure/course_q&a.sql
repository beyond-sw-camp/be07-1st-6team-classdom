-- 질문 올리기 프로시저 
DELIMITER //
CREATE PROCEDURE question_upload(in 제목 varchar(255), in 내용 varchar(3000), in 강좌Id bigint, in 작성자id bigint(20))
BEGIN
    insert into course_question(title, content, course_id, writer) values (제목, 내용, 강좌Id, 작성자id);
END
// DELIMITER ;

call course_question();

-- 답변 달기 프로시저
DELIMITER //
CREATE PROCEDURE response_upload(in 답변 varchar(3000), in 질문Id bigint, in 작성자Id bigint)
BEGIN
    insert into course_response(content, c_question_id, writer) values (답변 , 질문Id, 작성자Id);
END
// DELIMITER ;

call response_upload('그게 머지요?',1,1)

-- 게시글 전체 조회(게시글 목록)
DELIMITER //
CREATE PROCEDURE question_select()
BEGIN
    select q.title as'제목', c.name as'질문 관련 강좌 제목', u.name as'작성자', DATE_FORMAT(q.created_time, '%Y년 %m월 %d일') AS '작성일'
    from course_question q 
    left join user u on q.writer = u.id
    left join course c on q.course_id = c.id;
END
// DELIMITER ;

call question_select();

-- 게시글 단일 조회 (해당 게시글 눌렀을 때)
DELIMITER //
CREATE PROCEDURE question_one_select(in 게시글ID bigint(20))
BEGIN
    select q.title as'제목', q.content as'내용', c.name as'질문 관련 강좌 제목', u.name as'작성자', DATE_FORMAT(q.created_time, '%Y년 %m월 %d일') AS '작성일'
    from course_question q 
    left join user u on q.writer = u.id
    left join course c on q.course_id = c.id
    where q.id = 게시글ID;
END
// DELIMITER ;

call question_one_select();

-- 답변 조회 프로시저
DELIMITER //
CREATE PROCEDURE response_select()
BEGIN
    select q.content as'질문내용', r.content as'답변', u.name as'답변 작성자', DATE_FORMAT(r.created_time, '%Y년 %m월 %d일') AS '답변일'
    from course_response r 
    left join course_question q on r.c_question_id = q.id
    left join user u on r.writer = u.id;
    
END
// DELIMITER ;

call response_select();