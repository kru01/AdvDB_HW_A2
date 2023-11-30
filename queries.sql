/* 21HTTT1 - 21CLC1.CSDLNC.03
 * 21127004 - Trần Nguyễn An Phong
 * 21127135 - Diệp Hữu Phúc
 * 21127296 - Đặng Hà Huy
 * 21127315 - Nguyễn Gia Khánh
 * 21127712 - Lê Quang Trường
 */
USE [NC03_ORDERENTRY]
GO

/* 1. Đối với một đơn đặt hàng của khách hàng cụ thể, 
 * tổng chi phí đơn đặt hàng là bao nhiêu?
 */
SELECT CUSTOMER_IDENTIFIER, ORDER_NUMBER, TOTAL_COST FROM ORDERS
WHERE CUSTOMER_IDENTIFIER = 'CS00001' AND ORDER_NUMBER = 'OD00001'
GO

/* 2. Đối với một sản phẩm quảng cáo (Advertised_Item) cụ thể,
 * giá thấp nhất mà nhà cung cấp hiện đang cung cấp là bao nhiêu?
 */
SELECT ITEM_NUMBER, LOWEST_PURCHASE_PRICE FROM ADVERTISED_ITEM
WHERE ITEM_NUMBER = 'IT00001'
GO

/* 3. Khi thông tin khách hàng được truy xuất,
 * hãy bao gồm tất cả số thẻ tín dụng của họ.
 */
SELECT CS.*, CD.* FROM CUSTOMER CS, CREDIT_CARD CD
WHERE CS.CUSTOMER_IDENTIFIER = 'CS00001'
    AND CS.CUSTOMER_IDENTIFIER = CD.CUSTOMER_IDENTIFIER
GO

/* 4. Giả định bổ sung thuộc tính PreferredOption vào bảng Credit_Card
 * để quản lý thẻ tín dụng yêu thích của khách hàng.
 * Khi thông tin khách hàng truy xuất,
 * cho biết thông tin thẻ tín dụng sử dụng yêu thích của họ.
 */
SELECT CS.*, CD.* FROM CUSTOMER CS, CREDIT_CARD CD
WHERE CS.CUSTOMER_IDENTIFIER = 'CS00001'
    AND CS.PREFERRED_CARD = CD.CUSTOMER_CREDIT_CARD_NUMBER
GO

/* 5. Cho biết thông tin khách hàng và
 * số lần sử dụng trên mỗi thẻ tín dụng của họ.
 */
SELECT CS.*, CD.CUSTOMER_CREDIT_CARD_NUMBER, CD.USAGE_COUNT
    FROM CUSTOMER CS, CREDIT_CARD CD
WHERE CS.CUSTOMER_IDENTIFIER = 'CS00001'
    AND CS.CUSTOMER_IDENTIFIER = CD.CUSTOMER_IDENTIFIER
GO