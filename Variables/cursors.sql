-- 1
CREATE TABLE FirstNumbers (number int)
DECLARE @index int = 1

WHILE @index <= 25
BEGIN
    INSERT INTO FirstNumbers VALUES (@index)
    SET @index += 1
END

DECLARE @rowCount int
DECLARE @currentRow int = 1
DECLARE @number float
DECLARE @factorial float
DECLARE @j int

DECLARE CursorFactorial CURSOR FOR SELECT number FROM FirstNumbers

SELECT @rowCount = COUNT(*) FROM FirstNumbers

OPEN CursorFactorial
FETCH NEXT FROM CursorFactorial INTO @number

WHILE @currentRow <= @rowCount
BEGIN
    SET @factorial = 1
    SET @j = 1

    WHILE @j <= @number
    BEGIN
        SET @factorial *= @j
        SET @j += 1
    END

    PRINT cast(@number AS varchar) + '! = ' + cast(@factorial AS varchar)

    SET @currentRow += 1
    FETCH NEXT FROM CursorFactorial INTO @number
END

CLOSE CursorFactorial
DEALLOCATE CursorFactorial


-- 2
CREATE TABLE SecondNumbers (number int)
DECLARE @secondIndex int = 3
WHILE @secondIndex <= 1000000
BEGIN
    INSERT INTO SecondNumbers VALUES (@secondIndex)
    SET @secondIndex += 1
END

DECLARE @rowCountSecond int
DECLARE @currentRowSecond int = 1
DECLARE @num int
DECLARE @k int
DECLARE @isPrime bit

DECLARE numCursor CURSOR FOR SELECT number FROM SecondNumbers
SELECT @rowCountSecond = COUNT(*) FROM SecondNumbers

OPEN PrimeNumCursor
FETCH NEXT FROM PrimeNumCursor INTO @num

WHILE @currentRowSecond <= @rowCountSecond
BEGIN
    SET @isPrime = 1
    SET @k = 2

    WHILE @k * @k <= @num
    BEGIN
        IF @num % @k = 0
        BEGIN
            SET @isPrime = 0
            BREAK
        END
        SET @k = @k + 1
    END

    IF @isPrime = 1 PRINT @num
    FETCH NEXT FROM PrimeNumCursor INTO @num
END

CLOSE PrimeNumCursor
DEALLOCATE PrimeNumCursor

-- 3. реализовать на языке Transact-SQL игровой автомат "однорукий бандит".
-- в начале игры есть некий стартовый капитал, например, 500 кредитов,
-- для начала игры необходимо нажать F5.
-- стоимость одного нажатия - 10 кредитов, при нажатии 
-- генерирутся три случайных числа (от 0 до 7).
-- если все три числа одинаковы, назначить приз (например, 50 кредитов),
-- если нет - то и приз никакой не назначается (просто теряем 10 кредитов),
-- кроме трёх случайных чисел показывать текущее состояние счёта, 
-- игра завершается поражением, если закончились деньги.
-- игра завершается победой, если выпало 777. 
-- выдать сообщение о победе или проигрыше, 
-- сбалансировать игру (можно сделать более 50 нажатий на F5 до проигрыша), 
-- для этого, скорее всего, придётся изменить ставки

DECLARE @credits INT = 500
DECLARE @cost INT = 10
DECLARE @balance INT = @credits
DECLARE @num1 INT
DECLARE @num2 INT
DECLARE @num3 INT

WHILE @balance >= @cost
BEGIN
    SET @balance -= @cost

    SET @num1 = CAST(RAND() * 7 + 1 AS INT)
    SET @num2 = CAST(RAND() * 7 + 1 AS INT)
    SET @num3 = CAST(RAND() * 7 + 1 AS INT)

    PRINT 'Result: ' + CHAR(10) + '|' + CAST(@num1 AS VARCHAR(10)) + ' ' + CAST(@num2 AS VARCHAR(10)) + ' ' + CAST(@num3 AS VARCHAR(10)) + '|'
    
    IF @num1 = @num2 AND @num2 = @num3
    BEGIN
        SET @balance += 50
        PRINT 'You won 50'
    END
    ELSE IF @num1 = 7 AND @num2 = 7 AND @num3 = 7
    BEGIN
        SET @balance += 777
        PRINT 'You win'
    END
    ELSE
    BEGIN
        PRINT 'Nothing'
        SET @balance -= @cost
    END

    PRINT 'Balance: ' + CAST(@balance AS VARCHAR(10))
    PRINT '-----------------------------------'
