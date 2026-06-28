CREATE DATABASE ANALYTICSDAY3;
USE DAY3;
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    signup_date DATE
);

INSERT INTO Customers VALUES
(101, 'Priya', 'Mumbai', '2023-01-10'),
(102, 'Rahul', 'Delhi', '2023-02-15'),
(103, 'Sneha', 'Pune', '2023-03-20'),
(104, 'Amit', 'Bangalore', '2023-01-25'),
(105, 'Neha', 'Hyderabad', '2023-04-12'),
(106, 'Karan', 'Chennai', '2023-05-08'),
(107, 'Anjali', 'Kolkata', '2023-06-18'),
(108, 'Vikas', 'Ahmedabad', '2023-02-28'),
(109, 'Riya', 'Jaipur', '2023-07-05'),
(110, 'Arjun', 'Lucknow', '2023-03-30'),
(111, 'Meera', 'Mumbai', '2023-08-11'),
(112, 'Rohan', 'Pune', '2023-09-01');
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    product_category VARCHAR(50),
    amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Orders VALUES
(1001,101,'2023-01-15','Electronics',8500),
(1002,101,'2023-02-10','Books',700),
(1003,101,'2023-03-18','Clothing',2200),
(1004,101,'2023-05-22','Furniture',12000),
(1005,101,'2023-07-15','Grocery',900),

(1006,102,'2023-02-20','Electronics',15000),
(1007,102,'2023-03-25','Electronics',18000),
(1008,102,'2023-06-30','Furniture',25000),
(1009,102,'2023-08-10','Books',1200),
(1010,102,'2023-09-15','Clothing',3200),
(1011,102,'2023-10-05','Grocery',850),
(1012,102,'2023-11-18','Electronics',21000),

(1013,103,'2023-03-28','Books',600),

(1014,104,'2023-02-05','Furniture',18000),
(1015,104,'2023-04-18','Furniture',9000),
(1016,104,'2023-06-25','Electronics',12000),
(1017,104,'2023-08-08','Books',950),

(1018,105,'2023-04-20','Clothing',1800),
(1019,105,'2023-05-25','Clothing',2500),

(1020,106,'2023-05-15','Electronics',25000),
(1021,106,'2023-06-20','Furniture',17000),
(1022,106,'2023-07-12','Clothing',4500),
(1023,106,'2023-08-15','Books',1000),
(1024,106,'2023-09-20','Grocery',1500),

(1025,107,'2023-07-01','Books',750),

(1026,108,'2023-03-10','Electronics',9500),
(1027,108,'2023-04-15','Clothing',2600),
(1028,108,'2023-05-20','Books',900),

(1029,109,'2023-07-18','Furniture',22000),
(1030,109,'2023-09-05','Furniture',8000),

(1031,110,'2023-04-05','Grocery',1200),
(1032,110,'2023-06-10','Books',500),
(1033,110,'2023-08-12','Clothing',1700),

(1034,111,'2023-08-20','Electronics',14000),

(1035,112,'2023-09-10','Books',650),
(1036,112,'2023-10-12','Books',800),
(1037,112,'2023-11-15','Books',950),
(1038,112,'2023-12-18','Books',1200);
#Display all customers along with their total spending.
SELECT C.CUSTOMER_NAME ,SUM(O.AMOUNT) AS TOTAL_SPENDING
FROM CUSTOMERS C
JOIN ORDERS O
ON C.CUSTOMER_ID=O.CUSTOMER_ID
GROUP BY CUSTOMER_NAME;
#Find customers who placed more than 3 orders.
SELECT C.CUSTOMER_ID,C.CUSTOMER_NAME,COUNT(O.ORDER_ID) AS COUNT_ORDERS
FROM CUSTOMERS C
JOIN ORDERS O
ON C.CUSTOMER_ID=O.CUSTOMER_ID
GROUP BY CUSTOMER_ID
HAVING COUNT_ORDERS >3;
#Find the customer who spent the highest total amount.
SELECT C.CUSTOMER_ID,C.CUSTOMER_NAME,SUM(AMOUNT) AS TOTAL_AMOUNT
FROM CUSTOMERS C
JOIN ORDERS O
ON C.CUSTOMER_ID=O.CUSTOMER_ID
GROUP BY CUSTOMER_ID 
HAVING SUM(AMOUNT) = ( SELECT MAX(total_sum) FROM 
(SELECT SUM(AMOUNT) as total_sum FROM ORDERS) AS t);
#Calculate the average order value for each customer.
select c.customer_id ,c.customer_name , avg(o.amount)
from customers c
join orders o
on c.customer_id=o.customer_id
group by customer_id;
#Find customers who purchased from more than one product category.
select c.customer_id,c.customer_name ,count(o.product_category) as diff_category_ordered
from customers c
join orders o
on c.customer_id=o.customer_id
group by customer_id
having count(o.product_category) != '1';
#Display each customer's first purchase date and latest purchase date.
SELECT c.customer_id,c.customer_name,max(o.order_date ) as latest_purchase ,min(o.order_date) as first_purchase
from customers c
join orders o
on c.customer_id=o.customer_id
group by customer_id;
#Display each customer's first purchase date and latest purchase date.
select c.customer_id,c.customer_name,count(o.order_id) as number_orders
from customers c
join orders o
on c.customer_id=o.customer_id
group by customer_id
having count(order_id) ='1';
#Calculate the number of days between a customer's first and last purchase.
select c.customer_id,c.customer_name, max(o.order_date)-min(o.order_date) as order_gap
from customers c
join orders o
on c.customer_id=o.customer_id
group by customer_id;
#Rank customers based on total spending (highest spender gets Rank 1).
WITH CTE AS 
(SELECT CUSTOMER_ID,SUM(AMOUNT) AS TOTAL_SPENDING FROM ORDERS GROUP BY CUSTOMER_ID)
SELECT C.CUSTOMER_ID,C.CUSTOMER_NAME,RANK() OVER (ORDER BY TOTAL_SPENDING)
FROM CTE
JOIN CUSTOMERS C
ON CTE.CUSTOMER_ID=C.CUSTOMER_ID;
#Find the top 3 customers by total revenue.
SELECT C.CUSTOMER_ID,C.CUSTOMER_NAME,SUM(O.AMOUNT) AS REVENUE
FROM CUSTOMERS C
JOIN ORDERS O
ON C.CUSTOMER_ID=O.CUSTOMER_ID
GROUP BY CUSTOMER_ID,CUSTOMER_NAME 
ORDER BY REVENUE DESC
LIMIT 3;
#For every customer, show:Customer Name,Total Orders,Total Spending,Average Order Value,Rank by Spending
WITH CTE AS
(
    SELECT
        CUSTOMER_ID,
        SUM(AMOUNT) AS TOTAL_SPENDING
    FROM ORDERS
    GROUP BY CUSTOMER_ID
)

