/*
 * Ejercicio 1
*/
/*Hallar todos los datos de los comerciales menores de 20 años a fecha de hoy */
SELECT * FROM comercial WHERE DATEDIFF(NOW(),fecha_nac)/365 > 20;

/* Hallar todos los datos de los comerciales menores de 25 años y cuyo codigo postal no coincidan con ninguno de los clientes existentes en la base de datos. */
SELECT * 
FROM comercial 
WHERE cod_postal not in (SELECT distinct(cod_postal) from cliente)
AND DATEDIFF(NOW(),fecha_nac)/365 < 25;

/* Hallar el nº de comerciales que viven en distritos (codigo postal) donde no hay clientes. */
SELECT cod_postal, count(*)
FROM comercial
WHERE cod_postal not in (SELECT distinct(cod_postal) from cliente)
GROUP BY cod_postal;

/*Hallar la media del precio unitario de los artículos que se hayan vendido en
2014 o 2015 (e.dque aparezcan en albaranes de 2014 o 2015) (solo con dos
decimales) (cuidado no repetir articulo en el cálculo de dicha media)
 */
SELECT truncate(AVG(precio),2) as media
FROM articulo, albaran
WHERE articulo.cod_art = albaran.cod_art
AND YEAR(fecha_alb) between'2014' AND '2015';

/*Hallar el código y descripción de aquellos artículos que están por debajo del
precio medio de todos los artículos.
 */
 SELECT cod_art, descripcion
 FROM articulo
 WHERE precio < (SELECT AVG(precio) from articulo);

/*Hallar (para cada factura de 2012) el nº de albaranes que la componen.
Incluye el cod_fact y el nº de albaranes en el resultado de la consulta */
SELECT distinct(factura.cod_fac), count(*)
FROM albaran, factura
WHERE factura.cod_fac = albaran.cod_fac
AND YEAR(fecha_fac) = '2012'
GROUP BY factura.cod_fac;

/*Hallar el máximo nº de unidades vendidas en una venta (albaran) de cada
articulo pero solo de aquellos artículos cuyo máximo en una venta sea de 10 o
mas unidades. Incluye en la salida el cod_art y dicho máximo de unidades
vendidas  */
SELECT cod_alb, MAX(cantidad) as 'MAX*Articulo'
FROM albaran
GROUP BY cod_alb
HAVING MAX(cantidad) >= 10;
/*  Hallar el valor de la facturación total en cada distrito (codigo_postal de
cliente). Incluye en la salida el código postal y la facturación total para ese distrito
pero solo teniendo en cuenta las facturas del año 2014 y 2015. */
SELECT YEAR(fecha_fac), cod_postal, SUM(importe)
FROM factura, cliente
WHERE cliente.dni = factura.dni
AND YEAR(fecha_fac) between '2014' AND '2015'
GROUP BY YEAR(fecha_fac), cod_postal;

/*  Hallar el cod_art y el precio de aquellos articulos que se correspondan con
los dos menores precios de articulo (no utilizar limit).
 */
SELECT cod_art, precio 
FROM articulo AS a1
WHERE (
SELECT COUNT(*)
FROM articulo AS a2
WHERE a1.precio > a2.precio
) < 2
order by precio desc;

/* Hallar si existe algún artículo (y si existe, indicar su código y descripción)
que se haya vendido a todos los clientes de los distritos '30007' y '30009'. (Puedes utlizar tablas temporales/vistas intermedias -0,5pts)
 */

/* EMPTY SET */
SELECT DISTINCT(cod_art), descripcion
FROM articulo
WHERE cod_art in (
				SELECT DISTINCT x.cod_art
				FROM (SELECT albaran.cod_art, factura.cod_fac, cliente.dni, cod_postal
						FROM albaran, factura, cliente
						WHERE albaran.cod_fac = factura.cod_fac
						AND factura.dni = cliente.dni) AS x
				WHERE NOT EXISTS (
								SELECT *
								FROM cliente AS y
								WHERE NOT EXISTS (
											SELECT *
											FROM (SELECT albaran.cod_art, factura.cod_fac, cliente.dni, cod_postal
													FROM albaran, factura, cliente
													WHERE albaran.cod_fac = factura.cod_fac
													AND factura.dni = cliente.dni) AS z
											WHERE (z.cod_art=x.cod_art) AND (z.cod_postal=y.cod_postal) AND(cod_postal='3007' OR cod_postal='3009') 
													)
								)
				);

/*
 * Ejercicio 2: Vistas
 */
