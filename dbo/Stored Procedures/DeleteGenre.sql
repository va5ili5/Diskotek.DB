CREATE PROCEDURE [dbo].[DeleteGenre]
	@GenreId UNIQUEIDENTIFIER
AS
BEGIN
	SET NOCOUNT ON;

	-- Raise an error if @GenreId is NULL
	IF @GenreId IS NULL
	BEGIN
		RAISERROR('GenreId cannot be NULL', 16, 1);
		RETURN -1;
	END

	-- Raise an error if the genre does not exist
	IF NOT EXISTS (SELECT 1
	FROM Genres
	WHERE Id = @GenreId)
	BEGIN
		RAISERROR('Genre with the specified Id does not exist', 16, 1);
		RETURN -2;
	END

	---- Raise an error if the genre is associated with any releases
	--IF EXISTS (SELECT 1 FROM ReleaseGenres WHERE GenreId = @GenreId)
	--BEGIN
	--	RAISERROR('Cannot delete genre because it is associated with one or more releases', 16, 1);
	--	RETURN -3;
	--END

	-- Check if the genre exists
	IF EXISTS (SELECT 1
	FROM Genres
	WHERE Id = @GenreId)
	BEGIN
		-- Delete records from ReleaseGenres table
		DELETE ReleaseGenres WHERE GenreId = @GenreId;

		-- Soft delete the genre
		UPDATE Genres SET IsActive = 0 WHERE Id = @GenreId;
	END
END
