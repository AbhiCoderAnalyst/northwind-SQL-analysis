-- The top 10 best-selling products by total quantity sold

SELECT p.product_id AS product_id, p.product_name AS name, SUM(quantity) AS total_quantity_sold, MAX(discount)*100 AS max_discount
FROM order_details o
LEFT JOIN products p
ON o.product_id = p.product_id
GROUP BY p.product_id
ORDER BY total_quantity_sold DESC
LIMIT 10;

/*
Most sold product is Camembert Pierrot and least sold is Chang.
*/


--Which customers have placed the most order
SELECT o.customer_id, contact_name as name, COUNT(DISTINCT o.order_id) AS total_orders
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
LEFT JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.customer_id, name
ORDER BY total_orders DESC;


-- The total revenue per category
SELECT c.category_id, c.category_name AS name, SUM(od.unit_price*quantity)::NUMERIC(10,3) AS revenue
FROM categories c
LEFT JOIN products p
ON c.category_id = p.category_id
LEFT JOIN order_details od
ON od.product_id = p.product_id
GROUP BY c.category_id
ORDER BY revenue DESC;
/*
Beverages are the most selling category(revenue lmost double of the least category) and Grains/Cereals are least
sold category. 
*/


-- Which country do most customers come from
SELECT country, COUNT(customer_id) as customer_count
FROM customers
GROUP BY country
ORDER BY customer_count DESC
LIMIT 1;
-- USA has your highest amount of customers



-- The shipper that handled the most orders
SELECT s.shipper_id, s.company_name
FROM shippers s
LEFT JOIN orders o
ON s.shipper_id = o.ship_via
LEFT JOIN order_details od
ON o.order_id = od.order_id
GROUP BY s.shipper_id
ORDER BY COUNT(DISTINCT o.order_id) DESC;

/*
United handled most orders and DHL did the least
*/






