-- Create a new database called 'RetailSales'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'RetailSales'
)
CREATE DATABASE RetailSales
GO