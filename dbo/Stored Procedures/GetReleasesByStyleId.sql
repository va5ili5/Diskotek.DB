CREATE PROCEDURE [dbo].[GetReleasesByStyleId]
	@StyleId INT
AS
BEGIN
	SELECT TOP 10
		release.Id,
		release.Title,
		releaseImage.ImageUrl
	FROM Releases release
	OUTER APPLY(
		SELECT TOP 1
			image.ImageUrl
		FROM Images image
		WHERE image.EntityId = release.Id AND image.EntityType='Release' AND image.IsPrimary = 1
		ORDER BY image.Id
	) releaseImage
		INNER JOIN ReleaseStyles releaseStyles ON releaseStyles.StyleId = @StyleId
	WHERE release.IsActive = 1
END