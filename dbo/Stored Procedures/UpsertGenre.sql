
CREATE PROCEDURE [dbo].[UpsertGenre]
    @Id UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @IsActive BIT,
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @GenreId UNIQUEIDENTIFIER = ISNULL(@Id, NEWID());
    -- Check if the genre already exists
    IF EXISTS (SELECT 1
    FROM Genres
    WHERE Id = @GenreId)
    BEGIN
        -- Update existing genre
        UPDATE Genres
        SET Name = @Name,
			Description = @Description,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @GenreId;
    END
    ELSE
    BEGIN
        -- Insert new genre
        INSERT INTO Genres
            (Id, Name, Description, CreatedBy)
        VALUES
            (@GenreId, @Name, @Description, @UserId);
    END
    SELECT @GenreId AS Id;
END