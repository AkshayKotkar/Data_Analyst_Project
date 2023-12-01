-- Retrive All Data

SELECT *
FROM pizza_sales

-- Find a Total Revenue 

SELECT SUM(total_price) as Revenue
FROM pizza_sales

-- Average Price Order Value
SELECT  COUNT(DISTINCT order_id) AS Total_Order, SUM(total_price) AS Total_Revenue, 
Average_Order_Price = (SUM(total_price)/COUNT(DISTINCT order_id))
FROM pizza_sales
												
-- Total Pizzas Sold
SELECT SUM(quantity) AS  Total_Pizzas_Sold
FROM pizza_sales

-- Total Order Sold
SELECT COUNT(DISTINCT order_id) AS Total_Order
FROM pizza_sales

-- Average Pizzas Per Order
SELECT SUM(quantity) AS quantity, COUNT(DISTINCT order_id) AS Orders, 
CAST(CAST(SUM(quantity) AS DECIMAL(10,2)) /
CAST(COUNT(DISTINCT order_id) AS DECIMAL (10,2)) AS DECIMAL (10,2)) AS Average_Pizza_Per_Order
FROM pizza_sales

-- Day wise Trend for Total Orders in a year

SELECT DATENAME(DW, order_date) AS Order_Day, COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)

-- Total Order in Per Day
SELECT order_date AS Order_Day, COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY order_date
ORDER BY order_date

-- Hourly Trend for Total Orders in a year

SELECT DATEPART(HOUR, order_time) AS Order_Hours, COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY DATEPART(HOUR, order_time)
ORDER BY DATEPART(HOUR, order_time)

-- Percentage Price of Pizza Category

SELECT pizza_category , COUNT(pizza_category) as Category_order , SUM(total_price) as Total_Sales,
SUM(total_price) *100 / (SELECT SUM(total_price) FROM pizza_sales) as Total_price_percentage_Category
FROM pizza_sales
GROUP BY pizza_category 
ORDER BY Total_price_percentage_Category DESC

-- Percentage Price of Only Specific Month. Which Pizza Category How much Sales

SELECT pizza_category , COUNT(pizza_category) as Category_order , SUM(total_price) as Total_Sales, 
						SUM(total_price) *100 / (SELECT SUM(total_price) 
						FROM pizza_sales 
						WHERE MONTH(order_date) = 1) as Total_price_percentage_Category
FROM pizza_sales
WHERE MONTH(order_date) = 1
GROUP BY pizza_category 
ORDER BY Total_price_percentage_Category DESC

--Percentage Sales by Pizza Size

SELECT pizza_size, COUNT(pizza_size) as Total_Size_Sale , CAST(SUM(total_price)AS DECIMAL(10,2)) as Total_Price,
					CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) 
					From pizza_sales)AS DECIMAL (10,2)) As Total_Price_Percentage_Size
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Total_Price_Percentage_Size DESC

-- Percentage Quarter Sale by Pizza Scale

SELECT pizza_size, COUNT(pizza_size) as Total_Size_Sale , CAST(SUM(total_price)AS DECIMAL(10,2)) as Total_Price,
					CAST(SUM(total_price) * 100 / (SELECT SUM(total_price)
					From pizza_sales
					WHERE DATEPART(QUARTER , order_date) = 1)AS DECIMAL (10,2)) As Total_Price_Percentage_Size
FROM pizza_sales
WHERE DATEPART(QUARTER , order_date) = 1
GROUP BY pizza_size
ORDER BY Total_Price_Percentage_Size DESC

-- How Much Pizza Sold by Which Category

SELECT pizza_category, SUM(quantity) AS Total_Orders
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Total_Orders

--TOP 5 Best Sellers By Total Pizzas Sold

SELECT TOP 5 pizza_name, SUM(quantity) AS Pizza_Sell
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Pizza_Sell DESC

--BOTTOM 5 Best Sellers By Total Pizzas Sold

SELECT TOP 5 pizza_name, SUM(quantity) AS Pizza_Sell
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Pizza_Sell