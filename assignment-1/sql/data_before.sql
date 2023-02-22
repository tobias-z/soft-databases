DELETE FROM publisher;
DELETE FROM book;
DELETE FROM magazine;
DELETE FROM author;
DELETE FROM dbo.address;
DELETE FROM published_item_genre;
DELETE FROM genre;
DELETE FROM published_item;

-- For testing purposes this ensures that we always have the same id's
DBCC CHECKIDENT ('[publisher]', RESEED, 0);
DBCC CHECKIDENT ('[author]', RESEED, 0);
DBCC CHECKIDENT ('[address]', RESEED, 0);
DBCC CHECKIDENT ('[published_item]', RESEED, 0);
GO

DECLARE @publisher_address_id BIGINT;
DECLARE @author_address_id BIGINT;

INSERT INTO dbo.address (city_name, postal_code, [address])
VALUES ('Lyngby', 2800, 'Something 30')
SET @publisher_address_id = @@IDENTITY;

INSERT INTO publisher ([name], address_id)
VALUES ('Builders', @publisher_address_id);

INSERT INTO dbo.address (city_name, postal_code, [address])
VALUES ('Lyngby', 2800, 'Something else')
SET @author_address_id = @@IDENTITY;

INSERT INTO author ([name], address_id)
VALUES ('Bob the Builder', @author_address_id);
