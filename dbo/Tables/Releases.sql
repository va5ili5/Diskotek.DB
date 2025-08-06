CREATE TABLE [dbo].[Releases]
(
    [Id] UNIQUEIDENTIFIER PRIMARY KEY,
    [Title] NVARCHAR (255) NOT NULL,
    [CatalogNumber] NVARCHAR (100) NULL,
    [Description] NVARCHAR (MAX) NULL,
    [ReleaseDate] DATETIME NULL,
    [FormatId] UNIQUEIDENTIFIER NOT NULL,
    [LabelId] UNIQUEIDENTIFIER NOT NULL,
    [CountryId] UNIQUEIDENTIFIER NULL,
    [IsActive] BIT DEFAULT 1,
    [CreatedAt] DATETIME DEFAULT (SYSUTCDATETIME()) NOT NULL,
    [UpdatedAt] DATETIME NULL,
    [CreatedBy] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedBy] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [FK_Releases_Countries] FOREIGN KEY ([CountryId]) REFERENCES [dbo].[Countries] ([Id]),
    CONSTRAINT [FK_Releases_Formats] FOREIGN KEY ([FormatId]) REFERENCES [dbo].[Formats] ([Id]),
    CONSTRAINT [FK_Releases_Labels] FOREIGN KEY ([LabelId]) REFERENCES [dbo].[Labels] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_Releases_Title]
    ON [dbo].[Releases]([Title] ASC);

