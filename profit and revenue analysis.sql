use pizza;

-- About dataset
select * from pizza_sales ;

-- Disable safe update mode
SET SQL_SAFE_UPDATES = 0; 

-- Update the order_date column to the correct format
UPDATE pizza_sales
SET order_date = STR_TO_DATE(order_date, '%d-%m-%Y')
WHERE order_date LIKE '%-%-%';


-- modify column datatype  into date 
Alter table pizza_sales 
modify  column order_date DATE; 

-- modify column datatype  into time
Alter table pizza_sales 
modify column order_time TIME;

-- Total orders

SELECT COUNT(*) AS total_orders FROM pizza_sales;


--  Types of pizzas catagory
select distinct(pizza_category) from pizza_sales;

--  how many different types of pizzas 
select  distinct pizza_name from pizza_sales;

-- total no of pizzas sell
select sum(quantity) as total_pizzas from pizza_sales; 

-- pizza with  highest price
    
    select pizza_name  as maximum_cost_pizza  ,unit_price
    from pizza_sales 
    order by unit_price desc 
    limit 1;
       
   -- pizza with  lowest price    
    select pizza_name  as minimum_cost_pizza ,unit_price 
    from pizza_sales 
    order by unit_price 
    limit 1;
    
--  Revenue Analysis -- 



 -- Total revenue 
select sum(total_price)  as total_revenue from pizza_sales;

-- Hourly Revenue Analysis
     
   SELECT 
    EXTRACT(HOUR FROM order_time) AS hour_of_day,
    SUM(total_price) AS total_revenue
FROM 
    pizza_sales
GROUP BY 
    hour_of_day
ORDER BY 
    total_revenue desc  ;

--  which day of which month of which year had the highest rvenue 
SELECT 
    YEAR(order_date) AS year, 
    MONTH(order_date) AS month, 
    DAY(order_date) AS day, 
    SUM(total_price) AS total_revenue
FROM 
    pizza_sales
GROUP BY 
    year, month, day 
    order by total_revenue desc 
    limit 1;
    
-- which  month has highest revenue
select  monthname(order_date), 
sum(total_price) as revenue_by_month  from pizza_sales 
group by monthname(order_date)
order by revenue_by_month desc
limit 1;

-- Which days of the week having the highest revenue?

SELECT DATE_FORMAT(order_date, '%W') AS day_of_week, sum(total_price) AS revenue
FROM pizza_sales
GROUP BY day_of_week
ORDER BY revenue DESC ;

-- which type of pizza( name ) has highest revenue

select  pizza_name, 
sum(total_price) as revenue_by_name from pizza_sales 
group by pizza_name
order by  revenue_by_name  desc
 limit 1;
 
 -- What is the total revenue of pizza across different categories?

select  pizza_category, 
sum(total_price) as revenue_by_category from pizza_sales 
group by pizza_category
order by  revenue_by_category  desc ;

 -- What is the total revenue of pizza across different sizes?


select  pizza_size, 
sum(total_price) as revenue_by_size from pizza_sales 
group by pizza_size
order by  revenue_by_size  desc;
 
 -- revenue according to  season
 select 
    CASE 
    WHEN MONTH(order_date) in (3,4,5) then 'spring'
    WHEN MONTH(order_date) in (6,7,8) then 'summer'
    WHEN MONTH(order_date) in (12,1,2) then 'winter'
    else 'fall'
    end as season ,
    sum(total_price) as season_revenue
    from pizza_sales
    group by season
    order by season_revenue;
 
  -- profit -- 
  
   
-- Profit Margin Calculation
SELECT 
     pizza_sales.pizza_name_id,
     pizza_sales.pizza_name,
    SUM(pizza_sales.total_price) AS total_revenue,
    SUM( pizza_cost.cost * pizza_sales.quantity) AS total_cost,
     SUM(pizza_sales.total_price) - SUM( pizza_cost.cost *pizza_sales.quantity)  AS total_profit,
    (SUM(pizza_sales.total_price) - SUM( pizza_cost.cost * pizza_sales.quantity)) / SUM(pizza_sales.total_price)  * 100 AS profit_margin_percentage
FROM 
    pizza_sales
JOIN 
    pizza_cost  ON pizza_sales.pizza_name_id =  pizza_cost.pizza_name_id
GROUP BY 
    pizza_sales.pizza_name_id, pizza_sales.pizza_name
ORDER BY 
    total_profit DESC limit 3;
 
 
  --  Profit  by Category
    
    SELECT 
    pizza_sales.pizza_category,
    SUM(pizza_sales.total_price) AS total_revenue,
    SUM(pizza_cost.cost * pizza_sales.quantity) AS total_cost,
    SUM(pizza_sales.total_price) - SUM(pizza_cost.cost * pizza_sales.quantity) AS total_profit
FROM 
    pizza_sales 
JOIN 
    pizza_cost  ON pizza_sales.pizza_name_id = pizza_cost.pizza_name_id
GROUP BY 
    pizza_sales.pizza_category
ORDER BY 
    total_profit DESC;
 

--  Which month has the highest Profit?

    
    SELECT 
    month(order_date) as month,
    SUM(pizza_sales.total_price) AS total_revenue,
    SUM(pizza_cost.cost * pizza_sales.quantity) AS total_cost,
    SUM(pizza_sales.total_price) - SUM(pizza_cost.cost * pizza_sales.quantity) AS total_profit
FROM 
    pizza_sales 
JOIN 
    pizza_cost   ON pizza_sales.pizza_name_id = pizza_cost.pizza_name_id
GROUP BY 
month    
ORDER BY 
total_profit desc
 limit 1;

--   Profit by Time of Day

select 
case 
   when hour(order_time) between 0 and 5 
  then 'Night'
   when   hour(order_time) between 6 and 11
  then 'Morning'
   when  hour(order_time) between 12 and 17 
   then 'Afternoon'
   ELSE 
   'Evening'
   END as Time_of_day,
   SUM(pizza_sales.total_price) AS total_revenue,
    SUM(pizza_cost.cost * pizza_sales.quantity) AS total_cost,
    SUM(pizza_sales.total_price) - SUM(pizza_cost.cost * pizza_sales.quantity) AS total_profit
FROM 
    pizza_sales 
JOIN 
    pizza_cost  ON pizza_sales.pizza_name_id = pizza_cost.pizza_name_id
GROUP BY 
    time_of_day
ORDER BY 
    total_profit DESC
    limit 1;
    

    
    
    
    
    
 

    
    







