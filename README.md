# northwind-SQL-analysis

A SQL analysis project built on the Northwind sample database — a small trading company's sales data covering customers, orders, products, employees, and shippers.

I wrote 15 queries to answer real business questions about the data, starting simple and working up to window functions and CTEs. Built and tested in PostgreSQL / pgAdmin.

Data source: [Northwind for Postgres](https://github.com/pthom/northwind_psql)

## What I found

- 4 out of 9 employees handled 510 of 830 orders (61.44%) — order volume is pretty unevenly split across the sales team.
- Camembert Pierrot was the best-selling product by quantity; Chang was near the bottom.
- Beverages brought in almost double the revenue of Grains/Cereals, the lowest category.
- USA has the most customers of any country in the dataset.
- Found products in the catalog that have never actually been ordered (dead stock, basically).
- Used a CTE to pull out customers with more than 5 orders, then calculated their lifetime spend.
- Ranked products by revenue *within* their own category, not just overall — so every category has its own top performer, not just the biggest sellers company-wide.

## SQL concepts used

- Multi-table joins across orders, order_details, customers, products, categories, employees, shippers
- GROUP BY / HAVING, COUNT(DISTINCT ...)
- Window functions — RANK(), ROW_NUMBER() with PARTITION BY
- CTEs for multi-step aggregation
- LEFT JOIN + IS NULL to find missing/unmatched records
- NUMERIC casting for clean currency output

Also hit a real bug a couple times — joining to order_details duplicates each order once per line item, which quietly breaks a plain COUNT(order_id). Fixed by switching to COUNT(DISTINCT order_id) wherever that join was in play.

## A few queries

**Top product per category (window function):**
```sql
SELECT 
    p.category_id, 
    p.product_id,
    p.product_name,
    SUM(od.unit_price * od.quantity) AS revenue,
    RANK() OVER(PARTITION BY p.category_id ORDER BY SUM(od.unit_price * od.quantity) DESC) AS ranking
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
GROUP BY p.category_id, p.product_id, p.product_name
ORDER BY p.category_id, ranking;
```

**Repeat customers + lifetime spend (CTE):**
```sql
WITH T AS (
    SELECT o.customer_id, c.contact_name
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.contact_name 
    HAVING COUNT(DISTINCT o.order_id) > 5
)
SELECT T.customer_id, T.contact_name, 
       SUM(od.unit_price * od.quantity)::NUMERIC(10,2) AS total_spent
FROM T 
LEFT JOIN orders o ON T.customer_id = o.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
GROUP BY T.customer_id, T.contact_name
ORDER BY total_spent DESC;
```

**Products never ordered:**
```sql
SELECT p.product_id, p.product_name
FROM products p
LEFT JOIN order_details od ON p.product_id = od.product_id
WHERE od.order_id IS NULL;
```

## Files

```
northwind-sql-analysis/
├── README.md
├── setup.sql          -- schema + data
└── queries/            -- all 15 queries, grouped by phase
```

## Tools

PostgreSQL
