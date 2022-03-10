import requests
from saaAPPID import saaAPPID

def saa_helsinki():
    appid = saaAPPID()
    url = "http://api.openweathermap.org/data/2.5/weather?lang=fi&q=helsinki&units=metric&APPID="+appid
    r = requests.get(url)
    vastaus = r.json()
    print(vastaus)
    return (str(vastaus['weather'][0]['description'])+' ja lämpötila = '+str(vastaus['main']['temp']))

if __name__ == '__main__':
    print(saa_helsinki())