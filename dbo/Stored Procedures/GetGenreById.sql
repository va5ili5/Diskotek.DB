CREATE PROCEDURE [dbo].[GetGenreById]
	@GenreId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		Id,
		Name,
		Description,
		(
		SELECT TOP 10
			Release.Id,
			Release.Title,
			Image.ImageUrl
		FROM Releases Release
			INNER JOIN Images Image ON Release.Id = Image.EntityId AND Image.EntityType='Release' AND Image.IsPrimary = 1
			INNER JOIN ReleaseGenres ReleaseGenre ON ReleaseGenre.GenreId = @GenreId AND ReleaseGenre.ReleaseId = Release.Id
		ORDER BY NEWID()
		FOR JSON PATH
	) As Releases
	FROM Genres
	WHERE Id = @GenreId
	FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
	END;