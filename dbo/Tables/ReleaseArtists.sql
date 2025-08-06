CREATE TABLE [dbo].[ReleaseArtists]
(
    [ReleaseId] INT NOT NULL,
    [ArtistId] INT NOT NULL,
    PRIMARY KEY (ReleaseId, ArtistId),
    CONSTRAINT FK_ReleaseArtists_Releases FOREIGN KEY (ReleaseId)
        REFERENCES Releases(Id) ON DELETE CASCADE,
    CONSTRAINT FK_ReleaseArtists_Artists FOREIGN KEY (ArtistId)
        REFERENCES Artists(Id) ON DELETE CASCADE
)
