--강의 등록
DELIMITER //
CREATE PROCEDURE lecture_upload(in nameInput varchar(255), in contentInput varchar(255), in course_idInput bigint, in timeInput time )
BEGIN
    insert into lecture(name, content, course_id, running_time) values (nameInput, contentInput, course_idInput, timeInput);
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