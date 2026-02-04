/*
PROYECTO SQL – PIRINEO ECUESTRE
Objetivo: modelar y analizar un sistema de reservas para una empresa de turismo ecuestre.
Incluye:
- Diseño de base de datos relacional
- Inserción de datos de prueba
- Consultas orientadas al negocio
- Vista para realizar el reporting
- Función para métricas reutilizables
*/

USE master;
GO

DROP DATABASE IF EXISTS PirineoEcuestre;
GO

-- 1. Creación de la base de datos

CREATE DATABASE PirineoEcuestre;
GO

USE PirineoEcuestre;
GO

-- 2. Creación de las tablas (modelo relacional)

CREATE TABLE Servicios (
    ServicioID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Descripcion NVARCHAR(250),
    Precio DECIMAL(10,2) NOT NULL CHECK (Precio >= 0),
    OcupacionMax INT NOT NULL CHECK (OcupacionMax >= 0)
);
GO

CREATE TABLE Clientes (
    ClienteID INT IDENTITY(1,1) PRIMARY KEY,
    Nombre NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL UNIQUE,
    Telefono NVARCHAR(20),
    Pais NVARCHAR(25)
);
GO

CREATE TABLE Reservas (
    ReservaID INT IDENTITY(1,1) PRIMARY KEY,
    ClienteID INT NOT NULL,
    FechaDeLaReserva DATETIME NOT NULL DEFAULT GETDATE(),
    Total DECIMAL(10,2) NOT NULL CHECK (Total >= 0),
    CONSTRAINT FK_Reservas_Clientes FOREIGN KEY (ClienteID)
        REFERENCES Clientes(ClienteID)
);
GO

CREATE TABLE DetallesReservas (
    DetalleID INT IDENTITY(1,1) PRIMARY KEY,
    ReservaID INT NOT NULL,
    ServicioID INT NOT NULL,
    CantidadContratada INT NOT NULL CHECK (CantidadContratada > 0),
    PrecioUnidad DECIMAL(10,2) NOT NULL CHECK (PrecioUnidad >= 0),
    CONSTRAINT FK_Detalles_Reservas FOREIGN KEY (ReservaID)
        REFERENCES Reservas(ReservaID),
    CONSTRAINT FK_Detalles_Servicios FOREIGN KEY (ServicioID)
        REFERENCES Servicios(ServicioID)
);
GO

-- 3. Inserción de datos (nº1)

-- Insertar servicios
INSERT INTO Servicios (Nombre, Descripcion, Precio, OcupacionMax)
VALUES
('Campamento completo', '7 días con pernocta y pensión completa', 1395.00, 25),
('Campamento de día', '7 días sin pernocta y sin pensión completa', 980.00, 5),
('Paseo a caballo', 'Paseo por la naturaleza', 25.00, 100),
('Paseo a pony', 'Para los más peques de la casa', 15.00, 100);
GO

-- Insertar clientes
INSERT INTO Clientes (Nombre, Email, Telefono, Pais)
VALUES
('Anna Martinez', 'annam@gmail.com', '655555555', 'España'),
('Laura Fernandez', 'lauram@gmail.com', '655555455', 'Austria'),
('Maria Lopez', 'mariam@gmail.com', '655555355', 'Ecuador'),
('Paula Gimenez', 'paulam@gmail.com', '655525555', 'Polonia');
GO

-- Insertar reservas
INSERT INTO Reservas (ClienteID, Total)
VALUES
(1, 1395.00),
(2, 1395.00),
(3, 25.00),
(4, 1410.00);
GO

-- Insertar detalles de reservas
INSERT INTO DetallesReservas (ReservaID, ServicioID, CantidadContratada, PrecioUnidad)
VALUES
(1, 1, 1, 1395.00),
(2, 1, 1, 1395.00),
(3, 3, 1, 25.00),
(4, 1, 1, 1395.00),
(4, 4, 1, 15.00);
GO

-- Inserción de datos (nº 2)
INSERT INTO Clientes (Nombre, Email, Telefono, Pais)
VALUES
('Carla Rodriguez', 'carlosr@gmail.com', '600111111', 'España'),
('Elena Mora', 'elenam@gmail.com', '600222222', 'España'),
('David Klein', 'davidk@gmail.com', '600333333', 'Alemania'),
('Sophie Laurent', 'sophie@gmail.com', '600444444', 'Francia'),
('Marco Bianchi', 'marcob@gmail.com', '600555555', 'Italia'),
('Ana Petrova', 'anap@gmail.com', '600666666', 'Rusia'),
('Lucas Silva', 'lucass@gmail.com', '600777777', 'Brasil'),
('Marta Novak', 'martan@gmail.com', '600888888', 'Croacia'),
('Jonas Berg', 'jonasb@gmail.com', '600999999', 'Suecia'),
('Emma Collins', 'emmac@gmail.com', '601000000', 'Irlanda');
GO

