CREATE PROCEDURE [dbo].[GetReleases]
	@PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
	DECLARE @TotalCount INT;

	-- Total count of all releases
	SELECT @TotalCount = COUNT(*) FROM Releases;

	-- CTE to get just the releases for this page
	;WITH PagedReleases AS (
        SELECT 
            Release.Id,
            Release.Title
        FROM Releases Release
        ORDER BY Release.Id
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY
    )

	SELECT 
	@TotalCount AS TotalCount,
	(
		SELECT
		Release.Id,
		Release.Title,
		(
		SELECT TOP 1 
        Image.Id,
        Image.ImageUrl
		FROM Images Image
		WHERE Image.ReleaseId = Release.Id and Image.IsPrimary = 1
		FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) As Image,
		ISNULL((
				SELECT 
					Artist.Id,
					Artist.Name
				FROM ReleaseArtists ReleaseArtist
				JOIN Artists Artist ON Artist.Id = ReleaseArtist.ArtistId
				WHERE ReleaseArtist.ReleaseId = Release.Id
				FOR JSON PATH
		),'[]') AS Artists
		FROM PagedReleases Release
		FOR JSON PATH, INCLUDE_NULL_VALUES
	) AS Releases
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
END;