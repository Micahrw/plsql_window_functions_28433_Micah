CREATE TABLE Customers (
    customer_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE NOT NULL,
    phone VARCHAR2(20),
    city VARCHAR2(50) NOT NULL,
    registration_date DATE DEFAULT SYSDATE
);

-- =====================================================
-- TABLE 2: RESTAURANTS
-- =====================================================
CREATE TABLE Restaurants (
    restaurant_id NUMBER PRIMARY KEY,
    restaurant_name VARCHAR2(100) NOT NULL,
    cuisine_type VARCHAR2(50) NOT NULL,
    city VARCHAR2(50) NOT NULL,
    rating NUMBER(2,1) CHECK (rating >= 0 AND rating <= 5),
    registration_date DATE DEFAULT SYSDATE
);

-- =====================================================
-- TABLE 3: ORDERS
-- =====================================================
CREATE TABLE Orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    restaurant_id NUMBER NOT NULL,
    order_date DATE NOT NULL,
    total_amount NUMBER(10,2) NOT NULL,
    order_status VARCHAR2(20) CHECK (order_status IN ('completed', 'cancelled', 'pending')),
    delivery_time_minutes NUMBER,
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    CONSTRAINT fk_restaurant FOREIGN KEY (restaurant_id) REFERENCES Restaurants(restaurant_id)
);

