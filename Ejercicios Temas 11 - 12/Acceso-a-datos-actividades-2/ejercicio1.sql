CREATE OR REPLACE PROCEDURE
    VER_APELLIDOS_Y_FECHA_DE_ALTA
AS
    v_apellido EMPLE.APELLIDO%TYPE;
    v_fecha_alta EMPLE.FECHA_ALT%TYPE;
    CURSOR v_cursor1 IS
        SELECT APELLIDO, FECHA_ALT  FROM EMPLE;
BEGIN
    OPEN v_cursor1;
        FETCH v_cursor1 INTO v_apellido, v_fecha_alta;
        WHILE v_cursor1%FOUND LOOP
            DBMS_OUTPUT.PUT_LINE(v_apellido || ' - ' || v_fecha_alta);
            FETCH v_cursor1 INTO v_apellido, v_fecha_alta;
        END LOOP;
    CLOSE v_cursor1;
END;
/

EXEC VER_APELLIDOS_Y_FECHA_DE_ALTA;