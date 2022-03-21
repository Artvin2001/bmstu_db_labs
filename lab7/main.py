import psycopg2
from peewee import *
from py_linq import *
import json
from psycopg2 import *

db = PostgresqlDatabase('postgres', user='postgres', password='Artvin2001', host='localhost', port=5432)

class BaseModel(Model):
    class Meta:
        database = db
        primary_key = False

class Trener_cl(BaseModel):
    id = IntegerField(column_name = 'id', primary_key = True)
    name = CharField(column_name = 'name')
    age = IntegerField(column_name = 'age')
    weight = IntegerField(column_name='weight')
    height = IntegerField(column_name='height')

    class Meta:
        table_name = 'treners'

class Team_cl(BaseModel):
    id = IntegerField(column_name = 'id', primary_key = True)
    sport = CharField(column_name = 'sport')
    budget = IntegerField(column_name = 'budget')
    members = IntegerField(column_name='members')
    medals = IntegerField(column_name='medals')

    class Meta:
        table_name = 'teams'

class Country_cl(BaseModel):
    id = IntegerField(column_name = 'id', primary_key = True)
    name = CharField(column_name = 'name')
    capital = CharField(column_name = 'capital')
    population = IntegerField(column_name='population')
    president_name = CharField(column_name='president_name')

    class Meta:
        table_name = 'countries'


class Sportsman_cl(BaseModel):
    id = IntegerField(column_name = 'id', primary_key = True)
    id_team = ForeignKeyField(Team_cl, field= 'id')
    id_trener = ForeignKeyField(Trener_cl, field='id')
    id_country = ForeignKeyField(Country_cl, field='id')
    age = IntegerField(column_name='age')
    weight = IntegerField(column_name='weight')

    class Meta:
        table_name = 'sportsmen'


class trener():
    # Структура полностью соответствует таблице treners.
    id = int()
    name = str()
    age = int()
    weight = int()
    height = int()

    def __init__(self, id, name, age, weight, height):
        self.id = id
        self.name = name
        self.age = age
        self.weight = weight
        self.height = height

    def get(self):
        return {'id': self.id, 'name': self.name, 'age': self.age,
                'weight': self.weight, 'height': self.height}

    def __str__(self):
        return f"{self.id:<2} {self.name:<20} {self.age:<5} {self.weight:<5} {self.height:<5}"

def create_treners(file_name):
    # Содает коллекцию объектов.
    # Загружая туда данные из файла file_name.
    file = open(file_name, 'r')
    treners = list()

    for line in file:
        arr = line.split(',')
        arr[0], arr[2], arr[3], arr[4] = int(
            arr[0]), int(arr[2]), int(arr[3]), int(arr[4])
        treners.append(trener(*arr).get())
    #print(treners)

    return treners
def request_1(treners):
	# Тренеры старше 40 лет отсортированные по id.
	result = treners.where(lambda x: x['age'] >= 40).order_by(lambda x: x['name']).select(lambda x: {x['name'], x['age']})
	return result

#агрегатная функция count
#количество тренеров выше 170
def request2(treners):
    result = treners.count(lambda x: x['height'] > 170)
    return result

#union
def request3(treners):
    age = Enumerable([{treners.min(lambda x: x['age']), treners.max(lambda x: x['age'])}])
    weight = Enumerable([{treners.min(lambda x: x['weight']), treners.max(lambda x: x['weight'])}])
    result = Enumerable(age).union(Enumerable(weight), lambda x: x)
    return result

#group by
def request4(treners):
	# Группировка по возрасту.
	result =treners.group_by(key_names=['age'], key=lambda x: x['age']).select(lambda g: {'key age': g.key.age, 'count treners': g.count()})
	return result

#join
def request_5(treners):
    spr = Enumerable([{'id': 0, 'id_trener': 1},
                        {'id': 1, 'id_trener': 605},
                        {'id': 2, 'id_trener': 967}])

    result = treners.join(spr, lambda o_key: o_key['id'], lambda i_key: i_key['id_trener'])

    return result

def task1():
    treners = Enumerable(create_treners('treners.csv'))
    print('\n1.Тренеры старше 40 лет отсортированные по id:')
    for elem in request_1(treners):
        print(elem)
    print('\n')

    print('\n2.Количество тренеров выше 170: ', request2(treners))
    print('\n')

    print('\n3.Минимальный и максимальный возраст и вес: ', request2(treners))
    for elem in request3(treners):
        print(elem)
    print('\n')

    print("[Количество тренеров каждого возраста]\n")
    for elem in request4(treners):
        print(elem)
    print('\n')

    print("[Соединение спортсменов и их тренеров]\n")
    for elem in request_5(treners):
        print(elem)
    print('\n')

