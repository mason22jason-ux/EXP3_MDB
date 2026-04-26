USE SistemaVentas_G5;
GO

CREATE PROCEDURE sp_InsertarCliente 
    @dui VARCHAR(10), 
    @nombre VARCHAR(150), 
    @email VARCHAR(100) 
AS
BEGIN
    IF dbo.fn_ValidarDUI(@dui) = 0 
        THROW 50001, 'DUI debe tener 10 caracteres', 1;

    IF dbo.fn_ValidarEmail(@email) = 0 
        THROW 50002, 'Email no tiene formato valido', 1;

    IF dbo.fn_ClienteExiste(@dui) > 0 
        THROW 50003, 'Cliente ya existe', 1;

    INSERT INTO Clientes 
    VALUES(@dui, @nombre, @email, 1);
END
GO

CREATE PROCEDURE sp_UpdateCliente 
    @dui VARCHAR(10), 
    @nombre VARCHAR(150), 
    @email VARCHAR(100) 
AS
BEGIN
    IF dbo.fn_ClienteExiste(@dui) = 0 
        THROW 50004, 'Cliente no existe', 1;

    IF dbo.fn_ValidarEmail(@email) = 0 
        THROW 50013, 'Email no tiene formato valido', 1;

    UPDATE Clientes 
    SET Nombre_Completo = @nombre, 
        Email = @email 
    WHERE DUI = @dui;
END
GO

CREATE PROCEDURE sp_DeleteCliente 
    @dui VARCHAR(10) 
AS
BEGIN
    IF dbo.fn_ClienteExiste(@dui) = 0 
        THROW 50016, 'Cliente no existe', 1;

    IF EXISTS(SELECT 1 FROM Pedidos WHERE DUI_Cliente = @dui) 
        THROW 50005, 'No se puede borrar: Cliente tiene pedidos vinculados', 1;

    DELETE FROM Clientes 
    WHERE DUI = @dui;
END
GO

CREATE PROCEDURE sp_InsertarProducto 
    @nom VARCHAR(100), 
    @costo DECIMAL(10,2), 
    @margen DECIMAL(5,2), 
    @stock INT 
AS
BEGIN
    IF @costo < 0 
        THROW 50017, 'El precio de costo no puede ser negativo', 1;

    IF @margen < 0 
        THROW 50010, 'El margen de ganancia no puede ser negativo', 1;

    IF @stock < 0 
        THROW 50018, 'El stock no puede ser negativo', 1;

    DECLARE @venta DECIMAL(10,2);

    SET @venta = @costo + (@costo * (@margen / 100));

    INSERT INTO Productos 
    (
        Nombre_Producto, 
        Precio_Costo, 
        Margen_Ganancia, 
        Precio_Venta, 
        Stock_Actual, 
        ID_Estado
    ) 
    VALUES
    (
        @nom, 
        @costo, 
        @margen, 
        @venta, 
        @stock, 
        1
    );
END
GO

CREATE PROCEDURE sp_ActualizarStock 
    @id INT, 
    @cantidadAgregar INT 
AS
BEGIN
    IF dbo.fn_ProductoExiste(@id) = 0 
        THROW 50006, 'Producto no existe', 1;

    IF @cantidadAgregar <= 0 
        THROW 50014, 'La cantidad a agregar debe ser mayor a cero', 1;

    UPDATE Productos 
    SET Stock_Actual = Stock_Actual + @cantidadAgregar 
    WHERE ID_Producto = @id;
END
GO

CREATE PROCEDURE sp_DarBajaProducto 
    @id INT 
AS
BEGIN
    IF dbo.fn_ProductoExiste(@id) = 0 
        THROW 50015, 'Producto no existe', 1;

    UPDATE Productos 
    SET ID_Estado = 0 
    WHERE ID_Producto = @id;
END
GO

CREATE PROCEDURE sp_RegistrarVenta 
    @dui VARCHAR(10), 
    @idProd INT, 
    @cant INT 
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        IF @cant <= 0 
            THROW 50011, 'La cantidad de venta debe ser mayor a cero', 1;

        IF dbo.fn_ClienteExiste(@dui) = 0 
            THROW 50007, 'Cliente no existe', 1;

        IF dbo.fn_ProductoExiste(@idProd) = 0 
            THROW 50012, 'Producto no existe', 1;

        IF dbo.fn_ProductoActivo(@idProd) = 0 
            THROW 50008, 'Producto se encuentra INACTIVO', 1;

        IF dbo.fn_validaStock(@idProd, @cant) = 0 
            THROW 50009, 'Stock insuficiente para la venta', 1;

        DECLARE @total DECIMAL(10,2);
        DECLARE @idPed INT;

        SET @total = dbo.fn_CalculaSubtotal(@idProd, @cant);

        INSERT INTO Pedidos 
        (
            DUI_Cliente, 
            Total_Venta
        ) 
        VALUES
        (
            @dui, 
            @total
        );

        SET @idPed = SCOPE_IDENTITY();

        INSERT INTO Detalle_Pedido 
        (
            ID_Pedido, 
            ID_Producto, 
            Cantidad, 
            Precio_Unitario_Historico, 
            Subtotal
        )
        VALUES
        (
            @idPed, 
            @idProd, 
            @cant, 
            (@total / @cant), 
            @total
        );

        UPDATE Productos 
        SET Stock_Actual = Stock_Actual - @cant 
        WHERE ID_Producto = @idProd;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH
END
GO

CREATE PROCEDURE sp_ReporteBajoStock 
AS 
BEGIN
    SELECT * 
    FROM Productos 
    WHERE Stock_Actual < 3;
END
GO

CREATE PROCEDURE sp_ListarClientes 
AS 
BEGIN
    SELECT * 
    FROM Clientes;
END
GO