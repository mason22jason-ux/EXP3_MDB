USE SistemaVentas_G5;
GO

CREATE TABLE Clientes (
    DUI VARCHAR(10) PRIMARY KEY,
    Nombre_Completo VARCHAR(150) NOT NULL,
    Email VARCHAR(100),
    ID_Estado INT DEFAULT 1 CHECK (ID_Estado IN (0,1))
);

CREATE TABLE Productos (
    ID_Producto INT IDENTITY(1,1) PRIMARY KEY,
    Nombre_Producto VARCHAR(100) NOT NULL,
    Precio_Costo DECIMAL(10,2) NOT NULL CHECK (Precio_Costo >= 0),
    Margen_Ganancia DECIMAL(5,2) NOT NULL CHECK (Margen_Ganancia >= 0),
    Precio_Venta DECIMAL(10,2) NOT NULL CHECK (Precio_Venta >= 0),
    Stock_Actual INT NOT NULL DEFAULT 0 CHECK (Stock_Actual >= 0),
    ID_Estado INT DEFAULT 1 CHECK (ID_Estado IN (0,1))
);

CREATE TABLE Pedidos (
    ID_Pedido INT IDENTITY(1,1) PRIMARY KEY,
    DUI_Cliente VARCHAR(10) NOT NULL,
    Fecha_Pedido DATETIME DEFAULT GETDATE(),
    Total_Venta DECIMAL(10,2) DEFAULT 0 CHECK (Total_Venta >= 0),
    ID_Estado INT DEFAULT 1 CHECK (ID_Estado IN (0,1)),
    FOREIGN KEY (DUI_Cliente) REFERENCES Clientes(DUI)
);

CREATE TABLE Detalle_Pedido (
    ID_Detalle INT IDENTITY(1,1) PRIMARY KEY,
    ID_Pedido INT NOT NULL,
    ID_Producto INT NOT NULL,
    Cantidad INT NOT NULL CHECK (Cantidad > 0),
    Precio_Unitario_Historico DECIMAL(10,2) NOT NULL CHECK (Precio_Unitario_Historico >= 0),
    Subtotal DECIMAL(10,2) NOT NULL CHECK (Subtotal >= 0),
    FOREIGN KEY (ID_Pedido) REFERENCES Pedidos(ID_Pedido),
    FOREIGN KEY (ID_Producto) REFERENCES Productos(ID_Producto)
);
GO