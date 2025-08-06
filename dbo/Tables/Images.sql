CREATE TABLE [dbo].[Images]
(
    [Id] UNIQUEIDENTIFIER PRIMARY KEY,
    [EntityId] UNIQUEIDENTIFIER NOT NULL,
    [EntityType] NVARCHAR (50) NOT NULL,
    [ImageUrl] NVARCHAR (500) NOT NULL,
    [SortOrder] INT NOT NULL,
    [IsPrimary] BIT DEFAULT ((0)) NOT NULL,
    [CreatedAt] DATETIME DEFAULT (getutcdate()) NOT NULL,
    [CreatedBy] UNIQUEIDENTIFIER NOT NULL
);

GO
CREATE NONCLUSTERED INDEX [IX_Images_Entity]
    ON [dbo].[Images]([EntityType] ASC, [EntityId] ASC);

