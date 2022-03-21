-- вывести информацию о спортсмене с наибольшим id тренера среди тренеров с наибольшим возрастом
SELECT sportsmen.id, age
FROM sportsmen
WHERE id_trener = 
(SELECT MAX(id)
FROM
(SELECT id
				   FROM treners
				   GROUP BY id
				   HAVING SUM(age) = ( SELECT MAX(age)
									  FROM treners
			   )
) AS H)