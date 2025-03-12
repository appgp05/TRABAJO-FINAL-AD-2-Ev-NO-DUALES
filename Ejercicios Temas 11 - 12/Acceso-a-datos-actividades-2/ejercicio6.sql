CREATE OR REPLACE PROCEDURE
    SUBIR_SALARIO(a_dept_no DEPART.DEPT_NO%TYPE, importe NUMBER, porcentaje NUMBER)
AS
    v_dept_no DEPART.DEPT_NO%TYPE;
    v_importe NUMBER(5,2);
    v_porcentaje NUMBER(4,2);

    v_emp_no EMPLE.EMP_NO%TYPE;
    v_apellido EMPLE.APELLIDO%TYPE;
    v_salario EMPLE.SALARIO%TYPE;

    CURSOR v_cursor IS
        SELECT EMP_NO, APELLIDO, SALARIO FROM EMPLE WHERE DEPT_NO = a_dept_no;
BEGIN
    v_dept_no := a_dept_no;
    v_importe := importe;
    v_porcentaje := porcentaje;
    DBMS_OUTPUT.PUT_LINE('Número de departamento: ' || v_dept_no || ', Importe: ' || v_importe || ', Porcentaje: ' || v_porcentaje);

    OPEN v_cursor;
        FETCH v_cursor INTO v_emp_no, v_apellido, v_salario;
        WHILE v_cursor%FOUND
        LOOP
            DBMS_OUTPUT.PUT_LINE('Salario:' || v_salario || ' de ' || v_apellido || ' con el número ' || v_emp_no);

            DBMS_OUTPUT.PUT_LINE('Importe: ' || v_importe || ', Porcentaje aplicado: ' || v_salario/100*v_porcentaje);
            IF v_importe > v_salario/100 * v_porcentaje THEN
                DBMS_OUTPUT.PUT_LINE('El importe es mayor que el porcentaje aplicado al salario.');
                UPDATE EMPLE SET SALARIO = SALARIO + v_importe WHERE EMP_NO = v_emp_no;
            ELSE
                DBMS_OUTPUT.PUT_LINE('El importe es menor que el porcentaje aplicado al salario.');
                UPDATE EMPLE SET SALARIO = v_salario/100 * v_porcentaje WHERE EMP_NO = v_emp_no;
            END IF;

            FETCH v_cursor INTO v_emp_no, v_apellido, v_salario;
        END LOOP;
    CLOSE v_cursor;
END;
/

EXEC SUBIR_SALARIO(30, 16, 1);