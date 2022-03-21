-- изменить возраст какого-то тренера на самый большой возраст спортсмена
UPDATE treners
SET age =(SELECT MAX(age)
		 FROM sportsmen)
WHERE id = 5;