CREATE SCHEMA IF NOT EXISTS `bank_schema` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE `bank_schema`;

-- ==========================================
-- TABLE CREATION
-- ==========================================

-- 1. Client Table
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE client AUTO_INCREMENT=10000;

-- 2. Login_Account Table
CREATE TABLE `login_account` (
  `login_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(45) NOT NULL,
  `password` varchar(255) NOT NULL, 
  `type` char(1) NOT NULL,
  PRIMARY KEY (`login_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE login_account AUTO_INCREMENT=60000;

-- 3. Employee Table
CREATE TABLE `employee` (
  `employee_id` int NOT NULL AUTO_INCREMENT,
  `f_name` varchar(45) NOT NULL,
  `l_name` varchar(45) NOT NULL,
  `father_name` varchar(45) NOT NULL,
  `mother_name` varchar(45) NOT NULL,
  `job` varchar(45) NOT NULL,
  `phone_no` varchar(45) NOT NULL,
  `email` varchar(45) NOT NULL,
  `login_id` int DEFAULT NULL,
  PRIMARY KEY (`employee_id`),
  KEY `login_id_idx` (`login_id`),
  CONSTRAINT `fk_employee_login` FOREIGN KEY (`login_id`) REFERENCES `login_account` (`login_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE employee AUTO_INCREMENT=20000;

-- 4. Card Table
CREATE TABLE `card` (
  `card_num` int NOT NULL AUTO_INCREMENT,
  `type` char(1) NOT NULL,
  `Status` char(1) NOT NULL,
  `Pin_code` char(4) NOT NULL,
  `Issue_date` date NOT NULL,
  PRIMARY KEY (`card_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE card AUTO_INCREMENT=40000;

-- 5. Bank_Account Table
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
  KEY `client_id` (`client_id`),
  KEY `login_id` (`login_id`),
  KEY `card_num` (`card_num`),
  CONSTRAINT `bank_account_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `bank_account_ibfk_2` FOREIGN KEY (`login_id`) REFERENCES `login_account` (`login_id`),
  CONSTRAINT `bank_account_ibfk_3` FOREIGN KEY (`card_num`) REFERENCES `card` (`card_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE bank_account AUTO_INCREMENT=500000;

-- 6. Transaction_History Table
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
  KEY `account_num` (`account_num`),
  CONSTRAINT `transaction_history_ibfk_1` FOREIGN KEY (`account_num`) REFERENCES `bank_account` (`acc_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE transaction_history AUTO_INCREMENT=70000;

-- 7. Cardless Withdrawal Table
CREATE TABLE `cardless_withdrawl` (
  `serial_no` int NOT NULL AUTO_INCREMENT,
  `card_no` int NOT NULL,
  `amount` int NOT NULL,
  `OTC` varchar(13) NOT NULL,
  `temp_pin` char(4) NOT NULL,
  `Status` char(1) NOT NULL,
  `date` date DEFAULT NULL,
  `time` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`serial_no`),
  KEY `card_no` (`card_no`),
  CONSTRAINT `cardless_withdrawl_ibfk_1` FOREIGN KEY (`card_no`) REFERENCES `card` (`card_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

ALTER TABLE cardless_withdrawl AUTO_INCREMENT=80000;


-- ==========================================
-- SAMPLE DEMO DATA INSERTION
-- ==========================================

-- Employees
INSERT INTO employee VALUES(20000, 'Nasir', 'Saeed', 'Saaed Yonus', 'Sara Naeem', 'Manager', '03908967581', 'nasir_saeed2311@gmail.com', NULL );
INSERT INTO employee VALUES(20001, 'Faizan', 'Raheem', 'Raheem Aslam', 'Asma Javeed', 'Accountant', '03778234199', 'faizan0045@gmail.com', NULL );

-- Clients
INSERT INTO client VALUES(10000, 'Ahmed', 'Ali', 'Zubair Ali', 'Ayesha Khan', '67153-7853257-8', STR_TO_DATE('17,9,1999', '%d,%m,%Y'), '03787817865', 'ahmedali987@gmail.com', 'House No. 412, Street 7, Fasil Colony, Rawalpindi');
INSERT INTO client VALUES(10001, 'Maria', 'Yasir', 'Sohail Jameel', 'Faiza Saleem', '78342-0978912-8', STR_TO_DATE('21,3,1995', '%d,%m,%Y'), '03569899631', 'maria_y03@gmail.com', 'House No. 112, Street 3B, Block 2, DHA Islamabad');
INSERT INTO client VALUES(10002, 'Daniel', 'Zaid', 'Zaid Bilal', 'Saba Tahir', '43210-7809821-1', STR_TO_DATE('7,11,1995', '%d,%m,%Y'), '03665132497', 'danielzahid909@gmail.com', 'House No. 8, Street 12, Ramzan Colony, Rawalpindi');

-- Login accounts
INSERT INTO login_account VALUES (60000, 'nasir55', '122221', 'M');
INSERT INTO login_account VALUES (60001, 'faizan211', '909094', 'A');
INSERT INTO login_account VALUES (60002, 'ahmed107', 'tom891', 'C');
INSERT INTO login_account VALUES (60003, 'maria_y70', 'green8', 'C');
INSERT INTO login_account VALUES (60004, 'daniel345', '90jeep', 'C');

-- Cards
INSERT INTO card VALUES(40000, 'C', 'A', '8947', CURDATE() );
INSERT INTO card VALUES(40001, 'D', 'A', '3921', CURDATE() );

-- Bank accounts
INSERT INTO bank_account VALUES(500000, 10000, 60002, 'Current', 1000, 1, CURDATE(), NULL, 40000);
INSERT INTO bank_account VALUES(500001, 10001, 60003, 'Current', 20000, 1, CURDATE(), NULL, 40001);
INSERT INTO bank_account VALUES(500002, 10002, 60004, 'Saving', 7000, 1, CURDATE(), NULL, NULL);

-- Finalize Employee links
UPDATE employee SET login_id = 60000 WHERE employee_id = 20000;
UPDATE employee SET login_id = 60001 WHERE employee_id = 20001;
