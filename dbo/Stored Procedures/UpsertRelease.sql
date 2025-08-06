CREATE PROCEDURE [dbo].[UpsertRelease]
    @Id UNIQUEIDENTIFIER = NULL,
    @Title NVARCHAR(255),
    @CatalogNumber NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @ReleaseDate DATETIME,
    @FormatId UNIQUEIDENTIFIER,
    @LabelId UNIQUEIDENTIFIER,
    @CountryId UNIQUEIDENTIFIER,
    @ArtistIds ArtistsIdsList READONLY,
    -- Table-valued parameter for artist IDs
    @GenreIds GenresIdsList READONLY,
    -- Table-valued parameter for genre IDs
    @StyleIds StylesIdsList READONLY,
    -- Table-valued parameter for style IDs
    @Tracks TrackList READONLY,
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
            BEGIN TRANSACTION;
			DECLARE @ReleaseId UNIQUEIDENTIFIER = ISNULL(@Id, NEWID())
            -- Upsert Release
            IF EXISTS (SELECT 1
    FROM Releases
    WHERE Id = @ReleaseId)
            BEGIN
        UPDATE Releases
                SET Title = @Title,
                    CatalogNumber = @CatalogNumber,
                    Description = @Description,
                    ReleaseDate = @ReleaseDate,
                    FormatId = @FormatId,
                    LabelId = @LabelId,
                    CountryId = @CountryId,
                    UpdatedBy = @UserId,
                    UpdatedAt = SYSUTCDATETIME()
                    WHERE Id = @ReleaseId;
    END
        ELSE
        BEGIN
        INSERT INTO Releases
            (
            Id, Title, CatalogNumber, Description, ReleaseDate,
            FormatId, LabelId, CountryId, CreatedBy, CreatedAt
            )
        VALUES
            (
                @ReleaseId, @Title, @CatalogNumber, @Description, @ReleaseDate,
                @FormatId, @LabelId, @CountryId, @UserId, SYSUTCDATETIME()
            );
        SELECT @ReleaseId AS Id;
    END

        -- Remove existing artist links to avoid duplicates
        DELETE FROM ReleaseArtists WHERE ReleaseId = @ReleaseId;

        -- Insert new artist links
        INSERT INTO ReleaseArtists
        (ReleaseId, ArtistId)
    SELECT @ReleaseId, ArtistId
    FROM @ArtistIds;

        -- Remove existing genres links to avoid duplicates
        DELETE FROM ReleaseGenres WHERE ReleaseId = @ReleaseId;

        -- Insert new genre links
        INSERT INTO ReleaseGenres
        (ReleaseId, GenreId)
    SELECT @ReleaseId, GenreId
    FROM @GenreIds;

        -- Remove existing styles links to avoid duplicates
        DELETE FROM ReleaseStyles WHERE ReleaseId = @ReleaseId;

        -- Insert new style links
        INSERT INTO ReleaseStyles
        (ReleaseId, StyleId)
    SELECT @ReleaseId, StyleId
    FROM @StyleIds;

        -- 5. UPSERT Tracks
		 DECLARE @TrackId UNIQUEIDENTIFIER;
		 DECLARE track_cursor CURSOR FOR
		 SELECT Id, Title, TrackNumber, Duration, Position
    FROM @Tracks
		 DECLARE 
			@TitleTrack NVARCHAR(255),
			@TrackNumber INT,
			@Duration NVARCHAR(20),
			@Position NVARCHAR(10);

		 OPEN track_cursor;
		 FETCH NEXT FROM track_cursor INTO @TrackId, @TitleTrack, @TrackNumber, @Duration, @Position;

		 WHILE @@FETCH_STATUS = 0
		 BEGIN
        IF EXISTS(SELECT 1
        FROM Tracks
        WHERE Id = @TrackId AND ReleaseId = @ReleaseId)
			BEGIN
            UPDATE Tracks
				SET Title		= @TitleTrack,
					TrackNumber	= @TrackNumber,
					Duration	= @Duration,
					Position	= @Position,
					UpdatedAt	= SYSUTCDATETIME(),
					UpdatedBy	= @UserId
					WHERE Id = @TrackId AND ReleaseId = @ReleaseId;
        END
			ELSE
			BEGIN
            INSERT INTO Tracks
                (
                Id, ReleaseId, Title, TrackNumber, Duration, Position, CreatedBy
                )
            VALUES
                (
                    ISNULL(@TrackId, NEWID()), @ReleaseId, @TitleTrack, @TrackNumber, @Duration, @Position, @UserId
                );
        END
        FETCH NEXT FROM track_cursor INTO @TrackId, @TitleTrack, @TrackNumber, @Duration, @Position;
    END
		CLOSE track_cursor;
		DEALLOCATE track_cursor;

        -- Optionally: Remove tracks not in the input list
        --DELETE FROM Tracks
        --WHERE ReleaseId = @Id AND Id NOT IN (
        --    SELECT Id FROM @Tracks WHERE Id IS NOT NULL
        --);
        --MERGE INTO Tracks AS target
        --USING (
        --    SELECT * FROM @Tracks
        --) AS source
        --ON target.Id = source.Id AND target.ReleaseId = @Id
        --WHEN MATCHED THEN
        --    UPDATE SET
        --        Title = source.Title,
        --        TrackNumber = source.TrackNumber,
        --        Duration = source.Duration,
        --        Position = source.Position,
        --        UpdatedAt = SYSUTCDATETIME()
        --WHEN NOT MATCHED BY TARGET THEN
        --    INSERT (Id, ReleaseId, Title, TrackNumber, Duration, Position, CreatedAt, CreatedBy)
        --    VALUES (
        --        NEWID(), @Id, source.Title, source.TrackNumber, source.Duration, source.Position, SYSUTCDATETIME(), @UserId
        --    );

        ---- 6. Delete tracks not present in new list
        --DELETE FROM Tracks
        --WHERE ReleaseId = @Id
        --  AND Id NOT IN (SELECT Id FROM @Tracks WHERE Id IS NOT NULL);


        COMMIT TRANSACTION;
		SELECT @ReleaseId AS Id;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        DECLARE @ErrMsg NVARCHAR(4000), @ErrSeverity INT;
        SELECT
        @ErrMsg = ERROR_MESSAGE(),
        @ErrSeverity = ERROR_SEVERITY();

        RAISERROR (@ErrMsg, @ErrSeverity, 1);
    END CATCH
END