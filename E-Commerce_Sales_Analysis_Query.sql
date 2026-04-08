create database Ecommerce;
use ecommerce;
select count(*) from dataset; 

describe dataset;

alter table dataset
rename column `Customer Name` to customer_name;

select * from dataset
where customer_name is NULL;

alter table dataset
rename column `Sub-Category` to sub_category;

alter table dataset
rename column `Order ID` to order_id;

alter table dataset
rename column `Customer ID` to customer_id;

select order_Date from dataset;

select product_name , sum(sales) as Total
from dataset
group by product_name
order by total desc;
select order_date from dataset;


select monthname(order_date) , ROUND(SUM(Sales), 0) as Sales
from dataset
group by month(order_date) ,MONTHNAME(order_date)
order by monthname(order_date);

select customer_name, count(*) as total_purchase from dataset
group by customer_name
having total_purchase > 1;


SELECT YEAR(order_date) AS year
FROM dataset);

ALTER TABLE dataset
MODIFY ship_date datetime;

UPDATE dataset
SET ship_date = STR_TO_DATE(ship_date, '%m/%d/%Y');

UPDATE dataset
SET ship_date = STR_TO_DATE(ship_date, '%m/%d/%Y');

select ship_date from dataset;
CREATE TABLE customers (
    customer_id VARCHAR(50) PRIMARY KEY,
    customer_name VARCHAR(100),
    segment VARCHAR(50),
    country VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    postal_code VARCHAR(20),
    region VARCHAR(50)
);

SET SQL_SAFE_UPDATES = 0;
DELETE FROM customers;
SET SQL_SAFE_UPDATES = 1;

INSERT INTO customers
SELECT 
    customer_id,
    MAX(customer_name),
    MAX(segment),
    MAX(country),
    MAX(city),
    MAX(state),
    MAX(postal_code),
    MAX(region)
FROM dataset
GROUP BY customer_id;

select * from customers;



CREATE TABLE products (
    product_id VARCHAR(50) PRIMARY KEY,
    product_name VARCHAR(200),
    category VARCHAR(50),
    sub_category VARCHAR(50)
);

INSERT INTO products
SELECT DISTINCT
    product_id,
    product_name,
    Category,
    sub_category
FROM dataset;
INSERT INTO products
SELECT 
    product_id,
    MAX(product_name),
    MAX(category),
    MAX(sub_category)
FROM dataset
GROUP BY product_id;

select * from products;

DROP TABLE order_details;
DROP TABLE orders;

CREATE TABLE orders (
    order_id VARCHAR(50) PRIMARY KEY,
    order_date DATE,
    ship_date DATE,
    customer_id VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
INSERT INTO orders
SELECT DISTINCT
    order_id,
    STR_TO_DATE(order_date, '%Y-%m-%d'),
    STR_TO_DATE(ship_date, '%m/%d/%Y'),
    customer_id
FROM dataset;

SELECT COUNT(*) FROM customers;


CREATE TABLE order_details (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id VARCHAR(50),
    product_id VARCHAR(50),
    sales DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(5,2),
    profit DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO order_details (order_id, product_id, sales, quantity, discount, profit)
SELECT
    order_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
FROM dataset;
describe order_details;

---------------------------------------------------------------------------------------------------------------------------------------------------------------

select profit  as Total_Sales from order_details;

select year(e.order_date) as Year , sum(o.sales) as Total_Sales 
from order_details o
left join orders e
on o.order_id = e.order_id
group by year(e.order_date)
order by Year;


select  p.product_name  , sum(o.sales) as Total_Sales
from products p 
join order_details o
on p.product_id = o.product_id
group by p.product_name
order by Total_Sales desc 
limit 10;

select p.category , sum(od.sales) as Total_Sales , sum(profit) as Total_Profit
from products p 
join order_details od
on p.product_id = od.product_id
group by p.category;


select p.product_name , sum(od.profit) as Total_loss
from products p 
join order_details od
on p.product_id = od.product_id
group by p.product_name
having Total_loss < 0
order by Total_loss;

select c.customer_name , sum(od.sales) as Spent
from customers c
join orders o
on c.customer_id = o.customer_id
join order_details od
on o.order_id = od.order_id 
group by od.order_id
order by Spent
limit 10;

SELECT MONTHNAME(order_date) AS month, ROUND(SUM(od.sales), 2) AS total_sales
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY MONTH(order_date);

select c.state , sum(od.sales) as Total_Sales
from customers c
join orders o
on c.customer_id = o.customer_id
join order_details od
on o.order_id = od.order_id 
group by c.state
order by Total_Sales desc
limit 0 , 10;

select c.segment , sum(od.sales) as Profit_Ratio
from customers c
join orders o
on c.customer_id = o.customer_id
join order_details od
on o.order_id = od.order_id 
group by c.segment;

select State , round(sum(sales),0) as profit
from dataset
group by state
order by profit desc 
limit 10;

SELECT 
    c.state,
    ROUND(SUM(od.sales), 2) AS total_sales
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.state;
