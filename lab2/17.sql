-- вставка в таблицу нескольких строк
INSERT INTO teams (id, sport, budget, members, medals)
SELECT id * 10 as ID, sport as SPORT, budget + 1 as BUDGET, members AS MEMBERS, medals AS MEDALS
FROM teams
WHERE id > 100 AND id < 120;