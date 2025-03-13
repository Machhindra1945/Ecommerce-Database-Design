-- Create Database
CREATE DATABASE ecommerce;

-- Switch to the ecommerce database
\c ecommerce;

-- Customer Table
CREATE TABLE Customer (
    User_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Password TEXT NOT NULL
);

-- Product Table
CREATE TABLE Product (
    Product_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Price NUMERIC(10, 2) NOT NULL,
    Description TEXT
);

-- Category Table
CREATE TABLE Category (
    Category_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Picture TEXT,
    Description TEXT
);

-- Order Table
CREATE TABLE orders (
    Order_ID SERIAL PRIMARY KEY,
    User_ID INT NOT NULL,
    Category_ID INT NOT NULL,
    Amount NUMERIC(10, 2) NOT NULL,
    Date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (User_ID) REFERENCES Customer(User_ID),
    FOREIGN KEY (Category_ID) REFERENCES Category(Category_ID)
);

-- Payment Table
CREATE TABLE Payment (
    Product_ID SERIAL PRIMARY KEY,
    Type VARCHAR(50) NOT NULL,
    Amount NUMERIC(10, 2) NOT NULL,
    Order_ID INT NOT NULL,
    FOREIGN KEY (Order_ID) REFERENCES orders(Order_ID)
);

-- Cart Table
CREATE TABLE Cart (
    Category_ID SERIAL PRIMARY KEY,
    User_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    FOREIGN KEY (User_ID) REFERENCES Customer(User_ID),
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID)
);


-- Insert Sample Records

-- Insert into Customer
INSERT INTO Customer (Name, Email, Password) VALUES
('John Doe', 'john@example.com', 'password123'),
('Jane Smith', 'jane@example.com', 'securepass'),
('Alice Johnson', 'alice@example.com', 'alicepass');

-- Insert into Product
INSERT INTO Product (Name, Price, Description) VALUES
('Laptop', 999.99, 'High-end gaming laptop'),
('Smartphone', 699.50, 'Latest model smartphone'),
('Headphones', 149.99, 'Noise-cancelling headphones');

-- Insert into Category
INSERT INTO Category (Name, Picture, Description) VALUES
('Electronics', 'electronics.jpg', 'Electronic devices and gadgets'),
('Accessories', 'accessories.jpg', 'Electronic accessories');

-- Insert into Orders
INSERT INTO orders (User_ID, Category_ID, Amount) VALUES
(1, 1, 999.99),
(2, 2, 149.99),
(3, 1, 699.50);

-- Insert into Payment
INSERT INTO Payment (Type, Amount, Order_ID) VALUES
('Credit Card', 999.99, 1),
('Paypal', 149.99, 2),
('Debit Card', 699.50, 3);

-- Insert into Cart
INSERT INTO Cart (User_ID, Product_ID) VALUES
(1, 1),
(2, 3),
(3, 2);

-- Sample Queries for Testing

-- Retrieve all Customers
SELECT * FROM Customer;

-- Retrieve all Products in Electronics Category
SELECT p.* FROM Product p
JOIN orders o ON p.Product_ID = o.Category_ID
JOIN Category c ON o.Category_ID = c.Category_ID
WHERE c.Name = 'Electronics';


-- Get Order Details with Payment Info
SELECT o.Order_ID, c.Name AS CustomerName, o.Amount, p.Type AS PaymentMethod
FROM orders o
JOIN Customer c ON o.User_ID = c.User_ID
JOIN Payment p ON o.Order_ID = p.Order_ID;

-- Display Cart Items for a Specific User
SELECT c.Name AS CustomerName, p.Name AS ProductName
FROM Cart ca
JOIN Customer c ON ca.User_ID = c.User_ID
JOIN Product p ON ca.Product_ID = p.Product_ID
WHERE c.Name = 'John Doe';
