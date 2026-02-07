-- =====================================================
-- JOIN 1: INNER JOIN
-- =====================================================
-- Purpose: Retrieve all completed orders with customer and restaurant details
-- Business Use: View successful transactions to analyze purchasing patterns

SELECT 
    o.order_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    c.city AS customer_city,
    r.restaurant_name,
    r.cuisine_type,
    o.order_date,
    o.total_amount,
    o.delivery_time_minutes
FROM Orders o
INNER JOIN Customers c ON o.customer_id = c.customer_id
INNER JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.order_status = 'completed'
ORDER BY o.order_date DESC;

-- BUSINESS INTERPRETATION:
-- This query shows all successful orders with complete customer and restaurant information.
-- INNER JOIN only returns records where there's a match in ALL tables (Orders, Customers, Restaurants).
-- This helps us understand which customers are ordering from which restaurants and track successful transactions.
-- We can identify popular restaurant-customer combinations and analyze delivery performance.


-- =====================================================
-- JOIN 2: LEFT JOIN (LEFT OUTER JOIN)
-- =====================================================
-- Purpose: Find customers who have NEVER placed an order
-- Business Use: Identify inactive customers for re-engagement campaigns

SELECT 
    c.customer_id,
    c.first_name || ' ' || c.last_name AS customer_name,
    COUNT(o.order_id) AS Orders
FROM Customers c LEFT JOIN Orders o ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.first_name || ' ' || c.last_name
HAVING COUNT(o.order_id) = 0;
    
-- BUSINESS INTERPRETATION:
-- LEFT JOIN returns ALL customers, even those without orders (NULLs in Orders table).
-- By filtering for COUNT = 0, we identify customers who registered but never ordered.
-- These are potential customers we're losing - they signed up but aren't engaged.
-- Marketing can target these customers with welcome promotions or special discounts to activate them.


-- =====================================================
-- JOIN 3: RIGHT JOIN (RIGHT OUTER JOIN)
-- =====================================================
-- Purpose: Find restaurants that have NO orders (no sales activity)
-- Business Use: Identify underperforming restaurants that may need support or removal

SELECT 
    r.restaurant_id,
    r.restaurant_name,
    COUNT(o.order_id) AS Orders
FROM Orders o RIGHT JOIN Restaurants r ON o.restaurant_id = r.restaurant_id group by r.restaurant_id, r.restaurant_name 
HAVING COUNT(o.order_id) = 0; 

-- BUSINESS INTERPRETATION:
-- RIGHT JOIN returns ALL restaurants, even those without any orders (NULLs in Orders table).
-- Restaurants with zero orders indicate potential issues: poor visibility, bad ratings, or unpopular cuisine.
-- QuickBite management can investigate why these restaurants aren't getting orders.
-- Decision: Either provide marketing support to boost these restaurants or remove them from the platform.


-- =====================================================
-- JOIN 4: FULL OUTER JOIN
-- =====================================================
-- Purpose: Complete view of customers and orders, including unmatched records
-- Business Use: Data quality check - find orphaned records or mismatches

SELECT 
    c.customer_id,
    c.first_name ||' '|| c.last_name AS CUST_NAMES,
    r.restaurant_id,
    r.restaurant_name,
    o.order_id
FROM Customers c 
FULL OUTER JOIN Orders o ON c.customer_id = o.customer_id
FULL OUTER JOIN Restaurants r ON o.restaurant_id = r.restaurant_id
ORDER BY customer_id;

-- BUSINESS INTERPRETATION:
-- FULL OUTER JOIN returns ALL records from both tables, matched and unmatched.
-- This helps identify: (1) Customers who never ordered, (2) Orphaned orders (data quality issues).
-- In a healthy database, we shouldn't have orders without customers (data integrity problem).
-- This query is useful for data auditing and ensuring referential integrity is maintained.


-- =====================================================
-- JOIN 5: SELF JOIN
-- =====================================================
-- Purpose: Find customers from the SAME CITY who made orders on the SAME DAY
-- Business Use: Identify location-based ordering patterns and potential delivery route optimization

SELECT 
    c1.customer_id AS customer1_id,
    c1.first_name || ' ' || c1.last_name AS customer1_name,
    c2.customer_id AS customer2_id,
    c2.first_name || ' ' || c2.last_name AS customer2_name,
    c1.city,
    o1.order_date,
    o1.order_id AS order1_id,
    o2.order_id AS order2_id,
    r1.restaurant_name AS restaurant1,
    r2.restaurant_name AS restaurant2
FROM Orders o1
JOIN Customers c1 ON o1.customer_id = c1.customer_id
JOIN Restaurants r1 ON o1.restaurant_id = r1.restaurant_id
JOIN Orders o2 ON o1.order_date = o2.order_date AND o1.order_id < o2.order_id
JOIN Customers c2 ON o2.customer_id = c2.customer_id
JOIN Restaurants r2 ON o2.restaurant_id = r2.restaurant_id
WHERE c1.city = c2.city
ORDER BY o1.order_date DESC, c1.city;

-- BUSINESS INTERPRETATION:
-- SELF JOIN compares the Orders table with itself to find orders placed on the same day in the same city.
-- This reveals clustering of orders by location and time, which is valuable for delivery optimization.
-- If multiple customers in Kigali order on the same day, we can batch deliveries for efficiency.
-- This helps reduce delivery costs, optimize driver routes, and improve delivery time estimates.
