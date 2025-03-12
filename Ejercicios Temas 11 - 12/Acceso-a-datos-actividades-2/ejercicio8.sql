-- VERSION 1

CREATE OR REPLACE PROCEDURE
    LISTADO_LIQUIDACION
AS
    v_emp_no EMPLE.EMP_NO%TYPE;
    v_apellido EMPLE.APELLIDO%TYPE;
    v_dept_no EMPLE.APELLIDO%TYPE;
    v_oficio EMPLE.APELLIDO%TYPE;
    v_salario EMPLE.APELLIDO%TYPE;

    v_fecha_alt EMPLE.FECHA_ALT%TYPE;
    v_trienios NUMBER;
    v_complemento_responsabilidad NUMBER;

    v_comision EMPLE.COMISION%TYPE;
    v_total NUMBER;

    CURSOR v_cursor IS
        SELECT EMP_NO, APELLIDO, DEPT_NO, OFICIO, SALARIO, FECHA_ALT, COMISION FROM EMPLE;
BEGIN
    OPEN v_cursor;
        FETCH v_cursor INTO v_emp_no, v_apellido, v_dept_no, v_oficio, v_salario, v_fecha_alt, v_comision;

        WHILE v_cursor%FOUND
        LOOP
            v_trienios := FLOOR(FLOOR(MONTHS_BETWEEN(SYSDATE, v_fecha_alt))/12/3)*5;

            SELECT COUNT(*) INTO v_complemento_responsabilidad FROM EMPLE WHERE DIR = v_emp_no;

            v_complemento_responsabilidad := v_complemento_responsabilidad * 100;

            v_comision := NVL(v_comision, 0);

            v_total := v_salario + v_trienios + v_complemento_responsabilidad + v_comision;
            
            DBMS_OUTPUT.PUT_LINE(v_trienios);
            DBMS_OUTPUT.PUT_LINE('*************************************************************');
            DBMS_OUTPUT.PUT_LINE('Liquidación del empleado              ' || v_apellido);
            DBMS_OUTPUT.PUT_LINE('Dpto                                  ' || v_dept_no);
            DBMS_OUTPUT.PUT_LINE('Oficio                                ' || v_oficio);
            DBMS_OUTPUT.PUT_LINE('Salario                               ' || v_salario);
            DBMS_OUTPUT.PUT_LINE('Trienios                              ' || v_trienios);
            DBMS_OUTPUT.PUT_LINE('Comp. responsabilidad                 ' || v_complemento_responsabilidad);
            DBMS_OUTPUT.PUT_LINE('Comision                              ' || v_comision);
            DBMS_OUTPUT.PUT_LINE('*************************************************************');
            DBMS_OUTPUT.PUT_LINE('Total                                 ' || v_total);
            DBMS_OUTPUT.PUT_LINE('*************************************************************');
            DBMS_OUTPUT.PUT_LINE('');
            FETCH v_cursor INTO v_emp_no, v_apellido, v_dept_no, v_oficio, v_salario, v_fecha_alt, v_comision;
        END LOOP;
    CLOSE v_cursor;
END;
/

EXEC LISTADO_LIQUIDACION;

-- VERSION 2

CREATE OR REPLACE PROCEDURE
    LISTADO_LIQUIDACION
AS
    -- v_emp_no EMPLE.EMP_NO%TYPE;
    -- v_apellido EMPLE.APELLIDO%TYPE;
    -- v_dept_no EMPLE.APELLIDO%TYPE;
    -- v_oficio EMPLE.APELLIDO%TYPE;
    -- v_salario EMPLE.APELLIDO%TYPE;

    -- v_fecha_alt EMPLE.FECHA_ALT%TYPE;
    v_emple EMPLE%ROWTYPE;

    v_trienios NUMBER;
    v_complemento_responsabilidad NUMBER;

    -- v_comision EMPLE.COMISION%TYPE;
    v_total NUMBER;

    CURSOR v_cursor IS
        SELECT * FROM EMPLE;

BEGIN
    OPEN v_cursor;
        FETCH v_cursor INTO v_emple;

        WHILE v_cursor%FOUND
        LOOP
            v_trienios := FLOOR(FLOOR(MONTHS_BETWEEN(SYSDATE, v_emple.fecha_alt))/12/3)*5;

            SELECT COUNT(*) INTO v_complemento_responsabilidad FROM EMPLE WHERE DIR = v_emple.emp_no;

            v_complemento_responsabilidad := v_complemento_responsabilidad * 100;

            v_emple.comision := NVL(v_emple.comision, 0);

            v_total := v_emple.salario + v_trienios + v_complemento_responsabilidad + v_emple.comision;
            
            DBMS_OUTPUT.PUT_LINE(v_trienios);
            DBMS_OUTPUT.PUT_LINE('*************************************************************');
            DBMS_OUTPUT.PUT_LINE('Liquidación del empleado              ' || v_emple.apellido);
            DBMS_OUTPUT.PUT_LINE('Dpto                                  ' || v_emple.dept_no);
            DBMS_OUTPUT.PUT_LINE('Oficio                                ' || v_emple.oficio);
            DBMS_OUTPUT.PUT_LINE('Salario                               ' || v_emple.salario);
            DBMS_OUTPUT.PUT_LINE('Trienios                              ' || v_trienios);
            DBMS_OUTPUT.PUT_LINE('Comp. responsabilidad                 ' || v_complemento_responsabilidad);
            DBMS_OUTPUT.PUT_LINE('Comision                              ' || v_emple.comision);
            DBMS_OUTPUT.PUT_LINE('*************************************************************');
            DBMS_OUTPUT.PUT_LINE('Total                                 ' || v_total);
            DBMS_OUTPUT.PUT_LINE('*************************************************************');
            DBMS_OUTPUT.PUT_LINE('');
            FETCH v_cursor INTO v_emple;
        END LOOP;
    CLOSE v_cursor;
END;
/

EXEC LISTADO_LIQUIDACION;