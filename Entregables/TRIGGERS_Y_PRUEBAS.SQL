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
-- INSERTS PARA TABLAS
-- ########################

-- TABLA OBRA
INSERT INTO obra (id, titulo, anyo) VALUES ('OB001', 'El Imperio Final', 2005);
INSERT INTO obra (id, titulo, anyo) VALUES ('OB002', 'La Rueda del Tiempo', 1990);
INSERT INTO obra (id, titulo, anyo) VALUES ('OB003', 'Cien Años de Soledad', 1967);
INSERT INTO obra (id, titulo, anyo) VALUES ('OB004', 'El otoño del patriarca', 1975);
INSERT INTO obra (id, titulo, anyo) VALUES ('OB005', 'Crónica de una muerte anunciada', 1981);

INSERT INTO obra (id, titulo, anyo) VALUES ('OB006', 'Prueba para borrar sin referencias', 1981);

-- TABLA AUTOR
INSERT INTO autor (id, nombre, apellidos, nacimiento) 
VALUES ('A001', 'Gabriel', 'García Márquez', DATE '1927-03-06');

INSERT INTO autor (id, nombre, apellidos, nacimiento) 
VALUES ('A002', 'Isabel', 'Allende', DATE '1942-08-02');

INSERT INTO autor (id, nombre, apellidos, nacimiento) 
VALUES ('A003', 'Jorge', 'Luis Borges', DATE '1899-08-24');

INSERT INTO autor (id, nombre, apellidos, nacimiento) 
VALUES ('A004', 'Prueba', 'Prueba para borrar sin referencias', DATE '1899-08-24');


INSERT INTO autor (id, nombre, apellidos, nacimiento) 
VALUES ('A005', 'Prueba', 'Prueba para vincular', DATE '1899-08-24');

-- TABLA AUTOR_OBRA
INSERT INTO autor_obra (id_autor, id_obra) VALUES ('A001', 'OB001');
INSERT INTO autor_obra (id_autor, id_obra) VALUES ('A002', 'OB002');
INSERT INTO autor_obra (id_autor, id_obra) VALUES ('A003', 'OB003');
INSERT INTO autor_obra (id_autor, id_obra) VALUES ('A001', 'OB004');
INSERT INTO autor_obra (id_autor, id_obra) VALUES ('A002', 'OB005');

-- TABLA EDICION
-- Para OB001: 2 ediciones
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED001', 'OB001', '9783161484100', 2005);
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED004', 'OB001', '9783161484117', 2006);

-- Para OB002: 1 edición
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED002', 'OB002', '9781234567897', 1990);

-- Para OB003: 2 ediciones
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED003', 'OB003', '9780987654321', 1967);
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED005', 'OB003', '9780987654338', 1968);

-- Para OB004: 1 edición
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED006', 'OB004', '9783161484124', 1976);

-- Para OB005: 2 ediciones
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED007', 'OB005', '9783161484131', 1981);
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED008', 'OB005', '9783161484148', 1982);

-- TABLA EJEMPLAR
-- Para ED001
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED001', 1, SYSDATE-10, SYSDATE-2);

-- Para ED002
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED002', 1, SYSDATE-20, NULL);

-- Para ED003
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED003', 1, SYSDATE-14, NULL);

-- Para ED004 (2 ejemplares)
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED004', 1, SYSDATE, NULL);
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED004', 2, SYSDATE, SYSDATE);

-- Para ED005
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED005', 1, SYSDATE-3, NULL);

-- Para ED006 (2 ejemplares)
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED006', 1, SYSDATE-21, NULL);
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED006', 2, SYSDATE-31, SYSDATE);

-- Para ED007
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED007', 1, SYSDATE-32, NULL);

-- Para ED008 (2 ejemplares)
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED008', 1, SYSDATE-6, SYSDATE);
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED008', 2, SYSDATE-6, NULL);

