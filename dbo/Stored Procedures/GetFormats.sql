CREATE PROCEDURE [dbo].[GetFormats]
AS
BEGIN
    SET NOCOUNT ON;

	SELECT
	Id,
	Name
    FROM Formats
    FOR JSON PATH;
END;
