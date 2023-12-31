/* 21HTTT1 - 21CLC1.CSDLNC.03
 * 21127004 - Trần Nguyễn An Phong
 * 21127135 - Diệp Hữu Phúc
 * 21127296 - Đặng Hà Huy
 * 21127315 - Nguyễn Gia Khánh
 * 21127712 - Lê Quang Trường
 */
USE [NC03_ORDERENTRY]
GO

CREATE OR ALTER PROC USP_SUPPLIER_INS
    @SUPPLIER_NAME NVARCHAR(100),
    @SUPPLIER_STREET_ADDRESS NVARCHAR(100),
    @SUPPLIER_CITY NVARCHAR(100),
    @SUPPLIER_STATE NVARCHAR(100),
    @SUPPLIER_ZIP_CODE VARCHAR(10),
    @SUPPLIER_ID CHAR(7) = NULL OUTPUT
AS BEGIN TRAN
    SELECT @SUPPLIER_ID = SUPPLIER_ID FROM SUPPLIER
    WHERE SUPPLIER_ID = (SELECT MAX(SUPPLIER_ID) FROM SUPPLIER)

    SET @SUPPLIER_ID = dbo.F_MAKE_ID('SP', @SUPPLIER_ID)

    INSERT INTO SUPPLIER
    VALUES (@SUPPLIER_ID, @SUPPLIER_NAME, @SUPPLIER_STREET_ADDRESS,
        @SUPPLIER_CITY, @SUPPLIER_STATE, @SUPPLIER_ZIP_CODE)
COMMIT TRAN
RETURN 0
GO