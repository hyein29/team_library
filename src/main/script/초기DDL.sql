drop database library;

create database library;

use library;

-- ȸ�� ���̺�
CREATE TABLE `member` (
  `user_id` varchar(20) NOT NULL, -- ���̵�
  `user_pw` varchar(1024) NOT NULL, -- ��й�ȣ
  `user_name` varchar(50) NOT NULL, -- �̸�
  `user_birth` date DEFAULT NULL, -- �������
  `user_tel` varchar(30) NOT NULL, -- ��ȭ��ȣ
  `user_email` varchar(40) NOT NULL, -- �̸���
  `user_zip` varchar(10) NOT NULL, -- �����ȣ
  `user_address` varchar(255) NOT NULL, -- �ּ�
  `user_address_detail` varchar(255) NOT NULL, -- ���ּ�
  `user_able_loan` int(11) NOT NULL DEFAULT '10', -- ���� ���� ���� ��
  `user_book_count` int(11) NOT NULL DEFAULT '0', -- ���� �� ���� ��
  `user_overdue_date` int(11) DEFAULT '0', -- ���� �Ұ� �� ��
  `enabled` varchar(1) DEFAULT '1', -- ����
  `user_reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- ȸ�� ���� ��
  PRIMARY KEY (`user_id`)
) 

-- ȸ�� ���� ���̺�
CREATE TABLE `member_auth` (
  `user_id` varchar(20) NOT NULL, -- ���̵�
  `auth` varchar(100) NOT NULL, -- ����
  KEY `fk_member_auth_user_id` (`user_id`),
  CONSTRAINT `fk_member_auth_userid` FOREIGN KEY (`user_id`) REFERENCES `member` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
)

-- Ż�� ȸ�� ���̺�
CREATE TABLE `secession_member` (
  `user_id` varchar(20) NOT NULL,
  `user_email` varchar(40) NOT NULL,
  PRIMARY KEY (`user_id`)
)

-- ���� ���� ���̺� 
CREATE TABLE `loan_history` (
  `loan_no` int(11) NOT NULL AUTO_INCREMENT, -- ���� ���� ��ȣ
  `user_id` varchar(20) NOT NULL, -- ���� ȸ�� ���̵�
  `user_email` varchar(40) not NULL, -- ���� ȸ�� �̸���
  `book_title` varchar(100) NOT NULL, -- ���� ���� ����
  `book_author` varchar(200) NOT NULL, -- ���� ���� ����
  `book_isbn` varchar(20) NOT NULL, -- ���� ���� ISBN
  `book_cover` varchar(2000) DEFAULT NULL, -- ���� ���� ǥ�� �ּ�
  `book_pubdate` varchar(20) NOT NULL, -- ���� ���� �Ⱓ��
  `book_publisher` varchar(50) NOT NULL, -- ���� ���� ���ǻ�
  `loan_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- ���� ����
  `return_date` timestamp NULL DEFAULT NULL, -- �ݳ� ����
  `return_period` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00', -- ���� �ݳ� ����
  `return_status` tinyint(1) NOT NULL DEFAULT '0', -- ���� �ݳ� ����
  PRIMARY KEY (`loan_no`),
  KEY `loan_history_FK` (`user_id`),
  CONSTRAINT `loan_history_FK` FOREIGN KEY (`user_id`) REFERENCES `member` (`user_id`)
)

