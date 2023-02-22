EXEC sp_publish_item
    @publisher_id = 1,
    @title = 'Bob Builds',
    @number_of_pages = 150,
    @item_type = 'book',
    @ISBN = '0-5599-9135-5',
    @author_id = 1;

EXEC sp_upsert_item
    @item_id = 7,
    @availability = 0,
    @publisher_id = 1,
    @title = 'Bob Builds',
    @number_of_pages = 150,
    @item_type = 'book',
    @ISBN = '0-5599-9135-5',
    @author_id = 1;

-- Will fail because of our error handling of item types
EXEC sp_upsert_item
    @availability = 1,
    @publisher_id = 1,
    @title = 'Some magazine title',
    @number_of_pages = 30,
    @item_type = 'something',
    @ISBN = '0-5599-9135-6',
    @author_id = 1;
