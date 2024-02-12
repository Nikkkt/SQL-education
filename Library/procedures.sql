-- 1
CREATE PROCEDURE BooksCounts
AS
BEGIN
    DECLARE @BookCounts TABLE (
        Department VARCHAR(300),
        GroupName VARCHAR(300),
        BooksCount INT
    )

    INSERT INTO @BookCounts (Department, GroupName, BooksCount)
    SELECT d.name AS Department, g.name AS GroupName, COUNT(bt.id_book) AS BooksCount
    FROM S_Cards bt
    JOIN [Group] g ON bt.id = g.id
    JOIN Department d ON g.id_department = d.id
    GROUP BY d.name, g.name

    SELECT * FROM @BookCounts
END

-- 2
CREATE PROCEDURE BooksByCriteries
    @AuthorFirstName NVARCHAR(100),
    @AuthorLastName NVARCHAR(100),
    @Subject NVARCHAR(100),
    @Category NVARCHAR(100),
    @SortField INT,
    @SortDirection NVARCHAR(10)
AS
BEGIN
    DECLARE @Query NVARCHAR(MAX)

    SET @Query = 
	'SELECT BookID, Title, AuthorFirstName, AuthorLastName, Subject, Category
    FROM Books
    WHERE 1 = 1'

    IF @AuthorFirstName IS NOT NULL SET @Query = @Query + ' AND AuthorFirstName = @ParamAuthorFirstName'
    IF @AuthorLastName IS NOT NULL SET @Query = @Query + ' AND AuthorLastName = @ParamAuthorLastName'
    IF @Subject IS NOT NULL SET @Query = @Query + ' AND Subject = @ParamSubject'
    IF @Category IS NOT NULL SET @Query = @Query + ' AND Category = @ParamCategory'

    SET @Query = @Query + ' ORDER BY '

    IF @SortField = 1 SET @Query = @Query + 'BookID'
    ELSE IF @SortField = 2 SET @Query = @Query + 'Title'
    ELSE IF @SortField = 3 SET @Query = @Query + 'AuthorFirstName'
    ELSE IF @SortField = 4 SET @Query = @Query + 'AuthorLastName'
    ELSE IF @SortField = 5 SET @Query = @Query + 'Subject'
    ELSE IF @SortField = 6 SET @Query = @Query + 'Category'

    IF @SortDirection = 'ASC' SET @Query = @Query + ' ASC'
    ELSE IF @SortDirection = 'DESC' SET @Query = @Query + ' DESC'

    EXEC sp_executesql @Query,
        N'@ParamAuthorFirstName NVARCHAR(100),
          @ParamAuthorLastName NVARCHAR(100),
          @ParamSubject NVARCHAR(100),
          @ParamCategory NVARCHAR(100)',
        @ParamAuthorFirstName = @AuthorFirstName,
        @ParamAuthorLastName = @AuthorLastName,
        @ParamSubject = @Subject,
        @ParamCategory = @Category
END

-- 3
CREATE PROCEDURE LibrarianBookCounts
AS
BEGIN
    SELECT l.id, l.first_name, l.last_name, COUNT(DISTINCT c.id_book) AS BooksIssued
    FROM Librarian l
    LEFT JOIN (
        SELECT id_librarian, id_book FROM S_Cards
        UNION ALL
        SELECT id_librarian, id_book FROM T_Cards
    ) c ON l.id = c.id_librarian
    GROUP BY l.id, l.first_name, l.last_name
    ORDER BY BooksIssued DESC
END

-- 4
CREATE PROCEDURE StudentWithMostBooks
AS
BEGIN
    SET NOCOUNT ON
    SELECT TOP 1 s.first_name, s.last_name
    FROM Student s
    JOIN (
        SELECT id_student, COUNT(*) AS BookCount
        FROM S_Cards
        GROUP BY id_student
    ) AS b ON s.id = b.id_student
    ORDER BY b.BookCount DESC
END

-- 5
CREATE PROCEDURE TotalBooksBorrowed
AS
BEGIN
    SET NOCOUNT ON

    DECLARE @TotalBooksBorrowed INT

    SELECT @TotalBooksBorrowed = COUNT(*)
    FROM S_Cards

    SELECT @TotalBooksBorrowed += COUNT(*)
    FROM T_Cards

    SELECT @TotalBooksBorrowed AS TotalBooksBorrowed
END