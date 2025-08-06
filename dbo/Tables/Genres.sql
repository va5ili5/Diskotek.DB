CREATE TABLE [dbo].[Genres]
(
    [Id] INT IDENTITY(1,1) PRIMARY KEY,
    [Name] NVARCHAR (100) NOT NULL,
    [Description] NVARCHAR (MAX) NULL,
    [IsActive] BIT DEFAULT 1,
    [CreatedAt] DATETIME DEFAULT (SYSUTCDATETIME()) NOT NULL,
    [UpdatedAt] DATETIME NULL,
    [CreatedBy] INT NOT NULL,
    [UpdatedBy] INT NULL
);

