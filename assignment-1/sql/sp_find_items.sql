-- Given no item_type, will return all columns
-- Given specific item type, it will return columns relevant to the item type requested.
CREATE OR ALTER PROCEDURE [dbo].[sp_find_items]
    @item_type VARCHAR(30) = null
AS
    IF @item_type IS NULL
    BEGIN
        SELECT * FROM published_item as pi
        LEFT JOIN book as book ON pi.item_type = 'book' AND book.book_id = pi.published_item_id
        LEFT JOIN magazine as magazine ON pi.item_type = 'magazine' AND magazine.magazine_id = pi.published_item_id;
        RETURN;
    END

    IF (@item_type = 'book')
    BEGIN
        SELECT * FROM published_item as pi
        LEFT JOIN book as book ON pi.item_type = 'book' AND book.book_id = pi.published_item_id
        WHERE pi.item_type = 'book';
    END
    ELSE IF (@item_type = 'magazine')
    BEGIN
        SELECT * FROM published_item as pi
        LEFT JOIN magazine as magazine ON pi.item_type = 'magazine' AND magazine.magazine_id = pi.published_item_id
        WHERE pi.item_type = 'magazine';
    END
    ELSE
    BEGIN
        DECLARE @error_message VARCHAR(100);
        SET @error_message = 'The item_type: ' + @item_type + ' is not a known item type';
        THROW 51000, @error_message, 1;
    END
GO
