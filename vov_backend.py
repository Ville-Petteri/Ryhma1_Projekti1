import psycopg2


def connect():
    con = None
    try:
        
        con = psycopg2.connect(**config())
        cursor = con.cursor()
        #select_all(cursor)
        #select_names(cursor)
        #insertcertificate('Scrum',5,cursor)
        #updateperson(5,32,cursor)
        #updatecertificate('AZ-300',8,cursor)
        #deleteperson(6,cursor)
        #deletecertificate(5,cursor)
        con.commit()
        cursor.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if con is not None:
            con.close()