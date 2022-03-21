-- создаем таблицу с группировкой по населению
SELECT population, COUNT(population)
INTO firstLocTable
FROM countries
GROUP BY population;