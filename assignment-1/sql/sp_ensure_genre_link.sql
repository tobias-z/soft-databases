CREATE OR ALTER PROCEDURE [dbo].[sp_ensure_genre_link]
    @genre_name VARCHAR(40),
    @published_item_id BIGINT
AS
    IF EXISTS (SELECT 1 FROM published_item_genre pg WHERE pg.genre_name = @genre_name AND pg.published_item_id = @published_item_id)
    BEGIN
        -- Link already exists
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION ensure_genre_link;

        IF NOT EXISTS (SELECT 1 FROM genre as g WHERE g.name = @genre_name)
        BEGIN
            INSERT INTO genre ([name], [description])
            VALUES (@genre_name, 'No description provided')
        END

        INSERT INTO published_item_genre (genre_name, published_item_id)
        VALUES (@genre_name, @published_item_id)

        COMMIT TRANSACTION ensure_genre_link;
    END TRY
    BEGIN  CATCH
        ROLLBACK TRANSACTION ensure_genre_link;
        THROW;
    END CATCH
GO
