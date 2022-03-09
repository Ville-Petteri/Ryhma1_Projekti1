import psycopg2
from config import config
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import emailcredentials


def connect():
    con = None
    try:
        
        con = psycopg2.connect(**config())
        cursor = con.cursor()
        luo_taulu_kayttajat(cursor)
        luo_taulu_projektit(cursor)
        luo_taulu_tuntikirjaukset(cursor)
        #select_tuntikirjaukset(cursor)
        #select_tuntisumma(cursor)
        laheta_email(cursor)
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
    SQL='CREATE TABLE IF NOT EXISTS tuntikirjaukset (id SERIAL PRIMARY KEY,aloitus TIMESTAMP NOT NULL,lopetus TIMESTAMP NOT NULL,selite varchar(255),projektit_id INT,kayttajat_id INT,saa_tieto varchar(255), CONSTRAINT fk_projektit FOREIGN KEY (projektit_id) REFERENCES projektit(id),CONSTRAINT fk_kayttajat FOREIGN KEY(kayttajat_id) REFERENCES kayttajat(id));'
    cursor.execute(SQL)    


def select_tuntikirjaukset(cursor):
    palautus=""
    SQL = 'SELECT * FROM tuntikirjaukset;'
    cursor.execute(SQL)
    colnames= [desc[0] for desc in cursor.description]
    #print(colnames)
    palautus=palautus+str(colnames)
    row =cursor.fetchone()
    while row is not None:
        #print(row)
        palautus=palautus+str(row)
        row = cursor.fetchone()
    return(palautus)
def select_tuntisumma(cursor):
    SQL ='SELECT AGE(lopetus, aloitus) AS  kesto FROM tuntikirjaukset;'
    cursor.execute(SQL)
    colnames= [desc[0] for desc in cursor.description]
    print(colnames)
    row =cursor.fetchone()
    while row is not None:
        print(row)
        row = cursor.fetchone()

def laheta_email(cursor):
    fromaddr = emailcredentials.emailuser
    toaddr = emailcredentials.emailreceiver
    msg = MIMEMultipart()
    msg['From'] = fromaddr
    msg['To'] = toaddr
    msg['Subject'] = "Tuntiraportti"
    body = select_tuntikirjaukset(cursor)
    msg.attach(MIMEText(body, 'plain'))
    
    
    
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.ehlo()
    server.starttls()
    server.ehlo()
    server.login(emailcredentials.emailuser, emailcredentials.emailpassword)

    text = msg.as_string()
    server.sendmail(fromaddr, toaddr, text)




if __name__ == '__main__':
    #connect()
    connect()