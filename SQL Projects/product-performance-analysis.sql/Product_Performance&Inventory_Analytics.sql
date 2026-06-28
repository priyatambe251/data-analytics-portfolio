CREATE TABLE PRODUCTS(
  PRODUCT_ID varchar(10) PRIMARY KEY,
  check PRODUCT_ID like 'P%',
  product_name varchar(50),
  category varchar(50),
  price decimal(10,2)
);
CREATE TABLE ORDERS(
  ORDER_ID VARCHAR(10) PRIMARY KEY,
  CHECK ORDER_ID LIKE 'O%'
  PRODUCT_ID VARCHAR(10),
  FORIEGN KEY PRODUCT_ID REFERENCE PRODUCTS.PRODUCT_ID,
  CUSTOMER_ID VARCHAR(50),
  CHECK CUSTOMER_ID LIKE 'C%'
  QUANTITY INT,
  ORDER_DATE DATE
);
#FIND THE QUANTITY SOLD BY EACH PRODUCT
select p.product_id ,p.product_name ,sum(o.quantity) as total_quantity
from products p
join orders o
on p.product_id= o.product_id
group by product_id
order by total_quantity desc;

#Find the top 5 products based on quantity sold.
select * from (select p.product_id ,p.product_name ,sum(o.quantity) as total_quantity ,dense_rank() over (order by sum(o.quantity) desc) as ranking 
from products p
join orders o
on p.product_id= o.product_id
group by product_id) as t 
where ranking <=5
;
#Find products that have never been ordered.
SELECT p.product_name 
from products p 
left join orders o
on p.product_id=o.product_id
where order_id is NULL ;

# Find categories generating the highest sales quantity.
select category, sum(o.quantity )as total_quantity
from products p
join orders o 
on p.product_id=o.product_id 
group by category 
order by total_quantity desc
limit 1;

#
