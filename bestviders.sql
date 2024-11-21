DROP DATABASE IF EXISTS bestviders;
CREATE DATABASE bestviders;
USE bestviders;

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
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NULL,
    status BOOLEAN,
    numTel VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    charge VARCHAR(10),
    area VARCHAR(10),
    FOREIGN KEY (charge) REFERENCES charge(code),
    FOREIGN KEY (area) REFERENCES area(code) ON DELETE SET NULL
);

ALTER TABLE area
ADD FOREIGN KEY (manager_num) REFERENCES employee(num) ON DELETE SET NULL;

-- 4. Provider
CREATE TABLE provider (
    num INT PRIMARY KEY AUTO_INCREMENT,
    fiscal_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NULL,
    numTel VARCHAR(20) NULL,
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
    category VARCHAR(10),
    FOREIGN KEY (category) REFERENCES category(code)
);

-- 6. Orders
CREATE TABLE orders (
    num INT PRIMARY KEY AUTO_INCREMENT,
    description TEXT NULL,
    employee INT,
    raw_material VARCHAR(10),
    status VARCHAR(10),
    FOREIGN KEY (employee) REFERENCES employee(num),
    FOREIGN KEY (raw_material) REFERENCES raw_material(code),
    FOREIGN KEY (status) REFERENCES status_order(code)
);

-- 7. Request
CREATE TABLE request (
    num INT PRIMARY KEY AUTO_INCREMENT,
    subtotal DECIMAL(12, 2),
    request_date DATETIME,
    employee INT,
    provider INT,
    order INT,
    status VARCHAR(10),
    FOREIGN KEY (employee) REFERENCES employee(num),
    FOREIGN KEY (provider) REFERENCES provider(num),
    FOREIGN KEY (order_num) REFERENCES orders(num),
    FOREIGN KEY (status) REFERENCES status_request(code)
);

-- 8. Request Material
CREATE TABLE request_material (
    request INT,
    material VARCHAR(10),
    quantity INT,
    amount DECIMAL(12, 2),
    PRIMARY KEY (request, material),
    FOREIGN KEY (request) REFERENCES request(num),
    FOREIGN KEY (material) REFERENCES raw_material(code)
);

-- 9. Invoice
CREATE TABLE invoice (
    folio VARCHAR(10) PRIMARY KEY,
    amount DECIMAL(12, 2),
    payDate DATETIME NULL,
    subtotal DECIMAL(12, 2),
    request INT,
    provider INT,
    FOREIGN KEY (request) REFERENCES request(num),
    FOREIGN KEY (provider) REFERENCES provider(num)
);

-- 10. Budget
CREATE TABLE budget (
    code VARCHAR(10) PRIMARY KEY,
    initialAmount DECIMAL(12, 2),
    budgetRemain DECIMAL(12, 2),
    dateBudget DATETIME,
    area VARCHAR(10),
    FOREIGN KEY (area) REFERENCES area(code)
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
    area VARCHAR(10),
    order INT,
    quantity INT,
    PRIMARY KEY (area, order),
    FOREIGN KEY (area) REFERENCES area(code),
    FOREIGN KEY (order) REFERENCES orders(num)
);

-- 13. Reception
CREATE TABLE reception (
    num INT PRIMARY KEY AUTO_INCREMENT,
    receptionDate DATETIME NULL,
    observations TEXT NULL,
    numReception INT NULL,
    missing INT NULL,
    employee INT,
    request INT,
    status VARCHAR(10),
    FOREIGN KEY (employee) REFERENCES employee(num),
    FOREIGN KEY (request) REFERENCES request(num),
    FOREIGN KEY (status) REFERENCES status_reception(code)
);

