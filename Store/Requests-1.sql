-- SELECT * 
-- FROM Product

USE Store
GO

-- 1
-- Посчитать возможную выручку за хлеб и молоко (с учётом скидок на эти товары) 
-- если нет товаров с такими названиями, взять 2 любых других названия
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
-- Получить информацию о том, каких товаров вчера и сегодня доставили более 10 штук
SELECT *
FROM Product
WHERE (date_of_delivery = CAST(GETDATE() - 1 AS DATE) AND quantity > 10) OR
(date_of_delivery = CAST(GETDATE() AS DATE) AND quantity > 10)

-- 3
-- Уменьшить цены на все товары на 5%
UPDATE Product
SET price = price * 0.95

-- 4
-- Проставить сегодняшнюю дату доставки на все товары, в которых такая информация отсутствует
UPDATE Product
SET date_of_delivery = CAST(GETDATE() AS DATE)
WHERE date_of_delivery IS NULL

-- 5
-- Удалить все товары, количество которых меньше 100, а цена более 70 гривен
DELETE FROM Product
WHERE quantity < 100 AND price > 70

-- 6
-- Удалить все алкогольные напитки и кондитерские изделия
DELETE FROM Product
WHERE category = 'Алкогольные напитки' OR category = 'Кондитерские изделия'

-- 7
-- Удалить все товары, дата доставки которых была более 3 месяцев назад от текущей даты
DELETE FROM Product
WHERE date_of_delivery < DATEADD(MONTH, -3, GETDATE())

-- 8
-- Удалить все товары, информация о производителе которых неизвестна, или же если скидка на эти товары более 19%
DELETE FROM Product
WHERE producer IS NULL OR producer = '' OR discount > 19