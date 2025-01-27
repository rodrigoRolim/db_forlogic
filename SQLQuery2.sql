use IntroMSSQL
select count(month(login_date)) as qtd_log_month, c.customer_name
from dbo.logins as l join dbo.customers as c on l.id_user = c.id  
group by c.customer_name
--
select avg(l.id_user) as media, day(login_date) as dia  
from dbo.logins as l
group by day(login_date)
order by day(login_date)
--
select top(10) dbo.stored_files.length 
from  dbo.stored_files 
order by dbo.stored_files.length desc
--
select s.name as estado_100, count(c.name) as n_cidades
from dbo.cities as c join dbo.states as s on s.id = c.id_state
group by s.name
having count(c.name) > 100
--
go