INSERT INTO Reservas (ClienteID, Total)
VALUES
(5, 1395.00),
(6, 980.00),
(7, 50.00),
(8, 25.00),
(9, 1410.00),
(10, 25.00),
(11, 1395.00),
(12, 40.00),
(13, 980.00),
(14, 25.00);
GO

INSERT INTO DetallesReservas (ReservaID, ServicioID, CantidadContratada, PrecioUnidad)
VALUES
(5, 1, 1, 1395.00),      -- Campamento completo
(6, 2, 1, 980.00),       -- Campamento de día
(7, 3, 2, 25.00),        -- 2 paseos a caballo
(8, 3, 1, 25.00),        -- 1 paseo a caballo
(9, 1, 1, 1395.00),      -- Campamento completo
(9, 4, 1, 15.00),        -- Paseo a pony
(10, 3, 1, 25.00),       -- Paseo a caballo
(11, 1, 1, 1395.00),     -- Campamento completo
(12, 4, 2, 15.00),       -- 2 paseos a pony
(13, 2, 1, 980.00),      -- Campamento de día
(14, 3, 1, 25.00);       -- Paseo a caballo
GO

-- 4. Comprobar que todo se ha registrado correctamente. Consulta que une las 
-- tablas mediante sus claves primarias y foráneas para mostrar la información completa.”

SELECT
    c.Nombre AS Cliente,
    c.Pais,
    r.ReservaID,
    s.Nombre AS Servicio,
    dr.CantidadContratada,
    dr.PrecioUnidad,
    dr.CantidadContratada * dr.PrecioUnidad AS Importe
FROM Clientes c
JOIN Reservas r ON c.ClienteID = r.ClienteID
JOIN DetallesReservas dr ON r.ReservaID = dr.ReservaID
JOIN Servicios s ON dr.ServicioID = s.ServicioID
ORDER BY r.ReservaID;
GO

-- 5. Consultas orientadas al negocio
-- Servicios ordenados por rentabilidad
SELECT 
    s.Nombre AS Servicio,
    SUM(dr.CantidadContratada * dr.PrecioUnidad) AS IngresosTotales
FROM DetallesReservas dr
JOIN Servicios s ON dr.ServicioID = s.ServicioID
GROUP BY s.Nombre
ORDER BY IngresosTotales DESC;

-- Ingresos totales por país
SELECT 
    c.Pais,
    SUM(dr.CantidadContratada * dr.PrecioUnidad) AS Ingresos
FROM Clientes c
JOIN Reservas r ON c.ClienteID = r.ClienteID
JOIN DetallesReservas dr ON r.ReservaID = dr.ReservaID
GROUP BY c.Pais
ORDER BY Ingresos DESC;

-- Vista para análisis en Power BI o Excel
CREATE VIEW vw_ReservasDetalle AS
SELECT
    c.Nombre AS Cliente,
    c.Pais,
    r.ReservaID,
    s.Nombre AS Servicio,
    dr.CantidadContratada,
    dr.PrecioUnidad,
    dr.CantidadContratada * dr.PrecioUnidad AS Importe
FROM Clientes c
JOIN Reservas r ON c.ClienteID = r.ClienteID
JOIN DetallesReservas dr ON r.ReservaID = dr.ReservaID
JOIN Servicios s ON dr.ServicioID = s.ServicioID;

SELECT * FROM vw_ReservasDetalle;

-- Función para calcular el numero total de contrataciones realizadas por servicio
CREATE FUNCTION dbo.TotalContratacionesPorServicio (@ServicioID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Total INT;

    SELECT @Total = SUM(CantidadContratada)
    FROM DetallesReservas
    WHERE ServicioID = @ServicioID;

    RETURN ISNULL(@Total, 0);
END;
GO

-- Utilización de la anterior función
SELECT
    s.ServicioID,
    s.Nombre AS Servicio,
    dbo.TotalContratacionesPorServicio(s.ServicioID) AS TotalContrataciones
FROM Servicios s;

SELECT
    s.Nombre AS Servicio,
    dbo.TotalContratacionesPorServicio(s.ServicioID) AS TotalContrataciones,
    s.OcupacionMax
FROM Servicios s;

