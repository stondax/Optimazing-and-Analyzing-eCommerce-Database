-- Building Conversion Funnels

-- Business Context
	-- we want to build a mini conversion funnel, from /lander-2 to /cart
    -- we want to know how many people reach each step, and also dropoff rates

-- Step 1: select all pageviews for relevant sessions
-- Steo 2: identify each relevant pageview as the specific funnel step
-- Step 3: create the session-level conversion funnel view
-- Step 4: aggregate the data to assess funnel performance

SELECT 
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at
    , CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    , CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
    , CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- Random timeframe for demo
	AND website_pageviews.pageview_url IN ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
ORDER BY 
	website_sessions.website_session_id,
	website_pageviews.created_at
;

-- next we will put the previous query inside a subquery (similar to temporary tables)
-- we will group by website_session_id, and take the MAX() of each of the flags
-- this MAX() becomes a made_it flag for that session, to show the session made it there
CREATE TEMPORARY TABLE session_level_made_it_flags_demo
SELECT 
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it
FROM (
SELECT 
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at
    , CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    , CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
    , CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01' -- Random timeframe for demo
	AND website_pageviews.pageview_url IN ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
ORDER BY 
	website_sessions.website_session_id,
	website_pageviews.created_at
) AS pageview_level

GROUP BY 
	website_session_id
    ;





SELECT 
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart
FROM session_level_made_it_flags_demo;


SELECT 
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS lander_clickthrough_rate,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS products_clickthrough_rate,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mr_fuzzy_clickthrough_rate
FROM session_level_made_it_flags_demo;
