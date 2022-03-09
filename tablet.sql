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



CREATE TABLE IF NOT EXISTS tuntikirjaukset (
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
   
   
INSERT INTO tuntikirjaukset2 (aloitus,lopetus,selite,projektit_id,kayttajat_id)
    VALUES ('2022-3-9 12:0','2022-3-9 13:0', 'pulipulipulipuli', 2, 2);

SELECT kayttajat.name,projektit.name,tuntikirjaukset.id FROM tuntikirjaukset, projektit,kayttajat 
WHERE tuntikirjaukset.projektit_id=projektit.id AND tuntikirjaukset.kayttajat_id=kayttajat.id 

SELECT id,aloitus,lopetus,lopetus - aloitus AS difference
FROM tuntikirjaukset;

SELECT SUM (lopetus - aloitus) AS total
FROM tuntikirjaukset
WHERE kayttajat_id=3;




