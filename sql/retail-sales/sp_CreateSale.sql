CREATE OR ALTER PROCEDURE sp_CreateSale
    @SaleDate DATETIME,
    @CustomerID bigint,
    @ProductID bigint,
    @Quantity int
AS
    BEGIN TRY
        BEGIN TRANSACTION create_sale;

        INSERT INTO Sales (SaleDate, CustomerID, ProductID, Quantity)
        VALUES (@SaleDate, @CustomerID, @ProductID, @Quantity)

        COMMIT TRANSACTION create_sale;
    END TRY
    BEGIN  CATCH
        PRINT 'Invalid ProductID: ' + CAST(@ProductID AS VARCHAR) + ' or CustomerID: ' + CAST(@CustomerID AS VARCHAR);
        ROLLBACK TRANSACTION create_sale;
    END CATCH
GO