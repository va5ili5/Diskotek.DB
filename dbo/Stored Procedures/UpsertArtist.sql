
CREATE PROCEDURE UpsertArtist
	@Id UNIQUEIDENTIFIER,
	@Name NVARCHAR(100),
    @Profile NVARCHAR(MAX),
	@UserId UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

    -- Check if the artist already exists
    IF EXISTS (SELECT 1 FROM Artists WHERE Id = @Id)
    BEGIN
        -- Update existing artist
        UPDATE Artists
        SET Name = @Name,
			Profile = @Profile,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
    END
    ELSE
    BEGIN        
		-- Insert new artist
        INSERT INTO Artists (Id, Name, Profile, CreatedBy, CreatedAt)
        VALUES (@Id, @Name, @Profile, @UserId, SYSUTCDATETIME());

		SELECT @Id AS Id;
    END
END