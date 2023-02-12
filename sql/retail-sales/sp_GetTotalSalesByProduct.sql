CREATE PROCEDURE sp_GetTotalSalesByProduct
    @ProductID bigint
AS
    SELECT SUM(s.Quantity) FROM Sales as s
    WHERE s.ProductID = @ProductID
GO