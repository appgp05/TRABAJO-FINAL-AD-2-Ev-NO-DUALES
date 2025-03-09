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
    v_id CHAR(6);
    v_count_id INTEGER;
    v_count INTEGER;
BEGIN
    v_id := dbms_random.string('X', 6);

    -- Comprobar si ya existe el ID
    SELECT COUNT(*) INTO v_count_id FROM prestamo WHERE id = v_id;

    -- Si existe
    IF v_count_id = 1
    THEN
        return '-1';
    END IF;

    -- Comprobar si ya hay un prestamo sin cerrar de ese libro
    SELECT COUNT(*) INTO v_count FROM prestamo WHERE id_ejemplar = p_id_ejemplar AND numero_ejemplar = p_numero_ejemplar AND fecha_devolucion IS NULL;

    -- Si el ejemplar aún está en préstamo
    IF v_count > 0
    THEN
        return '-1';
    END IF;

    -- Insertar el nuevo préstamo
    INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo)
    VALUES (v_id, p_id_socio, p_id_ejemplar, p_numero_ejemplar, SYSDATE);

    -- Devolver el nuevo ID
    RETURN v_id;

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
    v_count INTEGER;
    v_fecha_devolucion DATE;
BEGIN
    -- Comprobar que el préstamo existe
    SELECT COUNT(*) INTO v_count FROM prestamo WHERE id = p_id_prestamo;

    -- Si el préstamo no existe
    IF v_count = 0
    THEN
        return '0';
    END IF;

    -- Comprobar que el préstamo no está cerrado
    SELECT fecha_devolucion INTO v_fecha_devolucion FROM prestamo WHERE id = p_id_prestamo;

    -- Si el préstamo está cerrado
    IF v_fecha_devolucion IS NOT NULL
    THEN
        return '-1';
    END IF;

    -- Cerrar préstamo
    UPDATE prestamo
    SET fecha_devolucion = SYSDATE
    WHERE id = p_id_prestamo;
    
    RETURN 1;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN -1;
END cierre_prestamo;
/