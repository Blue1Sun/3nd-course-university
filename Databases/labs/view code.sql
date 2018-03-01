-- 1.	Представление "Количественные показатели": 
-- научное направление – количество грантов – общая сумма финансирования.
create view qind
as select s.name, count(*), sum(sumf)
	from scidir as s, grants as g
	where (s.id_dir = g.dir)
	group by s.name;

--2.	Представление "Участники и руководители": 
--ФИО – шифр гранта – даты начала и завершения – название темы – отношение к гранту (руководитель или исполнитель).
create view memhead
as select s.name as 'fio', g.id_gr, g.bdate, g.edate, g.name as 'grant', 'head'
	from sci as s, grants as g
	where (g.head = s.id_sci)
union
select s.name as 'fio', g.id_gr, g.bdate, g.edate, g.name as 'grant', 'member'
	from sci as s, grants as g, members as m
	where (m.person = s.id_sci) AND (m.grants = g.id_gr) AND (g.head != s.id_sci)
order by 1;
--3.	Представление "Руководители текущих грантов".
create view curhead
as select s.name as 'Head', g.name as 'CurGrant'
	from sci as s, grants as g
	where (s.id_sci = g.head) AND (curdate() < g.edate) AND (curdate() > g.bdate);


--проекция
select distinct degree, title 
from sci; 
--селекция
select * 
from grants
where dir='221B';
--декартово произведение
select * 
from scidir,members 
order by id_dir;
--объединение
select id_sci, name, title 
from sci
union 
select id_gr, name, org from grants; 
--разность
select id_dir 
from scidir
where id_dir NOT IN (select dir from grants);
--пересечение
select d.*
from extra as e, scidir as d
where (e.id = d.id_dir AND e.title = d.name); 
--соединение
select * 
from scidir, grants 
where (id_dir = dir)
order by id_dir;
--деление
select name 
from extra2 
where person in ('Петров','Сидоров') 
group by name 
having count(person)>1;
