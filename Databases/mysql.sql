/* =========================================================
   CREATE DATABASE
   ========================================================= */

CREATE DATABASE IF NOT EXISTS MYSHOP;

USE MYSHOP;


/* =========================================================
   DROP TRIGGER FIRST
   ========================================================= */

DROP TRIGGER IF EXISTS trg_Orders_SetDeliveryDate;


/* =========================================================
   DROP TABLES
   ========================================================= */

DROP TABLE IF EXISTS ASSIGNORDERFORSTAFF;
DROP TABLE IF EXISTS USERCART;
DROP TABLE IF EXISTS USER_DEMAND;
DROP TABLE IF EXISTS TRANSACTIONS;
DROP TABLE IF EXISTS ORDERS;
DROP TABLE IF EXISTS DELIVERYSTAFF;
DROP TABLE IF EXISTS USER;
DROP TABLE IF EXISTS PRODUCTS;
DROP TABLE IF EXISTS ADMIN;


/* =========================================================
   PRODUCTS
   ========================================================= */

CREATE TABLE PRODUCTS
(
    pId        VARCHAR(45) NOT NULL,
    pName      VARCHAR(100) NULL,
    pType      VARCHAR(20) NULL,
    pInfo      VARCHAR(350) NULL,
    pPrice     DECIMAL(12,2) NULL,
    pQuantity  INT NULL,
    image      LONGBLOB NULL,

    CONSTRAINT PK_PRODUCTS
        PRIMARY KEY (pId)
) ENGINE=InnoDB;


/* =========================================================
   USER
   ========================================================= */

CREATE TABLE USER
(
    image           LONGBLOB NULL,
    email           VARCHAR(60) NOT NULL,
    name            VARCHAR(30) NULL,
    mobile          VARCHAR(12) NULL,
    address         VARCHAR(500) NULL,
    pincode         INT NULL,
    password        VARCHAR(255) NULL,
    email_verified  BOOLEAN NOT NULL DEFAULT TRUE,
    mobile_verified BOOLEAN NOT NULL DEFAULT FALSE,

    CONSTRAINT PK_USER
        PRIMARY KEY (email)
) ENGINE=InnoDB;


/* =========================================================
   DELIVERY STAFF
   ========================================================= */

CREATE TABLE DELIVERYSTAFF
(
    simage      LONGBLOB NULL,
    semail      VARCHAR(60) NOT NULL,
    sname       VARCHAR(30) NULL,
    smobile     VARCHAR(12) NULL,
    spassword   VARCHAR(255) NULL,

    CONSTRAINT PK_DELIVERYSTAFF
        PRIMARY KEY (semail)
) ENGINE=InnoDB;


/* =========================================================
   ORDERS
   ========================================================= */

