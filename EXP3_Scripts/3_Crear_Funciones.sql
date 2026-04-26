USE SistemaVentas_G5;
GO

CREATE FUNCTION fn_ClienteExiste(@dui VARCHAR(10)) 
RETURNS INT 
AS 
BEGIN
    RETURN (SELECT COUNT(*) FROM Clientes WHERE DUI = @dui);
END
GO

CREATE FUNCTION fn_ProductoExiste(@id INT) 
RETURNS INT 
AS 
BEGIN
    RETURN (SELECT COUNT(*) FROM Productos WHERE ID_Producto = @id);
END
GO

CREATE FUNCTION fn_validaStock(@id INT, @cant INT) 
RETURNS INT 
AS 
BEGIN
    DECLARE @s INT;

    SELECT @s = Stock_Actual 
    FROM Productos 
    WHERE ID_Producto = @id;

    RETURN CASE WHEN ISNULL(@s, 0) >= @cant THEN 1 ELSE 0 END;
END
GO

CREATE FUNCTION fn_ValidarEmail(@email VARCHAR(100)) 
RETURNS INT 
AS
BEGIN
    RETURN CASE WHEN @email LIKE '%_@__%.__%' THEN 1 ELSE 0 END;
END
GO

CREATE FUNCTION fn_CalculaSubtotal(@idProd INT, @cant INT) 
RETURNS DECIMAL(10,2) 
AS
BEGIN
    DECLARE @subtotal DECIMAL(10,2);

    SELECT @subtotal = Precio_Venta * @cant 
    FROM Productos 
    WHERE ID_Producto = @idProd;

    RETURN ISNULL(@subtotal, 0);
END
GO

CREATE FUNCTION fn_ValidarDUI(@dui VARCHAR(10)) 
RETURNS INT 
AS
BEGIN
    RETURN CASE WHEN LEN(@dui) = 10 THEN 1 ELSE 0 END;
END
GO

CREATE FUNCTION fn_ProductoActivo(@id INT) 
RETURNS INT 
AS
BEGIN
    DECLARE @estado INT;

    SELECT @estado = ID_Estado 
    FROM Productos 
    WHERE ID_Producto = @id;

    RETURN ISNULL(@estado, 0);
END
GO