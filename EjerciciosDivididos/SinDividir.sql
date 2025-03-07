-- ########################
-- EJERCICIO 1         (08)
-- ########################

CREATE OR REPLACE FUNCTION alta_obra(
    p_titulo VARCHAR,
    p_anyo INTEGER DEFAULT NULL) 
RETURN VARCHAR IS
    v_id CHAR(5);
BEGIN
    -- Generar un ID aleatorio de 5 carácteres en mayúsculas
    v_id := dbms_random.string('X', 5);
    
    -- Insertar la nueva obra

    INSERT INTO obra (id, titulo, anyo)
    VALUES (v_id, p_titulo, p_anyo); 

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

CREATE OR REPLACE FUNCTION borrado_obra(
    p_id VARCHAR) 
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

-- #########################
-- EJERCICIO 3        (09.1)
-- #########################

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

-- #######################
-- EJERCICIO 4        (10)
-- #######################

CREATE OR REPLACE FUNCTION alta_autor(
    p_nombre VARCHAR,
    p_apellidos VARCHAR,
    p_nacimiento DATE DEFAULT NULL)
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

-- #######################
-- EJERCICIO 5        (11)
-- #######################

CREATE OR REPLACE FUNCTION borrado_autor (
    p_id VARCHAR) 
RETURN INTEGER IS
    v_count INTEGER; -- Variable para verificar si el autor existe
BEGIN
    -- Verificar si el autor con el ID proporcionado existe
    SELECT COUNT(*) INTO v_count FROM autor WHERE id = p_id;

    -- Si no existe, devolver 0
    IF v_count = 0 THEN
        RETURN 0;
    END IF;

    -- Si existe, eliminar el autor
    DELETE FROM autor WHERE id = p_id;

    -- Devolver 1 indicando que el autor fue elimnado 
    RETURN 1;

EXCEPTION
    WHEN OTHERS THEN
        -- Si ocurre un error devolver -1
        RETURN -1;
END;
/

DECLARE 
    v_result INTEGER; -- Variable para almacenar el resultado 
BEGIN 
    -- Intentar borrar un autor 
    v_result := borrado_autor('0AUP');

    -- Mostrar el resultado en la sálida estandar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

-- #######################
-- EJERCICIO 6        (12)
-- #######################

CREATE OR REPLACE FUNCTION vincular (
    p_id_autor VARCHAR,
    p_id_obra VARCHAR)
RETURN INTEGER IS
    v_count_autor INTEGER;
    v_count_obra INTEGER;
    v_count_vinculo INTEGER;
BEGIN
    -- Verificar si el autor existe en la tabla autor
    SELECT COUNT(*) INTO v_count_autor FROM autor WHERE id = p_id_autor;
    IF v_count_autor = 0 THEN
        RETURN -2; -- Autor no encontado
    END IF;

    -- Verificar si la obra existe en la tabla obra
    SELECT COUNT(*) INTO v_count_obra FROM obra WHERE id = p_id_obra;
    IF v_count_obra = 0 THEN
        RETURN -3; -- Obra no encontrada
    END IF;

    -- Verificar si la relación ya existe en 'autor_obra'
    SELECT COUNT(*) INTO v_count_vinculo FROM autor_obra
    WHERE id_autor = p_id_autor AND id_obra = p_id_obra;

    IF v_count_vinculo > 0 THEN
        RETURN 0; -- La relaciön ya existe
    END IF;

    -- Insertamos la vinculación en 'autor_obra'
    INSERT INTO autor_obra (id_autor, id_obra)
    VALUES (p_id_autor, p_id_obra);

    RETURN 1; -- Vinculación existosa

EXCEPTION
    WHEN OTHERS THEN
        RETURN -1; -- Error
END;
/

DECLARE 
    v_result INTEGER; 
BEGIN
    -- autor / obra
    v_result := vincular('IX9V', '8HT74');
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

-- ########################
-- EJERCICIO 7         (13)
-- ########################

CREATE OR REPLACE FUNCTION desvincular(
    p_id_autor VARCHAR,
    p_id_obra VARCHAR)
RETURN INTEGER IS
    v_count_vinculo INTEGER;
