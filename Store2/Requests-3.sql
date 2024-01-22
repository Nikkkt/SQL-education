-- 1
SELECT p.name AS Product, AVG(s.price) AS 'Average Price'
FROM Product p

JOIN Sale s ON p.id = s.id_product

GROUP BY p.id, p.name
HAVING AVG(s.price) > 50

-- 2
SELECT c.name AS Category, COUNT(p.id) AS Number, AVG(d.price) AS 'Average Price'
FROM Category c

LEFT JOIN Product p ON c.id = p.id_category
LEFT JOIN Delivery d ON p.id = d.id_product

GROUP BY c.id, c.name
HAVING AVG(d.price) > 300

-- 3
SELECT d.id_supplier, sup.name AS Supplier, MIN(d.price) AS 'Lowest cost'
FROM Delivery d

JOIN Supplier sup ON d.id_supplier = sup.id
WHERE d.date_of_delivery >= DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()) - 1, 0) AND d.date_of_delivery < DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)

GROUP BY d.id_supplier, sup.name
ORDER BY 'Lowest cost' ASC

-- 4
SELECT
    pr.id AS Producer, pr.name AS 'Producer name', adr.street AS 'Address street',
    adr.id_city AS 'Address city', c.id_region AS 'Address region', c.name AS City,
    r.name AS Region, COUNT(p.id) AS 'Products produced', SUM(s.price * s.quantity) AS 'Sales value'
FROM Producer pr

JOIN Address adr ON pr.id_address = adr.id
JOIN City c ON adr.id_city = c.id
JOIN Region r ON c.id_region = r.id
JOIN Product p ON pr.id = p.id_producer
JOIN Sale s ON p.id = s.id_product

GROUP BY pr.id, pr.name, adr.street, adr.id_city, c.id_region, c.name, r.name
HAVING SUM(s.price * s.quantity) BETWEEN 500 AND 20000
ORDER BY 'Sales value'

-- 5
SELECT c.id AS 'Category id', c.name AS 'Category name', COUNT(p.id) AS 'Number of products'
FROM Product p

JOIN Category c ON p.id_category = c.id
JOIN Producer pr ON p.id_producer = pr.id
JOIN Delivery d ON p.id = d.id_product

WHERE pr.name IN ('Ukrainian delivery', 'Romanian delivery', 'German food') AND d.price > 400
GROUP BY c.id, c.name
ORDER BY 'Number of products' DESC
