DROP TABLE closed_deals;

CREATE TABLE closed_deals (
	mql_id varchar(32) NOT NULL,
	seller_id varchar(32) NOT NULL,
	sdr_id varchar(32) NOT NULL,
	sr_id varchar(32) NOT NULL,
	won_date timestamp NOT NULL,
	business_segment varchar(31) NULL,
	lead_type varchar(15) NULL,
	lead_behaviour_profile varchar(11) NULL,
	has_company bool NULL,
	has_gtin bool NULL,
	average_stock varchar(7) NULL,
	business_type varchar(12) NULL,
	declared_product_catalog_size numeric(6, 1) NULL,
	declared_monthly_revenue numeric(10, 1) NOT NULL,
	CONSTRAINT closed_deals_pkey PRIMARY KEY (mql_id)
);

DROP TABLE customers;
CREATE TABLE customers (
	customer_id varchar(32) NOT NULL,
	customer_unique_id varchar(32) NOT NULL,
	customer_zip_code_prefix int4 NOT NULL,
	customer_city varchar NOT NULL,
	customer_state varchar(2) NOT NULL,
	CONSTRAINT customers_pkey PRIMARY KEY (customer_id)
);

DROP TABLE marketing_qualified_leads;
CREATE TABLE marketing_qualified_leads (
	mql_id varchar(32) NOT NULL,
	first_contact_date date NOT NULL,
	landing_page_id varchar(32) NOT NULL,
	origin varchar(17) NULL,
	CONSTRAINT marketing_qualified_leads_pkey PRIMARY KEY (mql_id)
);

DROP TABLE order_items;
CREATE TABLE order_items (
	id int8 NOT NULL PRIMARY KEY,
	order_item_id int4 NOT NULL,
	order_id varchar(32) NOT NULL,
	product_id varchar(32) NOT NULL,
	seller_id varchar(32) NOT NULL,
	shipping_limit_date timestamp NOT NULL,
	price numeric(6, 2) NOT NULL,
	freight_value numeric(5, 2) NOT NULL
);

DROP TABLE orders;
CREATE TABLE orders (
	order_id varchar(32) NOT NULL,
	customer_id varchar(32) NOT NULL,
	order_status varchar NOT NULL,
	order_purchase_timestamp timestamp NOT NULL,
	order_approved_at timestamp NULL,
	order_delivered_carrier_date timestamp NULL,
	order_delivered_customer_date timestamp NULL,
	order_estimated_delivery_date timestamp NULL,
	CONSTRAINT orders_pkey PRIMARY KEY (order_id)
);

DROP TABLE products;
CREATE TABLE products (
	product_id varchar(32) NOT NULL,
	product_category_name varchar(46) NULL,
	product_name_length int4 NULL,
	product_description_length int4 NULL,
	product_photos_qty int4 NULL,
	product_weight_g int4 NULL,
	product_length_cm int4 NULL,
	product_height_cm int4 NULL,
	product_width_cm int4 NULL,
	CONSTRAINT products_pkey PRIMARY KEY (product_id)
);
