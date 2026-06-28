create database day2;
use day2;
create table customer(
  customer_id varchar(5) primary key,
  CHECK( customer_id like 'C%'),
  customer_name varchar(20) NOT NULL,
  city varchar(10),
  join_date DATE
);
CREATE TABLE PRODUCTS (
  PRODUCT_ID VARCHAR(5) PRIMARY KEY,
  CHECK (PRODUCT_ID LIKE 'P%'),
  PRODUCT_NAME VARCHAR(10),
  CATEGORY VARCHAR(40),
  PRICE INT
);

create table orders (
  order_id varchar(5) PRIMARY KEY,
  CHECK( ORDER_ID LIKE 'O%'),
  CUSTOMER_ID VARCHAR(5),
  FOREIGN KEY (CUSTOMER_ID) REFERENCES CUSTOMER(CUSTOMER_ID),
  PRODUCT_ID VARCHAR(5),
  FOREIGN KEY (PRODUCT_ID) REFERENCES PRODUCTS(PRODUCT_ID),
  ORDER_DATE DATE,
  QUANTITY INT,
  AMOUNT INT
  );

INSERT INTO CUSTOMER VALUES
('C001','Amit','Mumbai','2024-01-15'),
('C002','Priya','Pune','2024-02-10'),
('C003','Rahul','Nagpur','2024-03-05'),
('C004','Sneha','Nashik','2024-04-18'),
('C005','Karan','Mumbai','2024-05-12');
INSERT INTO PRODUCTS VALUES
('P001','Laptop','Electronics',60000),
('P002','Mobile','Electronics',25000),
('P003','Chair','Furniture',3500),
('P004','Table','Furniture',5000),
('P005','Watch','Fashion',8000);
INSERT INTO ORDERS VALUES
('O001','C001','P001','2024-06-01',1,60000),
('O002','C002','P002','2024-06-02',2,50000),
('O003','C003','P003','2024-06-03',4,14000),
('O004','C001','P005','2024-06-04',1,8000),
('O005','C004','P004','2024-06-05',2,10000),
('O006','C005','P002','2024-06-06',1,25000),
('O007','C002','P005','2024-06-07',3,24000),
('O008','C003','P001','2024-06-08',1,60000);
#Display all customers who joined after 2024-01-01.
SELECT CUSTOMER_ID ,CUSTOMER_NAME 
FROM CUSTOMER
WHERE JOIN_DATE = "2024-01-01"
#Find the customer who placed the maximum number of orders.
SELECT C.CUSTOMER_ID ,C.CUSTOMER_NAME ,COUNT(O.CUSTOMER_ID) AS NUMBER_ORDERS
  FROM CUSTOMER C
  JOIN ORDERS O
  ON C.CUSTOMER_ID=O.CUSTOMER_ID
  GROUP BY CUSTOMER_ID
ORDER BY NUMBER_ORDERS DESC LIMIT 1;
#Find the top 5 customers by total revenue.
SELECT C.CUSTOMER_ID,C.CUSTOMER_NAME,SUM(O.AMOUNT) AS TOTAL_REVENUE
FROM CUSTOMER C
JOIN ORDERS O
ON C.CUSTOMER_ID=O.CUSTOMER_ID
GROUP BY CUSTOMER_ID
ORDER BY TOTAL_REVENUE
LIMIT 5;
#Find the best-selling product based on quantity sold.
  select p.product_id ,p.product_name as best_selled,sum(o.quantity) as quantity_sold
  from products p
  join orders o
  on p.product_id=o.product_id
  group by product_id
  order by quantity_sold desc
  limit 1;
# Find customers who havent placed any orders.
 select c.customer_id,c.customer_name
 from customer c
 left join orders o
 on c.customer_id=o.customer_id
where order_id IS NULL ;
#Which city generates the highest revenue
select c.city ,sum(o.amount) as city_revenue
from customer c
join orders o
on c.customer_id=o.customer_id
group by city
order by city desc
limit 1;
#Which month had the highest sales
select monthname(order_date) as month,sum(amount) as total_sales
from orders 
group by month;
#Which customer should receive a loyalty reward? (Define your own criteria.)
# loyalty of customer can be seen if it has highest number of orders
SELECT c.customer_id,
       c.customer_name,
       COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) = (
    SELECT MAX(order_count)
    FROM (
        SELECT COUNT(*) AS order_count
        FROM orders
        GROUP BY customer_id
    ) AS t
);
#Which category contributes the highest percentage of total revenue
