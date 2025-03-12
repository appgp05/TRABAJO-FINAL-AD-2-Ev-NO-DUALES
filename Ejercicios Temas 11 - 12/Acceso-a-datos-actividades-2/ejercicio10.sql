-- CREATE OR REPLACE PROCEDURE
--     AÑADIR_PEDIDO
-- AS
--     v_pedido_no;
--     v_producto_no;
--     v_cliente_no;
--     v_unidades;
--     v_fecha_pedido
-- BEGIN
--     INSERT INTO PEDIDOS VALUES(
        
--     );
-- END;
-- /

-- CREATE TABLE PEDIDOS(
-- NIF               VARCHAR2(10),
-- ARTICULO          VARCHAR2(20),
-- COD_FABRICANTE    NUMBER(3),
-- PESO              NUMBER(3),
-- CATEGORIA         VARCHAR2(10),
-- FECHA_PEDIDO      DATE,
-- UNIDADES_PEDIDAS  NUMBER(4)
-- );

CREATE OR REPLACE PROCEDURE insertar_pedido(
  p_pedido_no pedidos08.pedido_no%TYPE,
  p_producto_no pedidos08.producto_no%TYPE,
  p_cliente_no pedidos08.cliente_no%TYPE,
  p_unidades pedidos08.unidades%TYPE,
  p_fecha_pedido pedidos08.fecha_pedido%TYPE DEFAULT SYSDATE
) AS
  -- Variables para verificaciones
  v_stock_disponible productos08.stock_disponible%TYPE;
  v_precio_actual productos08.precio_actual%TYPE;
  v_limite_credito clientes08.limite_credito%TYPE;
  v_debe_actual clientes08.debe%TYPE;
  v_importe_pedido NUMBER;
  v_comision NUMBER;
  
  -- Excepciones personalizadas
  e_stock_insuficiente EXCEPTION;
  e_supera_credito EXCEPTION;
  e_producto_inexistente EXCEPTION;
  e_cliente_inexistente EXCEPTION;
  
BEGIN
  -- Iniciar la transacción
  SAVEPOINT inicio_pedido;
  
  -- Verificar existencia y stock del producto
  BEGIN
    SELECT stock_disponible, precio_actual
    INTO v_stock_disponible, v_precio_actual
    FROM productos08
    WHERE producto_no = p_producto_no
    FOR UPDATE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE e_producto_inexistente;
  END;
  
  IF v_stock_disponible < p_unidades THEN
    RAISE e_stock_insuficiente;
  END IF;
  
  -- Calcular importe del pedido
  v_importe_pedido := p_unidades * v_precio_actual;
  
  -- Verificar límite de crédito del cliente
  BEGIN
    SELECT limite_credito, debe
    INTO v_limite_credito, v_debe_actual
    FROM clientes08
    WHERE cliente_no = p_cliente_no
    FOR UPDATE;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE e_cliente_inexistente;
  END;
  
  IF (v_debe_actual + v_importe_pedido) > v_limite_credito THEN
    RAISE e_supera_credito;
  END IF;
  
  -- Insertar el pedido
  INSERT INTO pedidos08 (
    pedido_no, producto_no, cliente_no, unidades, fecha_pedido
  ) VALUES (
    p_pedido_no, p_producto_no, p_cliente_no, p_unidades, p_fecha_pedido
  );
  
  -- Actualizar stock del producto
  UPDATE productos08
  SET stock_disponible = stock_disponible - p_unidades
  WHERE producto_no = p_producto_no;
  
  -- Actualizar debe del cliente
  UPDATE clientes08
  SET debe = debe + v_importe_pedido
  WHERE cliente_no = p_cliente_no;
  
  -- Calcular y actualizar comisión (5% del valor total)
  v_comision := v_importe_pedido * 0.05;
  
  UPDATE emple
  SET comision = NVL(comision, 0) + v_comision
  WHERE emp_no = (
    SELECT vendedor_no 
    FROM clientes08 
    WHERE cliente_no = p_cliente_no
  );
  
  -- Confirmar la transacción
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Pedido insertado correctamente');
  DBMS_OUTPUT.PUT_LINE('Importe del pedido: ' || v_importe_pedido);
  DBMS_OUTPUT.PUT_LINE('Comisión generada: ' || v_comision);
  
EXCEPTION
  WHEN e_producto_inexistente THEN
    ROLLBACK TO inicio_pedido;
    RAISE_APPLICATION_ERROR(-20001, 'El producto no existe');
    
  WHEN e_cliente_inexistente THEN
    ROLLBACK TO inicio_pedido;
    RAISE_APPLICATION_ERROR(-20002, 'El cliente no existe');
    
  WHEN e_stock_insuficiente THEN
    ROLLBACK TO inicio_pedido;
    RAISE_APPLICATION_ERROR(-20003, 'Stock insuficiente. Stock disponible: ' || v_stock_disponible);
    
  WHEN e_supera_credito THEN
    ROLLBACK TO inicio_pedido;
    RAISE_APPLICATION_ERROR(-20004, 'El pedido supera el límite de crédito del cliente');
    
  WHEN OTHERS THEN
    ROLLBACK TO inicio_pedido;
    RAISE_APPLICATION_ERROR(-20005, 'Error al procesar el pedido: ' || SQLERRM);
END;
/

-- Ejecutar el procedimiento
-- BEGIN
--   insertar_pedido(
--     p_pedido_no => 1020,
--     p_producto_no => 10,
--     p_cliente_no => 101,
--     p_unidades => 5
--     -- fecha_pedido, por defecto SYSDATE
--   );
-- END;
-- /

EXEC insertar_pedido(1020, 10, 101, 5);