-- ��� ���� ���̺�
CREATE TABLE `hope` (
  `hope_no` int(11) NOT NULL AUTO_INCREMENT, -- ��� ���� ��ȣ
  `user_id` varchar(20) NOT NULL, -- ��û ȸ�� ���̵�
  `book_title` varchar(100) NOT NULL, -- ��� ���� ����
  `book_author` varchar(200) NOT NULL, -- ��� ���� ����
  `book_publisher` varchar(50) NOT NULL, -- ��� ���� ���ǻ�
  `book_pubdate` varchar(20) NOT NULL, -- ��� ���� �Ⱓ��
  `book_isbn` varchar(20) DEFAULT NULL, -- ��� ���� ISBN
  `note` varchar(100) DEFAULT NULL, -- ���
  `book_price` varchar(20) DEFAULT NULL, -- ��� ���� ����
  `hope_status` int(11) DEFAULT '0', -- ��� ���� ó�� ����
  `cancel_reason` varchar(100) DEFAULT NULL, -- ��� ���� ��� ����
  `hope_reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- ��� ���� ��û��
  PRIMARY KEY (`hope_no`),
  KEY `hope_FK` (`user_id`),
  CONSTRAINT `hope_FK` FOREIGN KEY (`user_id`) REFERENCES `member` (`user_id`)
)

-- ��õ ���� ���̺�
CREATE TABLE `recommend_book` (
  `rec_no` int(11) NOT NULL AUTO_INCREMENT, -- ��õ ���� ��ȣ
  `user_id` varchar(20) NOT NULL, -- ��õ�� ���̵�
  `book_title` varchar(100) NOT NULL, -- ��õ ���� ����
  `book_author` varchar(200) NOT NULL, -- ��õ ���� ����
  `book_isbn` varchar(20) NOT NULL, -- ��õ ���� ISBN
  `book_cover` varchar(2000) NOT NULL, -- ��õ ���� ǥ��
  `book_pubdate` varchar(20) NOT NULL, -- ��õ ���� �Ⱓ��
  `book_publisher` varchar(50) NOT NULL, -- ��õ ���� ���ǻ�
  `recommend_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- ��õ ���� �����
  PRIMARY KEY (`rec_no`),
  KEY `recommend_book_FK` (`user_id`),
  CONSTRAINT `recommend_book_FK` FOREIGN KEY (`user_id`) REFERENCES `member` (`user_id`)
)

-- ������ ���̺�
CREATE TABLE `reading_room` (
  `seat_no` int(11) NOT NULL, -- �¼� ��ȣ
  `user_id` varchar(20) DEFAULT NULL, -- ������ ���̵�
  `checkin_time` timestamp NULL DEFAULT NULL, -- �¼� �Խ� �ð�
  `checkout_time` timestamp NULL DEFAULT NULL, -- �¼� ��� �ð�
  PRIMARY KEY (`seat_no`),
  UNIQUE KEY `user_id` (`user_id`)
)

-- ������ ���� ���̺�
CREATE TABLE `calendar` (
  `cal_no` int(11) NOT NULL AUTO_INCREMENT, -- ���� ��ȣ
  `groupId` int(11) NOT NULL, -- �׷� ���̵�
  `user_id` varchar(20) NOT NULL, -- ���� �ۼ��� ���̵�
  `title` varchar(1024) NOT NULL, -- ���� ����
  `start` date NOT NULL, -- ���� ���� �ð�
  `end` date NOT NULL, -- ���� ���� �ð�
  `allDay` int(11) NOT NULL, -- �Ϸ���������
  `textColor` varchar(50) NOT NULL, -- ���� ����
  `backgroundColor` varchar(50) NOT NULL, -- ��� ����
  `borderColor` varchar(50) NOT NULL, -- �ܰ��� ����
  `reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- ���� ��� ����
  PRIMARY KEY (`cal_no`),
  KEY `calendar_FK` (`user_id`),
  CONSTRAINT `calendar_FK` FOREIGN KEY (`user_id`) REFERENCES `member` (`user_id`)
)

-- �������� ���̺�
CREATE TABLE `notice` (
  `notice_no` int(11) NOT NULL AUTO_INCREMENT, -- �������� ��ȣ
  `notice_title` varchar(50) NOT NULL, -- �������� ����
  `notice_content` varchar(8196) NOT NULL, -- �������� ����
  `writer_id` varchar(20) NOT NULL, -- �������� �ۼ��� ���̵�
  `writer_name` varchar(50) NOT NULL, -- �������� �ۼ��� �̸�
  `notice_reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- �������� �ۼ���
  `notice_views` int(11) NOT NULL DEFAULT '0', -- �������� ��ȸ��
  `notice_img` mediumblob, -- �������� ÷������ ��� 
  PRIMARY KEY (`notice_no`),
  KEY `notice_FK` (`writer_id`),
  CONSTRAINT `notice_FK` FOREIGN KEY (`writer_id`) REFERENCES `member` (`user_id`)
)

-- �������� ÷������ ���̺�
CREATE TABLE `notice_attach_file` (
  `uuid` varchar(500) NOT NULL, -- uuid
  `upload_path` varchar(200) NOT NULL, -- ���ε� ���
  `file_name` varchar(100) NOT NULL, -- ���ϸ�
  `file_type` char(1) DEFAULT '1', -- ���� Ÿ��
  `notice_no` int(11) NOT NULL, -- �������� ��ȣ
  PRIMARY KEY (`uuid`),
  KEY `notice_no` (`notice_no`),
  CONSTRAINT `notice_attach_file_ibfk_1` FOREIGN KEY (`notice_no`) REFERENCES `notice` (`notice_no`) ON DELETE CASCADE ON UPDATE CASCADE
)

