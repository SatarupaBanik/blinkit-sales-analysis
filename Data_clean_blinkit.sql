use Blinkit_Sales_Analysis;
show tables;
select * from blinkit_customers;

-- Data cleaning

-- Checking for null for every table
SELECT COUNT(*) AS total_rows,
  SUM(customer_id IS NULL) AS null_customer_id,
  SUM(customer_name IS NULL) AS null_customer_name,
  SUM(email IS NULL) AS null_email,
  SUM(phone IS NULL) AS null_phone,
  SUM(address IS NULL) AS null_address,
  SUM(area IS NULL) AS null_area
FROM blinkit_customers;

select * from blinkit_orders;
-- blinkit_orders
SELECT COUNT(*) AS total_rows,
  SUM(order_id IS NULL) AS null_order_id,
  SUM(customer_id IS NULL) AS null_customer_id,
  SUM(order_date IS NULL) AS null_order_date,
  SUM(promised_delivery_time IS NULL) AS null_promised_delivery_time,
  SUM(actual_delivery_time IS NULL) AS null_actual_delivery_time,
  SUM(delivery_status IS NULL) AS null_delivery_status,
  SUM(order_total IS NULL) AS null_order_total,
  SUM(payment_method IS NULL) AS null_payment_method,
  SUM(delivery_partner_id IS NULL) AS null_delivery_partner_id,
  SUM(store_id IS NULL) AS null_store_id
FROM blinkit_orders;

select * from blinkit_products;
--  blinkit_products
SELECT COUNT(*) AS total_rows,
  SUM(product_id IS NULL) AS null_product_id,
  SUM(product_name IS NULL) AS null_product_name,
  SUM(brand IS NULL) AS null_brand,
  SUM(category IS NULL) AS null_category,
  SUM(price IS NULL) AS null_price,
  SUM(mrp IS NULL) AS null_mrp,
  SUM(margin_percentage IS NULL) as null_margin_percentage,
  SUM(shelf_life_days IS NULL) as null_shelf_life_days,
  SUM(min_stock_level IS NULL) as null_min_stock_level,
  SUM(max_stock_level IS NULL) as null_max_stock_level
FROM blinkit_products;

select * from blinkit_inventory;
-- blinkit_inventory
SELECT COUNT(*) AS total_rows,
  SUM(product_id IS NULL) AS null_product_id,
  SUM(date IS NULL) AS null_date,
  SUM(stock_received IS NULL) AS null_stock_received,
  SUM(damaged_stock IS NULL) AS null_damaged_stock
FROM blinkit_inventory;

select * from blinkit_order_items;
-- blinkit_order_items
SELECT COUNT(*) AS total_rows,
  SUM(order_id IS NULL) AS null_order_id,
  SUM(product_id IS NULL) AS null_product_id,
  SUM(quantity IS NULL) AS null_quantity
FROM blinkit_order_items;

select * from blinkit_delivery_performance;
-- blinkit_delivery_performance
SELECT COUNT(*) AS total_rows,
  SUM(order_id IS NULL) AS null_order_id,
  SUM(delivery_partner_id IS NULL) AS null_delivery_partner_id,
  SUM(promised_time IS NULL) AS null_promised_time,
  SUM(actual_time IS NULL) AS null_actual_time,
  SUM(delivery_time_minutes IS NULL) AS null_delivery_time_minutes,
  SUM(distance_km IS NULL) AS null_distance_km,
  SUM(delivery_status IS NULL) AS null_delivery_status,
  SUM(reasons_if_delayed IS NULL) AS null_reasons_if_delayed
FROM blinkit_delivery_performance;

select * from blinkit_marketing_performance;
-- blinkit_marketing_performance
SELECT COUNT(*) AS total_rows,
  SUM(campaign_id IS NULL) AS null_campaign_id,
  SUM(campaign_name IS NULL) AS null_camapaign_name,
  SUM(date IS NULL) AS null_date,
  SUM(target_audience IS NULL) as null_target_audience,
  SUM(impressions IS NULL) as null_impressions,
  SUM(clicks IS NULL) as null_clicks,
  SUM(spend IS NULL) as null_spend,
  SUM(revenue_generated IS NULL) as null_revenue_genearted,
  SUM(roas IS NULL) as null_iroas,
  SUM(conversions IS NULL) AS null_conversions
FROM blinkit_marketing_performance;