CREATE TABLE raw_provider (
    provider INT,
    material VARCHAR(10),
    PRIMARY KEY (provider, material),
    FOREIGN KEY (provider) REFERENCES provider(num),
    FOREIGN KEY (material) REFERENCES raw_material(code)
);


    DELIMITER $$
    CREATE TRIGGER CreateUser
    AFTER INSERT ON employee
    FOR EACH ROW
    BEGIN
        DECLARE Username VARCHAR(100);
        SET Username = CONCAT(NEW.first_name, ' ', NEW.last_name, ' ', IFNULL(NEW.surname, ''));

        INSERT INTO user (num, username, password)
        VALUES (NEW.num, Username, '1234567890');
    END $$

    DELIMITER $$
    CREATE TRIGGER StatusAuto
    BEFORE INSERT ON employee
    FOR EACH ROW
    BEGIN
        IF NEW.status IS NULL THEN
            SET NEW.status = TRUE; -- TRUE o FALSE se usa para BOOLEAN en MySQL
        END IF;
    END $$

    DELIMITER $$
    DROP TRIGGER UpdateOrderStatus
    CREATE TRIGGER UpdateOrderStatus
    AFTER INSERT ON request
    FOR EACH ROW
    BEGIN
        IF NEW.order_num IS NOT NULL THEN
            UPDATE orders
            SET status_code = 'Received'
            WHERE num = NEW.order_num;
        END IF;
    END $$

    DELIMITER $$
    DROP TRIGGER UpdateRequestStatus
    CREATE TRIGGER UpdateRequestStatus
    BEFORE INSERT ON request
    FOR EACH ROW
    BEGIN
        SET NEW.status_code = 'In Progress';
    END $$

    DELIMITER $$
    DROP TRIGGER AutoRequest
    CREATE TRIGGER AutoRequest
    BEFORE INSERT ON request
    FOR EACH ROW
    BEGIN
        DECLARE total DECIMAL(10, 2) DEFAULT 0.0;

        SET NEW.status_code = 'In Progress';
        SET NEW.request_date = CURDATE();

        SELECT SUM(RM.quantity * M.price) INTO total
        FROM request_material RM
        JOIN raw_material M ON RM.product_code = M.code
        WHERE RM.request_num = NEW.num;

        SET NEW.subtotal = total;
    END $$
    DELIMITER ;


    DELIMITER $$
    DROP TRIGGER UpdateRequestSubtotal
    CREATE TRIGGER UpdateRequestSubtotal
    AFTER INSERT ON request_material
    FOR EACH ROW
    BEGIN
        DECLARE total DECIMAL(10, 2);

        SELECT SUM(RM.quantity * M.price)
        INTO total
        FROM request_material RM
        JOIN raw_material M ON RM.product_code = M.code
        WHERE RM.request_num = NEW.request_num;

        UPDATE request
        SET subtotal = total
        WHERE num = NEW.request_num;
    END $$

    INSERT INTO area (code, name, manager_num)
    VALUES
        ('RH', 'Human Resources', NULL),
        ('PR', 'Purchasing Area', NULL),
        ('ST', 'Store', NULL);

    INSERT INTO charge (code, name)
    VALUES
        ('MAN', 'Manager')

    -- 2. Insertar datos en la tabla `employee`
    INSERT INTO employee (first_name, last_name, surname, status, phone_number, email, charge_code, area_code)
    VALUES
        ('Carlos', 'Gómez', 'Pérez', TRUE, '5551234567', 'carlos.gomez@bestviders.com', 'MAN', 'RH')


    CREATE VIEW employee_user_view AS
    SELECT 
        E.num,
        E.first_name AS firstName,
        E.last_name AS lastName,
        E.area_code AS area,
        E.email,
        U.password
    FROM 
        employee AS E
    JOIN 
        user AS U 
    ON 
        E.num = U.num;

/* ******NUEVOS INSERTS****** */
-- Status Request
INSERT INTO status_request (code, name) VALUES
('PEND', 'Pending'),
('APRV', 'Approved'),
('REJT', 'Rejected');

-- Status Order
INSERT INTO status_order (code, name, motive) VALUES
('CRTD', 'Created', NULL),
('PROC', 'In Process', NULL),
('RCVD', 'Received', 'Received successfully.'),
('REJT', 'Rejected', NULL);

-- Status Reception
INSERT INTO status_reception (code, name) VALUES
('PEND', 'Pending'),
('CMPL', 'Completed');

-- Status Provider
INSERT INTO status_provider (code, name, motive) VALUES
('ACTV', 'Active', NULL),
('INAC', 'Inactive', 'No recent activity.');

-- Category
INSERT INTO category (code, name, description) VALUES
('CAP', 'Capacitors', 'Components used for storing electrical energy.'),
('CON', 'Connectors', 'Various connectors for PCBs and circuits.'),
('IC', 'Integrated Circuits', 'Semiconductor chips for various functionalities.'),
('PCB', 'Printed Circuit Boards', 'Base material for creating circuit boards.'),
('RES', 'Resistors', 'Components used to limit the flow of current.');

