CREATE TABLE [dbo].[ReleaseGenres]
(
    [ReleaseId] INT NOT NULL,
    [GenreId] INT NOT NULL,
    PRIMARY KEY (ReleaseId, GenreId),
    CONSTRAINT FK_ReleaseGenres_Releases FOREIGN KEY (ReleaseId)
        REFERENCES Releases(Id) ON DELETE CASCADE,
    CONSTRAINT FK_ReleaseGenres_Genres FOREIGN KEY (GenreId)
        REFERENCES Genres(Id) ON DELETE CASCADE
)
