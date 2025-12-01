CREATE PROCEDURE [dbo].[GetStyleById]
	@StyleId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		Id,
		Name,
		Description
	FROM Styles
	WHERE Id = @StyleId
END;