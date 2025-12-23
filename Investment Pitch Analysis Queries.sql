SELECT 
    YEAR(ws.created_at) AS Year,
    DATEPART(QUARTER, ws.created_at) AS Quarter,
    COUNT(DISTINCT ws.website_session_id) AS Total_Sessions,
    COUNT(DISTINCT o.order_id) AS Total_Orders,
    ROUND( (COUNT(DISTINCT o.order_id) * 100.0) / NULLIF(COUNT(DISTINCT ws.website_session_id), 0), 2) AS Conversion_Rate_Percentage
FROM website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
GROUP BY YEAR(ws.created_at), DATEPART(QUARTER, ws.created_at)
ORDER BY Year DESC, Quarter DESC;

------------------------------------------------------------
SELECT 
    YEAR(o.created_at) AS Year,
    SUM(o.price_usd) AS Total_Revenue,
    SUM(o.price_usd - o.cogs_usd) AS Total_Profit
FROM orders o
GROUP BY YEAR(o.created_at)
ORDER BY Year DESC;

---------------------------------------------------------
SELECT 
    YEAR(created_at) AS Year,
    COUNT(order_id) AS Total_Orders
FROM orders
GROUP BY YEAR(created_at)
ORDER BY Year DESC;

--------------------------------------------------
SELECT 
    YEAR(ws.created_at) AS Year,
    COUNT(DISTINCT ws.user_id) AS Total_Visitors,
    COUNT(DISTINCT o.user_id) AS Total_Customers
FROM website_sessions ws
LEFT JOIN orders o ON ws.user_id = o.user_id  -- Joining to get customers who placed orders
GROUP BY YEAR(ws.created_at)
ORDER BY Year DESC;

-----------------------------------------------------

SELECT 
    YEAR(created_at) AS Year,
    COUNT(website_session_id) AS Total_Sessions
FROM website_sessions
GROUP BY YEAR(created_at)
ORDER BY Year DESC;

-----------------------------------------------------

WITH QuarterlyData AS (
    SELECT 
        YEAR(created_at) AS Year,
        DATEPART(QUARTER, created_at) AS Quarter,
        COUNT(DISTINCT website_session_id) AS Total_Sessions,
        COUNT(DISTINCT order_id) AS Total_Orders
    FROM (
        SELECT created_at, website_session_id, NULL AS order_id FROM website_sessions
        UNION ALL
        SELECT created_at, website_session_id, order_id FROM orders
    ) AS CombinedData
    WHERE YEAR(created_at) >= 2012
    GROUP BY YEAR(created_at), DATEPART(QUARTER, created_at)
),
GrowthData AS (
    SELECT 
        Year,
        Quarter,
        Total_Sessions,
        Total_Orders,
        LAG(Total_Sessions) OVER (ORDER BY Year, Quarter) AS Prev_Sessions,
        LAG(Total_Orders) OVER (ORDER BY Year, Quarter) AS Prev_Orders
    FROM QuarterlyData
)
SELECT 
    Year,
    Quarter,
    Total_Sessions,
    Total_Orders,
    CASE 
        WHEN Prev_Sessions IS NULL THEN NULL 
        ELSE ROUND(((Total_Sessions - Prev_Sessions) * 100.0 / Prev_Sessions), 2)
    END AS Session_Growth_Percentage,
    CASE 
        WHEN Prev_Orders IS NULL THEN NULL 
        ELSE ROUND(((Total_Orders - Prev_Orders) * 100.0 / Prev_Orders), 2)
    END AS Order_Growth_Percentage
FROM GrowthData
ORDER BY Year DESC, Quarter DESC;

-------------------------------------------------------------------------------

SELECT 
    YEAR(o.created_at) AS Year,
    MONTH(o.created_at) AS Month,
    COUNT(o.order_id) AS Total_Sales,
    SUM(o.price_usd) AS Total_Revenue,
    SUM(o.price_usd - o.cogs_usd) AS Total_Profit,
    (SUM(o.price_usd - o.cogs_usd) / NULLIF(SUM(o.price_usd), 0)) * 100 AS Profit_Margin_Percentage
FROM orders o
GROUP BY YEAR(o.created_at), MONTH(o.created_at)
ORDER BY Year ASC, Month ASC;