END

IF @balance < @cost
    PRINT 'You lose'


-- 4.проверить, содержит ли заданная строка одно из 
-- списка нехороших слов (например, 'viagra' или 'XXX').
-- регистр не учитывать, если содержит - пишем на экране 
-- "это спам/получи бан", если нет - пишем "это не спам",
-- нехорошие слова должны храниться в отдельной таблице
-- Создаем таблицу bad_words
CREATE TABLE BadWords (word varchar(255))
INSERT INTO BadWords VALUES ('viagra', 'XXX')

DECLARE @st varchar(255) = 'He bought viagra yesterday';
DECLARE @word varchar(255)
DECLARE @has_bad_words bit = 0

DECLARE BadWordsCursor CURSOR FOR SELECT word FROM BadWords

OPEN BadWordsCursor
FETCH NEXT FROM BadWordsCursor INTO @word

WHILE @@FETCH_STATUS = 0
BEGIN
    IF CHARINDEX(@word, @st) > 0
		SET @has_bad_words = 1

    FETCH NEXT FROM bw_cursor INTO @word
END

CLOSE BadWordsCursor
DEALLOCATE BadWordsCursor

IF @has_bad_words = 1 PRINT 'It is spam/get a ban'
ELSE PRINT 'All is ok'

-- 5.1
DECLARE @DataBaseName varchar(255)

DECLARE DataBaseCursor CURSOR FOR 
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb') 

OPEN DataBaseCursor
FETCH NEXT FROM DataBaseCursor INTO @DataBaseName

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @DataBaseName
    FETCH NEXT FROM DataBaseCursor INTO @DataBaseName
END

CLOSE DataBaseCursor
DEALLOCATE DataBaseCursor

-- 5.2
DECLARE @DataBaseName2 varchar(255)
DECLARE @position int = 1

DECLARE DataBaseCursor2 CURSOR FOR 
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')

OPEN DataBaseCursor2
FETCH NEXT FROM DataBaseCursor2 INTO @DataBaseName2

WHILE @@FETCH_STATUS = 0
BEGIN
	IF @position % 4 = 0 PRINT @DataBaseName2
	SET @position += 1
	FETCH NEXT FROM DataBaseCursor2 INTO @DataBaseName2
END

CLOSE DataBaseCursor2
DEALLOCATE DataBaseCursor2

-- 5.3 все базы, в названии которых содержится буква А
DECLARE @DataBaseName3 varchar(255)

DECLARE DataBaseCursor3 CURSOR FOR 
SELECT name 
FROM master.dbo.sysdatabases 
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb') AND name LIKE '%А%'

OPEN DataBaseCursor3
FETCH NEXT FROM DataBaseCursor3 INTO @DataBaseName3

WHILE @@FETCH_STATUS = 0
BEGIN
	PRINT @DataBaseName3
	FETCH NEXT FROM DataBaseCursor3 INTO @DataBaseName3
END

CLOSE DataBaseCursor3
DEALLOCATE DataBaseCursor3

-- 5.4
GO
CREATE OR ALTER PROCEDURE GetDBSize
@name SYSNAME,
@sizeMB DECIMAL(18,2) OUTPUT
AS
BEGIN
    SET @sizeMB = 0
    
    IF EXISTS (SELECT 1 FROM sys.databases WHERE name = @name)
    BEGIN
        SELECT @sizeMB = SUM(size * 8.0 / 1024)
        FROM sys.master_files
        WHERE type = 0 AND database_id = DB_ID(@name);
    END
END
GO

DECLARE @DataBaseName4 SYSNAME
DECLARE @size DECIMAL(18,2)

DECLARE DataBaseCursor4 CURSOR FOR 
SELECT name 
FROM sys.databases 
WHERE name NOT IN ('master', 'model', 'msdb', 'tempdb')

OPEN DataBaseCursor4
FETCH NEXT FROM DataBaseCursor4 INTO @DataBaseName4

WHILE @@FETCH_STATUS = 0
BEGIN
    EXEC GetDBSize @name = @DataBaseName4, @sizeMB = @size OUTPUT
    IF ISNULL(@size, 0) < 1 PRINT @DataBaseName4
    FETCH NEXT FROM DataBaseCursor4 INTO @DataBaseName4
END

CLOSE DataBaseCursor4
DEALLOCATE DataBaseCursor4