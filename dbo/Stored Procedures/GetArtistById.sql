CREATE PROCEDURE [dbo].[GetArtistById]
	@ArtistId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		artist.Id,
		artist.Name,
		artist.Profile,
		artistImage.ImageUrl
	FROM Artists artist
	OUTER APPLY(
		SELECT TOP 1
			image.ImageUrl
		FROM Images image
		WHERE image.EntityId = @ArtistId AND image.EntityType=2 AND image.IsPrimary = 1
		ORDER BY image.Id
	) artistImage
	WHERE Artist.Id = @ArtistId
END;
GO
