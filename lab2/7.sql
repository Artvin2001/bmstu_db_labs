-- выбрать наибольшую столицу в странах, где население больше 100
SELECT MAX(capital)
FROM countries
WHERE population > 100;