CREATE PROCEDURE [dbo].[UpsertImages]
    @Id INT = NULL,
    @EntityId INT = NULL,
    @EntityType INT = NULL,
    @ImageUrl NVARCHAR(MAX),
    @PublicId NVARCHAR(250),
    @AltText NVARCHAR (250),
    @IsPrimary BIT,
    @SortOrder INT,
    @UserId INT
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
                AltText = @AltText,
                PublicId = @PublicId,
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
            (ImageUrl, IsPrimary, AltText, PublicId, SortOrder, EntityId, EntityType, CreatedBy)
        VALUES
            (@ImageUrl, @IsPrimary, @AltText, @PublicId, @SortOrder, @EntityId, @EntityType, @UserId);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END