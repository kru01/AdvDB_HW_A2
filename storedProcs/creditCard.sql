/* 21HTTT1 - 21CLC1.CSDLNC.03
 * 21127004 - Trần Nguyễn An Phong
 * 21127135 - Diệp Hữu Phúc
 * 21127296 - Đặng Hà Huy
 * 21127315 - Nguyễn Gia Khánh
 * 21127712 - Lê Quang Trường
 */
USE [NC03_ORDERENTRY]
GO

CREATE OR ALTER PROC USP_CREDIT_CARD_INS
    @CUSTOMER_CREDIT_CARD_NAME NVARCHAR(100),
    @PREFERRED_OPTION BIT,
    @CUSTOMER_IDENTIFIER CHAR(7),
    @CUSTOMER_CREDIT_CARD_NUMBER VARCHAR(20) = NULL OUTPUT
AS BEGIN TRAN
    IF NOT EXISTS (SELECT * FROM CUSTOMER
        WHERE CUSTOMER_IDENTIFIER = @CUSTOMER_IDENTIFIER) BEGIN
        RAISERROR('INVALID CUSTOMER IDENTIFIER', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    IF @PREFERRED_OPTION = 1 AND EXISTS (SELECT * FROM CREDIT_CARD
        WHERE CUSTOMER_IDENTIFIER = @CUSTOMER_IDENTIFIER
            AND PREFERRED_OPTION = 1) BEGIN
        RAISERROR('THERE ALREADY EXISTS A PREFERRED CARD', 16, 1)
        ROLLBACK TRAN
        RETURN -2
    END

    SELECT @CUSTOMER_CREDIT_CARD_NUMBER = CUSTOMER_CREDIT_CARD_NUMBER
    FROM CREDIT_CARD WHERE CUSTOMER_CREDIT_CARD_NUMBER =
        (SELECT MAX(CUSTOMER_CREDIT_CARD_NUMBER) FROM CREDIT_CARD)

    SET @CUSTOMER_CREDIT_CARD_NUMBER =
        dbo.F_MAKE_ID('CD', @CUSTOMER_CREDIT_CARD_NUMBER)

    INSERT INTO CREDIT_CARD
    VALUES (@CUSTOMER_CREDIT_CARD_NUMBER, @CUSTOMER_CREDIT_CARD_NAME,
        @PREFERRED_OPTION, 0, @CUSTOMER_IDENTIFIER)

    IF @PREFERRED_OPTION = 1
        UPDATE CUSTOMER SET PREFERRED_CARD = @CUSTOMER_CREDIT_CARD_NUMBER
        WHERE CUSTOMER_IDENTIFIER = @CUSTOMER_IDENTIFIER
COMMIT TRAN
RETURN 0
GO