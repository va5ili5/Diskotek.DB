CREATE PROCEDURE [dbo].[DeleteArtist]
	@ArtistId INT
AS
BEGIN
	SET NOCOUNT ON;

	-- Raise an error if @ArtistId is NULL
	IF @ArtistId IS NULL
	BEGIN
		RAISERROR('ArtistId cannot be NULL', 16, 1);
		RETURN -1;
	END

	-- Raise an error if the artist does not exist
	IF NOT EXISTS (SELECT 1
	FROM Artists
	WHERE Id = @ArtistId)
	BEGIN
		RAISERROR('Artist with the specified Id does not exist', 16, 1);
		RETURN -2;
	END

	-- Raise an error if the format is associated with any releases
	--IF EXISTS (SELECT 1 FROM Releases WHERE FormatId = @FormatId)
	--BEGIN
	--	RAISERROR('Cannot delete format because it is associated with one or more releases', 16, 1);
	--	RETURN -3;
	--END

	-- Check if the artist is the sole artist on any release
	IF EXISTS (SELECT ReleaseId
	FROM ReleaseArtists
	WHERE ArtistId = @ArtistId
	GROUP BY ReleaseId
	HAVING COUNT(*) = 1 AND MAX(ArtistId) = @ArtistId)
	BEGIN
		RAISERROR('Cannot delete artist because they are the sole artist on one or more releases', 16, 1);
		RETURN -3;
	END
	-- Check if the format exists
	IF EXISTS (SELECT 1
	FROM Artists
	WHERE Id = @ArtistId)
	BEGIN
		-- Delete records from ReleaseArtists table
		DELETE ReleaseArtists WHERE ArtistId = @ArtistId;

		-- Soft delete the artist
		UPDATE Artists SET IsActive = 0 WHERE Id = @ArtistId;
	END
END
