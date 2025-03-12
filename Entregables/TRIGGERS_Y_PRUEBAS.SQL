-- ########
-- TRIGGERS
-- ########

DROP TRIGGER auditar_borrado_obra;
DROP TRIGGER auditar_borrado_autor;
DROP TRIGGER auditar_borrado_autor_obra;
DROP TRIGGER auditar_borrado_edicion;
DROP TRIGGER auditar_borrado_ejemplar;
DROP TRIGGER auditar_borrado_socio;
DROP TRIGGER auditar_borrado_prestamo;

-- EJERCICIO 3        (09.1)###################################################################################################
CREATE OR REPLACE TRIGGER auditar_borrado_obra
BEFORE DELETE ON obra
FOR EACH ROW
BEGIN
    INSERT INTO historico_obra_auditado (id, titulo, anyo, fecha_borrado) VALUES (:OLD.id, :OLD.titulo, :OLD.anyo, SYSTIMESTAMP);
END;
/

-- EJERCICIO 16         (30)###################################################################################################
-- ##################
DROP SEQUENCE sequence_historico_autor_auditado;
CREATE SEQUENCE sequence_historico_autor_auditado START WITH 1 INCREMENT BY 1 NOCACHE;

DROP TABLE historico_autor_auditado;
CREATE TABLE historico_autor_auditado (
    id_historico INTEGER DEFAULT sequence_historico_obra_auditado.NEXTVAL,
    id CHAR(4),
    nombre VARCHAR(30),
    apellidos VARCHAR(60),
    nacimiento DATE,
    fecha_borrado TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT PK_historico_autor_auditado PRIMARY KEY (id)
);

CREATE OR REPLACE TRIGGER auditar_borrado_autor
BEFORE DELETE ON autor
FOR EACH ROW
BEGIN
    INSERT INTO historico_autor_auditado (id, nombre, apellidos, nacimiento, fecha_borrado) VALUES (:OLD.id, :OLD.nombre, :OLD.apellidos, :OLD.nacimiento, SYSTIMESTAMP);
END;
/

-- ##################
DROP SEQUENCE sequence_historico_autor_obra_auditado;
CREATE SEQUENCE sequence_historico_autor_obra_auditado START WITH 1 INCREMENT BY 1 NOCACHE;

DROP TABLE historico_autor_obra_auditado;
CREATE TABLE historico_autor_obra_auditado (
    id_historico INTEGER DEFAULT sequence_historico_autor_obra_auditado.NEXTVAL,
    id_autor CHAR(4),
    id_obra CHAR(5),
    fecha_borrado TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT PK_historico_autor_obra_auditado PRIMARY KEY (id_historico)
);

CREATE OR REPLACE TRIGGER auditar_borrado_autor_obra
BEFORE DELETE ON autor_obra
FOR EACH ROW
BEGIN
    INSERT INTO historico_autor_obra_auditado (id_autor, id_obra, fecha_borrado) VALUES (:OLD.id_autor, :OLD.id_obra, SYSTIMESTAMP);
END;
/

-- ##################
DROP SEQUENCE sequence_historico_edicion_auditado;
CREATE SEQUENCE sequence_historico_edicion_auditado START WITH 1 INCREMENT BY 1 NOCACHE;

DROP TABLE historico_edicion_auditado;
CREATE TABLE historico_edicion_auditado (
    id_historico INTEGER DEFAULT sequence_historico_edicion_auditado.NEXTVAL,
    id CHAR(6),
    id_obra CHAR(5),
    isbn VARCHAR(20),
    anyo INTEGER,
    fecha_borrado TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT PK_historico_edicion_auditado PRIMARY KEY (id_historico)
);

CREATE OR REPLACE TRIGGER auditar_borrado_edicion
BEFORE DELETE ON edicion
FOR EACH ROW
BEGIN
    INSERT INTO historico_edicion_auditado (id, id_obra, isbn, anyo, fecha_borrado) VALUES (:OLD.id, :OLD.id_obra, :OLD.isbn, :OLD.anyo, SYSTIMESTAMP);
END;
/

-- ##################
DROP SEQUENCE sequence_historico_ejemplar_auditado;
CREATE SEQUENCE sequence_historico_ejemplar_auditado START WITH 1 INCREMENT BY 1 NOCACHE;

DROP TABLE historico_ejemplar_auditado;
CREATE TABLE historico_ejemplar_auditado (
    id_historico INTEGER DEFAULT sequence_historico_ejemplar_auditado.NEXTVAL,
    id_edicion CHAR(6),
    numero INTEGER,
    alta DATE,
    baja DATE,
    fecha_borrado TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT PK_historico_ejemplar_auditado PRIMARY KEY (id_historico)
);

CREATE OR REPLACE TRIGGER auditar_borrado_ejemplar
BEFORE DELETE ON ejemplar
FOR EACH ROW
BEGIN
    INSERT INTO historico_ejemplar_auditado (id_edicion, numero, alta, baja, fecha_borrado) VALUES (:OLD.id_edicion, :OLD.numero, :OLD.alta, :OLD.baja, SYSTIMESTAMP);
END;
/

-- ##################
DROP SEQUENCE sequence_historico_socio_auditado;
CREATE SEQUENCE sequence_historico_socio_auditado START WITH 1 INCREMENT BY 1 NOCACHE;

DROP TABLE historico_socio_auditado;
CREATE TABLE historico_socio_auditado (
    id_historico INTEGER DEFAULT sequence_historico_socio_auditado.NEXTVAL,
    id CHAR(5),
    nombre VARCHAR(50),
    apellidos VARCHAR(100),
    fecha_borrado TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT PK_historico_socio_auditado PRIMARY KEY (id_historico)
);

CREATE OR REPLACE TRIGGER auditar_borrado_socio
BEFORE DELETE ON socio
FOR EACH ROW
BEGIN
    INSERT INTO historico_socio_auditado (id, nombre, apellidos, fecha_borrado) VALUES (:OLD.id, :OLD.nombre, :OLD.apellidos, SYSTIMESTAMP);
END;
/

-- ##################
DROP SEQUENCE sequence_historico_prestamo_auditado;
CREATE SEQUENCE sequence_historico_prestamo_auditado START WITH 1 INCREMENT BY 1 NOCACHE;

DROP TABLE historico_prestamo_auditado;
CREATE TABLE historico_prestamo_auditado (
    id_historico INTEGER DEFAULT sequence_historico_prestamo_auditado.NEXTVAL,
    id CHAR(6),
    id_socio CHAR(5),
    id_ejemplar CHAR(6),
    numero_ejemplar INTEGER,
    fecha_prestamo DATE DEFAULT SYSDATE,
    fecha_devolucion DATE,
    fecha_borrado TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT PK_historico_prestamo_auditado PRIMARY KEY (id_historico)
);

