CREATE PROCEDURE [dbo].[GetFormats]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id,
        Name
    FROM Formats
    WHERE IsActive = 1
END;