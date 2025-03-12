CREATE OR REPLACE PROCEDURE
    DOS_EMPLEADOS_MENOR_SALARIO_POR_OFICIO
AS
    v_apellido EMPLE.APELLIDO%TYPE;
    v_oficio EMPLE.OFICIO%TYPE;
    v_salario EMPLE.SALARIO%TYPE;

    CURSOR v_cursor1 IS
        SELECT DISTINCT OFICIO FROM EMPLE;
    CURSOR v_cursor2 IS
        SELECT APELLIDO, SALARIO FROM EMPLE WHERE OFICIO = v_oficio ORDER BY SALARIO ASC FETCH FIRST 2 ROWS ONLY;
BEGIN
    OPEN v_cursor1;
        FETCH v_cursor1 INTO v_oficio;
        WHILE v_cursor1%FOUND
        LOOP
            DBMS_OUTPUT.PUT_LINE(v_oficio);

            OPEN v_cursor2;
                FETCH v_cursor2 INTO v_apellido, v_salario;
                WHILE v_cursor2%FOUND
                LOOP
                    DBMS_OUTPUT.PUT_LINE('    |' || v_apellido || ' - ' || v_salario);
                    FETCH v_cursor2 INTO v_apellido, v_salario;
                END LOOP;
            CLOSE v_cursor2;

            FETCH v_cursor1 INTO v_oficio;
        END LOOP;
    CLOSE v_cursor1;
END;
/

EXEC DOS_EMPLEADOS_MENOR_SALARIO_POR_OFICIO;