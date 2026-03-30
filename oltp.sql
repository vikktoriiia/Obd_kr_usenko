SELECT * FROM client;
SELECT * FROM restaurant_table;
SELECT * FROM menu_items;
SELECT * FROM orders;
SELECT * FROM order_items;

--insert
INSERT INTO client (client_id, client_name, phone_number, email)
VALUES (7, 'Петро', '+380674896324', 'petro@gmail.com');

INSERT INTO orders (client_id, table_id, order_time, order_status)
VALUES (2, 1, '20:00', 'new');

--update
UPDATE orders
SET order_status = 'completed'
WHERE order_id = 1;

UPDATE order_items
SET menu_item_id = 6
WHERE order_id = 3 AND menu_item_id = 5;

--delete

DELETE FROM order_items
WHERE order_id = 4;
DELETE FROM orders
WHERE order_id = 4;

DELETE FROM client
WHERE client_id = 7;

--select

SELECT
    c.client_name,
    rt.table_number,
    mi.menu_items_name,
    oi.quantity,
    mi.price,
    (mi.price * oi.quantity) AS total_price
FROM order_items oi
JOIN menu_items mi ON oi.menu_item_id = mi.menu_items_id
JOIN orders o ON oi.order_id = o.order_id
JOIN client c ON o.client_id = c.client_id
JOIN restaurant_table rt ON o.table_id = rt.table_id
WHERE oi.order_id = 1;

SELECT *
FROM restaurant_table rt
WHERE rt.table_id NOT IN (
    SELECT table_id
    FROM orders
    WHERE order_status != 'completed'
);

UPDATE orders
SET order_date = '2026-03-01'
WHERE order_id = 1;

UPDATE orders
SET order_date = '2026-03-15'
WHERE order_id = 2;

UPDATE orders
SET order_date = '2026-03-20'
WHERE order_id = 3;
