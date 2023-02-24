-- This allows us find all items by a specific publisher much quicker
CREATE NONCLUSTERED INDEX [Index_published_item_2]
    ON [dbo].[published_item]([publisher_id] ASC);

-- This allows us to find all the newest published items much quicker
-- A better solution might be to partiotion on the publishing date
CREATE NONCLUSTERED INDEX [Index_published_item_1]
    ON [dbo].[published_item]([publication_date] ASC);
