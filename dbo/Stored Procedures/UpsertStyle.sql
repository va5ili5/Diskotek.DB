CREATE PROCEDURE [dbo].[UpsertStyle]
    @Id UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR (100),
    @Description NVARCHAR (MAX),
    @IsActive BIT,
    @GenreId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @StyleId UNIQUEIDENTIFIER = ISNULL(@Id, NEWID());
    IF EXISTS (SELECT 1
    FROM Styles
    WHERE Id = @StyleId)
	BEGIN
        UPDATE Styles
    SET Name        = @Name,
        Description = @Description,
		IsActive	= @IsActive,
        GenreId     = @GenreId,
        UpdatedBy   = @UserId,
        UpdatedAt   = SYSUTCDATETIME()
	WHERE Id = @StyleId;
    END
	ELSE
	BEGIN
        INSERT INTO Styles
            (Id, Name, Description, GenreId, CreatedBy)
        VALUES
            (@StyleId, @Name, @Description, @GenreId, @UserId);
    END
    SELECT @StyleId AS Id;
END