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

