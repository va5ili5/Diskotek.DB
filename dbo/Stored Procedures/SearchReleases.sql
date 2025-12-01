CREATE PROCEDURE [dbo].[SearchReleases]
    @Title NVARCHAR(MAX) = NULL,
    @Description NVARCHAR(MAX) = NULL,
    @CatalogNumber NVARCHAR(MAX) = NULL,
	@ArtistIds NVARCHAR(MAX) = NULL, -- comma separated list
    @GenreIds NVARCHAR(MAX) = NULL, -- comma separated list
    @StyleIds NVARCHAR(MAX) = NULL, -- comma separated list
    @FormatId INT = NULL,
    @CountryId INT = NULL,
    @LabelId INT = NULL,
    @SortBy NVARCHAR(50) = 'Title', -- 'Title', 'Year', etc.
    @SortDirection NVARCHAR(4) = 'ASC', -- 'ASC' or 'DESC'
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
	SET NOCOUNT ON;
	;WITH ArtistFilter AS (
        SELECT TRY_CAST([value] AS INT) AS ArtistId -- converts each numeric string to an integer, null if the conversion fails
        FROM STRING_SPLIT(@ArtistIds, ',') -- create a table with all ids
        WHERE ISNUMERIC([value]) = 1  -- Filter out non-numeric values
    ),
    GenreFilter AS (
        SELECT TRY_CAST([value] AS INT) AS GenreId
        FROM STRING_SPLIT(@GenreIds, ',')
        WHERE ISNUMERIC([value]) = 1
    ),
    StyleFilter AS (
        SELECT TRY_CAST([value] AS INT) AS StyleId
        FROM STRING_SPLIT(@StyleIds, ',')
        WHERE ISNUMERIC([value]) = 1
    )
    SELECT DISTINCT r.*
    INTO #FilteredReleases
        FROM Releases r
        LEFT JOIN ReleaseArtists ra ON r.Id = ra.ReleaseId
        LEFT JOIN ReleaseGenres rg ON r.Id = rg.ReleaseId
        LEFT JOIN ReleaseStyles rs ON r.Id = rs.ReleaseId
        WHERE
        (@Title IS NULL OR r.Title = @Title)
        AND
        (@Description IS NULL OR r.Description = @Description)
         AND 
        (@CatalogNumber IS NULL OR r.CatalogNumber = @CatalogNumber)
        AND
        (
                @GenreIds IS NULL 
                OR EXISTS (SELECT 1 FROM GenreFilter gf WHERE gf.GenreId = rg.GenreId)
            )
        AND (
                @StyleIds IS NULL 
                OR EXISTS (SELECT 1 FROM StyleFilter sf WHERE sf.StyleId = rs.StyleId)
            )
            AND
            (@FormatId IS NULL OR r.FormatId = @FormatId)
            AND
            (@CountryId IS NULL OR r.CountryId = @CountryId)
            AND
            (
                @ArtistIds IS NULL 
                OR EXISTS (SELECT 1 FROM ArtistFilter af WHERE af.ArtistId = ra.ArtistId)
            )
    
    SELECT 
        fr.Id, fr.Title, fr.Description, fr.ReleaseDate, fr.CatalogNumber, l.Name AS LabelName, STRING_AGG(a.Name, ', ') AS ArtistNames, STRING_AGG(g.Name, ', ') AS GenreNames
    FROM #FilteredReleases fr
    INNER JOIN Labels l ON fr.LabelId = l.Id
    INNER JOIN ReleaseArtists ra ON fr.Id = ra.ReleaseId
    INNER JOIN Artists a ON ra.ArtistId = a.Id
    INNER JOIN ReleaseGenres rg ON fr.Id = rg.ReleaseId
    INNER JOIN Genres g ON rg.GenreId = g.Id
    GROUP BY fr.Id, fr.Title, fr.Description, fr.ReleaseDate, fr.CatalogNumber, l.Name
    ORDER BY
        CASE WHEN @SortBy = 'Title' AND @SortDirection = 'ASC' THEN fr.Title END ASC
    OFFSET (@PageNumber - 1) * @PageSize ROWS
    FETCH NEXT @PageSize ROWS ONLY;

    -- Total number of releases for this artist
    SELECT COUNT(*)
    FROM #FilteredReleases f
    WHERE f.IsActive = 1
END;