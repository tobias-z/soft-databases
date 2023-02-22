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

DECLARE @out_item_id BIGINT;

EXEC sp_publish_item
    @publisher_id = 1,
    @title = 'Bob Builds',
    @number_of_pages = 150,
    @item_type = 'book',
    @ISBN = '0-5599-9135-5',
    @author_id = 1,
    @out_item_id = @out_item_id OUTPUT;

EXEC sp_ensure_genre_link
    @genre_name = 'Building',
    @published_item_id = @out_item_id;

EXEC sp_ensure_genre_link
    @genre_name = 'Fication',
    @published_item_id = @out_item_id;

EXEC sp_ensure_genre_link
    @genre_name = 'Fantacy',
    @published_item_id = @out_item_id;

-- Loan the book
EXEC sp_upsert_item
    @item_id = @out_item_id,
    @availability = 0,
    @publisher_id = 1,
    @title = 'Bob Builds',
    @number_of_pages = 150,
    @item_type = 'book',
    @ISBN = '0-5599-9135-5',
    @author_id = 1,
    @out_item_id = @out_item_id OUTPUT

EXEC sp_upsert_item
    @availability = 1,
    @publisher_id = 1,
    @title = 'How to build',
    @number_of_pages = 20,
    @item_type = 'magazine',
    @ISBN = '0-5599-9135-6',
    @author_id = 1,
    @out_item_id = @out_item_id OUTPUT

EXEC sp_ensure_genre_link
    @genre_name = 'Building',
    @published_item_id = @out_item_id;

EXEC sp_ensure_genre_link
    @genre_name = 'Work',
    @published_item_id = @out_item_id;

EXEC sp_find_items

EXEC sp_find_items @item_type = 'book'

EXEC sp_find_items @item_type = 'magazine';
