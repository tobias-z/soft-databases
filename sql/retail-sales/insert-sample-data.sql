DECLARE @CustomerID bigint;

INSERT INTO dbo.Customers (Email, FirstName, LastName, Phone)
VALUES ('bob@thebuilder.com', 'bob', 'thebuilder', 12345678);
SET @CustomerID = @@IDENTITY

DECLARE @ProductId bigint;
INSERT INTO dbo.Products (ProductName, [Description], Price)
VALUES ('Bob helps', 'he can do anything', 10)
SET @ProductId = @@IDENTITY;

INSERT INTO dbo.Sales (SaleDate, Quantity, CustomerID, ProductID)
VALUES (
    GETDATE(),
    1,
    @CustomerID,
    @ProductId
)