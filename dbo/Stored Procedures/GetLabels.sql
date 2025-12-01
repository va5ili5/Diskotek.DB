CREATE PROCEDURE [dbo].[GetLabels]
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        label.Id,
        label.Name,
        labelImage.ImageUrl
    FROM Labels label
	OUTER APPLY(
		SELECT TOP 1
            image.ImageUrl
        FROM Images image
        WHERE image.EntityId = label.Id AND image.EntityType='Label' AND image.IsPrimary = 1
        ORDER BY image.Id
	) labelImage
    WHERE label.IsActive = 1
    ORDER BY label.Name DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    -- Total number of releases for this label
    SELECT COUNT(*)
    FROM Labels labels
    WHERE labels.IsActive = 1
END;