CREATE TABLE [dbo].[ReleaseStyles]
(
    [ReleaseId] INT NOT NULL,
    [StyleId] INT NOT NULL,
    PRIMARY KEY (ReleaseId, StyleId),
    CONSTRAINT FK_ReleaseStyles_Releases FOREIGN KEY (ReleaseId)
        REFERENCES Releases(Id) ON DELETE CASCADE,
    CONSTRAINT FK_ReleaseStyles_Styles FOREIGN KEY (StyleId)
        REFERENCES Styles(Id) ON DELETE CASCADE
)
