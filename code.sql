create database sales_db;
use sales_db;

-- use import data by wizared to insert to database Sales_db

select * from sales_db.sales;

-- Staet clean data 
-- check for duplicates data 
select count(transaction_id) from sales_db.sales;
-- count rows 943
with sales_duplicates as(
           select *,
                  row_number() over(partition by transaction_id order by transaction_id) as rn
           from sales_db.sales )
 select * from sales_duplicates where rn >1 ;
 -- return 3 rows duplicates in table 
 -- delete this 3 rows 
 create table rm_dup_sales as (
               Select distinct * from sales_db.sales );
drop table sales_db.sales;
-- insert new data in sales table with out duplicates
create table  sales as ( select * from sales_db.rm_dup_sales);
drop table sales_db.rm_dup_sales;
--   check for Null Values
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'sales_db'
  AND TABLE_NAME = 'sales' group by COLUMN_NAME ;      

-- handle nulls in category change to Unknown
select distinct category from sales_db.sales;
update sales_db.sales
set category ='Unknown'
where category='';

-- handle nulls in customer_address' Not Aviable'
select customer_address from sales_db.sales where customer_address is null or customer_address ='';
update sales_db.sales
set customer_address ='Not Avaiable'
where customer_address='';


-- handle payment_method nulls and 'Cash'
select distinct(payment_method) from sales_db.sales;
update sales_db.sales
set payment_method = 'Cash'
where payment_method='';

-- handle payment_method Credit Card
 update sales_db.sales
 set payment_method='Credit Card'
 where payment_method in('CC','credit','creditcard');
 
 -- handle delivery_status nulls to 'Not Delivered
 select distinct(delivery_status) from sales_db.sales;
 update sales_db.sales
 set delivery_status='Not Delivered'
 where delivery_status='';
 
 -- handle price by Avg(price) but groupby category
 select category,round(avg(price),2) from sales_db.sales group by category ;
 /* Clothing	2539.28
Electronics	2663.93
Books	2591.65
Toys	2237.2
Unknown	2511.42
Home & Kitchen	2507.06 */
update sales_db.sales
 set  price = 2591.65
 where price = '' and category ='Books';
 
  update sales_db.sales
 set  price = 2237.2
 where price = '' and category ='Toys';
 
 update sales_db.sales
 set  price = 2663.93
 where price = '' and category ='Electronics';

 update sales_db.sales
 set  price = 2511.42
 where price = '' and category ='Clothing';
 
 update sales_db.sales
 set  price = 2539.28
 where price = '' and category ='Unknown';
 
  update sales_db.sales
 set  price = 2507.06
 where price = '' and category ='Home & Kitchen';
 
 -- handle negative vlues quantity 295 negative values
 select * from sales_db.sales where quantity<0;
 update sales_db.sales
 set quantity = ABS(quantity) where quantity<0;
 
 -- handle Total_amount = price*quantity
 update sales_db.sales
 set total_amount = round((price*quantity),2)
 where total_amount='' or total_amount<>price*quantity;
 
-- handle customer_name nulls insert 'User'
select * from sales_db.sales where customer_name ='';

update sales_db.sales
set customer_name ='User'
where customer_name='';

-- handle date in purchase_date when check the date find the type column purchase_date is text and 
-- some date format dd/mm/yyyy and some is yyyy-mm-dd and error in date 2024-02-30 but correct to 2024-02-29
select * from sales_db.sales where purchase_date is null;
UPDATE sales_db.sales
SET purchase_date = CASE
    WHEN purchase_date ='2024-02-30'
    THEN date('2024-02-29')
    ELSE  STR_TO_DATE(purchase_date, '%d/%m/%Y')
END;

ALTER TABLE sales_db.sales
MODIFY COLUMN purchase_date DATE;

-- handle Email Address not correct to null
select * from sales_db.sales where email not like'%@%';

update sales_db.sales
set email= null where email not like '%@%';


update sales_db.sales
set purchase_date=date('2024-02-29') where purchase_date is null;

    






