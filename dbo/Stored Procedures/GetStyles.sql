CREATE PROCEDURE [dbo].[GetStyles]
	@GenreId INT = NULL
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		Id,
		Name
	FROM Styles
	WHERE @GenreId IS NULL OR GenreId = @GenreId
	END;