CREATE OR REPLACE TRIGGER auditar_borrado_prestamo
BEFORE DELETE ON prestamo
FOR EACH ROW
BEGIN
   INSERT INTO historico_prestamo_auditado (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) VALUES (:OLD.id, :OLD.id_socio, :OLD.id_ejemplar, :OLD.numero_ejemplar, :OLD.fecha_prestamo, :OLD.fecha_devolucion);
END;
/

-- ###################
-- INSERTS PARA TABLAS
-- ###################

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
VALUES ('ED0001', 'OB001', '978-3-16-148410-0', 2005);
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED0004', 'OB001', '97-8-31-6148411-7', 2006);

-- Para OB002: 1 edición
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED0002', 'OB002', '978-1-23-456789-7', 1990);

-- Para OB003: 2 ediciones
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED0003', 'OB003', '978-0-98-765432-1', 1967);
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED0005', 'OB003', '978-0-98-765433-8', 1968);

-- Para OB004: 1 edición
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED0006', 'OB004', '978-3-16-148412-4', 1976);

-- Para OB005: 2 ediciones
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED0007', 'OB005', '978-3-16-148413-1', 1981);
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED0008', 'OB005', '978-3-16-148414-8', 1982);

-- PRUEBA PARA BORRAR
INSERT INTO edicion (id, id_obra, isbn, anyo) 
VALUES ('ED0009', 'OB005', '978-3-16-148414-8', 1982);

-- -- PRUEBA PARA DAR DE BAJA
-- INSERT INTO edicion (id, id_obra, isbn, anyo) 
-- VALUES ('ED0010', 'OB005', '978-3-16-148414-8', 1982);

-- TABLA EJEMPLAR
-- Para ED001
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0001', 1, SYSDATE-10, SYSDATE-2);

-- Para ED002
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0002', 1, SYSDATE-20, NULL);

-- Para ED003
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0003', 1, SYSDATE-14, NULL);

-- Para ED004 (2 ejemplares)
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0004', 1, SYSDATE, NULL);
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0004', 2, SYSDATE, SYSDATE);

-- Para ED005
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0005', 1, SYSDATE-3, NULL);

-- Para ED006 (2 ejemplares)
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0006', 1, SYSDATE-21, NULL);
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0006', 2, SYSDATE-15, SYSDATE);

-- Para ED007
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0007', 1, SYSDATE-32, NULL);
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0007', 2, SYSDATE-32, NULL);

-- Para ED008 (2 ejemplares)
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0008', 1, SYSDATE-6, SYSDATE);
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0008', 2, SYSDATE-6, NULL);

-- PRUEBA PARA BORRAR
INSERT INTO ejemplar (id_edicion, numero, alta, baja) 
VALUES ('ED0008', 3, SYSDATE-6, NULL);

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
VALUES ('P00001', 'S0001', 'ED0001', 1, SYSDATE, SYSDATE-7);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00002', 'S0002', 'ED0002', 1, SYSDATE, NULL);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00003', 'S0003', 'ED0003', 1, SYSDATE, NULL);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00004', 'S0004', 'ED0004', 1, SYSDATE, SYSDATE-10);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00005', 'S0005', 'ED0005', 1, SYSDATE, NULL);

INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo, fecha_devolucion) 
VALUES ('P00006', 'S0005', 'ED0006', 2, SYSDATE, SYSDATE-8);


-- ##################
-- BATERIA DE PRUEBAS ADAPTADA
-- ##################

-- EJERCICIO 1         (08)###################################################################################################
-- ### Obras antes de ejecutar las pruebas
SELECT * FROM OBRA;

-- ### Pruebas para insertar dos obras
DECLARE
    -- Declaramos variables para almacenar los IDs generados por la función alta_obra
    v_nueva_obra_id1 VARCHAR(5);
    v_nueva_obra_id2 VARCHAR(5);
BEGIN  
    -- Primera obra
    v_nueva_obra_id1 := BiblioTK.alta_obra('El Imperio Final', 2005);
    
    IF v_nueva_obra_id1 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta la obra "El Imperio Final"');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Obra dada de alta con ID: ' || v_nueva_obra_id1);
    END IF;
    
    -- Segunda obra
    v_nueva_obra_id2 := BiblioTK.alta_obra('El Imperio Final II', 2006);
    
    IF v_nueva_obra_id2 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta la obra "El Imperio Final II"');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Obra dada de alta con ID: ' || v_nueva_obra_id2);
    END IF;
END;
/

-- ### Obras depués de ejecutar las pruebas
SELECT * FROM OBRA;

-- EJERCICIO 2         (09)###################################################################################################
-- ### Obras antes de ejecutar las pruebas
SELECT * FROM OBRA;

-- ### Pruebas para borrar obras
DECLARE
    v_result1 INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
    v_result2 INTEGER;
    v_result3 INTEGER;
    v_result4 INTEGER;
BEGIN
    -- Intentar borrar una obra que no existe
    v_result1 := BiblioTK.borrado_obra('OB000');
    
    IF v_result1 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Obra OB000 borrada correctamente');
    ELSIF v_result1 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('La obra OB000 no existe');
    ELSIF v_result1 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar borrar la obra OB000');
    END IF;

    -- Intentar borrar una obra que tiene referencias (No se puede borrar)
    v_result2 := BiblioTK.borrado_obra('OB005');
    
    IF v_result2 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Obra OB005 borrada correctamente');
    ELSIF v_result2 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('La obra OB005 no existe');
    ELSIF v_result2 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar borrar la obra OB005');
    END IF;

    -- Intentar borrar una obra
    v_result3 := BiblioTK.borrado_obra('OB006');
    
    IF v_result3 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Obra OB006 borrada correctamente');
    ELSIF v_result3 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('La obra OB006 no existe');
    ELSIF v_result3 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar borrar la obra OB006');
    END IF;

    -- Intentar borrar una obra que ya ha sido borrada
    v_result4 := BiblioTK.borrado_obra('OB006');
    
    IF v_result4 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Obra OB006 borrada correctamente');
    ELSIF v_result4 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('La obra OB006 no existe');
    ELSIF v_result4 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar borrar la obra OB006');
    END IF;
END;
/

-- ### Obras después de ejecutar las pruebas
SELECT * FROM OBRA;

-- EJERCICIO 4        (10)###################################################################################################
-- ### Autores antes de ejecutar las pruebas
SELECT * FROM AUTOR;

-- ### Pruebas para insertar dos autores
DECLARE 
    -- Declaramos variables para almacenar los IDs
    v_nuevo_autor_id1 VARCHAR(4);
    v_nuevo_autor_id2 VARCHAR(4);
BEGIN
    -- Primer autor
    v_nuevo_autor_id1 := BiblioTK.alta_autor('Brandon', 'Sanderson', TO_DATE('1975-12-19', 'YYYY-MM-DD'));
    
    IF v_nuevo_autor_id1 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta el autor "Brandon Sanderson"');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Autor dado de alta con ID: ' || v_nuevo_autor_id1);
    END IF;
    
    -- Segundo autor
    v_nuevo_autor_id2 := BiblioTK.alta_autor('Brandon II', 'Sanderson', TO_DATE('1995-12-19', 'YYYY-MM-DD'));
    
    IF v_nuevo_autor_id2 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta el autor "Brandon II Sanderson"');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Autor dado de alta con ID: ' || v_nuevo_autor_id2);
    END IF;
