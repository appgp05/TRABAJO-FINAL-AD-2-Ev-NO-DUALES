-- #####################################################
-- PACKAGE CON LOS NOMBRES DE LAS FUNCIONES OBLIGATORIAS
-- #####################################################

CREATE OR REPLACE PACKAGE BiblioTK AS
    -- EJERCICIO 1         (08)
    FUNCTION alta_obra(
        p_titulo VARCHAR,
        p_anyo INTEGER DEFAULT NULL) 
    RETURN VARCHAR;

    -- EJERCICIO 2         (09)
    FUNCTION borrado_obra(
        p_id VARCHAR) 
    RETURN INTEGER;

    -- EJERCICIO 4        (10)
    FUNCTION alta_autor(
        p_nombre VARCHAR,
        p_apellidos VARCHAR,
        p_nacimiento DATE DEFAULT NULL)
    RETURN VARCHAR;

    -- EJERCICIO 5        (11)
    FUNCTION borrado_autor (
        p_id VARCHAR) 
    RETURN INTEGER;

    -- EJERCICIO 6        (12)
    FUNCTION vincular (
        p_id_autor VARCHAR,
        p_id_obra VARCHAR)
    RETURN INTEGER;

    -- EJERCICIO 7         (13)
    FUNCTION desvincular(
        p_id_autor VARCHAR,
        p_id_obra VARCHAR)
    RETURN INTEGER;

    -- EJERCICIO 8         (14)
    FUNCTION alta_edicion(
        p_id_obra VARCHAR,
        p_isbn VARCHAR,
        p_anyo INTEGER DEFAULT NULL) 
    RETURN VARCHAR;

    -- EJERCICIO 9         (15)
    FUNCTION borrado_edicion (
        p_id VARCHAR)
    RETURN INTEGER;

    -- EJERCICIO 10         (16, 17, 18)
    FUNCTION alta_ejemplar(
        p_id_edicion VARCHAR) 
    RETURN INTEGER;

    -- EJERCICIO 11         (19, 20, 21, 22)
    FUNCTION borrado_ejemplar (
        p_id_edicion VARCHAR,
        p_numero INTEGER)
    RETURN INTEGER;

    -- EJERCICIO 12         (19, 23, 24, 25, 26)
    FUNCTION baja_ejemplar(
        p_id_edicion VARCHAR,
        p_numero INTEGER)
    RETURN INTEGER;
END;
/