CREATE PROCEDURE [dbo].[GetArtistById]
	@ArtistId UNIQUEIDENTIFIER,
	@PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
	 SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
	DECLARE @TotalCount INT;

    -- Total number of releases for this artist
    SELECT @TotalCount = COUNT(*)
    FROM ReleaseArtists ReleaseArtist
    WHERE ReleaseArtist.ArtistId = @ArtistId;
    
	-- CTE to get the releases for this page
    ;WITH PagedReleases AS (
        SELECT 
            Release.Id,
            Release.Title
            FROM ReleaseArtists ReleaseArtist
            INNER JOIN Releases Release ON Release.Id = ReleaseArtist.ReleaseId
            WHERE ReleaseArtist.ArtistId = @ArtistId
            ORDER BY Release.ReleaseDate
            OFFSET @Offset ROWS
            FETCH NEXT @PageSize ROWS ONLY
    )

    SELECT
        Artist.Id,
        Artist.Name,
		Artist.Profile,
		LabelImage.ImageUrl,
        @TotalCount AS TotalCount,
        (
            SELECT 
            PagedRelease.Id,
            PagedRelease.Title,
			Image.ImageUrl
            FROM PagedReleases PagedRelease
			INNER JOIN Images Image ON PagedRelease.Id = Image.ReleaseId AND Image.IsPrimary = 1
            FOR JSON PATH
        ) AS Releases
    FROM Artists Artist
    INNER JOIN Images LabelImage ON LabelImage.LabelId = @ArtistId AND LabelImage.IsPrimary = 1  
    WHERE Artist.Id = @ArtistId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
END;
GO
