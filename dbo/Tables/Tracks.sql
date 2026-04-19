CREATE TABLE [dbo].[Tracks] (
    [Id]        INT            IDENTITY (1, 1) NOT NULL,
    [ReleaseId] INT            NOT NULL,
    [Title]     NVARCHAR (500) NOT NULL,
    [Position]  NVARCHAR (10)  NOT NULL,
    [Duration]  NVARCHAR (10)  NULL,
    [SortOrder] INT            NOT NULL,
    [IsActive]  BIT            DEFAULT ((1)) NULL,
    [CreatedAt] DATETIME       DEFAULT (sysutcdatetime()) NOT NULL,
    [UpdatedAt] DATETIME       NULL,
    [CreatedBy] INT            NOT NULL,
    [UpdatedBy] INT            NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Tracks_Releases] FOREIGN KEY ([ReleaseId]) REFERENCES [dbo].[Releases] ([Id])
);




GO
CREATE NONCLUSTERED INDEX [ix_tracks_release_id]
    ON [dbo].[Tracks]([ReleaseId] ASC);

