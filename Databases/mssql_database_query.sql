/* =========================================================
   CREATE DATABASE
   ========================================================= */

IF DB_ID('MYSHOP') IS NULL
BEGIN
    CREATE DATABASE MYSHOP;
END
GO

USE MYSHOP;
GO


/* =========================================================
   DROP TABLES
   ========================================================= */

IF OBJECT_ID('dbo.ASSIGNORDERFORSTAFF', 'U') IS NOT NULL
    DROP TABLE dbo.ASSIGNORDERFORSTAFF;

IF OBJECT_ID('dbo.USERCART', 'U') IS NOT NULL
    DROP TABLE dbo.USERCART;

IF OBJECT_ID('dbo.USER_DEMAND', 'U') IS NOT NULL
    DROP TABLE dbo.USER_DEMAND;

IF OBJECT_ID('dbo.TRANSACTIONS', 'U') IS NOT NULL
    DROP TABLE dbo.TRANSACTIONS;

IF OBJECT_ID('dbo.PAYMENTS_PAYU', 'U') IS NOT NULL
    DROP TABLE dbo.PAYMENTS_PAYU;

IF OBJECT_ID('dbo.ORDERS', 'U') IS NOT NULL
    DROP TABLE dbo.ORDERS;

IF OBJECT_ID('dbo.DELIVERYSTAFF', 'U') IS NOT NULL
    DROP TABLE dbo.DELIVERYSTAFF;

IF OBJECT_ID('dbo.USER', 'U') IS NOT NULL
    DROP TABLE dbo.[USER];

IF OBJECT_ID('dbo.PRODUCTS', 'U') IS NOT NULL
    DROP TABLE dbo.PRODUCTS;

IF OBJECT_ID('dbo.ADMIN', 'U') IS NOT NULL
    DROP TABLE dbo.ADMIN;
GO


/* =========================================================
   PRODUCTS
   ========================================================= */

CREATE TABLE dbo.PRODUCTS
(
    pId        VARCHAR(45) NOT NULL,
    pName      VARCHAR(100) NULL,
    pType      VARCHAR(20) NULL,
    pInfo      VARCHAR(350) NULL,
    pPrice     DECIMAL(12,2) NULL,
    pQuantity  INT NULL,
    image      VARBINARY(MAX) NULL,

    CONSTRAINT PK_PRODUCTS
        PRIMARY KEY (pId)
);
GO


/* =========================================================
   USER
   ========================================================= */

CREATE TABLE dbo.USER
(
    image           VARBINARY(MAX) NULL,
    email           VARCHAR(60) NOT NULL,
    name            VARCHAR(30) NULL,
    mobile          VARCHAR(12) NULL,
    address         VARCHAR(500) NULL,
    pincode         INT NULL,
    password        VARCHAR(255) NULL,
    email_verified  BIT NOT NULL DEFAULT 1,
    mobile_verified BIT NOT NULL DEFAULT 0,

    CONSTRAINT PK_USER
        PRIMARY KEY (email)
);
GO


/* =========================================================
   DELIVERY STAFF
   ========================================================= */

CREATE TABLE dbo.DELIVERYSTAFF
(
    simage      VARBINARY(MAX) NULL,
    semail      VARCHAR(60) NOT NULL,
    sname       VARCHAR(30) NULL,
    smobile     VARCHAR(12) NULL,
    spassword   VARCHAR(255) NULL,

    CONSTRAINT PK_DELIVERYSTAFF
        PRIMARY KEY (semail)
);
GO


/* =========================================================
   ORDERS
   ========================================================= */

CREATE TABLE dbo.ORDERS
(
    orderId       VARCHAR(45) NOT NULL,
    prodId        VARCHAR(45) NOT NULL,
    quantity      INT NULL,
    amount        DECIMAL(10,2) NULL,
    order_date    DATETIME2 NOT NULL DEFAULT GETDATE(),
    delivery_date DATE NULL,
    shipped       INT NOT NULL DEFAULT 0,

    CONSTRAINT PK_ORDERS
        PRIMARY KEY (orderId, prodId),

    CONSTRAINT FK_ORDERS_PRODUCTS
        FOREIGN KEY (prodId)
        REFERENCES dbo.PRODUCTS(pId)
);
GO


/* =========================================================
   TRIGGER
   Automatically set delivery date = order date + 7 days
   ========================================================= */

CREATE TRIGGER dbo.trg_Orders_SetDeliveryDate
ON dbo.ORDERS
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE o
    SET delivery_date = DATEADD(DAY, 7, i.order_date)
    FROM dbo.ORDERS o
    INNER JOIN inserted i
        ON o.orderId = i.orderId
        AND o.prodId = i.prodId
    WHERE i.delivery_date IS NULL;
END;
GO


/* =========================================================
   TRANSACTIONS
   ========================================================= */

CREATE TABLE dbo.TRANSACTIONS
(
    transId   VARCHAR(45) NOT NULL,
    userName  VARCHAR(60) NULL,
    [time]    DATETIME2 NULL,
    amount    DECIMAL(10,2) NULL,

    CONSTRAINT PK_TRANSACTIONS
        PRIMARY KEY (transId),

    CONSTRAINT FK_TRANSACTIONS_USER
        FOREIGN KEY (userName)
        REFERENCES dbo.USER(email)
);
GO

