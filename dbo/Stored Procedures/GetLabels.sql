CREATE PROCEDURE [dbo].[GetLabels]
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Offset INT = (@PageNumber - 1) * @PageSize;
    DECLARE @TotalCount INT;

    -- Total count of all labels
    SELECT @TotalCount = COUNT(*)
    FROM Labels;

    -- CTE to get just the labels for this page
    ;WITH
        PagedLabels
        AS
        (
            SELECT Id, Name
            FROM Labels
            ORDER BY Name
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY
        )

    SELECT
        @TotalCount AS TotalCount,
        (
		SELECT
            Labels.Id,
            Labels.Name,
            (
            SELECT TOP 1
                Image.Id,
                Image.ImageUrl
            FROM Images Image
            WHERE Image.EntityId = Labels.Id AND Image.EntityType='Label' AND Image.IsPrimary = 1
            FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER) As Image
        FROM PagedLabels Labels
        FOR JSON PATH, INCLUDE_NULL_VALUES
        ) AS Labels
    FOR JSON PATH, INCLUDE_NULL_VALUES, WITHOUT_ARRAY_WRAPPER;
    END;