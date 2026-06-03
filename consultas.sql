USE ubicacion;

--1)Consultar todos los registros y todos los campos de la tabla pais.
SELECT * FROM pais;

--2)Consultar los diez primeros registros y obtener todos los campos de la tabla provincia.
--Limitar la cantidad de registros de salida a 10.
SELECT * FROM provincia LIMIT 10;

--3)Obtener las provincias que tienen un identificador de país específico.
--Para el caso listar las provincias con el id del pais 2.
SELECT * FROM provincia WHERE idpais=2;

--4)Obtener todas las provincias cuyo contenido del campo nombre contenga a la cadena 'jua'
SELECT * FROM provincia WHERE nombre LIKE '%jua%';

--5)Obtener todos los campos de las provincias cuyo id se encuentre dentro de una lista específica.
--Para el caso la lista contiene 5,6,7,8
SELECT *  FROM provincia WHERE id IN (5,6,7,8);
SELECT * FROM provincia WHERE id BETWEEN 5 AND 8;

--6)Obtener los nombres de las provincias cuyo id se encuentre dentro de una lista específica.
--Para el caso la lista contiene 1,2,3,4
SELECT nombre FROM provincia WHERE id IN (1,2,3,4);
SELECT nombre FROM provincia WHERE id BETWEEN 1 AND 4;

--7)Obtener todas las provincias correspondientes al país “Argentina”
SELECT * FROM pais INNER JOIN provincia ON pais.id=provincia.idpais WHERE pais.id=1;

--8)Obtener todos las provincias correspondientes al país “Argentina”.
--Modificar los títulos de las columnas de salida y mostrar sólo dos campos:
--El nombre del Pais indicarlo como “Pais” y el nombre de la provincia indicarlo como “Provincia”.
SELECT pais.nombre AS Pais, provincia.nombre AS Provincia
FROM pais
INNER JOIN provincia ON pais.id=provincia.idpais
WHERE pais.id=1;

--9) Obtener todos los departamentos de la provincia de Buenos Aires. Listar los campos Pais, 
--   Provincia, Departamento. Limitar la salida a sólo 20 registros.

SELECT pais.nombre AS PAIS, provincia.nombre AS PROVINCIA, departamento.nombre AS DEPARTAMENTO
FROM pais
INNER JOIN provincia ON pais.id=provincia.idpais
INNER JOIN departamento ON provincia.id=departamento.idprovincia
WHERE pais.nombre='Argentina' AND provincia.nombre='Buenos Aires'
LIMIT 20;

--10) Idem al anterior, pero se agrega la columna superficie para cada departamento.
SELECT pais.nombre AS PAIS, provincia.nombre AS PROVINCIA, departamento.nombre AS DEPARTAMENTO,
superficie.valor AS SUPERFICIE
FROM pais
INNER JOIN provincia ON pais.id=provincia.idpais
INNER JOIN departamento ON provincia.id=departamento.idprovincia
INNER JOIN superficie ON departamento.id=superficie.idDepartamento
WHERE pais.nombre='Argentina' AND provincia.nombre='Buenos Aires'
LIMIT 20;

--11)Obtener la población de la provincia de Buenos Aires al 2001 y al 2010. 
--Listar los campos Pais, Provincia, Población y Año. Se sabe que el id de Buenos Aires es 2.
SELECT pais.nombre AS PAIS, provincia.nombre AS PROVINCIA, SUM(poblacion.valor) AS POBLACION, anio.numero AS AÑO
FROM pais
INNER JOIN provincia ON pais.id=provincia.idpais
INNER JOIN departamento ON provincia.id=departamento.idprovincia
INNER JOIN poblacion ON departamento.id=poblacion.idDepartamento
INNER JOIN anio ON poblacion.idAnio=anio.id
WHERE provincia.id=2 AND (anio.numero=2001 OR anio.numero=2010)
GROUP BY pais.nombre, provincia.nombre, anio.numero;

--12)Obtener la cantidad de departamentos de la provincia de Buenos Aires (para cada año) 
--   que tienen registrada la Población. Listar País, Provincia, Cantidad Dpto y Año.
SELECT pais.nombre AS PAIS, provincia.nombre AS PROVINCIA, COUNT(departamento.id) AS 'CANTIDAD Dpto', anio.numero AS AÑO
FROM pais
INNER JOIN provincia ON pais.id=provincia.idpais
INNER JOIN departamento ON provincia.id=departamento.idprovincia
INNER JOIN poblacion ON departamento.id=poblacion.idDepartamento
INNER JOIN anio ON poblacion.idAnio=anio.id
WHERE provincia.id=2 AND (anio.numero=2001 OR anio.numero=2010)
GROUP BY pais.nombre, provincia.nombre, anio.numero;

