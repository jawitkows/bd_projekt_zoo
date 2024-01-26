
create database zoo;

#tabela 1
create or replace TABLE stan_gatunku (
    ID INT PRIMARY KEY,
    zagrozenie varchar(50) unique not null
);

#tabela 2
create or replace TABLE obszary_zoo (
    ID INT PRIMARY KEY,
    nazwa_obszaru varchar(50) unique not null
);

#tabela 3
create or replace TABLE opiekunowie (
    ID INT auto_increment PRIMARY KEY,
    imie varchar(50) not null,
    nazwisko varchar(50) not null,
    email varchar(50) unique
);

#tabela 4
create or replace TABLE sponsorzy (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    org_name varchar(50) not null,
    donate_date date not null,
    amount varchar(50) not null,
    animal_name varchar(50)
);

#tabela 5
create or replace TABLE opiekun (
    ID INT,
    data_zatrudnienia date,
    zwierze_opieka varchar(50),
    okres_opieki date,
    foreign key (id) references opiekunowie(id) on update cascade
);

#tabela główna (6)
create or replace TABLE zwierzeta (
    ID INT auto_increment,
    imie varchar(20) unique,
    gatunek varchar(50) not null,
    wiek int not null,
    opiekun int not null,
    dotacje INT,
    czesc_zoo int not null,
    stan_gatunku int not null,
    data_przybycia date not null,
    primary key (ID),
    FOREIGN KEY (opiekun) REFERENCES opiekunowie(id) on update cascade,
    FOREIGN KEY (dotacje) REFERENCES sponsorzy(id) on update cascade,
    FOREIGN KEY (czesc_zoo) REFERENCES obszary_zoo(id) on update cascade,
    FOREIGN KEY (stan_gatunku) REFERENCES stan_gatunku(id) on update cascade
);

SELECT * FROM zwierzeta;

#tabela 7
create or replace TABLE gdzie_zwierze (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nazwa_obszaru varchar(50) not null,
    zwierze varchar(50) not null,
    data_pobytu date not null,
    FOREIGN KEY (nazwa_obszaru) REFERENCES obszary_zoo(nazwa_obszaru) on update cascade,
    FOREIGN KEY (zwierze) REFERENCES zwierzeta(imie) on update cascade
);

#tabela 8
create or replace TABLE zwierze_widok (
    ID INT auto_increment primary key,
    nazwa_zwierzecia varchar(50) unique,
    data_przyjecia date,
    opiekun int,
    okres_opieki date,
    wiek int,
    pozywienie varchar(50) not null,
    foreign key (nazwa_zwierzecia) references zwierzeta(imie) on update cascade,
    foreign key (opiekun) references opiekun(id) on update cascade
);

#tabela 9
create or replace table karta_przyjecia (
	id int auto_increment,
	data_przyjecia date,
	stan int,
	kraj_pochodzenia varchar(20),
	primary key (id, stan)
)
partition by list(stan) (
	partition wymarle_na_wolnosci values in (0),
	partition zagrozone_wyginieciem values in (1,2,3),
	partition bliskie_zagrozenia values in (4),
	partition najmniejszej_troski values in (5)
);

select * from karta_przyjecia partition (wymarle_na_wolnosci);

#trigger 1 - automatyczne tworzenie maila dla opiekuna
create trigger before_insert_opiekun
before insert on opiekunowie
for each row 
begin 
	set new.email = concat(lower(new.imie),'.',lower(new.nazwisko),'@zoo.pl');
end;

select * from sponsorzy;

#trigger2 - aktualizacja tabeli opiekunowie po dodaniu do opiekun nowego członka
create trigger update_opiekun_after_insert
after insert on opiekunowie
for each row
begin
    declare v_opiekun_id INT;

    select ID into v_opiekun_id
    from opiekunowie
    where ID = NEW.ID;
    if v_opiekun_id is not null then
        update opiekun
        set data_zatrudnienia = CURRENT_DATE, 
            zwierze_opieka = null, 
            okres_opieki = null 
        where ID = v_opiekun_id;
    end if;
