CREATE ROLE student WITH LOGIN PASSWORD 'student'
NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION VALID UNTIL 'infinity';

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
	customer_id BIGINT PRIMARY KEY,
	first_name VARCHAR NOT NULL,
	middle_initial VARCHAR,
	last_name VARCHAR NOT NULL,
	age INT NOT NULL
);

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	employee_id BIGINT PRIMARY KEY,
	first_name VARCHAR NOT NULL,
	middle_initial VARCHAR,
	last_name VARCHAR NOT NULL
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	product_id BIGINT PRIMARY KEY,
	name VARCHAR NOT NULL,
	price DECIMAL(19,4) NOT NULL
);

DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
	sales_id BIGINT PRIMARY KEY,
	sales_person_id BIGINT REFERENCES employees(employee_id) NOT NULL,
	customer_id BIGINT REFERENCES customers(customer_id) NOT NULL,
	product_id BIGINT REFERENCES products(product_id) NOT NULL,
	quantity int NOT NULL,
	sale_date DATE
);

-- GRANT SELECT ON ALL TABLES IN SCHEMA public TO student;
GRANT SELECT ON TABLE public.customers TO student;
GRANT SELECT ON TABLE public.employees TO student;
GRANT SELECT ON TABLE public.products TO student;
GRANT SELECT ON TABLE public.sales TO student;
