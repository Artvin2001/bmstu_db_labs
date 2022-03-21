--1 Из таблиц базы данных, созданной в первой
-- лабораторной работе, извлечь данные в JSON.
--row_to_json - возвращает кортеж в виде объекта JSON.
select row_to_json(c) result from countries c;
select row_to_json(tm) result from teams tm;
select row_to_json(t) result from treners t;
select row_to_json(s) result from sportsmen s;

-- 2 Выполнить загрузку и сохранение JSON файла в таблицу.
-- Созданная таблица после всех манипуляций должна соответствовать таблице
-- базы данных, созданной в первой лабораторной работе.

CREATE TABLE IF NOT EXISTS sportsmen_copy
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

-- Копируем данные из таблицы sportsmen в файл sportsmen.json

copy
(
select row_to_json(s) result from sportsmen s
)
to 'C:/databases/lab5/sportsmen.json';

-- Создаем таблицу, которая будет содержать json кортежи.
create table if not exists
sportsmen_import(doc json);

copy sportsmen_import
from 'C:/databases/lab5/sportsmen.json';

select *
from sportsmen import;

-- Данный запрос преобразует данные из строки в формате json
-- В табличное предстваление. Т.е. разворачивает объект из json в табличную строку.
select *
from sportsmen_import,
json_populate_record(null::sportsmen_copy, doc);

-- Преобразование одного типа в другой null::users_copy
select * 
from sportsmen_import,
json_populate_record(cast(null as sportsmen_copy), doc);

-- Загружаем в таблицу сконвертированные данные из формата json из таблицы users_import.
insert into sportsmen_copy
select id, id_team, id_trener, id_country, age, weight
from sportsmen_import,
json_populate_record(null::sportsmen_copy, doc);

select *
from sportsmen_copy;

--3 Создать таблицу, в которой будет атрибут(-ы) с типом JSON, или
-- добавить атрибут с типом JSON к уже существующей таблице.
-- Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE
create table if not exists winners
(
	data json
);

-- Вставляем  json строку.
-- json_object - формирует объект JSON.
insert into winners
select * 
from json_object('{id, id_team, sport}', '{87, 91, boating}');

select *
from winners;

-- 4

-- 1 Извлечь XML/JSON фрагмент из XML/JSON документа
create table if not exists sportsmen_id_age
(
	id int,
	age int
);

select * from sportsmen_import,
json_populate_record(null::sportsmen_id_age, doc);

select id, age
from sportsmen_import, 
json_populate_record(null::sportsmen_id_age, doc)
where age > 70;

select * from sportsmen_import;

select doc->'id' as id, doc->'age' as age
from sportsmen_import;

-- 2: Извлечь значения конкретных узлов или атрибутов XML/JSON документа
select doc->'id' as id, doc->'age' as age
from sportsmen_import;

--3
-- подготовка таблицы jsonb
create table equipment(doc jsonb);

INSERT INTO equipment 
VALUES ('{"id":0, "equipment": {"price":"middle", "quality":"high"}}');

INSERT INTO equipment 
VALUES ('{"id":1, "equipment": {"price":"low", "quality":"middle"}}');

CREATE OR REPLACE FUNCTION get_equipment(u_id jsonb)
RETURNS VARCHAR AS '
    SELECT CASE
               WHEN count.cnt > 0
                   THEN ''true''
               ELSE ''false''
               END AS comment
    FROM (
             SELECT COUNT(doc -> ''id'') cnt
             FROM equipment
             WHERE doc -> ''id'' @> u_id
         ) AS count;
' LANGUAGE sql;

select get_equipment('1');

--4  Изменить XML/JSON документ

select * from equipment;

SELECT doc || '{"id": 33}'::jsonb
FROM equipment;

-- Перезаписываем значение json поля.
UPDATE equipment
SET doc = doc || '{"id": 33}'::jsonb
WHERE (doc->'id')::INT = 3;

--5 Разделить XML/JSON документ на несколько строк по узлам
create table if not exists
friends(doc json);

INSERT INTO friends VALUES ('[{"fr1_id": 0, "fr2_id": 1},
  {"fr1_id": 2, "fr2_id": 2}, {"fr1_id": 3, "fr2_id": 1}]');

SELECT * FROM friends;

SELECT jsonb_array_elements(doc::jsonb)
FROM friends;

--процедура по названии страны выписывает отдельно записи типа тренер команда в json

create table if not exists
trener_team_json(doc json);

create or replace procedure trener_country_json
(
	in_id int
)
as
'
declare
   elem record;
begin
   for elem in
      select id_trener, id_team
	  from sportsmen
	  where id = in_id
	loop
	   RAISE NOTICE ''id_trener = %, id_team = %'', elem.id_trener, elem.id_team;
	end loop;
	
end
' language plpgsql;

create or replace procedure trener_country_json
(
	in_id int
)
as
'
declare
   elem record;
begin
   for elem in
      select id_trener, id_team
	  from sportsmen
	  where id = in_id
	loop
	   RAISE NOTICE ''id_trener = %, id_team = %'', elem.id_trener, elem.id_team;
	   insert into trener_team_json values (row_to_json(elem));
	end loop;
	
end
' language plpgsql;

create or replace procedure trener_country_json
(
	in_id int
)
as
'
declare
   elem record;
begin
   for elem in
      select id_trener, id_team
	  from sportsmen
	  where id = in_id
	loop
	   RAISE NOTICE ''id_trener = %, id_team = %'', elem.id_trener, elem.id_team;
	   RAISE NOTICE ''%'', row_to_json(elem);
	   insert into trener_team_json values (row_to_json(elem));
	end loop;
	
	execute ''select *
	from trener_team_json'';
	
end
' language plpgsql;

call trener_country_json(3);

create or replace procedure trener_country_json
(
	in_id int
)
as
'
declare
   elem record;
begin
   for elem in
      select id_trener, id_team
	  from sportsmen
	  where id = in_id
	loop
	   RAISE NOTICE ''%'', row_to_json(elem);
	end loop;	
end
' language plpgsql;

call trener_country_json(3);

create or replace procedure trener_country_json
(
	in_name char
)
as
'
declare
   elem record;
begin
   for elem in
      select id_trener, id_team
	  from sportsmen
	  join (
	     select id, name
		 from countries
		 where name = in_name
	  ) as S on sportsmen.id_country = S.id
	loop
	   RAISE NOTICE ''%'', row_to_json(elem);
	end loop;	
end
' language plpgsql;

call trener_country_json('Macao');

create or replace procedure trener_country_json
(
	in_name char
)
as
'
declare
   elem record;
begin
   for elem in
      select id_trener, id_team
	  from sportsmen
	  join (
	     select id, name
		 from countries
		 where name = in_name
	  ) as S on sportsmen.id_country = S.id
	loop
	   RAISE NOTICE ''%'', row_to_json(elem);
	end loop;	
end
' language plpgsql;

call trener_country_json('Spain');