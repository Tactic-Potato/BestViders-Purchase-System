DROP DATABASE IF EXISTS BestViders;
CREATE DATABASE BestViders;
USE BestViders;

-- 1. Status Tables
CREATE TABLE status_request (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE status_order (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    motive TEXT 
);

CREATE TABLE status_reception (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE status_provider (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    motive TEXT 
);

-- 2. Category and Area
CREATE TABLE category (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT NULL
);

CREATE TABLE area (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager_num INT NULL
);

-- 3. Charge and Employee
CREATE TABLE charge (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE employee (
    num INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NULL,
    status BOOLEAN,
    phone_number VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    charge_code VARCHAR(10),
    area_code VARCHAR(10)
);

ALTER TABLE employee
ADD FOREIGN KEY (area_code) REFERENCES area(code) ON DELETE SET NULL;

ALTER TABLE area
ADD FOREIGN KEY (manager_num) REFERENCES employee(num) ON DELETE SET NULL;

-- 4. Provider
CREATE TABLE provider (
    num INT PRIMARY KEY AUTO_INCREMENT,
    fiscal_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NULL,
    phone_number VARCHAR(20) NULL,
    status VARCHAR(10),
    FOREIGN KEY (status) REFERENCES status_provider(code)
);

-- 5. Raw Material
CREATE TABLE raw_material (
    code VARCHAR(10) PRIMARY KEY,
    price DECIMAL(12, 2) NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    weight DECIMAL(12, 2) NULL,
    stock INT NULL,
    category_code VARCHAR(10),
    FOREIGN KEY (category_code) REFERENCES category(code)
);

-- 6. Orders
CREATE TABLE orders (
    num INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT NULL,
    employee_num INT,
    raw_material_code VARCHAR(10),
    status_code VARCHAR(10),
    FOREIGN KEY (employee_num) REFERENCES employee(num),
    FOREIGN KEY (raw_material_code) REFERENCES raw_material(code),
    FOREIGN KEY (status_code) REFERENCES status_order(code)
);

-- 7. Request
CREATE TABLE request (
    num INT PRIMARY KEY AUTO_INCREMENT,
    subtotal DECIMAL(12, 2),
    request_date DATETIME,
    employee_num INT,
    provider_num INT,
    order_num INT,
    status_code VARCHAR(10),
    FOREIGN KEY (employee_num) REFERENCES employee(num),
    FOREIGN KEY (provider_num) REFERENCES provider(num),
    FOREIGN KEY (order_num) REFERENCES orders(num),
    FOREIGN KEY (status_code) REFERENCES status_request(code)
);

-- 8. Request Material
CREATE TABLE request_material (
    request_num INT,
    product_code VARCHAR(10),
    quantity INT,
    amount DECIMAL(12, 2),
    PRIMARY KEY (request_num, product_code),
    FOREIGN KEY (request_num) REFERENCES request(num),
    FOREIGN KEY (product_code) REFERENCES raw_material(code)
);

-- 9. Invoice
CREATE TABLE invoice (
    folio VARCHAR(10) PRIMARY KEY,
    amount DECIMAL(12, 2),
    pay_date DATETIME NULL,
    subtotal DECIMAL(12, 2),
    request_num INT,
    provider_num INT,
    FOREIGN KEY (request_num) REFERENCES request(num),
    FOREIGN KEY (provider_num) REFERENCES provider(num)
);

-- 10. Budget
CREATE TABLE budget (
    code VARCHAR(10) PRIMARY KEY,
    initial_amount DECIMAL(12, 2),
    remaining_budget DECIMAL(12, 2),
    budget_date DATETIME,
    area_code VARCHAR(10),
    FOREIGN KEY (area_code) REFERENCES area(code)
);

-- 11. User
CREATE TABLE user (
    num INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) DEFAULT '1234567890',
    FOREIGN KEY (num) REFERENCES employee(num)
);

-- 12. Area Order
CREATE TABLE area_order (
    area_code VARCHAR(10),
    order_num INT,
    quantity INT,
    PRIMARY KEY (area_code, order_num),
    FOREIGN KEY (area_code) REFERENCES area(code),
    FOREIGN KEY (order_num) REFERENCES orders(num)
);

-- 13. Reception
CREATE TABLE reception (
    num INT PRIMARY KEY AUTO_INCREMENT,
    reception_date DATETIME NULL,
    observations TEXT NULL,
    reception_number INT NULL,
    missing_quantity INT NULL,
    employee_num INT,
    request_num INT,
    status_code VARCHAR(10),
    FOREIGN KEY (employee_num) REFERENCES employee(num),
    FOREIGN KEY (request_num) REFERENCES request(num),
    FOREIGN KEY (status_code) REFERENCES status_reception(code)
);