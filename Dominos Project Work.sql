CREATE TABLE dominos_orders (
    pizza_id INT,
    order_id INT,
    pizza_name_id VARCHAR(50),
    quantity INT,
    order_date TEXT,       -- keep as TEXT for safe import
    order_time TIME,
    price NUMERIC,
    pizza_category VARCHAR(50),
    pizza_ingredients TEXT,
    pizza_name VARCHAR(100)
);

select * from dominos_orders

-- 🍕Dominos Pizza SQL Insight Questions

-- 🧾Basic Sales Insights

-- 1.What is the total number of orders placed?

select * from dominos_orders

select count(distinct order_id) as total_order
from dominos_orders

-- 2.What is the total revenue generated from all orders?

select sum(price) as total_revenue
from dominos_orders

-- Second Method

select sum(price * quantity) as total_revenue
from dominos_orders

-- 3.What is the average order value (AOV)?

select round(sum(price * quantity) / count(distinct order_id),2) as avg_order_value
from dominos_orders

-- 4.Which pizza sold the most (by quantity)?
select * from dominos_orders

select pizza_name_id, sum(quantity) as total_sold
from dominos_orders
group by pizza_name_id
order by total_sold desc
limit 5

-- 5.Which pizza generated the highest total revenue?

select pizza_name_id, sum(price * quantity) as highest_revenue
from dominos_orders
group by pizza_name_id
order by highest_revenue desc
limit 5

-- 6.Which pizza category (Classic, Veggie, etc.) earned the most revenue?

select pizza_category, sum(price * quantity) as highest_revenue
from dominos_orders
group by pizza_category
order by highest_revenue desc

-- 7.Which pizza category sold the most units?

select pizza_category, sum(quantity) as total_sold
from dominos_orders
group by pizza_category
order by total_sold desc

-- 8.What is the average price of each pizza category?

select pizza_category, round(avg(price),2) as Avg_price
from dominos_orders
group by pizza_category
order by  Avg_price desc

-- 9.How many unique pizzas are available on the menu?

SELECT COUNT(DISTINCT pizza_name_id) AS unique_pizza_count
FROM dominos_orders;

-- Second Method

select pizza_name_id,count(distinct pizza_id) as unique_pizza
from dominos_orders
group by pizza_name_id 
order by unique_pizza desc

-- 10.Find the most and least expensive pizza on the menu.

select * from dominos_orders

(
    select pizza_name_id, price, 'Most Expensive' as type
 from dominos_orders
 order by price desc
 limit 1
 )
union all
(
    select pizza_name_id, price, 'Least Expensive' as type
 from dominos_orders
 order by price asc
 limit 1
 );

-- Second Method

select pizza_name_id, price
from dominos_orders
where price = (select max(price) from dominos_orders)
union all
select pizza_name_id, price
from dominos_orders
where price = (select min(price) from dominos_orders)

-- 📅 Time-Based Insights

-- 11.What is the daily sales trend (total revenue by date)?

select * from dominos_orders

select
to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Day') as Day_name,
sum(price * quantity) as total_revenue
from dominos_orders
group by to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Day')
order by total_revenue desc

-- 12.What is the daily sales trend (total sold pizza by Day)?

select
to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Day') as Day_name,
sum(quantity) as total_Pizza_Sold
from dominos_orders
group by to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Day')
order by total_Pizza_Sold desc

-- 13.What is the monthly revenue trend?

select
to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Month') as Month_name,
sum(price * quantity) as total_revenue
from dominos_orders
group by to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Month')
order by total_revenue desc

-- 14.What is the daily sales trend (total sold pizza by Month)? 

select
to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Month') as Month_name,
sum(quantity) as total_Pizza_Sold
from dominos_orders
group by to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Month')
order by total_Pizza_Sold desc

-- 15.On which day did Dominos record the highest revenue?

select
to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Day') as Day_name,
sum(price * quantity) as total_revenue
from dominos_orders
group by to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Day')
order by total_revenue desc
limit 1

-- 16.Which hour of the day has the highest number of orders?

select
extract(hour from order_time) as order_hours,
count(*) as total_orders
from dominos_orders
group by extract(hour from order_time)
order by total_orders desc
limit 1

select * from dominos_orders

-- 💰 Advanced Revenue & Quantity Insights

-- 17.Which pizzas contribute to top 5 total revenue share (%)?

select pizza_name_id,
sum(price * quantity) as total_revenue,
round(sum(price * quantity) * 100 / (select sum(price * quantity) from dominos_orders),2) as persentage_sale
from dominos_orders
group by pizza_name_id
order by total_revenue desc
limit 5

-- 18.What is the total quantity sold per month?

select
to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Month') as Month_name,
sum(quantity) as total_Pizza_Sold
from dominos_orders
group by to_char(TO_DATE(order_date,'DD-MM-YYYY'), 'Month')
order by total_Pizza_Sold desc

-- 19.Find the revenue contribution (%) of each category.

select pizza_category,
sum(price * quantity) as total_revenue,
round(
sum(price * quantity) * 100 / 
(select sum(price * quantity) from dominos_orders),
2
) as persentage_sale
from dominos_orders
group by pizza_category
order by total_revenue desc

-- 20.Which pizzas are slow sellers (lowest quantity sold)?

select pizza_name_id, 
sum(quantity) as total_sold
from dominos_orders
group by pizza_name_id
order by total_sold asc
limit 5

-- Second Method

select pizza_name_id, pizza_category, price,
sum(quantity) as total_sold
from dominos_orders
group by pizza_name_id, pizza_category, price
order by total_sold asc
limit 5

-- 21.Which pizzas are higher sellers (higher quantity sold)?

select pizza_name_id, 
sum(quantity) as total_sold
from dominos_orders
group by pizza_name_id
order by total_sold desc
limit 5

-- Second Method

select pizza_name_id, pizza_category, price,
sum(quantity) as total_sold
from dominos_orders
group by pizza_name_id, pizza_category, price
order by total_sold desc
limit 5

-- 22.Which size of pizza generates the highest revenue?

SELECT 
    RIGHT(pizza_name_id, 1) AS size,
    SUM(price * quantity) AS total_revenue
FROM dominos_orders
GROUP BY size
ORDER BY total_revenue DESC;

-- 23.Which size of pizza generates the highest Sold?

select
right(pizza_name_id,1) as size,
sum(quantity) as total_sold
from dominos_orders
group by size
order by total_sold desc

-- 24.Which size of pizza generates the highest order_placed?

select
right(pizza_name_id,1) as size,
count(distinct order_id) as total_order
from dominos_orders
group by size
order by total_order desc




