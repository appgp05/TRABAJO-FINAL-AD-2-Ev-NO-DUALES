CREATE OR REPLACE PROCEDURE
    INSERTAR_DEPARTAMENTO(dnombre DEPART.DNOMBRE%TYPE, loc DEPART.LOC%TYPE)
AS
    v_dept_no DEPART.DEPT_NO%TYPE;
    v_dnombre DEPART.DNOMBRE%TYPE;
    v_loc DEPART.LOC%TYPE;
BEGIN
    SELECT DEPT_NO INTO v_dept_no FROM DEPART ORDER BY DEPT_NO DESC FETCH FIRST 1 ROWS ONLY;
    v_dept_no := v_dept_no + 10;

    v_dnombre := dnombre;
    v_loc := loc;

    INSERT INTO DEPART VALUES (v_dept_no, v_dnombre, v_loc);

    DBMS_OUTPUT.PUT_LINE('Valores del nuevo departamento: ' || v_dept_no || ' ' || v_dnombre || ' ' || v_loc);
END;
/

EXEC INSERTAR_DEPARTAMENTO('hola', 'holo');

SELECT * FROM DEPART;