use mavenfuzzyfactory;

SELECT 
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE
            WHEN utm_source = 'gsearch' THEN website_session_id
            ELSE NULL
        END) AS gsearch_sessions,
    COUNT(DISTINCT CASE
            WHEN utm_source = 'bsearch' THEN website_session_id
            ELSE NULL
        END) AS bsearch_sessions
FROM
    website_sessions
WHERE
    created_at BETWEEN '2012-08-22' AND '2012-11-29'
    AND utm_campaign = 'nonbrand'
GROUP BY YEAR(created_at) , WEEK(created_at);

Select 
	utm_content,
	COUNT(Distinct website_session_id)
from website_sessions
GROUP BY 1;
    
SELECT 
    utm_source,
    COUNT(DISTINCT CASE
            WHEN
                device_type = 'mobile'
                    OR device_type = 'desktop'
            THEN
                website_session_id
            ELSE NULL
        END) AS total_traffic,
    COUNT(DISTINCT CASE
            WHEN device_type = 'mobile' THEN website_session_id
            ELSE NULL
        END) AS mobile_traffic,
    COUNT(DISTINCT CASE
            WHEN device_type = 'mobile' THEN website_session_id
            ELSE NULL
        END) / COUNT(DISTINCT CASE
            WHEN
                device_type = 'mobile'
                    OR device_type = 'desktop'
            THEN
                website_session_id
            ELSE NULL
        END) AS mobile_traffic_percentage
FROM
    website_sessions
WHERE
    created_at > '2012-08-30'
        AND created_at < '2012-11-30'
        AND utm_campaign = 'nonbrand'
GROUP BY 1;

SELECT 
    MIN(DATE(created_at)) AS week_start_date,
    COUNT(DISTINCT CASE
            WHEN
                utm_source = 'gsearch'
                    AND device_type = 'desktop'
            THEN
                website_session_id
            ELSE NULL
        END) AS g_dtop_sessions,
    COUNT(DISTINCT CASE
            WHEN
                utm_source = 'bsearch'
                    AND device_type = 'desktop'
            THEN
                website_session_id
            ELSE NULL
        END) AS b_dtop_sessions,
    COUNT(DISTINCT CASE
            WHEN
                utm_source = 'bsearch'
                    AND device_type = 'desktop'
            THEN
                website_session_id
            ELSE NULL
        END) / COUNT(DISTINCT CASE
            WHEN
                utm_source = 'gsearch'
                    AND device_type = 'desktop'
            THEN
                website_session_id
            ELSE NULL
        END) AS b_percentage_of_g_dtop,
    COUNT(DISTINCT CASE
            WHEN
                utm_source = 'gsearch'
                    AND device_type = 'mobile'
            THEN
                website_session_id
            ELSE NULL
        END) AS g_mob_sessions,
    COUNT(DISTINCT CASE
            WHEN
                utm_source = 'bsearch'
                    AND device_type = 'mobile'
            THEN
                website_session_id
            ELSE NULL
        END) AS b_mob_sessions,
    COUNT(DISTINCT CASE
            WHEN
                utm_source = 'bsearch'
                    AND device_type = 'mobile'
            THEN
                website_session_id
            ELSE NULL
        END) / COUNT(DISTINCT CASE
            WHEN
                utm_source = 'gsearch'
                    AND device_type = 'mobile'
            THEN
                website_session_id
            ELSE NULL
        END) AS b_percentage_of_g_mob
FROM
    website_sessions
WHERE
    created_at > '2012-11-04'
        AND created_at < '2012-12-22'
        AND utm_campaign = 'nonbrand'
GROUP BY YEARWEEK(created_at) ;
	