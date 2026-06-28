CREATE DATABASE DATA_ANALYST;
USE DATA_ANALYST;
CREATE TABLE CUSTOMER(
CUSTOMER_ID INT PRIMARY KEY,
CUSTOMER_NAME CHAR(10),
CITY VARCHAR(50)
);
CREATE TABLE ORDERS(
ORDER_ID INT PRIMARY KEY,
CUSTOMER_ID INT,
FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER (CUSTOMER_ID),
ORDER_DATE VARCHAR(10),
AMOUNT INT
);
INSERT INTO CUSTOMER VALUES
(1,'priyanka','mumbai'),
(2,'shreya','nagpur'),
(3, 'Amit', 'Mumbai'),
(4, 'Priya', 'Pune'),
(5, 'Rahul', 'Delhi'),
(6, 'Sneha', 'Mumbai'),
(7, 'Karan', 'Bangalore');
-- ORDERS TABLE VALUES
INSERT INTO orders VALUES
(101, 1, '2025-05-01', 4500),
(102, 2, '2025-05-03', 6200),
(103, 1, '2025-05-05', 3000),
(104, 3, '2025-05-06', 8000),
(105, 4, '2025-05-08', 5500),
(106, 5, '2025-05-10', 2000);
select * from CUSTOMER;
SELECT * FROM ORDERS;
#find the total sales by each customer 
SELECT c.CUSTOMER_ID,c.CUSTOMER_NAME ,COUNT(o.CUSTOMER_ID) as total_sales
FROM CUSTOMER c
JOIN ORDERS o
ON c.customer_id=o.customer_id
group by customer_id;
#find the avgerage order amount by city
select c.CITY ,avg(o.AMOUNT) AS average_amount
from customer c
join orders o
on c.customer_id=o.customer_id
group by city;
#find the customer who spent maximum amount
select c.customer_id,c.customer_name 
from customer c
join orders o 
on c.customer_id=o.customer_id
where amount=(
  select max(amount) from orders);
#find the top three customer with total spending
SELECT c.customer_id ,c.customer_name 
from customer c
join orders o
on c.customer_id=o.customer_id
order by amount
limit 3;
# SELECT CUSTOMER WHO HAVE NEVER PLACED AN ORDER
select c.customer_id 
from customer c
LEFT join orders o
on c.customer_id=o.customer_id
where order_id IS NULL;
# Find monthly sales trend.
select month(order_date) as month,sum(amount)
from orders 
group by month;
# SELECT CITY WITH HIGHEST REVENUE
  SELECT c.CITY,SUM(o.AMOUNT) as total_amount
  FROM CUSTOMER c
  join orders o
  on c.customer_id=o.customer_id
  group by city
  order by total_amount desc
  limit 1;
#method 2
WITH revenue_cte AS (
    SELECT
        c.city,
        SUM(o.amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(o.amount) DESC) AS rnk
    FROM customer c
    JOIN orders o
        ON c.customer_id = o.customer_id
    GROUP BY c.city
)
SELECT city, total_revenue
FROM revenue_cte
WHERE rnk = 1;
#find the customer who have spend more than average
select c.customer_id,c.customer_name
from customer c
join orders o
on c.customer_id=o.customer_id
where amount>(select avg(amount) from orders);
#find repeat customer
 select customer_id ,COUNT(order_id) as number_order
  from orders
  group by customer_id
  HAVING number_order>1;
#FIND THE PERCENTAGE CONTRIBUTION OF EACH CUSTOMER TO TOTAL SALES
SELECT
    c.customer_id,
    SUM(o.amount) AS customer_sales,
    ROUND(
        SUM(o.amount) * 100.0 ,2
    ) AS percentage_contribution
FROM customer c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
