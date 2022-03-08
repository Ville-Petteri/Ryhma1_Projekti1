import datetime

def vov_valikko():
    print('VOV-tuntikirjaus')
    print('1: Lisää tuntikirjaus')
    print('2: Näytä Projektit')
    print('3: Näytä kirjaukset')
    print('4: Muokkaa kirjausta')
    print('5: Näytä projekti')
    print('6: Lopeta')
    valinta = int(input('Syötä valinta: '))
    if valinta == 1:
        lisaa_tuntikirjaus()
    elif valinta == 2:
        return
    elif valinta == 3:
        return
    elif valinta == 4:
        return
    elif valinta == 5:
        return
    elif valinta == 5:
        return

def lisaa_tuntikirjaus():
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

            lopetuspvmaika = muodosta_date_pvm(aloituspvm+" "+aloitusaika)
            break
        except:
            print("------------------------------")
            print("\n VIRHE!!! VIRHE!!! VIRHE!!!\n")
            print("Tarkista, että syötit pvm muodossa DD-MM-YYYY ja ajan muodossa HH:MM")
            print("------------------------------\n")    

    print("Syötä projektinumero")
    projektitieto = int(input("Projekti: "))

    print("Lisää työselite")
    selite = input("Selite:")

    print(aloituspvm,aloitusaika,lopetusaika,lopetuspvm,projektitieto,selite)

def muodosta_date_pvm(pvmaika):
    date_muotoiltu_pvm = datetime.datetime.strptime(pvmaika,"%d-%m-%Y %H:%M")
    return date_muotoiltu_pvm

if __name__ == '__main__':
    vov_valikko()
