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
    CREATE TRIGGER UpdateRequestStatus
    BEFORE INSERT ON request
    FOR EACH ROW
    BEGIN
        SET NEW.status_code = 'In Progress';
    END $$

    DELIMITER $$
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

