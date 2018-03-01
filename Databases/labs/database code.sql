/*
		База данных научного фонда
*/

/*Отношение Научные направления*/
create table scidir 
	(
		id_dir varchar(8) primary key,
		name varchar(100) not null unique);

/*Отношение Ученые*/
create table sci
	(
		id_sci numeric(6) primary key,
		name varchar(100) not null,
		birth date not null,
		degree varchar(20),
		title varchar(50) not null);

/*Отношение Гранты*/
create table grants
	(
		id_gr varchar(10) primary key,
		dir varchar(8) references scidir(id_dir), 
		head numeric(6) references sci(id_sci),
		name varchar(100) not null,
		bdate date not null,
		org varchar(60) not null,
		edate date not null,
		sumf numeric(8) not null);

/*Отношение Участники*/
create table members
	(
		grants varchar(10) references grants(id_gr),
		person numeric(6) references sci(id_sci));
/*CHECK TEST ---- DOESN'T WORK
create table test
	(
		bdate date not null,
		edate date not null
		);
*/

/*Триггеры на grants sumf > 0*/
delimiter // 
create trigger chk1_gr before insert on grants
for each row 
begin 
	if (new.sumf < 0) then 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Cannot add row: sumf needs to be more then 0'; 
	end if; 
	if (new.bdate > new.edate) then 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Cannot add row: bdate needs to be less then edate'; 
	end if; 
end; 
//
delimiter ;

delimiter // 
create trigger chk2_gr before update on grants 
for each row 
begin 
	if (new.sumf < 0) then 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Cannot update row: sumf needs to be more then 0'; 
	end if; 
	if (new.bdate > new.edate) then 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Cannot update row: bdate needs to be less then edate'; 
	end if; 
end; 
//
delimiter ;

/*Триггеры на sci birth и degree*/
delimiter // 
create trigger chk1_sci before insert on sci
for each row 
begin 
	if (new.birth > curdate()-INTERVAL 20 YEAR) or (new.birth < curdate()-INTERVAL 100 YEAR) then 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Cannot add row: age needs to be more then 20 but less then 100 years'; 
	end if; 
	if (new.degree not in ('доктор наук', 'кандидат наук') and new.degree is not null) then 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Cannot add row: wrong degree'; 
	end if; 
end; 
//
delimiter ;

delimiter // 
create trigger chk2_sci before update on sci 
for each row 
begin 
	if (new.birth > curdate()-INTERVAL 20 YEAR) or (new.birth < curdate()-INTERVAL 100 YEAR) then 
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Cannot update row: age needs to be more then 20 but less then 100 years'; 
	end if; 
	if (new.degree not in ('доктор наук', 'кандидат наук') and new.degree is not null) then  
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Cannot update row: wrong degree'; 
	end if; 
end; 
//
delimiter ;

/*
insert into members values ('A21', 1);
insert into members values ('A21', 2);
insert into members values ('A21', 3);
insert into members values ('A21', 4);
insert into members values ('A21', 5);
insert into members values ('A21', 6);
insert into members values ('A21', 7);
insert into members values ('A21', 8);
insert into members values ('A21', 9);
insert into members values ('A21', 10);
insert into members values ('A21', 11);
insert into members values ('35H', 19);
insert into members values ('14F', 15);
insert into members values ('95K', 17);
insert into members values ('I43', 18);
insert into members values ('1B7', 20);
insert into members values ('9DA', 16);
insert into members values ('95K', 14);
*/

/*•	проектов по научному направлению "Телекоммуникационные системы и сети";*/

/*•	количество грантов по разделам науки, выполняемых в текущем году;*/

/*•	научных направлений, по которым не выдано ни одного гранта;*/

/*•	ученых, которые являются руководителем одного гранта и участником другого;*/

/*•	гранты, в которых участвует более 10 человек (не считая руководителя).*/