end;

select * from gdzie_zwierze ;
select * from opiekunowie;


#Dodawanie danych do tabeli opiekunowie
insert into opiekunowie (imie, nazwisko) values
('Marta', 'Buc'),
('Krystyna', 'Kloc'),
('Anna', 'Maki'),
('Kuba', 'Krzakowy'),
('Jan', 'Janowicz'),
('Zenon', 'Martin');

select * from opiekunowie;


#Dodawanie danych do tabeli obszary_zoo
INSERT INTO obszary_zoo (ID, nazwa_obszaru) VALUES
(1,'Pawilon wodny'),
(2,'Pawilon zwierzat hodowlanych'),
(3,'Pawilon zwierzat dzikich'),
(4,'Pawilon zwierzat domowych'),
(5,'Pawilon wezy'),
(6,'Pawilon owadow, pajeczakow'),
(7,'Oceanarium'),
(8,'Pawilon ptaków'),
(9,'Pawilon sLoni');


#Dodawanie danych do tabeli stan_gatunku
INSERT INTO stan_gatunku (ID, zagrozenie) VALUES
(0, 'gatunki zanikajace'),
(1, 'skrajnie zagrozone wyginieciem'),
(2, 'duze ryzyko wyginiecia'),
(3, 'nizsze ryzyko wyginiecia'),
(4, 'narazone na wyginiecie'),
(5, 'powszechnie wystepujace');


#Dodawanie danych do tabeli sponsorzy
INSERT INTO sponsorzy (org_name, donate_date, amount, animal_name) VALUES
('Help_animal', '2021-07-08', 300, 'Kachna'),
('Help_animal', '2021-07-08', 100, 'Mikus'),
('Lovanimals', '2022-10-08', 102, 'Lola'),
('Lovanimals', '2022-10-08', 182, 'Burek'),
('Lovanimals', '2022-10-08', 20, 'Urban'),
('Lovanimals', '2022-10-08', 81, 'Skoczek'),
('Money_wow', '2023-11-27', 304, 'Milutki'),
('Money_wow', '2023-11-27', 351, 'Amor'),
('Money_wow', '2023-11-27', 106, 'Zlota'),
('Kacperek_pl', '2020-01-17', 166, 'Bzyczek'),
('Kacperek_pl', '2020-01-17', 60, 'Harry'),
('Kacperek_pl', '2020-01-17', 430, 'Jasio'),
('Kacper_zwierz', '2020-12-29', 230, 'Krecik'),
('Kacper_zwierz', '2020-12-29', 30, 'Chytrusek'),
('Kacper_zwierz', '2020-12-29', 500, 'Stefania'),
('Marianna_mar', '2022-02-23', 230, 'Gigus'),
('Marianna_mar', '2022-02-23', 400, 'Maja'),
('Marianna_mar', '2022-02-23', 200, 'Tekla'),
('Marianna_mar', '2022-02-23', 185, 'Jaga'),
('Stefanik', '2022-05-14', 305, 'Elemelek'),
('Stefanik', '2022-05-14', 140, 'Kiler'),
('Stefanik', '2022-05-14', 208, 'Zermena'),
('Stefan', '2022-05-14', 23, 'Trabalski');


