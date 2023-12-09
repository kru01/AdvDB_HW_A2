/* 21HTTT1 - 21CLC1.CSDLNC.03
 * 21127004 - Trần Nguyễn An Phong
 * 21127135 - Diệp Hữu Phúc
 * 21127296 - Đặng Hà Huy
 * 21127315 - Nguyễn Gia Khánh
 * 21127712 - Lê Quang Trường
 */
USE [NC03_ORDERENTRY]
GO

CREATE OR ALTER PROC USP_CUSTOMER_INS
    @CUSTOMER_TELEPHONE_NUMBER VARCHAR(11),
    @CUSTOMER_NAME NVARCHAR(100),
    @CUSTOMER_STREET_ADDRESS NVARCHAR(100),
    @CUSTOMER_CITY NVARCHAR(100),
    @CUSTOMER_STATE NVARCHAR(100),
    @CUSTOMER_ZIP_CODE VARCHAR(10),
    @CUSTOMER_CREDIT_RATING INT,
    @CUSTOMER_IDENTIFIER CHAR(7) = NULL OUTPUT
AS BEGIN TRAN
    IF @CUSTOMER_CREDIT_RATING < 0 BEGIN
        RAISERROR('INVALID CREDIT RATING', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    SELECT @CUSTOMER_IDENTIFIER = CUSTOMER_IDENTIFIER FROM CUSTOMER
    WHERE CUSTOMER_IDENTIFIER = (SELECT MAX(CUSTOMER_IDENTIFIER)
        FROM CUSTOMER)

    SET @CUSTOMER_IDENTIFIER = dbo.F_MAKE_ID('CS', @CUSTOMER_IDENTIFIER)

    INSERT INTO CUSTOMER
    VALUES (@CUSTOMER_IDENTIFIER, @CUSTOMER_TELEPHONE_NUMBER, @CUSTOMER_NAME,
        @CUSTOMER_STREET_ADDRESS, @CUSTOMER_CITY, @CUSTOMER_STATE,
        @CUSTOMER_ZIP_CODE, @CUSTOMER_CREDIT_RATING, NULL)
COMMIT TRAN
RETURN 0
GO

CREATE OR ALTER PROC USP_CUSTOMER_UPD_PREFERRED_CARD
    @CUSTOMER_IDENTIFIER CHAR(7),
    @PREFERRED_CARD CHAR(7)
AS BEGIN TRAN
    IF NOT EXISTS (SELECT CUSTOMER_IDENTIFIER FROM CUSTOMER
        WHERE CUSTOMER_IDENTIFIER = @CUSTOMER_IDENTIFIER) BEGIN
        RAISERROR('INVALID CUSTOMER IDENTIFIER', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    IF NOT EXISTS (SELECT CUSTOMER_CREDIT_CARD_NUMBER FROM CREDIT_CARD
        WHERE CUSTOMER_CREDIT_CARD_NUMBER = @PREFERRED_CARD) BEGIN
        RAISERROR('INVALID CUSTOMER CREDIT CARD NUMBER', 16, 1)
        ROLLBACK TRAN
        RETURN -2
    END

    UPDATE CUSTOMER SET PREFERRED_CARD = @PREFERRED_CARD
    WHERE CUSTOMER_IDENTIFIER = @CUSTOMER_IDENTIFIER

    UPDATE CREDIT_CARD SET PREFERRED_OPTION = 0
    WHERE CUSTOMER_IDENTIFIER = @CUSTOMER_IDENTIFIER AND PREFERRED_OPTION = 1

    UPDATE CREDIT_CARD SET PREFERRED_OPTION = 1
    WHERE CUSTOMER_CREDIT_CARD_NUMBER = @PREFERRED_CARD
COMMIT TRAN
RETURN 0
GO