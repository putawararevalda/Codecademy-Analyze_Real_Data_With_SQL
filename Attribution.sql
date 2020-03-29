/*Campaigns*/
SELECT DISTINCT(utm_campaign)
FROM page_visits;

/*Sources*/
SELECT DISTINCT(utm_source)
FROM page_visits;

/*Campaigns & Sources Relationship*/
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

/*Pages on Site*/
SELECT DISTINCT(page_name)
FROM page_visits;

/*First Touch*/
WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
    ft_attr AS( 
    SELECT ft.user_id,
               ft.first_touch_at,
               pv.utm_source,
               pv.utm_campaign
    FROM first_touch as ft
      JOIN page_visits as PV
        ON ft.user_id = pv.user_id
        AND ft.first_touch_at = pv.timestamp
    )
SELECT ft_attr.utm_campaign,
        ft_attr.utm_source,
        COUNT(*)
FROM fT_attr
GROUP BY 1,2
ORDER BY 3 DESC;

/*Last Touch*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
    lt_attr AS( 
    SELECT lt.user_id,
               lt.last_touch_at,
               pv.utm_source,
               pv.utm_campaign
    FROM last_touch as lt
      JOIN page_visits as PV
        ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
    )
SELECT lt_attr.utm_campaign,
        lt_attr.utm_source,
        COUNT(*)
FROM lt_attr
GROUP BY 1,2
ORDER BY 3 DESC;

/*# of visitors making purchase*/
SELECT COUNT(DISTINCT(user_id))
FROM page_visits
WHERE page_name = '4 - purchase';

/*Last touches on purchase page per campaign*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
    lt_attr AS( 
    SELECT lt.user_id,
               lt.last_touch_at,
               pv.utm_source,
               pv.utm_campaign,
              pv.page_name
    FROM last_touch as lt
      JOIN page_visits as PV
        ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
    )
SELECT lt_attr.utm_campaign,
        lt_attr.utm_source,
        COUNT(*)
FROM lt_attr
GROUP BY 1,2
ORDER BY 3 DESC;

/*Typical User Journey*/
SELECT page_name,COUNT(*)
FROM page_visits
GROUP BY page_name;

/*Top 5 campaigns that lead to purchase*/
WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
    lt_attr AS( 
    SELECT lt.user_id,
               lt.last_touch_at,
               pv.utm_source,
               pv.utm_campaign,
              pv.page_name
    FROM last_touch as lt
      JOIN page_visits as PV
        ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
    )
SELECT lt_attr.utm_campaign,
        lt_attr.utm_source,
        COUNT(*)
FROM lt_attr
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 5;