CREATE PROCEDURE [dbo].[GetReleasesByArtistId]
	@ArtistId INT,
	@PageNumber INT = 1,
	@PageSize INT = 10
AS
BEGIN
	SELECT
		release.Id,
		release.Title,
		releaseImage.ImageUrl
	FROM Releases release
	OUTER APPLY(
		SELECT TOP 1
			image.ImageUrl
		FROM Images image
		WHERE image.EntityId = release.Id AND image.EntityType=1 AND image.IsPrimary = 1
		ORDER BY image.Id
	) releaseImage
		INNER JOIN ReleaseArtists releaseArtists ON releaseArtists.ArtistId = @ArtistId
	WHERE release.IsActive = 1
	ORDER BY release.ReleaseDate DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

	-- Total number of releases for this artist
	SELECT COUNT(*)
	FROM ReleaseArtists releaseArtist
		INNER JOIN Releases release ON release.Id = releaseArtist.ReleaseId
	WHERE releaseArtist.ArtistId = @ArtistId AND release.IsActive = 1;
END