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