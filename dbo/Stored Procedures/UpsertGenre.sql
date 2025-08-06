
CREATE PROCEDURE [dbo].[UpsertGenre]
    @Id INT = NULL,
    @Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @IsActive BIT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Check if the genre already exists
    IF EXISTS (SELECT 1
    FROM Genres
    WHERE Id = @Id)
    BEGIN
        -- Update existing genre
        UPDATE Genres
        SET Name = @Name,
			Description = @Description,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
        SELECT @Id AS Id;
    END
    ELSE
    BEGIN
        -- Insert new genre
        INSERT INTO Genres
            (Name, Description, CreatedBy)
        VALUES
            (@Name, @Description, @UserId);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END