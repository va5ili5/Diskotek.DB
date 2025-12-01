
CREATE PROCEDURE [dbo].[UpsertUser]
    @Id INT = NULL,
    @UserName NVARCHAR(50),
    @FirstName NVARCHAR(100),
    @LastName NVARCHAR(100),
    @Email NVARCHAR(100),
    @IsActive BIT = 1,
    @UserId INT
AS
BEGIN
    SET NOCOUNT ON;
    -- Check if the user already exists
    IF EXISTS (SELECT 1
    FROM Users
    WHERE Id = @Id)
    BEGIN
        -- Update existing user
        UPDATE Users
        SET Username = @UserName,
            Firstname = @FirstName,
            Lastname = @LastName,
            Email = @Email,
			IsActive = @IsActive,
			UpdatedBy = @UserId,
			UpdatedAt = SYSUTCDATETIME()
        WHERE Id = @Id;
        SELECT @Id AS Id;
    END
    ELSE
    BEGIN
        -- Insert new user
        INSERT INTO Users
            (UserName, FirstName, LastName, Email, IsActive, CreatedBy)
        VALUES
            (@UserName, @FirstName, @LastName, @Email, @IsActive, @UserId);
        SELECT SCOPE_IDENTITY() AS Id;
    END
END