-- имена тренеров чей возраст больше 20 и возраст спортсмена которого они тренируют больше 80
SELECT name
FROM treners
WHERE age > 20 AND EXISTS
(
	SELECT id
	FROM sportsmen
	WHERE sportsmen.id_trener = treners.id AND sportsmen.age > 80
);