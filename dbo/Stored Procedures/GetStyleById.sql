CREATE PROCEDURE [dbo].[GetStyleById]
	@StyleId UNIQUEIDENTIFIER
AS
BEGIN
    SET NOCOUNT ON;

	SELECT
	Id,
	Name,
	Description,
	(
		SELECT TOP 10 
		ReleaseStyle.ReleaseId,
		Release.Title,
		Image.ImageUrl
		FROM Releases Release
		INNER JOIN Images Image ON Release.Id = Image.ReleaseId AND Image.IsPrimary = 1
        INNER JOIN ReleaseStyles ReleaseStyle ON ReleaseStyle.StyleId = @StyleId AND ReleaseStyle.ReleaseId = Release.Id
		ORDER BY NEWID()
		FOR JSON PATH
	) As Releases
    FROM Styles WHERE Id = @StyleId
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
END;