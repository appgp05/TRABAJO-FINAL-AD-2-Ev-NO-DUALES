-- ÉSTA ES LA PARTE OPCIONAL

-- #########################
-- EJERCICIO 3        (09.1)
-- #########################
DROP TABLE historico_obra_auditado;

CREATE TABLE historico_obra_auditado (
    id CHAR(5),
    titulo VARCHAR(100),
    anyo INTEGER,
    fecha_borrado TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT PK_historico_obra_auditado PRIMARY KEY (id)
);

-- #########################################
-- EJERCICIO 13         (27)
-- #########################################
DROP TABLE socio;

CREATE TABLE socio (
    id CHAR(5),
    nombre VARCHAR(50),
    apellidos VARCHAR(100),
    CONSTRAINT PK_socio PRIMARY KEY (id),
    CONSTRAINT NN_socio_nombre CHECK (nombre IS NOT NULL),
    CONSTRAINT NN_socio_apellidos CHECK (apellidos IS NOT NULL)
);

-- #########################################
-- EJERCICIO 14         (28)
-- #########################################
DROP TABLE prestamo;

CREATE TABLE prestamo (
    id CHAR(6),
    id_socio CHAR(5),
    id_ejemplar CHAR(6),
    numero_ejemplar INTEGER,
    fecha_prestamo DATE DEFAULT SYSDATE,
    fecha_devolucion DATE,
    CONSTRAINT PK_prestamo PRIMARY KEY (id),
    CONSTRAINT NN_prestamo_id_socio CHECK (id_socio IS NOT NULL),
    CONSTRAINT NN_prestamo_id_ejemplar CHECK (id_ejemplar IS NOT NULL),
    CONSTRAINT NN_prestamo_numero_ejemplar CHECK (numero_ejemplar IS NOT NULL),
    CONSTRAINT FK_prestamo_id_socio FOREIGN KEY (id_socio) REFERENCES socio(id),
    CONSTRAINT FK_prestamo_id_ejemplar FOREIGN KEY (id_ejemplar, numero_ejemplar) REFERENCES ejemplar(id_edicion, numero)
);



-- #########################################
-- EJERCICIO 15         (29)
-- #########################################
CREATE OR REPLACE FUNCTION apertura_prestamo(
    p_id_socio CHAR, 
    p_id_ejemplar CHAR, 
    p_numero_ejemplar INTEGER
) RETURN CHAR IS
    v_id_prestamo CHAR(6);
BEGIN
    v_id_prestamo := dbms_random.string('X', 6);
    INSERT INTO prestamo (id_prestamo, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo)
    VALUES (v_id_prestamo, p_id_socio, p_id_ejemplar, p_numero_ejemplar, SYSDATE);
    RETURN v_id_prestamo;
EXCEPTION
    WHEN OTHERS THEN
        RETURN '-1';
END apertura_prestamo;
/

-- #########################################
-- EJERCICIO 16         (30)
-- #########################################
CREATE OR REPLACE FUNCTION cierre_prestamo(
    p_id_prestamo CHAR
) RETURN INTEGER IS
BEGIN
    UPDATE prestamo
    SET fecha_devolucion = SYSDATE
    WHERE id_prestamo = p_id_prestamo AND fecha_devolucion IS NULL;
    IF SQL%ROWCOUNT = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END cierre_prestamo;
/