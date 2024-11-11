-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 08-11-2024 a las 16:39:21
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `bestviders`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `area`
--

CREATE TABLE `area` (
  `code` char(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `manager` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `area`
--

INSERT INTO `area` (`code`, `name`, `manager`) VALUES
('PD', 'Production Department', NULL),
('PR', 'Purchasing Department', NULL),
('RH', 'Human Resources', NULL),
('ST', 'Store', NULL),
('SV', 'Supervisor', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `areaorder`
--

CREATE TABLE `areaorder` (
  `area` char(10) NOT NULL,
  `order` int(11) NOT NULL,
  `cant` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `budget`
--

CREATE TABLE `budget` (
  `code` char(10) NOT NULL,
  `initialAmount` decimal(10,2) DEFAULT NULL,
  `budgetRemain` decimal(10,2) DEFAULT NULL,
  `dateBudget` date DEFAULT NULL,
  `area` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `budget`
--

INSERT INTO `budget` (`code`, `initialAmount`, `budgetRemain`, `dateBudget`, `area`) VALUES
('BGT001', 10000.00, 8500.00, '2023-01-15', 'RH'),
('BGT002', 20000.00, 19500.00, '2023-02-01', 'PR'),
('BGT003', 15000.00, 14000.00, '2023-03-10', 'ST');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `category`
--

CREATE TABLE `category` (
  `code` char(10) NOT NULL,
  `name` varchar(100) NOT NULL,
  `descrp` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `category`
--

INSERT INTO `category` (`code`, `name`, `descrp`) VALUES
('CAP', 'Capacitors', 'Components used for storing electrical energy.'),
('CON', 'Connectors', 'Various connectors for PCBs and circuits.'),
('IC', 'Integrated Circuits', 'Semiconductor chips for various functionalities.'),
('PCB', 'Printed Circuit Boards', 'Base material for creating circuit boards.'),
('RES', 'Resistors', 'Components used to limit the flow of current.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `charge`
--

CREATE TABLE `charge` (
  `code` char(10) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `charge`
--

INSERT INTO `charge` (`code`, `name`) VALUES
('MAN', 'Manager'),
('SUP', 'Supervisor'),
('WOK', 'Worker');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `employee`
--

CREATE TABLE `employee` (
  `num` int(11) NOT NULL,
  `firstName` varchar(100) NOT NULL,
  `lastName` varchar(100) NOT NULL,
  `surname` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `numTel` varchar(15) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `manager` int(11) DEFAULT NULL,
  `charge` char(10) DEFAULT NULL,
  `area` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `employee`
--

INSERT INTO `employee` (`num`, `firstName`, `lastName`, `surname`, `status`, `numTel`, `email`, `manager`, `charge`, `area`) VALUES
(1, 'Juan', 'Pérez', 'García', 'Active', '5551234567', 'juan.perez@gmail.com', NULL, 'MAN', 'RH'),
(2, 'Ana', 'Gómez', 'López', 'Active', '5559876543', 'ana.gomez@gmail.com', 1, 'WOK', 'RH'),
(3, 'Marta', 'Rodríguez', 'Cano', 'Active', '5554567891', 'marta.rodriguez@gmail.com', NULL, 'MAN', 'RH'),
(4, 'Carlos', 'Sánchez', 'Moreno', 'Active', '5557891234', 'carlos.sanchez@gmail.com', 3, 'WOK', 'ST'),
(5, 'Oscar', 'Soto', 'Garcia', 'Active', '66489632145', 'OscarS@gmail.com', 1, 'WOK', 'PR'),
(6, 'Alejandro', 'Diaz', 'Cervantes', 'Active', '6445234569', 'Almejandro@gmail.com', 3, 'WOK', 'PR'),
(7, 'Daniel', 'Martinez', 'Bustamante', 'Active', '6642564589', 'Danielon@gmail.com', NULL, 'MAN', 'RH'),
(8, 'Brian', 'Becerra', 'Sanchez', 'Active', '6645286459', 'BrianBS@gmail.com', 3, 'WOK', 'PR'),
(9, 'Nacho', 'Diaz', 'Reyes', 'Active', '66458923', 'NachosConQueso@gmail.com', 7, 'WOK', 'PR');

--
-- Disparadores `employee`
--
DELIMITER $$
CREATE TRIGGER `CreateUser` AFTER INSERT ON `employee` FOR EACH ROW BEGIN
    DECLARE Username VARCHAR(100);
    SET Username = CONCAT(NEW.firstName, ' ', NEW.lastName, ' ', IFNULL(NEW.surname, ''));

    INSERT INTO USER (num, username, password)
    VALUES (NEW.num, Username, '1234567890');
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `StatusAuto` BEFORE INSERT ON `employee` FOR EACH ROW BEGIN
        IF NEW.status IS NULL THEN
        SET NEW.status = 'Active';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `order`
--

CREATE TABLE `order` (
  `num` int(11) NOT NULL,
  `descrp` text DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `employee` int(11) DEFAULT NULL,
  `rawMaterial` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `order`
--

INSERT INTO `order` (`num`, `descrp`, `status`, `employee`, `rawMaterial`) VALUES
(1, 'We need 280 USB Connectors to be able to continue with the Production Order for the creation of 100 Laptop frames.', 'Received', 4, 'CON005'),
(2, 'We need 100 Resistors for ongoing projects', 'Received', 4, 'RES004'),
(3, 'Order for 500 Ceramic Capacitors for storage', 'Received', 2, 'CAP003'),
(4, 'PCB order to replace damaged units', 'Received', 3, 'PCB001'),
(5, 'Order for 150 Microcontrollers for new project', 'Received', 1, 'IC002'),
(6, 'USB Connectors needed for assembly', 'Received', 2, 'CON005'),
(7, '10 Keybords', NULL, 2, 'IC002');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provider`
--

CREATE TABLE `provider` (
  `num` int(11) NOT NULL,
  `fiscalName` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `numTel` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `provider`
--

INSERT INTO `provider` (`num`, `fiscalName`, `email`, `numTel`) VALUES
(1, 'ElectroComponents Inc.', 'contact@electrocomponents.com', '5551122334'),
(2, 'TechParts Ltd.', 'support@techparts.com', '5552233445'),
(3, 'PrecisionCircuits', 'sales@precisioncircuits.com', '5553344556'),
(4, 'AdvancedMaterials Co.', 'info@advancedmaterials.com', '5554455667');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `raw_material`
--

CREATE TABLE `raw_material` (
  `code` char(10) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `name` varchar(100) NOT NULL,
  `descrp` text DEFAULT NULL,
  `weight` decimal(10,2) DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `category` char(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `raw_material`
--

INSERT INTO `raw_material` (`code`, `price`, `name`, `descrp`, `weight`, `stock`, `category`) VALUES
('CAP003', 0.10, 'Ceramic Capacitor 10uF', 'General purpose capacitor for filtering', 0.00, 1000, 'CAP'),
('CON005', 0.50, 'USB Connector', 'Standard USB connector type-A', 0.01, 300, 'CON'),
('IC002', 3.00, 'Microcontroller', '8-bit Microcontroller for embedded applications', 0.01, 200, 'IC'),
('PCB001', 1.50, 'PCB 2-layer', 'Standard 2-layer PCB for general applications', 0.05, 500, 'PCB'),
('RES004', 0.05, 'Resistor 100 Ohm', 'General purpose resistor 100 Ohm 1/4W', 0.00, 1500, 'RES');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reception`
--

CREATE TABLE `reception` (
  `num` int(11) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `dateReception` date DEFAULT NULL,
  `overations` text DEFAULT NULL,
  `numReception` int(11) DEFAULT NULL,
  `missing` int(11) DEFAULT NULL,
  `employee` int(11) DEFAULT NULL,
  `request` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `request`
--

CREATE TABLE `request` (
  `num` int(11) NOT NULL,
  `status` varchar(50) DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  `requestDate` date DEFAULT NULL,
  `employee` int(11) DEFAULT NULL,
  `provider` int(11) DEFAULT NULL,
  `order` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `request`
--

INSERT INTO `request` (`num`, `status`, `subtotal`, `requestDate`, `employee`, `provider`, `order`) VALUES
(1, 'In Progress', 145.00, '2024-11-06', 4, 1, 1),
(2, 'In Progress', 50.00, '2024-11-06', 4, 1, 2),
(3, 'In Progress', 225.00, '2024-11-06', 2, 2, 3),
(4, 'In Progress', 225.00, '2024-11-06', 3, 3, 4),
(5, 'In Progress', 75.00, '2024-11-06', 1, 4, 5),
(6, 'In Progress', 100.00, '2024-11-06', 3, 2, 6);

--
-- Disparadores `request`
--
DELIMITER $$
CREATE TRIGGER `UpdateOrderStatus` AFTER INSERT ON `request` FOR EACH ROW BEGIN
    IF NEW.`order` IS NOT NULL THEN
        UPDATE `ORDER`
        SET status = 'Received'
        WHERE num = NEW.`order`;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `request_material`
--

CREATE TABLE `request_material` (
  `request` int(11) NOT NULL,
  `product` char(10) NOT NULL,
  `cant` int(11) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `request_material`
--

INSERT INTO `request_material` (`request`, `product`, `cant`, `amount`) VALUES
(1, 'CON005', 280, 140.00),
(2, 'RES004', 100, 5.00),
(3, 'CAP003', 500, 0.10),
(4, 'PCB001', 150, 1.50),
(5, 'IC002', 75, 3.00),
(6, 'CON005', 200, 100.00);

--
-- Disparadores `request_material`
--
DELIMITER $$
CREATE TRIGGER `UpdateRequestSubtotal` AFTER INSERT ON `request_material` FOR EACH ROW BEGIN
    DECLARE total DECIMAL(10, 2);

    
    SELECT SUM(cant * price)
    INTO total
    FROM REQUEST_MATERIAL RM
    JOIN RAW_MATERIAL M ON RM.product = M.code
    WHERE RM.request = NEW.request;

    
    UPDATE REQUEST
    SET subtotal = total
    WHERE num = NEW.request;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `user`
--

CREATE TABLE `user` (
  `num` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `user`
--

INSERT INTO `user` (`num`, `username`, `password`) VALUES
(1, 'Juan Pérez García', 'Bethoven'),
(2, 'Ana Gómez López', '1234567890'),
(3, 'Marta Rodríguez Cano', '1234567890'),
(4, 'Carlos Sánchez Moreno', '1234567890'),
(5, 'Oscar Soto Garcia', '1234567890'),
(6, 'Alejandro Diaz Cervantes', '1234567890'),
(7, 'Daniel Martinez Bustamante', '1234567890'),
(8, 'Brian Becerra Sanchez', 'Becerra'),
(9, 'Nacho Diaz Reyes', '1234567890');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`code`),
  ADD KEY `manager` (`manager`);

--
-- Indices de la tabla `areaorder`
--
ALTER TABLE `areaorder`
  ADD PRIMARY KEY (`area`,`order`),
  ADD KEY `order` (`order`);

--
-- Indices de la tabla `budget`
--
ALTER TABLE `budget`
  ADD PRIMARY KEY (`code`),
  ADD KEY `area` (`area`);

--
-- Indices de la tabla `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`code`);

--
-- Indices de la tabla `charge`
--
ALTER TABLE `charge`
  ADD PRIMARY KEY (`code`);

--
-- Indices de la tabla `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`num`),
  ADD KEY `area` (`area`);

--
-- Indices de la tabla `order`
--
ALTER TABLE `order`
  ADD PRIMARY KEY (`num`),
  ADD KEY `employee` (`employee`),
  ADD KEY `rawMaterial` (`rawMaterial`);

--
-- Indices de la tabla `provider`
--
ALTER TABLE `provider`
  ADD PRIMARY KEY (`num`);

--
-- Indices de la tabla `raw_material`
--
ALTER TABLE `raw_material`
  ADD PRIMARY KEY (`code`),
  ADD KEY `category` (`category`);

--
-- Indices de la tabla `reception`
--
ALTER TABLE `reception`
  ADD PRIMARY KEY (`num`),
  ADD KEY `employee` (`employee`),
  ADD KEY `request` (`request`);

--
-- Indices de la tabla `request`
--
ALTER TABLE `request`
  ADD PRIMARY KEY (`num`),
  ADD KEY `employee` (`employee`),
  ADD KEY `provider` (`provider`),
  ADD KEY `order` (`order`);

--
-- Indices de la tabla `request_material`
--
ALTER TABLE `request_material`
  ADD PRIMARY KEY (`request`,`product`),
  ADD KEY `product` (`product`);

--
-- Indices de la tabla `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`num`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `employee`
--
ALTER TABLE `employee`
  MODIFY `num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de la tabla `order`
--
ALTER TABLE `order`
  MODIFY `num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT de la tabla `provider`
--
ALTER TABLE `provider`
  MODIFY `num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `reception`
--
ALTER TABLE `reception`
  MODIFY `num` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `request`
--
ALTER TABLE `request`
  MODIFY `num` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `area`
--
ALTER TABLE `area`
  ADD CONSTRAINT `area_ibfk_1` FOREIGN KEY (`manager`) REFERENCES `employee` (`num`) ON DELETE SET NULL;

--
-- Filtros para la tabla `areaorder`
--
ALTER TABLE `areaorder`
  ADD CONSTRAINT `areaorder_ibfk_1` FOREIGN KEY (`area`) REFERENCES `area` (`code`),
  ADD CONSTRAINT `areaorder_ibfk_2` FOREIGN KEY (`order`) REFERENCES `order` (`num`);

--
-- Filtros para la tabla `budget`
--
ALTER TABLE `budget`
  ADD CONSTRAINT `budget_ibfk_1` FOREIGN KEY (`area`) REFERENCES `area` (`code`);

--
-- Filtros para la tabla `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`area`) REFERENCES `area` (`code`);

--
-- Filtros para la tabla `order`
--
ALTER TABLE `order`
  ADD CONSTRAINT `order_ibfk_1` FOREIGN KEY (`employee`) REFERENCES `employee` (`num`),
  ADD CONSTRAINT `order_ibfk_2` FOREIGN KEY (`rawMaterial`) REFERENCES `raw_material` (`code`);

--
-- Filtros para la tabla `raw_material`
--
ALTER TABLE `raw_material`
  ADD CONSTRAINT `raw_material_ibfk_1` FOREIGN KEY (`category`) REFERENCES `category` (`code`);

--
-- Filtros para la tabla `reception`
--
ALTER TABLE `reception`
  ADD CONSTRAINT `reception_ibfk_1` FOREIGN KEY (`employee`) REFERENCES `employee` (`num`),
  ADD CONSTRAINT `reception_ibfk_2` FOREIGN KEY (`request`) REFERENCES `request` (`num`);

--
-- Filtros para la tabla `request`
--
ALTER TABLE `request`
  ADD CONSTRAINT `request_ibfk_1` FOREIGN KEY (`employee`) REFERENCES `employee` (`num`),
  ADD CONSTRAINT `request_ibfk_2` FOREIGN KEY (`provider`) REFERENCES `provider` (`num`),
  ADD CONSTRAINT `request_ibfk_3` FOREIGN KEY (`order`) REFERENCES `order` (`num`);

--
-- Filtros para la tabla `request_material`
--
ALTER TABLE `request_material`
  ADD CONSTRAINT `request_material_ibfk_1` FOREIGN KEY (`request`) REFERENCES `request` (`num`),
  ADD CONSTRAINT `request_material_ibfk_2` FOREIGN KEY (`product`) REFERENCES `raw_material` (`code`);

--
-- Filtros para la tabla `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`num`) REFERENCES `employee` (`num`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
