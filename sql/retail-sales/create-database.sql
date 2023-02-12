CREATE TABLE [dbo].[Customers] (
    [CustomerID] BIGINT       IDENTITY (1, 1) NOT NULL,
    [FirstName]  VARCHAR (30) NOT NULL,
    [LastName]   VARCHAR (30) NOT NULL,
    [Email]      VARCHAR (50) NULL,
    [Phone]      INT          NULL,
    CONSTRAINT [PK_Customers] PRIMARY KEY CLUSTERED ([CustomerID] ASC)
);

CREATE TABLE [dbo].[Products] (
    [ProductID]   BIGINT       IDENTITY (1, 1) NOT NULL,
    [ProductName] VARCHAR (50) NOT NULL,
    [Description] TEXT         NULL,
    [Price]       MONEY        NOT NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([ProductID] ASC)
);

CREATE TABLE [dbo].[Sales] (
    [SaleID]     BIGINT   IDENTITY (1, 1) NOT NULL,
    [SaleDate]   DATETIME NOT NULL,
    [CustomerID] BIGINT   NOT NULL,
    [ProductID]  BIGINT   NOT NULL,
    [Quantity]   INT      NOT NULL,
    CONSTRAINT [PK_Sales] PRIMARY KEY CLUSTERED ([SaleID] ASC),
    CONSTRAINT [FK_Sales_Customers] FOREIGN KEY ([CustomerID]) REFERENCES [dbo].[Customers] ([CustomerID]),
    CONSTRAINT [FK_Sales_Products] FOREIGN KEY ([ProductID]) REFERENCES [dbo].[Products] ([ProductID])
);
