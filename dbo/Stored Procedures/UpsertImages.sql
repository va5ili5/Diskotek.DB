CREATE PROCEDURE [dbo].[UpsertImages]
	@Id UNIQUEIDENTIFIER,
	@EntityId UNIQUEIDENTIFIER = NULL,
    @EntityType NVARCHAR(20) = NULL,
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
                EntityId = @EntityId,
                EntityType = @EntityType
            WHERE Id = @Id;
        END
        ELSE
        BEGIN
            -- Insert new image
            INSERT INTO Images (ImageUrl, IsPrimary, SortOrder, EntityId, EntityType)
            VALUES (@ImageUrl, @IsPrimary, @SortOrder, @EntityId, @EntityType);
        END
END
