import psycopg2
from config import config
import datetime


def connect(valinta):
    con = None
    try:
        con = psycopg2.connect(**config())
        cur = con.cursor()
        valitsija(valinta,cur)
        con.commit()
        cur.close()        
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if con is not None:
            con.close()

def valitsija(valinta,cur):
    if valinta == 1 :
        insert_tuntikirjaus(cur)
    elif valinta == 21 :
        select_kayttajat(cur)
    elif valinta == 22 :
        insert_kayttaja(cur)
    elif valinta == 23 :
        update_kayttaja(cur)
    elif valinta == 24 :
        delete_kayttaja(cur)
    elif valinta == 31 :
        select_projektit(cur)
    elif valinta == 32 :
        insert_projekti(cur)
    elif valinta == 33 :
        update_projekti(cur)
    elif valinta == 34 :
        delete_projekti(cur)
    elif valinta == 41 :
        select_tuntikirjaukset(cur)
    elif valinta == 42 :
        insert_tuntikirjaus(cur)
    elif valinta == 44 :
        delete_tuntikirjaus(cur)


#kayttajien listaus
def select_kayttajat(cur):
    SQL = 'SELECT * FROM kayttajat;'
    cur.execute(SQL)
    colnames = [desc[0] for desc in cur.description]
    print(colnames)
    row = cur.fetchone()
    while row is not None:
        print(row)
        row = cur.fetchone()
    input('Paina Enter jatkaaksesi')

def delete_kayttaja(cur):
    delete_id  = int(input('Anna poistettavan käyttäjän id: '))
    SQL = "DELETE FROM kayttajat WHERE id=%s;"
    data = (delete_id,)
    cur.execute(SQL, data)
            
    input('käyttäjä poistettu')

def insert_kayttaja(cur):
    name = input('Käyttäjän nimi: ')
    email = input('Käyttäjän email: ')
    SQL = "INSERT INTO kayttajat (name,email) VALUES (%s, %s);"
    data = (name,email)
    cur.execute(SQL, data)
    input('Käyttäjä lisätty')

def update_kayttaja(cur):
    id = input('Kenen tietoja muutetaan (id): ')
    select_kayttajat_yksittainen(cur,id)
    name = input('Anna nimi: ')
    email = input('Anna email:')
    SQL = "UPDATE kayttajat SET name=%s, email=%s WHERE id=%s;"
    data = (name,email,id)
    cur.execute(SQL, data)
    input('Käyttäjä päivitetty')

def select_kayttajat_yksittainen(cur,id):
    print('******************************')
    SQL = 'SELECT * FROM kayttajat WHERE id=%s;'
    cur.execute(SQL,id)
    colnames = [desc[0] for desc in cur.description]
    print(colnames)
    row = cur.fetchone()
    while row is not None:
        print(row)
        row = cur.fetchone()
    print('******************************')

#Projektien listaus
def select_projektit(cur):
    SQL = 'SELECT * FROM projektit;'
    cur.execute(SQL)
    colnames = [desc[0] for desc in cur.description]
    print(colnames)
    row = cur.fetchone()
    while row is not None:
        print(row)
        row = cur.fetchone()
    input('Paina Enter jatkaaksesi')

def delete_projekti(cur):
    delete_id  = int(input('Anna poistettavan projektin id: '))
    SQL = "DELETE FROM projektit WHERE id=%s;"
    data = (delete_id,)
    cur.execute(SQL, data)
            
    input('käyttäjä poistettu')

def insert_projekti(cur):
    name = input('Projektin nimi: ')
    selite = input('Projektin selite: ')
    SQL = "INSERT INTO projektit (name,selite) VALUES (%s, %s);"
    data = (name,selite)
    cur.execute(SQL, data)
    input('Käyttäjä lisätty')

def update_projekti(cur):
    id = input('Kenen tietoja muutetaan (id): ')
    select_projektit_yksittainen(cur,id)
    name = input('Anna nimi: ')
    selite = input('Anna selite:')
    SQL = "UPDATE projektit SET name=%s, selite=%s WHERE id=%s;"
    data = (name,selite,id)
    cur.execute(SQL, data)
    input('Käyttäjä päivitetty')