END;
/

-- ### Autores después de ejecutar las pruebas
SELECT * FROM AUTOR;

-- EJERCICIO 5        (11)###################################################################################################
-- ### Autores antes de ejecutar las pruebas
SELECT * FROM AUTOR;

-- ### Pruebas para borrar autores
DECLARE 
    v_result1 INTEGER;
    v_result2 INTEGER;
    v_result3 INTEGER;
    v_result4 INTEGER;
BEGIN 
    -- Intentar borrar un autor que no existe
    v_result1 := BiblioTK.borrado_autor('A000');
    
    IF v_result1 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A000 borrado correctamente');
    ELSIF v_result1 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El autor A000 no existe');
    ELSIF v_result1 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar borrar el autor A000');
    END IF;

    -- Intentar borrar un autor que tiene referencias (No se puede borrar)
    v_result2 := BiblioTK.borrado_autor('A003');
    
    IF v_result2 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A003 borrado correctamente');
    ELSIF v_result2 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El autor A003 no existe');
    ELSIF v_result2 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar borrar el autor A003');
    END IF;

    -- Intentar borrar un autor
    v_result3 := BiblioTK.borrado_autor('A004');
    
    IF v_result3 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A004 borrado correctamente');
    ELSIF v_result3 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El autor A004 no existe');
    ELSIF v_result3 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar borrar el autor A004');
    END IF;

    -- Intentar borrar un autor que ya ha sido borrado
    v_result4 := BiblioTK.borrado_autor('A004');
    
    IF v_result4 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A004 borrado correctamente');
    ELSIF v_result4 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El autor A004 no existe');
    ELSIF v_result4 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al intentar borrar el autor A004');
    END IF;
END;
/

-- ### Autores después de ejecutar las pruebas
SELECT * FROM AUTOR;

-- EJERCICIO 6        (12)###################################################################################################
-- ### Vínculos autor_obra antes de ejecutar las pruebas
SELECT * FROM autor_obra;

-- ### Pruebas para vincular autores y obras
DECLARE 
    v_result1 INTEGER;
    v_result2 INTEGER;
    v_result3 INTEGER;
    v_result4 INTEGER;
BEGIN
    -- Intentar vincular un autor que no existe
    v_result1 := BiblioTK.vincular('A000', 'OB005');
    
    IF v_result1 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A000 vinculado correctamente con obra OB005');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al vincular autor A000 con obra OB005');
    END IF;

    -- Intentar vincular una obra que no existe
    v_result2 := BiblioTK.vincular('A005', 'OB000');
    
    IF v_result2 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A005 vinculado correctamente con obra OB000');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al vincular autor A005 con obra OB000');
    END IF;

    -- Vincular un autor y una obra
    v_result3 := BiblioTK.vincular('A005', 'OB005');
    
    IF v_result3 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A005 vinculado correctamente con obra OB005');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al vincular autor A005 con obra OB005');
    END IF;

    -- Intentar vincular un autor y una obra cuando ya existe el vínculo
    v_result4 := BiblioTK.vincular('A005', 'OB005');
    
    IF v_result4 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A005 vinculado correctamente con obra OB005');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al vincular autor A005 con obra OB005');
    END IF;
END;
/

-- ### Vínculos autor_obra después de ejecutar las pruebas
SELECT * FROM autor_obra;

-- EJERCICIO 7         (13)###################################################################################################
-- ### Vínculos autor_obra antes de ejecutar las pruebas
SELECT * FROM autor_obra;

-- ### Pruebas para desvincular autores y obras
DECLARE
    v_result1 INTEGER;
    v_result2 INTEGER;
    v_result3 INTEGER;
    v_result4 INTEGER;
BEGIN
    -- Intentar desvincular un autor que no existe
    v_result1 := BiblioTK.desvincular('A000', 'OB005');
    
    IF v_result1 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A000 desvinculado correctamente de obra OB005');
    ELSIF v_result1 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No existe vínculo entre autor A000 y obra OB005');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al desvincular autor A000 de obra OB005');
    END IF;

    -- Intentar desvincular una obra que no existe
    v_result2 := BiblioTK.desvincular('A005', 'OB000');
    
    IF v_result2 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A005 desvinculado correctamente de obra OB000');
    ELSIF v_result2 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No existe vínculo entre autor A005 y obra OB000');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al desvincular autor A005 de obra OB000');
    END IF;

    -- Desvincular un autor y una obra
    v_result3 := BiblioTK.desvincular('A005', 'OB005');
    
    IF v_result3 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A005 desvinculado correctamente de obra OB005');
    ELSIF v_result3 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No existe vínculo entre autor A005 y obra OB005');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al desvincular autor A005 de obra OB005');
    END IF;

    -- Intentar desvincular un autor y una obra que ya han sido desvinculados
    v_result4 := BiblioTK.desvincular('A005', 'OB005');
    
    IF v_result4 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Autor A005 desvinculado correctamente de obra OB005');
    ELSIF v_result4 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No existe vínculo entre autor A005 y obra OB005');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Error al desvincular autor A005 de obra OB005');
    END IF;
END;
/

-- ### Vínculos autor_obra después de ejecutar las pruebas
SELECT * FROM autor_obra;

-- EJERCICIO 8         (14)###################################################################################################
-- ### Ediciones antes de ejecutar las pruebas
SELECT * FROM edicion;

-- ### Pruebas para insertar ediciones
DECLARE
    v_id_edicion1 VARCHAR(6);
    v_id_edicion2 VARCHAR(6);
    v_id_edicion3 VARCHAR(6);
BEGIN
    -- Intentar insertar una edición de una obra que no existe
    v_id_edicion1 := BiblioTK.alta_edicion('OB000', '978-3-16-148410-0', 2025);
    
    IF v_id_edicion1 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta la edición de la obra OB000');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Edición dada de alta con ID: ' || v_id_edicion1);
    END IF;
    
    -- Insertar primera edición de una obra
    v_id_edicion2 := BiblioTK.alta_edicion('OB005', '978-3-16-148410-0', 2025);
    
    IF v_id_edicion2 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta la edición de la obra OB005');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Edición dada de alta con ID: ' || v_id_edicion2);
    END IF;
    
    -- Insertar segunda edición de la misma obra
    v_id_edicion3 := BiblioTK.alta_edicion('OB005', '978-3-16-148410-0', 2025);
    
    IF v_id_edicion3 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta la edición de la obra OB005');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Edición dada de alta con ID: ' || v_id_edicion3);
    END IF;
END;
/

-- ### Ediciones después de ejecutar las pruebas
SELECT * FROM edicion;

-- EJERCICIO 9         (15)###################################################################################################
-- ### Ediciones antes de ejecutar las pruebas
SELECT * FROM edicion;