BEGIN
    -- Verificar si la relación existe en `autor_obra`
    SELECT COUNT(*) INTO v_count_vinculo FROM autor_obra 
    WHERE id_autor = p_id_autor AND id_obra = p_id_obra;

    -- Si no hay vínculo, devolver 0
    IF v_count_vinculo = 0 THEN
        RETURN 0; -- No existe vínculo
    END IF;

    -- Eliminar la vinculación en `autor_obra`
    DELETE FROM autor_obra 
    WHERE id_autor = p_id_autor AND id_obra = p_id_obra;

    -- Verificar si se realizó la eliminación
    IF SQL%ROWCOUNT > 0 THEN
        COMMIT;
        RETURN 1; -- Desvinculación exitosa
    ELSE
        RETURN 0; -- No se eliminó nada (caso raro)
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RETURN -1; -- Error inesperado
END desvincular;
/

DECLARE
    v_result INTEGER;
BEGIN
    v_result := desvincular('SOZC', 'O2KYG'); -- ID de un autor y una obra ya vinculados
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/


-- ########################
-- EJERCICIO 7         (14)
-- ########################
CREATE OR REPLACE FUNCTION alta_edicion(
    p_id_obra VARCHAR,
    p_isbn VARCHAR,
    p_anyo INTEGER DEFAULT NULL) 
RETURN VARCHAR IS
    v_id_edicion CHAR(6);
    v_count INTEGER;
BEGIN
    -- Verificar que la obra existe
    SELECT COUNT(*) INTO v_count FROM obra WHERE id = p_id_obra;
    IF v_count = 0 THEN
        RETURN '0';  -- Error: la obra no existe
    END IF;

    -- Generar un nuevo ID único para la edición
    v_id_edicion := dbms_random.string('X', 6);

    -- Insertar la nueva edición
    INSERT INTO edicion (id, id_obra, isbn, anyo)
    VALUES (v_id_edicion, p_id_obra, p_isbn, p_anyo);

    RETURN v_id_edicion;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '-1';  -- En caso de cualquier error
END alta_edicion;
/

DECLARE
    v_id_obra VARCHAR(5) := 'O2KYG';
    v_isbn VARCHAR(20) := '978-3-16-148410-0';
    v_anyo INTEGER := 2025; 
    v_id_edicion VARCHAR(6);
BEGIN
    -- Llamar a la función y almacenar el resultado
    v_id_edicion := alta_edicion(v_id_obra, v_isbn, v_anyo);

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_id_edicion);
END;
/

-- ########################
-- EJERCICIO 8         (15)
-- ########################

CREATE OR REPLACE FUNCTION borrado_edicion (
    p_id VARCHAR)
RETURN INTEGER IS 
    v_count INTEGER;
BEGIN
    -- Verificar si la edición existe
    SELECT COUNT(*) INTO v_count FROM edicion WHERE id = p_id;

    -- Si no existe devolver 0
    IF v_count = 0 THEN
        RETURN 0;
    END IF;

    -- Si existe, eliminar la obra
    DELETE FROM edicion WHERE id = p_id;

    -- Devolver 1 indicando que la obra fue eliminada correctamente y guardar cambios
    COMMIT;
    RETURN 1;

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RETURN -1;
END borrado_edicion;
/

DECLARE
    v_result INTEGER;
BEGIN
    v_result := borrado_edicion('QX86JR');
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

-- ################################
-- EJERCICIO 9         (16, 17, 18)
-- ################################

CREATE OR REPLACE FUNCTION alta_ejemplar(
    p_id_edicion VARCHAR) 
RETURN INTEGER IS
    v_max_numero INTEGER;
    v_new_numero INTEGER;
    v_count INTEGER;
BEGIN
    -- Comprobar si la edición ya existe
    SELECT COUNT(*) INTO v_count
    FROM edicion
    WHERE id = p_id_edicion;

    IF v_count = 0 THEN
        RETURN -1;  -- Retorna -1 si la edición no existe
    END IF;

    -- Encontrar el número más alto de ejemplares para esta edición
    SELECT COALESCE(MAX(numero), 0) INTO v_max_numero -- Coalesce sustituye NULL por 0
    FROM ejemplar
    WHERE id_edicion = p_id_edicion;

    -- Asignar el nuevo número
    v_new_numero := v_max_numero + 1;

    -- Insertar el nuevo ejemplar con la fecha actual
    INSERT INTO ejemplar (id_edicion, numero, alta)
    VALUES (p_id_edicion, v_new_numero, SYSDATE);

    -- Devolver el número asignado
    RETURN v_new_numero;

