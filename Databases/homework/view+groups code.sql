
--текущие больные 
create view Cur_Sick
as select distinct cl.name as 'Owner name', p.*, d.name as 'Diagnose'
from Pets p, Card c, Appointment a, Clients cl, Diagnoses d
where ((p.Owner = cl.Id) AND (c.Rec_Date IS NULL) AND (c.Doctor = a.Doctor) AND (c.Diagnose = d.id) AND (c.Reg_date = a.Date_Time) AND (a.Pet = p.Id));

--животные, больные определенным заболеванием+ инфа 
create view Animal_Ill
as select p.*, c.Reg_date
from Pets p, Card c, Appointment a, Diagnoses d
where ((c.Doctor = a.Doctor) AND (c.Reg_date = a.Date_Time) AND (a.Pet = p.Id) AND (c.Diagnose = d.id) AND (d.name = 'Ящур'));
 
--врачи 1ого отделения+кто не занят сегодня
create Depart_Doc
as select d.*, dc.name as 'Doctor name', dc.surname as 'Doctor surname'
from Departs d, Doctors dc
where ((d.number = 1) AND (dc.Depart = d.Number) AND dc.Id NOT IN (select Doctor from Appointment where year(Date_Time) = year(curdate()) AND month(Date_Time) = month(curdate()) AND day(Date_Time) = day(curdate()));


--личный кабинет клиента 1 (животные-приемы-время-стоимость итп) 
create Cli_Acc
as select p.name, p.species, a.Date_Time, d.name as 'Doctor name', d.surname as 'Doctor surname', a.Room as 'Room', s.Name, s.cost
from Pets p, Appointment a, Services s, Doctors d
where ((p.Owner = 1) AND (a.Pet = p.Id) AND (a.Service = s.Id) AND (a.Doctor = d.Id));

--возможные диагнозы на определенный симптом
create Dia_Symp
as select d.*
from Diagnoses s, Symptoms s, Diag_Symp ds
where ((ds.Symptom = s.Id) AND (ds.Diagnose = d.Id) AND (s.Name like 'тошнота'));

--будущее расписание врача, зашедшего под логином gudin 
create Doc_Sch
as select a.Date_Time, a.Room as 'Room', p.name as 'Pet', s.Name as 'Service' 
from Appointment a, Doctors d, Pet p, Services s
where ((d.login = 'gudin') AND (a.Doctor = d.Id) AND (a.Date_Time > curdate()) AND (a.Pet = p.Id) AND (a.Service = s.Id));

--услуги + стоимость 
create Serv_Cost
as select s.name, s.cost
from Services s;

--данные об отделениях для руководителя отделения 

--данные о сотрудниках отделения для руводителя
create Dep_work
as select dc.*
from Departs d, Doctors dc, Doctors dhead
where ((dhead.role = 'руководитель') AND (dhead.login = 'gudin') AND (dhead.Depart = d.Number) AND (dc.Depart = d.Number));

--РК - рукво клиники
--РО - рукво отделений
--К - клиенты
--В - врачи
--Р - ресепшн
--Б - бухгалтер

--расписание врача -- РК(SIUD), РО(SIUD), К(S), В(S), Р(SIU)
--услуги + стоимость -- РК(SIUD), РО(S), К(S), Р(S)
--данные об отделениях для руководителя отделения -- РК(SIUD), РО(S)
--данные о сотрудниках отделения для руводителя -- РК(SIUD), РО(S)
--выписка на получение зарплаты -- Б(S)
--текущие больные -- РО(S), В(S)
--животные, больные определенным заболеванием+ инфа -- РО(S), В(S)
--отделения+ их услуги+кто не занят(опционально) -- РО(S), К(S), Р(S)
--личный кабинет клиента(животные-приемы-время-стоимость итп) -- К(S)
--возможные диагнозы на определенный симптом -- РО(S), РК(S)

--create index e_posts on employees(e_post);
--create index e_tel on employees(e_room, e_phone);

create index R_Depart on Rooms(Depart);
create index P_Owner on Pets(Owner);
create index D_Depart on Doctors(Depart);
create index D_Position on Doctors(Position);
create index E_Id on Education(Id);
create index AP_Id on Address_Phone(Id);
create index DS_Symptom on Diag_Symp(Symptom);
create index DS_Diagnose on Diag_Symp(Diagnose);
create index S_Depart on Services(Depart);
create index SM_Service on Serv_Med(Service);
create index SM_Medicine on Serv_Med(Medicine);
create index SE_Service on Serv_Equip(Service);
create index SE_Equipment on Serv_Equip(Equipment);
create index A_Doctor on Appointment(Doctor);
create index A_Pet on Appointment(Pet);
create index A_Service on Appointment(Service);
create index A_Room on Appointment(Room);
create index C_Diagnose on Card(Diagnose);
create index C_Appoint on Card(Appoint);