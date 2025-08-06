
CREATE PROCEDURE [dbo].[UpsertArtist]
    @Id UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(100),
    @Profile NVARCHAR(MAX),
    @IsActive BIT,
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @ArtistId UNIQUEIDENTIFIER = ISNULL(@Id, NEWID());
    -- Check if the artist already exists
    IF EXISTS (SELECT 1
    FROM Artists
    WHERE Id = @ArtistId)
    BEGIN
        -- Update existing artist
        UPDATE Artists
        SET Name = @Name,
			Profile = @Profile,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @ArtistId;
    END
    ELSE
    BEGIN
        -- Insert new artist
        INSERT INTO Artists
            (Id, Name, Profile, CreatedBy)
        VALUES
            (@ArtistId, @Name, @Profile, @UserId);
    END
    SELECT @ArtistId AS Id;
END