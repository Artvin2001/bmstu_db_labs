-- инстикруция select, использующая рекурсивное обобщенное табличное выражение
WITH RECURSIVE RecursiveTable(id, id_trener, age)
AS
(
	SELECT id, id_trener, age
	FROM sportsmen S
	WHERE S.id = 10
	UNION ALL
	SELECT S.id, S.id_trener, S.age
	FROM sportsmen S
	JOIN RecursiveTable rec ON S.id_trener = rec.id
)
SELECT *
FROM RecursiveTable;