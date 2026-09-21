CREATE SCHEMA IF NOT EXISTS `bank_schema` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `bank_schema`;

CREATE TABLE `client` (
  `client_id` int NOT NULL AUTO_INCREMENT,
  `f_name` varchar(45) NOT NULL,
  `l_name` varchar(45) NOT NULL,
  `father_name` varchar(45) NOT NULL,
  `mother_name` varchar(45) NOT NULL,
  `CNIC` varchar(45) NOT NULL,
  `DOB` date NOT NULL,
  `phone` varchar(45) NOT NULL,
  `email` varchar(45) DEFAULT NULL,
  `address` varchar(100) NOT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
ALTER TABLE client AUTO_INCREMENT=10000;

CREATE TABLE `login_account` (
  `login_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL, 
  `type` char(1) NOT NULL,
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
ALTER TABLE login_account AUTO_INCREMENT=60000;

CREATE TABLE `card` (
  `card_num` int NOT NULL AUTO_INCREMENT,
  `type` char(1) NOT NULL,
  `Status` char(1) NOT NULL,
  `Pin_code` char(4) NOT NULL,
  `Issue_date` date NOT NULL,
  PRIMARY KEY (`card_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
ALTER TABLE card AUTO_INCREMENT=40000;

CREATE TABLE `bank_account` (
  `acc_num` int NOT NULL AUTO_INCREMENT,
  `client_id` int NOT NULL,
  `login_id` int DEFAULT NULL,
  `type` char(10) NOT NULL,
  `balance` int NOT NULL,
  `status` int NOT NULL,
  `opening_date` date NOT NULL,
  `closing_date` date DEFAULT NULL,
  `card_num` int DEFAULT NULL,
  PRIMARY KEY (`acc_num`),
  CONSTRAINT `fk_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `fk_login` FOREIGN KEY (`login_id`) REFERENCES `login_account` (`login_id`),
  CONSTRAINT `fk_card` FOREIGN KEY (`card_num`) REFERENCES `card` (`card_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
ALTER TABLE bank_account AUTO_INCREMENT=500000;

CREATE TABLE `transaction_history` (
  `serial_no` int unsigned NOT NULL AUTO_INCREMENT,
  `amount` int NOT NULL,
  `type` varchar(45) NOT NULL,
  `date` date NOT NULL,
  `time` varchar(45) NOT NULL,
  `account_num` int NOT NULL,
  `recv_acc_num` int DEFAULT NULL,
  `cheque_num` int DEFAULT NULL,
  PRIMARY KEY (`serial_no`),
  CONSTRAINT `fk_tx_account` FOREIGN KEY (`account_num`) REFERENCES `bank_account` (`acc_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
ALTER TABLE transaction_history AUTO_INCREMENT=70000;

-- SEED ACCOUNTS
INSERT INTO client VALUES(10000, 'Ahmed', 'Ali', 'Zubair Ali', 'Ayesha Khan', '67153-7853257-8', '1999-09-17', '03787817865', 'ahmedali987@gmail.com', 'Rawalpindi');
INSERT INTO client VALUES(10001, 'Maria', 'Yasir', 'Sohail Jameel', 'Faiza Saleem', '78342-0978912-8', '1995-03-21', '03569899631', 'maria_y03@gmail.com', 'DHA Islamabad');

INSERT INTO login_account VALUES (60002, 'ahmed107', 'tom891', 'C');
INSERT INTO login_account VALUES (60003, 'maria_y70', 'green8', 'C');

INSERT INTO card VALUES(40000, 'C', 'A', '8947', CURDATE());
INSERT INTO card VALUES(40001, 'D', 'A', '3921', CURDATE());

INSERT INTO bank_account VALUES(500000, 10000, 60002, 'Current', 1000, 1, CURDATE(), NULL, 40000);
INSERT INTO bank_account VALUES(500001, 10001, 60003, 'Current', 20000, 1, CURDAT
