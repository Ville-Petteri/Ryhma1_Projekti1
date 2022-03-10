import psycopg2
from config import config
import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
import emailcredentials


#connect funktio luo yhteyden tietokantaan config.py ja datadase.ini tiedostojen mukaisesti.
# Funktio käynnistyy kun ohjelma ajetaan ja se luo tietokantaan tarvittavat taulut jos niitä ei ole olemassa
#funktio kutsuu laheta email funktiota, joka luo emailin funktioiden avulla ja lähettää sen emaicredentials.py tiedostossa määriteltyyn osoitteeseen
def connect():
    con = None
    try:
        
        con = psycopg2.connect(**config())
        cursor = con.cursor()
        luo_taulu_kayttajat(cursor)
        luo_taulu_projektit(cursor)
        luo_taulu_tuntikirjaukset(cursor)
        laheta_email(cursor)
        con.commit()
        cursor.close()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if con is not None:
            con.close()

#Funktio luo taulun kayttajat, jos sitä ei ole            
def luo_taulu_kayttajat(cursor):
    SQL='CREATE TABLE IF NOT EXISTS kayttajat (id SERIAL PRIMARY KEY,name varchar(255) NOT NULL,email varchar(255));'
    cursor.execute(SQL)

#Funktio luo taulun projektit jos sitä ei ole
def luo_taulu_projektit(cursor):
    SQL='CREATE TABLE IF NOT EXISTS projektit (id SERIAL PRIMARY KEY,name varchar(255) NOT NULL,selite varchar(255));'
    cursor.execute(SQL)

#Funktio luo taulun tuntikirjausket, jos sitä ei ole
def luo_taulu_tuntikirjaukset(cursor):
    SQL='CREATE TABLE IF NOT EXISTS tuntikirjaukset (id SERIAL PRIMARY KEY,aloitus TIMESTAMP NOT NULL,lopetus TIMESTAMP NOT NULL,selite varchar(255),projektit_id INT,kayttajat_id INT,saa_tieto varchar(255),DateCreated TIMESTAMP NOT NULL DEFAULT NOW(), CONSTRAINT fk_projektit FOREIGN KEY (projektit_id) REFERENCES projektit(id),CONSTRAINT fk_kayttajat FOREIGN KEY(kayttajat_id) REFERENCES kayttajat(id));'
    cursor.execute(SQL)    

#Funktio hakee ja palauttaa kaikkien tuntikirjauksien pituuksien summan Total nimellä
def select_tuntisumma(cursor):
    SQL ='SELECT SUM (lopetus - aloitus) AS total FROM tuntikirjaukset'
    cursor.execute(SQL)
    row =cursor.fetchone()
    return(row[0])
    
#Funktio hakee ja palauttaa kaikki tuntikirjaukset ja hakee niille käyttäjä ja projektinimet toisista tableista palautusta muokataan html-tageilla
def tuntikirjaukset_table(cursor):
    palautus="<table> <tr>"
    SQL = 'SELECT kayttajat.name AS Käyttäjä,projektit.name AS Projekti,tuntikirjaukset.aloitus,tuntikirjaukset.lopetus - tuntikirjaukset.aloitus AS Kesto,tuntikirjaukset.selite,tuntikirjaukset.saa_tieto FROM tuntikirjaukset, projektit,kayttajat WHERE tuntikirjaukset.projektit_id=projektit.id AND tuntikirjaukset.kayttajat_id=kayttajat.id;'
    cursor.execute(SQL)
    for desc in cursor.description:
        palautus=palautus+ "<td>" +str(desc[0])+"</td>"
    palautus=palautus+"</tr>"
    row =cursor.fetchone()
    palautus=palautus+f'<tr><td>{row[0]} <td>{row[1]}</td> <td>{row[2]}</td> <td>{row[3]}</td> <td>{row[4]} </td><td>{row[5]}</td></tr>'
    while row is not None:
        palautus=palautus+f'<tr><td>{row[0]} <td>{row[1]}</td> <td>{row[2]}</td> <td>{row[3]}</td> <td>{row[4]} </td><td>{row[5]}</td></tr>'
        row = cursor.fetchone()
    palautus=palautus+"</table>"
    return(palautus)

#Funktio hakee ja palauttaa kaikki alle tunnin ikäiset tuntikirjaukset ja hakee niille käyttäjä ja projektinimet toisista tableista palautusta muokataan html-tageilla
def tuntikirjaukset_table_age(cursor):
    palautus="<table> <tr>"
    SQL = "SELECT kayttajat.name AS Käyttäjä,projektit.name AS Projekti,tuntikirjaukset.aloitus,tuntikirjaukset.lopetus - tuntikirjaukset.aloitus AS Kesto,tuntikirjaukset.selite,tuntikirjaukset.saa_tieto FROM tuntikirjaukset, projektit,kayttajat WHERE tuntikirjaukset.projektit_id=projektit.id AND tuntikirjaukset.kayttajat_id=kayttajat.id AND NOW() - tuntikirjaukset.DateCreated < ( 1 ) * INTERVAL '1' hour;"
    cursor.execute(SQL)
    for desc in cursor.description:
        palautus=palautus+ "<td>" +str(desc[0])+"</td>"
    palautus=palautus+"</tr>"
    row =cursor.fetchone()
    palautus=palautus+f'<tr><td>{row[0]} <td>{row[1]}</td> <td>{row[2]}</td> <td>{row[3]}</td> <td>{row[4]} </td><td>{row[5]}</td></tr>'  
    while row is not None:
        palautus=palautus+f'<tr><td>{row[0]} <td>{row[1]}</td> <td>{row[2]}</td> <td>{row[3]}</td> <td>{row[4]} </td><td>{row[5]}</td></tr>'
        row = cursor.fetchone()
    palautus=palautus+"</table>"
    return(palautus)
   

#Funktio luo ja palauttaa emailin body osuuden hakien sisällön funktioiden avulla
def luo_email(cursor):
    style="<style> table, th, td {border:1px solid black;}</style>"
    otsikko1="<h3>Tunteja yhteensä:</h3> <br>"
    data1=select_tuntisumma(cursor)
    otsikko2="<br><h3> Kaikki tuntikirjaukset: </h3><br>"
    data2=tuntikirjaukset_table(cursor)
    otsikko3="<br><h3> Uudet tuntikirjaukset: </h3><br>"
    data3=tuntikirjaukset_table_age(cursor)
    palautus=(f'{style}{otsikko1}{data1}{otsikko2}{data2}{otsikko3}{data3}')
    return(palautus)

#Funktio lähettää emailin emailcredentials tiedostossa määritellystä ositteesta samassa tiedostossa määriteltyyn osoitteeseen
def laheta_email(cursor):
    fromaddr = emailcredentials.emailuser
    toaddr = emailcredentials.emailreceiver
    msg = MIMEMultipart()
    msg['From'] = fromaddr
    msg['To'] = toaddr
    msg['Subject'] = "Tuntiraportti"
    body = luo_email(cursor)
    msg.attach(MIMEText(body, 'html'))
    server = smtplib.SMTP('smtp.gmail.com', 587)
    server.ehlo()
    server.starttls()
    server.ehlo()
    server.login(emailcredentials.emailuser, emailcredentials.emailpassword)

    text = msg.as_string()
    server.sendmail(fromaddr, toaddr, text)


if __name__ == '__main__':
    connect()