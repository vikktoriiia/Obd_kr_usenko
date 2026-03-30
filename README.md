# Котрольна робота

Виконала студента ІО-41, Усенко Вікторія

---
1)  Спочатку в DataGrip я створюю новий проект. Далі створюю create_tables.sql для того, щоб створити самі бази для подального працювання з цими базами.
2)  Далі я створюю insert_data.sql, для того, щоб наповнити нашу базу даними.
3)  Для того, щоб побачити зміни після моїх запитів, для початку я виведу всю інформацію, що я заповнила
<img width="1728" height="402" alt="Снимок экрана 2026-03-30 170907" src="https://github.com/user-attachments/assets/b9d5cbcc-a922-4139-b37f-9435b42e32cf" />
<img width="1845" height="251" alt="Снимок экрана 2026-03-30 170932" src="https://github.com/user-attachments/assets/1d86f39a-d790-407f-b41a-b5af8a87c597" />
<img width="1670" height="442" alt="Снимок экрана 2026-03-30 171107" src="https://github.com/user-attachments/assets/95f6195b-1c3e-4cc2-9cba-4fa37a132cdb" />
<img width="2129" height="577" alt="Снимок экрана 2026-03-30 171129" src="https://github.com/user-attachments/assets/d536a5b6-60ce-45e4-9b54-c0a745c1c7d9" />
<img width="1846" height="244" alt="Снимок экрана 2026-03-30 171142" src="https://github.com/user-attachments/assets/f91329a1-5a24-4dfa-ba38-11b8c2c8f389" />
<img width="1689" height="392" alt="Снимок экрана 2026-03-30 171200" src="https://github.com/user-attachments/assets/9c02ab67-0984-445f-b07c-6cf8af915318" />

## Тепер я буду писати OLTP запити:

**insert**

1) Додаю нового клієнта
 ```sql
INSERT INTO client (client_id, client_name, phone_number, email)
VALUES (7, 'Петро', '+380674896324', 'petro@gmail.com');
```
<img width="1704" height="462" alt="Снимок экрана 2026-03-30 171748" src="https://github.com/user-attachments/assets/457dfaa7-f2cd-4a96-b15c-789b3af0a15d" />

---
2)Додаю та створюю нове замовлення

```sql
INSERT INTO orders (client_id, table_id, order_time, order_status)
VALUES (2, 1, '20:00', 'new');
```
<img width="1851" height="309" alt="Снимок экрана 2026-03-30 173120" src="https://github.com/user-attachments/assets/13e9d793-06ec-4919-bc99-88bee2a8fb9f" />

---

**update**

1) Оновлюю статус замовлення

```sql
UPDATE orders
SET order_status = 'completed'
WHERE order_id = 1;
```
<img width="2019" height="291" alt="Снимок экрана 2026-03-30 174952" src="https://github.com/user-attachments/assets/5a15e5d4-60ac-4e1e-b3a7-80bf33a5f431" />

---

2) Змінюю позицію 5 меню на 6 в замовленні

```sql
UPDATE order_items
SET menu_item_id = 6
WHERE order_id = 3 AND menu_item_id = 5;
```

<img width="1692" height="400" alt="Снимок экрана 2026-03-30 180214" src="https://github.com/user-attachments/assets/8e43d16e-8ff9-4d80-86de-2e9213c1baa4" />

---
**delete**

1) Тут я видаляю замовлення, але попередньо видаляю позиції з замовлення:

```sql
DELETE FROM order_items
WHERE order_id = 4;
DELETE FROM orders
WHERE order_id = 4;
```
<img width="2038" height="254" alt="Снимок экрана 2026-03-30 180641" src="https://github.com/user-attachments/assets/914aa329-f1ae-4433-8f44-b11686903a32" />

2) Далі я видаляю клієнта 7

```sql
DELETE FROM client
WHERE client_id = 7;
```
<img width="1680" height="387" alt="Снимок экрана 2026-03-30 181030" src="https://github.com/user-attachments/assets/ba01cb40-f5f1-408e-b5dd-3a7ebd5044ea" />

---
**select**

1) підготувати чек для замовлення

```sql
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
```
<img width="2190" height="198" alt="Снимок экрана 2026-03-30 181534" src="https://github.com/user-attachments/assets/d52c33ff-cfe6-4277-a9ab-dc3940baa1df" />

2) знайти всі не зайняті столики (столики, для яких немає незавершених замовлень)
```sql
SELECT *
FROM restaurant_table rt
WHERE rt.table_id NOT IN (
    SELECT table_id
    FROM orders
    WHERE order_status != 'completed'
);
```

<img width="1651" height="458" alt="Снимок экрана 2026-03-30 181850" src="https://github.com/user-attachments/assets/ac969761-7d6d-440d-a795-284a366a221a" />

## Тепер я буду писати OLАP запити:

1) Обчислити загальний денний дохід за датами за останній місяць 
```sql
SELECT
    o.order_date,
    SUM(mi.price * oi.quantity) AS daily_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN menu_items mi ON oi.menu_item_id = mi.menu_items_id
WHERE o.order_date >= CURRENT_DATE - INTERVAL '1 month'
GROUP BY o.order_date
ORDER BY o.order_date;

```
<img width="948" height="243" alt="Снимок экрана 2026-03-30 182817" src="https://github.com/user-attachments/assets/c1e98433-54c6-4abc-b2de-011802a57814" />


2) Знайти топ-10 найбільш популярних позицій меню(у мене топ-6, оскільки в мене не багато страв, які замовляли)
```sql
SELECT
    mi.menu_items_name,
    SUM(oi.quantity) AS total_ordered
FROM order_items oi
JOIN menu_items mi ON oi.menu_item_id = mi.menu_items_id
GROUP BY mi.menu_items_name
ORDER BY total_ordered DESC
LIMIT 10;
```

<img width="1056" height="412" alt="Снимок экрана 2026-03-30 183116" src="https://github.com/user-attachments/assets/d91be52e-2a0b-40af-bb20-309c905625d0" />

3) Обчислити середню вартість замовлення за часом доби (сніданок, обід, вечеря) у мене обід та вечера, оскільки ніхто не замовляв зранку
```sql
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
```

<img width="987" height="182" alt="Снимок экрана 2026-03-30 183628" src="https://github.com/user-attachments/assets/6a51d937-bd48-431e-9908-4830dc87b0a2" />

4) Визначити клієнтів з найбільшими загальними витратами (CTE)

```sql
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
```

<img width="1294" height="228" alt="Снимок экрана 2026-03-30 183927" src="https://github.com/user-attachments/assets/2401df8f-e765-4fa9-bde1-bacbaffbd5a4" />
