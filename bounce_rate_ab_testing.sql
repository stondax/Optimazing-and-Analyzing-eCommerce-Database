-- Task:
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

SELECT 
    MIN(created_at) AS min_created_date,
    MIN(website_pageview_id) AS min_pageview_id
FROM
    website_pageviews
where pageview_url = '/lander-1'
	and created_at is not null;
    
-- min pageview id is 23504
-- 2012-06-14 is the date of the request
-- Step 1: finding the first website_pageview_id for relevant session

CREATE TEMPORARY TABLE first_test_pageviews_3
SELECT 
    website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM
    website_pageviews
        INNER JOIN
    website_sessions ON website_pageviews.website_session_id = website_sessions.website_session_id
        AND website_pageviews.website_pageview_id > 23504
        AND website_pageviews.created_at < '2012-07-28'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY website_pageviews.website_session_id;

CREATE TEMPORARY TABLE sessions_w_home_landing_page_3
SELECT 
    first_test_pageviews_3.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM
    first_test_pageviews_3
        LEFT JOIN
    website_pageviews ON website_pageviews.website_pageview_id = first_test_pageviews_3.min_pageview_id 
WHERE
    website_pageviews.pageview_url IN ('/home' , '/lander-1');
    
    -- Step 3: counting pageviews for each session, to identify "bounces"

CREATE TEMPORARY TABLE bounced_sessions
Select
	sessions_w_home_landing_page_3.website_session_id,
    sessions_w_home_landing_page_3.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
from 
	sessions_w_home_landing_page_3
left join 
	website_pageviews
ON sessions_w_home_landing_page_3.website_session_id = website_pageviews.website_session_id
GROUP BY 
	sessions_w_home_landing_page_3.landing_page, sessions_w_home_landing_page_3.website_session_id
HAVING 
	COUNT(website_pageviews.website_pageview_id) = 1;
    
Select 
	sessions_w_home_landing_page_3.landing_page,
	Count(distinct sessions_w_home_landing_page_3.website_session_id) as total_sessions,
    Count(distinct bounced_sessions.website_session_id) as bounced_sessions,
    Count(distinct bounced_sessions.website_session_id)/Count(distinct sessions_w_home_landing_page_3.website_session_id) as bounced_rate 
FROM 
	sessions_w_home_landing_page_3
LEFT JOIN
	bounced_sessions
ON 
	sessions_w_home_landing_page_3.website_session_id = bounced_sessions.website_session_id

GROUP BY 
	sessions_w_home_landing_page_3.landing_page;


	