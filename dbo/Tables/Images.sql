CREATE TABLE [dbo].[Images] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [EntityId]   INT            NOT NULL,
    [EntityType] INT            NOT NULL,
    [ImageUrl]   NVARCHAR (500) NOT NULL,
    [PublicId]   NVARCHAR (500) NULL,
    [AltText]    NVARCHAR (500) NULL,
    [SortOrder]  INT            NOT NULL,
    [IsPrimary]  BIT            DEFAULT ((0)) NOT NULL,
    [CreatedAt]  DATETIME       DEFAULT (sysutcdatetime()) NOT NULL,
    [CreatedBy]  INT            NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);



GO
CREATE NONCLUSTERED INDEX [IX_Images_Entity]
    ON [dbo].[Images]([EntityType] ASC, [EntityId] ASC);

