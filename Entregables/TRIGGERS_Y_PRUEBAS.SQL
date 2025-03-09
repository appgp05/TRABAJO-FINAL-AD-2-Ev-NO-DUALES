-- ########################
-- TRIGGERS
-- ########################

-- EJERCICIO 3        (09.1)###################################################################################################
CREATE OR REPLACE TRIGGER auditar_borrado_obra
BEFORE DELETE ON obra
FOR EACH ROW
BEGIN
    INSERT INTO historico_obra_auditado VALUES(:OLD.id, :OLD.titulo, :OLD.anyo, SYSTIMESTAMP);
END;
/

-- EJERCICIO 16         (30)###################################################################################################
CREATE OR REPLACE TRIGGER auditar_borrado_autor
BEFORE DELETE ON autor
FOR EACH ROW
BEGIN
    --CODIGO
END;
/

CREATE OR REPLACE TRIGGER auditar_borrado_autor_obra
BEFORE DELETE ON autor_obra
FOR EACH ROW
BEGIN
    --CODIGO
END;
/

CREATE OR REPLACE TRIGGER auditar_borrado_edicion
BEFORE DELETE ON edicion
FOR EACH ROW
BEGIN
    --CODIGO
END;
/

CREATE OR REPLACE TRIGGER auditar_borrado_ejemplar
BEFORE DELETE ON ejemplar
FOR EACH ROW
BEGIN
    --CODIGO
END;
/

CREATE OR REPLACE TRIGGER auditar_borrado_socio;
BEFORE DELETE ON socio;
FOR EACH ROW
BEGIN
    --CODIGO
END;
/

CREATE OR REPLACE TRIGGER auditar_borrado_prestamo;
BEFORE DELETE ON prestamo;
FOR EACH ROW
BEGIN
    --CODIGO
END;
/

CREATE OR REPLACE TRIGGER auditar_borrado_
BEFORE DELETE ON --NOMBRE TABLA
FOR EACH ROW
BEGIN
    --CODIGO
END;
/

CREATE OR REPLACE TRIGGER auditar_borrado_
BEFORE DELETE ON --NOMBRE TABLA
FOR EACH ROW
BEGIN
    --CODIGO
END;
/


-- ########################
-- BATERIA DE PRUEBAS
-- ########################

-- EJERCICIO 1         (08)###################################################################################################
DECLARE
    -- Declaramos una variable para alamcenar el ID generado por la función alta_obra
    v_nueva_obra_id VARCHAR(5); 
BEGIN  
    -- Llamamos a la función y almacenamos el ID generado. La función inserta la nueva obra
    v_nueva_obra_id := BiblioTK.alta_obra('El Imperio Final', 2005);
    -- Mostramos el ID asignado en la salida estándar (Visible al activar el buffer)
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nueva_obra_id);
END;
/

DECLARE
    -- Declaramos una variable para alamcenar el ID generado por la función alta_obra
    v_nueva_obra_id VARCHAR(5); 
BEGIN  
    -- Llamamos a la función y almacenamos el ID generado. La función inserta la nueva obra
    v_nueva_obra_id := BiblioTK.alta_obra('El Imperio Final', 2005);
    -- Mostramos el ID asignado en la salida estándar (Visible al activar el buffer)
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nueva_obra_id);
END;
/

DECLARE
    -- Declaramos una variable para alamcenar el ID generado por la función alta_obra
    v_nueva_obra_id VARCHAR(5); 
BEGIN  
    -- Llamamos a la función y almacenamos el ID generado. La función inserta la nueva obra
    v_nueva_obra_id := BiblioTK.alta_obra('El Imperio Final', 2005);
    -- Mostramos el ID asignado en la salida estándar (Visible al activar el buffer)
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nueva_obra_id);
END;
/

-- EJERCICIO 2         (09)###################################################################################################
DECLARE
    v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
BEGIN
    -- Intentar borrar una obra con un ID
    v_result := BiblioTK.borrado_obra('8RU3A');

    -- Mostrar el resultado en la salida estándar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

-- EJERCICIO 4        (10)###################################################################################################
DECLARE 
    -- Declaramos una variable para alamcenar el ID
    v_nuevo_autor_id VARCHAR(4);
BEGIN
    -- Llamamos a la funcion y creamos el nuevo autor
    v_nuevo_autor_id := BiblioTK.alta_autor('Brandon', 'Sanderson', TO_DATE('1975-12-19', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nuevo_autor_id);
END;
/

-- EJERCICIO 5        (11)###################################################################################################
DECLARE 
    v_result INTEGER; -- Variable para almacenar el resultado 
BEGIN 
    -- Intentar borrar un autor 
    v_result := BiblioTK.borrado_autor('8888');

    -- Mostrar el resultado en la sálida estandar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

-- EJERCICIO 6        (12)###################################################################################################
DECLARE 
    v_result INTEGER; 
BEGIN
    -- autor / obra
    v_result := BiblioTK.vincular('6ULH', 'NZIXI');
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

-- EJERCICIO 7         (13)###################################################################################################
DECLARE
    v_result INTEGER;
BEGIN
    v_result := BiblioTK.desvincular('6ULH', 'NZIXR'); -- ID de un autor y una obra ya vinculados
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

-- EJERCICIO 8         (14)###################################################################################################
DECLARE
    v_id_obra VARCHAR(5) := 'NZIXR';
    v_isbn VARCHAR(20) := '978-3-16-148410-0';
    v_anyo INTEGER := 2025; 
    v_id_edicion VARCHAR(6);
BEGIN
    -- Llamar a la función y almacenar el resultado
    v_id_edicion := BiblioTK.alta_edicion(v_id_obra, v_isbn, v_anyo);

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_id_edicion);
END;
/

-- EJERCICIO 9         (15)###################################################################################################
DECLARE
    v_result INTEGER;
BEGIN
    v_result := BiblioTK.borrado_edicion('XLYRAH');
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

-- EJERCICIO 10         (16, 17, 18)###################################################################################################
DECLARE
    v_id_edicion VARCHAR(10) := 'YRN4ZC';
    v_resultado INTEGER;
BEGIN
    -- Llamar a la función
    v_resultado := BiblioTK.alta_ejemplar(v_id_edicion);

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('Número de ejemplar asignado: ' || v_resultado);
END;
/

-- EJERCICIO 11         (19, 20, 21, 22)###################################################################################################
DECLARE 
    v_resultado INTEGER;
BEGIN
    v_resultado := BiblioTK.borrado_ejemplar('YRN4ZC', 3);

    IF v_resultado = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar borrado exitosamente.');
    ELSIF v_resultado = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
    ELSIF v_resultado = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede borrar: no cumple condiciones.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error inesperado.');
    END IF;
END;
/

-- EJERCICIO 12         (19, 23, 24, 25, 26)###################################################################################################
DECLARE
    v_resultado INTEGER;
BEGIN
    v_resultado := BiblioTK.baja_ejemplar('ZHEKI4', 1);

    IF v_resultado = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Baja efectuada correctamente.');
    ELSIF v_resultado = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
    ELSIF v_resultado = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede dar de baja: ya tiene fecha de baja.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error inesperado.');
    END IF;
END;
/