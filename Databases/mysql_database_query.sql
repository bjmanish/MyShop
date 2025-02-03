SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

---------
-- SCHEMA MYSHOP
---------------------------------

CREATE SCHEMA IF NOT EXISTS `MYSHOP` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE `MYSHOP`;

--
-------------------
-- TABLE `MYSHOP`.`PRODUCT`
-----------------

DROP TABLE IF EXISTS `MYSHOP`.`PRODUCTS`;

CREATE TABLE IF NOT EXISTS `MYSHOP`.`PRODUCTS`(
    `pId` VARCHAR(45) NOT NULL,
    `pName` VARCHAR(100) NULL DEFAULT NULL,
    `pType` VARCHAR(20) NULL DEFAULT NULL,
    `pInfo` VARCHAR(350) NULL DEFAULT NULL,
    `pPrice` DECIMAL(12,2) NULL DEFAULT NULL,
    `pQuantity` INT NULL DEFAULT NULL,
    `image` LONGBLOB NULL DEFAULT NULL,
    PRIMARY KEY (`pId`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

--
------------------------------------
-- TABLE `MYSHOP`.`ORDERS`
--
--------------------------------------

DROP TABLE IF EXISTS `MYSHOP`.`ORDERS`;
select * from orders;
CREATE TABLE IF NOT EXISTS `MYSHOP`.`ORDERS`(
    `orderId` VARCHAR(45) NOT NULL,
    `prodId` VARCHAR(250) NOT NULL,
    `quantity` INT NULL DEFAULT NULL,
    `amount` DECIMAL(10,2) NULL DEFAULT NULL,
    `shipped` INT NOT NULL DEFAULT 0,
--     `image` LONGBLOB NULL DEFAULT NULL,
    PRIMARY KEY (`orderId`, `prodId`),
    INDEX `productId_idx` (`prodId` ASC) 
    VISIBLE,
    CONSTRAINT `productId` 
        FOREIGN KEY (`prodId`) 
        REFERENCES `MYSHOP`.`PRODUCTS`(`pId`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


--
-------------------
-- TABLE `MYSHOP`.`USER`
-----------------

DROP TABLE IF EXISTS `MYSHOP`.`USER`;

CREATE TABLE IF NOT EXISTS `MYSHOP`.`USER`(
    `image` LONGBLOB NULL DEFAULT NULL,
    `email` VARCHAR(60) NOT NULL,
    `name` VARCHAR(30) NULL DEFAULT NULL,
    `mobile` VARCHAR(12) NULL DEFAULT NULL,
    `address` VARCHAR(500) NULL DEFAULT NULL,
    `pincode` int NULL DEFAULT NULL,
    `password` VARCHAR(20) NULL DEFAULT NULL,
    PRIMARY KEY (`email`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


--
-------------------
-- TABLE `MYSHOP`.`TRANSACTIONS`
-----------------

DROP TABLE IF EXISTS `MYSHOP`.`TRANSACTIONS`;

CREATE TABLE IF NOT EXISTS `MYSHOP`.`TRANSACTIONS`(
    `transId` VARCHAR(45) NOT NULL,
    `userName` VARCHAR(60) NULL DEFAULT NULL,
    `time` DATETIME NULL DEFAULT NULL,
    `amount` DECIMAL(10,2) NULL DEFAULT NULL,
    PRIMARY KEY (`transId`),
    INDEX `trUserId_idx` (`userName` ASC) 
    VISIBLE,
    CONSTRAINT `trUserId` 
        FOREIGN KEY (`userName`) 
        REFERENCES `MYSHOP`.`USER`(`email`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION,
    CONSTRAINT `transOrderId` 
        FOREIGN KEY (`transId`) 
        REFERENCES `MYSHOP`.`ORDERS`(`orderId`)
        ON DELETE NO ACTION
        ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -------------------------------------------------
-- Table `MYSHOP`.`USER-DEMAND`
-- -------------------------------------------------
DROP TABLE IF EXISTS `MYSHOP`.`USER-DEMAND` ;

CREATE TABLE IF NOT EXISTS `MYSHOP`.`USER_DEMAND` (
  `userName` VARCHAR(60) NOT NULL,
  `prodId` VARCHAR(45) NOT NULL,
  `quantity` INT NULL DEFAULT NULL,
  PRIMARY KEY (`userName`, `prodId`),
  INDEX `prodId_idx` (`prodId` ASC) VISIBLE,
  CONSTRAINT `userdEmailEmail`
    FOREIGN KEY (`userName`)
    REFERENCES `MYSHOP`.`USER`(`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `prodId`
    FOREIGN KEY (`prodId`)
    REFERENCES `MYSHOP`.`PRODUCTS`(`pId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;



-- -----------------------------------------------------
-- Table `MYSHOP`.`USERCART`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MYSHOP`.`USERCART` ;

CREATE TABLE IF NOT EXISTS `MYSHOP`.`USERCART` (
  `username` VARCHAR(60) NULL DEFAULT NULL,
  `prodid` VARCHAR(45) NULL DEFAULT NULL,
  `quantity` INT NULL DEFAULT NULL,
  INDEX `useremail_idx` (`username` ASC) VISIBLE,
  INDEX `prodidcart_idx` (`prodid` ASC) VISIBLE,
  CONSTRAINT `useremail`
    FOREIGN KEY (`username`)
    REFERENCES `MYSHOP`.`USER` (`email`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `prodIdcart`
    FOREIGN KEY (`prodid`)
    REFERENCES `MYSHOP`.`PRODUCTS` (`pId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;

-- -----------------------------------------------------
-- Table `MYSHOP`.`DELIVERYSTAFF`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `MYSHOP`.`DELIVERYSTAFF` ;

CREATE TABLE IF NOT EXISTS `MYSHOP`.`DELIVERYSTAFF`(
    `simage` LONGBLOB NULL DEFAULT NULL,
    `semail` VARCHAR(60) NOT NULL,
    `sname` VARCHAR(30) NULL DEFAULT NULL,
    `smobile` VARCHAR(12) NULL DEFAULT NULL,
    `spassword` VARCHAR(20) NULL DEFAULT NULL,
    PRIMARY KEY (`semail`)
)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;


describe `USER`;
select * from user;
SELECT image FROM USER WHERE email="bjmanish45@gmail.com";
select * from deliverystaff;

-- SELECT * FROM USER_DEMAND WHERE userName='bjmanish45@gmail.com' AND prodId='P20250121052653';

-- SELECT P.pId AS ProdId, O.orderId AS orderId, t.transId As transId, O.shipped AS shipped, P.image AS image, 
--                 P.pName AS pName, O.quantity AS quantity, O.amount AS amount, T.time AS time FROM ORDERS O, TRANSACTIONS T , PRODUCTS P
--                 WHERE O.orderId = T.transId AND O.orderId = T.transId AND O.prodId = P.pId AND T.userName="bjmanish45@gmail.com";

-- SELECT * FROM ORDERS o INNER JOIN TRANSACTIONS t INNER JOIN PRODUCTS p ON o.orderId = t.transId AND o.prodId = p.pId WHERE t.userName='bjmanish45@gmail.com';
