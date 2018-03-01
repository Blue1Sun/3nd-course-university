-- Предмет "Базы данных"
-- Вариант 7
/*
Л. р. №1. Создание и заполнение отношений БД собственников квартир.
1. Отношение "Адреса" (поля "Номер здания" (ПК), "Название улицы", "Номер дома").
2. Отношение "Собственники" (поля "Идентификатор" (ПК), "ФИО", "Дата рождения", "Пол").
3. Отношение "Документы" (поля "Владелец" (ВнК), "Тип документа", "Серия документа", "Номер документа", "Кем и когда выдан").
4. Отношение "Владение":
Содержимое поля 	Тип 	Длина 	Дес. 	Примечание
Владелец 			N 		6 		0 		внешний ключ к таблице "Собственники"
Номер здания 		N 		6 		0 		внешний ключ к таблице "Адреса"
Номер квартиры 		N 		4 				обязательное поле
Доля 				С 		8 				часть квартиры, которой он владеет (например, 1, 1/3, 0.25 и т.д.)
Начало владения 	D 						обязательное поле
Окончание владения 	D
*/

CREATE TABLE adresses(
 	buildingID numeric(6) PRIMARY KEY,
	street varchar(50) NOT NULL,
	buildingNumber numeric(3) NOT NULL);

CREATE TABLE owners(
	ownerID numeric(6) PRIMARY KEY,
	fio varchar(100) NOT NULL,
	datebirth date NOT NULL, 
	sex varchar(1) NOT NULL);

CREATE TABLE documents(
	ownerID numeric(6) REFERENCES owners(ownerID), 
	type varchar(50) NOT NULL,
	series numeric(2) NOT NULL, 
	num numeric(3) NOT NULL,
	issued varchar(100) NOT NULL); 

CREATE TABLE ownership(
	ownerID numeric(6) REFERENCES owners(ownerID),
	buildingID numeric(6) REFERENCES adresses(buildingID),
	apartment numeric(4) NOT NULL,
	share varchar(8) NOT NULL, 
	ownbegin date NOT NULL,
	ownend date);

-- Задание 3 
/*
Л.р. №3. 
Работа с представлениями. 
Для созданных представлений необходимо проверить с помощью запросов 
UPDATE, DELETE и INSERT, являются ли они обновляемыми, и объяснить полученный результат.
1.  Представление "Квартиры, в числе собственников которых в 
настоящее время есть несовершеннолетние дети".*/
create view view1
as select a.*
from adresses a, ownership os, owners o
where (os.ownerID = o.ownerID AND os.buildingID = a.buildingID AND (o.datebirth > curdate() - INTERVAL 18 YEAR) AND os.ownbegin < curdate()) AND (os.ownend > curdate());

/*2.  Представление "Количество собственников по домам": 
номер здания – улица – номер дома – количество текущих собственников.*/
create view view2
as select a.buildingID, a.street, a.buildingNumber, count(*)
from adresses a, ownership o
where (o.ownbegin < curdate()) AND (o.ownend > curdate())
group by a.buildingID;

/*3.  Представление "Количество текущих собственников" 
по всем квартирам, включая квартиры, у которых нет собственников.*/
create view view3
as select a.*, count(*)
from adresses a, ownership o
where (o.ownbegin < curdate()) AND (o.ownend > curdate())
group by a.buildingID
UNION 
select *, 0
from adresses
where buildingID NOT IN (select buildingID from ownership);


-- Задание 4 
--проекция
select distinct fio, datebirth
from owners; 
--селекция
select * 
from documents
where type = 'passport';
--декартово произведение
select * 
from adresses, owners
order by buildingID;
--объединение
select buildingID, street, buildingNumber 
from adresses
union 
select ownerID, type, num 
from documents; 
--разность
select o.ownerID 
from owners o
where o.ownerID NOT IN (select os.ownerID from ownership os);
--пересечение
select o.*
from extra as e, owners as o
where (e.ownerID = o.ownerID, e.fio = o.fio, e.datebirth = o.datebirth, e.sex = o.sex); 
--соединение
--фактически декартово произведение с селекцией
select * 
from documents d, owners o
where (d.ownerID = o.ownerID)
order by ownerID;
--деление
select buildingID 
from ownership 
where share in ('0.1','1') 
group by buildingID 
having count(share)>1;