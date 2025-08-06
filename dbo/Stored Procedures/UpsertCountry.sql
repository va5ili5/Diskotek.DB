
CREATE PROCEDURE [dbo].[UpsertCountry]
    @Id INT = NULL,
    @CountryCode NVARCHAR(10),
    @Name NVARCHAR(100),
    @IsActive BIT,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
    FROM Countries
    WHERE Id = @Id)
    BEGIN
        -- Update existing country
        UPDATE Countries
        SET Name = @Name,
            Code = @CountryCode,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
       WHERE Id = @Id;
        SELECT @Id AS Id;
    END
    ELSE
    BEGIN
        -- Insert new country
        INSERT INTO Countries
            (Name, Code, CreatedBy)
        VALUES
            (@Name, @CountryCode, @UserId);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END