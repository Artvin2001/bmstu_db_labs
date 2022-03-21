-- вывести максимальный рост по группам возраста
SELECT id, name, age, MAX(height) OVER(PARTITION BY age) max
FROM treners
ORDER BY id;