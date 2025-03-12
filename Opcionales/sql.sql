DROP TABLE sanciones;
DROP TABLE tipo_sancion;

CREATE TABLE tipo_sancion(
    id CHAR(2),
    nombre VARCHAR(10),
    dias_sancion INTEGER,
    CONSTRAINT PK_id_tipo_sancion PRIMARY KEY (id)
);

CREATE TABLE SANCIONES(
    id CHAR(6),
    socio CHAR(5),
    fecha DATE,
    prestamo CHAR(6),
    tipo_sancion CHAR(2),
    CONSTRAINT PK_id_sanciones PRIMARY KEY (id),
    CONSTRAINT FK_socio_sanciones FOREIGN KEY (socio) REFERENCES socio(id),
    CONSTRAINT PK_prestamo_sanciones FOREIGN KEY (prestamo) REFERENCES prestamo(id),
    CONSTRAINT PK_tipo_sancion_sanciones FOREIGN KEY (tipo_sancion) REFERENCES tipo_sancion(id)
);

INSERT INTO tipo_sancion VALUES (1, 'LEVE', 7);
INSERT INTO tipo_sancion VALUES (2, 'GRAVE', 30);
INSERT INTO tipo_sancion VALUES (3, 'MUY GRAVE', 90);






CREATE OR REPLACE FUNCTION apertura_prestamo(
    p_id_socio CHAR, 
    p_id_ejemplar CHAR, 
    p_numero_ejemplar INTEGER
) RETURN CHAR IS
    v_id CHAR(6);
    v_count_id INTEGER;
    v_count_prestamo INTEGER;
    v_count_socio INTEGER;
    v_count_ejemplar INTEGER;
    v_sancion sanciones%ROWTYPE;
    v_dias_sancion INTEGER;
BEGIN
    v_id := dbms_random.string('X', 6);

    -- Comprobar si ya existe el ID
    SELECT COUNT(*) INTO v_count_id FROM prestamo WHERE id = v_id;

    -- Si existe
    IF v_count_id = 1
    THEN
        return '-4';
    END IF;

    -- Comprobar si ya hay un prestamo sin cerrar de ese libro
    SELECT COUNT(*) INTO v_count_prestamo FROM prestamo WHERE id_ejemplar = p_id_ejemplar AND numero_ejemplar = p_numero_ejemplar AND fecha_devolucion IS NULL;

    -- Si el ejemplar aún está en préstamo
    IF v_count_prestamo > 0
    THEN
        return '-3';
    END IF;

    -- Comprobar si existe el socio
    SELECT COUNT(*) INTO v_count_socio FROM socio WHERE id = p_id_socio;

    -- Si el ejemplar aún está en préstamo
    IF v_count_socio = 0
    THEN
        return '-1';
    END IF;

    -- Comprobar si existe el ejemplar
    SELECT COUNT(*) INTO v_count_ejemplar FROM ejemplar WHERE id_edicion = p_id_ejemplar AND numero = p_numero_ejemplar;

    -- Si el ejemplar aún está en préstamo
    IF v_count_ejemplar = 0
    THEN
        return '-2';
    END IF;

    -- INSERT INTO sanciones VALUES ('AAAA02', 'S0002', SYSDATE+2, 'P00003', 2);
    -- INSERT INTO sanciones VALUES ('AAAA01', v_prestamo.id_socio, SYSDATE, v_prestamo.id, v_tipo_sancion);

    SELECT * INTO v_sancion FROM sanciones WHERE socio = 'S0002' ORDER BY fecha DESC;
    SELECT dias_sancion INTO v_dias_sancion FROM tipo_sancion WHERE id = v_sancion.tipo_sancion;

    IF (v_sancion.fecha + v_dias_sancion) >= SYSDATE
    THEN
        RETURN '-6';
    END IF;

    -- Insertar el nuevo préstamo
    INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo)
    VALUES (v_id, p_id_socio, p_id_ejemplar, p_numero_ejemplar, SYSDATE);

    -- Devolver el nuevo ID
    RETURN v_id;

EXCEPTION
    WHEN OTHERS THEN
        RETURN '-5';
END apertura_prestamo;
/

SELECT * FROM prestamo;
SELECT * FROM sanciones;




CREATE OR REPLACE FUNCTION cierre_prestamo(
    p_id_prestamo CHAR
) RETURN INTEGER IS
    v_id CHAR(6);
    v_count_id INTEGER;
    v_count INTEGER;
    v_prestamo prestamo%ROWTYPE;
    v_tipo_sancion INTEGER;
BEGIN
    -- Comprobar que el préstamo existe
    SELECT COUNT(*) INTO v_count FROM prestamo WHERE id = p_id_prestamo;

    -- Si el préstamo no existe
    IF v_count = 0
    THEN
        return '0';
    END IF;

    -- Comprobar que el préstamo no está cerrado
    SELECT * INTO v_prestamo FROM prestamo WHERE id = p_id_prestamo;

    -- Si el préstamo está cerrado
    IF v_prestamo.fecha_devolucion IS NOT NULL
    THEN
        return '-1';
    END IF;


    v_tipo_sancion := 0;

    DBMS_OUTPUT.PUT_LINE('sadasd');

    IF (SYSDATE - v_prestamo.fecha_prestamo) > 7+30 THEN
        DBMS_OUTPUT.PUT_LINE('3');
        v_tipo_sancion := 3;
    ELSIF (SYSDATE - v_prestamo.fecha_prestamo) > 7+7 THEN
        DBMS_OUTPUT.PUT_LINE('2');
        v_tipo_sancion := 2;
    ELSIF (SYSDATE - v_prestamo.fecha_prestamo) > 7 THEN
        DBMS_OUTPUT.PUT_LINE('1');
        v_tipo_sancion := 1;
    ELSE
        DBMS_OUTPUT.PUT_LINE('0');
    END IF;

    DBMS_OUTPUT.PUT_LINE('sadasd');

    IF v_tipo_sancion != 0
    THEN 
        SELECT COUNT(*) INTO v_count_id FROM sanciones WHERE id = v_id;

        -- Si existe
        IF v_count_id = 1
        THEN
            return '-4';
        END IF;

        INSERT INTO sanciones VALUES ('AAAA01', v_prestamo.id_socio, SYSDATE, v_prestamo.id, v_tipo_sancion);
    END IF;
    

    -- Cerrar préstamo
    UPDATE prestamo
    SET fecha_devolucion = SYSDATE
    WHERE id = p_id_prestamo;
    
    RETURN 1;
    
EXCEPTION
    WHEN OTHERS THEN
        RETURN '-2';
END cierre_prestamo;
/

show errors

DECLARE
    response VARCHAR(6);
BEGIN
    response := cierre_prestamo('P00002');
    DBMS_OUTPUT.PUT_LINE(response);
END;
/

SELECT * FROM prestamo;
SELECT * FROM sanciones;

DECLARE
    response VARCHAR(6);
BEGIN
    response := apertura_prestamo('S0002', 'ED0010', 1);
    DBMS_OUTPUT.PUT_LINE(response);
END;
/

SELECT * FROM prestamo;
SELECT * FROM sanciones;
