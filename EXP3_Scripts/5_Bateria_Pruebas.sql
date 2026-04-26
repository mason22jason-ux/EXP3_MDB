USE SistemaVentas_G5;
GO

-- A. CARGA INICIAL
EXEC sp_InsertarProducto 'Monitor 24', 100, 25, 10;
EXEC sp_InsertarProducto 'Teclado RGB', 20, 50, 5;
EXEC sp_InsertarProducto 'Mouse Pro', 10, 50, 2;

EXEC sp_InsertarCliente '12345678-9', 'Yoselyn Rivera', 'yoselyn@edu.sv';
EXEC sp_InsertarCliente '98765432-1', 'Raul Andrade', 'raul@edu.sv';

-- B. PRUEBAS CORRECTAS
EXEC sp_RegistrarVenta '12345678-9', 1, 1;
EXEC sp_ActualizarStock 3, 10;
EXEC sp_UpdateCliente '98765432-1', 'Raul Alberto Andrade', 'raul.a@mail.com';
EXEC sp_RegistrarVenta '98765432-1', 2, 2;

-- C. PRUEBAS DE ERROR
BEGIN TRY 
    EXEC sp_InsertarCliente '123', 'Error', 'test@mail.com'; 
END TRY 
BEGIN CATCH 
    SELECT 'P5 DUI corto' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_InsertarCliente '12345678-900', 'Error', 'test@mail.com'; 
END TRY 
BEGIN CATCH 
    SELECT 'P6 DUI largo' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_InsertarCliente '00000000-0', 'Test', 'email_malo'; 
END TRY 
BEGIN CATCH 
    SELECT 'P7 Email invalido' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_InsertarCliente '12345678-9', 'Duplicado', 'test@mail.com'; 
END TRY 
BEGIN CATCH 
    SELECT 'P8 Cliente duplicado' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_RegistrarVenta '12345678-9', 1, 100; 
END TRY 
BEGIN CATCH 
    SELECT 'P9 Venta sin stock' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_RegistrarVenta '12345678-9', 99, 1; 
END TRY 
BEGIN CATCH 
    SELECT 'P10 Producto inexistente' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_RegistrarVenta '00000000-0', 1, 1; 
END TRY 
BEGIN CATCH 
    SELECT 'P11 Cliente inexistente' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

EXEC sp_DarBajaProducto 2;

BEGIN TRY 
    EXEC sp_RegistrarVenta '12345678-9', 2, 1; 
END TRY 
BEGIN CATCH 
    SELECT 'P12 Producto inactivo' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_DeleteCliente '12345678-9'; 
END TRY 
BEGIN CATCH 
    SELECT 'P13 Borrar cliente con pedidos' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_ActualizarStock 500, 10; 
END TRY 
BEGIN CATCH 
    SELECT 'P14 Stock producto inexistente' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_RegistrarVenta '12345678-9', 3, 0; 
END TRY 
BEGIN CATCH 
    SELECT 'P15 Cantidad cero' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_InsertarProducto 'Error', 100, -50, 10; 
END TRY 
BEGIN CATCH 
    SELECT 'P16 Margen negativo' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_RegistrarVenta '98765432-1', 9999, 1; 
END TRY 
BEGIN CATCH 
    SELECT 'P17 Producto fantasma' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

BEGIN TRY 
    EXEC sp_UpdateCliente '11111111-1', 'No Existo', 'error@mail.com'; 
END TRY 
BEGIN CATCH 
    SELECT 'P18 Update cliente inexistente' AS Prueba, ERROR_MESSAGE() AS Resultado_Prueba; 
END CATCH;

EXEC sp_DarBajaProducto 1;
SELECT 'P19 Producto 1 inhabilitado correctamente' AS Prueba;

EXEC sp_InsertarProducto 'Stock Critico', 5, 20, 1;
EXEC sp_ReporteBajoStock;

-- D. CONSULTAS FINALES
EXEC sp_ListarClientes;
SELECT * FROM Productos;
SELECT * FROM Pedidos;
SELECT * FROM Detalle_Pedido;