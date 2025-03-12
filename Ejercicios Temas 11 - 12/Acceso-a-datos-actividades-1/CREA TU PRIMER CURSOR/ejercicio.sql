-- SET SERVEROUTPUT ON

-- DECLARE
--   CURSOR v_cur1 IS 
--     SELECT dnombre, loc FROM DEPART;
--   v_nombre DEPART.dnombre%TYPE;
--   v_localidad DEPART.loc%TYPE; 
-- BEGIN
--   OPEN v_cur1;
--   LOOP
--     FETCH v_cur1 INTO v_nombre, v_localidad;
--     EXIT WHEN v_cur1%NOTFOUND;

--     DBMS_OUTPUT.PUT_LINE(v_nombre||' * '||v_localidad);
--   END LOOP;
--   DBMS_OUTPUT.PUT_LINE('');
--   DBMS_OUTPUT.PUT_LINE(v_cur1%ROWCOUNT||' DEPARTAMENTOS LISTADOS');
--   CLOSE v_cur1;
-- END;
-- /

SET SERVEROUTPUT ON

DECLARE

BEGIN
  SELECT EMP_NO, APELLIDO FROM EMPLE
  WHERE DEPT_NO = 10;
END;
/

-- Este ejemplo falla porque falta la cláusula INTO en el SELECT.


DECLARE
  v_num_emple EMPLE.EMP_NO%TYPE;
  v_apellido EMPLE.APELLIDO%TYPE;
BEGIN
  SELECT EMP_NO, APELLIDO INTO v_num_emple, v_apellido
  FROM EMPLE
  WHERE DEPT_NO = 10 AND SALARIO > 4000;
  DBMS_OUTPUT.PUT_LINE('El empleado '||v_apellido||' tiene el número de empleado: '||v_num_emple);
END;
/

-- EL SIGUIENTE ejemplo falla porque el SELECT DEVUELVE MAS DE UNA FILA !!!!!
--  No podremos utilizar el SELECT INTO, ya que en una variable NO CABE más de un valor

DECLARE
  v_num_emple EMPLE.EMP_NO%TYPE;
  v_apellido EMPLE.APELLIDO%TYPE;
BEGIN
  SELECT EMP_NO, APELLIDO INTO v_num_emple, v_apellido
  FROM EMPLE
  WHERE DEPT_NO = 10 AND SALARIO > 1000;
  DBMS_OUTPUT.PUT_LINE('El empleado '||v_apellido||' tiene el número de empleado: '||v_num_emple);
END;
/














DECLARE
    CURSOR v_cursor IS SELECT EMP_NO, APELLIDO FROM EMPLE WHERE DEPT_NO = 10 AND SALARIO > 1000;
    v_num_emple EMPLE.EMP_NO%TYPE;
    v_apellido EMPLE.APELLIDO%TYPE;
BEGIN
    OPEN v_cursor;
    LOOP
        FETCH v_cursor INTO v_num_emple, v_apellido;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('El empleado '||v_apellido||' tiene el número de empleado: '||v_num_emple);
    END LOOP;

  
    
END;
/





DECLARE
  CURSOR v_cur1 IS 
    SELECT dnombre, loc FROM DEPART;
  v_nombre DEPART.dnombre%TYPE;
  v_localidad DEPART.loc%TYPE; 
BEGIN
  OPEN v_cur1;
  LOOP
    FETCH v_cur1 INTO v_nombre, v_localidad;
    EXIT WHEN v_cur1%NOTFOUND;

    DBMS_OUTPUT.PUT_LINE(v_nombre||' * '||v_localidad);
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('');
  DBMS_OUTPUT.PUT_LINE(v_cur1%ROWCOUNT||' DEPARTAMENTOS LISTADOS');
  CLOSE v_cur1;
END;


















-- POSIBLE SOLUCIÓN:  CAPTURAR EL ERROR
DECLARE
  v_num_emple EMPLE.EMP_NO%TYPE;
  v_apellido EMPLE.APELLIDO%TYPE;
BEGIN
  SELECT EMP_NO, APELLIDO INTO v_num_emple, v_apellido
  FROM EMPLE
  WHERE DEPT_NO = 10 AND SALARIO > 100000;
  DBMS_OUTPUT.PUT_LINE('El empleado '||v_apellido||' tiene el número de empleado: '||v_num_emple);
EXCEPTION
  WHEN NO_DATA_FOUND THEN  
        DBMS_OUTPUT.PUT_LINE('NO HAY RESULTADOS !!!');
  WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('EL SELECT DEVUELVE MÁS DE UNA FILA !!!');
   WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDEFINIDO');
END;
/

-- Una posible solución sería codificar los errores (con números de error) y 
-- devolver a quien nos invoca el código de error para que pida nuevamente 
-- parámetros y me ejecute de nuevo con parámetros correctos
--  (para esto tendré que ser una función parametrizable)

CREATE FUNCTION Ver_Emple_Por_Salario_Dept (Num_depto NUMBER, Salario_dpto NUMBER) RETURN NUMBER AS
-- DEVUELVO -1 SINO HAY DATOS, -2 SI HAY MAS DE UNA FILA
-- -3 EN OTRO CASO  Y 1 SI TODO HA IDO BIEN
  v_num_emple EMPLE.EMP_NO%TYPE;
  v_apellido EMPLE.APELLIDO%TYPE;
BEGIN
  SELECT EMP_NO, APELLIDO INTO v_num_emple, v_apellido
  FROM EMPLE
  WHERE DEPT_NO = 

Num_depto   AND SALARIO > 

Salario_dpto  ;
  DBMS_OUTPUT.PUT_LINE('El empleado '||v_apellido||' tiene el número de empleado: '||v_num_emple);
   RETURN(1);  -- TODO OK
EXCEPTION
  WHEN NO_DATA_FOUND THEN  
        DBMS_OUTPUT.PUT_LINE('NO HAY RESULTADOS !!!');
        RETURN (-1);
  WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('EL SELECT DEVUELVE MÁS DE UNA FILA !!!');
        RETURN (-2);
   WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('ERROR INDEFINIDO');
        RETURN (-3);
END;
/

-- SI HAY ERRORES DE COMPILACIÓN HAY QUE UTILIZAR "SHOW ERRORS" PARA VERLOS

DECLARE
     v_res NUMBER(1);
BEGIN
     v_res := 
Ver_Emple_Por_Salario_Dept (10, 1000);
     CASE 
         WHEN v_res  = 1 THEN
               DBMS_OUTPUT.PUT_LINE('TODO OK !!!!');
         WHEN v_res  = -1 THEN
               DBMS_OUTPUT.PUT_LINE('NO HAY RESULTADOS PARA ESOS PARÁMETROS !!!!');
               DBMS_OUTPUT.PUT_LINE('VOY A PROBAR CON DEPTO 10 Y SALARIO 4000 !!!!');
               v_res  := Ver_Emple_Por_Salario_Dept (10, 4000);
         WHEN v_res  = -2 THEN
              DBMS_OUTPUT.PUT_LINE('HAY MAS DE UN RESULTADO PARA ESOS PARÁMETROS !!!!');
               DBMS_OUTPUT.PUT_LINE('VOY A PROBAR CON DEPTO 10 Y SALARIO 4000 !!!!');
               v_res  := Ver_Emple_Por_Salario_Dept (10, 4000);
         WHEN v_res  = -3 THEN
               DBMS_OUTPUT.PUT_LINE('ERROR FATAL INDEFINIDO EN LA FUNCIÓN !!!!');
      END CASE;
END;
/