#Dodawanie danych do tabeli zwierzeta                                                       
INSERT INTO zwierzeta (imie, gatunek, wiek, opiekun, dotacje, czesc_zoo, stan_gatunku, data_przybycia) VALUES
('Kachna', 'slon', 5, 6, 1, 9, 4, '2018-11-12'),
('Mikus', 'kret', 8, 4, 2, 3, 5, '2020-08-04'),
('Lola', 'foka', 5, 2, 9, 1, 4, '2018-11-12'),
('Burek', 'zmija', 12, 2, 4, 5, 4, '2010-10-01'),
('Urban', 'mysz', 17, 1, 5, 2, 3, '2018-12-25'),
('Skoczek', 'kot', 3, 1, 6, 2, 5, '2019-10-24'),
('Milutki', 'krokodyl', 5, 2, 7, 1, 0, '2020-01-15'),
('Amor', 'glonojad', 2, 2, 8, 7, 3, '2021-04-11'),
('Zlota', 'ryba', 2, 2, 9, 7, 5, '2022-06-13'),
('Bzyczek', 'mucha', 1, 5, 10, 6, 5, '2022-07-15'),
('Harry', 'pies', 6, 1, 11, 4, 5, '2018-05-18'),
('Jasio', 'kanarek', 4, 5, 12, 8, 2, '2018-04-15'),
('Krecik', 'kret', 20, 4, 13, 3, 5, '2009-04-07'),
('Chytrusek', 'lisek', 6, 4, 14, 3, 3, '2017-08-19'),
('Stefania', 'pirania', 5, 2, 15, 7, 3, '2020-03-17'),
('Gigus', 'jelen', 2, 3, 16, 3, 5, '2018-05-18'),
('Maja', 'pszczola', 7, 5, 17, 6, 3, '2018-11-12'),
('Tekla', 'pajak', 12, 5, 18, 6, 5, '2020-09-21'),
('Jaga', 'zyrafa', 1, 6, 19, 9, 2, '2022-07-15'),
('Elemelek', 'wrobel', 4, 5, 20, 8, 1, '2022-07-15'),
('Kiler', 'osiol', 2, 6, 21, 2, 5, '2022-08-19'),
('Zermena', 'wielorybica', 23, 2, 22, 1, 3, '2022-08-19'),
('Trabalski', 'slon', 10, 6, 23, 9, 4, '2020-08-04');
                                                                                 

#Dodawanie danych do tabeli opiekun
INSERT INTO opiekun (ID, data_zatrudnienia, zwierze_opieka, okres_opieki) VALUES
(6,'2017-01-05', 'Kachna', '2018-11-12'),
(4, '2015-10-24', 'Mikus', '2020-08-04'),
(2, '2008-10-08', 'Lola', '2018-11-12'),
(2, '2008-10-08', 'Burek', '2010-10-01'),
(1, '2016-01-07', 'Urban', '2018-12-25'),
(1, '2016-01-07', 'Skoczek', '2019-10-24'),
(2, '2008-10-08', 'Milutki', '2022-01-15'),
(2, '2008-10-08', 'Amor', '2021-04-11'),
(2, '2008-10-08', 'Zlota', '2022-06-13'),
(5, '2020-06-07', 'Bzyczek', '2022-07-15'),
(1, '2016-01-07', 'Harry', '2018-05-18'),
(5, '2020-06-07', 'Jasio', '2018-04-15'),
(4, '2015-10-24', 'Krecik', '2009-04-07'),
(4, '2015-10-24', 'Chytrusek', '2017-08-19'),
(2, '2008-10-08', 'Stefania', '2020-03-17'),
(3, '2020-06-07', 'Gigus', '2018-05-18'),
(5, '2020-06-07', 'Maja', '2018-11-12'),
(5, '2020-06-07', 'Tekla', '2020-09-21'),
(6, '2017-01-05', 'Jaga', '2022-07-15'),
(5, '2020-06-07', 'Elemelek', '2022-07-15'),
(6, '2017-01-05', 'Kiler', '2022-08-19'),
(2, '2008-10-08', 'Zermena', '2022-08-19'),
(6, '2017-01-05', 'Trabalski', '2020-08-04');


