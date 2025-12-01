CREATE PROCEDURE [dbo].[LoadReferenceData]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT Id, Name
    FROM Artists
    ORDER BY Name

    SELECT Id, Name
    FROM Labels
    ORDER BY Name

    SELECT Id, Name
    FROM Formats
    ORDER BY Name

    SELECT Id, Name
    FROM Countries
    ORDER BY Name

    SELECT Id, Name
    FROM Genres
    ORDER BY Name

    SELECT Id, Name
    FROM Styles
    ORDER BY Name

END;
