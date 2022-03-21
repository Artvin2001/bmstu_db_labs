CREATE TABLE IF NOT EXISTS teams
(
	id INT NOT NULL PRIMARY KEY,
	sport VARCHAR(30) DEFAULT 'secret',
	budget INT CHECK(budget >= 2000 and budget <= 10000),
	members INT CHECK(members >= 3 and members <= 200),
	medals INT CHECK(medals >= 1 and medals <= 20)
);

 -- COPY teams FROM 'C:/databases/lab1/team.csv' delimiter ',';
CREATE TABLE IF NOT EXISTS countries
(
	id INT NOT NULL PRIMARY KEY,
	name VARCHAR(45) DEFAULT 'secret',
	capital VARCHAR(25) DEFAULT 'secret',
	population INT CHECK(population >= 1 and population <= 300),
	president_name VARCHAR(40)
);

 -- COPY countries FROM 'C:/databases/lab1/country.csv' delimiter ',';
 CREATE TABLE IF NOT EXISTS treners
(
	id INT NOT NULL PRIMARY KEY,
	name VARCHAR(45) DEFAULT 'secret',
	age INT CHECK(age >= 18 and age <= 100),
	weight INT CHECK(weight >= 50 and weight <= 150),
	height INT CHECK(height >= 145 and height <= 210)
);

 -- COPY treners FROM 'C:/databases/lab1/treners.csv' delimiter ',';
 
 CREATE TABLE IF NOT EXISTS sportsmen
(
	id INT NOT NULL PRIMARY KEY,
	id_team INT,
    FOREIGN KEY (id_team) REFERENCES teams(id),
	id_trener INT,
	FOREIGN KEY (id_trener) REFERENCES treners(id),
	id_country INT,
    FOREIGN KEY (id_country) REFERENCES countries(id),
	age INT CHECK(age >= 18 and age <= 100),
	weight INT CHECK(weight >= 40 and weight <= 160)
);

 -- COPY sportsmen FROM 'C:/databases/lab1/sportsman.csv' delimiter ',';

