CREATE OR ALTER PROCEDURE [dbo].[sp_upsert_item]
    @item_id BIGINT = null,
    @publisher_id BIGINT,
    @title VARCHAR(50),
    @number_of_pages BIGINT,
    @item_type VARCHAR(30),
    @availability BIT,
    @ISBN VARCHAR(20) = NULL,
    @author_id BIGINT = NULL,
    @out_item_id BIGINT OUTPUT
AS
    -- Because we are doing a relativly large amount of operations in this sp, this likely makes the sp faster.
    SET NOCOUNT ON;

    IF NOT EXISTS (SELECT 1 FROM publisher as p WHERE p.publisher_id = @publisher_id)
    BEGIN
        DECLARE @pub_id VARCHAR(100)
        SET @pub_id = CAST(@publisher_id AS VARCHAR)
        RAISERROR('No publisher was found with id: %s', 18, 1, @pub_id);
        RETURN -1;
    END

    DECLARE @is_update BIT = 1;
    -- Because IS NULL is expensive we only do it ones.
    IF @item_id IS NULL
    BEGIN
        SET @is_update = 0;
    END

    IF @is_update = 1 AND NOT EXISTS (SELECT 1 FROM published_item pi WHERE pi.published_item_id = @item_id)
    BEGIN
        DECLARE @pub_item_id VARCHAR(100)
        SET @pub_item_id = CAST(@item_id AS VARCHAR)
        RAISERROR('Unable to update item with id: %s, since it does not exist', 18, 1, @pub_item_id);
        RETURN -1;
    END

    BEGIN TRY
        BEGIN TRANSACTION upsert_item;

        IF @is_update = 0
        BEGIN
            INSERT INTO published_item (publisher_id, title, number_of_pages, [availability], publication_date, item_type)
            VALUES (@publisher_id, @title, @number_of_pages, @availability, GETDATE(), @item_type)
            SET @item_id = @@IDENTITY;
        END
        ELSE
        BEGIN
            UPDATE published_item
            SET [availability] = @availability, number_of_pages = @number_of_pages, publisher_id = @publisher_id, title = @title
            WHERE published_item_id = @item_id
        END

        IF (@item_type = 'book')
        BEGIN
            IF @is_update = 0
            BEGIN
                INSERT INTO book (book_id, ISBN, author_id)
                VALUES (@item_id, @ISBN, @author_id);
            END
            ELSE
            BEGIN
                UPDATE book
                SET author_id = @author_id, ISBN = @ISBN
                WHERE book_id = @item_id
            END
        END
        ELSE IF (@item_type = 'magazine')
        BEGIN
            IF @is_update = 0
            BEGIN
                INSERT INTO magazine (magazine_id)
                VALUES (@item_id);
            END
            -- Ignore update for now because magazines have no actual data 😃
        END
        ELSE
        BEGIN
            DECLARE @error_message VARCHAR(100);
            SET @error_message = 'The item_type: ' + @item_type + ' is not a known item type';
            THROW 51000, @error_message, 1;
        END

        SET @out_item_id = @item_id;

        COMMIT TRANSACTION upsert_item;
    END TRY
    BEGIN  CATCH
        ROLLBACK TRANSACTION upsert_item;
        THROW;
    END CATCH
GO
