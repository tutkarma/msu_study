-- 01. Выбрать все заказы
select * 
from oltp_test.sales_order;

-- 02. Выбрать все заказы, введенные после 1 января 2016 года
select *
from oltp_test.sales_order
where order_date > to_date('2016/01/01', 'yyyy/mm/dd');

-- 03. Выбрать все заказы, введенные после 1 января 2016 года и до 15 июля 2016 года
select *
from oltp_test.sales_order
where order_date between to_date('2016/01/01', 'yyyy/mm/dd') and to_date('2016/07/15', 'yyyy/mm/dd');

-- 04. Найти менеджеров с именем 'Henry'
select *
from oltp_test.manager
where manager_first_name = 'Henry';

-- 05. Выбрать все заказы менеджеров с именем Henry
select *
from oltp_test.manager t1 join oltp_test.sales_order t2
on t1.manager_id = t2.manager_id
where t1.manager_first_name = 'Henry';

-- 06. Выбрать все уникальные страны из таблицы CITY
select distinct country
from oltp_test.city;

-- 07. Выбрать все уникальные комбинации страны и региона из таблицы CITY
select distinct country, region
from oltp_test.city;

-- 08. Выбрать все страны из таблицы CITY с количеством городов в них.
select country, count(city_id) as city_cnt
from oltp_test.city
group by country;

-- 09. Выбрать количество товаров (QTY), проданное с 1 по 30 января 2016 года.
select sum(t1.product_qty)
from oltp_test.sales_order_line t1 join oltp_test.sales_order t2
on t1.sales_order_id = t2.sales_order_id;
where t2.order_date between to_date('2016/01/01', 'yyyy/mm/dd') and to_date('2016/01/30', 'yyyy/mm/dd');

-- 10. Выбрать все уникальные названия городов, регионов и стран в одной колонке
select distinct city_name
from oltp_test.city
union
select distinct region
from oltp_test.city
union
select distinct country
from oltp_test.city;

-- 11. Вывести имена и фамилии менеджер(ов), продавшего товаров в январе 2016 года на наибольшую сумму.
with manager_sales as (
    select so.manager_id, sum(sol.product_price * sol.product_qty-) as sum_sales
    from oltp_test.sales_order_line sol join oltp_test.sales_order so
    on sol.sales_order_id = so.sales_order_id
    where so.order_date between to_date('2016/01/01', 'yyyy/mm/dd') and to_date('2016/01/30', 'yyyy/mm/dd')
    group by so.manager_id
)

select t1.manager_first_name, t1.manager_last_name
from oltp_test.manager t1 join manager_sales t2
on t1.manager_id = t2.manager_id
where t2.sum_sales >= all (select sum_sales from manager_sales);
