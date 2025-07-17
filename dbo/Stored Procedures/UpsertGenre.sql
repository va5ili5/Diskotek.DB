
CREATE PROCEDURE UpsertGenre
	@Id UNIQUEIDENTIFIER,
	@Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
	@UserId UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

    -- Check if the genre already exists
    IF EXISTS (SELECT 1 FROM Genres WHERE Id = @Id)
    BEGIN
        -- Update existing genre
        UPDATE Genres
        SET Name = @Name,
			Description = @Description,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
    END
    ELSE
    BEGIN        
		-- Insert new genre
        INSERT INTO Genres (Id, Name, Description, CreatedBy, CreatedAt)
        VALUES (@Id, @Name, @Description, @UserId, SYSUTCDATETIME());

		SELECT @Id AS Id;
    END
END