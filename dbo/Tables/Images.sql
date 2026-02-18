CREATE TABLE [dbo].[Images]
(
    [Id] INT IDENTITY(1,1) PRIMARY KEY,
    [EntityId] INT NOT NULL,
    [EntityType] INT NOT NULL,
    [ImageUrl] NVARCHAR (500) NOT NULL,
    [SortOrder] INT NOT NULL,
    [IsPrimary] BIT DEFAULT ((0)) NOT NULL,
    [CreatedAt] DATETIME DEFAULT (SYSUTCDATETIME()) NOT NULL,
    [CreatedBy] INT NOT NULL
);

GO
CREATE NONCLUSTERED INDEX [IX_Images_Entity]
    ON [dbo].[Images]([EntityType] ASC, [EntityId] ASC);