#Dodawanie danych do tabeli gdzie_zwierze
INSERT INTO gdzie_zwierze (nazwa_obszaru, zwierze, data_pobytu) VALUES
('Pawilon sLoni', 'Kachna', '2018-11-12'),
('Pawilon zwierzat dzikich', 'Mikus', '2020-08-04'),
('Pawilon wodny', 'Lola', '2018-11-12'),
('Pawilon wezy', 'Burek', '2010-10-01'),
('Pawilon zwierzat hodowlanych', 'Urban', '2018-12-25'),
('Pawilon zwierzat hodowlanych', 'Skoczek', '2019-10-24'),
('Pawilon wodny', 'Milutki', '2022-01-15'),
('Oceanarium', 'Amor', '2021-04-11'),
('Oceanarium', 'Zlota', '2022-06-13'),
('Pawilon owadow, pajeczakow', 'Bzyczek', '2022-07-15'),
('Pawilon zwierzat domowych', 'Harry', '2018-05-18'),
('Pawilon ptakow', 'Jasio', '2018-04-15'),
('Pawilon zwierzat dzikich', 'Krecik', '2009-04-07'),
('Pawilon zwierzat dzikich', 'Chytrusek', '2017-08-19'),
('Oceanarium', 'Stefania', '2020-03-17'),
('Pawilon zwierzat dzikich', 'Gigus', '2018-05-18'),
('Pawilon owadow, pajeczakow', 'Maja', '2018-11-12'),
('Pawilon owadow, pajeczakow', 'Tekla', '2020-09-21'),
('Pawilon sLoni', 'Jaga', '2022-07-15'),
('Pawilon ptakow', 'Elemelek', '2022-07-15'),
('Pawilon zwierzat hodowlanych', 'Kiler', '2022-08-19'),
('Pawilon zwierzat hodowlanych', 'Zermena', '2022-08-19'),
('Pawilon sLoni', 'Trabalski', '2020-08-04');


#Dodawanie danych do tabeli karta_przyjecia
INSERT INTO karta_przyjecia (data_przyjecia, stan, kraj_pochodzenia) VALUES
('2018-11-12', 4, 'Tanzania'),
('2020-08-04', 5, 'Czechy'),
('2018-11-12', 4, 'Portugalia'),
('2010-10-01', 4, 'Slowacja'),
('2018-12-25', 3, 'Litwa'),
('2019-10-24', 5, 'Polska'),
('2022-01-15', 0, 'Brazylia'),
('2021-04-11', 3, 'Islandia'),
('2022-06-13', 5, 'Brazylia'),
('2022-07-15', 5, 'Rosja'),
('2018-05-18', 5, 'Litwa'),
('2018-04-15', 2, 'Czechy'),
('2009-04-07', 5, 'Nowa Zelandia'),
('2017-08-19', 3, 'Boliwia'),
('2020-03-17', 3, 'Brazylia'),
('2018-05-18', 5, 'Tanzania'),
('2018-11-12', 3, 'Polska'),
('2020-09-21', 5, 'Australia'),
('2022-07-15', 2, 'Tanzania'),
('2022-07-15', 1, 'Wenezuela'),
('2022-08-19', 5, 'Etiopia'),
('2022-08-19', 3, 'Islandia'),
('2020-08-04', 4, 'Kenia');

select * from zwierzeta;
select * from gdzie_zwierze;

#insert kluczy obcych do zpartycjonowanej tabeli
insert into karta_przyjecia (id, stan)
select zwierzeta.id, stan_gatunku.id
from zwierzeta 
join stan_gatunku on zwierzeta.stan_gatunku = stan_gatunku.id;

select * from karta_przyjecia;



#procedura 1 - suma kwot dotacji
CREATE PROCEDURE suma_dotacji()
BEGIN
    SELECT org_name, SUM(amount) AS suma_dotacji
    FROM sponsorzy
    GROUP BY org_name;
END;

call suma_dotacji();

#procedura 2 - zmiana opiekuna danego zwierzęcia
CREATE PROCEDURE zmiana_opiekuna(IN nowe_zwierze VARCHAR(50), IN nowy_opiekun INT)
BEGIN
    DECLARE stare_opiekun_id INT;

    SELECT ID INTO stare_opiekun_id
    FROM opiekun
    WHERE zwierze_opieka = nowe_zwierze
    LIMIT 1;

    IF stare_opiekun_id IS NOT NULL THEN
        UPDATE opiekun
        SET ID = nowy_opiekun
        WHERE zwierze_opieka = nowe_zwierze;
    END IF;
END;

select * from opiekun;

CALL zmiana_opiekuna('Lola', 4);

