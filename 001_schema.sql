DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
	customer_id BIGINT PRIMARY KEY,
	first_name VARCHAR NOT NULL,
	middle_initial VARCHAR,
	last_name VARCHAR NOT NULL
);

DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees (
	employee_id BIGINT PRIMARY KEY,
	first_name VARCHAR NOT NULL,
	middle_initial VARCHAR,
	last_name VARCHAR NOT NULL
);

DROP TABLE IF EXISTS Products;
CREATE TABLE Products (
	product_id BIGINT PRIMARY KEY,
	name VARCHAR NOT NULL,
	price DECIMAL(19,4) NOT NULL
);

DROP TABLE IF EXISTS Sales;
CREATE TABLE Sales (
	sales_id BIGINT PRIMARY KEY,
	sales_person_id BIGINT REFERENCES Employees(employee_id) NOT NULL,
	customer_id BIGINT REFERENCES Customers(customer_id) NOT NULL,
	product_id BIGINT REFERENCES Products(product_id) NOT NULL,
	quantity int NOT NULL
);
