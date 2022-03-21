from faker import Faker
from random import randint, choice

MAX = 1000

def generate_country():
    res = open("country.csv", "w")
    name_country = [line.strip() for line in open("countries.txt", "r")]
    capital = [line.strip() for line in open("capitals.txt", "r")]
    name_president = [line.strip() for line in open("presidents.txt", "r")]
    for i in range(MAX):
        line = "{0},{1},{2},{3},{4}\n".format(
            i, name_country[i], choice(capital), randint(1, 300),
            choice(name_president))
        res.write(line)
    res.close()
    
def generate_trener():
    res = open("treners.csv", "w")
    name = [line.strip() for line in open("treners.txt", "r")]
    for i in range(MAX):
        line = "{0},{1},{2},{3},{4}\n".format(
            i, name[i], randint(18, 100), randint(50, 150), randint(145, 210))
        res.write(line)
    res.close()

def generate_team():
    res = open("team.csv", "w")
    tipes = ["polo", "sprint", "aquatics", "boating", "diving", "freestyle",
             "kayaking", "rowing", "surfing", "swimming", "yachting", "water polo",
             "waterskiing", "wind surfing", "alpine skiing", "biathlon", "hockey",
             "bobsleign", "curling", "figure skating", "luge", "nordic combined",
             "skeleton", "slalom", "snowboarding", "bungee jumping", "tennis",
             "volleyball", "boxing", "chess", "darts", "fencing", "golf"]
    for i in range(MAX):
        line = "{0},{1},{2},{3},{4}\n".format(
            i, choice(tipes), randint(2000, 10000), randint(3, 200), randint(1, 20))
        res.write(line)
    res.close()

def generate_sportsman():
    res = open("sportsman.csv", "w")
    for i in range(MAX):
        line = "{0},{1},{2},{3},{4},{5}\n".format(i, randint(0, 999), randint(0, 999),
                                              randint(0, 999), randint(18, 100), randint(40, 160))
        res.write(line)
    res.close()

generate_sportsman()
generate_country()
generate_trener()
generate_team()
