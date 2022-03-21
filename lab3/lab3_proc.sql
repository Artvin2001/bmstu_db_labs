-- Хранимая процедура с параметрами
-- Меняет бюджет по id
select * into temp teams_copy
from teams;

select * 
from teams_copy;

create or replace procedure update_team
(
	in_id int,
	in_budget int
)
as
'
begin
    update teams_copy
	set budget = in_budget
	where id = in_id;
end;
' language plpgsql;

call update_team(2, 6000);

select *
from teams_copy
order by id;

create or replace procedure update_team_const
(
	in_id int,
	in_budget int
)
as
'
begin
    update teams
	set budget = in_budget
	where id = in_id;
end;
' language plpgsql;

--Хранимая процедура с курсором
-- Меняет количество медалей на заданное по id
select *
into team_tmp_cursor
from teams_copy;

create or replace procedure proc_cursor
(
	in_id int,
	in_medals int
)
as
'
declare
   my_cursor cursor for
       select *
	   from team_tmp_cursor
	   where id = in_id;
   tmp team_tmp_cursor;
begin
    open my_cursor;
	loop
	    fetch my_cursor
		into tmp;
		exit when not found;
		
		update team_tmp_cursor
		set medals = in_medals
		where id = in_id;
	end loop;
end;
'language plpgsql;

call proc_cursor(1, 3);

select *
from team_tmp_cursor
order by id;

-- Хранимая процедура доступа к метаданным
create or replace procedure meta(name varchar)
as
'
    declare
	   my_cursor cursor for
	       select column_name, data_type
		   from information_schema.columns
		   where table_name = name;
	   tmp record;
begin
    open my_cursor;
	loop
	    fetch my_cursor
		into tmp;
		exit when not found;
		raise notice ''column name = %; data type = %'', tmp.column_name, tmp.data_type;
	end loop;
end;
' language plpgsql;


call meta('teams');

-- Хранимая процедура с рекурсией
--Разыгрывается сумма

create or replace procedure recursive_proc
(
	res inout int,
	in_id int,
	coef float default 1
)
as
'
declare
    elem int;
begin
    if coef <= 0 then
	    coef = 1;
	end if;
	
	res = res + 1000 * coef;
	
	RAISE NOTICE ''id = %, res = %, coef = %'', in_id, res, coef;
	
	for elem in
	    select *
		from sportsmen
		where id_trener = in_id
		loop
		   call recursive_proc(res, elem, coef - 0.1);
		end loop;
end;
' language plpgsql;

call recursive_proc(0, 8);

