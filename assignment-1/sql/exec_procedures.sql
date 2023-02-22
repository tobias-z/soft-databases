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
