CREATE PROCEDURE [dbo].[GetReleasesByLabelId]
	@LabelId INT,
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
	WHERE release.LabelId = @LabelId AND release.IsActive = 1
	ORDER BY release.ReleaseDate DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

	-- Total number of releases for this artist
	SELECT COUNT(*)
	FROM Releases release
	WHERE release.LabelId = @LabelId AND release.IsActive = 1
END