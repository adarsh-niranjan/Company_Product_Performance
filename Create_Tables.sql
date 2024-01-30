--Creating tables from csv files for analysis, in case of text files just remove CSV, HEADER keyword from copy command.

-- 1. customer
CREATE TABLE customer (
	customer_id varchar PRIMARY KEY,
	customer_name varchar,
	segment varchar,
	age int,
	country varchar,
	city varchar,
	state varchar,
	postal_code bigint,
	region varchar 
);
COPY Customer from 'Source\Customer.csv' DELIMITER ',' CSV HEADER;

-- 2. sale
CREATE TABLE sale (
	order_line int PRIMARY KEY,
	order_id varchar,
	order_date date,
	ship_date date,
	ship_mode varchar,
	customer_id varchar,
	product_id varchar,
	sales numeric,
	quantity int,
	discount numeric,
	profit numeric
);
COPY Sale from 'Source\Sales.csv' DELIMITER ',' CSV HEADER;

-- 3. product
CREATE TABLE product (
	product_id varchar PRIMARY KEY,
	category varchar,
	sub_category varchar,
	product_name varchar
);
COPY Product from 'Source\Product.csv' DELIMITER ',' CSV HEADER;