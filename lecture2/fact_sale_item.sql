DROP TABLE IF EXISTS fact.sale_item CASCADE;
CREATE TABLE fact.sale_item (
    date_key int not null references dim.date(id),
    customer_key int not null references dim.customer(id),
    store_key int NOT NULL REFERENCES dim.store(id),
    product_key int references dim.product(id),
    transaction_id int not null,
    line_number smallint not null,
    quantity smallint not null,
    unit_price float8,
    unit_cost float8,
    sales_value float8,
    sales_cost float8,
    margin float8
);


INSERT INTO fact.sale_item (date_key, customer_key, store_key, product_key, transaction_id, line_number, quantity, unit_price, unit_cost, sales_value, sales_cost, margin)
SELECT
     to_char(dt, 'YYYYMMDD')::int as date_key,
     customer_id,
     store_id,
     p.id,
     transaction_id, line_number, quantity,
     p.unit_price, p.unit_cost, p.unit_price * si.quantity, p.unit_cost * si.quantity, p.unit_price * si.quantity - p.unit_cost * si.quantity
FROM nds.sale_item si
LEFT JOIN dim.product p ON p.code::int = si.music_id
;