EXCEPTION
    WHEN OTHERS THEN
        RETURN -2;  -- Devuelve -2 si ocurre un error inesperado
END alta_ejemplar;
/

DECLARE
    v_id_edicion VARCHAR(10) := 'ZHEKI4';
    v_resultado INTEGER;
BEGIN
    -- Llamar a la función
    v_resultado := alta_ejemplar(v_id_edicion);

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('Número de ejemplar asignado: ' || v_resultado);
END;
/

-- #####################################
-- EJERCICIO 10         (19, 20, 21, 22)
-- #####################################

CREATE OR REPLACE FUNCTION borrado_ejemplar (
    p_id_edicion VARCHAR,
    p_numero INTEGER)
RETURN INTEGER IS 
    v_max_numero INTEGER;
    v_alta DATE;
    v_baja DATE;
    v_count INTEGER;
BEGIN
    -- Verificar si el ejemplar existe
    SELECT COUNT(*), MAX(numero) INTO v_count, v_max_numero
    FROM ejemplar
    WHERE id_edicion = p_id_edicion;

    -- Si el ejemplar no existe, devolver 0
    IF v_count = 0 THEN
        RETURN 0;
    END IF;

    -- Verificar si el ejemplar es el último de su serie
    IF p_numero != v_max_numero THEN
        RETURN -1;
    END IF;

    -- Obtener datos del ejemplar específico
    SELECT alta, baja INTO v_alta, v_baja
    FROM ejemplar
    WHERE id_edicion = p_id_edicion AND numero = p_numero;

    -- Verificar que no tenga fecha de baja y que no hayan pasado más de 30 días
    IF v_baja IS NOT NULL OR (SYSDATE - v_alta) > 30 THEN
        RETURN -1;
    END IF;

    -- Si todas las condiciones se cumplen, eliminar el ejemplar
    DELETE FROM ejemplar
    WHERE id_edicion = p_id_edicion AND numero = p_numero;

    -- Devolver 1 indicando que el ejemplar fue eliminado correctamente y guardar cambios
    COMMIT;
    RETURN 1;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RETURN -2; -- Error inesperado
END borrado_ejemplar;
/

DECLARE 
    v_resultado INTEGER;
BEGIN
    v_resultado := borrado_ejemplar('ZHEKI4', 1);

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

-- #########################################
-- EJERCICIO 11         (19, 23, 24, 25, 26)
-- #########################################

CREATE OR REPLACE FUNCTION baja_ejemplar(
    p_id_edicion VARCHAR,
    p_numero INTEGER)
RETURN INTEGER IS
    v_baja DATE;
    v_count INTEGER := 0;
BEGIN
    -- Verificar si el ejemplar existe
    SELECT COUNT(*) INTO v_count
    FROM ejemplar
    WHERE id_edicion = p_id_edicion AND numero = p_numero;

    -- Si el ejemplar no existe, devolver 0
    IF v_count = 0 THEN
        RETURN 0;
    END IF;

    -- Obtener la fecha de baja
    SELECT baja INTO v_baja
    FROM ejemplar
    WHERE id_edicion = p_id_edicion AND numero = p_numero;

    -- Verificar que el ejemplar no tenga fecha de baja
    IF v_baja IS NOT NULL THEN
        RETURN -1;
    END IF;

    -- Actualizar la fecha de baja con la fecha actual del sistema
    UPDATE ejemplar
    SET baja = SYSDATE
    WHERE id_edicion = p_id_edicion AND numero = p_numero;

    RETURN 1;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RETURN -2; -- Error inesperado
END baja_ejemplar;
/


DECLARE
    v_resultado INTEGER;
BEGIN
    v_resultado := baja_ejemplar('ZHEKI4', 1);

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