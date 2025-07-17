
CREATE PROCEDURE UpsertStyle
	@Id UNIQUEIDENTIFIER,
	@Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
	@UserId UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

    -- Check if the style already exists
    IF EXISTS (SELECT 1 FROM Styles WHERE Id = @Id)
    BEGIN
        -- Update existing style
        UPDATE Styles
        SET Name = @Name,
			Description = @Description,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
    END
    ELSE
    BEGIN        
		-- Insert new style
        INSERT INTO Styles (Id, Name, Description, CreatedBy, CreatedAt)
        VALUES (@Id, @Name, @Description, @UserId, SYSUTCDATETIME());

		SELECT @Id AS Id;
    END
END