CREATE PROCEDURE [dbo].[GetReleaseById]
	@ReleaseId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		Release.Id,
		Title,
		CatalogNumber,
		Description,
		ReleaseDate,
		FormatId,
		Format.Name as FormatName,
		LabelId,
		Label.Name as LabelName,
		CountryId,
		Country.Name as CountryName,
		Image.ImageUrl
	FROM Releases Release
		INNER JOIN Formats Format ON Format.Id = Release.FormatId
		INNER JOIN Labels Label ON Label.Id = Release.LabelId
		INNER JOIN Countries Country ON Country.Id = Release.CountryId
		LEFT JOIN Images Image ON Image.EntityId = @ReleaseId AND Image.EntityType = 'Release' AND Image.IsPrimary = 1
	WHERE [Release].Id = @ReleaseId
	
	SELECT
			Id,
			Name
		FROM Artists Artist
			INNER JOIN ReleaseArtists ReleaseArtist ON Artist.Id = ReleaseArtist.ArtistId
		WHERE ReleaseArtist.ReleaseId = @ReleaseId

	--SELECT
	--		Id,
	--		Title,
	--		Duration,
	--		TrackNumber,
	--		Position
	--	FROM Tracks Track
	--	WHERE Track.ReleaseId = @ReleaseId

SELECT
			Id,
			Name
		FROM Genres Genre
			INNER JOIN ReleaseGenres ReleaseGenre ON Genre.Id = ReleaseGenre.GenreId
		WHERE ReleaseGenre.ReleaseId = @ReleaseId

		SELECT
			Id,
			Name
		FROM Styles Style
			INNER JOIN ReleaseStyles ReleaseStyle ON Style.Id = ReleaseStyle.StyleId
		WHERE ReleaseStyle.ReleaseId = @ReleaseId
	END;