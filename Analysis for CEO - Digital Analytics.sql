CREATE DATABASE Internship_Project_3;

Select * from orders
Select * from order_items
Select * from order_item_refunds
Select * from products
Select * from website_pageviews
Select * from website_sessions


-------------------------------------- Analysis For CEO ----------------------------------------------
------------------------------ 1.) Finding Top Traffic Sources----------------------------------
----- Objective: Identify which traffic sources (utm_source) bring the most users and conversions.
----- Business Impact: Helps optimize marketing budgets by focusing on high-performing sources and 
-----------------------adjusting spend on low-performing ones.

SELECT utm_source, COUNT(DISTINCT ws.website_session_id) AS session_count, 
       SUM(o.price_usd) AS total_revenue, 
       COUNT(DISTINCT o.order_id) * 100.0 / COUNT(DISTINCT ws.website_session_id) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
GROUP BY utm_source
ORDER BY total_revenue DESC;

------------------------------ 2.) Analyzing Free Channels --------------------------------------
------ Objective: Understand the performance of organic and referral traffic.
------ Business Impact: Helps refine SEO strategy and evaluate the effectiveness of referral partnerships.

SELECT 
    ws.utm_source,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.price_usd) AS total_revenue
FROM website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
WHERE ws.utm_source
GROUP BY ws.utm_source
ORDER BY total_revenue DESC;

------------------------------ 3.) Analyzing Seasonality --------------------------------------
----- Objective: Identify sales patterns across different months and seasons.
----- Business Impact: Helps in inventory planning, staffing, and seasonal marketing campaigns.

SELECT 
    YEAR(created_at) AS year,
    MONTH(created_at) AS month,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(price_usd) AS total_revenue
FROM orders
GROUP BY YEAR(created_at), MONTH(created_at)
ORDER BY year, month;

----------------------------- 4.) Product-Level Analysis ----------------------------------------
----- Objective: Determine the best-performing products in terms of sales and revenue.
----- Business Impact: Helps in optimizing product strategy and managing inventory.

SELECT 
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price_usd) AS total_revenue,
    SUM(oi.cogs_usd) AS total_cogs,
    (SUM(oi.price_usd) - SUM(oi.cogs_usd)) AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC;

----------------------------- 5.) Product Launch Sales Analysis ---------------------------------
----- Objective: Evaluate the success of newly launched products.
----- Business Impact: Helps refine go-to-market strategies for new products.

SELECT 
    p.product_name,
    MIN(p.created_at) AS launch_date,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price_usd) AS total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE p.created_at >= DATEADD(YEAR, -2, '2015-03-31') -- Last 6 months
GROUP BY p.product_name
ORDER BY total_revenue DESC;

----------------------------- 6.) Cross-Sell Analysis -----------------------------------------
----- Objective: Identify product combinations frequently bought together.
----- Business Impact: Helps create targeted upsell and cross-sell opportunities.

SELECT 
    oi1.product_id AS product_1,
    p1.product_name AS product_1_name,
    oi2.product_id AS product_2,
    p2.product_name AS product_2_name,
    COUNT(DISTINCT oi1.order_id) AS times_purchased_together
FROM order_items oi1
JOIN order_items oi2 ON oi1.order_id = oi2.order_id AND oi1.product_id <> oi2.product_id
JOIN products p1 ON oi1.product_id = p1.product_id
JOIN products p2 ON oi2.product_id = p2.product_id
GROUP BY oi1.product_id, p1.product_name, oi2.product_id, p2.product_name
ORDER BY times_purchased_together DESC;

-------------------------- 7.) Portfolio Expansion Analysis -----------------------------------
----- Objective: Determine if adding new product categories would drive more sales.
----- Business Impact: Helps in strategic decision-making for new product introductions.

SELECT 
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    SUM(oi.price_usd) AS total_revenue,
    SUM(oi.cogs_usd) AS total_cogs,
    (SUM(oi.price_usd) - SUM(oi.cogs_usd)) AS total_profit
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
WHERE p.created_at >= DATEADD(YEAR, -2, '2015-03-31') -- Products added in the last 1 year
GROUP BY p.product_name
ORDER BY total_revenue DESC;

------------------------- 8.) Product Refund Rate Analysis ----------------------------------
----- Objective: Identify products with high refund rates.
----- Business Impact: Helps improve product quality and customer satisfaction.

SELECT 
    p.product_name,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT oir.order_item_refund_id) AS total_refunds,
    SUM(oir.refund_amount_usd) AS total_refunded_amount,
    (COUNT(DISTINCT oir.order_item_refund_id) * 100.0 / COUNT(DISTINCT oi.order_id)) AS refund_rate
FROM order_items oi
LEFT JOIN order_item_refunds oir ON oi.order_item_id = oir.order_item_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY refund_rate DESC;





