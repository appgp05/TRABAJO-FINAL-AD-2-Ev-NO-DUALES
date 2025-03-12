DECLARE
    v_fecha DATE := TO_DATE('2025-10-01', 'YYYY-MM-DD');
    v_ano NUMBER;
BEGIN
    v_ano := VER_ANO(v_fecha);
    
    DBMS_OUTPUT.PUT_LINE('El año es: ' || v_ano);
END;
/