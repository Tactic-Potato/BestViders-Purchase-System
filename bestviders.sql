CREATE DATABASE BestViders;
USE BestViders;

CREATE TABLE CATEGORY (
    code CHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    descrp TEXT
);

CREATE TABLE PROVIDER (
    num CHAR(10) PRIMARY KEY,
    fiscalName VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    numTel VARCHAR(15)
);

CREATE TABLE CHARGE (
    code CHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE AREA (
    code CHAR(10) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    manager CHAR(10)
);

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
    area CHAR(10),
    FOREIGN KEY (manager) REFERENCES EMPLOYEE(num),
    FOREIGN KEY (charge) REFERENCES CHARGE(code),
    FOREIGN KEY (area) REFERENCES AREA(code)
);

CREATE TABLE REQUEST (
    num CHAR(10) PRIMARY KEY,
    status VARCHAR(50),
    subtotal DECIMAL(10, 2),
    requestDate DATE,
    employee CHAR(10),
    provider CHAR(10),
    FOREIGN KEY (employee) REFERENCES EMPLOYEE(num),
    FOREIGN KEY (provider) REFERENCES PROVIDER(num)
);

CREATE TABLE RAW_MATERIAL (
    code CHAR(10) PRIMARY KEY,
    price DECIMAL(10, 2) NOT NULL,
    name VARCHAR(100) NOT NULL,
    descrp TEXT,
    weight DECIMAL(10, 2),
    stock INT,
    request CHAR(10),
    category CHAR(10),
    FOREIGN KEY (request) REFERENCES REQUEST(num),
    FOREIGN KEY (category) REFERENCES CATEGORY(code)
);

CREATE TABLE REQUEST_MATERIAL (
    request CHAR(10),
    product CHAR(10),
    cant INT,
    amount DECIMAL(10, 2),
    PRIMARY KEY (request, product),
    FOREIGN KEY (request) REFERENCES REQUEST(num),
    FOREIGN KEY (product) REFERENCES RAW_MATERIAL(code)
);

CREATE TABLE INVOICE (
    folio CHAR(10) PRIMARY KEY,
    amount DECIMAL(10, 2),
    payDate DATE,
    request CHAR(10),
    provider CHAR(10),
    FOREIGN KEY (request) REFERENCES REQUEST(num),
    FOREIGN KEY (provider) REFERENCES PROVIDER(num)
);

CREATE TABLE USER (
    num CHAR(10) PRIMARY KEY,
    username VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    FOREIGN KEY (num) REFERENCES EMPLOYEE(num)
);

CREATE TABLE BUDGET (
    code CHAR(10) PRIMARY KEY,
    initialAmount DECIMAL(10, 2),
    budgetRemain DECIMAL(10, 2),
    dateBudget DATE,
    area CHAR(10),
    FOREIGN KEY (area) REFERENCES AREA(code)
);

CREATE TABLE `ORDER` (
    code CHAR(10) PRIMARY KEY,
    descrp TEXT,
    status VARCHAR(50),
    employee CHAR(10),
    request CHAR(10),
    rawMaterial CHAR(10),
    FOREIGN KEY (employee) REFERENCES EMPLOYEE(num),
    FOREIGN KEY (request) REFERENCES REQUEST(num),
    FOREIGN KEY (rawMaterial) REFERENCES RAW_MATERIAL(code)
);

CREATE TABLE AREAORDER (
    area CHAR(10),
    `order` CHAR(10),
    cant INT,
    PRIMARY KEY (area, `order`),
    FOREIGN KEY (area) REFERENCES AREA(code),
    FOREIGN KEY (`order`) REFERENCES `ORDER`(code)
);

CREATE TABLE RECEPTION (
    num CHAR(10) PRIMARY KEY,
    status VARCHAR(50),
    dateReception DATE,
    overations TEXT,
    numReception CHAR(10),
    missing INT,
    employee CHAR(10),
    request CHAR(10),
    FOREIGN KEY (employee) REFERENCES EMPLOYEE(num),
    FOREIGN KEY (request) REFERENCES REQUEST(num)
);

DELIMITER $$

CREATE TRIGGER CreateUser
AFTER INSERT ON EMPLOYEE
FOR EACH ROW
BEGIN
    DECLARE Username VARCHAR(100);
    SET Username = CONCAT(NEW.firstName, ' ', NEW.lastName, ' ', IFNULL(NEW.surname, ''));

    INSERT INTO USER (num, username, password)
    VALUES (NEW.num, Username, '1234567890');
END $$

-- Asegúrate de tener registros en las tablas CHARGE, AREA, y un registro inicial en EMPLOYEE para el manager.

-- Insertar un registro en la tabla CHARGE (si aún no tienes uno)
INSERT INTO CHARGE (code, name) VALUES ('C001', 'Manager');

-- Insertar un registro en la tabla AREA (si aún no tienes uno)
INSERT INTO AREA (code, name, manager) VALUES ('A001', 'Human Resources', NULL);

-- Insertar un registro inicial en la tabla EMPLOYEE (para usarlo como manager)
INSERT INTO EMPLOYEE (num, firstName, lastName, surname, status, numTel, email, manager, charge, area)
VALUES ('E0001', 'John', 'Doe', 'Smith', 'Active', '1234567890', 'john.doe@example.com', NULL, 'C001', 'A001');

-- Ahora, puedes insertar un nuevo empleado que tenga un manager, un cargo y un área asignados
INSERT INTO EMPLOYEE (num, firstName, lastName, surname, status, numTel, email, manager, charge, area)
VALUES ('E0002', 'Jane', 'Roe', 'Johnson', 'Active', '0987654321', 'jane.roe@example.com', 'E0001', 'C001', 'A001');

select * from employee

INSERT INTO AREA (code, name, manager) VALUES ('A002', 'Purchasing', NULL);
INSERT INTO AREA (code, name, manager) VALUES ('A003', 'Store', NULL);

INSERT INTO EMPLOYEE (num, firstName, lastName, surname, status, numTel, email, manager, charge, area)
VALUES ('E0003', 'Carlos', 'Ballarta', 'Nose', 'Active', '2189203', 'Carlo.Mr@example.com', NULL , 'C001', 'A002');