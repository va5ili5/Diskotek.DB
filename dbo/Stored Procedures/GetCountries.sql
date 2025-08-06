CREATE PROCEDURE [dbo].[GetCountries]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        Id,
        Name
    FROM Countries
    FOR JSON PATH;
    END;
