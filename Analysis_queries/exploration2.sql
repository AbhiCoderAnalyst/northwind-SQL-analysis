--COUNT of customers, orders, products etc

SELECT COUNT(customer_id) FROM customers; --91 customers
SELECT COUNT(order_id) FROM orders;  --830 orders
SELECT COUNT(product_id) FROM products; --77 products


-- earliest and latest order dates
SELECT MAX(order_date) AS latest_order_date, MIN(order_date) AS earliest_order_date 
FROM orders;
/* 
 Two years is the difference between earlist(1996) and latest(1998) order.
*/


-- numbers of orders per employee 
SELECT COUNT(order_id) as orders_per_emp, o.employee_id, CONCAT(first_name, ' ',last_name) as emp_name
FROM orders o
LEFT JOIN 
employees e
ON o.employee_id = e.employee_id
GROUP BY o.employee_id, e.first_name, e.last_name
ORDER BY COUNT(order_id) DESC;

/*  
 From the data we can see that employees with emp_id (1,3,4,8) have 510/830 = 61.44 % of the total order volume(which is 830) 
*/