-- ### Pruebas para borrar ediciones
DECLARE
    v_result1 INTEGER;
    v_result2 INTEGER;
    v_result3 INTEGER;
BEGIN
    -- Intentar borrar una edición que no existe
    v_result1 := BiblioTK.borrado_edicion('ED0000');
    
    IF v_result1 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Edición ED0000 borrada correctamente');
    ELSIF v_result1 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('La edición ED0000 no existe');
    END IF;

    -- Borrar una edición
    v_result2 := BiblioTK.borrado_edicion('ED0009');
    
    IF v_result2 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Edición ED0009 borrada correctamente');
    ELSIF v_result2 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('La edición ED0009 no existe');
    END IF;

    -- Intentar borrar una edición que ya ha sido borrada
    v_result3 := BiblioTK.borrado_edicion('ED0009');
    
    IF v_result3 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Edición ED0009 borrada correctamente');
    ELSIF v_result3 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('La edición ED0009 no existe');
    END IF;
END;
/

-- ### Ediciones después de ejecutar las pruebas
SELECT * FROM edicion;

-- EJERCICIO 10         (16, 17, 18)###################################################################################################
-- ### Ejemplares antes de ejecutar las pruebas
SELECT * FROM ejemplar;

-- ### Pruebas para dar de alta ejemplares
DECLARE
    v_resultado1 INTEGER;
    v_resultado2 INTEGER;
    v_resultado3 INTEGER;
BEGIN
    -- Intentar dar de alta un ejemplar de una edición que no existe
    v_resultado1 := BiblioTK.alta_ejemplar('ED0000');
    
    IF v_resultado1 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta el ejemplar (La edición ED0000 no existe)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ejemplar dado de alta con número: ' || v_resultado1);
    END IF;

    -- Dar de alta un ejemplar
    v_resultado2 := BiblioTK.alta_ejemplar('ED0005');
    
    IF v_resultado2 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta el ejemplar (La edición ED0005 no existe)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ejemplar dado de alta con número: ' || v_resultado2);
    END IF;

    -- Dar de alta otro ejemplar de la misma edición
    v_resultado3 := BiblioTK.alta_ejemplar('ED0005');
    
    IF v_resultado3 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('Error al dar de alta el ejemplar (La edición ED0005 no existe)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Ejemplar dado de alta con número: ' || v_resultado3);
    END IF;
END;
/

-- ### Ejemplares después de ejecutar las pruebas
SELECT * FROM ejemplar;

-- EJERCICIO 11         (19, 20, 21, 22)###################################################################################################
-- ### Ejemplares antes de ejecutar las pruebas
SELECT * FROM ejemplar;

-- ### Pruebas para borrar ejemplares
DECLARE 
    v_resultado1 INTEGER;
    v_resultado2 INTEGER;
    v_resultado3 INTEGER;
    v_resultado4 INTEGER;
    v_resultado5 INTEGER;
BEGIN
    -- Intentar borrar un ejemplar que no existe
    v_resultado1 := BiblioTK.borrado_ejemplar('ED0000', 0);

    IF v_resultado1 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar ED0000-0 borrado correctamente');
    ELSIF v_resultado1 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El ejemplar ED0000-0 no existe');
    ELSIF v_resultado1 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede borrar el ejemplar ED0000-0: no cumple las condiciones');
    END IF;

    -- Intentar borrar un ejemplar que no es el último de su edición
    v_resultado2 := BiblioTK.borrado_ejemplar('ED0008', 1);

    IF v_resultado2 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar ED0008-1 borrado correctamente');
    ELSIF v_resultado2 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El ejemplar ED0008-1 no existe');
    ELSIF v_resultado2 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede borrar el ejemplar ED0008-1: no cumple las condiciones');
    END IF;

    -- Intentar borrar un ejemplar que ha sido dado de baja
    v_resultado3 := BiblioTK.borrado_ejemplar('ED0006', 2);

    IF v_resultado3 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar ED0006-2 borrado correctamente');
    ELSIF v_resultado3 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El ejemplar ED0006-2 no existe');
    ELSIF v_resultado3 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede borrar el ejemplar ED0006-2: no cumple las condiciones');
    END IF;

    -- Intentar borrar un ejemplar que fue dado de alta hace más de 30 días
    v_resultado4 := BiblioTK.borrado_ejemplar('ED0007', 2);

    IF v_resultado4 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar ED0007-2 borrado correctamente');
    ELSIF v_resultado4 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El ejemplar ED0007-2 no existe');
    ELSIF v_resultado4 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede borrar el ejemplar ED0007-2: no cumple las condiciones');
    END IF;

    -- Borrar un ejemplar que cumple todas las condiciones
    v_resultado5 := BiblioTK.borrado_ejemplar('ED0008', 3);

    IF v_resultado5 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar ED0008-3 borrado correctamente');
    ELSIF v_resultado5 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El ejemplar ED0008-3 no existe');
    ELSIF v_resultado5 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede borrar el ejemplar ED0008-3: no cumple las condiciones');
    END IF;
END;
/

-- ### Ejemplares después de ejecutar las pruebas
SELECT * FROM ejemplar;

-- EJERCICIO 12         (19, 23, 24, 25, 26)###################################################################################################
-- ### Ejemplares antes de ejecutar las pruebas
SELECT * FROM ejemplar;

-- ### Pruebas para dar de baja ejemplares
DECLARE
    v_resultado1 INTEGER;
    v_resultado2 INTEGER;
    v_resultado3 INTEGER;
    v_resultado4 INTEGER;
BEGIN
    -- Intentar dar de baja un ejemplar que no existe
    v_resultado1 := BiblioTK.baja_ejemplar('ED0008', 0);

    IF v_resultado1 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar ED0008-0 dado de baja correctamente');
    ELSIF v_resultado1 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El ejemplar ED0008-0 no existe');
    ELSIF v_resultado1 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede dar de baja el ejemplar ED0008-0: no cumple las condiciones');
    END IF;

    -- Intentar dar de baja un ejemplar que ya tiene fecha de baja
    v_resultado2 := BiblioTK.baja_ejemplar('ED0008', 1);

    IF v_resultado2 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar ED0008-1 dado de baja correctamente');
    ELSIF v_resultado2 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El ejemplar ED0008-1 no existe');
    ELSIF v_resultado2 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede dar de baja el ejemplar ED0008-1: no cumple las condiciones');
    END IF;

    -- Dar de baja un ejemplar
    v_resultado3 := BiblioTK.baja_ejemplar('ED0008', 2);

    IF v_resultado3 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar ED0008-2 dado de baja correctamente');
    ELSIF v_resultado3 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El ejemplar ED0008-2 no existe');
    ELSIF v_resultado3 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede dar de baja el ejemplar ED0008-2: no cumple las condiciones');
    END IF;

    -- Intentar dar de baja un ejemplar que ya ha sido dado de baja
    v_resultado4 := BiblioTK.baja_ejemplar('ED0008', 2);

    IF v_resultado4 = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Ejemplar ED0008-2 dado de baja correctamente');
    ELSIF v_resultado4 = 0 THEN
        DBMS_OUTPUT.PUT_LINE('El ejemplar ED0008-2 no existe');
    ELSIF v_resultado4 = -1 THEN
        DBMS_OUTPUT.PUT_LINE('No se puede dar de baja el ejemplar ED0008-2: no cumple las condiciones');
    END IF;
