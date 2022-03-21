-- вывести информацию о тренере + дополнительный столбец с описанием возраста
SELECT name, age,
CASE
WHEN age <
(
	SELECT AVG(age)
	FROM treners
)
THEN 'Младший возраст'
ELSE 'Старший возраст'
END AS comment
FROM treners;