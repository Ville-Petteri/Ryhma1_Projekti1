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
    erotus          TIMESTAMPDIFF(SECOND, aloitus, lopetus),
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

