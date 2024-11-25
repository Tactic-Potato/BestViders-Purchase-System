DROP DATABASE IF EXISTS bestviders;
CREATE DATABASE bestviders;
USE bestviders;

-- 1. Status Tables
CREATE TABLE status_request (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE status_order (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

CREATE TABLE status_reception (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(20) NOT NULL
);

-- 2. Category and Area
CREATE TABLE category (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(250) NULL
);

CREATE TABLE area (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager INT NULL
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
    status BOOLEAN DEFAULT TRUE,
    numTel VARCHAR(20) NULL,
    email VARCHAR(100) NULL,
    charge VARCHAR(10),
    area VARCHAR(10),
    FOREIGN KEY (charge) REFERENCES charge(code),
    FOREIGN KEY (area) REFERENCES area(code) ON DELETE SET NULL
);

ALTER TABLE area
ADD FOREIGN KEY (manager) REFERENCES employee(num) ON DELETE SET NULL;

-- 4. Provider
CREATE TABLE provider (
    num INT PRIMARY KEY AUTO_INCREMENT,
    fiscal_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NULL,
    numTel VARCHAR(20) NULL,
    status BOOLEAN DEFAULT TRUE,
    motive VARCHAR(250) NULL
);

-- 5. Raw Material
CREATE TABLE raw_material (
    code VARCHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(12, 2) NOT NULL,
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
    motive VARCHAR(250) NULL,
    employee INT,
    status VARCHAR(10) DEFAULT 'PEND',
    creationDate DATE NOT NULL DEFAULT (CURRENT_DATE),
    area VARCHAR(10),
    FOREIGN KEY (employee) REFERENCES employee(num),
    FOREIGN KEY (status) REFERENCES status_order(code),
    FOREIGN KEY (area) REFERENCES area(code)
);


-- 7. Request
CREATE TABLE request (
    num INT PRIMARY KEY AUTO_INCREMENT,
    request_date DATE DEFAULT (CURRENT_DATE),
    estimated_date DATE,
    employee INT,
    provider INT,
    order_num INT,
    status VARCHAR(10) DEFAULT 'PEND',
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

CREATE TABLE order_material (
    order_num INT,
    material VARCHAR(10),
    quantity INT,
    PRIMARY KEY (order_num, material),
    FOREIGN KEY (order_num) REFERENCES orders(num),
    FOREIGN KEY (material) REFERENCES raw_material(code)
);


-- 9. Invoice
CREATE TABLE invoice (
    folio VARCHAR(10) PRIMARY KEY,
    amount DECIMAL(12, 2),
    subtotal DECIMAL(12, 2),
    iva DECIMAL(12, 2),
    payDate DATE DEFAULT (CURRENT_DATE),
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
    dateBudget DATE DEFAULT (CURRENT_DATE),
    area VARCHAR(10),
    FOREIGN KEY (area) REFERENCES area(code)
);

-- 11. User
CREATE TABLE user (
    num INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100),
    FOREIGN KEY (num) REFERENCES employee(num)
);

-- 12. Area Order
CREATE TABLE area_order (
    area VARCHAR(10),
    order_num INT,
    quantity INT,
    PRIMARY KEY (area, order_num),
    FOREIGN KEY (area) REFERENCES area(code),
    FOREIGN KEY (order_num) REFERENCES orders(num)
);

-- 13. Reception
CREATE TABLE reception (
    num INT PRIMARY KEY AUTO_INCREMENT,
    receptionDate DATE DEFAULT (CURRENT_DATE),
    observations TEXT NULL,
    missings INT NULL,
    employee INT,
    request INT,
    status VARCHAR(10) DEFAULT 'PEND',
    FOREIGN KEY (employee) REFERENCES employee(num),
    FOREIGN KEY (request) REFERENCES request(num),
    FOREIGN KEY (status) REFERENCES status_reception(code)
);

-- 14. Raw Provider
CREATE TABLE raw_provider (
    provider INT,
    material VARCHAR(10),
    PRIMARY KEY (provider, material),
    FOREIGN KEY (provider) REFERENCES provider(num),
    FOREIGN KEY (material) REFERENCES raw_material(code)
);

-- 15. Trouble 
CREATE TABLE trouble (
    num INT PRIMARY KEY AUTO_INCREMENT,
    troubleDate DATE DEFAULT (CURRENT_DATE),
    description TEXT,
    reception INT,
    FOREIGN KEY (reception) REFERENCES reception(num)
);

/* * * * * * * * * * * * * TRIGGERS * * * * * * * * * * * * */
    DELIMITER $$
    CREATE TRIGGER CreateUser
    AFTER INSERT ON employee
    FOR EACH ROW
    BEGIN
        DECLARE Username VARCHAR(100);
        SET Username = CONCAT(NEW.firstName, ' ', NEW.lastName, ' ', IFNULL(NEW.surname, ''));
        INSERT INTO user (num, username, password)
        VALUES (NEW.num, Username, '1234567890');
    END $$

    DELIMITER $$
    CREATE TRIGGER UpdateOrderStatus
    AFTER INSERT ON request
    FOR EACH ROW
    BEGIN
        IF NEW.order_num IS NOT NULL THEN
            UPDATE orders
            SET status = 'RCVD'
            WHERE num = NEW.order_num;
        END IF;
    END $$

    DELIMITER $$
    CREATE TRIGGER UpdateRequestStatus
    BEFORE INSERT ON request
    FOR EACH ROW
    BEGIN
        SET NEW.status = 'PROC';
    END $$

    DELIMITER $$
    CREATE TRIGGER AutoRequest
    BEFORE INSERT ON request
    FOR EACH ROW
    BEGIN
        DECLARE total DECIMAL(10, 2) DEFAULT 0.0;
        SELECT SUM(RM.quantity * M.price) INTO total
        FROM request_material RM
        JOIN raw_material M ON RM.material = M.code
        WHERE RM.request = NEW.num;

        SET NEW.subtotal = total;
    END $$
    DELIMITER;

    DELIMITER $$    
    CREATE TRIGGER UpdateRequestSubtotal
    AFTER INSERT ON request_material
    FOR EACH ROW
    BEGIN
        DECLARE total DECIMAL(10, 2);

        SELECT SUM(RM.quantity * M.price)
        INTO total
        FROM request_material RM
        JOIN raw_material M ON RM.material = M.code
        WHERE RM.request = NEW.request;

        UPDATE request
        SET subtotal = total
        WHERE num = NEW.request;
    END $$

/* * * * * * * * * * * * * VIEWS * * * * * * * * * * * * */
    CREATE VIEW vw_employee_user AS
    SELECT 
        e.num as num,
        e.firstName AS firstName,
        e.lastName AS lastName,
        e.area AS area,
        e.email AS email,
        e.numTel AS numTel,
        e.status AS status,
        u.password
    FROM employee AS e
    INNER JOIN user AS u ON e.num = u.num;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    create VIEW vw_provider AS 
    SELECT
        p.num AS num,
        p.fiscal_name AS fiscalName,
        p.email AS email,
        p.numTel AS numTel,
        p.status AS status,
        GROUP_CONCAT(rm.name SEPARATOR ' | ') AS materials
    FROM provider AS p
    INNER JOIN raw_provider AS rp ON rp.provider = p.num
    INNER JOIN raw_material AS rm ON rp.material = rm.code
    GROUP BY p.num, p.fiscal_name, p.email, p.numTel, p.status;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    CREATE VIEW vw_order AS
    SELECT
        o.num AS num,
        o.description AS description,
        CONCAT(e.firstName, ' ', e.lastName) AS employee,
        GROUP_CONCAT(rw.name ORDER BY rw.name SEPARATOR ', ') AS rawMaterials,  -- Concatenamos los materiales
        so.name AS status,
        o.creationDate AS creationDate,
        a.name AS area
    FROM orders AS o
    INNER JOIN employee AS e ON o.employee = e.num
    INNER JOIN order_material AS om ON om.order_num = o.num
    INNER JOIN raw_material AS rw ON om.material = rw.code
    INNER JOIN status_order AS so ON o.status = so.code
    INNER JOIN area AS a ON o.area = a.code
    GROUP BY o.num, o.description, e.firstName, e.lastName, so.name, o.creationDate, a.name;


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    CREATE VIEW vw_request AS
    SELECT
        r.num as num,
        r.request_date as requestDate,
        CONCAT(e.firstName, ' ', e.lastName) as employee,
        p.fiscal_name as fiscalName,
        o.num as numOrder,
        sr.name as status
    FROM request as r
    INNER JOIN employee as e ON r.employee = e.num
    INNER JOIN provider as p ON r.provider = p.num
    INNER JOIN orders as o ON r.order_num = o.num
    INNER JOIN status_request as sr ON r.status = sr.code;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    create VIEW vw_provider_removed AS 
    SELECT
        p.num AS num,
        p.fiscal_name AS fiscalName,
        p.email AS email,
        p.numTel AS numTel,
        p.status AS status,
        GROUP_CONCAT(rm.name SEPARATOR ' | ') AS materials
    FROM provider AS p
    INNER JOIN raw_provider AS rp ON rp.provider = p.num
    INNER JOIN raw_material AS rm ON rp.material = rm.code
    WHERE p.status = 0 
    GROUP BY p.num, p.fiscal_name, p.email, p.numTel, p.status;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    create VIEW vw_provider_assoc AS 
    SELECT
        p.num AS num,
        p.fiscal_name AS fiscalName,
        p.email AS email,
        p.numTel AS numTel,
        p.status AS status,
        GROUP_CONCAT(rm.name SEPARATOR ' | ') AS materials
    FROM provider AS p
    INNER JOIN raw_provider AS rp ON rp.provider = p.num
    INNER JOIN raw_material AS rm ON rp.material = rm.code
    WHERE p.status = 1
    GROUP BY p.num, p.fiscal_name, p.email, p.numTel, p.status;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

/* * * * * * * * * * * * * INSERTS * * * * * * * * * * * * */

-- Status Request
INSERT INTO status_request (code, name) VALUES
('PEND', 'Pending'),
('PROC', 'In Process'),
('COMP', 'Completed');

INSERT INTO status_order (code, name) VALUES
('PEND', 'Pending'),
('APRV', 'Approved'),
('REJD', 'Rejected');

INSERT INTO status_reception (code, name) VALUES
('PEND', 'Pending'),
('VERF', 'Verified'),
('ERR', 'Errors');

-- Category
INSERT INTO category (code, name, description) VALUES
('CAP', 'Capacitors', 'Components used for storing electrical energy.'),
('CON', 'Connectors', 'Various connectors for PCBs and circuits.'),
('IC', 'Integrated Circuits', 'Semiconductor chips for various functionalities.'),
('PCB', 'Printed Circuit Boards', 'Base material for creating circuit boards.'),
('RES', 'Resistors', 'Components used to limit the flow of current.'),
('LED', 'LEDs', 'Light Emitting Diodes for indicators and displays.'),
('TRN', 'Transistors', 'Semiconductor devices used for switching and amplification.'),
('DIO', 'Diodes', 'Components for rectification and switching.');

-- Area
INSERT INTO area (code, name, manager) VALUES
('RH', 'Human Resources', NULL),
('PR', 'Purchasing Area', NULL),
('ST', 'Store', NULL),
('PA1', 'Production Area 1', NULL),
('PA2', 'Production Area 2', NULL),
('PA3', 'Production Area 3', NULL)

-- Charge
INSERT INTO charge (code, name) VALUES
('MNGR', 'Manager'),
('WRKR', 'Worker');

-- Employee
INSERT INTO employee (firstName, lastName, surname, status, numTel, email, charge, area) VALUES
('Carlos', 'Gómez', 'Pérez', TRUE, '5551234567', 'carlos.gomez@gmail.com', 'MNGR', 'RH'),
('Ana', 'Martínez', NULL, TRUE, '5552345678', 'ana.martinez@gmail.com', 'WRKR', 'PA1'),
('Maria', 'Salem', NULL, TRUE, '5552345678', 'MariaSal@gmail.com', 'WRKR', 'PA2'),
('Jane', 'Lopez', NULL, TRUE, '5552345678', 'JaneL@gmail.com', 'WRKR', 'PA3')

-- Raw Material
INSERT INTO raw_material (code, price, name, description, weight, stock, category) VALUES
('CAP003', 0.10, 'Ceramic Capacitor 10uF', 'General purpose capacitor for filtering', 0.00, 1000, 'CAP'),
('CON005', 0.50, 'USB Connector', 'Standard USB connector type-A', 0.01, 300, 'CON'),
('IC0002', 3.00, 'Microcontroller', '8-bit Microcontroller for embedded applications', 0.01, 200, 'IC'),
('PCB001', 1.50, 'PCB 2-layer', 'Standard 2-layer PCB for general applications', 0.05, 500, 'PCB'),
('RES004', 0.05, 'Resistor 100 Ohm', 'General purpose resistor 100 Ohm 1/4W', 0.00, 1500, 'RES'),
('CAP006', 0.15, 'Ceramic Capacitor 22uF', 'High capacitance for filtering', 0.00, 800, 'CAP'),
('CON008', 0.75, 'HDMI Connector', 'Standard HDMI connector for video/audio', 0.02, 400, 'CON'),
('IC0030', 5.50, 'ARM Cortex-M0', '32-bit microcontroller for IoT applications', 0.01, 100, 'IC'),
('PCB002', 2.00, 'PCB 4-layer', '4-layer PCB for advanced designs', 0.07, 300, 'PCB'),
('RES010', 0.10, 'Resistor 1k Ohm', 'General purpose resistor 1k Ohm 1/2W', 0.00, 1200, 'RES'),
('LED001', 0.25, 'LED 5mm Red', 'Standard red LED for indicators', 0.00, 1000, 'LED'),
('TRN002', 0.90, 'NPN Transistor', 'General purpose NPN transistor', 0.01, 700, 'TRN'),
('DIO003', 0.20, 'Schottky Diode', 'High-speed switching diode', 0.01, 600, 'DIO');

-- Provider
INSERT INTO provider (fiscal_name, email, numTel) VALUES
('Electronic Parts Co.', 'electronicparts@gmail.com', '6647891234'),
('Global Circuits Ltd.', 'globalcircuits@gmail.com', '6643216789'),
('Resistor World', 'resistorworld@gmail.com', '6649876543'),
('Capacitor Central', 'capacitorcentral@gmail.com', '6645674321'),
('LED Galaxy', 'ledgalaxy@gmail.com', '6641234567'),
('Semiconductor Solutions', 'semiconductorsolutions@gmail.com', '6644567890');

-- Raw Provider
INSERT INTO raw_provider (provider, material) VALUES
(1, 'CAP003'),
(1, 'CAP006'),
(2, 'PCB001'),
(2, 'PCB002'),
(3, 'RES004'),
(3, 'RES010'),
(4, 'LED001'),
(5, 'LED001'),
(6, 'IC0002'),
(6, 'IC0030'),
(6, 'TRN002'),
(6, 'DIO003');

-- Budget
INSERT INTO budget (code, initialAmount, budgetRemain, dateBudget, area) VALUES
('BPA1-1', 250000.00, 250000.00, CURRENT_DATE, 'PA1'),
('BPA2-1', 250000.00, 250000.00, CURRENT_DATE, 'PA2'),
('BPA3-1', 250000.00, 250000.00, CURRENT_DATE, 'PA3');

/********************** PROCEDURES ***********************/

DELIMITER $$

CREATE PROCEDURE Sp_RegistrarEmpleado(
    IN firstName VARCHAR(100),
    IN lastName VARCHAR(100),
    IN surName VARCHAR(100),
    IN numTel VARCHAR(20),
    IN email VARCHAR(100),
    IN charge VARCHAR(10),
    IN area VARCHAR(10)
)
BEGIN
    INSERT INTO employee (firstName, lastName, surname, numTel, email, charge, area)
    VALUES (
        firstName, 
        lastName, 
        surName, 
        numTel, 
        email, 
        charge, 
        area
    );
END$$

DELIMITER ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
DELIMITER $$

CREATE PROCEDURE sp_RemoveProvider(
    IN p_num INT,
    IN p_motive TEXT,
    IN p_status INT
)
BEGIN
    UPDATE provider
    SET status = p_status, motive = p_motive
    WHERE num = p_num;
END$$

DELIMITER ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
DELIMITER $$
CREATE PROCEDURE sp_RehireProvider(
    IN p_num INT,
    IN p_status INT
)
BEGIN
    UPDATE provider
    SET status = p_status
    WHERE num = p_num;
END$$

DELIMITER ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
DELIMITER $$

CREATE PROCEDURE Sp_CreateOrder(
    IN p_descrp TEXT,
    IN p_employee INT,
    IN p_rawMaterial VARCHAR(10)
)
BEGIN
    INSERT INTO orders (description, employee, raw_material)
    VALUES (p_descrp, p_employee, p_rawMaterial);
END$$

DELIMITER ;
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
