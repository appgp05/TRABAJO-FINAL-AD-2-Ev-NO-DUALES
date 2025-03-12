CREATE OR REPLACE PROCEDURE
    MOSTRAR_NOMBRES_DEPARTAMENTOS
AS
    v_dept_no DEPART.DEPT_NO%TYPE;
    v_dnombre DEPART.DNOMBRE%TYPE;
    v_no_empleados EMPLE.EMP_NO%TYPE;
    CURSOR v_cursor IS
        SELECT DEPT_NO, DNOMBRE FROM DEPART;
BEGIN
    OPEN v_cursor;
        FETCH v_cursor INTO v_dept_no, v_dnombre;
        WHILE v_cursor%FOUND LOOP
            SELECT COUNT(*) INTO v_no_empleados FROM EMPLE WHERE DEPT_NO = v_dept_no;

            DBMS_OUTPUT.PUT_LINE(v_dnombre || ' - ' || v_no_empleados);
            FETCH v_cursor INTO v_dept_no, v_dnombre;
        END LOOP;
    CLOSE v_cursor;
END;
/

EXEC MOSTRAR_NOMBRES_DEPARTAMENTOS;