/* =========================================================
   USER DEMAND
   ========================================================= */

CREATE TABLE dbo.PAYMENTS_PAYU
(
    payment_id1 VARCHAR(50) NOT NULL,
    order_id    VARCHAR(50) NOT NULL,
    user_id     VARCHAR(50) NOT NULL,
    txn_id      VARCHAR(100) NOT NULL,
    amount      DECIMAL(10,2) NOT NULL,
    status      VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    payu_hash   VARCHAR(255) NULL,

    created_at  DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_PAYMENTS_PAYU
        PRIMARY KEY (payment_id1),

    CONSTRAINT UQ_PAYMENTS_PAYU_TXN
        UNIQUE (txn_id),

    CONSTRAINT FK_PAYMENTS_PAYU_USERS
        FOREIGN KEY (user_id)
        REFERENCES dbo.[USER](user_id),
    
    CONSTRAINT FK_PAYMENTS_PAYU_USER
        FOREIGN KEY (order_id)
        REFERENCES dbo.ORDERS(orderId)
);
GO

/* =========================================================
   USER DEMAND
   ========================================================= */

CREATE TABLE dbo.USER_DEMAND
(
    userName VARCHAR(60) NOT NULL,
    prodId   VARCHAR(45) NOT NULL,
    quantity INT NULL,

    CONSTRAINT PK_USER_DEMAND
        PRIMARY KEY (userName, prodId),

    CONSTRAINT FK_USER_DEMAND_USER
        FOREIGN KEY (userName)
        REFERENCES dbo.USER(email),

    CONSTRAINT FK_USER_DEMAND_PRODUCT
        FOREIGN KEY (prodId)
        REFERENCES dbo.PRODUCTS(pId)
);
GO


/* =========================================================
   USER CART
   ========================================================= */

CREATE TABLE dbo.USERCART
(
    username VARCHAR(60) NULL,
    prodid   VARCHAR(45) NULL,
    quantity INT NULL,

    CONSTRAINT FK_USERCART_USER
        FOREIGN KEY (username)
        REFERENCES dbo.USER(email),

    CONSTRAINT FK_USERCART_PRODUCT
        FOREIGN KEY (prodid)
        REFERENCES dbo.PRODUCTS(pId)
);
GO


/* =========================================================
   ASSIGN ORDER FOR STAFF
   ========================================================= */

CREATE TABLE dbo.ASSIGNORDERFORSTAFF
(
    assignId       INT IDENTITY(1,1) NOT NULL,
    prodId         VARCHAR(45) NULL,
    orderId        VARCHAR(45) NOT NULL,
    staffId        VARCHAR(60) NOT NULL,
    staffName      VARCHAR(30) NULL,
    assignedDate   DATE NULL,
    deliveryStatus VARCHAR(20) NULL,
    otp            VARCHAR(10) NULL,
    otpGeneratedAt DATETIME2 NOT NULL DEFAULT GETDATE(),
    remarks        VARCHAR(255) NULL,

    CONSTRAINT PK_ASSIGNORDERFORSTAFF
        PRIMARY KEY (assignId),

    /*
       ORDERS has composite PK:
       (orderId, prodId)

       Therefore both columns are used in the FK.
    */
    CONSTRAINT FK_ASSIGN_ORDER
        FOREIGN KEY (orderId, prodId)
        REFERENCES dbo.ORDERS(orderId, prodId),

    CONSTRAINT FK_ASSIGN_STAFF
        FOREIGN KEY (staffId)
        REFERENCES dbo.DELIVERYSTAFF(semail)
);
GO


/* =========================================================
   ADMIN
   ========================================================= */

CREATE TABLE dbo.ADMIN
(
    admin_id   INT IDENTITY(1,1) NOT NULL,
    admin_name VARCHAR(50) NOT NULL,
    email      VARCHAR(100) NOT NULL,
    password   VARCHAR(255) NOT NULL,
    mobile     VARCHAR(15) NULL,
    role       VARCHAR(20) NOT NULL DEFAULT 'ADMIN',
    status     VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
    updated_at DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_ADMIN
        PRIMARY KEY (admin_id),

    CONSTRAINT UQ_ADMIN_EMAIL
        UNIQUE (email)
);
GO


/* =========================================================
   INSERT ADMIN
   ========================================================= */

INSERT INTO dbo.ADMIN
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
GO


/* =========================================================
   TEST DATA / CHECK TABLES
   ========================================================= */

SELECT * FROM dbo.ORDERS;
SELECT * FROM dbo.USER;
SELECT * FROM dbo.PRODUCTS;
SELECT * FROM dbo.TRANSACTIONS;
SELECT * FROM dbo.USER_DEMAND;
SELECT * FROM dbo.USERCART;
SELECT * FROM dbo.ASSIGNORDERFORSTAFF;
SELECT * FROM dbo.DELIVERYSTAFF;
SELECT * FROM dbo.ADMIN;
GO