def connection():
    con = psycopg2.connect(database="postgres", user="postgres", password="Artvin2001", host="localhost", port="5432")
    print("База данных успешно открыта")
    return con

def output_json(array):
	for elem in array:
		print(json.dumps(elem.get()))

def read_tbl_json(cur, count = 20):
    cur.execute("select * from treners_import")
    rows = cur.fetchmany(count)
    arr = list()
    for elem in rows:
        temp = elem[0]
        arr.append(trener(temp['id'], temp['name'], temp['age'], temp['weight'], temp['height']))

    print(*arr, sep='\n')
    return arr

def update_json(array, age):
    for elem in array:
        if (elem.age == age):
            print('ДО обновления: ', elem.age)
            elem.age += 1
            print('ПОСЛЕ обновления: ', elem.age)
            print(json.dumps(elem.get()))

def add_trener(treners, trener):
    treners.append(trener)
    output_json(treners)

def task2():
    con = connection()
    cur = con.cursor()

    # 1. Чтение из XML/JSON документа.
    print("Чтение из JSON файла первых 20ти строк\n")
    treners_arr = read_tbl_json(cur)
    # 2. Обновление XML/JSON документа.
    print("\nОбновление JSON файла: возраст у  тренера с заданным возрастом увеличиваетс на 1\n")
    update_json(treners_arr, 55)
    # 3. Запись (Добавление) в XML/JSON документ.
    print("\nДобавление в JSON файл информации о новом тренере\n")
    add_trener(treners_arr, trener(22, 'Lane Nels', 54, 63, 167))
    cur.close()
    con.close()


def req_1():
    print("[Однотабличный запрос на выборку]\n")
    print("Команды с количеством медалей > 2 (первые 5 записей)\n")

    selection = Team_cl.select().where(Team_cl.medals > 2).limit(5).order_by(Team_cl.id)
    result = selection.dicts().execute()

    for elem in result:
        print(elem['id'], elem['sport'], elem['budget'], elem['members'], elem['medals'])

def req_2():
    print("\n[Многотабличный запрос на выборку]\n")

    selection = Team_cl.select(Team_cl.id, Team_cl.medals, Trener_cl.name, Trener_cl.age).join(Trener_cl, on= (Team_cl.medals + 20 == Trener_cl.age)).limit(10)
    result = selection.dicts().execute()
    for elem in result:
        print("Данные: ", elem['id'], elem['medals'], elem['name'], elem['age'])

def print_last_five_teams():
	# Вывод последних 5-ти записей.
	query = Team_cl.select().limit(5).order_by(Team_cl.id.desc())
	for elem in query.dicts().execute():
		print(elem)
	print()

def add_team(_id, _sport, _budget, _members, _medals):
    Team_cl.create(id = _id, sport = _sport, budget = _budget, members = _members, medals = _medals)

    print("Добавлен новая команда с id = ", _id)

def update_team(_id, _sport):
    team_upd = Team_cl.get(Team_cl.id == _id)
    old_sport = team_upd.sport
    team_upd.sport = _sport
    team_upd.save()

    print("Спорт команды с id = ", _id, "изменен с ", old_sport, "на ", _sport)

def delete_team(_id):
    team_del = Team_cl.get(Team_cl.id == _id)
    team_del.delete_instance()

    print("\nУдалена команда с id = ", _id)

def req_3():
    print("Три запроса на добавление, изменение и удаление данных в базе данных")
    print("\nДобавление команды")
    print_last_five_teams()
    add_team(1002, 'chess', 3460, 20, 5)
    print_last_five_teams()

    print("\nИзменение вида спорта команды")
    update_team(4, 'swimming')

    print("\nУдаление команды")
    delete_team(1002)
    print_last_five_teams()


def req_4():
    print("\nПолучение доступа к данным, выполняя только хранимую процедуру\n")
    cur = db.cursor()
    print('До:\n')
    print_last_five_teams()
    cur.execute("call update_team_const(%s, %s);", ('997', '2500'))
    db.commit()
    print('После:\n')
    print_last_five_teams()
    cur.close()

def task3():
    req_1()
    req_2()
    req_3()
    req_4()

answer = int(input("Номер задания: "))

if answer == 1:
    task1()
elif answer == 2:
    task2()
elif answer == 3:
    task3()
