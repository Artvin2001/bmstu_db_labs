-- Скалярная функция: возвращает среднюю популяцию.
create or replace function AveragePopulation() returns int as 
'select avg(population) from countries;'
language sql;

select AveragePopulation() as avg_ppl;

-- Табличная функция: возвращает спортсмена по id
create or replace function GetSportsman(s_id int = 0)
returns sportsmen as
'select *
from sportsmen
where id = s_id;'
language sql;

select *
from GetSportsman(2);

-- Многооператорная табличная функция: возвращает тренеров с заданными 2 весовыми ограничениями
create or replace function get_trener_by_weight(first_rest int, second_rest int)
returns table
(
	out_id int,
	out_name varchar,
	out_age int, 
	out_height int
)
as
'
begin
    return query
	select id, name, age, height
	from treners
	where weight=first_rest;
	
	return query
	select id, name, age, height
	from treners
	where weight=second_rest;
end;
' language plpgsql;

select *
from get_trener_by_weight(62, 84);

-- Рекурсия
create or replace function recurs(in_id int)
returns table
(
	out_id int,
	out_id_team int,
	out_id_trener int,
	out_id_country int,
	out_age int,
	out_weight int
)
as
'
declare
   elem int;
begin
    return query
	select *
	from sportsmen
	where id = in_id;
	
	for elem in
	   select *
	   from sportsmen
	   where id_trener = in_id
	loop
	   return query
	   select *
	   from recurs(elem);
	end loop;
end;
' language plpgsql;

select *
from recurs(10);