/* Crear una vista llamada v_cli_fact que muestre el dni, nombre y apellidos de los clientes,
así como el importe total con un descuento del 20% de las facturas de 2013 */

BEGIN;
DROP VIEW if exists v_cli_fact;
CREATE VIEW v_cli_fact as SELECT cliente.dni, nombre, apellidos, SUM(importe)-importe*0.2 as 'precio + descuento'
FROM cliente, factura
WHERE cliente.dni = factura.dni
AND YEAR(fecha_fac) = '2013'
GROUP BY cliente.dni, nombre, apellidos;
SELECT * FROM v_cli_fact;
COMMIT;

/* Crear una vista llamada v_distrito_fact que muestre el código postal junto con la
facturación total asociada a los clientes de ese distrito pero solo se aquellos distritos que
superen una facturación de 5000 euros */
BEGIN;
DROP VIEW if exists v_distrito_fact;
CREATE VIEW v_distrito_fact as SELECT cliente.dni, nombre, apellidos, SUM(importe)-importe*0.2 as 'precio + descuento'
FROM cliente, factura
WHERE cliente.dni = factura.dni
AND YEAR(fecha_fac) = '2013'
GROUP BY cliente.dni, nombre, apellidos;
SELECT * FROM v_distrito_fact;
COMMIT;

/* Crear dos usuarios usuario_cli y usuario_distrito con permisos solo de lectura sobre las
vistas anteriores respectivamente.*/
begin;
CREATE USER 'usuario_cli'@'localhost' identified by 'passwd';
GRANT SELECT ON v_cli_fact.comercial to 'usuario_cli'@'localhost'; 
GRANT SELECT ON v_distrito_fact.comercial to 'usuario_cli'@'localhost'; 
SELECT user from mysql.user;
commit;

begin;
CREATE USER 'usuario_distrito'@'localhost' identified by 'passwd';
GRANT SELECT ON v_cli_fact.comercial to 'usuario_distrito'@'localhost';
GRANT SELECT ON v_distrito_fact.comercial to 'usuario_distrito'@'localhost';
commit;

/* Indica como definirías (y en qué nivel de aislamiento óptimo lo harías -concurrencia vs
serialización-), un conjunto de sentencias como transacción para realizar una venta de
artículo (realizar el albaran correspondiente y actualizar stock).
Pon un ejemplo con instrucciones reales y al menos dos transacciones concurrentes
probadas en el SGBD e indica lo siguiente:
*/
SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;
SELECT * from articulo WHERE cod_art='ART-10';
UPDATE ARTICULO
set stock=stock-1
WHERE cod_art='ART-10';

insert into albaran values ('A-0000',null,'2015-03-01','ART-10',15);

SELECT * from articulo WHERE cod_art='ART-10';
SELECT * from albaran WHERE cod_alb='A-0000';
COMMIT;

/* EXPLICACIÓN */

Este nivel de aislamiento, implementa un control de concurrencia, mediante bloqueos de escritura,
ese bloqueo dura x tiempo este tipo de transacciones puede generar lectura no repetible, es decir, ocurre cuando en el curso de una transacción una fila se lee dos veces y los
valores no coinciden.

/* Se desea mejorar la velocidad en búsquedas y optimizar la BD y se propone: */
alter table articulo
add (index (descripcion);
/* NO FUNCIONA EL ALTER TABLE ADD COUMM, PERO SI EL ADD */

/* EXPLICACIÓN */
 Deberemos de utilizar un indice no unico porque nunca podras identificar un articulo por su descripción puesto que diferentes articulos
puede tener la misma descripción. Ej.: ' tarjeta fast ethernet 100GG' 'Tarjeta de red' | 'Tarjeta ethernet' 'Tarjeta de red'

/* Se desea cambiar desde 0 la definición de la tabla factura para utilizar una clave
sintética. Indica el código de creación de tabla para la tabla factura así definida y
cualquier otras acciones que se habrían de realizar (en caso de ser necesarias). */ 

create table factura(
	id_factura int not null auto_increment;
	cod_fac varchar(11) not null comment 'clave alternativa de tabla facturas',
	dni varchar(11) not null comment 'Campo de clave alternativa',
	fecha_fac date not null comment 'Campo de la con la fecha de la factura',
	importe integer not null,
	unique(cod_fac),
	unique(dni),
	primary key(id_factura),
	foreign key(dni) references cliente(dni) on update cascade 
);

Sinceramente si el cod_fac es unico y una clave alternativa se podría segir empleando la BD como hasta ahora, pero supongo que por semántica lo correcto sería
modificar las referencias de las FK de las otras tablas al id_factura.