#procedura 3 aktualizowanie sponsorów w tabeli sponsorzy (dodawanie sponsorów)
CREATE PROCEDURE DodajSponsora (
    IN orgName VARCHAR(50),
    IN donateDate DATE,
    IN amount DECIMAL(10,2),
    IN animalName VARCHAR(50)
)
BEGIN
    INSERT INTO sponsorzy (org_name, donate_date, amount, animal_name)
    VALUES (orgName, donateDate, amount, animalName);
END;

CALL DodajSponsora('Help_animal', '2021-07-08', 300.00, 'Kachna');

select * from sponsorzy;


#indeksowanie - indeksowanie zwierzat po imieniu i gatunku
create or replace unique index zwierze on zwierzeta(imie, gatunek);

select * from zwierzeta;

#funkcja licząca ile jest zwierząt w danym obszarze ZOO
CREATE FUNCTION IleZwierzatnaobszar (
    NazwaObszaru VARCHAR(50)
)
RETURNS INT
BEGIN
    DECLARE LiczbaZwierzat INT;

    SELECT COUNT(*)
    INTO LiczbaZwierzat
    FROM zwierzeta z
    INNER JOIN obszary_zoo o ON z.czesc_zoo = o.ID
    WHERE o.nazwa_obszaru = NazwaObszaru;

    RETURN LiczbaZwierzat;
end;

SELECT IleZwierzatnaobszar('Oceanarium');


#Funckja wypisująca,, które gatunki są bardzo zagrożone lub wyginęły
CREATE FUNCTION GatunkiZagrożone()
RETURNS VARCHAR(255)
BEGIN
    DECLARE lista_gatunkow VARCHAR(255);

    SELECT GROUP_CONCAT(DISTINCT gatunek)
    INTO lista_gatunkow
    FROM zwierzeta
    WHERE stan_gatunku = 1 or stan_gatunku = 0;

    IF lista_gatunkow IS NULL THEN
        SET lista_gatunkow = 'Brak zagrożonych gatunków.';
    END IF;

    RETURN lista_gatunkow;
END ;

select GatunkiZagrożone() as GatunkiZagrożone; 

#funkcja licząca ile jest zwierząt danego gatunku
create function liczba_zwierzat_gatunku(
    gatunek_param VARCHAR(50)
)
returns INT
begin
    declare ilosc INT;

    select COUNT(*) into ilosc
    from zwierzeta
    where gatunek = gatunek_param;

    return ilosc;
end;

select liczba_zwierzat_gatunku ('slon') as ilosc_zwierzat;

#Widok zwierząt z podziałem na stan gatunku
CREATE VIEW Zwierzeta_StanGatunku AS
SELECT *,
       CASE
           when stan_gatunku = 0 then 'Zanikające'
           when stan_gatunku = 1 then 'Duże ryzyko wyginięcie'
           when stan_gatunku = 2 then 'Duże ryzyko wyginięcie'
           when stan_gatunku = 3 then 'Zagrożone'
           when stan_gatunku = 4 then 'Zagrożone'
           when stan_gatunku = 5 then 'Powszechnie występujące'
           else 'Nieznany'
       end as status_gatunku
FROM zwierzeta;

select * from Zwierzeta_StanGatunku;

#Widok, jaki opiekun zajmował się jakim zwierzęciem
CREATE VIEW WidokZwierzatOpiekuna AS
SELECT opiekun, GROUP_CONCAT(CONCAT(imie, ' (', gatunek, ')') ORDER BY imie ASC) AS zwierzeta_opiekuna
FROM zwierzeta
WHERE opiekun IS NOT NULL
GROUP BY opiekun;

select * from widokzwierzatopiekuna;


#Widok na jakim obszarze zoo jakie zwierzęta przebywały
create view zwierzeta_obszary AS
SELECT czesc_zoo, GROUP_CONCAT(CONCAT(imie, ' (', gatunek, ')') ORDER BY imie ASC) AS zwierzeta_w_obszarze
FROM zwierzeta
GROUP BY czesc_zoo;

select * from zwierzeta_obszary;


