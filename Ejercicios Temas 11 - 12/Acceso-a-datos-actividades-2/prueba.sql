CREATE OR REPLACE TRIGGER mod_emple BEFORE INSERT ON emple FOR EACH ROW 
BEGIN
--   IF (:new.salario <:old.salario) THEN
--      INSERT INTO emple_auditado VALUES (:old.emp_no, :old.apellido, :old.salario, 
--                     :new.salario, SYSDATE);
--   END IF;
    UPDATE EMPLE SET SALARIO = 1 WHERE EMP_NO = :NEW.EMP_NO;
    :new.SALARIO := 1;
    DBMS_OUTPUT.PUT_LINE('Llego 1' || :old.emp_no || :new.emp_no);
    TEST;
END;
/

CREATE OR REPLACE PROCEDURE
    TEST
AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Llego 2');
END;
/


UPDATE EMPLE SET SALARIO = SALARIO WHERE 1 = 1;

INSERT INTO EMPLE VALUES (7939,'MUÑOZ','EMPLEADO',7783,'23/01/1992',
                        1690,NULL,10);

SELECT * FROM EMPLE WHERE EMP_NO = 7939;


EXEC TEST;