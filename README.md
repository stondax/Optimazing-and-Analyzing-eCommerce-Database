# Optimazing-and-Analyzing-eCommerce-Database
My work showcases the analysis and optimazation of marketing channels, measuring and testing website conversion performance, and using data to understand the impact of new product launches.

The provided codes are SQL queries used to analyze and measure conversion funnels and bounce rates on a website. Here's a breakdown of each code:

Building Conversion Funnels:

The code selects relevant website sessions and pageviews within a specified timeframe.
It assigns flags to each pageview based on specific URLs.
The data is ordered and retrieved.
Creating Session-Level Conversion Funnel View:

The previous query is placed inside a subquery to create a temporary table.
The data is grouped by website_session_id, and the maximum value of each flag is taken to indicate whether a session reached a specific step.
Aggregating Data for Funnel Performance:

The temporary table from the previous query is used.
The code counts the number of sessions that reached each step of the funnel.
Analyzing Funnel Click-Through Rates:

Similar to the previous query, it counts the number of sessions that reached each step of the funnel.
Additionally, it calculates the click-through rates between funnel steps.
Analyzing Conversion Funnel for a Custom Landing Page:

The code builds a conversion funnel from a custom landing page to the thank you page.
It selects relevant sessions and assigns flags to each step of the funnel.
The data is grouped and counts the number of sessions that reached each step.
Analyzing Click-Through Rates for Conversion Funnel:

Similar to the previous query, it calculates the click-through rates between each step of the conversion funnel.
Analyzing Bounce Rates for A/B Test:

The code identifies the launch date and minimum pageview ID for a new landing page (/lander-1).
It selects relevant sessions and identifies the landing page for each session.
The code counts the pageviews for each session and identifies bounced sessions (sessions with only one pageview).
Finally, it calculates the bounce rates for each landing page (/home and /lander-1).
Analyzing Traffic Sources:

The code analyzes the traffic sources and their corresponding sessions.
It groups the data by utm_source and calculates the total traffic and mobile traffic.
It also calculates the percentage of mobile traffic out of total traffic.
Analyzing Desktop Traffic Sources:

The code analyzes the traffic sources for desktop users.
It groups the data by utm_source and calculates the number of sessions for each source.
Additionally, it calculates the percentage of bsearch sessions out of gsearch sessions for desktop users.

