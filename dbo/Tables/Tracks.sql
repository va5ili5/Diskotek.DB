CREATE TABLE [dbo].[Tracks]
(
    [Id] INT IDENTITY(1,1) PRIMARY KEY,
    [ReleaseId] INT NOT NULL,
    [Title] NVARCHAR (255) NOT NULL,
    [Position] NVARCHAR (10) NULL,
    [Duration] NVARCHAR (20) NULL,
    [TrackNumber] INT NULL,
    [IsActive] BIT DEFAULT ((1)) NULL,
    [CreatedAt] DATETIME DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAt] DATETIME NULL,
    [CreatedBy] INT NOT NULL,
    [UpdatedBy] INT NULL,
    CONSTRAINT [FK_Tracks_Releases] FOREIGN KEY ([ReleaseId]) REFERENCES [dbo].[Releases] ([Id])
);


GO
CREATE NONCLUSTERED INDEX [IX_Tracks_ReleaseId]
    ON [dbo].[Tracks]([ReleaseId] ASC, [TrackNumber] ASC);

