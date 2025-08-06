CREATE TABLE [dbo].[Artists]
(
    [Id] INT IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR (255) NOT NULL,
    [Profile] NVARCHAR (MAX) NULL,
    [IsActive] BIT DEFAULT 1,
    [CreatedAt] DATETIME DEFAULT (SYSUTCDATETIME()) NOT NULL,
    [UpdatedAt] DATETIME NULL,
    [CreatedBy] INT NOT NULL,
    [UpdatedBy] INT NULL
);


GO
CREATE NONCLUSTERED INDEX [IX_Artists_Name]
    ON [dbo].[Artists]([Name] ASC);

