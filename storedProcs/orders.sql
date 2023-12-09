/* 21HTTT1 - 21CLC1.CSDLNC.03
 * 21127004 - Trần Nguyễn An Phong
 * 21127135 - Diệp Hữu Phúc
 * 21127296 - Đặng Hà Huy
 * 21127315 - Nguyễn Gia Khánh
 * 21127712 - Lê Quang Trường
 */
USE [NC03_ORDERENTRY]
GO

CREATE OR ALTER PROC USP_ORDERS_INS
    @CUSTOMER_TELEPHONE_NUMBER VARCHAR(11),
    @ORDER_DATE DATE,
    @SHIPPING_STREET_ADDRESS NVARCHAR(100),
    @SHIPPING_CITY NVARCHAR(100),
    @SHIPPING_STATE NVARCHAR(100),
    @SHIPPING_ZIP_CODE VARCHAR(10),
    @SHIPPING_DATE DATE,
    @CUSTOMER_IDENTIFIER CHAR(7),
    @CUSTOMER_CREDIT_CARD_NUMBER CHAR(7),
    @ORDER_NUMBER CHAR(7) = NULL OUTPUT
AS BEGIN TRAN
    IF NOT EXISTS (SELECT CUSTOMER_IDENTIFIER FROM CUSTOMER
        WHERE CUSTOMER_IDENTIFIER = @CUSTOMER_IDENTIFIER) BEGIN
        RAISERROR('INVALID CUSTOMER IDENTIFIER', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    IF @CUSTOMER_CREDIT_CARD_NUMBER IS NOT NULL BEGIN
        IF NOT EXISTS (SELECT CUSTOMER_CREDIT_CARD_NUMBER FROM CREDIT_CARD
            WHERE CUSTOMER_CREDIT_CARD_NUMBER =
                @CUSTOMER_CREDIT_CARD_NUMBER) BEGIN
            RAISERROR('INVALID CUSTOMER CREDIT CARD NUMBER', 16, 1)
            ROLLBACK TRAN
            RETURN -2
        END

        UPDATE CREDIT_CARD SET USAGE_COUNT += 1
        WHERE CUSTOMER_CREDIT_CARD_NUMBER = @CUSTOMER_CREDIT_CARD_NUMBER
    END

    SELECT @ORDER_NUMBER = ORDER_NUMBER FROM ORDERS
    WHERE ORDER_NUMBER = (SELECT MAX(ORDER_NUMBER) FROM ORDERS)

    SET @ORDER_NUMBER = dbo.F_MAKE_ID('OD', @ORDER_NUMBER)

    INSERT INTO ORDERS
    VALUES (@ORDER_NUMBER, @CUSTOMER_TELEPHONE_NUMBER, @ORDER_DATE,
        @SHIPPING_STREET_ADDRESS, @SHIPPING_CITY, @SHIPPING_STATE,
        @SHIPPING_ZIP_CODE, @SHIPPING_DATE, 0, @CUSTOMER_IDENTIFIER,
        @CUSTOMER_CREDIT_CARD_NUMBER)    
COMMIT TRAN
RETURN 0
GO

CREATE OR ALTER PROC USP_ORDERS_UPD
    @ORDER_NUMBER CHAR(7),
    @CUSTOMER_TELEPHONE_NUMBER VARCHAR(11),
    @ORDER_DATE DATE,
    @SHIPPING_STREET_ADDRESS NVARCHAR(100),
    @SHIPPING_CITY NVARCHAR(100),
    @SHIPPING_STATE NVARCHAR(100),
    @SHIPPING_ZIP_CODE VARCHAR(10),
    @SHIPPING_DATE DATE,
    @CUSTOMER_IDENTIFIER CHAR(7),
    @CUSTOMER_CREDIT_CARD_NUMBER CHAR(7)
AS BEGIN TRAN
    IF NOT EXISTS (SELECT ORDER_NUMBER FROM ORDERS
        WHERE ORDER_NUMBER = @ORDER_NUMBER) BEGIN
        RAISERROR('INVALID ORDER NUMBER', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    IF NOT EXISTS (SELECT CUSTOMER_IDENTIFIER FROM CUSTOMER
        WHERE CUSTOMER_IDENTIFIER = @CUSTOMER_IDENTIFIER) BEGIN
        RAISERROR('INVALID CUSTOMER IDENTIFIER', 16, 1)
        ROLLBACK TRAN
        RETURN -2
    END

    IF @CUSTOMER_CREDIT_CARD_NUMBER IS NOT NULL AND NOT EXISTS
        (SELECT CUSTOMER_CREDIT_CARD_NUMBER FROM CREDIT_CARD
        WHERE CUSTOMER_CREDIT_CARD_NUMBER =
            @CUSTOMER_CREDIT_CARD_NUMBER) BEGIN
            RAISERROR('INVALID CUSTOMER CREDIT CARD NUMBER', 16, 1)
            ROLLBACK TRAN
            RETURN -3
    END

    IF @CUSTOMER_TELEPHONE_NUMBER IS NULL OR @ORDER_DATE IS NULL OR
        @SHIPPING_STREET_ADDRESS IS NULL OR @SHIPPING_CITY IS NULL OR
        @SHIPPING_STATE IS NULL OR @SHIPPING_ZIP_CODE IS NULL OR
        @SHIPPING_DATE IS NULL BEGIN
        RAISERROR('INVALID DATA', 16, 1)
        ROLLBACK TRAN
        RETURN -4
    END

    UPDATE ORDERS SET CUSTOMER_TELEPHONE_NUMBER = @CUSTOMER_TELEPHONE_NUMBER,
        ORDER_DATE = @ORDER_DATE, SHIPPING_STREET_ADDRESS = @SHIPPING_STREET_ADDRESS,
        SHIPPING_CITY = @SHIPPING_CITY, SHIPPING_STATE = @SHIPPING_STATE,
        SHIPPING_ZIP_CODE = @SHIPPING_ZIP_CODE, SHIPPING_DATE = @SHIPPING_DATE,
        CUSTOMER_IDENTIFIER = @CUSTOMER_IDENTIFIER,
        CUSTOMER_CREDIT_CARD_NUMBER = @CUSTOMER_CREDIT_CARD_NUMBER
    WHERE ORDER_NUMBER = @ORDER_NUMBER

    DECLARE @OLD_CUSTOMER_CREDIT_CARD_NUMBER CHAR(7)
    SELECT @OLD_CUSTOMER_CREDIT_CARD_NUMBER = CUSTOMER_CREDIT_CARD_NUMBER
    FROM ORDERS WHERE ORDER_NUMBER = @ORDER_NUMBER

    IF @OLD_CUSTOMER_CREDIT_CARD_NUMBER IS NOT NULL
        UPDATE CREDIT_CARD SET USAGE_COUNT -= 1
        WHERE CUSTOMER_CREDIT_CARD_NUMBER = @OLD_CUSTOMER_CREDIT_CARD_NUMBER

    IF @CUSTOMER_CREDIT_CARD_NUMBER IS NOT NULL
        UPDATE CREDIT_CARD SET USAGE_COUNT += 1
        WHERE CUSTOMER_CREDIT_CARD_NUMBER = @CUSTOMER_CREDIT_CARD_NUMBER
COMMIT TRAN
RETURN 0
GO

CREATE OR ALTER PROC USP_ORDERS_DEL
    @ORDER_NUMBER CHAR(7)
AS BEGIN TRAN
    IF NOT EXISTS (SELECT ORDER_NUMBER FROM ORDERS
        WHERE ORDER_NUMBER = @ORDER_NUMBER) BEGIN
        RAISERROR('INVALID ORDER NUMBER', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    DECLARE @OLD_CUSTOMER_CREDIT_CARD_NUMBER CHAR(7)
    SELECT @OLD_CUSTOMER_CREDIT_CARD_NUMBER = CUSTOMER_CREDIT_CARD_NUMBER
    FROM ORDERS WHERE ORDER_NUMBER = @ORDER_NUMBER

    DELETE FROM ORDERS WHERE ORDER_NUMBER = @ORDER_NUMBER

    IF @OLD_CUSTOMER_CREDIT_CARD_NUMBER IS NOT NULL
        UPDATE CREDIT_CARD SET USAGE_COUNT -= 1
        WHERE CUSTOMER_CREDIT_CARD_NUMBER = @OLD_CUSTOMER_CREDIT_CARD_NUMBER
COMMIT TRAN
RETURN 0
GO