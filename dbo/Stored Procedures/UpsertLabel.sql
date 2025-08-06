
CREATE PROCEDURE [dbo].[UpsertLabel]
    @Id UNIQUEIDENTIFIER = NULL,
    @Name NVARCHAR(100),
    @Description NVARCHAR(MAX),
    @IsActive BIT,
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @LabelId UNIQUEIDENTIFIER = ISNULL(@Id, NEWID());
    -- Check if the label already exists
    IF EXISTS (SELECT 1
    FROM Labels
    WHERE Id = @LabelId)
    BEGIN
        -- Update existing label
        UPDATE Labels
        SET Name = @Name,
			Description = @Description,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @LabelId;
    END
    ELSE
    BEGIN
        -- Insert new label
        INSERT INTO Labels
            (Id, Name, Description, CreatedBy)
        VALUES
            (@LabelId, @Name, @Description, @UserId);
    END
    SELECT @LabelId AS Id;
END