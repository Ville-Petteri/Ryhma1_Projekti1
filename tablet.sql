CREATE TABLE kayttajat (
    id          SERIAL PRIMARY KEY,
    name        varchar(255) NOT NULL,
    email       varchar(255)
    );


CREATE TABLE projektit  (
    id          SERIAL PRIMARY KEY,
    name        varchar(255) NOT NULL,
    selite       varchar(255)
    );   


CREATE TABLE tuntikirjaukset (
    id              SERIAL PRIMARY KEY,
    aloitus         TIMESTAMP NOT NULL,
    lopetus         TIMESTAMP NOT NULL,
    selite          varchar(255),
    projektit_id     INT,
    kayttajat_id     INT,
    CONSTRAINT fk_projektit
        FOREIGN KEY(projektit_id) 
            REFERENCES projektit(id),
    CONSTRAINT fk_kayttajat
        FOREIGN KEY(kayttajat_id) 
            REFERENCES kayttajat(id)

    );



CREATE TABLE IF NOT EXISTS tuntikirjaukset2 (
    id              SERIAL PRIMARY KEY,
    aloitus         TIMESTAMP NOT NULL,
    lopetus         TIMESTAMP NOT NULL,
    selite          varchar(255),
    projektit_id     INT,
    kayttajat_id     INT,
     saa_tieto varchar(255),
    DateCreated TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT fk_projektit
        FOREIGN KEY(projektit_id) 
            REFERENCES projektit(id),
    CONSTRAINT fk_kayttajat
        FOREIGN KEY(kayttajat_id) 
            REFERENCES kayttajat(id)

    );
   
CREATE TABLE IF NOT EXISTS kayttajat (
    id          SERIAL PRIMARY KEY,
    name        varchar(255) NOT NULL,
    email       varchar(255)
    );


CREATE TABLE IF NOT EXISTS projektit  (
    id          SERIAL PRIMARY KEY,
    name        varchar(255) NOT NULL,
    selite       varchar(255)
    );      
   
   
INSERT INTO tuntikirjaukset (aloitus,lopetus,selite,projektit_id,kayttajat_id)
    VALUES ('2022-3-9 12:0','2022-3-9 13:0', 'vp-testi', 2, 2);

SELECT kayttajat.name,projektit.name,tuntikirjaukset.lopetus - tuntikirjaukset.aloitus AS difference FROM tuntikirjaukset, projektit,kayttajat 
WHERE tuntikirjaukset.projektit_id=projektit.id AND tuntikirjaukset.kayttajat_id=kayttajat.id;

SELECT id,aloitus,lopetus,lopetus - aloitus AS difference
FROM tuntikirjaukset;

SELECT SUM (lopetus - aloitus) AS total
FROM tuntikirjaukset;
WHERE kayttajat_id=3;

SELECT
  id,
  aloitus,
  lopetus,
  lopetus - aloitus AS difference
FROM tuntikirjaukset;

SELECT kauttajat.name,SUM(tuntikirjaukset.lopetus - tuntikirjaukset.aloitus) AS total
FROM tuntikirjaukset,kayttajat
WHERE tuntikirjaukset.kayttajat_id=kayttajat.id;
GROUP BY tuntikirjaukset.kayttajat_id;

SELECT kayttajat.name,tuntikirjaukset.lopetus - tuntikirjaukset.aloitus AS difference FROM tuntikirjaukset, projektit,kayttajat 
WHERE tuntikirjaukset.projektit_id=projektit.id AND tuntikirjaukset.kayttajat_id=kayttajat.id AND AGE(tuntikirjaukset.DateCreated) > DAY '7';

SELECT DateCreated   AS ika FROM tuntikirjaukset WHERE NOW() - tuntikirjaukset.DateCreated < ( 1 ) * INTERVAL '1' hour;

SELECT * FROM tuntikirjaukset;




CREATE TABLE IF NOT EXISTS tuntikirjaukset2 (
    id SERIAL PRIMARY KEY,
    aloitus TIMESTAMP NOT NULL,
    lopetus TIMESTAMP NOT NULL,
    selite varchar(255),
    projektit_id INT,
    kayttajat_id INT,
    saa_tieto varchar(255),
    DateCreated TIMESTAMP NOT NULL DEFAULT NOW()
    CONSTRAINT fk_projektit 
    FOREIGN KEY (projektit_id)
    REFERENCES projektit(id),
    CONSTRAINT fk_kayttajat 
    FOREIGN KEY(kayttajat_id) 
    REFERENCES kayttajat(id));


DateCreated TIMESTAMP NOT NULL DEFAULT NOW()

ALTER TABLE tuntikirjaukset

ADD COLUMN IF NOT EXISTS DateCreated TIMESTAMP NOT NULL DEFAULT NOW();

SELECT kayttajat.name AS Käyttäjä,projektit.name AS Projekti,tuntikirjaukset.aloitus,tuntikirjaukset.lopetus - tuntikirjaukset.aloitus AS Kesto,tuntikirjaukset.selite,tuntikirjaukset.saa_tieto 
FROM tuntikirjaukset, projektit,kayttajat 
WHERE tuntikirjaukset.projektit_id=projektit.id 
AND tuntikirjaukset.kayttajat_id=kayttajat.id
AND NOW() - tuntikirjaukset.DateCreated < ( 1 ) * INTERVAL '1' hour;