-- Area
INSERT INTO area (code, name, manager_num)
VALUES
    ('RH', 'Human Resources', NULL),
    ('PR', 'Purchasing Area', NULL),
    ('ST', 'Store', NULL);

-- Charge
INSERT INTO charge (code, name) VALUES
('MNGR', 'Manager'),
('WRKR', 'Worker');

-- Employee
INSERT INTO employee (first_name, last_name, surname, status, phone_number, email, charge_code, area_code) VALUES
('Carlos', 'Gómez', 'Pérez', TRUE, '5551234567', 'carlos.gomez@bestviders.com', 'MNGR', 'RH'),
('Ana', 'Martínez', NULL, TRUE, '5552345678', 'ana.martinez@bestviders.com', 'WRKR', 'ST'),
('Luis', 'Fernández', 'López', TRUE, '5553456789', 'luis.fernandez@bestviders.com', 'WRKR', 'PR');

-- Provider
INSERT INTO provider (fiscal_name, email, category_code) VALUES
('Supplier A', 'supplier.a@example.com', 'CAP'),
('Supplier B', 'supplier.b@example.com', 'CON');

-- Raw Material
INSERT INTO raw_material (code, price, name, description, weight, stock, category_code) VALUES
('CAP003', 0.10, 'Ceramic Capacitor 10uF', 'General purpose capacitor for filtering', 0.00, 1000, 'CAP'),
('CON005', 0.50, 'USB Connector', 'Standard USB connector type-A', 0.01, 300, 'CON'),
('IC0002', 3.00, 'Microcontroller', '8-bit Microcontroller for embedded applications', 0.01, 200, 'IC'),
('PCB001', 1.50, 'PCB 2-layer', 'Standard 2-layer PCB for general applications', 0.05, 500, 'PCB'),
('RES004', 0.05, 'Resistor 100 Ohm', 'General purpose resistor 100 Ohm 1/4W', 0.00, 1500, 'RES');

-- Order
INSERT INTO orders (description, employee_num, raw_material_code, status_code) VALUES 
('Order for 100 Ceramic Capacitors', 1, 'CAP003', 'CRTD'), 
('Order for 50 USB Connectors', 5, 'CON005', 'PROC'),
('Order for 200 Microcontrollers', 6, 'IC0002', 'RCVD');

-- Request
INSERT INTO request (subtotal, request_date, employee_num, provider_num, order_num, status_code) VALUES 
(50.00, '2024-11-15 10:00:00', 1, 1, 1, 'PEND'),
(100.00, '2024-11-16 11:00:00', 5, 2, 2, 'APRV'),
(150.00, '2024-11-17 12:00:00', 6, 1, 3, 'REJT');
/* pendiente */

-- Request_material
INSERT INTO request_material (request_num, product_code, quantity, amount) VALUES
(1, 'CAP003', 100, 10.00),
(2, 'CON005', 50, 25.00),
(3, 'IC0002', 200, 600.00);

-- Invoice
INSERT INTO invoice (folio, amount, pay_date, subtotal, request_num, provider_num) VALUES
('INV001', 55.00, '2024-11-18 14:00:00', 50.00, 1, 1),
('INV002', 125.00, '2024-11-19 15:00:00', 100.00, 2, 2);

-- Budget
INSERT INTO budget (code, initial_amount, remaining_budget, budget_date, area_code) VALUES
('BUD001', 5000.00, 4500.00, '2024-11-01', 'RH'),
('BUD002', 3000.00, 2500.00, '2024-11-01', 'PR'),
('BUD003', 2000.00, 1500.00, '2024-11-01', 'ST');

-- Area Order
INSERT INTO area_order (area_code, order_num, quantity) VALUES
('RH', 1, 100),
('PR', 2, 50),
('ST', 3, 200);

-- Reception
INSERT INTO reception (reception_date, observations, reception_number, missing_quantity, employee_num, request_num, status_code)  VALUES
('2024-11-18 10:30:00', 'All items received successfully.', 1, 0, 1, 1, 'CMPL'),
('2024-11-19 11:00:00', 'Missing 10 connectors.', 2, 10, 5, 2, 'PEND');