--Триггер AFTER
select * into countries_temp
from countries;

-- Выводит оценку количества населения при insert
create or replace function raiting_of_population()
returns trigger
as
'
begin
    if new.population < 100 then
	    RAISE NOTICE ''% has little population'', new.name;
	else
	    RAISE NOTICE ''% has big population'', new.name;
	end if;
	return new;
end;
' language plpgsql;

create trigger population_trigger
after insert on countries_temp
for row
execute procedure raiting_of_population();

insert into countries_temp (name, capital, population, president_name)
values ('tranving', 'trionity', 80, 'lily names');

--удаление
drop trigger population_trigger
on countries_temp;

-- Триггер INSTEAD OF
--Заменяет удаление на мягкое удаление(в name ставится none)
create view country_new as
select *
from countries
where id < 20;

select * from country_new;

create or replace function del_country()
returns trigger
as
'
begin
    update country_new
	set name = ''none''
	where country_new.id = old.id;
	return new;
end;
' language plpgsql;

create trigger del_country_trigger
instead of delete on country_new
for row
execute procedure del_country();

delete from country_new
where id = 2;

select * from country_new;