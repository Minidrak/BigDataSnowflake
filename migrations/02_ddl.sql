CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    age INT,
    email VARCHAR,
    country VARCHAR,
    postal_code VARCHAR,
    pet_type VARCHAR,
    pet_name VARCHAR,
    pet_breed VARCHAR
);

CREATE TABLE sellers (
    seller_id INT PRIMARY KEY,
    first_name VARCHAR,
    last_name VARCHAR,
    email VARCHAR,
    country VARCHAR,
    postal_code VARCHAR
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    name VARCHAR,
    category VARCHAR,
    price DECIMAL,
    quantity INT,
    weight DECIMAL,
    color VARCHAR,
    size VARCHAR,
    brand VARCHAR,
    material VARCHAR,
    description TEXT,
    rating DECIMAL,
    reviews INT,
    release_date DATE,
    expiry_date DATE
);

CREATE TABLE stores (
    store_id SERIAL PRIMARY KEY,
    name VARCHAR,
    location VARCHAR,
    city VARCHAR,
    state VARCHAR,
    country VARCHAR,
    phone VARCHAR,
    email VARCHAR
);

CREATE TABLE suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR,
    contact VARCHAR,
    email VARCHAR,
    phone VARCHAR,
    address VARCHAR,
    city VARCHAR,
    country VARCHAR
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    customer_id INT,
    seller_id INT,
    product_id INT,
    store_id INT,
    supplier_id INT,
    sale_date DATE,
    quantity INT,
    total_price DECIMAL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (store_id) REFERENCES stores(store_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);