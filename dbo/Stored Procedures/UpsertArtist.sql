
CREATE PROCEDURE [dbo].[UpsertArtist]
    @Id INT = NULL,
    @Name NVARCHAR(100),
    @Profile NVARCHAR(MAX),
    @IsActive BIT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Check if the artist already exists
    IF EXISTS (SELECT 1
    FROM Artists
    WHERE Id = @Id)
    BEGIN
        -- Update existing artist
        UPDATE Artists
        SET Name = @Name,
			Profile = @Profile,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
        SELECT @Id AS Id;
    END
    ELSE
    BEGIN
        -- Insert new artist
        INSERT INTO Artists
            (Name, Profile, CreatedBy)
        VALUES
            (@Name, @Profile, @UserId);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END