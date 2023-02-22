CREATE TABLE [dbo].[address] (
    [address_id]  BIGINT       IDENTITY (1, 1) NOT NULL,
    [city_name]   VARCHAR (40) NOT NULL,
    [postal_code] INT          NOT NULL,
    [address]     VARCHAR (60) NOT NULL,
    CONSTRAINT [PK_address] PRIMARY KEY CLUSTERED ([address_id] ASC)
);

CREATE TABLE [dbo].[author] (
    [author_id]  BIGINT       IDENTITY (1, 1) NOT NULL,
    [name]       VARCHAR (40) NOT NULL,
    [address_id] BIGINT       NOT NULL,
    CONSTRAINT [PK_author] PRIMARY KEY CLUSTERED ([author_id] ASC),
    CONSTRAINT [FK_author_address] FOREIGN KEY ([address_id]) REFERENCES [dbo].[address] ([address_id])
);

CREATE TABLE [dbo].[patron] (
    [patron_id]     BIGINT       IDENTITY (1, 1) NOT NULL,
    [first_name]    VARCHAR (40) NOT NULL,
    [last_name]     VARCHAR (40) NOT NULL,
    [email]         VARCHAR (50) NOT NULL,
    [phone_number]  INT          NOT NULL,
    [date_of_birth] DATE         NOT NULL,
    [address_id]    BIGINT       NOT NULL,
    CONSTRAINT [PK_Patron] PRIMARY KEY CLUSTERED ([patron_id] ASC),
    CONSTRAINT [FK_patron_address] FOREIGN KEY ([address_id]) REFERENCES [dbo].[address] ([address_id])
);

CREATE TABLE [dbo].[publisher] (
    [publisher_id] BIGINT       IDENTITY (1, 1) NOT NULL,
    [name]         VARCHAR (40) NOT NULL,
    [address_id]   BIGINT       NOT NULL,
    CONSTRAINT [PK_publisher] PRIMARY KEY CLUSTERED ([publisher_id] ASC),
    CONSTRAINT [FK_publisher_address] FOREIGN KEY ([address_id]) REFERENCES [dbo].[address] ([address_id])
);

CREATE TABLE [dbo].[published_item] (
    [published_item_id] BIGINT       IDENTITY (1, 1) NOT NULL,
    [publisher_id]      BIGINT       NOT NULL,
    [title]             VARCHAR (50) NOT NULL,
    [publication_date]  DATE         NOT NULL,
    [number_of_pages]   INT          NOT NULL,
    [availability]      TINYINT      NOT NULL,
    [item_type]         VARCHAR (20) NOT NULL,
    [item_id]           BIGINT       NOT NULL,
    CONSTRAINT [PK_published_item] PRIMARY KEY CLUSTERED ([published_item_id] ASC)
);

CREATE TABLE [dbo].[genre] (
    [genre_id]    BIGINT       IDENTITY (1, 1) NOT NULL,
    [name]        VARCHAR (40) NOT NULL,
    [description] TEXT         NOT NULL,
    CONSTRAINT [PK_genre] PRIMARY KEY CLUSTERED ([genre_id] ASC)
);

CREATE TABLE [dbo].[published_item_genre] (
    [published_item_id] BIGINT NOT NULL,
    [genre_id]          BIGINT NOT NULL,
    CONSTRAINT [PK_published_item_genre] PRIMARY KEY CLUSTERED ([published_item_id] ASC, [genre_id] ASC),
    CONSTRAINT [FK_published_item_genre_genre] FOREIGN KEY ([genre_id]) REFERENCES [dbo].[genre] ([genre_id]),
    CONSTRAINT [FK_published_item_genre_published_item] FOREIGN KEY ([published_item_id]) REFERENCES [dbo].[published_item] ([published_item_id])
);

CREATE TABLE [dbo].[book] (
    [book_id]   BIGINT       IDENTITY (1, 1) NOT NULL,
    [ISBN]      VARCHAR (20) NOT NULL,
    [author_id] BIGINT       NOT NULL,
    CONSTRAINT [PK_book] PRIMARY KEY CLUSTERED ([book_id] ASC),
    CONSTRAINT [FK_book_author] FOREIGN KEY ([author_id]) REFERENCES [dbo].[author] ([author_id])
);

CREATE TABLE [dbo].[magazine] (
    [magazine_id] BIGINT NOT NULL,
    CONSTRAINT [PK_magazine] PRIMARY KEY CLUSTERED ([magazine_id] ASC)
);

CREATE TABLE [dbo].[loan] (
    [loan_id]           BIGINT   IDENTITY (1, 1) NOT NULL,
    [patron_id]         BIGINT   NOT NULL,
    [published_item_id] BIGINT   NOT NULL,
    [loan_date]         DATETIME NOT NULL,
    [due_date]          DATETIME NOT NULL,
    [return_date]       DATETIME NOT NULL,
    CONSTRAINT [PK_loan] PRIMARY KEY CLUSTERED ([loan_id] ASC),
    CONSTRAINT [FK_loan_patron] FOREIGN KEY ([patron_id]) REFERENCES [dbo].[patron] ([patron_id]),
    CONSTRAINT [FK_loan_published_item] FOREIGN KEY ([published_item_id]) REFERENCES [dbo].[published_item] ([published_item_id])
);
