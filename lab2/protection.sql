SELECT sportsmen.id
FROM sportsmen
JOIN (
	SELECT id
	FROM teams
	WHERE sport = 'chess'
) AS T ON sportsmen.id_team = T.id
WHERE age BETWEEN 18 AND 25;