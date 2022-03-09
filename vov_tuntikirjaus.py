import queries

#aloitus valikko
def vov_valikko():
    while True:
        print('******************************')
        print('VOV-tuntikirjaus')
        print('******************************')
        print('1: Lisää tuntikirjaus')
        print('2: Käyttäjät CRUD')
        print('3: Projektit CRUD')
        print('4: Kirjaukset CRUD')
        print('5: Lopeta')
        valinta = int(input('Syötä valinta: '))
        if valinta == 1:
            queries.connect(valinta)
        elif 2<= valinta <= 4:
                valikko_crud(valinta)
        elif valinta == 5:
            exit()
        else:
            input("Virheellinen valinta")

#CRUD valikot
def valikko_crud(valinta):
    valikkonimi=""
    while True:
        if(valinta == 2):
            valikkonimi = "Käyttäjät"
        elif(valinta == 3):
            valikkonimi = "Projektit"
        elif(valinta == 4):
            valikkonimi = "Tuntikirjaukset"
        if 2<= valinta <= 4:
            print('------------------------------')
            print(valikkonimi +' CRUD')
            print('------------------------------')    
            print('1:Listaa')
            print('2:Lisää uusi')
            if(valinta != 4):
                print('3:Muokkaa')
            print('4:Deletoi\n')        
            print('5:Takaisin\n')
        valinta_crud = int(input('Syötä valinta: '))
        if valinta_crud == 5:
            break
        elif 1<= valinta_crud <= 4:
            queries.connect(valinta*10+valinta_crud)
        else:
            input("Virheellinen valinta")

#ohjelman ajaminen
if __name__ == '__main__':
    vov_valikko()
