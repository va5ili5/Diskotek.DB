
CREATE PROCEDURE [dbo].[UpsertLabel]
    @Id INT = NULL,
    @Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @IsActive BIT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Check if the label already exists
    IF EXISTS (SELECT 1
    FROM Labels
    WHERE Id = @Id)
    BEGIN
        -- Update existing label
        UPDATE Labels
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
        -- Insert new label
        INSERT INTO Labels
            (Name, Description, CreatedBy)
        VALUES
            (@Name, @Description, @UserId);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END