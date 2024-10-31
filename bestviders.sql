CREATE DATABASE bestviders;
use bestviders;
CREATE TABLE providers(
    num INT AUTO_INCREMENT PRIMARY KEY,
    fiscalName VARCHAR(25) NOT NULL,
    email VARCHAR(30) NOT NULL,
    numTel  VARCHAR(10) NOT NULL
)
CREATE TABLE area(
    code VARCHAR(4) PRIMARY KEY NOT NULL,
    name VARCHAR(20) NOT NULL,
    manager
)

CREATE TABLE employee(
    num INT AUTO_INCREMENT PRIMARY KEY,
    firstname  VARCHAR(20) NOT NULL,
    lastname  VARCHAR(20) NOT NULL,
    surname VARCHAR(20) NOT NULL,
    email VARCHAR(30) NOT NULL,
    numTel  VARCHAR(10) NOT NULL,
    manager INT NOT NULL,
    user INT NOT NULL,
    charge VARCHAR(3)  NOT NULL,
    area VARCHAR(4) NOT NULL
)