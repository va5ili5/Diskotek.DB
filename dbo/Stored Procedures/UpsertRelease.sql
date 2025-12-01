CREATE PROCEDURE [dbo].[UpsertRelease]
    @Id INT = NULL,
    @Title NVARCHAR(255),
    @CatalogNumber NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @ReleaseDate DATETIME = NULL,
    @FormatId INT,
    @LabelId INT,
    @CountryId INT,
    @ArtistIds NVARCHAR(100),
    @GenreIds NVARCHAR(100),
    @StyleIds NVARCHAR(100),
    --@Tracks TrackList READONLY,
    @UserId INT,
    @IsActive BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
            BEGIN TRANSACTION;
            -- Upsert Release
            IF EXISTS (SELECT 1
    FROM Releases
    WHERE Id = @Id)
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
                    WHERE Id = @Id;
        SELECT @Id AS Id;
    END
        ELSE
        BEGIN
        INSERT INTO Releases
            (
            Title, CatalogNumber, Description, ReleaseDate,
            FormatId, LabelId, CountryId, CreatedBy, CreatedAt
            )
        VALUES
            (
                @Title, @CatalogNumber, @Description, @ReleaseDate,
                @FormatId, @LabelId, @CountryId, @UserId, SYSUTCDATETIME()
            );
        SET @Id = SCOPE_IDENTITY();
    END
        -- Remove existing artist links to avoid duplicates
        DELETE FROM ReleaseArtists WHERE ReleaseId = @Id;
        
        ;WITH AList AS (
            SELECT value AS AId
            FROM STRING_SPLIT(@ArtistIds, ',')
        )
            -- Insert new artist links
            INSERT INTO ReleaseArtists
            (ReleaseId, ArtistId)
        SELECT @Id, CAST(AList.AId AS INT)
        FROM AList;

        -- Remove existing genres links to avoid duplicates
        DELETE FROM ReleaseGenres WHERE ReleaseId = @Id;

        -- Insert new genre links
        ;WITH GList AS (
            SELECT value AS GId
            FROM STRING_SPLIT(@GenreIds, ',')
        )
        INSERT INTO ReleaseGenres
        (ReleaseId, GenreId)
    SELECT @Id, CAST(GList.GId AS INT)
        FROM GList;

        -- Remove existing styles links to avoid duplicates
        DELETE FROM ReleaseStyles WHERE ReleaseId = @Id;

        -- Insert new style links
        ;WITH SList AS (
            SELECT value AS SId
            FROM STRING_SPLIT(@StyleIds, ',')
        )
        INSERT INTO ReleaseStyles
        (ReleaseId, StyleId)
    SELECT @Id, CAST(SList.SId AS INT)
        FROM SList;

        -- 5. UPSERT Tracks
		-- DECLARE @TrackId INT;
		-- DECLARE track_cursor CURSOR FOR
		-- SELECT Id, Title, TrackNumber, Duration, Position
  --  FROM @Tracks
		-- DECLARE 
		--	@TitleTrack NVARCHAR(255),
		--	@TrackNumber INT,
		--	@Duration NVARCHAR(20),
		--	@Position NVARCHAR(10);

		-- OPEN track_cursor;
		-- FETCH NEXT FROM track_cursor INTO @TrackId, @TitleTrack, @TrackNumber, @Duration, @Position;

		-- WHILE @@FETCH_STATUS = 0
		-- BEGIN
  --      IF EXISTS(SELECT 1
  --      FROM Tracks
  --      WHERE Id = @TrackId AND ReleaseId = @Id)
		--	BEGIN
  --          UPDATE Tracks
		--		SET Title		= @TitleTrack,
		--			TrackNumber	= @TrackNumber,
		--			Duration	= @Duration,
		--			Position	= @Position,
		--			UpdatedAt	= SYSUTCDATETIME(),
		--			UpdatedBy	= @UserId
		--			WHERE Id = @TrackId AND ReleaseId = @Id;
  --      END
		--	ELSE
		--	BEGIN
  --          INSERT INTO Tracks
  --              (
  --              ReleaseId, Title, TrackNumber, Duration, Position, CreatedBy
  --              )
  --          VALUES
  --              (
  --                  @Id, @TitleTrack, @TrackNumber, @Duration, @Position, @UserId
  --              );
  --      END
  --      FETCH NEXT FROM track_cursor INTO @TrackId, @TitleTrack, @TrackNumber, @Duration, @Position;
  --  END
		--CLOSE track_cursor;
		--DEALLOCATE track_cursor;

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
		SELECT @Id AS Id;
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