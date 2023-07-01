-- Creamos la tabla empleados
CREATE TABLE IF NOT EXISTS public.empleados
(
    id_empleado numeric(2,0),
    id_departamento numeric(2,0),
    nombre character varying(50),
    puesto character varying(50),
    sueldo integer
);

-- Insertamos un registro
INSERT INTO empleados (id_empleado, id_departamento, nombre,
   puesto, sueldo)
VALUES (1,1,'Miguel Troyano','Consultor', 60000);

-- Mostramos los datos de la tabla
SELECT * from empleados;

-- Insertamos otro registro pero mostrando lo insertado al final
INSERT INTO empleados (id_empleado, id_departamento, nombre,
   puesto, sueldo)
VALUES (2,1,'Ismael Troyano','Consultor', 60000)
RETURNING *;

-- Insertamos varios registros a la vez
INSERT INTO empleados (id_empleado, id_departamento, nombre,
   puesto, sueldo)
VALUES (3,1,'Jose Troyano','Director', 80000),
       (4,1,'Pilar Troyano','Directora', 80000)
RETURNING *;
