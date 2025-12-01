CREATE PROCEDURE [dbo].[GetStylesByGenreId]
	@GenreId INT
AS
BEGIN
	SELECT Id,
		Name
	FROM Styles style
	WHERE style.GenreId = @GenreId
END