SELECT
    C.CUSTOMER_ID,
    C.CUSTOMER_NAME,
    COUNT(O.ORDER_ID) AS TOTAL_ORDERS,
    CTE.TOTAL_SPENDING,
    AVG(O.AMOUNT) AS AVERAGE_ORDER_VALUE,
    RANK() OVER (ORDER BY CTE.TOTAL_SPENDING DESC) AS CUSTOMER_RANK
FROM CTE
JOIN CUSTOMERS C
    ON CTE.CUSTOMER_ID = C.CUSTOMER_ID
JOIN ORDERS O
    ON C.CUSTOMER_ID = O.CUSTOMER_ID
GROUP BY
    C.CUSTOMER_ID,C.CUSTOMER_NAME,
    CTE.TOTAL_SPENDING;


#Classify customers using CASE:
WITH CTE AS (SELECT CUSTOMER_ID,SUM(AMOUNT) AS SPENDING FROM ORDERS GROUP BY CUSTOMER_ID)
SELECT C.CUSTOMER_ID,C.CUSTOMER_NAME ,SPENDING,
CASE WHEN SPENDING > 20000 THEN 'PLATINUM'
WHEN SPENDING < 20000 AND SPENDING >10000 THEN 'GOLD'
WHEN SPENDING < 9999 AND SPENDING > 5000 THEN 'SILVER'
ELSE 'BRONZE' END AS AMOUNT_STATS
FROM CTE 
JOIN CUSTOMERS C
ON CTE.CUSTOMER_ID=C.CUSTOMER_ID
JOIN ORDERS O
ON C.CUSTOMER_ID=O.CUSTOMER_ID
GROUP BY CUSTOMER_ID,CUSTOMER_NAME;
#Find customers who bought from every product category available.
SELECT C.CUSTOMER_ID,C.CUSTOMER_NAME,COUNT(DISTINCT O.PRODUCT_CATEGORY) AS ORDERS 
FROM CUSTOMERS C
JOIN ORDERS O
ON C.CUSTOMER_ID=O.CUSTOMER_ID
GROUP BY CUSTOMER_ID 
HAVING COUNT(DISTINCT O.PRODUCT_CATEGORY) = (
SELECT COUNT(DISTINCT PRODUCT_CATEGORY) FROM ORDERS)
#Generate a monthly sales report
select distinct customer_id,month(order_date) as month ,count(order_id) as total_orders ,sum(amount) as revenue
from orders
group by customer_id,month(order_date);

#Management wants to identify potential loyalty members.
select COUNT(DISTINCT O.PRODUCT_CATEGORY) , C.customer_id,
C.customer_name,count(O.order_id) as total_orders,sum(O.amount) as total_spending
FROM CUSTOMERS C 
JOIN ORDERS O
ON C.CUSTOMER_ID=O.CUSTOMER_ID
GROUP BY CUSTOMER_ID,CUSTOMER_NAME
HAVING COUNT(O.ORDER_ID) >=5 AND SUM(O.AMOUNT) >15000 AND 
COUNT(DISTINCT O.PRODUCT_CATEGORY) >=3;

