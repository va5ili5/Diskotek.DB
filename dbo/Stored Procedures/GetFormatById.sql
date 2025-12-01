CREATE PROCEDURE [dbo].[GetFormatById]
	@FormatId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		Id,
		Name
	FROM Formats
	WHERE Id = @FormatId AND IsActive = 1
END;