END;
/

-- ### Ejemplares después de ejecutar las pruebas
SELECT * FROM ejemplar;

-- EJERCICIO 15         (29)###################################################################################################
-- ### Préstamos antes de ejecutar las pruebas
SELECT * FROM prestamo;

-- ### Pruebas para hacer préstamos
DECLARE
    v_resultado1 VARCHAR(6);
    v_resultado2 VARCHAR(6);
    v_resultado3 VARCHAR(6);
    v_resultado4 VARCHAR(6);
    v_resultado5 VARCHAR(6);
BEGIN
    -- Intentar hacer un préstamo a un socio que no existe
    v_resultado1 := apertura_prestamo('S0000', 'ED0001', 1);

    IF v_resultado1 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el socio S0000 no existe');
    ELSIF v_resultado1 = '-2' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ejemplar ED0001-1 no existe');
    ELSIF v_resultado1 = '-3' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ejemplar ya está siendo prestado');
    ELSIF v_resultado1 = '-4' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ID ya está asignado');
    ELSIF v_resultado1 = '-5' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: error inesperado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Préstamo abierto con ID: ' || v_resultado1);
    END IF;

    -- Intentar hacer un préstamo de una edición que no existe
    v_resultado2 := apertura_prestamo('S0001', 'ED0000', 1);

    IF v_resultado2 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el socio S0001 no existe');
    ELSIF v_resultado2 = '-2' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: la edición ED0000-1 no existe');
    ELSIF v_resultado2 = '-3' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ejemplar ya está siendo prestado');
    ELSIF v_resultado1 = '-4' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ID ya está asignado');
    ELSIF v_resultado1 = '-5' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: error inesperado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Préstamo abierto con ID: ' || v_resultado2);
    END IF;

    -- Intentar hacer un préstamo de una edición que ya está siendo prestada
    v_resultado3 := apertura_prestamo('S0001', 'ED0002', 1);

    IF v_resultado3 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el socio S0001 no existe');
    ELSIF v_resultado3 = '-2' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: la edición ED0002-1 no existe');
    ELSIF v_resultado3 = '-3' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ejemplar ya está siendo prestado');
    ELSIF v_resultado1 = '-4' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ID ya está asignado');
    ELSIF v_resultado1 = '-5' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: error inesperado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Préstamo abierto con ID: ' || v_resultado3);
    END IF;

    -- Hacer un préstamo
    v_resultado4 := apertura_prestamo('S0001', 'ED0001', 1);

    IF v_resultado4 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el socio S0001 no existe');
    ELSIF v_resultado4 = '-2' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: la edición ED0001-1 no existe');
    ELSIF v_resultado4 = '-3' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ejemplar ya está siendo prestado');
    ELSIF v_resultado1 = '-4' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ID ya está asignado');
    ELSIF v_resultado1 = '-5' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: error inesperado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Préstamo abierto con ID: ' || v_resultado4);
    END IF;

    -- Intentar hacer un préstamo cuando ya ha sido prestado pero no cerrado
    v_resultado5 := apertura_prestamo('S0001', 'ED0001', 1);

    IF v_resultado5 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el socio S0001 no existe');
    ELSIF v_resultado5 = '-2' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: la edición ED0001-1 no existe');
    ELSIF v_resultado5 = '-3' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ejemplar ya está siendo prestado');
    ELSIF v_resultado1 = '-4' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: el ID ya está asignado');
    ELSIF v_resultado1 = '-5' THEN
        DBMS_OUTPUT.PUT_LINE('Error al abrir préstamo: error inesperado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Préstamo abierto con ID: ' || v_resultado5);
    END IF;
END;
/

-- ### Préstamos después de ejecutar las pruebas
SELECT * FROM prestamo;

-- EJERCICIO 16         (30)###################################################################################################
-- ### Préstamos antes de ejecutar las pruebas
SELECT * FROM prestamo;

-- ### Pruebas para cerrar préstamos
DECLARE
    v_resultado1 VARCHAR(6);
    v_resultado2 VARCHAR(6);
    v_resultado3 VARCHAR(6);
    v_resultado4 VARCHAR(6);
BEGIN
    -- Intentar cerrar un préstamo que no existe
    v_resultado1 := cierre_prestamo('P00000');

    IF v_resultado1 = '0' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: el préstamo P00000 no existe');
    ELSIF v_resultado1 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: el préstamo P00000 ya está cerrado');
    ELSIF v_resultado1 = '-2' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: error inesperado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Préstamo P00000 cerrado correctamente');
    END IF;

    -- Intentar cerrar un préstamo que ya ha sido cerrado
    v_resultado2 := cierre_prestamo('P00006');

    IF v_resultado2 = '0' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: el préstamo P00006 no existe');
    ELSIF v_resultado2 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: el préstamo P00006 ya está cerrado');
    ELSIF v_resultado1 = '-2' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: error inesperado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Préstamo P00006 cerrado correctamente');
    END IF;

    -- Cerrar un préstamo
    v_resultado3 := cierre_prestamo('P00005');

    IF v_resultado3 = '0' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: el préstamo P00005 no existe');
    ELSIF v_resultado3 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: el préstamo P00005 ya está cerrado');
    ELSIF v_resultado1 = '-2' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: error inesperado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Préstamo P00005 cerrado correctamente');
    END IF;

    -- Intentar cerrar un préstamo que ya ha sido cerrado
    v_resultado4 := cierre_prestamo('P00005');

    IF v_resultado4 = '0' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: el préstamo P00005 no existe');
    ELSIF v_resultado4 = '-1' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: el préstamo P00005 ya está cerrado');
    ELSIF v_resultado1 = '-2' THEN
        DBMS_OUTPUT.PUT_LINE('Error al cerrar préstamo: error inesperado');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Préstamo P00005 cerrado correctamente');
    END IF;
END;
/

-- ### Préstamos después de ejecutar las pruebas
SELECT * FROM prestamo;


-- -- ##################
-- -- BATERIA DE PRUEBAS
-- -- ##################

-- -- EJERCICIO 1         (08)###################################################################################################
-- -- ### Obras antes de ejecutar las pruebas
-- SELECT * FROM OBRA;

-- -- ### Pruebas para insertar dos obras
-- DECLARE
--     -- Declaramos una variable para alamcenar el ID generado por la función alta_obra
--     v_nueva_obra_id VARCHAR(5); 
-- BEGIN  
--     -- Llamamos a la función y almacenamos el ID generado. La función inserta la nueva obra
--     v_nueva_obra_id := BiblioTK.alta_obra('El Imperio Final', 2005);
--     -- Mostramos el ID asignado en la salida estándar (Visible al activar el buffer)
--     DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nueva_obra_id);
-- END;
-- /

