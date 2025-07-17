CREATE TABLE [dbo].[Artists] (
    [Id]        UNIQUEIDENTIFIER NOT NULL,
    [Name]      NVARCHAR (255)   NOT NULL,
    [Profile]   NVARCHAR (MAX)   NULL,
    [IsActive]  BIT DEFAULT 1,
    [CreatedAt] DATETIME DEFAULT (SYSUTCDATETIME()) NOT NULL,
    [UpdatedAt] DATETIME          NULL,
    [CreatedBy] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedBy] UNIQUEIDENTIFIER NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [IX_Artists_Name]
    ON [dbo].[Artists]([Name] ASC);