-- TABLA SOCIO
INSERT INTO socio (id, nombre, apellidos) 
VALUES ('S0001', 'Carlos', 'Pérez Gómez');

INSERT INTO socio (id, nombre, apellidos) 
VALUES ('S0002', 'Ana', 'Martínez Ruiz');

INSERT INTO socio (id, nombre, apellidos) 
VALUES ('S0003', 'Luis', 'Gómez López');

INSERT INTO socio (id, nombre, apellidos) 
VALUES ('S0004', 'María', 'Rodríguez Sánchez');

INSERT INTO socio (id, nombre, apellidos) 
VALUES ('S0005', 'Javier', 'López Fernández');

-- TABLA PRESTAMO
INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00001', 'S0001', 'ED001', 1, SYSDATE, SYSDATE-7);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00002', 'S0002', 'ED002', 1, SYSDATE, NULL);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00003', 'S0003', 'ED003', 1, SYSDATE, NULL);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00004', 'S0004', 'ED004', 1, SYSDATE, SYSDATE-10);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00005', 'S0005', 'ED005', 1, SYSDATE, NULL);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00006', 'S0005', 'ED006', 2, SYSDATE, SYSDATE-8);

-- ########################
-- BATERIA DE PRUEBAS
-- ########################

-- EJERCICIO 1         (08)###################################################################################################
SELECT * FROM OBRA;

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
    v_nueva_obra_id := BiblioTK.alta_obra('El Imperio Final II', 2006);
    -- Mostramos el ID asignado en la salida estándar (Visible al activar el buffer)
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nueva_obra_id);
END;
/

SELECT * FROM OBRA;

-- EJERCICIO 2         (09)###################################################################################################
SELECT * FROM OBRA;

DECLARE
    v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
BEGIN
    -- Intentar borrar una obra con un ID
    v_result := BiblioTK.borrado_obra('OB000');

    -- Mostrar el resultado en la salida estándar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE
    v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
BEGIN
    -- Intentar borrar una obra con un ID
    v_result := BiblioTK.borrado_obra('OB005');

    -- Mostrar el resultado en la salida estándar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE
    v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
BEGIN
    -- Intentar borrar una obra con un ID
    v_result := BiblioTK.borrado_obra('OB006');

    -- Mostrar el resultado en la salida estándar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE
    v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
BEGIN
    -- Intentar borrar una obra con un ID
    v_result := BiblioTK.borrado_obra('OB006');

    -- Mostrar el resultado en la salida estándar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

SELECT * FROM OBRA;

-- EJERCICIO 4        (10)###################################################################################################
SELECT * FROM AUTOR;

DECLARE 
    -- Declaramos una variable para alamcenar el ID
    v_nuevo_autor_id VARCHAR(4);
