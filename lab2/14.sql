-- вывести количество команд по видам спорта
SELECT sport, COUNT(sport) as cnt
FROM teams
GROUP BY sport;