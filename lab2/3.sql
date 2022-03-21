-- вид спорта и бюджет команд, где в названии спорта присутствует поло
SELECT sport, budget
FROM teams
WHERE sport LIKE '%polo%';