-- 1
SELECT name, price
FROM Product
WHERE date_of_delivery >= DATEADD(MONTH, -1, GETDATE())

-- 2
SELECT name, price
FROM Product
WHERE category = '������������ �������' AND producer <> 'Roshen'

-- 3
SELECT *
FROM Product
WHERE name LIKE '�%' AND category LIKE '%�%'

-- 4
SELECT *
FROM Product
WHERE name BETWEEN '�%' AND '�%'

-- 5
SELECT *
FROM Product
WHERE price < 50 AND date_of_delivery BETWEEN '2023-10-01' AND GETDATE() - 1

-- 6
SELECT *
FROM Product
WHERE category = '�������������� �������' AND quantity > 100

-- 7
SELECT *
FROM Product
WHERE price BETWEEN 100 AND 200
ORDER BY price ASC

-- 8
SELECT name
FROM Product
WHERE name LIKE '%�%�%�%' AND name NOT LIKE '%�%�%�%�%'

-- 9
DELETE FROM Product
WHERE LEN(name) = 5

-- 10
SELECT TOP 5 *
FROM Product
ORDER BY price DESC