-- DECLARE
--     -- Declaramos una variable para alamcenar el ID generado por la función alta_obra
--     v_nueva_obra_id VARCHAR(5); 
-- BEGIN  
--     -- Llamamos a la función y almacenamos el ID generado. La función inserta la nueva obra
--     v_nueva_obra_id := BiblioTK.alta_obra('El Imperio Final II', 2006);
--     -- Mostramos el ID asignado en la salida estándar (Visible al activar el buffer)
--     DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nueva_obra_id);
-- END;
-- /

-- -- ### Obras depués de ejecutar las pruebas
-- SELECT * FROM OBRA;

-- -- EJERCICIO 2         (09)###################################################################################################
-- -- ### Obras antes de ejecutar las pruebas
-- SELECT * FROM OBRA;

-- -- ### Prueba para borrar una obra que no existe
-- DECLARE
--     v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
-- BEGIN
--     -- Intentar borrar una obra con un ID
--     v_result := BiblioTK.borrado_obra('OB000');

--     -- Mostrar el resultado en la salida estándar
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para borrar una obra que tiene referencias (No se puede borrar)
-- DECLARE
--     v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
-- BEGIN
--     -- Intentar borrar una obra con un ID
--     v_result := BiblioTK.borrado_obra('OB005');

--     -- Mostrar el resultado en la salida estándar
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para borrar una obra
-- DECLARE
--     v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
-- BEGIN
--     -- Intentar borrar una obra con un ID
--     v_result := BiblioTK.borrado_obra('OB006');

--     -- Mostrar el resultado en la salida estándar
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para borrar una obra que ya ha sido borrada
-- DECLARE
--     v_result INTEGER; -- Variable para almacenar el resultado de la función borrado_obra
-- BEGIN
--     -- Intentar borrar una obra con un ID
--     v_result := BiblioTK.borrado_obra('OB006');

--     -- Mostrar el resultado en la salida estándar
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Obras después de ejecutar las pruebas
-- SELECT * FROM OBRA;

-- -- EJERCICIO 4        (10)###################################################################################################
-- -- ### Autores antes de ejecutar las pruebas
-- SELECT * FROM AUTOR;

-- -- ### Pruebas para insertar dos autores
-- DECLARE 
--     -- Declaramos una variable para alamcenar el ID
--     v_nuevo_autor_id VARCHAR(4);
-- BEGIN
--     -- Llamamos a la funcion y creamos el nuevo autor
--     v_nuevo_autor_id := BiblioTK.alta_autor('Brandon', 'Sanderson', TO_DATE('1975-12-19', 'YYYY-MM-DD'));
--     DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nuevo_autor_id);
-- END;
-- /

-- DECLARE 
--     -- Declaramos una variable para alamcenar el ID
--     v_nuevo_autor_id VARCHAR(4);
-- BEGIN
--     -- Llamamos a la funcion y creamos el nuevo autor
--     v_nuevo_autor_id := BiblioTK.alta_autor('Brandon II', 'Sanderson', TO_DATE('1995-12-19', 'YYYY-MM-DD'));
--     DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_nuevo_autor_id);
-- END;
-- /

-- -- ### Autores después de ejecutar las pruebas
-- SELECT * FROM AUTOR;

-- -- EJERCICIO 5        (11)###################################################################################################
-- -- ### Autores antes de ejecutar las pruebas
-- SELECT * FROM AUTOR;

-- -- ### Prueba para borrar un autor que no existe
-- DECLARE 
--     v_result INTEGER; -- Variable para almacenar el resultado 
-- BEGIN 
--     -- Intentar borrar un autor 
--     v_result := BiblioTK.borrado_autor('A000');

--     -- Mostrar el resultado en la sálida estandar
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para borrar un autor que tiene referencias (No se puede borrar)
-- DECLARE 
--     v_result INTEGER; -- Variable para almacenar el resultado 
-- BEGIN 
--     -- Intentar borrar un autor 
--     v_result := BiblioTK.borrado_autor('A003');

--     -- Mostrar el resultado en la sálida estandar
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para borrar un autor
-- DECLARE 
--     v_result INTEGER; -- Variable para almacenar el resultado 
-- BEGIN 
--     -- Intentar borrar un autor 
--     v_result := BiblioTK.borrado_autor('A004');

--     -- Mostrar el resultado en la sálida estandar
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para borrar un autor que ya ha sido borrado
-- DECLARE 
--     v_result INTEGER; -- Variable para almacenar el resultado 
-- BEGIN 
--     -- Intentar borrar un autor 
--     v_result := BiblioTK.borrado_autor('A004');

--     -- Mostrar el resultado en la sálida estandar
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Autores después de ejecutar las pruebas
-- SELECT * FROM AUTOR;

-- -- EJERCICIO 6        (12)###################################################################################################
-- -- ### Vínculos autor_obra antes de ejecutar las pruebas
-- SELECT * FROM autor_obra;

-- -- ### Prueba para vincular un autor y una obra con un autor que no existe
-- DECLARE 
--     v_result INTEGER; 
-- BEGIN
--     -- autor / obra
--     v_result := BiblioTK.vincular('A000', 'OB005');
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para vincular un autor y una obra con una obra que no existe
-- DECLARE 
--     v_result INTEGER; 
-- BEGIN
--     -- autor / obra
--     v_result := BiblioTK.vincular('A005', 'OB000');
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para vincular un autor y una obra
-- DECLARE
--     v_result INTEGER; 
-- BEGIN
--     -- autor / obra
--     v_result := BiblioTK.vincular('A005', 'OB005');
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para vincular un autor y una obra cuando ya existe el vínculo
-- DECLARE 
--     v_result INTEGER; 
-- BEGIN
--     -- autor / obra
--     v_result := BiblioTK.vincular('A005', 'OB005');
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Vínculos autor_obra después de ejecutar las pruebas
-- SELECT * FROM autor_obra;

-- -- EJERCICIO 7         (13)###################################################################################################
-- -- ### Vínculos autor_obra antes de ejecutar las pruebas
-- SELECT * FROM autor_obra;

-- -- ### Prueba para desvincular un autor y una obra con un autor que no existe
-- DECLARE
--     v_result INTEGER;
-- BEGIN
--     v_result := BiblioTK.desvincular('A000', 'OB005'); -- ID de un autor y una obra ya vinculados
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para desvincular un autor y una obra con una obra que no existe
-- DECLARE
--     v_result INTEGER;
-- BEGIN
--     v_result := BiblioTK.desvincular('A005', 'OB000'); -- ID de un autor y una obra ya vinculados
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para desvincular un autor y una obra
-- DECLARE
--     v_result INTEGER;
-- BEGIN
--     v_result := BiblioTK.desvincular('A005', 'OB005'); -- ID de un autor y una obra ya vinculados
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para desvincular un autor y una obra que ya han sido desvinculados
-- DECLARE
--     v_result INTEGER;
-- BEGIN
--     v_result := BiblioTK.desvincular('A005', 'OB005'); -- ID de un autor y una obra ya vinculados
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Vínculos autor_obra después de ejecutar las pruebas
-- SELECT * FROM autor_obra;

