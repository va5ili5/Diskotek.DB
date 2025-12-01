
CREATE PROCEDURE [dbo].[UpsertLabel]
    @Id INT = NULL,
    @Name NVARCHAR(100),
    @Profile NVARCHAR(MAX),
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
			Profile = @Profile,
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
            (Name, Profile, CreatedBy)
        VALUES
            (@Name, @Profile, @UserId);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END