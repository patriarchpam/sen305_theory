# SEN 305 Assignment

**Date:** 17th November, 2026

---

## Question 1: Explain Cookies, Authentication, Authorization, and Session

### 1. Authentication ("Who are you?")
**Definition:**  
Authentication is the security process of verifying the identity of a user, device, or system attempting to access an application or database. It ensures that the person logging in is genuinely who they claim to be.

* **How It Works:** A user provides credentials—such as an email/username and password, a One-Time Password (OTP), or biometric data (fingerprint/Face ID)—and the server checks those credentials against records stored in the database (e.g., the `Customer` table).
* **E-Commerce Example:** When a customer enters `alice@example.com` and their password on the login page, the system verifies the credentials before allowing them into their account.
* **Common Methods:**
  * **Single-Factor Authentication (SFA):** Username + Password.
  * **Multi-Factor Authentication (MFA / 2FA):** Password + SMS/Authenticator code or biometrics.

---

### 2. Authorization ("What are you allowed to do?")
**Definition:**  
Authorization is the security process of determining what resources, data, or actions an **already authenticated** user is permitted to access or perform.

* **How It Works:** Once Authentication confirms *who* the user is, Authorization checks the user's assigned role or permissions (e.g., `Customer`, `Vendor`, or `Admin`) before granting or denying access to specific routes, database tables, or operations.
* **E-Commerce Example:**
  * A logged-in **Customer** is authorized to view their own orders (`SELECT`) and place a new order (`INSERT`), but is **not** authorized to delete products from the store (`DELETE FROM Products`).
  * An **Administrator** is authorized to add new products, update prices, and view all customer orders.

| Feature | Authentication | Authorization |
| :--- | :--- | :--- |
| **Core Question** | *"Who are you?"* | *"What are you allowed to do?"* |
| **Order of Execution** | Happens **first** (at login). | Happens **after** successful authentication. |
| **User Visibility** | Visible to the user (login form, 2FA prompt). | Enforced behind the scenes by server access rules. |

---

### 3. Session
**Definition:**  
A **Session** is a temporary, stateful record stored on the **server** that tracks an authenticated user's interactions and state across multiple HTTP requests during a visit to a website.

* **Why It Is Needed:** HTTP is a *stateless* protocol, meaning the server forgets who the user is after every single page load unless a session is maintained.
* **How It Works:**
  1. The user logs in successfully (Authentication).
  2. The server creates a **Session** in server memory or a database and generates a unique random identifier called a **`Session_ID`**.
  3. The server sends the `Session_ID` to the user's browser (usually inside a Cookie).
  4. On every new page click (e.g., viewing cart, checking out), the browser sends back the `Session_ID` so the server knows which customer is making the request without asking them to log in again.
  5. When the user clicks **Logout** or remains inactive past a timeout limit, the server destroys the session.

---

### 4. Cookies
**Definition:**  
**Cookies** are small pieces of data (key-value text files, up to 4 KB) sent by a web server to a user's web browser and stored locally on the **client's device** (computer or phone).

* **How It Works:** Whenever the browser makes a new request to the same website, it automatically attaches the stored cookie back to the server.
* **Common Uses in an E-Commerce System:**
  1. **Session Management:** Storing the user's `Session_ID` so they stay logged in as they browse different products.
  2. **Personalization & Preferences:** Remembering user settings such as preferred currency, language, or dark/light theme.
  3. **Shopping Cart / Tracking:** Remembering items added to a guest shopping cart or tracking recently viewed products.

