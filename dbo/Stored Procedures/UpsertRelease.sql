CREATE PROCEDURE UpsertRelease
    @Id UNIQUEIDENTIFIER,
    @Title NVARCHAR(255),
    @CatalogNumber NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @ReleaseDate DATETIME,
    @FormatId UNIQUEIDENTIFIER,
    @LabelId UNIQUEIDENTIFIER,
    @CountryId UNIQUEIDENTIFIER,
    @ArtistIds ArtistsIdsList READONLY, -- Table-valued parameter for artist IDs
    @GenreIds GenresIdsList READONLY, -- Table-valued parameter for genre IDs
    @StyleIds StylesIdsList READONLY, -- Table-valued parameter for style IDs
    @UserId UNIQUEIDENTIFIER
    AS
    BEGIN
        SET NOCOUNT ON;

        BEGIN TRY
            BEGIN TRANSACTION;

            -- Upsert Release
            IF EXISTS (SELECT 1 FROM Releases WHERE Id = @Id)
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
        END
        ELSE
        BEGIN
            INSERT INTO Releases (
                Id, Title, CatalogNumber, Description, ReleaseDate,
                FormatId, LabelId, CountryId, CreatedBy, CreatedAt
            )
            VALUES (
                @Id, @Title, @CatalogNumber, @Description, @ReleaseDate,
                @FormatId, @LabelId, @CountryId, @UserId, SYSUTCDATETIME()
            );
            SELECT @Id AS Id;
        END

        -- Remove existing artist links to avoid duplicates
        DELETE FROM ReleaseArtists WHERE ReleaseId = @Id;

        -- Insert new artist links
        INSERT INTO ReleaseArtists (ReleaseId, ArtistId)
        SELECT @Id, ArtistId FROM @ArtistIds;

        -- Remove existing genres links to avoid duplicates
        DELETE FROM ReleaseGenres WHERE ReleaseId = @Id;

        -- Insert new genre links
        INSERT INTO ReleaseGenres(ReleaseId, GenreId)
        SELECT @Id, GenreId FROM @GenreIds;

        -- Remove existing styles links to avoid duplicates
        DELETE FROM ReleaseStyles WHERE ReleaseId = @Id;

        -- Insert new style links
        INSERT INTO ReleaseStyles(ReleaseId, StyleId)
        SELECT @Id, StyleId FROM @StyleIds;

        COMMIT TRANSACTION;
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