-- -- EJERCICIO 8         (14)###################################################################################################
-- -- ### Ediciones antes de ejecutar las pruebas
-- SELECT * FROM edicion;

-- -- ### Prueba para insertar una edición de una obra que no existe
-- DECLARE
--     v_id_edicion VARCHAR(6);
-- BEGIN
--     -- Llamar a la función y almacenar el resultado
--     v_id_edicion := BiblioTK.alta_edicion('OB000', '978-3-16-148410-0', 2025);

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_id_edicion);
-- END;
-- /

-- -- ### Pruebas para insertar dos ediciones de una obra
-- DECLARE
--     v_id_edicion VARCHAR(6);
-- BEGIN
--     -- Llamar a la función y almacenar el resultado
--     v_id_edicion := BiblioTK.alta_edicion('OB005', '978-3-16-148410-0', 2025);

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_id_edicion);
-- END;
-- /

-- DECLARE
--     v_id_edicion VARCHAR(6);
-- BEGIN
--     -- Llamar a la función y almacenar el resultado
--     v_id_edicion := BiblioTK.alta_edicion('OB005', '978-3-16-148410-0', 2025);

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('ID Asignado: ' || v_id_edicion);
-- END;
-- /

-- -- ### Ediciones después de ejecutar las pruebas
-- SELECT * FROM edicion;

-- -- EJERCICIO 9         (15)###################################################################################################
-- -- ### Ediciones antes de ejecutar las pruebas
-- SELECT * FROM edicion;

-- -- ### Prueba para borrar una edición que no existe
-- DECLARE
--     v_result INTEGER;
-- BEGIN
--     v_result := BiblioTK.borrado_edicion('ED0000');
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para borrar una edición
-- DECLARE
--     v_result INTEGER;
-- BEGIN
--     v_result := BiblioTK.borrado_edicion('ED0009');
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Prueba para borrar una edición que ya ha sido borrada
-- DECLARE
--     v_result INTEGER;
-- BEGIN
--     v_result := BiblioTK.borrado_edicion('ED0009');
--     DBMS_OUTPUT.PUT_LINE('Resultado: ' || v_result);
-- END;
-- /

-- -- ### Ediciones después de ejecutar las pruebas
-- SELECT * FROM edicion;

-- -- EJERCICIO 10         (16, 17, 18)###################################################################################################
-- -- ### Ejemplares antes de ejecutar las pruebas
-- SELECT * FROM ejemplar;

-- -- ### Prueba para dar de alta un ejemplar que no existe
-- DECLARE
--     v_resultado INTEGER;
-- BEGIN
--     -- Llamar a la función
--     v_resultado := BiblioTK.alta_ejemplar('ED0000');

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Número de ejemplar asignado: ' || v_resultado);
-- END;
-- /

-- -- ### Prueba para dar de alta un ejemplar
-- DECLARE
--     v_resultado INTEGER;
-- BEGIN
--     -- Llamar a la función
--     v_resultado := BiblioTK.alta_ejemplar('ED0005');

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Número de ejemplar asignado: ' || v_resultado);
-- END;
-- /

-- -- ### Prueba para dar de alta un ejemplar que ya ha sido dado de alta
-- DECLARE
--     v_resultado INTEGER;
-- BEGIN
--     -- Llamar a la función
--     v_resultado := BiblioTK.alta_ejemplar('ED0005');

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Número de ejemplar asignado: ' || v_resultado);
-- END;
-- /

-- -- ### Ejemplares después de ejecutar las pruebas
-- SELECT * FROM ejemplar;

-- -- EJERCICIO 11         (19, 20, 21, 22)###################################################################################################
-- -- ### Ejemplares antes de ejecutar las pruebas
-- SELECT * FROM ejemplar;

-- -- ### Prueba para borrar un ejemplar que no existe
-- DECLARE 
--     v_resultado INTEGER;
-- BEGIN
--     v_resultado := BiblioTK.borrado_ejemplar('ED0000', 0);

--     IF v_resultado = 1 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar borrado exitosamente.');
--     ELSIF v_resultado = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
--     ELSIF v_resultado = -1 THEN
--         DBMS_OUTPUT.PUT_LINE('No se puede borrar: no cumple condiciones.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Error inesperado.');
--     END IF;
-- END;
-- /

-- -- ### Prueba para borrar un ejemplar que no es el último de su edición
-- DECLARE 
--     v_resultado INTEGER;
-- BEGIN
--     v_resultado := BiblioTK.borrado_ejemplar('ED0008', 1);

--     IF v_resultado = 1 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar borrado exitosamente.');
--     ELSIF v_resultado = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
--     ELSIF v_resultado = -1 THEN
--         DBMS_OUTPUT.PUT_LINE('No se puede borrar: no cumple condiciones.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Error inesperado.');
--     END IF;
-- END;
-- /

-- -- ### Prueba para borrar un ejemplar que ha sido dado de baja
-- DECLARE 
--     v_resultado INTEGER;
-- BEGIN
--     v_resultado := BiblioTK.borrado_ejemplar('ED0006', 2);

--     IF v_resultado = 1 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar borrado exitosamente.');
--     ELSIF v_resultado = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
--     ELSIF v_resultado = -1 THEN
--         DBMS_OUTPUT.PUT_LINE('No se puede borrar: no cumple condiciones.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Error inesperado.');
--     END IF;
-- END;
-- /

-- -- ### Prueba para borrar un ejemplar que fué dado de alta hace más de 30 días
-- DECLARE 
--     v_resultado INTEGER;
-- BEGIN
--     v_resultado := BiblioTK.borrado_ejemplar('ED0007', 2);

--     IF v_resultado = 1 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar borrado exitosamente.');
--     ELSIF v_resultado = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
--     ELSIF v_resultado = -1 THEN
--         DBMS_OUTPUT.PUT_LINE('No se puede borrar: no cumple condiciones.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Error inesperado.');
--     END IF;
-- END;
-- /

-- -- ### Prueba para borrar un ejemplar
-- DECLARE 
--     v_resultado INTEGER;
-- BEGIN
--     v_resultado := BiblioTK.borrado_ejemplar('ED0008', 3);

--     IF v_resultado = 1 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar borrado exitosamente.');
--     ELSIF v_resultado = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
--     ELSIF v_resultado = -1 THEN
--         DBMS_OUTPUT.PUT_LINE('No se puede borrar: no cumple condiciones.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Error inesperado.');
--     END IF;
-- END;
-- /

-- -- ### Ejemplares después de ejecutar las pruebas
-- SELECT * FROM ejemplar;

