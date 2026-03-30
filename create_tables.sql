--тут я створюю таблички наші для роботи:
--Клієнти (ім'я, телефон, email)
--Столики (номер столика, місткість, розташування)
--Позиції меню (назва, опис, ціна, категорія)
--Замовлення (час замовлення, статус)
--Позиції замовлення (позиції в кожному замовленні з кількістю)

create table client(
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(13) NOT NULL,
    email VARCHAR(50)
);
create table restaurant_table(
    table_id SERIAL PRIMARY KEY,
    table_number INT NOT NULL,
    capacity INT NOT NULL,
    arrangement VARCHAR(100) NOT NULL
);
create table menu_items(
    menu_items_id SERIAL PRIMARY KEY,
    menu_items_name VARCHAR(30) NOT NULL ,
    description VARCHAR(200),
    price NUMERIC(10,2) NOT NULL ,
    category VARCHAR(30) NOT NULL
);
create table orders(
    order_id SERIAL PRIMARY KEY,
    client_id INT NOT NULL,
    table_id INT NOT NULL,
    order_time TIME NOT NULL,
    order_status VARCHAR(20) NOT NULL,
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (table_id) REFERENCES restaurant_table(table_id)
);
create table order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(menu_items_id)
);
ALTER TABLE orders
ADD COLUMN order_date DATE;
