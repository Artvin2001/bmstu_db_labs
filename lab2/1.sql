-- имя и рост всех тренеров в возрасте от 30 до 50 и весом меньше 80
SELECT name, height
FROM treners
WHERE age >= 30 AND age <= 50 AND weight < 80;