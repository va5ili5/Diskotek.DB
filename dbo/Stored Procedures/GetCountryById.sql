CREATE PROCEDURE [dbo].[GetCountryById]
	@CountryId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		Id,
		Name
	FROM Countries
	WHERE Id = @CountryId AND IsActive=1
END;