update teams
set sport = 'chess', budget = 4000, members = 12, medals = 5
where id > 999;

-- удаление дублей
WITH cte(row_nu, id, sport, budget, members, medals)
AS
(
	SELECT ROW_NUMBER() OVER (PARTITION BY teams.budget, teams.sport, teams.members, teams.medals 
							  ORDER BY teams.budget, teams.sport, teams.members, teams.medals), 
	id, sport, budget, members, medals
	FROM teams
)

SELECT *
FROM cte
WHERE row_nu = 1;