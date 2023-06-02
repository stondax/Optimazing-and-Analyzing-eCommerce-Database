-- Task 

-- Based on your bounce rate analysis, we ran a new custom landing page (/lander-1)
-- in a 50/50 test against the homepage (/home) for our gsearch nonbrand traffic.
-- Can you pull bounce rates for the two groups so we can evaluate the new pages?
-- Make sure to just look at the time period where /lander-1 was getting traffic, 
-- so that it is a fair comparison

-- Step 0: find out when the new page/lander launched
-- Step 1: finding the first website_pageview_id for relevant sessions
-- Step 2: identifying the landing page of each session
-- Step 3: counting pageviews for each session, to identify "bounces"
-- Step 4: Summarizing total sessions and bounced sessions, by LP


USE mavenfuzzyfactory;

SELECT 
    MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id
FROM
    website_pageviews
WHERE
    pageview_url = '/lander-1'
        AND created_at IS NOT NULL;

-- first_created_at = '2012-06-19 00:35:54'
-- first_pageview_id = 23504

CREATE TEMPORARY TABLE first_test_pageviews
SELECT
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews
		INNER JOIN website_sessions
			ON website_sessions.website_session_id = website_pageviews.website_session_id
            AND website_sessions.created_at < '2012-07-28' -- prescribed by the assignment
            AND website_pageviews.website_pageview_id > 23504 -- the min pageview id
            AND utm_source = 'gsearch'
            AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;


-- next, we'll bring in the landing page to each sessions, like the last time
-- but restricting to home or lander-1 this time

-- CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_page
SELECT 
    first_test_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM
    first_test_pageviews
        LEFT JOIN
    website_pageviews ON website_pageviews.website_pageview_id = first_test_pageviews.min_pageview_id
WHERE
    website_pageviews.pageview_url IN ('/home' , '/lander-1');

-- then a table to have count of pageviews per session
	-- then limit it to just bounced sessions
CREATE TEMPORARY TABLE nonbrand_test_bounced_sessions    
SELECT 
    nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM
    nonbrand_test_sessions_w_landing_page
        LEFT JOIN
    website_pageviews ON website_pageviews.website_session_id = nonbrand_test_sessions_w_landing_page.website_session_id
GROUP BY nonbrand_test_sessions_w_landing_page.website_session_id , nonbrand_test_sessions_w_landing_page.landing_page
HAVING COUNT(website_pageviews.website_pageview_id) = 1;


SELECT 
    nonbrand_test_sessions_w_landing_page.landing_page,
    Count(Distinct nonbrand_test_sessions_w_landing_page.website_session_id) as sessions,
    Count(Distinct nonbrand_test_bounced_sessions.website_session_id) AS bounced_sessions,
    Count(Distinct nonbrand_test_bounced_sessions.website_session_id)/Count(Distinct nonbrand_test_sessions_w_landing_page.website_session_id) as bounced_session_rate
FROM
    nonbrand_test_sessions_w_landing_page
        LEFT JOIN nonbrand_test_bounced_sessions 
			ON nonbrand_test_sessions_w_landing_page.website_session_id = nonbrand_test_bounced_sessions.website_session_id
Group BY nonbrand_test_sessions_w_landing_page.landing_page;
	
