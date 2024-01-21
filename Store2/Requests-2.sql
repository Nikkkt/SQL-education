-- 1
SELECT p.name AS Product, pr.name AS Producer
FROM Product p
LEFT JOIN Producer pr ON p.id_producer = pr.id
ORDER BY Producer, Product

-- 2
SELECT c.name AS Category
FROM Category c
LEFT JOIN Product p ON c.id = p.id_category
WHERE p.id IS NULL

-- 3
SELECT r.name AS Region
FROM Region r

EXCEPT

SELECT r.name AS Region
FROM Region r
JOIN Producer p ON r.id = p.id_address

-- 4
SELECT c.name AS Category
FROM Category c

EXCEPT

SELECT c.name AS Category
FROM Category c
JOIN Product p ON c.id = p.id_category
JOIN Producer pr ON p.id_producer = pr.id
WHERE pr.name = 'Germany Product Factory'