
CREATE PROCEDURE [dbo].[UpsertFormat]
    @Id UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(100),
    @IsActive BIT,
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @FormatId UNIQUEIDENTIFIER = ISNULL(@Id, NEWID());
    -- Check if the format already exists
    IF EXISTS (SELECT 1
    FROM Genres
    WHERE Id = @FormatId)
    BEGIN
        -- Update existing format
        UPDATE Formats
        SET Name = @Name,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @FormatId;
    END
    ELSE
    BEGIN
        -- Insert new format
        INSERT INTO Formats
            (Id, Name, CreatedBy)
        VALUES
            (@FormatId, @Name, @UserId);
    END
    SELECT @FormatId AS Id;
END