-- 회원 가입
DELIMITER //
CREATE PROCEDURE user_join(in emailInput varchar(255), in pwInput varchar(255), in nameInput varchar(255), in PhoneInput varchar(255), in roleInput enum('학생', '강사', '관리자') )
BEGIN
    insert into user(email, password, name, phone_number, role ) values (emailInput, pwInput, nameInput, PhoneInput, roleInput);
END
// DELIMITER ;

-- 회원 조회
DELIMITER //
CREATE PROCEDURE user_search(in email varchar(255))
BEGIN
        select * from user where email = email;
END
// DELIMITER ;

-- 회원 정보 수정
DELIMITER //
CREATE PROCEDURE user_modify(in userEmail varchar(255), in userPw varchar(255), in userName varchar(255), in userPhone varchar(255))
BEGIN
        declare userId bigint;
        select id into userId from user where email = userEmail and password = userPw;
    if userId is null then
                select '아이디/비밀번호가 틀렸습니다.';
        else 
                update user set name = userName, phone_number = userPhone where id=userId;
        select '변경이 완료되었습니다.', email, password, name, phone_number from user where id = userId;
        end if;
END
// DELIMITER ;

-- 회원 탈퇴
DELIMITER //
CREATE PROCEDURE user_withdraw(in delete_email varchar(255))
BEGIN
        update user set del_yn = 'Y' where email = delete_email;
END
// DELIMITER ;

--강좌 등록
DELIMITER //
CREATE PROCEDURE course_upload(in nameInput varchar(255), 
in descriptionInput varchar(8000), 
in priceInput decimal(10,2), 
in categoryInput varchar(255), 
in start_dateInput datetime, 
in end_dateInput datetime, 
in instructor_idInput bigint, 
in maxInput int )

BEGIN
    insert into course(name, description, price, category, start_date, end_date, instructor_id, max_student) values (nameInput, descriptionInput, priceInput, categoryInput, start_dateInput, end_dateInput, instructor_idInput, maxInput);
END
// DELIMITER ;

--강좌 승인
DELIMITER //
CREATE PROCEDURE course_approval(in course_idInput bigint)
BEGIN
    update course set approval = 'Y' where id = course_idInput;
END
// DELIMITER ;

-- 승인된 전체 강좌 조회 프로시저 ( 강좌명, 강사명, 가격, 전체인원 조회 )
DELIMITER //
CREATE PROCEDURE course_all_search()
BEGIN
    select c.name as'강좌명', u.name as'강사명', c.price as'가격', c.max_student as'전체인원' 
    from course c left join user u on c.instructor_id = u.id 
    where c.approval = 'Y';
END
// DELIMITER ;

-- 승인된 단일 강좌 조회 ( 강좌명 입력 )
DELIMITER //
CREATE PROCEDURE course_one_search(in 강좌명 varchar(255))
BEGIN
    select c.name as '강좌명', u.name as '강사명', c.price as '가격', c.max_student as '전체인원' 
    from course c left join user u on c.instructor_id = u.id 
    where c.approval = 'Y' and c.name = 강좌명;
END
// DELIMITER ;

-- 수강 강좌 전체 조회 프로시저
DELIMITER //
CREATE PROCEDURE register_all_search(in 학생id bigint(20))
BEGIN
    select c.name as 수강강좌명
    from course_register r inner join course c on r.course_id = c.id
    where r.student_id = 학생id; 
END
// DELIMITER ;

-- 수강 강좌 단일 조회 프로시저
DELIMITER //
CREATE PROCEDURE register_one_search(in 학생id bigint(20), in 강좌id bigint(20))
BEGIN
    select c.name as 수강강좌명
    from course_register r inner join course c on r.course_id = c.id
    where r.student_id = 학생id and r.course_id = 강좌id; 
END
// DELIMITER ;

-- 수강 강좌 취소 프로시저
DELIMITER //
CREATE PROCEDURE register_delete(in 학생id bigint(20), in 강좌명 varchar(255))
BEGIN
    declare courseId bigint(20);
    select id into courseId from course where name = 강좌명;
    update course_register set del_yn = 'Y' where student_id = 학생id and course_id = courseId;
