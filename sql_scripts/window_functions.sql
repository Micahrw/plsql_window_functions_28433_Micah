-- =====================================================
-- CATEGORY 1: RANKING FUNCTIONS
-- =====================================================
-- Functions: ROW_NUMBER(), RANK(), DENSE_RANK(), PERCENT_RANK()
-- Use Case: Top N customers or products by revenue

-- Query 1.1: Rank customers by total spending
-- Business Question: Who are our top spending customers?

SELECT 
    customer_id,
    first_name || ' ' || last_name AS customer_name,
    city,
    total_spent,
    ROW_NUMBER() OVER (ORDER BY total_spent DESC) AS row_num,
    RANK() OVER (ORDER BY total_spent DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY total_spent DESC) AS dense_rank,
    ROUND(PERCENT_RANK() OVER (ORDER BY total_spent DESC) * 100, 2) AS percent_rank
FROM (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city,
        NVL(SUM(o.total_amount), 0) AS total_spent
    FROM Customers c
    LEFT JOIN Orders o ON c.customer_id = o.customer_id
    WHERE o.order_status = 'completed' OR o.order_status IS NULL
    GROUP BY c.customer_id, c.first_name, c.last_name, c.city
)
ORDER BY total_spent DESC;

-- INTERPRETATION:
-- ROW_NUMBER: Gives unique sequential number (1, 2, 3, 4...) even for ties
-- RANK: Gives same rank for ties, then skips numbers (1, 2, 2, 4...)
-- DENSE_RANK: Gives same rank for ties, NO skipping (1, 2, 2, 3...)
-- PERCENT_RANK: Shows percentile position (0% = lowest, 100% = highest)
-- This helps identify VIP customers who spend the most and should get premium treatment.


-- Query 1.2: Top 5 restaurants by revenue in EACH city
-- Business Question: Which restaurants are market leaders in each 

-- =====================================================
-- CATEGORY 2: AGGREGATE WINDOW FUNCTIONS
-- =====================================================
-- Functions: SUM(), AVG(), MIN(), MAX() with ROWS and RANGE
-- Use Case: Running totals, moving averages, trends

-- Query 2.1: Running total of monthly revenue (Cumulative Sum)
-- Business Question: How is our revenue accumulating over time?

SELECT 
    TO_CHAR(order_date, 'YYYY-MM') AS order_month,
    SUM(total_amount) AS monthly_revenue,
    
    -- Running Total (adds up from September to current month)
    SUM(SUM(total_amount)) OVER (
        ORDER BY TO_CHAR(order_date, 'YYYY-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total,
    
    -- Cumulative Average (average from start to current month)
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY TO_CHAR(order_date, 'YYYY-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS cumulative_avg,
    
    -- 3-Month Moving Average (current + 2 months before)
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY TO_CHAR(order_date, 'YYYY-MM')
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3months,
    
    -- Maximum Revenue So Far
    MAX(SUM(total_amount)) OVER (
        ORDER BY TO_CHAR(order_date, 'YYYY-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS max_so_far,
    
    -- Minimum Revenue So Far
    MIN(SUM(total_amount)) OVER (
        ORDER BY TO_CHAR(order_date, 'YYYY-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS min_so_far,
    
    -- Grand Total (all months combined, shown on every row)
    SUM(SUM(total_amount)) OVER () AS grand_total

FROM Orders
WHERE order_status = 'completed'
GROUP BY TO_CHAR(order_date, 'YYYY-MM')
ORDER BY order_month;
-- INTERPRETATION:
-- ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW: From start to current row
-- Running total shows cumulative revenue growth over time.
-- Cumulative average helps smooth out monthly variations.
-- This reveals if revenue is growing, stable, or declining over the months.

-- =====================================================
-- CATEGORY 3: NAVIGATION FUNCTIONS
-- =====================================================
-- Query 6: See Customer's Previous Order Date (Even Simpler)
-- When did this customer order before?

SELECT 
    c.first_name || ' ' || c.last_name AS customer_name,
    o.order_date AS current_order_date,
    o.total_amount AS current_order_amount,
    -- Shows when this customer ordered BEFORE this order
    LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS previous_order_date,
    -- How many days between orders?
    o.order_date - LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS days_between_orders
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
WHERE o.order_status = 'completed'
ORDER BY c.customer_id, o.order_date;

-- SIMPLE INTERPRETATION:
-- For each order, you can see: "When did this person last order?"
-- And: "How many days ago was that?"
-- Helps identify: Are they ordering more frequently or less?


-- =====================================================
-- CATEGORY 4: DISTRIBUTION FUNCTIONS (Simplified)
-- =====================================================
-- Think of this like: "Dividing students into groups"

-- Query 7: Divide Customers into 4 Groups (Quartiles)
-- This is like dividing class into 4 teams of equal size

SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    -- NTILE(4) divides all customers into 4 equal groups
    NTILE(4) OVER (ORDER BY SUM(o.total_amount) DESC) AS customer_group,
    -- Give each group a name
    CASE 
        WHEN NTILE(4) OVER (ORDER BY SUM(o.total_amount) DESC) = 1 THEN 'VIP Customers'
        WHEN NTILE(4) OVER (ORDER BY SUM(o.total_amount) DESC) = 2 THEN 'Good Customers'
        WHEN NTILE(4) OVER (ORDER BY SUM(o.total_amount) DESC) = 3 THEN 'Regular Customers'
        ELSE 'Need Attention'
    END AS customer_category
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_status = 'completed'
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- SIMPLE INTERPRETATION:
-- NTILE(4) splits customers into 4 equal-sized groups
-- Group 1 = Top 25% (best customers)
-- Group 2 = Next 25%
-- Group 3 = Next 25%
-- Group 4 = Bottom 25% (need re-engagement)
-- It's automatic grouping - no complicated math needed!