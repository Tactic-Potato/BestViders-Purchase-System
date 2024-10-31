-- Creación de la base de datos
CREATE DATABASE IF NOT EXISTS BestViders;
DROP DATABASE BestViders;
-- Creación de las tablas sin relaciones

-- Tabla CATEGORY
CREATE TABLE CATEGORY (
    code CHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    descrp TEXT
);

-- Tabla RAW_MATERIAL
CREATE TABLE RAW_MATERIAL (
    code CHAR(10) PRIMARY KEY,
    price DECIMAL(10, 2) NOT NULL,
    name VARCHAR(100) NOT NULL,
    descrp TEXT,
    weight DECIMAL(10, 2),
    stock INT,
    request CHAR(10),
    category CHAR(10)
);

-- Tabla PROVIDER
CREATE TABLE PROVIDER (
    num CHAR(10) PRIMARY KEY,
    fiscalName VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    numTel VARCHAR(15)
);

-- Tabla REQUEST
CREATE TABLE REQUEST (
    num CHAR(10) PRIMARY KEY,
    status VARCHAR(50),
    subtotal DECIMAL(10, 2),
    requestDate DATE,
    employee CHAR(10),
    provider CHAR(10)
);

-- Tabla REQUEST_MATERIAL (tabla intermedia entre REQUEST y RAW_MATERIAL)
CREATE TABLE REQUEST_MATERIAL (
    request CHAR(10),
    product CHAR(10),
    cant INT,
    amount DECIMAL(10, 2),
    PRIMARY KEY (request, product)
);

-- Tabla INVOICE
CREATE TABLE INVOICE (
    folio CHAR(10) PRIMARY KEY,
    amount DECIMAL(10, 2),
    payDate DATE,
    request CHAR(10),
    provider CHAR(10)
);

