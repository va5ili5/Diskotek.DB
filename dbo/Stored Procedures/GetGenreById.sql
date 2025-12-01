CREATE PROCEDURE [dbo].[GetGenreById]
	@GenreId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		Id,
		Name,
		Description
	FROM Genres
	WHERE Id = @GenreId
END;