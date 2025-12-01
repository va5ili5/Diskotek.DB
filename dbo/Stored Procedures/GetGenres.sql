CREATE PROCEDURE [dbo].[GetGenres]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id,
        Name
    FROM Genres
    WHERE IsActive = 1
END;
