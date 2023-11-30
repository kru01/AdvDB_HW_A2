/* 21HTTT1 - 21CLC1.CSDLNC.03
 * 21127004 - Trần Nguyễn An Phong
 * 21127135 - Diệp Hữu Phúc
 * 21127296 - Đặng Hà Huy
 * 21127315 - Nguyễn Gia Khánh
 * 21127712 - Lê Quang Trường
 */
USE [NC03_ORDERENTRY]
GO

CREATE OR ALTER PROC USP_RESTOCK_ITEM_INS
    @SUPPLIER_ID CHAR(7),
    @ITEM_NUMBER CHAR(7),
    @PURCHASE_PRICE INT
AS BEGIN TRAN
    IF NOT EXISTS (SELECT * FROM SUPPLIER
        WHERE SUPPLIER_ID = @SUPPLIER_ID) BEGIN
        RAISERROR('INVALID SUPPLIER ID', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    DECLARE @LOWEST_PURCHASE_PRICE INT
    SELECT @LOWEST_PURCHASE_PRICE = LOWEST_PURCHASE_PRICE
    FROM ADVERTISED_ITEM WHERE ITEM_NUMBER = @ITEM_NUMBER

    IF @LOWEST_PURCHASE_PRICE IS NULL BEGIN
        RAISERROR('INVALID ITEM NUMBER', 16, 1)
        ROLLBACK TRAN
        RETURN -2
    END

    IF @PURCHASE_PRICE IS NULL OR @PURCHASE_PRICE < 0 BEGIN
        RAISERROR('INVALID PURCHASE PRICE', 16, 1)
        ROLLBACK TRAN
        RETURN -3
    END

    INSERT INTO RESTOCK_ITEM
    VALUES (@SUPPLIER_ID, @ITEM_NUMBER, @PURCHASE_PRICE)

    IF @PURCHASE_PRICE < @LOWEST_PURCHASE_PRICE
        UPDATE ADVERTISED_ITEM SET LOWEST_PURCHASE_PRICE = @PURCHASE_PRICE
        WHERE ITEM_NUMBER = @ITEM_NUMBER
COMMIT TRAN
RETURN 0
GO

CREATE OR ALTER PROC USP_RESTOCK_ITEM_UPD
    @SUPPLIER_ID CHAR(7),
    @ITEM_NUMBER CHAR(7),
    @PURCHASE_PRICE INT
AS BEGIN TRAN
    IF NOT EXISTS (SELECT * FROM RESTOCK_ITEM
        WHERE SUPPLIER_ID = @SUPPLIER_ID AND ITEM_NUMBER = @ITEM_NUMBER) BEGIN
        RAISERROR('INVALID RESTOCK ITEM', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    DECLARE @LOWEST_PURCHASE_PRICE INT
    SELECT @LOWEST_PURCHASE_PRICE = LOWEST_PURCHASE_PRICE
    FROM ADVERTISED_ITEM WHERE ITEM_NUMBER = @ITEM_NUMBER

    IF @LOWEST_PURCHASE_PRICE IS NULL BEGIN
        RAISERROR('INVALID ITEM NUMBER', 16, 1)
        ROLLBACK TRAN
        RETURN -2
    END

    IF @PURCHASE_PRICE < 0 BEGIN
        RAISERROR('INVALID PURCHASE PRICE', 16, 1)
        ROLLBACK TRAN
        RETURN -3
    END

    UPDATE RESTOCK_ITEM SET PURCHASE_PRICE = @PURCHASE_PRICE
    WHERE SUPPLIER_ID = @SUPPLIER_ID AND ITEM_NUMBER = @ITEM_NUMBER

    IF @PURCHASE_PRICE < @LOWEST_PURCHASE_PRICE
        UPDATE ADVERTISED_ITEM SET LOWEST_PURCHASE_PRICE = @PURCHASE_PRICE
        WHERE ITEM_NUMBER = @ITEM_NUMBER
COMMIT TRAN
RETURN 0
GO

CREATE OR ALTER PROC USP_RESTOCK_ITEM_DEL
    @SUPPLIER_ID CHAR(7),
    @ITEM_NUMBER CHAR(7)
AS BEGIN TRAN
    IF NOT EXISTS (SELECT * FROM RESTOCK_ITEM
        WHERE SUPPLIER_ID = @SUPPLIER_ID AND ITEM_NUMBER = @ITEM_NUMBER) BEGIN
        RAISERROR('INVALID RESTOCK ITEM', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    DECLARE @LOWEST_PURCHASE_PRICE INT
    SELECT @LOWEST_PURCHASE_PRICE = LOWEST_PURCHASE_PRICE
    FROM ADVERTISED_ITEM WHERE ITEM_NUMBER = @ITEM_NUMBER

    IF @LOWEST_PURCHASE_PRICE IS NULL BEGIN
        RAISERROR('INVALID ITEM NUMBER', 16, 1)
        ROLLBACK TRAN
        RETURN -2
    END

    DELETE FROM RESTOCK_ITEM WHERE SUPPLIER_ID = @SUPPLIER_ID
        AND ITEM_NUMBER = @ITEM_NUMBER

    IF NOT EXISTS (SELECT * FROM RESTOCK_ITEM
        WHERE PURCHASE_PRICE = @LOWEST_PURCHASE_PRICE) BEGIN
        SELECT @LOWEST_PURCHASE_PRICE = MIN(PURCHASE_PRICE)
        FROM RESTOCK_ITEM WHERE ITEM_NUMBER = @ITEM_NUMBER
    
        UPDATE ADVERTISED_ITEM
        SET LOWEST_PURCHASE_PRICE = @LOWEST_PURCHASE_PRICE
        WHERE ITEM_NUMBER = @ITEM_NUMBER
    END
COMMIT TRAN
RETURN 0
GO