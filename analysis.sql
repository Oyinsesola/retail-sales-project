
/* 1. PRODUCT ANALYSIS*/

-- Top 5 products by revenue + quantity sold
SELECT 
    p.product_name,
    SUM(oi.quantity) AS quantity_sold,
    SUM(p.price * oi.quantity) AS revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC
LIMIT 5;

-- Total revenue of the store
SELECT 
    SUM(p.price * oi.quantity) AS revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id;


/* 2. CATEGORY ANALYSIS*/

-- Revenue by product category
SELECT 
    c.category_name,
    SUM(p.price * oi.quantity) AS revenue
FROM order_items oi
JOIN products p 
    ON oi.product_id = p.product_id
JOIN categories c 
    ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY revenue DESC;


/* 3. CUSTOMER ANALYSIS*/

-- Top customers by total spending
SELECT 
    c.customer_name,
    SUM(p.price * oi.quantity) AS total_spent
FROM customers c
JOIN orders o 
    ON c.customer_id = o.customer_id
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC;


/* 4. TIME ANALYSIS*/

-- Monthly order count
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(*) AS number_of_orders
FROM orders o
GROUP BY month
ORDER BY month;

-- Monthly revenue
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    SUM(p.price * oi.quantity) AS revenue
FROM orders o
JOIN order_items oi 
    ON o.order_id = oi.order_id
JOIN products p 
    ON oi.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- Month-over-month revenue change
WITH monthly_revenue AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS month,
        SUM(p.price * oi.quantity) AS revenue
    FROM orders o
    JOIN order_items oi 
        ON o.order_id = oi.order_id
    JOIN products p 
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
)

SELECT 
    month,
    revenue,
    LAG(revenue) OVER (ORDER BY month) AS previous_month_revenue,
    revenue - LAG(revenue) OVER (ORDER BY month) AS revenue_change
FROM monthly_revenue;

