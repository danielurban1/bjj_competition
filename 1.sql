create database zawody_bjj; 
use zawody_bjj;
CREATE TABLE `zawody_bjj`.`login` (
  `id_login` INT NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(45) NOT NULL,
  `haslo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id_login`),
  UNIQUE INDEX `id_login_UNIQUE` (`id_login` ASC),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC));
LOAD DATA LOCAL INFILE 'C:/Users/oem/Desktop/loginyxlsx.txt' INTO TABLE login;
select * from login;
delete from  dane_os;
CREATE TABLE `zawody_bjj`.`dane_os` (
  `id_login` INT NOT NULL AUTO_INCREMENT,
  `imie_nazwisko` VARCHAR(45) NOT NULL,
  `kategoria` INT NOT NULL,
  `klub` INT NOT NULL,
  PRIMARY KEY (`id_login`),
  CONSTRAINT `id_login`
    FOREIGN KEY (`id_login`)
    REFERENCES `zawody_bjj`.`login` (`id_login`));
ALTER TABLE `zawody_bjj`.`dane_os` 
COLLATE = utf8_polish_ci ;
LOAD DATA LOCAL INFILE 'C:/Users/oem/Desktop/adult.txt' INTO TABLE dane_os;
select * from dane_os;
CREATE TABLE `zawody_bjj`.`kluby` (
  `id_klubu` INT NOT NULL AUTO_INCREMENT,
  `nazwa_klubu` VARCHAR(45) NULL,
  PRIMARY KEY (`id_klubu`),
  UNIQUE INDEX `id_klubu_UNIQUE` (`id_klubu` ASC));
ALTER TABLE `zawody_bjj`.`kluby` 
COLLATE = utf8_polish_ci ;
LOAD DATA LOCAL INFILE 'C:/Users/oem/Desktop/kluby.txt' INTO TABLE kluby;
select * from kluby;
delete from kluby where id_klubu = '65';
ALTER TABLE `zawody_bjj`.`dane_os` 
ADD INDEX `klub_idx` (`klub` ASC);
ALTER TABLE `zawody_bjj`.`dane_os` 
ADD CONSTRAINT `klub`
  FOREIGN KEY (`klub`)
  REFERENCES `zawody_bjj`.`kluby` (`id_klubu`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
CREATE TABLE `zawody_bjj`.`sedziowie` (
  `id_sedziego` INT NOT NULL AUTO_INCREMENT,
  `imie_sedziego` VARCHAR(45) NULL,
  PRIMARY KEY (`id_sedziego`));
LOAD DATA LOCAL INFILE 'C:/Users/oem/Desktop/sedziowie.txt' INTO TABLE sedziowie;
select * from sedziowie;
CREATE TABLE `zawody_bjj`.`maty` (
  `id_maty` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_maty`));
insert into  maty values(1);
insert into  maty values(2);
insert into  maty values(3);
insert into  maty values(4);
insert into  maty values(5);
insert into  maty values(6);
select * from maty;
CREATE TABLE `zawody_bjj`.`kategorie_wagowe` (
  `id_kategorii` INT NOT NULL AUTO_INCREMENT,
  `nazwa` VARCHAR(45) NOT NULL,
  `mata` INT NOT NULL,
  `sedzia` INT NOT NULL,
  `godzina` DATE NOT NULL,
  PRIMARY KEY (`id_kategorii`),
  INDEX `mata_idx` (`mata` ASC),
  INDEX `sedzia_idx` (`sedzia` ASC),
  CONSTRAINT `mata`
    FOREIGN KEY (`mata`)
    REFERENCES `zawody_bjj`.`maty` (`id_maty`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `sedzia`
    FOREIGN KEY (`sedzia`)
    REFERENCES `zawody_bjj`.`sedziowie` (`id_sedziego`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
ALTER TABLE `zawody_bjj`.`kategorie_wagowe` 
DROP COLUMN `godzina`;
LOAD DATA LOCAL INFILE 'C:/Users/oem/Desktop/zawody/Kategoriewag.txt' INTO TABLE kategorie_wagowe;
select * from kategorie_wagowe;
select imie_nazwisko, kategorie_wagowe.nazwa, nazwa_klubu from dane_os, kategorie_wagowe, kluby where kategoria = id_kategorii and id_klubu = klub order by kategorie_wagowe.nazwa;
CREATE TABLE `zawody_bjj`.`medalisci` (
  `id_medalisty` INT NOT NULL AUTO_INCREMENT,
  `id_zawodnika` INT NOT NULL,
  `id_kategorii` INT NOT NULL,
  `id_klubu` INT NOT NULL,
  `miejsce` INT NOT NULL,
  PRIMARY KEY (`id_medalisty`),
  INDEX `id_zawodnika_idx` (`id_zawodnika` ASC),
  INDEX `id_kategorii_idx` (`id_kategorii` ASC),
  INDEX `id_klubu_idx` (`id_klubu` ASC),
  CONSTRAINT `id_zawodnika`
    FOREIGN KEY (`id_zawodnika`)
    REFERENCES `zawody_bjj`.`dane_os` (`id_login`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_kategorii`
    FOREIGN KEY (`id_kategorii`)
    REFERENCES `zawody_bjj`.`kategorie_wagowe` (`id_kategorii`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `id_klubu`
    FOREIGN KEY (`id_klubu`)
    REFERENCES `zawody_bjj`.`kluby` (`id_klubu`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
ALTER TABLE `zawody_bjj`.`kluby` 
CHANGE COLUMN `nazwa_klubu` `nazwa_klubu` VARCHAR(45) CHARACTER SET 'utf8' NOT NULL ,
ADD COLUMN `zlote_medale` INT NOT NULL AFTER `nazwa_klubu`,
ADD COLUMN `srebrne_medale` INT NOT NULL AFTER `zlote_medale`,
ADD COLUMN `brazowe medale` INT NOT NULL AFTER `srebrne_medale`,
ADD COLUMN `punkty` INT NOT NULL AFTER `brazowe medale`;
select * from kluby;
CREATE trigger `zawody_bjj`.`medalisci_AFTER_INSERT` AFTER INSERT ON `medalisci` FOR EACH ROW
BEGIN
if miejsce = 1 and id_kategorii != 1 and id_kategorii != 2 and id_kategorii != 3 and id_kategorii != 4 and id_kategorii != 5 and id_kategorii != 6 and id_kategorii != 7 and id_kategorii != 8 and id_kategorii != 9 then
set  new.kluby.zlote_medale = kluby.zlote_medale+1 and new.kluby.punkty = kluby.punkty+5;
elseif  miejsce = 2 and id_kategorii != 1 and id_kategorii != 2 and id_kategorii != 3 and id_kategorii != 4 and id_kategorii != 5 and id_kategorii != 6 and id_kategorii != 7 and id_kategorii != 8 and id_kategorii != 9 then
set  new.kluby.srebrne_medale = kluby.srebrne_medale and new.kluby.punkty = kluby.punkty+3;
elseif miejsce = 3 and id_kategorii != 1 and id_kategorii != 2 and id_kategorii != 3 and id_kategorii != 4 and id_kategorii != 5 and id_kategorii != 6 and id_kategorii != 7 and id_kategorii != 8 and id_kategorii != 9 then
set  new.kluby.zlote_medale = kluby.zlote_medale and new.kluby.punkty = kluby.punkty+3;
end if;
END;