CREATE TABLE ORDERS
(
    orderId       VARCHAR(45) NOT NULL,
    prodId        VARCHAR(45) NOT NULL,
    quantity      INT NULL,
    amount        DECIMAL(10,2) NULL,
    order_date    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    delivery_date DATE NULL,
    shipped       INT NOT NULL DEFAULT 0,

    CONSTRAINT PK_ORDERS
        PRIMARY KEY (orderId, prodId),

    CONSTRAINT FK_ORDERS_PRODUCTS
        FOREIGN KEY (prodId)
        REFERENCES PRODUCTS(pId)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


/* =========================================================
   TRIGGER
   Automatically set delivery date = order date + 7 days
   ========================================================= */

DELIMITER $$

CREATE TRIGGER trg_Orders_SetDeliveryDate
BEFORE INSERT ON ORDERS
FOR EACH ROW
BEGIN
    IF NEW.delivery_date IS NULL THEN
        SET NEW.delivery_date =
            DATE(DATE_ADD(NEW.order_date, INTERVAL 7 DAY));
    END IF;
END$$

DELIMITER ;


/* =========================================================
   TRANSACTIONS
   ========================================================= */

CREATE TABLE TRANSACTIONS
(
    transId   VARCHAR(45) NOT NULL,
    userName  VARCHAR(60) NULL,
    `time`    DATETIME NULL,
    amount    DECIMAL(10,2) NULL,

    CONSTRAINT PK_TRANSACTIONS
        PRIMARY KEY (transId),

    CONSTRAINT FK_TRANSACTIONS_USER
        FOREIGN KEY (userName)
        REFERENCES USER(email)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE=InnoDB;


/* =========================================================
   USER DEMAND
   ========================================================= */

CREATE TABLE USER_DEMAND
(
    userName VARCHAR(60) NOT NULL,
    prodId   VARCHAR(45) NOT NULL,
    quantity INT NULL,

    CONSTRAINT PK_USER_DEMAND
        PRIMARY KEY (userName, prodId),

    CONSTRAINT FK_USER_DEMAND_USER
        FOREIGN KEY (userName)
        REFERENCES USER(email)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_USER_DEMAND_PRODUCT
        FOREIGN KEY (prodId)
        REFERENCES PRODUCTS(pId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;


/* =========================================================
   USER CART
   ========================================================= */

CREATE TABLE USERCART
(
    username VARCHAR(60) NOT NULL,
    prodid   VARCHAR(45) NOT NULL,
    quantity INT NULL,

    CONSTRAINT FK_USERCART_USER
        FOREIGN KEY (username)
        REFERENCES USER(email)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_USERCART_PRODUCT
        FOREIGN KEY (prodid)
        REFERENCES PRODUCTS(pId)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE=InnoDB;


/* =========================================================
   ASSIGN ORDER FOR STAFF
   ========================================================= */

CREATE TABLE ASSIGNORDERFORSTAFF
(
    assignId       INT NOT NULL AUTO_INCREMENT,
    prodId         VARCHAR(45) NULL,
    orderId        VARCHAR(45) NOT NULL,
    staffId        VARCHAR(60) NOT NULL,
    staffName      VARCHAR(30) NULL,
    assignedDate   DATE NULL,
    deliveryStatus VARCHAR(20) NULL,
    otp            VARCHAR(10) NULL,
    otpGeneratedAt DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    remarks        VARCHAR(255) NULL,

    CONSTRAINT PK_ASSIGNORDERFORSTAFF
        PRIMARY KEY (assignId),

    CONSTRAINT FK_ASSIGN_ORDER
        FOREIGN KEY (orderId, prodId)
        REFERENCES ORDERS(orderId, prodId)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT FK_ASSIGN_STAFF
        FOREIGN KEY (staffId)
        REFERENCES DELIVERYSTAFF(semail)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;


/* =========================================================
   ADMIN
   ========================================================= */

CREATE TABLE ADMIN
(
    admin_id   INT NOT NULL AUTO_INCREMENT,
    admin_name VARCHAR(50) NOT NULL,
    email      VARCHAR(100) NOT NULL,
    password   VARCHAR(255) NOT NULL,
    mobile     VARCHAR(15) NULL,
    role       VARCHAR(20) NOT NULL DEFAULT 'ADMIN',
    status     VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
                           ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT PK_ADMIN
        PRIMARY KEY (admin_id),

    CONSTRAINT UQ_ADMIN_EMAIL
        UNIQUE (email)
) ENGINE=InnoDB;


/* =========================================================
   INSERT ADMIN
   ========================================================= */

INSERT INTO ADMIN
(
    admin_name,
    email,
    password,
    mobile
)
VALUES
(
    'Super Admin',
    'admin123@gmail.com',
    'YWRtaW4=',
    '6206848898'
);


/* =========================================================
   TEST DATA / CHECK TABLES
   ========================================================= */

SELECT * FROM ORDERS;
SELECT * FROM USER;
SELECT * FROM PRODUCTS;
SELECT * FROM TRANSACTIONS;
SELECT * FROM USER_DEMAND;
SELECT * FROM USERCART;
SELECT * FROM ASSIGNORDERFORSTAFF;
SELECT * FROM DELIVERYSTAFF;
SELECT * FROM ADMIN;