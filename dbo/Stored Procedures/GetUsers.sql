CREATE PROCEDURE [dbo].[GetUsers]
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN

    SET NOCOUNT ON;

    SELECT
        users.Id,
        users.Username,
        users.Firstname,
        users.Lastname,
        users.Email,
        users.IsActive
    FROM Users users
    ORDER BY users.Username DESC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    -- Total number of releases for this artist
    SELECT COUNT(*)
    FROM Users totalUsers
END;