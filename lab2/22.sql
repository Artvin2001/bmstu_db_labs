-- инстикруция select, использующая простое обобщенное табличное выражение
WITH capitalstable
AS
(
	SELECT c.name, c.capital FROM countries AS c
)
SELECT * FROM capitalstable