select * from blinkit_customer_feedback;
-- blinkit_customer_feedback
SELECT COUNT(*) AS total_rows,
  SUM(feedback_id IS NULL) AS null_feedback_id,
  SUM(order_id IS NULL) AS order_id_feedback,
  SUM(customer_id IS NULL) AS customer_id_rating,
  SUM(feedback_date IS NULL) AS customer_id_rating,
  SUM(rating IS NULL) AS null_rating,
  SUM(feedback_text IS NULL) AS null_feedback_test,
  SUM(feedback_category IS NULL) AS null_feedback_category,
  SUM(sentiment IS NULL) AS null_sentiment
FROM blinkit_customer_feedback;

-- No null values are found.

-- Standardising Dataset
ALTER TABLE blinkit_customers
MODIFY customer_name VARCHAR(100),
MODIFY email VARCHAR(150),
MODIFY phone VARCHAR(15),
MODIFY area VARCHAR(100),
MODIFY pincode VARCHAR(6),
MODIFY registration_date DATE,
MODIFY customer_segment VARCHAR(50);

ALTER TABLE blinkit_orders
MODIFY order_date DATE,
MODIFY promised_delivery_time DATETIME,
MODIFY actual_delivery_time DATETIME,
MODIFY delivery_status VARCHAR(25),
MODIFY payment_method VARCHAR(30);

SELECT MAX(CHAR_LENGTH(delivery_status)) AS max_length
FROM blinkit_orders;
ALTER TABLE blinkit_orders
MODIFY order_date DATETIME;

ALTER TABLE blinkit_products
    MODIFY COLUMN product_name VARCHAR(255),
    MODIFY COLUMN category VARCHAR(100),
    MODIFY COLUMN brand VARCHAR(100),
    MODIFY COLUMN price DECIMAL(10,2),
    MODIFY COLUMN mrp DECIMAL(10,2),
    MODIFY COLUMN margin_percentage DECIMAL(5,2);

ALTER TABLE blinkit_delivery_performance
    MODIFY COLUMN promised_time DATETIME,
    MODIFY COLUMN actual_time DATETIME,
    MODIFY COLUMN delivery_time_minutes DECIMAL(5,2),
    MODIFY COLUMN distance_km DECIMAL(6,2),
    MODIFY COLUMN delivery_status VARCHAR(50),
    MODIFY COLUMN reasons_if_delayed VARCHAR(255);


UPDATE blinkit_inventory
SET date = STR_TO_DATE(date, '%d-%m-%Y');
ALTER TABLE blinkit_inventory
MODIFY COLUMN date DATE;

ALTER TABLE blinkit_customer_feedback
MODIFY COLUMN feedback_date DATE;

ALTER TABLE blinkit_marketing_performance
MODIFY COLUMN date DATE;

select * from blinkit_orders;
select * from blinkit_marketing_performance;
select * from blinkit_products;

-- Standardisation is completed

-- Missing foreign key references
SELECT order_id FROM blinkit_orders WHERE delivery_partner_id IS NULL;

-- Out-of-range values
SELECT * FROM blinkit_marketing_performance WHERE roas < 0;

-- Checking customer_ids in blinkit_orders present in blinkit_customers(Foreign key reference)
SELECT customer_id 
FROM blinkit_orders 
WHERE customer_id NOT IN (SELECT customer_id FROM blinkit_customers);

SELECT product_id 
FROM blinkit_inventory 
WHERE product_id NOT IN (SELECT product_id FROM blinkit_products);



SELECT DISTINCT payment_method FROM blinkit_orders;

-- checking for duplicates in primary key in all tables
SELECT order_id, COUNT(*) FROM blinkit_orders GROUP BY order_id HAVING COUNT(*) > 1;

SELECT product_id, COUNT(*) AS dup_count
FROM blinkit_products
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT product_id, date, COUNT(*) AS dup_count
FROM blinkit_inventory
GROUP BY product_id, date
HAVING COUNT(*) > 1;

SELECT feedback_id, COUNT(*) AS dup_count
FROM blinkit_customer_feedback
GROUP BY feedback_id
HAVING COUNT(*) > 1;

SELECT campaign_id, COUNT(*) AS dup_count
FROM blinkit_marketing_performance
GROUP BY campaign_id
HAVING COUNT(*) > 1;

-- No duplicates

SELECT COUNT(*) AS invalid_customer_ids_in_orders
FROM blinkit_orders 
WHERE customer_id NOT IN (SELECT customer_id FROM blinkit_customers);

-- Core steps in Data cleaning done.
-- Checked for nulls
-- Standardized data types
-- Fixed date formats
-- Ensured foreign key integrity
-- Checked for duplicates


