--Which employees have generated more than $50,000 in total sales

SELECT o.employee_id, CONCAT(first_name,'  ', last_name) as name, SUM(unit_price*quantity)::NUMERIC(10,3) AS revenue
FROM orders o
LEFT JOIN order_details od
ON o.order_id = od.order_id
LEFT JOIN employees e
ON o.employee_id = e.employee_id
GROUP BY o.employee_id, first_name, last_name
HAVING SUM(unit_price*quantity) > 50000;


--Which products have never been ordered

SELECT  p.product_id, p.product_name
FROM products p
LEFT JOIN order_details od
ON p.product_id = od.product_id
WHERE od.order_id IS NULL
GROUP BY p.product_id;


--What's the monthly order count trend across the whole dataset
SELECT COUNT(order_id) as total_orders, EXTRACT('month' FROM order_date) as month, EXTRACT('year' FROM order_date) as year
FROM orders
GROUP BY year, month
ORDER BY year, month;




