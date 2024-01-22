-- 1
DECLARE @num1 FLOAT
DECLARE @num2 FLOAT
DECLARE @num3 FLOAT
DECLARE @arithmetic_mean FLOAT

SET @num1 = 10.5
SET @num2 = 15.3
SET @num3 = 20.7

SET @arithmetic_mean = (@num1 + @num2 + @num3) / 3

PRINT @arithmetic_mean

-- 2
DECLARE @current TIME

SET @current = CONVERT(TIME, GETDATE())

IF @current >= '00:00' AND @current < '12:00' 
	PRINT 'Good morning!'
ELSE IF @current >= '12:00' AND @current < '18:00' 
	PRINT 'Good afternoon!'
ELSE 
	PRINT 'Good evening!'

-- 3
DECLARE @ticket INT = 123006

DECLARE @firstThree INT
DECLARE @lastThree INT

SET @firstThree = (@ticket / 100000 % 10) + (@ticket / 10000 % 10) + (@ticket / 1000 % 10)

SET @lastThree = (@ticket / 100 % 10) + (@ticket / 10 % 10) + (@ticket % 10)

IF @firstThree = @lastThree
    PRINT 'The ticket is lucky'
ELSE
    PRINT 'The ticket is not lucky'