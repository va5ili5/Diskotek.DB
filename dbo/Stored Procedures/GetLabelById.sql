CREATE PROCEDURE [dbo].[GetLabelById]
    @LabelId INT,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    DECLARE @TotalCount INT;

    -- Total number of releases for this label
    SELECT @TotalCount = COUNT(*)
    FROM Releases Release
    WHERE Release.LabelId = @LabelId;

    -- CTE to get the releases for this page
    ;WITH
        PagedReleases
        AS
        (
            SELECT Id, Title
            FROM Releases
            ORDER BY ReleaseDate
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY
        )

    SELECT
        Label.Id,
        Label.Name,
        Label.Description,
        LabelImage.ImageUrl,
        @TotalCount AS TotalCount,
        (
            SELECT
            PagedRelease.Id,
            PagedRelease.Title,
            Image.ImageUrl
        FROM PagedReleases PagedRelease
            INNER JOIN Images Image ON PagedRelease.Id = Image.EntityId AND Image.EntityType='Release' AND Image.IsPrimary = 1
        FOR JSON PATH
        ) AS Releases
    FROM Labels Label
        INNER JOIN Images LabelImage ON LabelImage.EntityId = @LabelId AND LabelImage.EntityType='Label' AND LabelImage.IsPrimary = 1
    WHERE Label.Id = @LabelId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
    END;