END
// DELIMITER ;

-- 질문 올리기 프로시저 
DELIMITER //
CREATE PROCEDURE question_upload(in 제목 varchar(255), in 내용 varchar(3000), in 강좌Id bigint, in 작성자id bigint(20))
BEGIN
    insert into course_question(title, content, course_id, writer) values (제목, 내용, 강좌Id, 작성자id);
END
// DELIMITER ;

-- 답변 달기 프로시저
DELIMITER //
CREATE PROCEDURE response_upload(in 답변 varchar(3000), in 질문Id bigint, in 작성자Id bigint)
BEGIN
    insert into course_response(content, c_question_id, writer) values (답변 , 질문Id, 작성자Id);
END
// DELIMITER ;

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


-- 사용자 카드 등록 프로시저
DELIMITER //
CREATE PROCEDURE user_card(in 학생이름 varchar(255), in 카드사 varchar(45), in 카드번호 char(16))
BEGIN
    declare userId bigint;
    select id into userId from user where name  = 학생이름;
    insert into payment_method (student_id, card_category, card_number) values (userId, 카드사, 카드번호);
END
// DELIMITER ;

-- 사용자 수강 강좌 결제 프로시저
DELIMITER //
CREATE PROCEDURE user_payment(in 학생이름 varchar(255), in 강좌명 varchar(255), in 카드등록Id bigint)
BEGIN
    declare registerId bigint;
    declare paymentId bigint;
    select r.id into registerId from course c inner join course_register r on c.id = r.course_id where c.name = 강좌명;
    select p.id into paymentId from payment_method p inner join user u on p.student_id = u.id where u.name = 학생이름 and p.id = 카드등록Id;
    insert into payment(register_id, payment_id) value (registerId, paymentId);
END
// DELIMITER ;

-- 수강 강좌 결제 트랜잭션 프로시저 ( 꼭 수강등록 한 후 사용!! )
-- 회원이 수강할 강좌를 결제할 때 결제한 카드와 카드 번호를 등록을 함과 동시에 (payment_method에 insert)
-- 어떤 회원이 수강 등록한 강좌를 어떻게 결제를 했는지에 대한 결제 내역도 업로드 한다.(payment에 insert)
DELIMITER //
CREATE PROCEDURE user_card_payment(
    IN 학생이름 VARCHAR(255),
    IN 강좌명 VARCHAR(255),
    IN 카드사 VARCHAR(45),
    IN 카드번호 CHAR(16)
)
BEGIN
    DECLARE userId bigint(20);
    DECLARE registerId bigint(20);
    DECLARE paymentId bigint(20);
    
    -- 트랜잭션 시작
    START TRANSACTION;

    -- 사용자 ID 가져오기
    SELECT id INTO userId FROM user WHERE name = 학생이름;
    
    -- 카드 등록
    INSERT INTO payment_method (student_id, card_category, card_number) VALUES (userId, 카드사, 카드번호);
    
    -- 마지막으로 삽입된 카드 등록 ID 가져오기
    SET paymentId = LAST_INSERT_ID();
    
    -- 강좌 등록 ID 가져오기
    SELECT r.id INTO registerId FROM course c 
    INNER JOIN course_register r ON c.id = r.course_id 
    inner join  user u on r.student_id = u.id
    WHERE c.name = 강좌명 and u.name = 학생이름;
    
    -- 결제 정보 삽입
    INSERT INTO payment (register_id, payment_id) VALUES (registerId, paymentId);
    
    -- 트랜잭션 커밋
    COMMIT;
    
END
// DELIMITER ;

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
        AND c.course_name = course_name
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
DELIMITER //
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

DELIMITER //
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

