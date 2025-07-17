CREATE PROCEDURE [dbo].[UpsertImages]
	@Id UNIQUEIDENTIFIER,
	@ReleaseId UNIQUEIDENTIFIER = NULL,
    @ArtistId UNIQUEIDENTIFIER = NULL,
    @LabelId UNIQUEIDENTIFIER = NULL,
    @ImageUrl NVARCHAR(2048),
    @IsPrimary BIT,
    @SortOrder INT
AS
BEGIN
    SET NOCOUNT ON;
        -- Check if the genre already exists
        IF EXISTS (SELECT 1 FROM Images WHERE Id = @Id)
        BEGIN
            -- -- Update existing image
            UPDATE Images
            SET 
                ImageUrl = @ImageUrl,
                IsPrimary = @IsPrimary,
                SortOrder = @SortOrder,
                ReleaseId = @ReleaseId,
                LabelId = @LabelId,
                ArtistId = @ArtistId
            WHERE Id = @Id;
        END
        ELSE
        BEGIN
            -- Insert new image
            INSERT INTO Images (ImageUrl, IsPrimary, SortOrder, ReleaseId, LabelId, ArtistId)
            VALUES (@ImageUrl, @IsPrimary, @SortOrder, @ReleaseId, @LabelId, @ArtistId);
        END
END
