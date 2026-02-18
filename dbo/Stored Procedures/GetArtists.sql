CREATE PROCEDURE [dbo].[GetArtists]
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        artist.Id,
        artist.Name,
        artistImage.ImageUrl
    FROM Artists artist
	OUTER APPLY(
		SELECT TOP 1
            image.ImageUrl
        FROM Images image
        WHERE image.EntityId = artist.Id AND image.EntityType=2 AND image.IsPrimary = 1
        ORDER BY image.Id
	) artistImage
    WHERE artist.IsActive = 1
    ORDER BY artist.Name DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    -- Total number of releases for this artist
    SELECT COUNT(*)
    FROM Artists artists
    WHERE artists.IsActive = 1
END;