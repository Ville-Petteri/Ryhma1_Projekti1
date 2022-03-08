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

    print("Syötä aloituspvm muodossa DD-MM-YYYY")
    aloituspvm = input("aloituspvm: ")
    
    print("Syötä aloitusaika muodossa HH-MM")
    aloitusaika = input("aloitusaika: ")

    print("Syötä lopetuspvm muodossa DD-MM-YYYY")
    lopetuspvm = input("lopetuspvm: ")
    
    print("Syötä lopetusaika muodossa HH-MM")
    lopetusaika = input("lopetusaika: ")

    print("Syötä projektinumero")
    projektitieto = int(input("Projekti: "))

    print("Lisää työselite")
    selite = input("Selite:")

    print(aloituspvm,aloitusaika,lopetusaika,lopetuspvm,projektitieto,selite)

if __name__ == '__main__':
    vov_valikko()