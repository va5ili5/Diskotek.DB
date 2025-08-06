CREATE PROCEDURE [dbo].[GetReleaseById]
	@ReleaseId UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		Release.Id,
		Title,
		CatalogNumber,
		Release.Description,
		ReleaseDate,
		Format.Name as Format,
		Label.Id as LabelId,
		Label.Name as LabelName,
		Country.Name as Country,
		ISNULL(( 
		SELECT
			Artist.Id,
			Artist.Name
		FROM Artists Artist
			INNER JOIN ReleaseArtists ReleaseArtist ON Artist.Id = ReleaseArtist.ArtistId
		WHERE ReleaseArtist.ReleaseId = @ReleaseId
		FOR JSON PATH)
	,'[]') As Artists,
		ISNULL(( 
		SELECT
			Track.Id,
			Track.Title,
			Track.Duration,
			Track.TrackNumber,
			Track.Position
		FROM Tracks Track
		WHERE Track.ReleaseId = @ReleaseId
		FOR JSON PATH)
	,'[]') As Tracks,
		ISNULL((
		SELECT
			Genre.Id,
			Genre.Name
		FROM Genres Genre
			INNER JOIN ReleaseGenres ReleaseGenre ON Genre.Id = ReleaseGenre.GenreId
		WHERE ReleaseGenre.ReleaseId = @ReleaseId
		FOR JSON PATH)
	,'[]') As Genres,
		ISNULL((
		SELECT
			Style.Id,
			Style.Name
		FROM Styles Style
			INNER JOIN ReleaseStyles ReleaseStyle ON Style.Id = ReleaseStyle.StyleId
		WHERE ReleaseStyle.ReleaseId = @ReleaseId
		FOR JSON PATH)
	,'[]') As Styles
	FROM Releases Release
		INNER JOIN Formats Format ON Format.Id = Release.FormatId
		INNER JOIN Labels Label ON Label.Id = Release.LabelId
		INNER JOIN Countries Country ON Country.Id = Release.CountryId
		INNER JOIN Images Image ON Image.EntityId = @ReleaseId AND Image.EntityType = 'Release' AND Image.IsPrimary = 1
	WHERE [Release].Id = @ReleaseId
	FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER;
	END;