BEGIN
    -- Llamamos a la funcion y creamos el nuevo autor
    v_nuevo_autor_id := BiblioTK.alta_autor('Brandon', 'Sanderson', TO_DATE('1975-12-19', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nuevo_autor_id);
END;
/

DECLARE 
    -- Declaramos una variable para alamcenar el ID
    v_nuevo_autor_id VARCHAR(4);
BEGIN
    -- Llamamos a la funcion y creamos el nuevo autor
    v_nuevo_autor_id := BiblioTK.alta_autor('Brandon II', 'Sanderson', TO_DATE('1995-12-19', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nuevo_autor_id);
END;
/

SELECT * FROM AUTOR;

-- EJERCICIO 5        (11)###################################################################################################
SELECT * FROM AUTOR;

DECLARE 
    v_result INTEGER; -- Variable para almacenar el resultado 
BEGIN 
    -- Intentar borrar un autor 
    v_result := BiblioTK.borrado_autor('A000');

    -- Mostrar el resultado en la sálida estandar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE 
    v_result INTEGER; -- Variable para almacenar el resultado 
BEGIN 
    -- Intentar borrar un autor 
    v_result := BiblioTK.borrado_autor('A003');

    -- Mostrar el resultado en la sálida estandar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE 
    v_result INTEGER; -- Variable para almacenar el resultado 
BEGIN 
    -- Intentar borrar un autor 
    v_result := BiblioTK.borrado_autor('A004');

    -- Mostrar el resultado en la sálida estandar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE 
    v_result INTEGER; -- Variable para almacenar el resultado 
BEGIN 
    -- Intentar borrar un autor 
    v_result := BiblioTK.borrado_autor('A004');

    -- Mostrar el resultado en la sálida estandar
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

SELECT * FROM AUTOR;

-- EJERCICIO 6        (12)###################################################################################################
SELECT * FROM autor_obra;

DECLARE 
    v_result INTEGER; 
BEGIN
    -- autor / obra
    v_result := BiblioTK.vincular('A000', 'OB005');
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE 
    v_result INTEGER; 
BEGIN
    -- autor / obra
    v_result := BiblioTK.vincular('A005', 'OB000');
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE 
    v_result INTEGER; 
BEGIN
    -- autor / obra
    v_result := BiblioTK.vincular('A005', 'OB005');
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE 
    v_result INTEGER; 
BEGIN
    -- autor / obra
    v_result := BiblioTK.vincular('A005', 'OB005');
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

SELECT * FROM autor_obra;

-- EJERCICIO 7         (13)###################################################################################################
SELECT * FROM autor_obra;

DECLARE
    v_result INTEGER;
BEGIN
    v_result := BiblioTK.desvincular('A000', 'OB005'); -- ID de un autor y una obra ya vinculados
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE
    v_result INTEGER;
BEGIN
    v_result := BiblioTK.desvincular('A005', 'OB000'); -- ID de un autor y una obra ya vinculados
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE
    v_result INTEGER;
BEGIN
    v_result := BiblioTK.desvincular('A005', 'OB005'); -- ID de un autor y una obra ya vinculados
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

DECLARE
    v_result INTEGER;
BEGIN
    v_result := BiblioTK.desvincular('A005', 'OB005'); -- ID de un autor y una obra ya vinculados
    DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
END;
/

SELECT * FROM autor_obra;

-- EJERCICIO 8         (14)###################################################################################################
SELECT * FROM edicion;

DECLARE
    v_id_edicion VARCHAR(6);
BEGIN
    -- Llamar a la función y almacenar el resultado
    v_id_edicion := BiblioTK.alta_edicion('OB000', '978-3-16-148410-0', 2025);

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_id_edicion);
END;
/

DECLARE
    v_id_edicion VARCHAR(6);
BEGIN
    -- Llamar a la función y almacenar el resultado
    v_id_edicion := BiblioTK.alta_edicion('OB005', '978-3-16-148410-0', 2025);

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_id_edicion);
END;
/

DECLARE
    v_id_edicion VARCHAR(6);
BEGIN
    -- Llamar a la función y almacenar el resultado
    v_id_edicion := BiblioTK.alta_edicion('OB005', '978-3-16-148410-0', 2025);

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_id_edicion);
END;
/

SELECT * FROM edicion;

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
    v_resultado := BiblioTK.baja_ejemplar('YRN4ZC', 5);

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

-- EJERCICIO 15         (29)###################################################################################################
DECLARE
    v_resultado VARCHAR(6);
BEGIN
    -- Llamar a la función
    v_resultado := apertura_prestamo('S0002', 'ED002', 1);

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('Prestamo abierto: ' || v_resultado);
END;
/

-- EJERCICIO 16         (30)###################################################################################################
DECLARE
    v_resultado VARCHAR(6);
BEGIN
    -- Llamar a la función
    v_resultado := cierre_prestamo('JC8UHD');

    -- Mostrar el resultado
    DBMS_OUTPUT.PUT_LINE('Prestamo cerrado: ' || v_resultado);
END;
/

-- SELECT * FROM PRESTAMO;