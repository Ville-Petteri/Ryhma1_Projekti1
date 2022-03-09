import psycopg2
from config import config


def connect():
    con = None
    try:
        
        con = psycopg2.connect(**config())
        cursor = con.cursor()
        select_tuntikirjaukset(cursor)
        #con.commit()
        cursor.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if con is not None:
            con.close()

def select_tuntikirjaukset(cursor):
    SQL = 'SELECT * FROM tuntikirjaukset;'
    cursor.execute(SQL)
    colnames= [desc[0] for desc in cursor.description]
    print(colnames)
    row =cursor.fetchone()
    while row is not None:
        print(row)
        row = cursor.fetchone()

def select_tuntisumma(cursor):
    SQL ='SELECT SUM() FROM table_name'



if __name__ == '__main__':
    connect()