-- Task

-- I'd like to understand where we lose our gsearch visitors between the new '/lander-1' page
-- and placing an order. Can you build us a full conversion funned analyzing how many customers
-- make it to each step? Start with /lander-1 and build the funnel all the way to our thank you page.
-- please use data since august 5th



CREATE TEMPORARY TABLE session_level_made_it_flags_5
SELECT 
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thank_you_page) AS thank_you_made_it
FROM (SELECT 
	website_sessions.website_session_id,
    website_pageviews.pageview_url
    , CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page
    , CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page
    , CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
    , CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page
    , CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page
    , CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thank_you_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE 
	website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
	AND website_sessions.created_at BETWEEN '2012-08-05' AND '2012-09-05'
ORDER BY 
	website_sessions.website_session_id,
	website_pageviews.created_at
) AS pageview_level

GROUP BY 
	website_session_id;
    

SELECT 
    COUNT(DISTINCT CASE
            WHEN product_made_it = 1 THEN website_session_id
            ELSE NULL
        END) AS to_products,
    COUNT(DISTINCT CASE
            WHEN mrfuzzy_made_it = 1 THEN website_session_id
            ELSE NULL
        END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE
            WHEN cart_made_it = 1 THEN website_session_id
            ELSE NULL
        END) AS to_cart,
    COUNT(DISTINCT CASE
            WHEN shipping_made_it = 1 THEN website_session_id
            ELSE NULL
        END) AS to_shipping,
    COUNT(DISTINCT CASE
            WHEN billing_made_it = 1 THEN website_session_id
            ELSE NULL
        END) AS to_billing,
    COUNT(DISTINCT CASE
            WHEN thank_you_made_it = 1 THEN website_session_id
            ELSE NULL
        END) AS to_thank_you
FROM
    session_level_made_it_flags_5;
	


SELECT 
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS lander_clickthrough_rate,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/ COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS products_clickthrough_rate,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mr_fuzzy_clickthrough_rate,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_clickthrough_rate,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_clickthrough_rate,
    COUNT(DISTINCT CASE WHEN thank_you_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_clickthrough_rate
FROM session_level_made_it_flags_5;