def select_projektit_yksittainen(cur,id):
    print('******************************')
    SQL = 'SELECT * FROM projektit WHERE id=%s;'
    cur.execute(SQL,id)
    colnames = [desc[0] for desc in cur.description]
    print(colnames)
    row = cur.fetchone()
    while row is not None:
        print(row)
        row = cur.fetchone()
    print('******************************')

#id haku projekteista
def select_projektit_id(cur):
    SQL = 'SELECT id FROM projektit;'
    cur.execute(SQL)
    row = cur.fetchone()
    while row is not None:
        print(row)
        row = cur.fetchone()

def select_tuntikirjaukset(cur):
    SQL = 'SELECT * FROM tuntikirjaukset;'
    cur.execute(SQL)
    colnames = [desc[0] for desc in cur.description]
    print(colnames)
    row = cur.fetchone()
    while row is not None:
        print(row)
        row = cur.fetchone()
    input('Paina Enter jatkaaksesi')

def delete_tuntikirjaus(cur):
    delete_id  = int(input('Anna poistettavan tuntikirjauksen id: '))
    SQL = "DELETE FROM tuntikirjaukset WHERE id=%s;"
    data = (delete_id,)
    cur.execute(SQL, data)            
    input('Tuntikirjaus poistettu')

def select_tuntikirjaus_yksittainen(cur,id):
    print('******************************')
    SQL = 'SELECT * FROM tuntikirjaukset WHERE id=%s;'
    cur.execute(SQL,id)
    colnames = [desc[0] for desc in cur.description]
    print(colnames)
    row = cur.fetchone()
    while row is not None:
        print(row)
        row = cur.fetchone()
    print('******************************')

def insert_tuntikirjaus(cur):
    CurrentDate = datetime.date.today()
    tanaanpaiva = str(CurrentDate.day) + "-" + str(CurrentDate.month) + "-" + str(CurrentDate.year)
    aloituspvmaika=""
    lopetuspvmaika=""

    print('\nTänään on '+tanaanpaiva+"\n")

    print("Tuntikirjaus")
    
    while True:
        try:
            print("Syötä aloituspvm muodossa DD-MM-YYYY")
            aloituspvm = input("aloituspvm: ")
            
            print("Syötä aloitusaika muodossa HH:MM")
            aloitusaika = input("aloitusaika: ")

            aloituspvmaika = muodosta_date_pvm(aloituspvm+" "+aloitusaika)
            break
        except:
            print("------------------------------")
            print("\n VIRHE!!! VIRHE!!! VIRHE!!!\n")
            print("Tarkista, että syötit pvm muodossa DD-MM-YYYY ja ajan muodossa HH:MM")
            print("------------------------------\n")

    while True:
        try:
            print("Syötä lopetuspvm muodossa DD-MM-YYYY")
            lopetuspvm = input("lopetuspvm: ")
            
            print("Syötä lopetusaika muodossa HH:MM")
            lopetusaika = input("lopetusaika: ")

            lopetuspvmaika = muodosta_date_pvm(lopetuspvm+" "+lopetusaika)
            break
        except:
            print("------------------------------")
            print("\n VIRHE!!! VIRHE!!! VIRHE!!!\n")
            print("Tarkista, että syötit pvm muodossa DD-MM-YYYY ja ajan muodossa HH:MM")
            print("------------------------------\n")    

    print("Syötä projektinumero")
    projektitieto = int(input("Projekti: "))

    print("Lisää työselite")
    selite = input("Selite: ")

    print("Lisää käyttäjä id")
    kayttajat_id = input("id: ")

    SQL = "INSERT INTO tuntikirjaukset (aloitus,lopetus,selite,projektit_id,kayttajat_id) VALUES (%s, %s, %s, %s, %s);"
    data = (aloituspvmaika,lopetuspvmaika,selite,projektitieto,kayttajat_id)
    cur.execute(SQL, data)
    input('Tuntikirjaus lisätty')

def muodosta_date_pvm(pvmaika):
    date_muotoiltu_pvm = datetime.datetime.strptime(pvmaika,"%d-%m-%Y %H:%M")
    return date_muotoiltu_pvm


if __name__ == '__main__':
    connect(4)