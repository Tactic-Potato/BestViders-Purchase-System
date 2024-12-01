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

Alter TABLE employee (
    num INT PRIMARY KEY AUTO_INCREMENT,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    surname VARCHAR(100) NULL,
    status BOOLEAN DEFAULT TRUE,
    numTel VARCHAR(20) NULL UNIQUE,
    email VARCHAR(100) NULL UNIQUE,
    charge VARCHAR(10),
    area VARCHAR(10),
    FOREIGN KEY (charge) REFERENCES charge(code),
    FOREIGN KEY (area) REFERENCES area(code) ON DELETE SET NULL
);

Alter TABLE employee (
    modify column numTel VARCHAR(20) NULL UNIQUE,
    modify column email VARCHAR(100) NULL UNIQUE
);


ALTER TABLE area
ADD FOREIGN KEY (manager) REFERENCES employee(num) ON DELETE SET NULL;

-- 4. Provider
CREATE TABLE provider (
    num INT PRIMARY KEY AUTO_INCREMENT,
    fiscal_name VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(100) NULL UNIQUE,
    numTel VARCHAR(20) NULL UNIQUE,
    status BOOLEAN DEFAULT TRUE,
    motive VARCHAR(250) NULL
);


-- 5. Raw Material
CREATE TABLE raw_material (
    code VARCHAR(10) PRIMARY KEY,
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
); -- este ya no

SELECT CONSTRAINT_NAME 
FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = 'request' AND COLUMN_NAME = 'provider';


ALTER TABLE request
DROP FOREIGN KEY request_ibfk_2;

ALTER TABLE request
DROP COLUMN provider;

CREATE TABLE request (
    num INT PRIMARY KEY AUTO_INCREMENT,
    request_date DATE DEFAULT (CURRENT_DATE),
    estimated_date DATE,
    employee INT,
    provider INT,
    order_num INT,
    status VARCHAR(10) DEFAULT 'PEND',
    FOREIGN KEY (employee) REFERENCES employee(num),
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
    budgetMonth INT,
    budgetYear INT,
    area VARCHAR(10),
    FOREIGN KEY (area) REFERENCES area(code)
);

INSERT INTO budget (code, initialAmount, budgetRemain, budgetMonth, budgetYear, area) VALUES
('BRH-1', 250000.00, 250000.00, MONTH(CURRENT_DATE), YEAR(CURRENT_DATE), 'RH');

-- 11. User
CREATE TABLE user (
    num INT PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100),
    FOREIGN KEY (num) REFERENCES employee(num)
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
    price DECIMAL(12, 2) NOT NULL,
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

