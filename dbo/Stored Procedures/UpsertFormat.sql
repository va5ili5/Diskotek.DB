
CREATE PROCEDURE UpsertFormat
	@Id UNIQUEIDENTIFIER,
	@Name NVARCHAR(100),
	@UserId UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

    -- Check if the format already exists
    IF EXISTS (SELECT 1 FROM Genres WHERE Id = @Id)
    BEGIN
        -- Update existing format
        UPDATE Formats
        SET Name = @Name,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
    END
    ELSE
    BEGIN        
		-- Insert new format
        INSERT INTO Formats (Id, Name, CreatedBy, CreatedAt)
        VALUES (@Id, @Name, @UserId, SYSUTCDATETIME());

		SELECT @Id AS Id;
    END
END