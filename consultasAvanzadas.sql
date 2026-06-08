-- Active: 1780339369165@@127.0.0.1@3306@ubicacion
--Parte 1: Consultas descriptivas
--1.Listar todas las provincias de Argentina ordenadas 
--  alfabéticamente.
SELECT provincia.nombre AS Provincia
FROM provincia
WHERE idpais=1
ORDER BY provincia.nombre ASC;

--2.Mostrar los departamentos de la provincia de 
--  Buenos Aires.
SELECT departamento.nombre AS Departamento
FROM departamento
WHERE departamento.idprovincia=2;


--3.Consultar la población total de cada departamento 
--  bonaerense para el año 2010. Ordenar de mayor a menor.
SELECT provincia.nombre AS PROVINCIA, 
       departamento.nombre AS DEPARTAMENTO,
       SUM(poblacion.valor) AS 'TOTAL 2010'
FROM departamento
INNER JOIN provincia ON provincia.id=departamento.idprovincia
INNER JOIN poblacion ON poblacion.idDepartamento=departamento.id
INNER JOIN anio ON poblacion.idAnio=anio.id
WHERE provincia.nombre='Buenos Aires' AND anio.numero=2010
GROUP BY PROVINCIA, DEPARTAMENTO
ORDER BY SUM(poblacion.valor) DESC;


--4.Calcular el promedio de población departamental en Buenos Aires
--  para cada departamento.
SELECT
       departamento.nombre AS DEPARTAMENTO,
       AVG(poblacion.valor) AS 'PROMEDIO 2001-2010'
FROM departamento
INNER JOIN provincia ON provincia.id=departamento.idprovincia
INNER JOIN poblacion ON poblacion.idDepartamento=departamento.id
INNER JOIN anio ON poblacion.idAnio=anio.id
WHERE provincia.nombre='Buenos Aires'
GROUP BY departamento.id;

--PARTE 2: Agregaciones y comparaciones 
--5)Calcular la poblacion total de la provincia de Buenos Aires en 2001 y 2010.
SELECT
provincia.nombre AS PROVINCIA, SUM(poblacion.valor) AS 'TOTAL POBLACION', anio.numero AS AÑO
FROM provincia
INNER JOIN departamento ON provincia.id=departamento.idprovincia
INNER JOIN poblacion ON departamento.id=poblacion.idDepartamento
INNER JOIN anio ON poblacion.idAnio=anio.id
WHERE provincia.nombre='Buenos Aires'
GROUP BY provincia.nombre, anio.numero;

--6)Obtener las 5 LOCALIDADES más poblada de Argentina
--  en 2010.
SELECT pais.nombre AS PAIS, departamento.nombre AS LOCALIDADES,
poblacion.valor AS 'TOTAL POBLACION', anio.numero AS AÑO
FROM pais
INNER JOIN provincia ON pais.id=provincia.idpais
INNER JOIN departamento on provincia.id=departamento.idprovincia
INNER JOIN poblacion ON departamento.id=poblacion.idDepartamento
INNER JOIN anio ON poblacion.idAnio=anio.id
WHERE anio.numero=2010 AND pais.nombre='Argentina'
GROUP BY pais.nombre, departamento.nombre, anio.numero
ORDER BY poblacion.valor DESC
LIMIT 5;

--7)Calcular la variación porcentual de población por 
--  departamento bonaerense entre 2001 y 2010.
SELECT d.nombre AS LOCALIDAD,
p2001.valor AS 'POBLACION 2001',
p2010.valor AS 'POBLACION 2010',
ROUND(((p2010.valor-p2001.valor)/p2001.valor)*100, 2) AS 'VARIACION %'
FROM departamento d
INNER JOIN provincia pr ON d.idprovincia=pr.id
INNER JOIN pais pa ON pr.idpais=pa.id
INNER JOIN poblacion p2001 ON p2001.idDepartamento=d.id
inner JOIN anio a2001 ON a2001.id=p2001.idAnio
INNER JOIN poblacion p2010 ON p2010.idDepartamento=d.id
INNER JOIN anio a2010 ON a2010.id=p2010.idAnio
WHERE pa.nombre='Argentina' AND pr.nombre='Buenos Aires'
AND a2001.numero=2001 AND a2010.numero=2010
ORDER BY `VARIACION %` DESC;

--8)Calcular la densidad poblacional (hab/km²)de cada 
--  departamento bonaerense en 2010.
SELECT
d.nombre AS DEPARTAMENTO,
ROUND((p2010.valor/s.valor),2) AS "DENSIDAD POBLACION"
FROM pais pa
INNER JOIN provincia pr ON pa.id=pr.idpais
INNER JOIN departamento d ON pr.id=d.idprovincia
INNER JOIN superficie s ON d.id=s.idDepartamento
INNER JOIN poblacion p2010 ON p2010.idDepartamento=d.id
INNER JOIN anio a2010 ON p2010.idAnio=a2010.id
WHERE pa.id=(SELECT id FROM pais WHERE nombre="Argentina") 
AND pr.id=(SELECT id FROM provincia WHERE nombre="Buenos Aires")
AND a2010.id=(SELECT id FROM anio WHERE numero=2010)
ORDER BY `DENSIDAD POBLACION` DESC;

