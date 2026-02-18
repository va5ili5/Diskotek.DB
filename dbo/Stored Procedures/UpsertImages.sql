CREATE PROCEDURE [dbo].[UpsertImages]
    @Id INT,
    @EntityId INT = NULL,
    @EntityType INT = NULL,
    @ImageUrl NVARCHAR(2048),
    @IsPrimary BIT,
    @SortOrder INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Check if the genre already exists
    IF EXISTS (SELECT 1
    FROM Images
    WHERE Id = @Id)
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

        SELECT @Id AS Id;
    END
        ELSE
        BEGIN
        -- Insert new image
        INSERT INTO Images
            (ImageUrl, IsPrimary, SortOrder, EntityId, EntityType)
        VALUES
            (@ImageUrl, @IsPrimary, @SortOrder, @EntityId, @EntityType);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END
