CREATE DATABASE Internship_Project_3;

Select * from orders
Select * from order_items
Select * from order_item_refunds
Select * from products
Select * from website_pageviews
Select * from website_sessions



--------------------------------------For Website Manager----------------------------------------------
--------------1 Identifying Top Website Pages & Entry Pages

--A. Finding the Most Visited Pages -------------------------------

--------Goal-Identify the pages with the highest number of views. ----------------
--------Business Impact: Helps identify high-traffic pages for optimization and marketing strategies.

SELECT TOP 10 pageview_url, COUNT(*) AS total_visits
FROM website_pageviews
GROUP BY pageview_url
ORDER BY total_visits DESC



--B. Finding the Most Common Entry Pages
------------Goal: Identify where users first enter the website.
------------Business Impact: Helps optimize landing pages and SEO performance.


SELECT http_referer AS entry_page, COUNT(website_session_id) AS total_sessions
FROM website_sessions
GROUP BY http_referer
ORDER BY total_sessions DESC;


--------2. Bounce Rate Analysis----------------
------------Goal: Measure the percentage of visitors who leave after viewing only one page.
------------Business Impact:  Helps identify pages with poor engagement that need improvement.




SELECT TOP 10
    wp.pageview_url,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN pv.page_views = 1 THEN ws.website_session_id END) AS bounced_sessions,
    ROUND((COUNT(DISTINCT CASE WHEN pv.page_views = 1 THEN ws.website_session_id END) * 100.0) / 
          COUNT(DISTINCT ws.website_session_id), 2) AS bounce_rate
FROM website_sessions ws
JOIN (
    SELECT website_session_id, COUNT(*) AS page_views 
    FROM website_pageviews 
    GROUP BY website_session_id
) pv ON ws.website_session_id = pv.website_session_id
JOIN website_pageviews wp ON ws.website_session_id = wp.website_session_id
GROUP BY wp.pageview_url
ORDER BY bounce_rate DESC;


------3.  Analysing landing page tests.
--------- Objective:
----------1 - Compare A/B testing of different landing pages.
----------2 - Determine which landing page leads to higher conversions.
---------Business Impact:  Helps track how effectively website traffic is converting into customers.-----------

SELECT TOP 10
    ws.http_referer AS landing_page, 
    COUNT(DISTINCT ws.website_session_id) AS total_visits,
    COUNT(DISTINCT o.order_id) AS conversions,
    ROUND((COUNT(DISTINCT o.order_id) * 100.0) / COUNT(DISTINCT ws.website_session_id), 2) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
GROUP BY ws.http_referer
ORDER BY conversion_rate DESC;


----------4. Landing Page Trend Analysis
-------------Objective : Track the performance of landing pages over time.
------------------       Identify seasonal traffic and conversion trends.
-------------Business Impact:  Understand seasonal changes in landing page effectiveness.
----------                     Optimize ad spend during peak conversion periods.

SELECT TOP 10
    ws.http_referer AS landing_page,
    DATEPART(WEEK, ws.created_at) AS week_num,
    COUNT(DISTINCT ws.website_session_id) AS total_visits,
    COUNT(DISTINCT o.order_id) AS conversions,
    ROUND((COUNT(DISTINCT o.order_id) * 100.0) / COUNT(DISTINCT ws.website_session_id), 2) AS conversion_rate
FROM website_sessions ws
LEFT JOIN orders o ON ws.website_session_id = o.website_session_id
GROUP BY ws.http_referer, DATEPART(WEEK, ws.created_at)
ORDER BY week_num DESC, conversion_rate DESC;


-------5.Build Conversion Funnel for G-Search Non-Brand Traffic
---------Objective:
------------------Track users from /lander-1 to /thankyou page.
------------------Identify drop-off points in the purchase funnel. 
---------Business Insights:
------------------Identify drop-offs in the conversion journey and optimize those steps.
------------------Improve G-Search campaign effectiveness by adjusting targeting.

SELECT TOP 10
    ws.website_session_id, 
    COUNT(DISTINCT CASE WHEN wp.pageview_url = '/lander-1' THEN wp.pageview_url END) AS lander_visits,
    COUNT(DISTINCT CASE WHEN wp.pageview_url = '/thankyou' THEN wp.pageview_url END) AS thankyou_visits,
    ROUND((COUNT(DISTINCT CASE WHEN wp.pageview_url = '/thankyou' THEN wp.pageview_url END) * 100.0) /
         NULLIF(COUNT(DISTINCT CASE WHEN wp.pageview_url = '/lander-1' THEN wp.pageview_url END), 0), 2) AS conversion_rate
FROM website_sessions ws
JOIN website_pageviews wp ON ws.website_session_id = wp.website_session_id
WHERE ws.utm_source = 'G-Search'
GROUP BY ws.website_session_id;



------------6. Analyzing Conversion Funnel Tests for /billing vs. /billing-2 (Product Pathing Analysis)
-------Objective:
-----------------Compare checkout conversion rates between /billing and /billing-2.
-----------------Identify which billing page performs better.

SELECT TOP 10
    wp.pageview_url,
    COUNT(DISTINCT ws.website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN wp.pageview_url = '/thankyou' THEN ws.website_session_id END) AS successful_checkouts,
    ROUND((COUNT(DISTINCT CASE WHEN wp.pageview_url = '/thankyou' THEN ws.website_session_id END) * 100.0) / COUNT(DISTINCT ws.website_session_id), 2) AS conversion_rate
FROM website_sessions ws
JOIN website_pageviews wp ON ws.website_session_id = wp.website_session_id
WHERE wp.pageview_url IN ('/billing', '/billing-2')
GROUP BY wp.pageview_url
ORDER BY conversion_rate DESC;
