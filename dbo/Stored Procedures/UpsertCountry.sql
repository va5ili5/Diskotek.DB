
CREATE PROCEDURE [dbo].[UpsertCountry]
    @Id UNIQUEIDENTIFIER = NULL,
    @CountryCode NVARCHAR(10),
    @Name NVARCHAR(100),
    @IsActive BIT,
    @UserId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @CountryId UNIQUEIDENTIFIER = ISNULL(@Id, NEWID());
    -- Check if the country already exists
    IF EXISTS (SELECT 1
    FROM Countries
    WHERE Id = @CountryId)
    BEGIN
        -- Update existing country
        UPDATE Countries
        SET Name = @Name,
            Code = @CountryCode,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @CountryId;
    END
    ELSE
    BEGIN
        -- Insert new country
        INSERT INTO Countries
            (Id, Name, Code, CreatedBy)
        VALUES
            (@CountryId, @Name, @CountryCode, @UserId);
    END
    SELECT @CountryId AS Id;
END