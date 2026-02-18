CREATE PROCEDURE [dbo].[GetLabelById]
    @LabelId INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        Id,
        Name,
        Profile,
		labelImage.ImageUrl
    FROM Labels
    OUTER APPLY(
		SELECT TOP 1
			image.ImageUrl
		FROM Images image
		WHERE image.EntityId = @LabelId AND image.EntityType=3 AND image.IsPrimary = 1
	) labelImage
    WHERE Id = @LabelId
END;