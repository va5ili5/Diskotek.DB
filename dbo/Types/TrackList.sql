CREATE TYPE [dbo].[TrackList] AS TABLE
(   
    Id UNIQUEIDENTIFIER NULL, -- allow NULL for new tracks,
	Title NVARCHAR(255) NOT NULL,
    TrackNumber INT NULL,
    Duration NVARCHAR(20) NULL,
    Position NVARCHAR(10) NULL,
    CreatedAt DATETIME NOT NULL DEFAULT SYSUTCDATETIME(),
    CreatedBy NVARCHAR(255) NULL
)
