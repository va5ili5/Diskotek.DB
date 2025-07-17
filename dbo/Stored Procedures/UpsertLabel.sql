
CREATE PROCEDURE UpsertLabel
	@Id UNIQUEIDENTIFIER,
	@Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
	@UserId UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

    -- Check if the label already exists
    IF EXISTS (SELECT 1 FROM Labels WHERE Id = @Id)
    BEGIN
        -- Update existing label
        UPDATE Labels
        SET Name = @Name,
			Description = @Description,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
    END
    ELSE
    BEGIN        
		-- Insert new label
        INSERT INTO Labels (Id, Name, Description, CreatedBy, CreatedAt)
        VALUES (@Id, @Name, @Description, @UserId, SYSUTCDATETIME());

		SELECT @Id AS Id;
    END
END