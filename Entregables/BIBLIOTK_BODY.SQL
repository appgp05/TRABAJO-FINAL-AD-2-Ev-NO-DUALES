-- ######################################
-- PACKAGE CON EL CUERPO DE LAS FUNCIONES
-- ######################################

CREATE OR REPLACE PACKAGE BODY BiblioTK IS
    -- ###########
    -- OBLIGATORIO
    -- ###########

    -- EJERCICIO 1         (08)###################################################################################################
    FUNCTION alta_obra(
        p_titulo VARCHAR,
        p_anyo INTEGER DEFAULT NULL) 
    RETURN VARCHAR IS
        v_id CHAR(5);
        v_count_id INTEGER;
    BEGIN
        -- Generar un ID aleatorio de 5 carácteres en mayúsculas
        v_id := dbms_random.string('X', 5);

        -- Comprobar si ya existe el ID
        SELECT COUNT(*) INTO v_count_id FROM obra WHERE id = v_id;

        -- Si existe
        IF v_count_id = 1
        THEN
            return -1;
        END IF;
        
        -- Insertar la nueva obra
        INSERT INTO obra (id, titulo, anyo)
        VALUES (v_id, p_titulo, p_anyo); 

        -- Devolver el nuevo ID
        RETURN v_id;

    EXCEPTION
        -- En caso de error, devolver '-1'
        WHEN OTHERS THEN
            RETURN '-1';
    END alta_obra;

    -- EJERCICIO 2         (09)###################################################################################################
    FUNCTION borrado_obra(
        p_id VARCHAR) 
    RETURN INTEGER IS
        v_count INTEGER;
    BEGIN
        -- Comprobar si existe la obra con el ID proporcionado
        SELECT COUNT(*) INTO v_count FROM OBRA WHERE id = p_id;

        -- Si no existe, 
        IF v_count = 0
        THEN
            return 0;
        END IF; 

        -- Si existe, eliminar la obra y devolver 1 
        DELETE FROM OBRA WHERE id = p_id;
        RETURN 1;

    EXCEPTION
        -- En caso de error, devolver '-1'
        WHEN OTHERS THEN
            RETURN -1;
    END borrado_obra;

    -- EJERCICIO 4        (10)###################################################################################################
    FUNCTION alta_autor(
        p_nombre VARCHAR,
        p_apellidos VARCHAR,
        p_nacimiento DATE DEFAULT NULL)
    RETURN VARCHAR IS
        v_id CHAR(4);
        v_count_id INTEGER;
    BEGIN
        -- Generar un ID aleatorio de 4 carácteres en mayúsculas
        v_id := dbms_random.string('X', 4);

        -- Comprobar si ya existe el ID
        SELECT COUNT(*) INTO v_count_id FROM autor WHERE id = v_id;

        -- Si existe
        IF v_count_id = 1
        THEN
            return -1;
        END IF;
        
        -- Insertar el nuevo autor
        INSERT INTO autor (id, nombre, apellidos, nacimiento) VALUES (v_id, p_nombre, p_apellidos, p_nacimiento);

        -- Devolver el nuevo ID
        RETURN v_id;

    EXCEPTION
        -- En caso de error, devolver '-1'
        WHEN OTHERS THEN
            RETURN '-1';
    END alta_autor;

    -- EJERCICIO 5        (11)###################################################################################################
    FUNCTION borrado_autor (
        p_id VARCHAR) 
    RETURN INTEGER IS
        v_count INTEGER; -- Variable para verificar si el autor existe
    BEGIN
        -- Verificar si el autor con el ID proporcionado existe
        SELECT COUNT(*) INTO v_count FROM autor WHERE id = p_id;

        -- Si no existe, devolver 0
        IF v_count = 0 THEN
            RETURN 0;
        END IF;

        -- Si existe, eliminar el autor
        DELETE FROM autor WHERE id = p_id;

        -- Devolver 1 indicando que el autor fue elimnado 
        RETURN 1;

    EXCEPTION
        WHEN OTHERS THEN
            -- Si ocurre un error devolver -1
            RETURN -1;
    END borrado_autor;

    -- EJERCICIO 6        (12)###################################################################################################
    FUNCTION vincular (
        p_id_autor VARCHAR,
        p_id_obra VARCHAR)
    RETURN INTEGER IS
        v_count_autor INTEGER;
        v_count_obra INTEGER;
        v_count_vinculo INTEGER;
    BEGIN
        -- Verificar si el autor existe en la tabla autor
        SELECT COUNT(*) INTO v_count_autor FROM autor WHERE id = p_id_autor;
        IF v_count_autor = 0 THEN
            RETURN -1; -- Autor no encontado
        END IF;

        -- Verificar si la obra existe en la tabla obra
        SELECT COUNT(*) INTO v_count_obra FROM obra WHERE id = p_id_obra;
        IF v_count_obra = 0 THEN
            RETURN -1; -- Obra no encontrada
        END IF;

        -- Verificar si la relación ya existe en 'autor_obra'
        SELECT COUNT(*) INTO v_count_vinculo FROM autor_obra
        WHERE id_autor = p_id_autor AND id_obra = p_id_obra;

        IF v_count_vinculo > 0 THEN
            RETURN -1; -- La relaciön ya existe
        END IF;

        -- Insertamos la vinculación en 'autor_obra'
        INSERT INTO autor_obra (id_autor, id_obra)
        VALUES (p_id_autor, p_id_obra);

        RETURN 1; -- Vinculación existosa

    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1; -- Error
    END vincular;

    -- EJERCICIO 7         (13)###################################################################################################
    FUNCTION desvincular(
        p_id_autor VARCHAR,
        p_id_obra VARCHAR)
    RETURN INTEGER IS
        v_count_vinculo INTEGER;
    BEGIN
        -- Verificar si la relación existe en `autor_obra`
        SELECT COUNT(*) INTO v_count_vinculo FROM autor_obra 
        WHERE id_autor = p_id_autor AND id_obra = p_id_obra;

        -- Si no hay vínculo, devolver 0
        IF v_count_vinculo = 0 THEN
            RETURN 0; -- No existe vínculo
        END IF;

        -- Eliminar la vinculación en `autor_obra`
        DELETE FROM autor_obra 
        WHERE id_autor = p_id_autor AND id_obra = p_id_obra;

        RETURN 1;
        -- -- Verificar si se realizó la eliminación
        -- IF SQL%ROWCOUNT > 0 THEN
        --     COMMIT;
        --     RETURN 1; -- Desvinculación exitosa
        -- ELSE
        --     RETURN 0; -- No se eliminó nada (caso raro)
        -- END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1; -- Error inesperado
    END desvincular;

    -- EJERCICIO 8         (14)###################################################################################################
    FUNCTION alta_edicion(
        p_id_obra VARCHAR,
        p_isbn VARCHAR,
        p_anyo INTEGER DEFAULT NULL) 
    RETURN VARCHAR IS
        v_id CHAR(6);
        v_count_id INTEGER;
        v_count_obra INTEGER;
    BEGIN
        -- Verificar que la obra existe
        SELECT COUNT(*) INTO v_count_obra FROM obra WHERE id = p_id_obra;
        IF v_count_obra = 0 THEN
            RETURN '-1';  -- Error: la obra no existe
        END IF;

        -- Generar un ID aleatorio de 6 carácteres en mayúsculas
        v_id := dbms_random.string('X', 6);

        -- Comprobar si ya existe el ID
        SELECT COUNT(*) INTO v_count_id FROM obra WHERE id = v_id;

        -- Si existe
        IF v_count_id = 1
        THEN
            return '-1';
        END IF;

        -- Insertar la nueva edición
        INSERT INTO edicion (id, id_obra, isbn, anyo)
        VALUES (v_id, p_id_obra, p_isbn, p_anyo);

        RETURN v_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '-1';  -- En caso de cualquier error
    END alta_edicion;

    -- EJERCICIO 9         (15)###################################################################################################
    FUNCTION borrado_edicion (
        p_id VARCHAR)
    RETURN INTEGER IS 
        v_count INTEGER;
    BEGIN
        -- Verificar si la edición existe
        SELECT COUNT(*) INTO v_count FROM edicion WHERE id = p_id;
        
        -- Si no existe devolver 0
        IF v_count = 0 THEN
            RETURN 0;
        END IF;

        -- Si existe, eliminar la obra
        DELETE FROM edicion WHERE id = p_id;

        -- Devolver 1 indicando que la obra fue eliminada correctamente y guardar cambios
        RETURN 1;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1;
    END borrado_edicion;

    -- EJERCICIO 10         (16, 17, 18)###################################################################################################
    FUNCTION alta_ejemplar(
        p_id_edicion VARCHAR) 
    RETURN INTEGER IS
        v_max_numero INTEGER;
        v_new_numero INTEGER;
        v_count_edicion INTEGER;
    BEGIN
        -- Comprobar si la edición existe
        SELECT COUNT(*) INTO v_count_edicion
        FROM edicion
        WHERE id = p_id_edicion;

        IF v_count_edicion = 0 THEN
            RETURN -1;  -- Retorna -1 si la edición no existe
        END IF;

        -- Encontrar el número más alto de ejemplares para esta edición
        SELECT COALESCE(MAX(numero), 0) INTO v_max_numero -- Coalesce sustituye NULL por 0
        FROM ejemplar
        WHERE id_edicion = p_id_edicion;

        -- Asignar el nuevo número
        v_new_numero := v_max_numero + 1;

        -- Insertar el nuevo ejemplar con la fecha actual
        INSERT INTO ejemplar (id_edicion, numero, alta)
        VALUES (p_id_edicion, v_new_numero, SYSDATE);

        -- Devolver el número asignado
        RETURN v_new_numero;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN -2;  -- Devuelve -2 si ocurre un error inesperado
    END alta_ejemplar;

    -- EJERCICIO 11         (19, 20, 21, 22)###################################################################################################
    FUNCTION borrado_ejemplar (
        p_id_edicion VARCHAR,
        p_numero INTEGER)
    RETURN INTEGER IS 
        v_max_numero INTEGER;
        v_alta DATE;
        v_baja DATE;
        v_count INTEGER;
    BEGIN
        -- Verificar si el ejemplar existe
        SELECT COUNT(*), MAX(numero) INTO v_count, v_max_numero
        FROM ejemplar
        WHERE id_edicion = p_id_edicion;

        -- Si el ejemplar no existe, devolver 0
        IF v_count = 0 THEN
            RETURN 0;
        END IF;

        -- Verificar si el ejemplar es el último de su serie
        IF p_numero != v_max_numero THEN
            RETURN -1;
        END IF;

        -- Obtener datos del ejemplar específico
        SELECT alta, baja INTO v_alta, v_baja
        FROM ejemplar
        WHERE id_edicion = p_id_edicion AND numero = p_numero;

        -- Verificar que no tenga fecha de baja y que no hayan pasado más de 30 días
        IF v_baja IS NOT NULL OR (SYSDATE - v_alta) > 30 THEN
            RETURN -1;
        END IF;

        -- Si todas las condiciones se cumplen, eliminar el ejemplar
        DELETE FROM ejemplar
        WHERE id_edicion = p_id_edicion AND numero = p_numero;

        -- Devolver 1 indicando que el ejemplar fue eliminado correctamente y guardar cambios
        RETURN 1;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1; -- Error inesperado
    END borrado_ejemplar;

    -- EJERCICIO 12         (19, 23, 24, 25, 26)###################################################################################################
    FUNCTION baja_ejemplar(
        p_id_edicion VARCHAR,
        p_numero INTEGER)
    RETURN INTEGER IS
        v_baja DATE;
        v_count INTEGER;
    BEGIN
        -- Verificar si el ejemplar existe
        SELECT COUNT(*) INTO v_count
        FROM ejemplar
        WHERE id_edicion = p_id_edicion AND numero = p_numero;

        -- Si el ejemplar no existe, devolver 0
        IF v_count = 0 THEN
            RETURN 0;
        END IF;

        -- Obtener la fecha de baja
        SELECT baja INTO v_baja
        FROM ejemplar
        WHERE id_edicion = p_id_edicion AND numero = p_numero;

        -- Verificar que el ejemplar no tenga fecha de baja
        IF v_baja IS NOT NULL THEN
            RETURN -1;
        END IF;

        -- Actualizar la fecha de baja con la fecha actual del sistema
        UPDATE ejemplar
        SET baja = SYSDATE
        WHERE id_edicion = p_id_edicion AND numero = p_numero;

        RETURN 1;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1; -- Error inesperado
    END baja_ejemplar;
    
    -- ########
    -- OPCIONAL
    -- ########

    -- EJERCICIO 15         (29)###################################################################################################
    FUNCTION apertura_prestamo(
        p_id_socio CHAR, 
        p_id_ejemplar CHAR, 
        p_numero_ejemplar INTEGER
    ) RETURN CHAR IS
        v_id CHAR(6);
        v_count_id INTEGER;
        v_count_prestamo INTEGER;
        v_count_socio INTEGER;
        v_count_ejemplar INTEGER;
    BEGIN
        v_id := dbms_random.string('X', 6);

        -- Comprobar si ya existe el ID
        SELECT COUNT(*) INTO v_count_id FROM prestamo WHERE id = v_id;

        -- Si existe
        IF v_count_id = 1
        THEN
            return '-4';
        END IF;

        -- Comprobar si ya hay un prestamo sin cerrar de ese libro
        SELECT COUNT(*) INTO v_count_prestamo FROM prestamo WHERE id_ejemplar = p_id_ejemplar AND numero_ejemplar = p_numero_ejemplar AND fecha_devolucion IS NULL;

        -- Si el ejemplar aún está en préstamo
        IF v_count_prestamo > 0
        THEN
            return '-3';
        END IF;

        -- Comprobar si existe el socio
        SELECT COUNT(*) INTO v_count_socio FROM socio WHERE id = p_id_socio;

        -- Si el ejemplar aún está en préstamo
        IF v_count_socio = 0
        THEN
            return '-1';
        END IF;

        -- Comprobar si existe el ejemplar
        SELECT COUNT(*) INTO v_count_ejemplar FROM ejemplar WHERE id_edicion = p_id_ejemplar AND numero = p_numero_ejemplar;

        -- Si el ejemplar aún está en préstamo
        IF v_count_ejemplar = 0
        THEN
            return '-2';
        END IF;

        -- Insertar el nuevo préstamo
        INSERT INTO prestamo (id, id_socio, id_ejemplar, numero_ejemplar, fecha_prestamo)
        VALUES (v_id, p_id_socio, p_id_ejemplar, p_numero_ejemplar, SYSDATE);

        -- Devolver el nuevo ID
        RETURN v_id;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN '-5';
    END apertura_prestamo;


    -- EJERCICIO 16         (30)###################################################################################################
    FUNCTION cierre_prestamo(
        p_id_prestamo CHAR
    ) RETURN INTEGER IS
        v_count INTEGER;
        v_fecha_devolucion DATE;
    BEGIN
        -- Comprobar que el préstamo existe
        SELECT COUNT(*) INTO v_count FROM prestamo WHERE id = p_id_prestamo;

        -- Si el préstamo no existe
        IF v_count = 0
        THEN
            return '0';
        END IF;

        -- Comprobar que el préstamo no está cerrado
        SELECT fecha_devolucion INTO v_fecha_devolucion FROM prestamo WHERE id = p_id_prestamo;

        -- Si el préstamo está cerrado
        IF v_fecha_devolucion IS NOT NULL
        THEN
            return '-1';
        END IF;

        -- Cerrar préstamo
        UPDATE prestamo
        SET fecha_devolucion = SYSDATE
        WHERE id = p_id_prestamo;
        
        RETURN 1;
        
    EXCEPTION
        WHEN OTHERS THEN
            RETURN '-2';
    END cierre_prestamo;
END;
/