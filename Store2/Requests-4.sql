-- 1
SELECT pr.name AS 'Producer', ROUND((COUNT(p.id) * 100.0 / (SELECT COUNT(id) FROM Product)), 2) AS 'Percentage'
FROM Producer pr
LEFT JOIN Product p ON pr.id = p.id_producer
GROUP BY pr.name

-- 2
SELECT pr.name AS Producer
FROM Producer pr
WHERE EXISTS (
        SELECT 1
        FROM Product p
        JOIN Sale s ON p.id = s.id_product
        WHERE p.id_producer = pr.id
        GROUP BY p.id_producer
        HAVING COUNT(s.id) > 1
    )

-- 3
SELECT p.name AS product_name, (
        SELECT COUNT(s.id)
        FROM Sale s
        WHERE s.id_product = p.id
    ) AS sales_count

FROM Product p

WHERE (
        SELECT COUNT(s.id)
        FROM Sale s
        WHERE s.id_product = p.id
    ) = (
        SELECT MAX(sales_count)
        FROM (
            SELECT COUNT(s.id) AS sales_count
            FROM Product prod
            JOIN Sale s ON prod.id = s.id_product
            GROUP BY prod.id
        ) AS sq
    )

-- 4
SELECT name
FROM Supplier
WHERE id NOT IN (
    SELECT id_supplier
    FROM Delivery
    WHERE id_product IN (
        SELECT id
        FROM Product
        WHERE name = 'Yoghurt'
    )
)

-- 5
SELECT p.id, p.name
FROM Producer p
WHERE p.id_address IN (
        SELECT a.id
        FROM Address a, City c, Region r, Country co
        WHERE a.id_city = c.id AND c.id_region = r.id AND r.id_country = co.id AND co.id = (
			SELECT CoSup.id
            FROM Supplier S, Address ASup, City CSup, Region RSup, Country CoSup
            WHERE S.id_address = ASup.id AND ASup.id_city = CSup.id AND CSup.id_region = RSup.id AND RSup.id_country = CoSup.id AND S.name = 'Ukrainian delivery'
        )
    )

-- 6
SELECT p.id, p.name
FROM Producer p
WHERE (
        SELECT SUM(quantity)
        FROM Product pr
        WHERE pr.id_producer = p.id
    ) > (
        SELECT SUM(quantity)
        FROM Product Prd
        WHERE Prd.id_producer = (
                SELECT id
                FROM Producer
                WHERE name = 'Wroclaw PF'
            )
    )

-- 7
SELECT sd, COUNT(*) AS 'Total sales'
FROM (
	SELECT CONVERT(DATE, date_of_sale) AS sd
    FROM Sale
    WHERE CONVERT(DATE, date_of_sale) >= '2023-11-15'
    ) AS sq
GROUP BY sd
ORDER BY sd DESC