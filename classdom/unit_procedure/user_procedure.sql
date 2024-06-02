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