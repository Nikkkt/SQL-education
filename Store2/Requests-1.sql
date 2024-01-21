-- 1
SELECT p.name AS Product, c.name AS Category
FROM Product p

JOIN Supplier s ON p.id_producer = s.id
JOIN Category c ON P.id_category = c.id

WHERE s.name IN ('Ukrainian delivery', 'Royal quality')

-- 2
SELECT p.name AS Product, s.name AS Supplier
FROM Product p

JOIN Supplier s ON p.id_producer = s.id
LEFT JOIN Category c ON p.id_category = c.id

WHERE CHARINDEX('A', p.name) = 0 AND CHARINDEX('K', p.name) = 0 AND CHARINDEX('M', p.name) = 0 AND c.name <> 'Dairy'

-- 3
SELECT p.name AS Product, c.name AS Category, s.name AS Supplier, co.name AS Country
FROM Product p

JOIN Category c ON p.id_category = c.id
JOIN Supplier s ON p.id_producer = s.id
JOIN Producer pr ON s.id_address = pr.id_address
JOIN City ci ON pr.id_address = ci.id
JOIN Region r ON ci.id_region = r.id
JOIN Country co ON r.id_country = co.id
JOIN Delivery d ON p.id = d.id_product

WHERE d.date_of_delivery BETWEEN '2023-01-19' AND GETDATE() AND co.name NOT IN ('Ukraine', 'Poland') AND d.price < 1000

-- 4
SELECT p.name AS Product, c.name AS Category, s.name AS Supplier, co.name AS Country, sa.price AS Price, sa.quantity AS Quantity, sa.date_of_sale AS 'Date'
FROM Product p

JOIN Category c ON p.id_category = c.id
JOIN Supplier s ON p.id_producer = s.id
JOIN Producer pr ON s.id_address = pr.id_address
JOIN City ci ON pr.id_address = ci.id
JOIN Region r ON ci.id_region = r.id
JOIN Country co ON r.id_country = co.id
JOIN Sale sa ON p.id = sa.id_product

WHERE (C.name = 'Confectionery' OR C.name = 'Non-Alcoholic') AND Sa.quantity > 5

-- 5
SELECT p.name AS Product, s.name AS Supplier, c.name AS Category, d.date_of_delivery AS Date, SUM(D.quantity * D.price) AS 'Value'
FROM Delivery AS d

JOIN Product p ON d.id_product = p.id
JOIN Supplier s ON d.id_supplier = s.id
JOIN Category c ON p.id_category = c.id

WHERE s.name IN ('"Royal quality"', 'Romanian delivery', 'Ukrainian delivery')
GROUP BY p.name, s.name, c.name, d.date_of_delivery
ORDER BY Product ASC

-- 6
SELECT p.name AS Product, pr.name AS Producer, a.street + ', ' + c.name + ', ' + co.name AS Address, cat.name AS Category, s.date_of_sale AS Date, s.quantity * s.price AS Cost
FROM Sale s

JOIN Product p ON s.id_product = p.id
JOIN Producer pr ON p.id_producer = pr.id
JOIN Address a ON pr.id_address = a.id
JOIN City c ON a.id_city = c.id
JOIN Region r ON c.id_region = r.id
JOIN Country co ON r.id_country = co.id
JOIN Category cat ON p.id_category = cat.id

WHERE pr.name NOT IN ('Odesa FPP', 'Wroclaw PF')
ORDER BY Cost DESC