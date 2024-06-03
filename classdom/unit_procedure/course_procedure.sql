--강좌 등록
DELIMITER //
CREATE PROCEDURE course_upload(in nameInput varchar(255), in descriptionInput varchar(8000), in priceInput decimal(10,2), in categoryInput varchar(255), in start_dateInput datetime, in end_dateInput datetime, in instructor_idInput bigint, in maxInput int )
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

call course_approval();

DELIMITER //
create procedure 수강신청 (in 학생id bigint(20),in 강좌id bigint(20))
BEGIN
    insert into course_register (student_id,course_id) values (학생id,강좌id);

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

call course_all_search();

-- 승인된 단일 강좌 조회 ( 강좌명 입력 )
DELIMITER //
CREATE PROCEDURE course_one_search(in 강좌명 varchar(255))
BEGIN
    select c.name as '강좌명', u.name as '강사명', c.price as '가격', c.max_student as '전체인원' 
    from course c left join user u on c.instructor_id = u.id 
    where c.approval = 'Y' and c.name = 강좌명;
END
// DELIMITER ;

call course_one_search();

-- 수강 강좌 전체 조회 프로시저
DELIMITER //
CREATE PROCEDURE register_all_search(in 학생id bigint(20))
BEGIN
    select c.name as 수강강좌명
    from course_register r inner join course c on r.course_id = c.id
    where r.student_id = 학생id; 
END
// DELIMITER ;

call register_all_search();

-- 수강 강좌 단일 조회 프로시저
DELIMITER //
CREATE PROCEDURE register_one_search(in 학생id bigint(20), in 강좌id bigint(20))
BEGIN
    select c.name as 수강강좌명
    from course_register r inner join course c on r.course_id = c.id
    where r.student_id = 학생id and r.course_id = 강좌id; 
END
// DELIMITER ;

call register_one_search();

-- 수강 강좌 취소 프로시저
DELIMITER //
CREATE PROCEDURE register_delete(in 학생id bigint(20), in 강좌명 varchar(255))
BEGIN
    declare courseId bigint(20);
    select id into courseId from course where name = 강좌명;
    update course_register set del_yn = 'Y' where student_id = 학생id and course_id = courseId;
END
// DELIMITER ;

call register_delete();
