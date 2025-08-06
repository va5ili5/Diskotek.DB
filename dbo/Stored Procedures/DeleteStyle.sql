CREATE PROCEDURE [dbo].[DeleteStyle]
	@StyleId INT
AS
BEGIN
	SET NOCOUNT ON;

	-- Raise an error if @StyleId is NULL
	IF @StyleId IS NULL
	BEGIN
		RAISERROR('StyleId cannot be NULL', 16, 1);
		RETURN -1;
	END

	-- Raise an error if the style does not exist
	IF NOT EXISTS (SELECT 1
	FROM Styles
	WHERE Id = @StyleId)
	BEGIN
		RAISERROR('Style with the specified Id does not exist', 16, 1);
		RETURN -2;
	END

	-- Raise an error if the style is associated with any releases
	--IF EXISTS (SELECT 1 FROM ReleaseStyles WHERE StyleId = @StyleId)
	--BEGIN
	--	RAISERROR('Cannot delete style because it is associated with one or more releases', 16, 1);
	--	RETURN -3;
	--END

	-- Check if the style exists
	IF EXISTS (SELECT 1
	FROM Styles
	WHERE Id = @StyleId)
	BEGIN
		-- Delete records from ReleaseStyles table
		DELETE ReleaseStyles WHERE StyleId = @StyleId;

		-- Soft delete the style
		UPDATE Styles SET IsActive = 0 WHERE Id = @StyleId;
	END
END
