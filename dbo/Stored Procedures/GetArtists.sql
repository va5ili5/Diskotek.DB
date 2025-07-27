CREATE PROCEDURE [dbo].[GetArtists]
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    DECLARE @TotalCount INT;

    -- Total count of all artists
    SELECT @TotalCount = COUNT(*) FROM Artists;

    -- CTE to get just the artists for this page
    ;WITH PagedArtists AS (
        SELECT Id, Name
        FROM Artists
        ORDER BY Name
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY
    )

    SELECT
        @TotalCount AS TotalCount,
        (
            SELECT 
                Artists.Id,
                Artists.Name,
                (
                    SELECT TOP 1 
                        Image.Id,
                        Image.ImageUrl
		            FROM Images Image
		            WHERE Image.EntityId = Artists.Id AND Image.EntityType='Artist' AND Image.IsPrimary = 1
		            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER) As Image
            FROM PagedArtists Artists
            FOR JSON PATH, INCLUDE_NULL_VALUES
        ) AS Artists
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
END;