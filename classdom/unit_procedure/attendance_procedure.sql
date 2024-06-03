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