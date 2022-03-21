import psycopg2
from tkinter import *
from tkinter import messagebox as mb

def create_list_box(rows, title, count=15):
    root = Tk()

    root.title(title)
    root.resizable(width=False, height=False)

    size = (count + 3) * len(rows[0]) + 1

    list_box = Listbox(root, width=size, height=22,
                       font="monospace 10", bg="bisque", highlightcolor='bisque', selectbackground='#59405c', fg="#59405c")

    list_box.insert(END, "█" * size)

    for row in rows:
        string = (("█ {:^" + str(count) + "} ") * len(row)).format(*row) + '█'
        list_box.insert(END, string)

    list_box.insert(END, "█" * size)

    list_box.grid(row=0, column=0)

    root.configure(bg="bisque")

    root.mainloop()

def realization_task1(cur, members):
    #выводим кол-во команд с заданным кол-вом участников
    members = int(members.get())

    cur.execute(" \
        SELECT count(members) \
        FROM teams \
        WHERE members = %s", (members,))
        #GROUP BY members", (members,))

    row = cur.fetchone()

    mb.showinfo(title="Результат",
                message=f"Кол-во команд с количеством участников {members} составляет: {row[0]}")

def realization_task4(cur, table_name, con):
    table_name = table_name.get()
    print(table_name)

    try:
        cur.execute("SELECT * FROM {0}".format(table_name))
    except:
        # Откатываемся.
        con.rollback()
        mb.showerror(title="Ошибка", message="Такой таблицы нет!")
        return

    rows = [(elem[0],) for elem in cur.description]

    create_list_box(rows, "Задание 4", 17)

def realization_task6(cur, user_id):
    user_id = user_id.get()
    print(user_id)
    try:
        user_id = int(user_id)
    except:
        mb.showerror(title="Ошибка", message="Введите число!")
        return

    cur.execute("SELECT * FROM GetSportsman(%s)", (user_id,))

    rows = cur.fetchone()

    create_list_box((rows,), "Задание 6", 17)

def realization_task7(cur, param, con):
    try:
        in_id = int(param[0].get())
        in_budget = int(param[1].get())
    except:
        mb.showerror(title="Ошибка", message="Некорректные параметры!")
        return


    # Выполняем запрос.
    try:
        cur.execute("CALL update_team_const(%s, %s);",
               (in_id, in_budget))
    except:
        mb.showerror(title="Ошибка", message="Некорректный запрос!")
        # Откатываемся.
        con.rollback()
        return

    # Фиксируем изменения.
    # Т.е. посылаем команду в бд.
    # Метод commit() помогает нам применить изменения,
    # которые мы внесли в базу данных
    con.commit()

    mb.showinfo(title="Информация!", message="Данные обновлены!")

def realization_task10(cur, param, con):
    try:
        trener_id = int(param[0].get())
        name = param[1].get()
        age = int(param[2].get())
        weight = int(param[3].get())
        height = int(param[4].get())
    except:
        mb.showerror(title="Ошибка", message="Некорректные параметры!")
        return


    cur.execute(
        "SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME='treners'")

    if not cur.fetchone():
        mb.showerror(title="Ошибка", message="Таблица не создана!")
        return

    try:
        cur.execute("INSERT INTO treners VALUES(%s, %s, %s, %s, %s)",
                    (trener_id, name, age, weight, height))
    except:
        mb.showerror(title="Ошибка!", message="Ошибка запроса!")
        # Откатываемся.
        con.rollback()
        return

    # Фиксируем изменения.
    con.commit()

    mb.showinfo(title="Информация!", message="Тренер добавлен!")

def task1(cur, con = None):
    #выполнить скалярный запрос
    root_1 = Tk()

    root_1.title('Задание 1')
    root_1.geometry("300x200")
    root_1.configure(bg="bisque")
    root_1.resizable(width=False, height=False)

    Label(root_1, text="  Введите количество участников:", bg="bisque").place(
        x=75, y=50)
    members = Entry(root_1)
    members.place(x=75, y=85, width=150)

    b = Button(root_1, text="Выполнить",
               command=lambda arg1=cur, arg2=members: realization_task1(arg1, arg2),  bg="orange")
    b.place(x=75, y=120, width=150)

    root_1.mainloop()


def task2(cur, con = None):
    #сколько стран представляет спортсмен 
    cur.execute("\
    select sportsmen.id, countries.name , treners.name \
    from sportsmen \
    join countries \
    on countries.id = id_country \
    join treners on treners.id = id_trener")

    rows = cur.fetchall()
    #print(rows)
    create_list_box(rows, "Задание 2")

def task3(cur, con = None):
    #запрос с отв и конными ф-ми
    #добавлен столбец с максимальным ростом в возрасте
    cur.execute("\
    WITH n_table (id, nickname, age, sum) \
    AS \
    ( \
        SELECT id, name, age, MAX(height) OVER(PARTITION BY age) max \
        FROM treners \
        ORDER BY id \
    ) \
    SELECT * FROM n_table;")
    rows = cur.fetchall()
    create_list_box(rows, "Задание 3")


def task4(cur, con):
    #запрос к метаданным 
    root_1 = Tk()

    root_1.title('Задание 4')
    root_1.geometry("300x200")
    root_1.configure(bg="bisque")
    root_1.resizable(width=False, height=False)

    Label(root_1, text="Введите название таблицы:", bg="bisque").place(
        x=65, y=50)
    name = Entry(root_1)
    name.place(x=75, y=85, width=150)

    b = Button(root_1, text="Выполнить",
               command=lambda arg1=cur, arg2=name: realization_task4(arg1, arg2, con),  bg="orange")
    b.place(x=75, y=120, width=150)

    root_1.mainloop()

