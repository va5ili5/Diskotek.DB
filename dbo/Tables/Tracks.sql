CREATE TABLE [dbo].[Tracks]
(
    [Id] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY,
    [ReleaseId] UNIQUEIDENTIFIER NOT NULL,
    [Title] NVARCHAR (255) NOT NULL,
    [Position] NVARCHAR (10) NULL,
    [Duration] NVARCHAR (20) NULL,
    [TrackNumber] INT NULL,
    [IsActive] BIT DEFAULT ((1)) NULL,
    [CreatedAt] DATETIME DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAt] DATETIME NULL,
    [CreatedBy] UNIQUEIDENTIFIER NOT NULL,
    [UpdatedBy] UNIQUEIDENTIFIER NULL,
    CONSTRAINT [FK_Tracks_Releases] FOREIGN KEY ([ReleaseId]) REFERENCES [dbo].[Releases] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_Tracks_ReleaseId]
    ON [dbo].[Tracks]([ReleaseId] ASC, [TrackNumber] ASC);