CREATE TABLE request_provider (
    request INT,
    provider INT,
    PRIMARY KEY (request, provider),
    FOREIGN KEY (request) REFERENCES request(num),
    FOREIGN KEY (provider) REFERENCES provider(num)
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
DROP TRIGGER RequestAutoAmount
BEFORE INSERT ON request_material
FOR EACH ROW
BEGIN
    DECLARE unit_price DECIMAL(12, 2);
    SELECT price INTO unit_price
    FROM raw_provider
    WHERE provider = (SELECT provider FROM request WHERE num = NEW.request)
    AND material = NEW.material;
    SET NEW.amount = NEW.quantity * unit_price;
END$$
--
DELIMITER $$
CREATE TRIGGER RequestAutoAmount
BEFORE INSERT ON request_material
FOR EACH ROW
BEGIN
    DECLARE unit_price DECIMAL(12, 2);

    SELECT rp.price
    INTO unit_price
    FROM raw_provider rp
    INNER JOIN request_provider reqp ON reqp.provider = rp.provider
    WHERE reqp.request = NEW.request
    AND rp.material = NEW.material
    LIMIT 1;

    IF unit_price IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Material or Provider not found for the given request.';
    END IF;

    SET NEW.amount = NEW.quantity * unit_price;
END $$

DELIMITER ;

--
DELIMITER $$
DROP TRIGGER AutoInvoice
AFTER INSERT ON request_material
FOR EACH ROW
BEGIN
    DECLARE total_amount DECIMAL(12, 2);
    DECLARE generated_folio VARCHAR(20);
    DECLARE invoice_date DATE;
    DECLARE provider_id INT;

    SELECT SUM(amount) INTO total_amount
    FROM request_material
    WHERE request = NEW.request;
    SELECT request_date, provider INTO invoice_date, provider_id
    FROM request
    WHERE num = NEW.request;
        SET generated_folio = CONCAT(
            'F', NEW.request,
            LPAD(DAY(invoice_date), 2, '0'),
            LPAD(MONTH(invoice_date), 2, '0'),
            RIGHT(YEAR(invoice_date), 2)
        );
        
    INSERT INTO invoice (folio, amount, subtotal, iva, payDate, request, provider)
    VALUES (
        generated_folio,
        total_amount + (total_amount * 0.16),
        total_amount,
        total_amount * 0.16,
        invoice_date,
        NEW.request,
        provider_id
    );
END$$


DELIMITER $$
DROP TRIGGER AutoBudget
BEFORE INSERT ON invoice
FOR EACH ROW
BEGIN
    DECLARE area_code VARCHAR(10);
    DECLARE budget_month INT;
    DECLARE budget_year INT;
    DECLARE invoice_month INT;
    DECLARE invoice_year INT;
    DECLARE current_budget DECIMAL(12, 2);

    SELECT area INTO area_code
    FROM orders
    WHERE num = (SELECT order_num FROM request WHERE num = NEW.request);

    SET invoice_month = MONTH(NEW.payDate);
    SET invoice_year = YEAR(NEW.payDate);

    SELECT budgetRemain, budgetMonth, budgetYear INTO current_budget, budget_month, budget_year
    FROM budget
    WHERE area = area_code AND budgetMonth = invoice_month AND budgetYear = invoice_year;

    IF budget_month IS NULL OR budget_year IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No matching budget found for this invoice period.';
    ELSEIF current_budget >= NEW.amount THEN
        UPDATE budget
        SET budgetRemain = budgetRemain - NEW.amount
        WHERE area = area_code AND budgetMonth = invoice_month AND budgetYear = invoice_year;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient budget to cover this invoice.';
    END IF;
END $$

/********************** PROCEDURES ***********************/
DELIMITER $$
CREATE PROCEDURE Sp_RegistrarEmpleado(
    IN firstName VARCHAR(100), IN lastName VARCHAR(100),
    IN surName VARCHAR(100), IN numTel VARCHAR(20),
    IN email VARCHAR(100), IN charge VARCHAR(10), IN area VARCHAR(10)
)
BEGIN
    INSERT INTO employee (firstName, lastName, surname, numTel, email, charge, area)
    VALUES (firstName, lastName, surName, numTel, email, charge, area);
END$$
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
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
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
    CREATE VIEW vw_employee AS
    SELECT
        e.num AS num,
        CONCAT(
            IFNULL(e.firstName, ''), ' ',
            IFNULL(e.lastName, ''), ' ',
            IFNULL(e.surname, '')
        ) AS name,
        e.status AS status,
        e.numTel AS numTel,
        e.email AS email,
        c.name AS charge,
        a.name AS area
    FROM employee AS e
    INNER JOIN charge AS c ON e.charge = c.code
    INNER JOIN area AS a ON e.area = a.code;


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
('PA3', 'Production Area 3', NULL);

-- Charge
INSERT INTO charge (code, name) VALUES
('MNGR', 'Manager'),
('WRKR', 'Worker');

-- Employee
INSERT INTO employee (firstName, lastName, surname, status, numTel, email, charge, area) VALUES
('Carlos', 'Gómez', 'Pérez', TRUE, '5551234561', 'carlos.gomez@gmail.com', 'MNGR', 'RH'),
('Laura', 'Fernández', NULL, TRUE, '5551234562', 'laura.fernandez@gmail.com', 'MNGR', 'PR'),
('José', 'Martínez', NULL, TRUE, '5551234563', 'jose.martinez@gmail.com', 'MNGR', 'ST'),
('Lucía', 'Sánchez', NULL, TRUE, '5551234564', 'lucia.sanchez@gmail.com', 'MNGR', 'PA1'),
('David', 'López', NULL, TRUE, '5551234565', 'david.lopez@gmail.com', 'MNGR', 'PA2'),
('Elena', 'García', NULL, TRUE, '5551234566', 'elena.garcia@gmail.com', 'MNGR', 'PA3'),
('Ana', 'Martínez', NULL, TRUE, '5552345678', 'ana.martinez@gmail.com', 'WRKR', 'PA1'),
('Mario', 'Pérez', NULL, TRUE, '5552345679', 'mario.perez@gmail.com', 'WRKR', 'PA2'),
('Clara', 'Núñez', NULL, TRUE, '5552345680', 'clara.nunez@gmail.com', 'WRKR', 'PA3'),
('Pedro', 'González', NULL, TRUE, '5552345681', 'pedro.gonzalez@gmail.com', 'WRKR', 'RH'),
('Sara', 'Hernández', NULL, TRUE, '5552345682', 'sara.hernandez@gmail.com', 'WRKR', 'PR'),
('Luis', 'Ortiz', NULL, FALSE, '5552345683', 'luis.ortiz@gmail.com', 'WRKR', 'PA1'),
('Eva', 'Morales', NULL, FALSE, '5552345684', 'eva.morales@gmail.com', 'WRKR', 'PA2'),
('Javier', 'Ruiz', NULL, FALSE, '5552345685', 'javier.ruiz@gmail.com', 'WRKR', 'PA3'),
('Miguel', 'Domínguez', NULL, TRUE, '5552345690', 'miguel.dominguez@gmail.com', 'WRKR', 'RH'),
('Lucía', 'Alvarez', NULL, FALSE, '5552345691', 'lucia.alvarez@gmail.com', 'WRKR', 'RH'),
('Roberto', 'Torres', NULL, TRUE, '5552345692', 'roberto.torres@gmail.com', 'WRKR', 'PR'),
('Paula', 'Jiménez', NULL, FALSE, '5552345693', 'paula.jimenez@gmail.com', 'WRKR', 'PR'),
('Carmen', 'Mendoza', NULL, TRUE, '5552345694', 'carmen.mendoza@gmail.com', 'WRKR', 'ST'),
('Jorge', 'Navarro', NULL, FALSE, '5552345695', 'jorge.navarro@gmail.com', 'WRKR', 'ST'),
('Andrea', 'Ríos', NULL, TRUE, '5552345696', 'andrea.rios@gmail.com', 'WRKR', 'PA1'),
('Victor', 'Delgado', NULL, FALSE, '5552345697', 'victor.delgado@gmail.com', 'WRKR', 'PA1'),
('Marta', 'Iglesias', NULL, TRUE, '5552345698', 'marta.iglesias@gmail.com', 'WRKR', 'PA2'),
('Samuel', 'Ortiz', NULL, FALSE, '5552345699', 'samuel.ortiz@gmail.com', 'WRKR', 'PA2'),
('Rafael', 'Silva', NULL, TRUE, '5552345700', 'rafael.silva@gmail.com', 'WRKR', 'PA3'),
('Adriana', 'Reyes', NULL, FALSE, '5552345701', 'adriana.reyes@gmail.com', 'WRKR', 'PA3');


-- Raw Material
INSERT INTO raw_material (code, name, description, weight, stock, category) VALUES
('CAP003', 'Ceramic Capacitor 10uF', 'General purpose capacitor for filtering', 0.00, 1000, 'CAP'),
('CON005', 'USB Connector', 'Standard USB connector type-A', 0.01, 300, 'CON'),
('IC0002', 'Microcontroller', '8-bit Microcontroller for embedded applications', 0.01, 200, 'IC'),
('PCB001', 'PCB 2-layer', 'Standard 2-layer PCB for general applications', 0.05, 500, 'PCB'),
('RES004', 'Resistor 100 Ohm', 'General purpose resistor 100 Ohm 1/4W', 0.00, 1500, 'RES'),
('CAP006', 'Ceramic Capacitor 22uF', 'High capacitance for filtering', 0.00, 800, 'CAP'),
('CON008', 'HDMI Connector', 'Standard HDMI connector for video/audio', 0.02, 400, 'CON'),
('IC0030', 'ARM Cortex-M0', '32-bit microcontroller for IoT applications', 0.01, 100, 'IC'),
('PCB002', 'PCB 4-layer', '4-layer PCB for advanced designs', 0.07, 300, 'PCB'),
('RES010', 'Resistor 1k Ohm', 'General purpose resistor 1k Ohm 1/2W', 0.00, 1200, 'RES'),
('LED001', 'LED 5mm Red', 'Standard red LED for indicators', 0.00, 1000, 'LED'),
('TRN002', 'NPN Transistor', 'General purpose NPN transistor', 0.01, 700, 'TRN'),
('DIO003', 'Schottky Diode', 'High-speed switching diode', 0.01, 600, 'DIO');

-- Provider
INSERT INTO provider (fiscal_name, email, numTel) VALUES
('ElectroComp Distributors', 'sales@electrocomp.com', '6647891234'),
('CircuitTech Solutions', 'info@circuittech.com', '6643216789'),
('ComponentWorld Inc.', 'orders@componentworld.com', '6649876543'),
('MicroElectronics Ltd.', 'support@microelectronics.com', '6645674321'),
('GlobalTech Supplies', 'contact@globaltechsupplies.com', '6641234567'),
('PrecisionParts Co.', 'info@precisionparts.com', '6644567890');

-- Raw Provider
INSERT INTO raw_provider (provider, material, price) VALUES
(1, 'CAP003', 0.10),
(2, 'CAP003', 0.11),
(3, 'CAP003', 0.09),
(1, 'CON005', 0.50),
(2, 'CON005', 0.52),
(4, 'CON005', 0.48),
(3, 'IC0002', 3.00),
(5, 'IC0002', 3.10),
(6, 'IC0002', 2.95),
(2, 'PCB001', 1.50),
(4, 'PCB001', 1.55),
(5, 'PCB001', 1.48),
(1, 'RES004', 0.05),
(3, 'RES004', 0.06),
(6, 'RES004', 0.04),
(2, 'CAP006', 0.15),
(4, 'CAP006', 0.16),
(5, 'CAP006', 0.14),
(1, 'CON008', 0.75),
(3, 'CON008', 0.78),
(6, 'CON008', 0.73),
(2, 'IC0030', 5.50),
(4, 'IC0030', 5.60),
(5, 'IC0030', 5.45),
(3, 'PCB002', 2.00),
(5, 'PCB002', 2.05),
(6, 'PCB002', 1.98),
(1, 'RES010', 0.10),
(2, 'RES010', 0.11),
(4, 'RES010', 0.09),
(3, 'LED001', 0.25),
(5, 'LED001', 0.26),
(6, 'LED001', 0.24),
(1, 'TRN002', 0.90),
(2, 'TRN002', 0.92),
(4, 'TRN002', 0.88),
(3, 'DIO003', 0.20),
(5, 'DIO003', 0.21),
(6, 'DIO003', 0.19);

-- Budget
INSERT INTO budget (code, initialAmount, budgetRemain, budgetMonth, budgetYear, area) VALUES
('BRH-1', 250000.00, 250000.00, MONTH(CURRENT_DATE), YEAR(CURRENT_DATE), 'RH');

INSERT INTO budget (code, initialAmount, budgetRemain, budgetMonth, budgetYear, area) VALUES
('BPA1-1', 25000.00, 25000.00, MONTH(CURRENT_DATE), YEAR(CURRENT_DATE), 'PA1'),
('BPA2-1', 25000.00, 25000.00, MONTH(CURRENT_DATE), YEAR(CURRENT_DATE), 'PA2'),
('BPA3-1', 25000.00, 25000.00, MONTH(CURRENT_DATE), YEAR(CURRENT_DATE), 'PA3');

INSERT INTO budget (code, initialAmount, budgetRemain, budgetMonth, budgetYear, area) VALUES
('BPA1-2', 25000.00, 8000.00, 10, 2024, 'PA1'),
('BPA2-2', 25000.00, 4000.00, 10, 2024, 'PA2'),
('BPA3-2', 25000.00, 1000.00, 10, 2024, 'PA3'),
('BPA3-3', 25000.00, 25000.00, 12, 2024, 'PA3');

DELIMITER $$
CREATE TRIGGER AutoInvoice
AFTER INSERT ON request_material
FOR EACH ROW
BEGIN
    DECLARE total_amount DECIMAL(12, 2);
    DECLARE generated_folio VARCHAR(20);
    DECLARE invoice_date DATE;
    DECLARE provider_id INT;

    -- Calcular el monto total
    SELECT SUM(amount) INTO total_amount
    FROM request_material
    WHERE request = NEW.request;

    -- Obtener la fecha de la solicitud
    SELECT request_date INTO invoice_date
    FROM request
    WHERE num = NEW.request;

    -- Obtener el proveedor relacionado
    SELECT provider INTO provider_id
    FROM request_provider
    WHERE request = NEW.request;

    -- Generar el folio de la factura
    SET generated_folio = CONCAT(
        'F', NEW.request,
        LPAD(DAY(invoice_date), 2, '0'),
        LPAD(MONTH(invoice_date), 2, '0'),
        RIGHT(YEAR(invoice_date), 2)
    );

    -- Insertar en la tabla invoice
    INSERT INTO invoice (folio, amount, subtotal, iva, payDate, request, provider)
    VALUES (
        generated_folio,
        total_amount + (total_amount * 0.16),
        total_amount,
        total_amount * 0.16,
        invoice_date,
        NEW.request,
        provider_id
    );
END$$

DELIMITER $$
CREATE TRIGGER AutoBudget
BEFORE INSERT ON invoice
FOR EACH ROW
BEGIN
    DECLARE area_code VARCHAR(10);
    DECLARE budget_month INT;
    DECLARE budget_year INT;
    DECLARE invoice_month INT;
    DECLARE invoice_year INT;
    DECLARE current_budget DECIMAL(12, 2);

    -- Obtener el área asociada con el pedido
    SELECT area INTO area_code
    FROM orders
    WHERE num = (SELECT order_num FROM request WHERE num = NEW.request);

    -- Calcular el mes y el año de la factura
    SET invoice_month = MONTH(NEW.payDate);
    SET invoice_year = YEAR(NEW.payDate);

    -- Validar y actualizar el presupuesto
    SELECT budgetRemain, budgetMonth, budgetYear INTO current_budget, budget_month, budget_year
    FROM budget
    WHERE area = area_code AND budgetMonth = invoice_month AND budgetYear = invoice_year;

    IF budget_month IS NULL OR budget_year IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No matching budget found for this invoice period.';
    ELSEIF current_budget >= NEW.amount THEN
        UPDATE budget
        SET budgetRemain = budgetRemain - NEW.amount
        WHERE area = area_code AND budgetMonth = invoice_month AND budgetYear = invoice_year;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient budget to cover this invoice.';
    END IF;
END$$

DELIMITER $$
CREATE TRIGGER ValidateRequestProvider
BEFORE INSERT ON request_provider
FOR EACH ROW
BEGIN
    DECLARE provider_exists INT;

    -- Verificar que el proveedor exista
    SELECT COUNT(*) INTO provider_exists
    FROM provider
    WHERE num = NEW.provider;

    IF provider_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Provider does not exist.';
    END IF;
END$$

DELIMITER $$
CREATE TRIGGER AutoInvoice
AFTER INSERT ON request_material
FOR EACH ROW
BEGIN
    -- Declaración de variables
    DECLARE total_amount DECIMAL(12, 2);
    DECLARE generated_folio VARCHAR(20);
    DECLARE invoice_date DATE;
    DECLARE provider_id INT;

    -- Cursor para iterar sobre los proveedores relacionados con la solicitud
    DECLARE provider_cursor CURSOR FOR
    SELECT provider
    FROM request_provider
    WHERE request = NEW.request;

    -- Variable de control para el cursor
    DECLARE done INT DEFAULT FALSE;

    -- Manejo del final del cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done


DELIMITER $$
CREATE TRIGGER AutoInvoice
AFTER INSERT ON request_material
FOR EACH ROW
BEGIN
    DECLARE total_amount DECIMAL(12, 2);
    DECLARE generated_folio VARCHAR(20);
    DECLARE invoice_date DATE;
    DECLARE provider_id INT;
    DECLARE done INT DEFAULT 0;
    DECLARE cur_providers CURSOR FOR 
        SELECT provider 
        FROM request_provider 
        WHERE request = NEW.request;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Obtener la fecha de la solicitud
    SELECT request_date INTO invoice_date
    FROM request
    WHERE num = NEW.request;

    -- Cursor para iterar sobre los proveedores
    OPEN cur_providers;
    read_loop: LOOP
        FETCH cur_providers INTO provider_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Calcular el monto total para el proveedor actual
        SELECT SUM(amount) INTO total_amount
        FROM request_material
        WHERE request = NEW.request;

        -- Generar el folio para la factura
        SET generated_folio = CONCAT(
            'F', NEW.request,
            LPAD(DAY(invoice_date), 2, '0'),
            LPAD(MONTH(invoice_date), 2, '0'),
            RIGHT(YEAR(invoice_date), 2),
            '-', provider_id
        );

        -- Crear la factura para el proveedor actual
        INSERT INTO invoice (folio, amount, subtotal, iva, payDate, request, provider)
        VALUES (
            generated_folio,
            total_amount + (total_amount * 0.16),
            total_amount,
            total_amount * 0.16,
            invoice_date,
            NEW.request,
            provider_id
        );
    END LOOP;

    CLOSE cur_providers;
END$$
