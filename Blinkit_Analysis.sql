use Blinkit_Sales_Analysis;
-- Sales Trend Analysis using Aggregation

-- Monthly Revenue and Order Volume
SELECT 
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(order_total) AS total_revenue
FROM blinkit_orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;

-- We got:
-- For each year and month, 
-- we calculate the total number of unique orders placed and the total revenue generated from those orders

-- Top performing product By Quantity
SELECT 
    oi.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM blinkit_order_items oi
JOIN blinkit_products p ON oi.product_id = p.product_id
GROUP BY oi.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10;


-- Top Performing Product By Revenue
SELECT 
    oi.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM blinkit_order_items oi
JOIN blinkit_products p ON oi.product_id = p.product_id
GROUP BY oi.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- Most active customer by order

SELECT 
    o.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM blinkit_orders o
JOIN blinkit_customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name
ORDER BY total_orders DESC
LIMIT 10;

-- Order Trends by Weekdays
SELECT 
    DAYNAME(order_date) AS weekday,
    COUNT(order_id) AS total_orders
FROM blinkit_orders
GROUP BY weekday
ORDER BY FIELD(weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

-- Marketing Campaigns with Best ROAS (Return on Ad Spend)
SELECT 
    campaign_id,
    campaign_name,
    ROUND(roas, 2) AS roas,
    impressions,
    conversions
FROM blinkit_marketing_performance
ORDER BY roas DESC
LIMIT 5;

-- Delayed Delivaries and their Impact

-- Number of delayed deliveries
SELECT 
    COUNT(*) AS total_delayed_deliveries
FROM blinkit_orders
WHERE actual_delivery_time > promised_delivery_time;

-- Average delay time in minutes
SELECT 
    AVG(TIMESTAMPDIFF(MINUTE, promised_delivery_time, actual_delivery_time)) AS avg_delay_minutes
FROM blinkit_orders
WHERE actual_delivery_time > promised_delivery_time;

-- Impact on customer rating
SELECT 
    CASE 
        WHEN o.actual_delivery_time > o.promised_delivery_time THEN 'Delayed'
        ELSE 'On Time'
    END AS delivery_status,
    AVG(cf.rating) AS avg_rating
FROM blinkit_orders o
JOIN blinkit_customer_feedback cf ON o.order_id = cf.order_id
GROUP BY 
    CASE 
        WHEN o.actual_delivery_time > o.promised_delivery_time THEN 'Delayed'
        ELSE 'On Time'
    END;


