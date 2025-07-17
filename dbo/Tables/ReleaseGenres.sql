CREATE TABLE [dbo].[ReleaseGenres]
(
	[ReleaseId] UNIQUEIDENTIFIER NOT NULL,
    [GenreId] UNIQUEIDENTIFIER NOT NULL,
    PRIMARY KEY (ReleaseId, GenreId),
    CONSTRAINT FK_ReleaseGenres_Releases FOREIGN KEY (ReleaseId)
        REFERENCES Releases(Id) ON DELETE CASCADE,
    CONSTRAINT FK_ReleaseGenres_Genres FOREIGN KEY (GenreId)
        REFERENCES Genres(Id) ON DELETE CASCADE
)
