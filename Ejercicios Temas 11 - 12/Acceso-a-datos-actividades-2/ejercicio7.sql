CREATE OR REPLACE PROCEDURE
    SUBIR_SALARIO_MENOR_A_OFICIO
AS
    v_emp_no EMPLE.EMP_NO%TYPE;
    v_cantidad_empleados NUMBER;
    v_salario_total_oficio EMPLE.SALARIO%TYPE;
    v_salario_medio_oficio EMPLE.SALARIO%TYPE;
    v_oficio EMPLE.OFICIO%TYPE;
    v_salario EMPLE.SALARIO%TYPE;
    CURSOR v_cursor1 IS
        SELECT DISTINCT OFICIO FROM EMPLE;
    CURSOR v_cursor2 IS
        SELECT EMP_NO, SALARIO FROM EMPLE WHERE OFICIO = v_oficio;
BEGIN
    OPEN v_cursor1;
        FETCH v_cursor1 INTO v_oficio;
        WHILE v_cursor1%FOUND
        LOOP
            SELECT COUNT(*) INTO v_cantidad_empleados FROM EMPLE WHERE OFICIO = v_oficio;
            SELECT SUM(SALARIO) INTO v_salario_total_oficio FROM EMPLE WHERE OFICIO = v_oficio;
            v_salario_medio_oficio := v_salario_total_oficio / v_cantidad_empleados;

            DBMS_OUTPUT.PUT_LINE(v_cantidad_empleados || ' - ' || v_salario_total_oficio || ' - ' || v_salario_medio_oficio);

            OPEN v_cursor2;
                FETCH v_cursor2 INTO v_emp_no, v_salario;
                WHILE v_cursor2%FOUND
                LOOP
                    DBMS_OUTPUT.PUT_LINE(v_salario || ' - ');

                    IF v_salario_medio_oficio < v_salario THEN
                        DBMS_OUTPUT.PUT_LINE('Mayor');
                    ELSE
                        DBMS_OUTPUT.PUT_LINE('Menor ' || (v_salario_medio_oficio - v_salario) / 100 * 50);
                        UPDATE EMPLE SET SALARIO = SALARIO + (v_salario_medio_oficio - v_salario) / 100 * 50 WHERE EMP_NO = v_emp_no;
                    END IF;

                    FETCH v_cursor2 INTO v_emp_no, v_salario;
                END LOOP;
            CLOSE v_cursor2;
            FETCH v_cursor1 INTO v_oficio;
        END LOOP;
    CLOSE v_cursor1;
END;
/

EXEC SUBIR_SALARIO_MENOR_A_OFICIO;