DELIMITER //
CREATE PROCEDURE `get_course_review_single`(
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

-- FA 등록
DELIMITER //
CREATE PROCEDURE FA_upload(in title varchar(255), in content text)
BEGIN
        insert into fa(title, content) values(title, content);
END
// DELIMITER ;

-- FA 검색
DELIMITER //
CREATE PROCEDURE FA_search(in keyword varchar(255))
BEGIN
        select * from fa where title like '%'||keyword||'%';
END
// DELIMITER ;


--강의 프로시저
DELIMITER //
CREATE PROCEDURE lecture_upload(in instructorEmail varchar(255), in courseId bigint, in name varchar(255), in content varchar(255), in running_time Time)
BEGIN
        declare courseId bigint;        -- course_id
    declare instructorId bigint;        -- instructor_id
        select id into instructorId from user where email = instructorEmail;

    select id into courseId from course where id = courseIdInput and instructor_id = instructorId;
    
    if courseId is null then
                select '해당 강좌가 존재하지 않습니다.';
        else
                insert into lecture (name, content, course_id, running_time) values (name, content, courseId, running_time);
                select '강의 생성 완료';
    end if;
END
// DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lecture_delete`(in instructorEmail varchar(255), in courseId bigint, in lectureId bigint)
BEGIN
declare instructorId bigint;
    declare deleteCourseId bigint;
    declare deleteLectureName varchar(255);
    declare deleteLectureId bigint;
    select id into instructorId from user where email = instructorEmail;
    select id into deleteCourseId from course where id = courseId and instructor_id = instructorId;
    if deleteCourseId is null then
        select '해당 강좌가 존재하지 않습니다.';
else
        select id, name into deleteLectureId, deleteLectureName from lecture where id = lectureId;
if deleteLectureId is null then
select '해당 강의가 존재하지 않습니다.';
else
update lecture set del_yn = 'Y' where id = deleteLectureId;
select concat(deleteLectureName, '강의 삭제') ;

        end if;
end if;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lecture_one_search`(in courseId bigint, in lectureId bigint)
BEGIN
select name as '강의명', content as '동영상', running_time as '강의 시간', created_date as '강의 생성일' from lecture where course_id = courseId and del_yn = 'N' and id = lectureId;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lecture_total_search`(in courseId bigint)
BEGIN
select name as '강의명', content as '동영상', running_time as '강의 시간', created_date as '강의 생성일' from lecture where course_id = courseId and del_yn = 'N';
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `lecture_watch`(in studentEmail varchar(255), in lectureId bigint)
BEGIN
declare studentId bigint;
    declare registerId bigint default null;
    declare attendanceId bigint default null;-- 강의 시청 이력
    
    -- 학생의 id
    select id into studentId from user where email = studentEmail;
 
    -- 강좌를 수강하고 있는지. 하고 있으면 registerId에 course_register의 pk인 id가 들어감. 아니면 null
    select cr.id into registerId from course_register cr inner join lecture l on l.course_id = cr.course_id where cr.student_id = studentId and l.id = lectureId and l.del_yn = 'N';

    if registerId is null then
select '해당 강좌를 수강하고 있지 않습니다.';
else 
select id into attendanceId from attendance where student_id = studentId and lecture_id = lectureId;
if attendanceId is null then
select '강의 시청하기';
            insert into attendance (student_id, lecture_id) values (studentId, lectureId);
        else
select '강의 재시청';
        end if;



end if;
   
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `attendance_total_search`(in studentEmail varchar(255))
BEGIN
declare studentId bigint;
    select id into studentId from user where email = studentEmail;
    
    select c.name as '강의명', count(a.id) as '시청한 강의 수', count(*) as '전체 강의 수'
from course_register cr  right outer join lecture l on cr.course_id = l.course_id 
inner join course c on c.id = cr.course_id 
left outer join attendance a on l.id = a.lecture_id  and a.student_id = studentId
where l.del_yn = 'N' and cr.student_id = studentId
group by cr.course_id;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `attendance_one_saerch`(in studentEmail varchar(255), in courseId bigint)
BEGIN
declare studentId bigint;
    select id into studentId from user where email=studentEmail;
    
select l.name as'강의명', l.running_time as '강의 시간', ifnull(view_date, '미시청') as '시청날짜'
from lecture l
left outer join attendance a on l.id = a.lecture_id and a.student_id = studentId
where l.del_yn = 'N' and l.course_id = courseId;
END$$
DELIMITER ;