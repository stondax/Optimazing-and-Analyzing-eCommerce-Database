-- Task 

-- we tested an updated billing page based on your funnel analysis. Can you take a look and see whether 
-- /billing-2 is doing any better than the original /billing page?
-- We're wondering what % of sessions on those pages end up placing an order. FYI - we ran this test for all traffic
-- not just our search visitors

use mavenfuzzyfactory;

-- first, finding the starting point to frame the analysis:

SELECT 
	MIN(website_pageviews.website_pageview_id) AS first_pv_id
FROM website_pageviews
WHERE pageview_url = '/billing-2';
 -- first_pv_id 53550

SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen
    ,orders.order_id
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.website_pageview_id >= 53550 -- first pageview id where test was live
	AND website_pageviews.created_at < '2012-11-10' -- time for assignment
    AND website_pageviews.pageview_url IN ('/billing', '/billing-2');
    
Select 
	billing_version_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) AS orders,
    COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id) AS billing_to_order_rt
FROM(
SELECT 
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen
    ,orders.order_id
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.website_pageview_id >= 53550 -- first pageview id where test was live
	AND website_pageviews.created_at < '2012-11-10' -- time for assignment
    AND website_pageviews.pageview_url IN ('/billing', '/billing-2')
) AS billing_sessions_w_orders
GROUP BY 
	billing_version_seen;
		
		
