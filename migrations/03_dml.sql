INSERT INTO customers (customer_id, first_name, last_name, age, email, country, postal_code, pet_type, pet_name, pet_breed)
SELECT 
    sale_customer_id,
    customer_first_name,
    customer_last_name,
    customer_age,
    customer_email,
    customer_country,
    customer_postal_code,
    customer_pet_type,
    customer_pet_name,
    customer_pet_breed
FROM (
    SELECT 
        sale_customer_id,
        customer_first_name,
        customer_last_name,
        customer_age,
        customer_email,
        customer_country,
        customer_postal_code,
        customer_pet_type,
        customer_pet_name,
        customer_pet_breed,
        ROW_NUMBER() OVER (PARTITION BY sale_customer_id ORDER BY id) AS rn
    FROM mock_data
    WHERE sale_customer_id IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM customers c WHERE c.customer_id = mock_data.sale_customer_id
      )
) sub
WHERE rn = 1
ON CONFLICT (customer_id) DO NOTHING;

INSERT INTO sellers (seller_id, first_name, last_name, email, country, postal_code)
SELECT 
    sale_seller_id,
    seller_first_name,
    seller_last_name,
    seller_email,
    seller_country,
    seller_postal_code
FROM (
    SELECT 
        sale_seller_id,
        seller_first_name,
        seller_last_name,
        seller_email,
        seller_country,
        seller_postal_code,
        ROW_NUMBER() OVER (PARTITION BY sale_seller_id ORDER BY id) AS rn
    FROM mock_data
    WHERE sale_seller_id IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM sellers s WHERE s.seller_id = mock_data.sale_seller_id
      )
) sub
WHERE rn = 1
ON CONFLICT (seller_id) DO NOTHING;

INSERT INTO products (product_id, name, category, price, quantity, weight, color, size, brand, material, description, rating, reviews, release_date, expiry_date)
SELECT 
    sale_product_id,
    product_name,
    product_category,
    product_price,
    product_quantity,
    product_weight,
    product_color,
    product_size,
    product_brand,
    product_material,
    product_description,
    product_rating,
    product_reviews,
    product_release_date,
    product_expiry_date
FROM (
    SELECT 
        sale_product_id,
        product_name,
        product_category,
        product_price,
        product_quantity,
        product_weight,
        product_color,
        product_size,
        product_brand,
        product_material,
        product_description,
        product_rating,
        product_reviews,
        product_release_date,
        product_expiry_date,
        ROW_NUMBER() OVER (PARTITION BY sale_product_id ORDER BY id) AS rn
    FROM mock_data
    WHERE sale_product_id IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM products p WHERE p.product_id = mock_data.sale_product_id
      )
) sub
WHERE rn = 1
ON CONFLICT (product_id) DO NOTHING;

CREATE UNIQUE INDEX IF NOT EXISTS idx_stores_name_location ON stores (name, location);

INSERT INTO stores (name, location, city, state, country, phone, email)
SELECT 
    store_name,
    store_location,
    store_city,
    store_state,
    store_country,
    store_phone,
    store_email
FROM (
    SELECT 
        store_name,
        store_location,
        store_city,
        store_state,
        store_country,
        store_phone,
        store_email,
        ROW_NUMBER() OVER (PARTITION BY store_name, store_location ORDER BY id) AS rn
    FROM mock_data
    WHERE store_name IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM stores st 
          WHERE st.name = mock_data.store_name 
            AND st.location = mock_data.store_location
      )
) sub
WHERE rn = 1
ON CONFLICT (name, location) DO NOTHING;

CREATE UNIQUE INDEX IF NOT EXISTS idx_suppliers_name ON suppliers (name);

INSERT INTO suppliers (name, contact, email, phone, address, city, country)
SELECT 
    supplier_name,
    supplier_contact,
    supplier_email,
    supplier_phone,
    supplier_address,
    supplier_city,
    supplier_country
FROM (
    SELECT 
        supplier_name,
        supplier_contact,
        supplier_email,
        supplier_phone,
        supplier_address,
        supplier_city,
        supplier_country,
        ROW_NUMBER() OVER (PARTITION BY supplier_name ORDER BY id) AS rn
    FROM mock_data
    WHERE supplier_name IS NOT NULL
      AND NOT EXISTS (
          SELECT 1 FROM suppliers sup 
          WHERE sup.name = mock_data.supplier_name
      )
) sub
WHERE rn = 1
ON CONFLICT (name) DO NOTHING;

INSERT INTO sales (sale_id, customer_id, seller_id, product_id, store_id, supplier_id, sale_date, quantity, total_price)
SELECT 
    md.id,
    md.sale_customer_id,
    md.sale_seller_id,
    md.sale_product_id,
    st.store_id,
    sp.supplier_id,
    md.sale_date,
    md.sale_quantity,
    md.sale_total_price
FROM mock_data md
LEFT JOIN stores st ON st.name = md.store_name AND st.location = md.store_location
LEFT JOIN suppliers sp ON sp.name = md.supplier_name
WHERE md.id IS NOT NULL
  AND NOT EXISTS (
      SELECT 1 FROM sales s WHERE s.sale_id = md.id
  )
ON CONFLICT (sale_id) DO NOTHING;