| Feature | Session | Cookie |
| :--- | :--- | :--- |
| **Where It Is Stored** | **Server-side** (server memory or database). | **Client-side** (inside the user's web browser). |
| **Security** | More secure (cannot be directly edited by the user). | Less secure if not protected (can be inspected in browser, so sensitive passwords should never be stored in plain cookies). |
| **Storage Capacity** | Large (limited only by server memory). | Very small (maximum ~4 KB per cookie). |
| **Lifespan** | Ends when the user logs out or after inactivity timeout. | Can expire when the browser closes (session cookie) or last for days/months (persistent cookie). |

---

## Question 2: Create a Four-Table JOIN in SQL (`E_commerce` Database)

### 1. Database Schema Overview (4 Related Tables)
To perform a **four-table join** in our `E_commerce` database, we link the three tables created in class (**`Customer`**, **`Products`**, and **`Orders`**) with a fourth table called **`Payments`** (which records payment details for each order):

1. **`Customer` (`C`)**: Stores customer details (`Customer_id` as Primary Key).
2. **`Products` (`P`)**: Stores product catalog details (`Product_id` as Primary Key).
3. **`Orders` (`O`)**: Links `Customer` and `Products` (`Order_id` as Primary Key; `Customer_id` and `Product_id` as Foreign Keys).
4. **`Payments` (`PM`)**: Stores payment transactions for each order (`Payment_id` as Primary Key; `Order_id` as Foreign Key referencing `Orders.Order_id`).

---

### 2. SQL Commands to Create the 4 Tables and Insert Data

```sql
CREATE DATABASE IF NOT EXISTS E_commerce;
USE E_commerce;

-- Table 1: Customer
CREATE TABLE Customer (
    Customer_id INT PRIMARY KEY AUTO_INCREMENT,
    Fname VARCHAR(50) NOT NULL,
    Lname VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    email VARCHAR(100) UNIQUE
);

-- Table 2: Products
CREATE TABLE Products (
    Product_id INT PRIMARY KEY AUTO_INCREMENT,
    Product_name VARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) DEFAULT 0.00
);

-- Table 3: Orders
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

-- Table 4: Payments
CREATE TABLE Payments (
    Payment_id INT PRIMARY KEY AUTO_INCREMENT,
    Order_id INT,
    Payment_method ENUM('Card', 'Bank Transfer', 'Cash') DEFAULT 'Card',
    Payment_status ENUM('Paid', 'Unpaid', 'Refunded') DEFAULT 'Paid',
    Payment_date DATE,
    FOREIGN KEY (Order_id) REFERENCES Orders(Order_id)
);
```

#### Sample Data Insertion (`INSERT INTO`)
```sql
INSERT INTO Customer (Fname, Lname, phone_number, email) VALUES
('Alice', 'Johnson', '08012345678', 'alice@example.com'),
('Bob', 'Smith', '08023456789', 'bob@example.com'),
('Charlie', 'Brown', '08034567890', 'charlie@example.com');

INSERT INTO Products (Product_name, Price) VALUES
('Laptop', 450000.00),
('Wireless Mouse', 15000.00),
('Mechanical Keyboard', 45000.00);

INSERT INTO Orders (Customer_id, Product_id, Quantity, Order_date, Order_status) VALUES
(1, 1, 1, '2026-11-17', 'Delivered'),
(2, 2, 2, '2026-11-17', 'Shipped'),
(3, 3, 1, '2026-11-17', 'Pending');

INSERT INTO Payments (Order_id, Payment_method, Payment_status, Payment_date) VALUES
(1, 'Card', 'Paid', '2026-11-17'),
(2, 'Bank Transfer', 'Paid', '2026-11-17'),
(3, 'Card', 'Unpaid', '2026-11-17');
```

---

### 3. The Four-Table `INNER JOIN` Query

```sql
SELECT 
    O.Order_id,
    O.Order_date,
    C.Fname,
    C.Lname,
    P.Product_id,
    P.Product_name,
    O.Quantity,
    PM.Payment_id,
    PM.Payment_method,
    PM.Payment_status
FROM Orders O
INNER JOIN Customer C ON O.Customer_id = C.Customer_id
INNER JOIN Products P ON O.Product_id = P.Product_id
INNER JOIN Payments PM ON O.Order_id = PM.Order_id;
```

### 4. Explanation of How the Four-Table Join Works
1. **`FROM Orders O`**: Starts with the `Orders` table (aliased as `O`), which acts as the central bridge table.
2. **`INNER JOIN Customer C ON O.Customer_id = C.Customer_id`**: Connects each order in `Orders` (`O`) to the matching customer in `Customer` (`C`) where their `Customer_id` values match.
3. **`INNER JOIN Products P ON O.Product_id = P.Product_id`**: Connects each order in `Orders` (`O`) to the matching product in `Products` (`P`) where their `Product_id` values match.
4. **`INNER JOIN Payments PM ON O.Order_id = PM.Order_id`**: Connects each order in `Orders` (`O`) to its payment record in `Payments` (`PM`) where their `Order_id` values match.
5. **Expected Output:**

| Order_id | Order_date | Fname | Lname | Product_id | Product_name | Quantity | Payment_id | Payment_method | Payment_status |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | 2026-11-17 | Alice | Johnson | 1 | Laptop | 1 | 1 | Card | Paid |
| 2 | 2026-11-17 | Bob | Smith | 2 | Wireless Mouse | 2 | 2 | Bank Transfer | Paid |
| 3 | 2026-11-17 | Charlie | Brown | 3 | Mechanical Keyboard | 1 | 3 | Card | Unpaid |

