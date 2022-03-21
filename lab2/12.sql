-- вывести всех спортсменов, которые занимаются шахматами или плаванием
SELECT sportsmen.id
FROM sportsmen
JOIN (
	SELECT id
	FROM teams
	WHERE sport = 'chess' or sport = 'swimming'
) AS T ON sportsmen.id_team = T.id;