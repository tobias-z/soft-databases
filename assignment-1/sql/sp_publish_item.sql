CREATE OR ALTER PROCEDURE [dbo].[sp_publish_item]
    @publisher_id BIGINT,
    @title VARCHAR(50),
    @number_of_pages BIGINT,
    @item_type VARCHAR(30),
    @ISBN VARCHAR(20) = NULL,
    @author_id BIGINT = NULL
AS
    IF NOT EXISTS (SELECT 1 FROM publisher as p WHERE p.publisher_id = @publisher_id)
    BEGIN
        RAISERROR('No publisher was found with id: %d', 18, 1, @publisher_id);
        RETURN -1;
    END

    BEGIN TRY
        BEGIN TRANSACTION publish_item;

        DECLARE @item_id bigint;

        INSERT INTO published_item (publisher_id, title, number_of_pages, [availability], publication_date, item_type)
        VALUES (@publisher_id, @title, @number_of_pages, 1, GETDATE(), @item_type)
        SET @item_id = @@IDENTITY;

        IF (@item_type = 'book')
        BEGIN
            INSERT INTO book (book_id, ISBN, author_id)
            VALUES (@item_id, @ISBN, @author_id);
        END
        ELSE IF (@item_type = 'magazine')
        BEGIN
            INSERT INTO magazine (magazine_id)
            VALUES (@item_id);
        END
        ELSE
        BEGIN
            DECLARE @error_message VARCHAR(100);
            SET @error_message = 'The item_type: ' + @item_type + ' is not a known item type';
            THROW 51000, @error_message, 1;
        END

        COMMIT TRANSACTION publish_item;
    END TRY
    BEGIN  CATCH
        ROLLBACK TRANSACTION publish_item;
        THROW;
    END CATCH
GO
