CREATE OR ALTER PROCEDURE sp_delete_item
    @item_id BIGINT
AS
    DECLARE @item_type VARCHAR;

    SELECT @item_type = pi.item_type
    FROM published_item as pi
    WHERE pi.published_item_id = @item_id;

    BEGIN TRY
        BEGIN TRANSACTION delete_item;

        IF (@item_type = 'book')
        BEGIN
            DELETE FROM book
            WHERE book_id = @item_id;
        END
        ELSE IF (@item_type = 'magazine')
        BEGIN
            DELETE FROM magazine
            WHERE magazine_id = @item_id;
        END
        ELSE
        BEGIN
            RAISERROR('An unknown item_type: %s was found in the database.', 14, 1, @item_type);
        END

        DELETE FROM published_item
        WHERE published_item_id = @item_id;

        COMMIT TRANSACTION delete_item;
    END TRY
    BEGIN  CATCH
        ROLLBACK TRANSACTION delete_item;
        THROW;
    END CATCH
GO
