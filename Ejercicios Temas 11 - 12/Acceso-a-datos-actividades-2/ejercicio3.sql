CREATE OR REPLACE PROCEDURE
    ESCRIBIR_TOP_5_EMPLEADOS_POR_SALARIO
AS
    v_apellido EMPLE.APELLIDO%TYPE;
    v_salario EMPLE.SALARIO%TYPE;
    CURSOR v_cursor IS
        SELECT APELLIDO, SALARIO FROM EMPLE ORDER BY SALARIO DESC FETCH FIRST 5 ROWS ONLY;
BEGIN
    OPEN v_cursor;
        FETCH v_cursor INTO v_apellido, v_salario;
        WHILE v_cursor%FOUND
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_apellido || ' - ' || v_salario);
            FETCH v_cursor INTO v_apellido, v_salario;
        END LOOP;
    CLOSE v_cursor;
END;
/

EXEC ESCRIBIR_TOP_5_EMPLEADOS_POR_SALARIO;