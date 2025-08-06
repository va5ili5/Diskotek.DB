CREATE PROCEDURE [dbo].[GetGenres]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id,
        Name
    FROM Genres
    FOR JSON PATH;
    END;
