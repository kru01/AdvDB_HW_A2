/* 21HTTT1 - 21CLC1.CSDLNC.03
 * 21127004 - Trần Nguyễn An Phong
 * 21127135 - Diệp Hữu Phúc
 * 21127296 - Đặng Hà Huy
 * 21127315 - Nguyễn Gia Khánh
 * 21127712 - Lê Quang Trường
 */
USE [NC03_ORDERENTRY]
GO

CREATE OR ALTER PROC USP_ORDERED_ITEM_INS
    @ORDER_NUMBER CHAR(7),
    @ITEM_NUMBER CHAR(7),
    @QUANTITY_ORDERED INT,
    @SELLING_PRICE INT,
    @SHIPPING_DATE DATE
AS BEGIN TRAN
    IF NOT EXISTS (SELECT ORDER_NUMBER FROM ORDERS
        WHERE ORDER_NUMBER = @ORDER_NUMBER) BEGIN
        RAISERROR('INVALID ORDER NUMBER', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    IF NOT EXISTS (SELECT ITEM_NUMBER FROM ADVERTISED_ITEM
        WHERE ITEM_NUMBER = @ITEM_NUMBER) BEGIN
        RAISERROR('INVALID ITEM NUMBER', 16, 1)
        ROLLBACK TRAN
        RETURN -2
    END

    IF @QUANTITY_ORDERED <= 0 BEGIN
        RAISERROR('INVALID QUANTITY ORDERED', 16, 1)
        ROLLBACK TRAN
        RETURN -3
    END

    IF @SELLING_PRICE < 0 BEGIN
        RAISERROR('INVALID SELLING PRICE', 16, 1)
        ROLLBACK TRAN
        RETURN -4
    END

    INSERT INTO ORDERED_ITEM
    VALUES (@ORDER_NUMBER, @ITEM_NUMBER, @QUANTITY_ORDERED, @SELLING_PRICE,
        @SHIPPING_DATE)
    
    UPDATE ORDERS SET TOTAL_COST += @QUANTITY_ORDERED * @SELLING_PRICE
    WHERE ORDER_NUMBER = @ORDER_NUMBER
COMMIT TRAN
RETURN 0
GO

CREATE OR ALTER PROC USP_ORDERED_ITEM_UPD
    @ORDER_NUMBER CHAR(7),
    @ITEM_NUMBER CHAR(7),
    @QUANTITY_ORDERED INT,
    @SELLING_PRICE INT,
    @SHIPPING_DATE DATE
AS BEGIN TRAN
    DECLARE @OLD_QUANTITY_ORDERED INT, @OLD_SELLING_PRICE INT
    SELECT @OLD_QUANTITY_ORDERED = QUANTITY_ORDERED,
        @OLD_SELLING_PRICE = SELLING_PRICE
    FROM ORDERED_ITEM WHERE ORDER_NUMBER = @ORDER_NUMBER
        AND ITEM_NUMBER = @ITEM_NUMBER

    IF @OLD_QUANTITY_ORDERED IS NULL OR @OLD_SELLING_PRICE IS NULL BEGIN
        RAISERROR('INVALID ORDERED ITEM', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    IF @QUANTITY_ORDERED <= 0 BEGIN
        RAISERROR('INVALID QUANTITY ORDERED', 16, 1)
        ROLLBACK TRAN
        RETURN -2
    END

    IF @SELLING_PRICE < 0 BEGIN
        RAISERROR('INVALID SELLING PRICE', 16, 1)
        ROLLBACK TRAN
        RETURN -3
    END

    UPDATE ORDERED_ITEM SET QUANTITY_ORDERED = @QUANTITY_ORDERED,
        SELLING_PRICE = @SELLING_PRICE, SHIPPING_DATE = @SHIPPING_DATE
    WHERE ORDER_NUMBER = @ORDER_NUMBER AND ITEM_NUMBER = @ITEM_NUMBER

    UPDATE ORDERS SET TOTAL_COST += @QUANTITY_ORDERED * @SELLING_PRICE -
        @OLD_QUANTITY_ORDERED * @OLD_SELLING_PRICE
    WHERE ORDER_NUMBER = @ORDER_NUMBER
COMMIT TRAN
RETURN 0
GO

CREATE OR ALTER PROC USP_ORDERED_ITEM_DEL
    @ORDER_NUMBER CHAR(7),
    @ITEM_NUMBER CHAR(7)
AS BEGIN TRAN
    DECLARE @OLD_QUANTITY_ORDERED INT, @OLD_SELLING_PRICE INT
    SELECT @OLD_QUANTITY_ORDERED = QUANTITY_ORDERED,
        @OLD_SELLING_PRICE = SELLING_PRICE
    FROM ORDERED_ITEM WHERE ORDER_NUMBER = @ORDER_NUMBER
        AND ITEM_NUMBER = @ITEM_NUMBER

    IF @OLD_QUANTITY_ORDERED IS NULL OR @OLD_SELLING_PRICE IS NULL BEGIN
        RAISERROR('INVALID ORDERED ITEM', 16, 1)
        ROLLBACK TRAN
        RETURN -1
    END

    DELETE FROM ORDERED_ITEM WHERE ORDER_NUMBER = @ORDER_NUMBER
        AND ITEM_NUMBER = @ITEM_NUMBER

    UPDATE ORDERS
    SET TOTAL_COST -= @OLD_QUANTITY_ORDERED * @OLD_SELLING_PRICE
    WHERE ORDER_NUMBER = @ORDER_NUMBER
COMMIT TRAN
RETURN 0
GO