-- Tabla CHARGE
CREATE TABLE CHARGE (
    code CHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Tabla EMPLOYEE
CREATE TABLE EMPLOYEE (
    num CHAR(10) PRIMARY KEY,
    firstName VARCHAR(100) NOT NULL,
    lastName VARCHAR(100) NOT NULL,
    surname VARCHAR(100),
    status VARCHAR(50),
    numTel VARCHAR(15),
    email VARCHAR(100),
    manager CHAR(10),
    charge CHAR(10),
    area CHAR(10)
);

-- Tabla AREA
CREATE TABLE AREA (
    code CHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager CHAR(10)
);

-- Tabla USER
CREATE TABLE USER (
    num CHAR(10) PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL
);

-- Tabla BUDGET
CREATE TABLE BUDGET (
    code CHAR(10) PRIMARY KEY,
    initialAmount DECIMAL(10, 2),
    budgetRemain DECIMAL(10, 2),
    dateBudget DATE,
    area CHAR(10)
);

-- Tabla ORDER
CREATE TABLE `ORDER` (
    code CHAR(10) PRIMARY KEY,
    descrp TEXT,
    status VARCHAR(50),
    employee CHAR(10),
    request CHAR(10),
    rawMaterial CHAR(10)
);


-- Tabla AREAORDER (tabla intermedia entre AREA y ORDER)
CREATE TABLE AREAORDER (
    area CHAR(10),
    `order` CHAR(10),
    cant INT,
    PRIMARY KEY (area, `order`)
);


-- Tabla RECEPTION
CREATE TABLE RECEPTION (
    num CHAR(10) PRIMARY KEY,
    status VARCHAR(50),
    dateReception DATE,
    overations TEXT,
    numReception CHAR(10),
    missing INT,
    employee CHAR(10),
    request CHAR(10)
);

-- Agregar relaciones de claves foráneas

-- Relación en RAW_MATERIAL
ALTER TABLE RAW_MATERIAL
    ADD FOREIGN KEY (request) REFERENCES REQUEST(num),
    ADD FOREIGN KEY (category) REFERENCES CATEGORY(code);

-- Relación en REQUEST
ALTER TABLE REQUEST
    ADD FOREIGN KEY (employee) REFERENCES EMPLOYEE(num),
    ADD FOREIGN KEY (provider) REFERENCES PROVIDER(num);

-- Relación en REQUEST_MATERIAL
ALTER TABLE REQUEST_MATERIAL
    ADD FOREIGN KEY (request) REFERENCES REQUEST(num),
    ADD FOREIGN KEY (product) REFERENCES RAW_MATERIAL(code);

-- Relación en INVOICE
ALTER TABLE INVOICE
    ADD FOREIGN KEY (request) REFERENCES REQUEST(num),
    ADD FOREIGN KEY (provider) REFERENCES PROVIDER(num);

-- Relación en EMPLOYEE
ALTER TABLE EMPLOYEE
    ADD FOREIGN KEY (manager) REFERENCES EMPLOYEE(num),
    ADD FOREIGN KEY (charge) REFERENCES CHARGE(code),
    ADD FOREIGN KEY (area) REFERENCES AREA(code);

-- Relación en AREA
ALTER TABLE AREA
    ADD FOREIGN KEY (manager) REFERENCES EMPLOYEE(num);

-- Relación en USER
ALTER TABLE USER
    ADD FOREIGN KEY (num) REFERENCES EMPLOYEE(num);

-- Relación en BUDGET
ALTER TABLE BUDGET
    ADD FOREIGN KEY (area) REFERENCES AREA(code);

-- Relación en `ORDER`
ALTER TABLE `ORDER`
    ADD FOREIGN KEY (employee) REFERENCES EMPLOYEE(num),
    ADD FOREIGN KEY (request) REFERENCES REQUEST(num),
    ADD FOREIGN KEY (rawMaterial) REFERENCES RAW_MATERIAL(code);

-- Relación en AREAORDER
ALTER TABLE AREAORDER
    ADD FOREIGN KEY (area) REFERENCES AREA(code),
    ADD FOREIGN KEY (`order`) REFERENCES `ORDER`(code);

-- Relación en RECEPTION
ALTER TABLE RECEPTION
    ADD FOREIGN KEY (employee) REFERENCES EMPLOYEE(num),
    ADD FOREIGN KEY (request) REFERENCES REQUEST(num);

-- REGISTROS PARA PRUEBAS

-- Tabla CATEGORY (sin dependencias)
INSERT INTO CATEGORY (code, name, descrp) VALUES
('CAT01', 'Electronics', 'Electronic components and devices'),
('CAT02', 'Metals', 'Various types of metals and alloys'),
('CAT03', 'Plastics', 'Plastic materials and polymers');

-- Tabla PROVIDER (sin dependencias)
INSERT INTO PROVIDER (num, fiscalName, email, numTel) VALUES
('PROV01', 'ElectroSupply Inc.', 'contact@electrosupply.com', '123-456-7890'),
('PROV02', 'MetalWorks Ltd.', 'info@metalworks.com', '234-567-8901'),
('PROV03', 'PlasticHub', 'sales@plastichub.com', '345-678-9012');

-- Tabla CHARGE (sin dependencias)
INSERT INTO CHARGE (code, name) VALUES
('CHG01', 'Manager'),
('CHG02', 'Supervisor'),
('CHG03', 'Technician');

-- Tabla AREA (sin dependencias)
INSERT INTO AREA (code, name, manager) VALUES
('AREA01', 'Logistics', 'EMP01'),
('AREA02', 'Manufacturing', 'EMP02'),
('AREA03', 'Quality Control', 'EMP03');


-- Tabla EMPLOYEE (depende de CHARGE y AREA)
INSERT INTO EMPLOYEE (num, firstName, lastName, surname, status, numTel, email, manager, charge, area) VALUES
('EMP01', 'John', 'Doe', 'Smith', 'Active', '111-222-3333', 'johndoe@company.com', NULL, 'CHG01', 'AREA01'),
('EMP02', 'Jane', 'Roe', 'Johnson', 'Active', '222-333-4444', 'janeroe@company.com', 'EMP01', 'CHG02', 'AREA02'),
('EMP03', 'Jim', 'Beam', 'Brown', 'Inactive', '333-444-5555', 'jimbeam@company.com', 'EMP01', 'CHG03', 'AREA03');

-- Tabla USER (depende de EMPLOYEE)
INSERT INTO USER (num, username, password) VALUES
('EMP01', 'jdoe', 'password123'),
('EMP02', 'jroe', 'pass456'),
('EMP03', 'jbeam', 'pass789');

-- Tabla BUDGET (depende de AREA)
INSERT INTO BUDGET (code, initialAmount, budgetRemain, dateBudget, area) VALUES
('BUD01', 10000.00, 7500.00, '2024-01-01', 'AREA01'),
('BUD02', 15000.00, 13000.00, '2024-02-01', 'AREA02'),
('BUD03', 8000.00, 5000.00, '2024-03-01', 'AREA03');

-- Tabla REQUEST (depende de EMPLOYEE y PROVIDER)
INSERT INTO REQUEST (num, status, subtotal, requestDate, employee, provider) VALUES
('REQ01', 'Pending', 550.00, '2024-10-31', 'EMP01', 'PROV01'),
('REQ02', 'Approved', 1275.00, '2024-10-29', 'EMP02', 'PROV02'),
('REQ03', 'Pending', 820.00, '2024-10-30', 'EMP03', 'PROV03');

-- Tabla RAW_MATERIAL (depende de REQUEST y CATEGORY)
INSERT INTO RAW_MATERIAL (code, price, name, descrp, weight, stock, request, category) VALUES
('RM01', 5.50, 'Resistor', '1k ohm resistor', 0.001, 1000, 'REQ01', 'CAT01'),
('RM02', 12.75, 'Copper Wire', 'High-quality copper wire', 0.5, 500, 'REQ02', 'CAT02'),
('RM03', 8.20, 'Polymer Sheet', 'Durable plastic sheet', 1.2, 200, 'REQ03', 'CAT03');

-- Tabla ORDER (depende de EMPLOYEE, REQUEST y RAW_MATERIAL)
INSERT INTO `ORDER` (code, descrp, status, employee, request, rawMaterial) VALUES
('ORD01', 'Order for electronic components', 'Pending', 'EMP01', 'REQ01', 'RM01'),
('ORD02', 'Order for metal supplies', 'Approved', 'EMP02', 'REQ02', 'RM02'),
('ORD03', 'Order for plastic sheets', 'Pending', 'EMP03', 'REQ03', 'RM03');

-- Tabla AREAORDER (depende de AREA y ORDER)
INSERT INTO AREAORDER (area, `order`, cant) VALUES
('AREA01', 'ORD01', 100),
('AREA02', 'ORD02', 50),
('AREA03', 'ORD03', 100);

-- Tabla RECEPTION (depende de EMPLOYEE y REQUEST)
INSERT INTO RECEPTION (num, status, dateReception, overations, numReception, missing, employee, request) VALUES
('REC01', 'Complete', '2024-10-31', 'Received on time', 'R001', 0, 'EMP01', 'REQ01'),
('REC02', 'Partial', '2024-10-30', 'Some items missing', 'R002', 5, 'EMP02', 'REQ02'),
('REC03', 'Complete', '2024-10-29', 'Received in good condition', 'R003', 0, 'EMP03', 'REQ03');

-- Tabla REQUEST_MATERIAL (depende de REQUEST y RAW_MATERIAL)
INSERT INTO REQUEST_MATERIAL (request, product, cant, amount) VALUES
('REQ01', 'RM01', 100, 550.00),
('REQ02', 'RM02', 50, 1275.00),
('REQ03', 'RM03', 100, 820.00);

-- Tabla INVOICE (depende de REQUEST y PROVIDER)
INSERT INTO INVOICE (folio, amount, payDate, request, provider) VALUES
('INV001', 550.00, '2024-11-01', 'REQ01', 'PROV01'),
('INV002', 1275.00, '2024-11-02', 'REQ02', 'PROV02'),
('INV003', 820.00, '2024-11-03', 'REQ03', 'PROV03');