--13)Obtener un listado de los departamentos para la provincia de Buenos Aires en el año 2010
--   y cuya población sea superior a 450000. Listar País, Provincia, Departamento, Año, Población 
--   y Superficie. Ordenar el listado en forma descendente por cantidad de población. Recortar a 
--   tres caracteres­ el contenido de los campos Pais y Provincia.
SELECT LEFT(pais.nombre,3) AS PAIS, LEFT(provincia.nombre,3) AS PROVINCIA, departamento.nombre AS DEPARTAMENTO, anio.numero AS AÑO, poblacion.valor AS POBLACION
FROM pais
INNER JOIN provincia ON pais.id=provincia.idpais
INNER JOIN departamento ON provincia.id=departamento.idprovincia
INNER JOIN poblacion ON departamento.id=poblacion.idDepartamento
INNER JOIN anio ON poblacion.idAnio=anio.id
INNER JOIN superficie ON departamento.id=superficie.idDepartamento
WHERE provincia.nombre='Buenos Aires' AND anio.numero=2010 AND poblacion.valor>450000
ORDER BY poblacion DESC;

--14)Obtener un listado de los departamentos de la provincia de Buenos Aires para el año
--   2001 y 2010,  agrupado por id de departamento cuyo promedio de población sea superior 
--   a 450000. Listar País, Provincia, Departamento, Población y Superficie. Ordenar el listado
--   en forma descendente por cantidad de población. Recortar a tres caracteres el contenido de 
--   los campos País y Provincia.
SELECT LEFT(pais.nombre,3) AS PAIS, LEFT(provincia.nombre,3) AS PROVINCIA, departamento.nombre AS DEPARTAMENTO, AVG(poblacion.valor) AS POBLACION, superficie.valor AS SUPERFICIE
FROM pais
INNER JOIN provincia ON pais.id=provincia.idpais
INNER JOIN departamento ON provincia.id=departamento.idprovincia
INNER JOIN superficie ON departamento.id=superficie.idDepartamento
INNER JOIN poblacion ON superficie.idDepartamento=poblacion.idDepartamento
INNER JOIN anio ON anio.id=poblacion.idAnio
WHERE pais.nombre='Argentina' AND provincia.nombre='Buenos Aires' AND (anio.numero=2001 OR anio.numero=2010)
GROUP BY PAIS, PROVINCIA, DEPARTAMENTO, SUPERFICIE
HAVING AVG(poblacion.valor)>450000
ORDER BY poblacion.valor DESC;

--15)Obtener un listado de los departamentos de para la provincia de Buenos Aires para el 
--   año 2010,  agrupado por id de departamento , y cuyo promedio de población sea superior
--   a 450000. Listar País, Provincia, Departamento, Población, Superficie y Densidad de 
--   Población . Ordenar el listado en forma descendente por Densidad de Población. Recortar 
--   a tres caracteres el contenido de los campos País y Provincia.
--  Nota: Densidad de población= Población / Superficie
SELECT LEFT(pais.nombre,3) AS PAIS, LEFT(provincia.nombre,3) AS PROVINCIA, 
departamento.nombre AS DEPARTAMENTO, AVG(poblacion.valor) AS POBLACION, ROUND(superficie.valor,2) AS SUPERFICIE,
ROUND((poblacion.valor/superficie.valor),2) AS DENSIDAD
FROM pais
INNER JOIN provincia ON pais.id=provincia.idpais
INNER JOIN departamento ON provincia.id=departamento.idprovincia
INNER JOIN superficie ON departamento.id=superficie.idDepartamento
INNER JOIN poblacion ON superficie.idDepartamento=poblacion.idDepartamento
INNER JOIN anio ON anio.id=poblacion.idAnio
WHERE provincia.nombre='Buenos Aires' AND anio.numero=2010
GROUP BY PAIS, PROVINCIA, DEPARTAMENTO, SUPERFICIE
HAVING AVG(poblacion.valor)>450000
ORDER BY DENSIDAD DESC;