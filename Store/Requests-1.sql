-- SELECT * 
-- FROM Product

USE Store
GO

-- 1
SELECT 'Хліб' AS Product, COALESCE(SUM((price - (price * discount / 100)) * quantity), 0) AS Revenue
FROM Product
WHERE category = 'Хлебобулочные изделия'
OR category NOT IN ('Хлебобулочные изделия', 'Молочные изделия')
ORDER BY Product

SELECT 'Молоко' AS Product, COALESCE(SUM((price - (price * discount / 100)) * quantity), 0) AS Revenue
FROM Product
WHERE category = 'Молочные изделия'
OR category NOT IN ('Хлебобулочные изделия', 'Молочные изделия')
ORDER BY Product

-- 2
SELECT *
FROM Product
WHERE (date_of_delivery = CAST(GETDATE() - 1 AS DATE) AND quantity > 10) OR
(date_of_delivery = CAST(GETDATE() AS DATE) AND quantity > 10)

-- 3
UPDATE Product
SET price = price * 0.95

-- 4
UPDATE Product
SET date_of_delivery = CAST(GETDATE() AS DATE)
WHERE date_of_delivery IS NULL

-- 5
DELETE FROM Product
WHERE quantity < 100 AND price > 70

-- 6
DELETE FROM Product
WHERE category = 'Алкогольные напитки' OR category = 'Кондитерские изделия'

-- 7
DELETE FROM Product
WHERE date_of_delivery < DATEADD(MONTH, -3, GETDATE())

-- 8
DELETE FROM Product
WHERE producer IS NULL OR producer = '' OR discount > 19