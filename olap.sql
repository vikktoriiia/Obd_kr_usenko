SELECT
    o.order_date,
    SUM(mi.price * oi.quantity) AS daily_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN menu_items mi ON oi.menu_item_id = mi.menu_items_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY o.order_date
ORDER BY o.order_date;

SELECT
    mi.menu_items_name,
    SUM(oi.quantity) AS total_ordered
FROM order_items oi
JOIN menu_items mi ON oi.menu_item_id = mi.menu_items_id
GROUP BY mi.menu_items_name
ORDER BY total_ordered DESC
LIMIT 10;

SELECT
    CASE
        WHEN sub.order_time BETWEEN '06:00' AND '11:59' THEN 'Сніданок'
        WHEN sub.order_time BETWEEN '12:00' AND '17:59' THEN 'Обід'
        ELSE 'Вечеря'
    END AS time_of_day,
    AVG(sub.order_total) AS avg_order_value
FROM (
    SELECT
        o.order_time,
        SUM(mi.price * oi.quantity) AS order_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN menu_items mi ON oi.menu_item_id = mi.menu_items_id
    GROUP BY o.order_id, o.order_time
) sub
GROUP BY
    CASE
        WHEN sub.order_time BETWEEN '06:00' AND '11:59' THEN 'Сніданок'
        WHEN sub.order_time BETWEEN '12:00' AND '17:59' THEN 'Обід'
        ELSE 'Вечеря'
    END
ORDER BY time_of_day;

WITH client_total_spending AS (
    SELECT
        c.client_id,
        c.client_name,
        SUM(mi.price * oi.quantity) AS total_spent
    FROM client c
    JOIN orders o ON c.client_id = o.client_id
    JOIN order_items oi ON o.order_id = oi.order_id
    JOIN menu_items mi ON oi.menu_item_id = mi.menu_items_id
    GROUP BY c.client_id, c.client_name
)
SELECT
    client_id,
    client_name,
    total_spent
FROM client_total_spending
ORDER BY total_spent DESC;
