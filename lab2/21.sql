-- удалить всех спортсменов, которые играют в шахматы
DELETE 
FROM sportsmen
WHERE id_team in
(
	SELECT id
	FROM teams
	WHERE sport = 'chess'
);