-- �нǹ� ���̺�
CREATE TABLE `article` (
  `article_no` int(11) NOT NULL AUTO_INCREMENT, -- �нǹ� ã�� �Խñ� ��ȣ
  `article_title` varchar(50) NOT NULL, -- �нǹ�ã�� ����
  `article_content` varchar(8196) NOT NULL, -- �нǹ� ã�� ����
  `writer_id` varchar(20) NOT NULL, -- �ۼ��� ���̵�
  `writer_name` varchar(50) NOT NULL, -- �ۼ��� �̸�
  `article_reg_date` datetime DEFAULT CURRENT_TIMESTAMP, -- �Խñ� �����
  `article_views` int(11) NOT NULL DEFAULT '0', -- �Խñ� ��ȸ��
  PRIMARY KEY (`article_no`),
  KEY `article_FK` (`writer_id`),
  CONSTRAINT `article_FK` FOREIGN KEY (`writer_id`) REFERENCES `member` (`user_id`)
)

-- �нǹ� ÷������ ���̺�
CREATE TABLE `attach_file` (
  `uuid` varchar(500) NOT NULL, -- uuid
  `upload_path` varchar(200) NOT NULL, -- ���ε� ���
  `file_name` varchar(100) NOT NULL, -- ���ϸ�
  `file_type` char(1) DEFAULT '1', -- ���� Ÿ��
  `article_no` int(11) NOT NULL, -- �нǹ� ã�� �Խñ� ��ȣ
  PRIMARY KEY (`uuid`),
  KEY `article_no` (`article_no`),
  CONSTRAINT `attach_file_ibfk_1` FOREIGN KEY (`article_no`) REFERENCES `article` (`article_no`) ON DELETE CASCADE ON UPDATE CASCADE
)

-- ���ǻ��� ���̺�
CREATE TABLE `enquiry` (
  `enquiry_no` int(11) NOT NULL AUTO_INCREMENT, -- ���ǻ��� �Խñ� ��ȣ
  `enquiry_title` varchar(1024) NOT NULL, -- ���ǻ��� ����
  `enquiry_content` varchar(8196) NOT NULL, -- ���ǻ��� ����
  `writer_id` varchar(20) NOT NULL, -- ���ǻ��� �ۼ��� ���̵�
  `writer_name` varchar(50) NOT NULL, -- ���ǻ��� �ۼ��� �̸�
  `enquiry_hits` int(11) NOT NULL DEFAULT '0', -- ���ǻ��� ��ȸ��
  `enquiry_reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- ���ǻ��� �����
  PRIMARY KEY (`enquiry_no`),
  KEY `enquiry_FK` (`writer_id`),
  CONSTRAINT `enquiry_FK` FOREIGN KEY (`writer_id`) REFERENCES `member` (`user_id`)
)

-- �亯 ���̺�
CREATE TABLE `answer` (
  `answer_no` int(11) NOT NULL AUTO_INCREMENT, -- �亯 ��ȣ
  `enquiry_no` int(11) NOT NULL, -- ���ǻ��� ��ȣ
  `answer_title` varchar(1024) NOT NULL, -- �亯 ����
  `answer_content` varchar(8196) NOT NULL, -- �亯 ����
  `a_writer_id` varchar(20) NOT NULL, -- �亯 �ۼ��� ���̵�
  `a_writer_name` varchar(50) NOT NULL, -- �亯 �ۼ��� �̸�
  `answer_hits` int(11) NOT NULL DEFAULT '0', -- �亯 ��ȸ��
  `answer_reg_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP, -- �亯 �����
  PRIMARY KEY (`answer_no`),
  KEY `fk_answer_enquiry_no` (`enquiry_no`),
  KEY `answer_FK` (`a_writer_id`),
  CONSTRAINT `answer_FK` FOREIGN KEY (`a_writer_id`) REFERENCES `member` (`user_id`),
  CONSTRAINT `fk_answer_enquiry_no` FOREIGN KEY (`enquiry_no`) REFERENCES `enquiry` (`enquiry_no`) ON DELETE CASCADE
)


-- �̺�Ʈ ���
show variables like 'event%';

-- �̺�Ʈ Ȱ��ȭ
set global event_scheduler = on;

