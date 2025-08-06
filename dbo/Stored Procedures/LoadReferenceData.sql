CREATE PROCEDURE [dbo].[LoadReferenceData]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        (
            SELECT Id, Name
        FROM Formats
        ORDER BY Name
        FOR JSON PATH
        ) AS Formats,
        (
            SELECT Id, Name
        FROM Countries
        ORDER BY Name
        FOR JSON PATH
        ) AS Countries,
        (
            SELECT Id, Name
        FROM Genres
        ORDER BY Name
        FOR JSON PATH
        ) AS Genres,
        (
            SELECT Id, Name
        FROM Styles
        ORDER BY Name
        FOR JSON PATH
        ) AS Styles
    FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;
    END;
