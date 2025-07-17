
CREATE PROCEDURE UpsertCountry
	@Id UNIQUEIDENTIFIER,
    @CountryCode NVARCHAR(10),
	@Name NVARCHAR(100),
	@UserId UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

    -- Check if the country already exists
    IF EXISTS (SELECT 1 FROM Countries WHERE Id = @Id)
    BEGIN
        -- Update existing country
        UPDATE Countries
        SET Name = @Name,
            Code = @CountryCode,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
    END
    ELSE
    BEGIN        
		-- Insert new country
        INSERT INTO Countries (Id, Name, Code, CreatedBy, CreatedAt)
        VALUES (@Id, @Name, @CountryCode, @UserId, SYSUTCDATETIME());

		SELECT @Id AS Id;
    END
END
    