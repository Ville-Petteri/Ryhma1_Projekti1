import psycopg2
from config import config

def connect(valinta):
    con = None
    try:
        con = psycopg2.connect(**config())
        cur = con.cursor()        
        if valinta == 2 :
            select_allfromkayttajat(cur)
        elif valinta == 3 :
            select_allfromprojektit(cur)
        con.commit()
        cur.close()        
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if con is not None:
            con.close()

def select_allfromkayttajat(cur):
    SQL = 'SELECT * FROM kayttajat;'
    cur.execute(SQL)
    row = cur.fetchone()
    while row is not None:
        print(row)
        row = cur.fetchone()

def select_allfromprojektit(cur):
    SQL = 'SELECT * FROM projektit;'
    cur.execute(SQL)
    row = cur.fetchone()
    while row is not None:
        print(row)
        row = cur.fetchone()

if __name__ == '__main__':
    connect()