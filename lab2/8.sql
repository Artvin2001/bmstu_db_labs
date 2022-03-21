-- вывести информацию о спортсменах + имя тренера
SELECT id, age,
(
	SELECT name
	FROM treners
	WHERE treners.id = sportsmen.id_trener 
) AS trener_name
FROM sportsmen;