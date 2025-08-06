
CREATE PROCEDURE [dbo].[UpsertFormat]
    @Id INT = NULL,
    @Name NVARCHAR(100),
    @IsActive BIT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Check if the format already exists
    IF EXISTS (SELECT 1
    FROM Genres
    WHERE Id = @Id)
    BEGIN
        -- Update existing format
        UPDATE Formats
        SET Name = @Name,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
        SELECT @Id AS Id;
    END
    ELSE
    BEGIN
        -- Insert new format
        INSERT INTO Formats
            (Name, CreatedBy)
        VALUES
            (@Name, @UserId);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END