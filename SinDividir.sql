-- ########################
-- EJERCICIO 1         (08)
-- ########################

CREATE OR REPLACE FUNCTION alta_obra(p_titulo VARCHAR, p_anyo INTEGER DEFAULT NULL) 
RETURN VARCHAR IS
    v_id CHAR(5);
BEGIN
    -- Generar un ID aleatorio de 5 carácteres en mayúsculas
    v_id := dbms_random.string('X', 5);
    
    -- Insertar la nueva obra

    INSERT INTO obra (id, titulo, anyo) VALUES (v_id, p_titulo, p_anyo); 

    -- Devolver el nuevo ID
    RETURN v_id;

EXCEPTION
    -- En caso de error, devolver '-1'
    WHEN OTHERS THEN
        RETURN '-1';
END;
/

DECLARE
    -- Declaramos una variable para alamcenar el ID generado por la función alta_obra
    v_nueva_obra_id VARCHAR(5); 
BEGIN  
    -- Llamamos a la función y almacenamos el ID generado. La función inserta la nueva obra
    v_nueva_obra_id := alta_obra('El Imperio Final', 2005);
    -- Mostramos el ID asignado en la salida estándar (Visible al activar el buffer)
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nueva_obra_id);
END;
/

-- ########################
-- EJERCICIO 2         (09)
-- ########################

CREATE OR REPLACE FUNCTION borrado_obra(p_id VARCHAR) 
RETURN NUMBER IS
    v_count NUMBER;
BEGIN
    -- Verificar si la obra con el ID proporcio
    SELECT COUNT(*) INTO v_count FROM OBRA WHERE id = p_id;

    -- Si no existe, 
    IF v_count = 0
    THEN
        return 0;
    END IF; 

    -- Si existe, eliminar la obra y devolver 1 
    DELETE FROM OBRA WHERE id = p_id;
    RETURN 1;

EXCEPTION
    -- En caso de error, devolver '-1'
    WHEN OTHERS THEN
        RETURN '-1';
END;
/

DECLARE
    v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
BEGIN
    -- Intentar borrar una obra con ID '8OOKY'
    v_result := borrado_obra('A3BYH');

    -- Mostrar el resultado en la salida estándar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

-- ########################
-- EJERCICIO 3        (09.1)
-- ########################

CREATE TABLE historico_obra_auditado (
    id CHAR(5),
    titulo VARCHAR(100),
    anyo INTEGER,
    fecha_borrado TIMESTAMP DEFAULT SYSTIMESTAMP
);

CREATE OR REPLACE TRIGGER auditar_borrado_obra
BEFORE DELETE ON obra
FOR EACH ROW
BEGIN
    INSERT INTO historico_obra_auditado VALUES(:OLD.id, :OLD.titulo, :OLD.anyo, SYSTIMESTAMP);
END;
/

-- ########################
-- EJERCICIO 4        (10)
-- ########################

CREATE OR REPLACE FUNCTION
alta_autor(p_nombre VARCHAR, p_apellidos VARCHAR, p_nacimiento DATE DEFAULT NULL)
RETURN VARCHAR IS
    v_id CHAR(4);
BEGIN

    -- Generar un ID aleatorio de 4 carácteres en mayúsculas
    v_id := dbms_random.string('X', 4);
    
    -- Insertar el nuevo autor
    INSERT INTO autor (id, nombre, apellidos, nacimiento) VALUES (v_id, p_nombre, p_apellidos, p_nacimiento);

    -- Devolver el nuevo ID
    RETURN v_id;

EXCEPTION
-- En caso de error, devolver '-1'
    WHEN OTHERS THEN
        RETURN '-1';
END;
/

DECLARE 
    -- Declaramos una variable para alamcenar el ID
    v_nuevo_autor_id VARCHAR(4);
BEGIN
    -- Llamamos a la funcion y creamos el nuevo autor
    v_nuevo_autor_id := alta_autor('Brandon', 'Sanderson', TO_DATE('1975-12-19', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nuevo_autor_id);
END;
/