-- =====================================================
-- SAMPLE DATA: CUSTOMERS
-- =====================================================
INSERT INTO Customers VALUES (1, 'Jean', 'Uwase', 'jean.uwase@email.com', '0788123456', 'Kigali', TO_DATE('2024-01-15', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (2, 'Marie', 'Mukamana', 'marie.m@email.com', '0788234567', 'Kigali', TO_DATE('2024-02-20', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (3, 'Patrick', 'Niyomwungeri', 'patrick.n@email.com', '0788345678', 'Huye', TO_DATE('2024-03-10', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (4, 'Grace', 'Iradukunda', 'grace.i@email.com', '0788456789', 'Kigali', TO_DATE('2024-03-25', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (5, 'Emmanuel', 'Habimana', 'emmanuel.h@email.com', '0788567890', 'Musanze', TO_DATE('2024-04-05', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (6, 'Aline', 'Uwera', 'aline.u@email.com', '0788678901', 'Huye', TO_DATE('2024-04-15', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (7, 'David', 'Mugisha', 'david.m@email.com', '0788789012', 'Kigali', TO_DATE('2024-05-01', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (8, 'Claudine', 'Umutoniwase', 'claudine.u@email.com', '0788890123', 'Musanze', TO_DATE('2024-05-20', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (9, 'Eric', 'Nsabimana', 'eric.n@email.com', '0788901234', 'Kigali', TO_DATE('2024-06-10', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (10, 'Bella', 'Ingabire', 'bella.i@email.com', '0789012345', 'Huye', TO_DATE('2024-07-01', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (11, 'Samuel', 'Ndahiro', 'samuel.n@email.com', '0789123456', 'Kigali', TO_DATE('2024-07-15', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (12, 'Josephine', 'Mukeshimana', 'josephine.m@email.com', '0789234567', 'Musanze', TO_DATE('2024-08-01', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (13, 'Isaac', 'Uwizeye', 'isaac.u@email.com', '0789345678', 'Kigali', TO_DATE('2024-08-20', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (14, 'Divine', 'Mukamazimpaka', 'divine.m@email.com', '0789456789', 'Huye', TO_DATE('2024-09-05', 'YYYY-MM-DD'));
INSERT INTO Customers VALUES (15, 'James', 'Nkurunziza', 'james.n@email.com', '0789567890', 'Kigali', TO_DATE('2024-10-01', 'YYYY-MM-DD'));

-- =====================================================
-- SAMPLE DATA: RESTAURANTS
-- =====================================================
INSERT INTO Restaurants VALUES (101, 'Heaven Restaurant', 'International', 'Kigali', 4.5, TO_DATE('2023-01-10', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (102, 'Repub Lounge', 'American', 'Kigali', 4.2, TO_DATE('2023-02-15', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (103, 'Poivre Noir', 'French', 'Kigali', 4.8, TO_DATE('2023-03-20', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (104, 'Khana Khazana', 'Indian', 'Kigali', 4.3, TO_DATE('2023-04-05', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (105, 'Sole Luna', 'Italian', 'Kigali', 4.6, TO_DATE('2023-05-10', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (106, 'Inzora Rooftop', 'Local', 'Kigali', 4.4, TO_DATE('2023-06-01', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (107, 'Butare Brunch', 'Breakfast', 'Huye', 4.0, TO_DATE('2023-07-12', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (108, 'Huye Kitchen', 'Local', 'Huye', 3.9, TO_DATE('2023-08-20', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (109, 'The Hut', 'BBQ', 'Huye', 4.1, TO_DATE('2023-09-05', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (110, 'Volcano View', 'International', 'Musanze', 4.3, TO_DATE('2023-10-15', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (111, 'Gorilla Grill', 'BBQ', 'Musanze', 4.2, TO_DATE('2023-11-01', 'YYYY-MM-DD'));
INSERT INTO Restaurants VALUES (112, 'Mountain Spice', 'Asian', 'Musanze', 3.8, TO_DATE('2023-12-10', 'YYYY-MM-DD'));

-- =====================================================
-- SAMPLE DATA: ORDERS
-- =====================================================
-- Inserting 50+ orders spanning multiple months for analysis
-- Format: order_id, customer_id, restaurant_id, order_date, total_amount, status, delivery_time

-- September 2024 Orders
INSERT INTO Orders VALUES (1001, 1, 101, TO_DATE('2024-09-05', 'YYYY-MM-DD'), 25000, 'completed', 30);
INSERT INTO Orders VALUES (1002, 2, 102, TO_DATE('2024-09-08', 'YYYY-MM-DD'), 18000, 'completed', 25);
INSERT INTO Orders VALUES (1003, 3, 107, TO_DATE('2024-09-10', 'YYYY-MM-DD'), 12000, 'completed', 35);
INSERT INTO Orders VALUES (1004, 4, 103, TO_DATE('2024-09-12', 'YYYY-MM-DD'), 45000, 'completed', 40);
INSERT INTO Orders VALUES (1005, 1, 104, TO_DATE('2024-09-15', 'YYYY-MM-DD'), 22000, 'completed', 28);
INSERT INTO Orders VALUES (1006, 5, 110, TO_DATE('2024-09-18', 'YYYY-MM-DD'), 30000, 'completed', 45);
INSERT INTO Orders VALUES (1007, 2, 101, TO_DATE('2024-09-20', 'YYYY-MM-DD'), 27000, 'completed', 32);
INSERT INTO Orders VALUES (1008, 6, 108, TO_DATE('2024-09-22', 'YYYY-MM-DD'), 15000, 'completed', 30);

-- October 2024 Orders
INSERT INTO Orders VALUES (1009, 7, 105, TO_DATE('2024-10-02', 'YYYY-MM-DD'), 35000, 'completed', 35);
INSERT INTO Orders VALUES (1010, 8, 111, TO_DATE('2024-10-05', 'YYYY-MM-DD'), 28000, 'completed', 42);
INSERT INTO Orders VALUES (1011, 1, 101, TO_DATE('2024-10-08', 'YYYY-MM-DD'), 26000, 'completed', 29);
INSERT INTO Orders VALUES (1012, 9, 106, TO_DATE('2024-10-10', 'YYYY-MM-DD'), 32000, 'completed', 33);
INSERT INTO Orders VALUES (1013, 3, 109, TO_DATE('2024-10-12', 'YYYY-MM-DD'), 19000, 'completed', 38);
INSERT INTO Orders VALUES (1014, 4, 103, TO_DATE('2024-10-15', 'YYYY-MM-DD'), 48000, 'completed', 41);
INSERT INTO Orders VALUES (1015, 10, 107, TO_DATE('2024-10-18', 'YYYY-MM-DD'), 14000, 'completed', 36);
INSERT INTO Orders VALUES (1016, 2, 102, TO_DATE('2024-10-20', 'YYYY-MM-DD'), 20000, 'completed', 27);
INSERT INTO Orders VALUES (1017, 5, 110, TO_DATE('2024-10-22', 'YYYY-MM-DD'), 33000, 'completed', 44);
INSERT INTO Orders VALUES (1018, 11, 101, TO_DATE('2024-10-25', 'YYYY-MM-DD'), 29000, 'completed', 31);

-- November 2024 Orders
INSERT INTO Orders VALUES (1019, 7, 105, TO_DATE('2024-11-03', 'YYYY-MM-DD'), 38000, 'completed', 36);
INSERT INTO Orders VALUES (1020, 1, 104, TO_DATE('2024-11-05', 'YYYY-MM-DD'), 24000, 'completed', 30);
INSERT INTO Orders VALUES (1021, 12, 112, TO_DATE('2024-11-08', 'YYYY-MM-DD'), 21000, 'completed', 50);
INSERT INTO Orders VALUES (1022, 4, 103, TO_DATE('2024-11-10', 'YYYY-MM-DD'), 52000, 'completed', 43);
INSERT INTO Orders VALUES (1023, 9, 106, TO_DATE('2024-11-12', 'YYYY-MM-DD'), 31000, 'completed', 34);
INSERT INTO Orders VALUES (1024, 13, 101, TO_DATE('2024-11-15', 'YYYY-MM-DD'), 28000, 'completed', 32);
INSERT INTO Orders VALUES (1025, 6, 108, TO_DATE('2024-11-18', 'YYYY-MM-DD'), 16000, 'completed', 31);
INSERT INTO Orders VALUES (1026, 8, 111, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 29000, 'completed', 43);
INSERT INTO Orders VALUES (1027, 2, 102, TO_DATE('2024-11-22', 'YYYY-MM-DD'), 19000, 'completed', 26);
INSERT INTO Orders VALUES (1028, 14, 109, TO_DATE('2024-11-25', 'YYYY-MM-DD'), 17000, 'completed', 37);

-- December 2024 Orders
INSERT INTO Orders VALUES (1029, 7, 105, TO_DATE('2024-12-02', 'YYYY-MM-DD'), 41000, 'completed', 37);
INSERT INTO Orders VALUES (1030, 1, 101, TO_DATE('2024-12-05', 'YYYY-MM-DD'), 27000, 'completed', 30);
INSERT INTO Orders VALUES (1031, 15, 106, TO_DATE('2024-12-08', 'YYYY-MM-DD'), 34000, 'completed', 35);
INSERT INTO Orders VALUES (1032, 4, 103, TO_DATE('2024-12-10', 'YYYY-MM-DD'), 55000, 'completed', 42);
INSERT INTO Orders VALUES (1033, 9, 106, TO_DATE('2024-12-12', 'YYYY-MM-DD'), 33000, 'completed', 34);
INSERT INTO Orders VALUES (1034, 3, 109, TO_DATE('2024-12-15', 'YYYY-MM-DD'), 20000, 'completed', 39);
INSERT INTO Orders VALUES (1035, 11, 102, TO_DATE('2024-12-18', 'YYYY-MM-DD'), 22000, 'completed', 28);
INSERT INTO Orders VALUES (1036, 5, 110, TO_DATE('2024-12-20', 'YYYY-MM-DD'), 35000, 'completed', 46);
INSERT INTO Orders VALUES (1037, 12, 111, TO_DATE('2024-12-22', 'YYYY-MM-DD'), 30000, 'completed', 44);
INSERT INTO Orders VALUES (1038, 2, 102, TO_DATE('2024-12-24', 'YYYY-MM-DD'), 21000, 'completed', 27);

-- January 2025 Orders
INSERT INTO Orders VALUES (1039, 7, 105, TO_DATE('2025-01-03', 'YYYY-MM-DD'), 42000, 'completed', 38);
INSERT INTO Orders VALUES (1040, 1, 101, TO_DATE('2025-01-05', 'YYYY-MM-DD'), 28000, 'completed', 31);
INSERT INTO Orders VALUES (1041, 13, 104, TO_DATE('2025-01-08', 'YYYY-MM-DD'), 25000, 'completed', 29);
INSERT INTO Orders VALUES (1042, 4, 103, TO_DATE('2025-01-10', 'YYYY-MM-DD'), 58000, 'completed', 44);
INSERT INTO Orders VALUES (1043, 9, 106, TO_DATE('2025-01-12', 'YYYY-MM-DD'), 35000, 'completed', 35);
INSERT INTO Orders VALUES (1044, 14, 107, TO_DATE('2025-01-15', 'YYYY-MM-DD'), 13000, 'completed', 33);
INSERT INTO Orders VALUES (1045, 6, 108, TO_DATE('2025-01-18', 'YYYY-MM-DD'), 17000, 'completed', 32);
INSERT INTO Orders VALUES (1046, 15, 101, TO_DATE('2025-01-20', 'YYYY-MM-DD'), 30000, 'completed', 32);
INSERT INTO Orders VALUES (1047, 8, 112, TO_DATE('2025-01-22', 'YYYY-MM-DD'), 23000, 'completed', 51);
INSERT INTO Orders VALUES (1048, 11, 102, TO_DATE('2025-01-25', 'YYYY-MM-DD'), 24000, 'completed', 29);

-- Additional orders with cancelled and pending status
INSERT INTO Orders VALUES (1049, 2, 101, TO_DATE('2025-01-28', 'YYYY-MM-DD'), 26000, 'cancelled', NULL);
INSERT INTO Orders VALUES (1050, 3, 107, TO_DATE('2025-01-29', 'YYYY-MM-DD'), 15000, 'pending', NULL);
INSERT INTO Orders VALUES (1051, 10, 109, TO_DATE('2025-01-30', 'YYYY-MM-DD'), 18000, 'pending', NULL);

-- Commit all changes
COMMIT;