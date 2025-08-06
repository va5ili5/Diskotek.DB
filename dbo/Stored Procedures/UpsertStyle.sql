CREATE PROCEDURE [dbo].[UpsertStyle]
    @Id INT = NULL,
    @Name NVARCHAR (100),
    @Description NVARCHAR (MAX),
    @IsActive BIT,
    @GenreId INT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
    FROM Styles
    WHERE Id = @Id)
	BEGIN
        UPDATE Styles
        SET Name        = @Name,
            Description = @Description,
            IsActive	= @IsActive,
            GenreId     = @GenreId,
            UpdatedBy   = @UserId,
            UpdatedAt   = SYSUTCDATETIME()
        WHERE Id = @Id;
        SELECT @Id AS Id;
    END
	ELSE
	BEGIN
        INSERT INTO Styles
            (Name, Description, GenreId, CreatedBy)
        VALUES
            (@Name, @Description, @GenreId, @UserId);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END