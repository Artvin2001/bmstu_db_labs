-- вывести количество команд по видам спорта (меньше 30 команд в вкаждом виде)
SELECT sport, COUNT(sport) as cnt
FROM teams
GROUP BY sport
HAVING COUNT(sport) < 30;