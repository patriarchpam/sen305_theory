-- ============================================================================
-- SEN 305 Lecture (17th November, 2026): E-Commerce Database Complete Script
-- ============================================================================

-- STEP 1: Create and select the database
CREATE DATABASE IF NOT EXISTS E_commerce;
USE E_commerce;

-- STEP 2: Create Tables (DDL - Data Definition Language)

-- Table 1: Customer
CREATE TABLE Customer (
    Customer_id INT PRIMARY KEY AUTO_INCREMENT,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

-- Table 3 (Created before Orders so Orders can reference it): Products
CREATE TABLE Products (
    Product_id INT PRIMARY KEY AUTO_INCREMENT,
    Product_name VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) DEFAULT 0.00
);

-- Table 2: Orders (Links Customer and Products via Foreign Keys)
CREATE TABLE Orders (
    Order_id INT PRIMARY KEY AUTO_INCREMENT,
    Customer_id INT,
    Product_id INT,
    Quantity INT NOT NULL,
    Order_date DATE,
    Order_status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (Customer_id) REFERENCES Customer(Customer_id),
    FOREIGN KEY (Product_id) REFERENCES Products(Product_id)
);

-- Inspect tables in the database
SHOW TABLES;
DESCRIBE Customer;
DESCRIBE Products;
DESCRIBE Orders;

-- ============================================================================
-- STEP 3: Insert Records (DML - Data Manipulation Language)
-- ============================================================================

-- Task 3: Insert 3 records into Customer table
INSERT INTO Customer (Fname, Lname, phone_number, email)
VALUES
    ('Alice', 'Johnson', '08012345678', 'alice@example.com'),
    ('Bob', 'Smith', '08023456789', 'bob@example.com'),
    ('Charlie', 'Brown', '08034567890', 'charlie@example.com');

-- Task 4: Insert 5 products into Products table
INSERT INTO Products (Product_name, Price)
VALUES
    ('Laptop', 450000.00),
    ('Wireless Mouse', 15000.00),
    ('Mechanical Keyboard', 45000.00),
    ('USB-C Monitor', 180000.00),
    ('Noise Cancelling Headphones', 85000.00);

-- Task 5: Create 10 orders in Orders table
INSERT INTO Orders (Customer_id, Product_id, Quantity, Order_date, Order_status)
VALUES
    (1, 1, 1, '2026-11-15', 'Delivered'),
    (1, 2, 2, '2026-11-16', 'Shipped'),
    (2, 3, 1, '2026-11-16', 'Pending'),
    (2, 4, 2, '2026-11-17', 'Pending'),
    (3, 5, 1, '2026-11-17', 'Shipped'),
    (3, 1, 1, '2026-11-17', 'Pending'),
    (1, 3, 3, '2026-11-17', 'Delivered'),
    (2, 5, 2, '2026-11-17', 'Cancelled'),
    (3, 2, 4, '2026-11-18', 'Pending'),
    (1, 4, 1, '2026-11-18', 'Shipped');

-- ============================================================================
-- STEP 4: Basic SELECT Queries & Filtering (WHERE, AND, OR)
-- ============================================================================

-- View all customers and orders
SELECT * FROM Customer;
SELECT * FROM Products;
SELECT * FROM Orders;

-- Filter by date (from the whiteboard)
SELECT * FROM Orders
WHERE Order_date >= '2026-11-17';

-- Using AND (both conditions must be true)
SELECT * FROM Orders
WHERE Order_date >= '2026-11-17' AND Order_status = 'Pending';

-- Using OR (at least one condition must be true)
SELECT * FROM Orders
WHERE Order_status = 'Delivered' OR Order_status = 'Shipped';

-- ============================================================================
-- STEP 5: Aggregate Functions & Aliases (COUNT, SUM, AS)
-- ============================================================================

-- Count total number of orders
SELECT COUNT(Order_id) FROM Orders;

-- Sum total quantity of items ordered and rename column using AS (Alias)
SELECT SUM(Quantity) AS Total_orders FROM Orders;

-- ============================================================================
-- STEP 6: 3-Table INNER JOIN (From Whiteboard & Notes)
-- ============================================================================

SELECT 
    O.Order_id,
    O.Order_date,
    C.Fname,
    C.Lname,
    P.Product_id,
    P.Product_name
FROM Orders O
INNER JOIN Customer C ON O.Customer_id = C.Customer_id
INNER JOIN Products P ON O.Product_id = P.Product_id;

-- ============================================================================
-- STEP 7: BONUS - Assignment: 4-Table JOIN
-- ============================================================================

-- Create a 4th table: Payments (tracks payment for each order)
CREATE TABLE Payments (
    Payment_id INT PRIMARY KEY AUTO_INCREMENT,
    Order_id INT,
    Payment_method ENUM('Card', 'Bank Transfer', 'Cash') DEFAULT 'Card',
    Payment_status ENUM('Paid', 'Unpaid', 'Refunded') DEFAULT 'Paid',
    FOREIGN KEY (Order_id) REFERENCES Orders(Order_id)
);

-- Insert sample payments
INSERT INTO Payments (Order_id, Payment_method, Payment_status)
VALUES
    (1, 'Card', 'Paid'),
    (2, 'Bank Transfer', 'Paid'),
    (3, 'Card', 'Unpaid'),
    (4, 'Bank Transfer', 'Paid'),
    (5, 'Cash', 'Paid');

-- 4-Table INNER JOIN combining Orders (O), Customer (C), Products (P), and Payments (PM)
SELECT 
    O.Order_id,
    O.Order_date,
    C.Fname,
    C.Lname,
    P.Product_name,
    O.Quantity,
    PM.Payment_method,
    PM.Payment_status
FROM Orders O
INNER JOIN Customer C ON O.Customer_id = C.Customer_id
INNER JOIN Products P ON O.Product_id = P.Product_id
INNER JOIN Payments PM ON O.Order_id = PM.Order_id;

