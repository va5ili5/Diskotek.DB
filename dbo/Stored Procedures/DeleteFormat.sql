CREATE PROCEDURE [dbo].[DeleteFormat]
	@FormatId UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	-- Raise an error if @FormatId is NULL
	IF @FormatId IS NULL
	BEGIN
		RAISERROR('FormatId cannot be NULL', 16, 1);
		RETURN -1;
	END

	-- Raise an error if the format does not exist
	IF NOT EXISTS (SELECT 1
	FROM Formats
	WHERE Id = @FormatId)
	BEGIN
		RAISERROR('Format with the specified Id does not exist', 16, 1);
		RETURN -2;
	END

	-- Raise an error if the format is associated with any releases
	--IF EXISTS (SELECT 1 FROM Releases WHERE FormatId = @FormatId)
	--BEGIN
	--	RAISERROR('Cannot delete format because it is associated with one or more releases', 16, 1);
	--	RETURN -3;
	--END

	-- Check if the format exists
	IF EXISTS (SELECT 1
	FROM Formats
	WHERE Id = @FormatId)
	BEGIN
		-- Update release formats to NULL
		UPDATE Releases
		SET FormatId = NULL
		WHERE FormatId = @FormatId;

		-- Soft delete the format
		UPDATE Formats SET IsActive = 0 WHERE Id = @FormatId;
	END
END
