-- названия и столицы стран, где население больше населения любой страны, где столицм содержит "порт"
SELECT name, capital
FROM countries
WHERE population > ALL
(
	SELECT population
	FROM countries
	WHERE capital LIKE '%port%'
);