def task5(cur, con = None):
    #вызвать скалярную функцию из 3 лр
    cur.execute("select AveragePopulation() as avg_ppl;")

    row = cur.fetchone()

    mb.showinfo(title="Результат",
                message=f"Средняя популяция: {row[0]}")

def task6(cur, con = None):
    #Вызвать многооператорную или табличную функцию
    root = Tk()

    root.title('Задание 1')
    root.geometry("300x200")
    root.configure(bg="bisque")
    root.resizable(width=False, height=False)

    Label(root, text="  Введите id:", bg="bisque").place(
        x=75, y=50)
    user_id = Entry(root)
    user_id.place(x=75, y=85, width=150)

    b = Button(root, text="Выполнить",
               command=lambda arg1=cur, arg2=user_id: realization_task6(arg1, arg2),  bg="orange")
    b.place(x=75, y=120, width=150)

    root.mainloop()


def task7(cur, con=None):
    #Вызвать хранимую процедуру
    root = Tk()

    root.title('Задание 7')
    root.geometry("300x400")
    root.configure(bg="bisque")
    root.resizable(width=False, height=False)

    names = ["идентификатор",
             "новый бюджет"]

    param = list()

    i = 0
    for elem in names:
        Label(root, text=f"Введите {elem}:",
              bg="bisque").place(x=70, y=i + 25)
        elem = Entry(root)
        i += 50
        elem.place(x=70, y=i, width=150)
        param.append(elem)

    b = Button(root, text="Выполнить",
               command=lambda: realization_task7(cur, param, con),  bg="orange")
    b.place(x=70, y=300, width=150)

    root.mainloop()

def task8(cur, con = None):
    #Вызвать системную функцию или процедуру
    cur.execute(
        "SELECT current_database(), current_user;")
    current_database, current_user = cur.fetchone()
    mb.showinfo(title="Информация",
                message=f"Имя текущей базы данных:\n{current_database}\nИмя пользователя:\n{current_user}")

def task9(cur, con):
    #Создать таблицу в базе данных, соответствующую тематике БД
    cur.execute(" \
        CREATE TABLE IF NOT EXISTS sportsmen_countries \
        ( \
            sportsman_id INT, \
            FOREIGN KEY(sportsman_id) REFERENCES sportsmen(id), \
            country_id INT, \
            FOREIGN KEY(country_id) REFERENCES countries(id), \
            prestige INT \
        ) ")

    con.commit()

    mb.showinfo(title="Информация",
                message="Таблица успешно создана!")

def task10(cur, con):
    #Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY
    root = Tk()

    root.title('Задание 10')
    root.geometry("400x500")
    root.configure(bg="bisque")
    root.resizable(width=False, height=False)

    names = ["идентификатор тренера",
             "имя тренера",
             "возраст тренера",
             "вес тренера",
             "рост тренера"]

    param = list()

    i = 0
    for elem in names:
        Label(root, text=f"Введите {elem}:",
              bg="bisque").place(x=70, y=i + 25)
        elem = Entry(root)
        i += 50
        elem.place(x=115, y=i, width=150)
        param.append(elem)

    b = Button(root, text="Выполнить",
               command=lambda: realization_task10(cur, param, con),  bg="orange")
    b.place(x=115, y=300, width=150)

    root.mainloop()

def info_show():
    global root
    info = Toplevel(root)
    info_txt = "Условия задачи: \n\
    1. Выполнить скалярный запрос;\n \
    2. Выполнить запрос с несколькими соединениями(JOIN);\n\
    3.Выполнить запрос с ОТВ(CTE) и оконными функциями;\n\
    4. Выполнить запрос к метаданным;\n\
    5. Вызвать скалярную функцию(написанную в третьей лабораторной работе);\n\
    6. Вызвать многооператорную или табличную функцию(написанную в третьей лабораторной работе);\n\
    7. Вызвать хранимую процедуру(написанную в третьей лабораторной работе); \n\
    8. Вызвать системную функцию или процедуру; \n\
    9. Создать таблицу в базе данных, соответствующую тематике БД; \n\
    10. Выполнить вставку данных в созданную таблицу с использованием инструкции INSERT или COPY."

    label1 = Label(info, text=info_txt, font="Verdana 14", bg="bisque")
    label1.pack()

def menu(cur, con):
    global root
    root.title('Лабораторная работа №6')
    root.geometry("1000x650")
    root.configure(bg="bisque")
    root.resizable(width=False, height=False)
    main_menu = Menu(root)
    root.configure(menu=main_menu)
    third_item = Menu(main_menu, tearoff=0)
    main_menu.add_cascade(label="Меню",
                          menu=third_item, font="Verdana 10")
    third_item.add_command(label="Показать меню",
                           command=info_show, font="Verdana 12")

    tasks = [task1, task2, task3, task4, task5, task6,
             task7, task8, task9, task10]
    for (index, i) in enumerate(range(55, 550, 110)):
        button = Button(text="Задание " + str(index + 1), width=35, height=2,
                        command=lambda a=index: tasks[a](cur, con),  bg="orange")
        button.place(x=290, y=i)

        button = Button(text="Задание " + str(index + 6), width=35, height=2,
                        command=lambda a=index + 5: tasks[a](cur, con),  bg="orange")
        button.place(x=610, y=i)  # anchor="center")
    root.mainloop()

try:
    con = psycopg2.connect(
        database = "postgres",
        user = "postgres",
        password = "Artvin2001",
        host = "localhost",
        port = "5432")
except:
    print("Ошибка подключения к базе данных")
    #выход
print("База данных открыта")

cur = con.cursor()

root = Tk()
menu(cur, con)

cur.close()
con.close()
    
