--Rank products within each category by total revenue

SELECT category_id,product_name, SUM(od.unit_price * od.quantity)::NUMERIC(9,2) AS revenue,
RANK() OVER(PARTITION BY category_id ORDER BY SUM(od.unit_price * od.quantity) DESC) AS ranking
FROM products p
RIGHT JOIN order_details od
ON p.product_id = od.product_id
GROUP BY category_id, p.product_id, product_name
ORDER BY category_id, ranking;

--For each customer, finding their most recent order date using a window function instead of GROUP BY/MAX

SELECT customer_id, order_date, most_recent_order
FROM
(SELECT customer_id, order_date,
ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_date DESC) AS most_recent_order
FROM orders)
WHERE most_recent_order = 1;


--calculating total revenue per order first, then in an outer query find the average order value per country.
WITH T AS(
SELECT order_id, SUM(unit_price*quantity) as revenue_per_order
FROM order_details 
GROUP BY order_id
)
SELECT AVG(revenue_per_order)::NUMERIC(9,3) as avg_order_value_per_country, ship_country
FROM T 
LEFT JOIN orders o
ON T.order_id = o.order_id
GROUP BY o.ship_country
ORDER BY avg_order_value_per_country;

--find customers with more than 5 orders, then show their total lifetime spend
SELECT o.customer_id, SUM(od.unit_price*od.quantity)::NUMERIC(9,3) as total_spent, contact_name
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
LEFT JOIN order_details od
ON o.order_id = od.order_id
GROUP BY o.customer_id, contact_name
HAVING COUNT(DISTINCT o.order_id) > 5
ORDER BY total_spent DESC;

--with CTE 
WITH T AS(
SELECT o.customer_id, contact_name
FROM orders o
LEFT JOIN customers c
ON o.customer_id = c.customer_id
GROUP BY o.customer_id, contact_name 
HAVING COUNT(DISTINCT o.order_id) > 5
)
SELECT T.customer_id, contact_name, SUM(od.unit_price*od.quantity)::NUMERIC(9,3) as total_spent
FROM T 
LEFT JOIN orders o
ON T.customer_id = o.customer_id
LEFT JOIN order_details od
ON o.order_id = od.order_id
GROUP BY T.customer_id, contact_name
ORDER BY total_spent DESC;