-- ��� �� �̺�Ʈ ���
select * from information_schema.EVENTS;


-- ���� �Ұ� �ϼ� -1
DELIMITER //
CREATE PROCEDURE overdue_decrease()
begin
   update member 
     set user_overdue_date = user_overdue_date - 1
   where user_overdue_date > 0;
END //

-- �������� ���� �Ұ� �ϼ� -1 �ϴ� �̺�Ʈ
create event overdue_decrease
on schedule every 1 day
starts '2021-12-04 00:00:00'
comment '���� �Ұ� �� ��'
do
call overdue_decrease(); 




-- ������ ��� ���ν���
DELIMITER //
CREATE PROCEDURE seat_check()
begin
   update reading_room
      set user_id = null, checkin_time = null, checkout_time = null
    where checkout_time <= current_time;
END //

-- ������ �ǽð� �˻� �� ��� ó���ϴ� �̺�Ʈ
create event check_seat
on schedule every 1 second
comment '������ �ǽð� �˻�'
do
call seat_check(); 



-- �������� ���� �� �������� ��ȣ ����
DELIMITER //
CREATE PROCEDURE notice_reset()
begin
   SET @CNT = 0;
   UPDATE notice SET notice.notice_no = @CNT:=@CNT+1;
   set @max = (SELECT MAX(notice_no)+ 1 FROM notice); 
   set @str = CONCAT('ALTER TABLE notice AUTO_INCREMENT = ', @max);
   PREPARE qry FROM @str;
   EXECUTE qry;
   DEALLOCATE PREPARE qry;
END //



-- ���ǻ��� ���� �� ���ǻ��� ��ȣ ����
DELIMITER //
CREATE PROCEDURE enquiry_reset()
begin
   SET @CNT = 0;
   UPDATE enquiry SET enquiry.enquiry_no = @CNT:=@CNT+1;
   set @max = (SELECT MAX(enquiry_no)+ 1 FROM enquiry); 
   set @str = CONCAT('ALTER TABLE enquiry AUTO_INCREMENT = ', @max);
   PREPARE qry FROM @str;
   EXECUTE qry;
   DEALLOCATE PREPARE qry;
END //


-- �亯 ���� �� �亯 ��ȣ ����
DELIMITER //
CREATE PROCEDURE answer_reset()
begin
   SET @CNT = 0;
   UPDATE answer SET answer.answer_no = @CNT:=@CNT+1;
   set @max = (SELECT MAX(enquiry_no)+ 1 FROM enquiry); 
    set @str = CONCAT('ALTER TABLE answer AUTO_INCREMENT = ', @max);
    PREPARE qry FROM @str;
    EXECUTE qry;
    DEALLOCATE PREPARE qry;
END //

-- �нǹ� ã�� ���� �� �нǹ� ã�� ��ȣ ����
DELIMITER //
CREATE PROCEDURE article_reset()
begin
   SET @CNT = 0;
   UPDATE article SET article.article_no = @CNT:=@CNT+1;
   set @max = (SELECT MAX(article_no)+ 1 FROM article); 
    set @str = CONCAT('ALTER TABLE article AUTO_INCREMENT = ', @max);
    PREPARE qry FROM @str;
    EXECUTE qry;
    DEALLOCATE PREPARE qry;
END //

-- �ʱ� ������ ���� ����
-- id : admin
-- pw : asdfasdf

insert into member values
("admin", "$2a$10$oyw6645fwRPh9BOpgsVzZuqkSQr1N/b8UGE25hiU0ww7kEQ/e.YPW", "������", "2021-12-06", "01000000000",
"library.raon@gmail.com", "63309", "����Ư����ġ�� ���ֽ� ÷�ܷ� 242 (����)", "1", 10, 0, 0, 1, current_timestamp);
insert into member_auth values("admin", "ROLE_MEMBER");
insert into member_auth values("admin", "ROLE_ADMIN");
insert into member_auth values("admin", "ROLE_MASTER");

-- ������ �¼� insert
DELIMITER //
CREATE PROCEDURE insert_seat()
begin
    DECLARE i INT DEFAULT 1;
    WHILE (i <= 124) DO
        INSERT INTO reading_room(seat_no) VALUE (i); -- �� ���̺� i�� �־��ֱ�
        SET i = i + 1; -- �� i���� 1�����ְ� WHILE�� ó������ �̵�
    END WHILE;
END //

call insert_seat();

