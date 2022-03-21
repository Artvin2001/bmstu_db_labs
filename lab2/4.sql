-- названия, столицы  и население стран, где население равно > 90
SELECT name, capital, population
FROM countries
WHERE id IN
(
	SELECT id
	FROM countries
	WHERE population > 90
);