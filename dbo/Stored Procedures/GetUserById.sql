CREATE PROCEDURE [dbo].[GetUserById]
	@UserId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		Id,
		Username,
		Firstname,
		Lastname,
		Email,
		IsActive
	FROM Users
	WHERE Id = @UserId
END;