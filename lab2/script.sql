-- 1:
SELECT name, height
FROM treners
WHERE age >= 30 AND age <= 50 AND weight < 80;
-- 2:
SELECT name
FROM countries
WHERE population BETWEEN 100 AND 200;

-- 3:
SELECT sport, budget
FROM teams
WHERE sport LIKE '%polo%';

-- 4:
SELECT name, capital
FROM countries
WHERE population IN (80, 98, 100);

-- 5:
SELECT name
FROM treners
WHERE age > 20 AND EXISTS
(
	SELECT id
	FROM sportsmen
	WHERE sportsmen.id_trener = treners.id AND sportsmen.age > 80
);

-- 6:
SELECT name, capital
FROM countries
WHERE population > ALL
(
	SELECT population
	FROM countries
	WHERE capital LIKE '%port%'
);

-- 7:
SELECT MAX(capital)
FROM countries
WHERE population > 100;

-- 8:
SELECT id, age,
(
	SELECT name
	FROM treners
	WHERE treners.id = sportsmen.id_trener 
) AS trener_name
FROM sportsmen;

-- 9:
SELECT name, age, 
CASE(height)
WHEN
(
	SELECT MAX(height)
	FROM treners
)
THEN 'Наибольший рост'
WHEN
(
	SELECT MIN(height)
	FROM treners
)
THEN 'Наименьший рост'
ELSE 'Средний рост'
END AS comment
FROM treners;

-- 10:
SELECT name, age,
CASE
WHEN age <
(
	SELECT AVG(age)
	FROM treners
)
THEN 'Младший возраст'
ELSE 'Старший возраст'
END AS comment
FROM treners

-- 11:
SELECT population, COUNT(population)
INTO firstLocTable
FROM countries
GROUP BY population;

-- 12:
-- вывести всех спортсменов, которые занимаются шахматами или плаванием
SELECT sportsmen.id
FROM sportsmen
JOIN (
	SELECT id
	FROM teams
	WHERE sport = 'chess' or sport = 'swimming'
) AS T ON sportsmen.id_team = T.id;

-- 13:

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
-- 14:
SELECT sport, COUNT(sport) as cnt
FROM teams
GROUP BY sport;

-- 15:
SELECT sport, COUNT(sport) as cnt
FROM teams
GROUP BY sport
HAVING COUNT(sport) < 30;

-- 16:
INSERT INTO teams(id, sport, budget, members, medals)
VALUES(1000, 'curling', 3000, 6, 1);

-- 17:
INSERT INTO teams (id, sport, budget, members, medals)
SELECT id * 10 as ID, sport as SPORT, budget + 1 as BUDGET, members AS MEMBERS, medals AS MEDALS
FROM teams
WHERE id > 100 AND id < 120;

-- 18:
UPDATE treners
SET age = age + 3
WHERE id = 3;

-- 19:
UPDATE treners
SET age =(SELECT MAX(age)
		 FROM sportsmen)
WHERE id = 5;

-- 20:
DELETE 
FROM teams
WHERE id = 1000;

-- 21:
DELETE 
FROM sportsmen
WHERE id_team in
(
	SELECT id
	FROM teams
	WHERE sport = 'chess'
);

-- 22:
WITH capitalstable
AS
(
	SELECT c.name, c.capital FROM countries AS c
)
SELECT * FROM capitalstable

-- 23:
WITH RECURSIVE RecursiveTable(id, id_trener, age)
AS
(
	SELECT id, id_trener, age
	FROM sportsmen S
	WHERE S.id = 1
	UNION ALL
	SELECT S.id, S.id_trener, S.age
	FROM sportsmen S
	JOIN RecursiveTable rec ON S.id_trener = rec.id
)
SELECT *
FROM RecursiveTable;

-- 24:
SELECT id, name, age, MAX(height) OVER(PARTITION BY age) max
FROM treners
ORDER BY id;

-- 25:
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