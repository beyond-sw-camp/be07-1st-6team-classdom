-- 사용자 카드 등록 프로시저
DELIMITER //
CREATE PROCEDURE user_card(in 학생이름 varchar(255), in 카드사 varchar(45), in 카드번호 char(16))
BEGIN
    declare userId bigint;
    select id into userId from user where name  = 학생이름;
    insert into payment_method (student_id, card_category, card_number) values (userId, 카드사, 카드번호);
END
// DELIMITER ;

call user_card();

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

call user_payment();

-- 수강 강좌 결제 트랜잭션 프로시저 ( 꼭 수강등록 한 후 사용!! )
-- 회원이 수강할 강좌를 결제할 때 결제한 카드와 카드 번호를 등록을 함과 동시에 (payment_method에 insert)
-- 어떤 회원이 수강 등록한 강좌를 어떻게 결제를 했는지에 대한 결제 내역도 업로드 한다.(payment에 insert)
DELIMITER //

CREATE PROCEDURE user_card_payment(
    IN 학생이름 VARCHAR(255),
    IN 강좌명 VARCHAR(255),
    IN 카드사 VARCHAR(45),
    IN 카드번호 CHAR(16),
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
//
DELIMITER ;

-- 프로시저 호출 예시
CALL user_card_payment();

