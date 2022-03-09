import psycopg2
from config import config


def connect():
    con = None
    try:
        
        con = psycopg2.connect(**config())
        cursor = con.cursor()
        select_tuntikirjaukset(cursor)
        #select_tuntisumma(cursor)
        #luo_taulu_tuntikirjaukset(cursor)
        con.commit()
        cursor.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if con is not None:
            con.close()
def luo_taulu_kayttajat(cursor):
    SQL='CREATE TABLE IF NOT EXISTS kayttajat (id SERIAL PRIMARY KEY,name varchar(255) NOT NULL,email varchar(255));'
    cursor.execute(SQL)

def luo_taulu_projektit(cursor):
    SQL='CREATE TABLE IF NOT EXISTS projektit (id SERIAL PRIMARY KEY,name varchar(255) NOT NULL,selite varchar(255));'
    cursor.execute(SQL)

def luo_taulu_tuntikirjaukset(cursor):
    SQL='CREATE TABLE IF NOT EXISTS tuntikirjaukset2 (id SERIAL PRIMARY KEY,aloitus TIMESTAMP NOT NULL,lopetus TIMESTAMP NOT NULL,selite varchar(255),projektit_id INT,kayttajat_id INT,CONSTRAINT fk_projektit FOREIGN KEY (projektit_id) REFERENCES projektit(id),CONSTRAINT fk_kayttajat FOREIGN KEY(kayttajat_id) REFERENCES kayttajat(id));'
    cursor.execute(SQL)    


def select_tuntikirjaukset(cursor):
    SQL = 'SELECT * FROM tuntikirjaukset2;'
    cursor.execute(SQL)
    colnames= [desc[0] for desc in cursor.description]
    print(colnames)
    row =cursor.fetchone()
    while row is not None:
        print(row)
        row = cursor.fetchone()

def select_tuntisumma(cursor):
    SQL ='SELECT AGE(lopetus, aloitus) AS  kesto FROM tuntikirjaukset;'
    cursor.execute(SQL)
    colnames= [desc[0] for desc in cursor.description]
    print(colnames)
    row =cursor.fetchone()
    while row is not None:
        print(row)
        row = cursor.fetchone()





if __name__ == '__main__':
    connect()