-- -- EJERCICIO 12         (19, 23, 24, 25, 26)###################################################################################################
-- -- ### Ejemplares antes de ejecutar las pruebas
-- SELECT * FROM ejemplar;

-- -- ### Prueba para dar de baja un ejemplar que no existe
-- DECLARE
--     v_resultado INTEGER;
-- BEGIN
--     v_resultado := BiblioTK.baja_ejemplar('ED0008', 0);

--     IF v_resultado = 1 THEN
--         DBMS_OUTPUT.PUT_LINE('Baja efectuada correctamente.');
--     ELSIF v_resultado = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
--     ELSIF v_resultado = -1 THEN
--         DBMS_OUTPUT.PUT_LINE('No se puede dar de baja: ya tiene fecha de baja.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Error inesperado.');
--     END IF;
-- END;
-- /

-- -- ### Prueba para dar de baja un ejemplar que ya tiene fecha de baja
-- DECLARE
--     v_resultado INTEGER;
-- BEGIN
--     v_resultado := BiblioTK.baja_ejemplar('ED0008', 1);

--     IF v_resultado = 1 THEN
--         DBMS_OUTPUT.PUT_LINE('Baja efectuada correctamente.');
--     ELSIF v_resultado = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
--     ELSIF v_resultado = -1 THEN
--         DBMS_OUTPUT.PUT_LINE('No se puede dar de baja: ya tiene fecha de baja.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Error inesperado.');
--     END IF;
-- END;
-- /

-- -- ### Prueba para dar de baja un ejemplar
-- DECLARE
--     v_resultado INTEGER;
-- BEGIN
--     v_resultado := BiblioTK.baja_ejemplar('ED0008', 2);

--     IF v_resultado = 1 THEN
--         DBMS_OUTPUT.PUT_LINE('Baja efectuada correctamente.');
--     ELSIF v_resultado = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
--     ELSIF v_resultado = -1 THEN
--         DBMS_OUTPUT.PUT_LINE('No se puede dar de baja: ya tiene fecha de baja.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Error inesperado.');
--     END IF;
-- END;
-- /

-- -- ### Prueba para dar de baja un ejemplar que ya ha sido dado de baja
-- DECLARE
--     v_resultado INTEGER;
-- BEGIN
--     v_resultado := BiblioTK.baja_ejemplar('ED0008', 2);

--     IF v_resultado = 1 THEN
--         DBMS_OUTPUT.PUT_LINE('Baja efectuada correctamente.');
--     ELSIF v_resultado = 0 THEN
--         DBMS_OUTPUT.PUT_LINE('Ejemplar no encontrado.');
--     ELSIF v_resultado = -1 THEN
--         DBMS_OUTPUT.PUT_LINE('No se puede dar de baja: ya tiene fecha de baja.');
--     ELSE
--         DBMS_OUTPUT.PUT_LINE('Error inesperado.');
--     END IF;
-- END;
-- /

-- -- ### Ejemplares después de ejecutar las pruebas
-- SELECT * FROM ejemplar;

-- -- EJERCICIO 15         (29)###################################################################################################
-- -- ### Préstamos antes de ejecutar las pruebas
-- SELECT * FROM prestamo;

-- -- ### Prueba para hacer un préstamo a un socio que no existe
-- DECLARE
--     v_resultado VARCHAR(6);
-- BEGIN
--     -- Llamar a la función
--     v_resultado := apertura_prestamo('S0000', 'ED0001', 1);

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Prestamo abierto: ' || v_resultado);
-- END;
-- /

-- -- ### Prueba para hacer un préstamo de una edición que no existe
-- DECLARE
--     v_resultado VARCHAR(6);
-- BEGIN
--     -- Llamar a la función
--     v_resultado := apertura_prestamo('S0001', 'ED0000', 1);

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Prestamo abierto: ' || v_resultado);
-- END;
-- /

-- -- ### Prueba para hacer un préstamo de una edición que ya está siendo prestada
-- DECLARE
--     v_resultado VARCHAR(6);
-- BEGIN
--     -- Llamar a la función
--     v_resultado := apertura_prestamo('S0001', 'ED0002', 1);

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Prestamo abierto: ' || v_resultado);
-- END;
-- /

-- -- ### Prueba para hacer un préstamo
-- DECLARE
--     v_resultado VARCHAR(6);
-- BEGIN
--     -- Llamar a la función
--     v_resultado := apertura_prestamo('S0001', 'ED0001', 1);

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Prestamo abierto: ' || v_resultado);
-- END;
-- /

-- -- ### Prueba para hacer un préstamo cuando ya ha sido prestado pero no cerrado
-- DECLARE
--     v_resultado VARCHAR(6);
-- BEGIN
--     -- Llamar a la función
--     v_resultado := apertura_prestamo('S0001', 'ED0001', 1);

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Prestamo abierto: ' || v_resultado);
-- END;
-- /

-- -- ### Préstamos después de ejecutar las pruebas
-- SELECT * FROM prestamo;

-- -- EJERCICIO 16         (30)###################################################################################################
-- -- ### Préstamos antes de ejecutar las pruebas
-- SELECT * FROM prestamo;

-- -- ### Prueba para cerrar un préstamo que no existe
-- DECLARE
--     v_resultado VARCHAR(6);
-- BEGIN
--     -- Llamar a la función
--     v_resultado := cierre_prestamo('P00000');

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Prestamo cerrado: ' || v_resultado);
-- END;
-- /

-- -- ### Prueba para cerrar un préstamo que ya ha sido cerrado
-- DECLARE
--     v_resultado VARCHAR(6);
-- BEGIN
--     -- Llamar a la función
--     v_resultado := cierre_prestamo('P00006');

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Prestamo cerrado: ' || v_resultado);
-- END;
-- /

-- -- ### Prueba para cerrar un préstamo
-- DECLARE
--     v_resultado VARCHAR(6);
-- BEGIN
--     -- Llamar a la función
--     v_resultado := cierre_prestamo('P00005');

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Prestamo cerrado: ' || v_resultado);
-- END;
-- /

-- -- ### Prueba para cerrar un préstamo que ya ha sido cerrado
-- DECLARE
--     v_resultado VARCHAR(6);
-- BEGIN
--     -- Llamar a la función
--     v_resultado := cierre_prestamo('P00005');

--     -- Mostrar el resultado
--     DBMS_OUTPUT.PUT_LINE('Prestamo cerrado: ' || v_resultado);
-- END;
-- /

-- ### Préstamos después de ejecutar las pruebas
SELECT * FROM prestamo;

-- COMPROBACIÓN DE LAS TABLAS DE HISTORIAL DE BORRADO
SELECT * FROM historico_obra_auditado;
SELECT * FROM historico_autor_auditado;
SELECT * FROM historico_autor_obra_auditado;
SELECT * FROM historico_edicion_auditado;
SELECT * FROM historico_ejemplar_auditado;
SELECT * FROM historico_socio_auditado;
SELECT * FROM historico_prestamo_auditado;