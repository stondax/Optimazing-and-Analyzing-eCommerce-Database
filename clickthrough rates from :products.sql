/* 
Now that we have a new product, we now look at our user path and conversion funnel
Let's look at sessions which hit the /products page and see where they went next
Could you please pull clickthrough rates from /products since the new product launch on January 6th 2013, by product
and compare to the 3 months leading up to launch as a baseline?


Step 1: Find the relevant /product pageciew with website_session_id
Step 2: find the next pageview id that occurs AFTER  the product pageview
Step 3: find the pageview url associated with any applicable next pageview_id
Step 4: Summarize the data and analyze the pre vs post periods


*/

use mavenfuzzyfactory;
-- Step 1
-- CREATE TEMPORARY TABLE products_pageviews
SELECT
	website_session_id,
    website_pageview_id,
    created_at,
    CASE
		WHEN created_at < '2013-01-06' THEN 'A. Pre_Product_2'
        WHEN created_at >='2013-01-06' THEN 'B. Post_Product_2'
        ELSE 'check logic'
	END AS time_period
FROM website_pageviews
WHERE created_at < '2013-04-06' -- date of request
	AND created_at > '2012-10-06' -- start of 3 month before product 2 launch
    AND pageview_url = '/products';
    
-- Step 2: find the next pageview id that occurs after the product pageview

CREATE TEMPORARY TABLE sessions_w_next_pageview_id
SELECT 
	products_pageviews.time_period,
    products_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_next_pageview_id
FROM products_pageviews
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = products_pageviews.website_session_id
        AND website_pageviews.website_pageview_id > products_pageviews.website_pageview_id
GROUP BY 1,2;

-- Step 3: find the pageview_url associated with any applicable next pageview id
CREATE TEMPORARY TABLE sessions_w_next_pageview_url
SELECT
	sessions_w_next_pageview_id.time_period,
    sessions_w_next_pageview_id.website_session_id,
    website_pageviews.pageview_url AS next_pageview_url
FROM sessions_w_next_pageview_id
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = sessions_w_next_pageview_id.min_next_pageview_id;
        
        
SELECT 
	sessions_w_next_pageview_id.time_period,
    sessions_w_next_pageview_id.website_session_id,
    website_pageviews.pageview_url AS next_pageview_url
FROM sessions_w_next_pageview_id
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = sessions_w_next_pageview_id.min_next_pageview_id;

    
