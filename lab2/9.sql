-- вывести информацию о тренере + дополнительный столбец с описанием роста
SELECT name, age, 
CASE(height)
WHEN
(
	SELECT MAX(height)
	FROM treners
)
THEN 'Наибольший рост'
WHEN
(
	SELECT MIN(height)
	FROM treners
)
THEN 'Наименьший рост'
ELSE 'Средний рост'
END AS comment
FROM treners;