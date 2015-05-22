/* 
** Creación de DB
*/
/* Si existe eliminamos la base de datos*/
drop database if exists comercial;
/*Creamos la base de datos*/
create database comercial character set utf8 collate utf8_general_ci;

/*Selecionamos la base de datos a utilizar*/
use comercial;

/* Creación de la tabla cliente */
create table cliente (
	dni varchar(11) not null comment 'PK de la tabla cliente',
	nombre varchar(50) not null,
	apellidos varchar(50) not null,
	fecha_nac date comment 'Campo con la fecha de nacimiento (este campo admite null)',
	direccion varchar(50) not null,
	cod_postal varchar(7) comment 'Campo con la Código postal (este campo admite null)',
	primary key(dni)
);
/* Inserta datos CLIENTE*/
insert into cliente values ('11111111A','Jose','Perez Perez','1974-08-01','/Lepanto nº25 5º B','30001');
insert into cliente values ('22222222B','Maria','Sanchez Sanchez','1985-03-25','Cervantes nº1 2ºA','30001');
insert into cliente values ('33333333C','Pedro','Martinez Lopez','1995-06-10','/Medina nº 15 1º C','30009');
insert into cliente values ('44444444D','Juan','Flores Puerta','1991-04-12','/Velazquez nº 20 4ºD','30008');

/* Creación de la tabla factura */
create table factura(
	cod_fac varchar(11) not null comment 'PK de tabla facturas',
	dni varchar(11) not null comment 'Campo de clave alternativa',
	fecha_fac date not null comment 'Campo de la con la fecha de la factura',
	importe integer not null,
	primary key(cod_fac),
	foreign key(dni) references cliente(dni) on update cascade 
);
/* Inserción de datos FACTURA*/
insert into factura values ('F-0001','11111111A','2012-02-01',2800);
insert into factura values ('F-0002','11111111A','2012-03-02',1500);
insert into factura values ('F-0003','11111111A','2012-08-15',800);
insert into factura values ('F-0004','22222222B','2013-09-10',3000);
insert into factura values ('F-0005','22222222B','2013-10-02',900);
insert into factura values ('F-0006','33333333C','2013-11-15',2500);
insert into factura values ('F-0007','44444444D','2014-02-02',520);
insert into factura values ('F-0008','44444444D','2015-02-04',2500);



/* Creación de la tabla articulo */
CREATE TABLE articulo(
	cod_art varchar(7) not null comment 'Código de articulo',
	descripcion varchar(255) not null comment 'Descripcion del articulo',
	precio numeric(6,2) not null  comment 'Precio sin iva [6 enteros de los cuales2 decimales]',
	stock integer default 100 comment 'Stock por defecto 100',
	check (stock > 5),
	PRIMARY KEY(cod_art)
);
/* Inserción de datos ARTICULO */
insert into articulo values ('ART-10','Elevador potencia',60,50);
insert into articulo values ('ART-80','Condesador RJW',20,200);
insert into articulo values ('ART-77','Placa Base ASUS 1155',50,35);
insert into articulo values ('ART-100','SAI 1500VA-Salicru',500,8);
insert into articulo values ('ART-101','Condesador RJW',20,200);
insert into articulo values ('ART-120','Ventilador led enermax',10,55);
insert into articulo values ('ART-250','Condesador RJW',250,40);

/*Creación de la tabla albaran*/
create table albaran(
	cod_alb varchar(10) not null,
	cod_fac varchar(11) comment 'No tiene porque haber una factura cuando se crea un albaran', /* No tiene porque haber una factura */
	fecha_alb date not null comment 'fecha del albaran',
	cod_art varchar(10) not null,
	cantidad integer not null,
	primary key(cod_alb),
	foreign key(cod_fac) references factura(cod_fac) on update cascade,
	foreign key(cod_art) references articulo(cod_art) on update cascade
);
/* Inserción de datos ALBARAN */
insert into albaran values ('A-0001','F-0001','2012-01-10','ART-250',10);
insert into albaran values ('A-0002','F-0001','2012-01-20','ART-120',30);
insert into albaran values ('A-0003','F-0002','2012-02-15','ART-100',3);
insert into albaran values ('A-0004','F-0003','2012-04-03','ART-80',25);
insert into albaran values ('A-0005','F-0003','2012-06-15','ART-120',10);
insert into albaran values ('A-0006','F-0003','2012-07-25','ART-77',4);
insert into albaran values ('A-0007','F-0004','2013-09-20','ART-10',50);
insert into albaran values ('A-0008','F-0005','2013-10-02','ART-10',15);
insert into albaran values ('A-0009','F-0006','2013-11-15','ART-100',5);
insert into albaran values ('A-0010','F-0007','2014-02-01','ART-101',1);
insert into albaran values ('A-0011','F-0007','2014-02-02','ART-100',1);
insert into albaran values ('A-0012','F-0008','2015-02-04','ART-100',5);
/* ALBARAN SIN CODIGO DE FACTURA */
/* delete from albaran where cod_alb = 'A-9999'; */
insert into albaran values ('A-9999',null ,'2015-02-04','ART-100',0);
/* ALBARAN PARA OPERADOR DIVISOR */
/* delete from albaran where cod_alb = 'A-8888'; */
/* delete from albaran where cod_alb = 'A-8777'; */
/* delete from albaran where cod_alb = 'A-8666'; */
/* delete from albaran where cod_alb = 'A-8555'; */
insert into albaran(cod_alb,cod_fac,fecha_alb,cod_art,cantidad) values ('A-8888','F-0003','2012-07-25','ART-80',4);
insert into albaran(cod_alb,cod_fac,fecha_alb,cod_art,cantidad) values ('A-8777','F-0004','2012-07-25','ART-80',4);
insert into albaran(cod_alb,cod_fac,fecha_alb,cod_art,cantidad) values ('A-8666','F-0007','2012-07-25','ART-80',4);
insert into albaran(cod_alb,cod_fac,fecha_alb,cod_art,cantidad) values ('A-8555','F-0006','2012-07-25','ART-80',4);

/* Creación de la tabla comercial */
create table comercial(
	dni varchar(11) not null comment 'PK de la tabla comercial',
	nombre varchar(50) not null comment 'Nombre del comercial',
	apellidos varchar(50) not null,
	fecha_nac date not null comment 'La fecha de nacimiento',
	direccion varchar(50) not null,
	cod_postal varchar(7) not null,
	primary key(dni)
);

/* Inserción de datos COMERCIAL*/
insert into comercial values ('55555555E','Berta','Fuertes Ruiz','1980-08-01','C/Medina no40 3o A',30008);
insert into comercial values ('66666666F','Luis','Perez Martinez','1983-02-23','C/Picasso no3 7oC',30001);
insert into comercial values ('77777777G','Ramon','Lucas Sanchez','1995-06-12','C/Nadal no 14 1o D',30009);
insert into comercial values ('88888888H','Juana','Luna Puertas','1991-05-15','C/Colon no 20 4oD',30007);

/* Creación de la tabla visita */
create table visita(
	dni_cli varchar(11) not null,
	dni_comercial varchar(11) not null,
	fecha_visita date not null,
	primary key(dni_cli,dni_comercial,fecha_visita),
	foreign key(dni_cli) references cliente(dni) on update cascade,
	foreign key(dni_comercial) references comercial(dni) on update cascade		
);
/* Inserción de datos  VISITAS*/
insert into visita values ('11111111A','66666666F','2012-04-01');
insert into visita values ('11111111A','66666666F','2012-06-01');
insert into visita values ('22222222B','66666666F','2013-05-10');
insert into visita values ('33333333C','55555555E','2014-07-12');
insert into visita values ('33333333C','66666666F','2014-04-01');
insert into visita values ('44444444D','77777777G','2012-02-07');
insert into visita values ('44444444D','66666666F','2013-04-01');
insert into visita values ('44444444D','55555555E','2014-04-15');

/* En esta vista no se puede insertar nada porque los campos calculados no se encuentran en la tabla base */
/* No deja añadirle datos */
CREATE VIEW v_articulo_error as
SELECT cod_art, descripcion, precio, precio * 0.21 as IVA, precio * 1.21 as PVP
FROM articulo;

/* Aqui si se puede insertar */
/*Como en esta vista se ven los campos que son oblicatorios porque son not null y el stock tiene un defaul de 100*/
/*Puedes insertar articulos dentro de esta vista*/
CREATE VIEW v_articulo_correcto as
SELECT cod_art, descripcion, precio
FROM articulo;

insert  into v_articulo_correcto(cod_art, descripcion, precio) values ('ART-999', 'Conector RJ45', 3.50);

begin;
CREATE USER 'khru'@'localhost' IDENTIFIED BY 'passwd';
GRANT SELECT,UPDATE, DELETE, INSERT ON comercial.v_articulo_correcto  TO 'khru'@'localhost';
commit;

/* 1-  Hallar todos los datos de los clientes mayores de 20 años a fecha de hoy */
SELECT * 
FROM cliente 
WHERE DATEDIFF(NOW(),fecha_nac)/365 > 20;
/* 2- Hallar todos los datos de los clientes mayores de 35 años que residan en un distrito de codigo postal 30001 */
SELECT * 
FROM cliente 
WHERE DATEDIFF(NOW(), fecha_nac)/365 > 35
AND cod_postal = '30001';
/* 3- Hallar el nº de clientes qye residan en cada uno de los distritos (que tengan mismo código postal) En la salida  */
SELECT cod_postal ,count(*)
FROM cliente
GROUP BY cod_postal;
/* 4- Hallar los diferentes códigos postales donde tenemos tanto clientes como comerciales.*/
SELECT distinct(cl.cod_postal)
FROM cliente as cl, comercial as co
WHERE cl.cod_postal = co.cod_postal;
/*-------------------------------------*/
SELECT cl.cod_postal
FROM cliente as cl, comercial as co
WHERE cl.cod_postal = co.cod_postal
GROUP BY cl.cod_postal;

/* 5- Hallar la media de los stocks de artículos. (solo con dos decimales) */
SELECT truncate(avg(stock), 2)
FROM articulo;

/* 6- Hallar la media del precio unitario de los artículos que se hayan vendido en 2014 (que aparezcan en albaranes de 2014) (solo con dos decimales)*/
SELECT ROUND(avg(precio),2)
FROM albaran as al , articulo as ar
WHERE fecha_alb between '2014-01-01'AND '2014-12-31'
AND  al.cod_art = ar.cod_art;
/**********************************************************/
SELECT truncate(avg(precio),2)
FROM albaran as al , articulo as ar
WHERE fecha_alb between '2014-01-01'AND '2014-12-31'
AND  al.cod_art = ar.cod_art;

/* 7- Hallar el código y descripción de aquellos artículos que están por encima del precio medio de todos los artículos */
SELECT cod_art, descripcion 
FROM articulo
WHERE precio > (SELECT avg(precio) FROM articulo);

/* 8- Hallar el valor total actual del almacen. (lo que valen todos los artículos que tenemos en stock almacenados). */
SELECT SUM(precio * stock) as 'Precio Total'
FROM articulo;

/* 9 - Hallar el valor de la facturación total en 2012 */
SELECT SUM(IMPORTE) as 'facturación total 2012'
FROM factura
WHERE YEAR(fecha_fac) = '2012';

/* 10- Hallar el valor de la facturación total en cada distrito (codigo_postal de cliente). Incluye en la salida el código postal y la facturación total para ese distrito.*/
SELECT cod_postal, SUM(importe) as 'facturación total por zona'
FROM factura, cliente
WHERE cliente.dni = factura.dni
GROUP BY cod_postal;

/* 11- Hallar (en una solo consulta) el valor de la facturación total por cada año. Incluye el valor total y el año en el resultado de la consulta. */
SELECT YEAR(fecha_fac) as año, SUM(importe) as 'facturación total'
FROM factura
GROUP BY YEAR(fecha_fac);

/* 12- Hallar (para cada factura) el nº de albaranes que la componen. Incluye el cod_fact y el nº de albaranes en el resultado de la consulta. */
SELECT factura.cod_fac, count(cod_alb)
FROM albaran, factura
WHERE factura.cod_fac = albaran.cod_fac
GROUP BY factura.cod_fac;

/* POR SI HAY FACTURAS SIN ALBARAN */
SELECT factura.cod_fac, count(*)
FROM factura LEFT OUTER JOIN albaran on factura.cod_fac = albaran.cod_fac
GROUP BY factura.cod_fac;


/* 13- Hallar todos los datos de la factura de mayor importe.*/
SELECT *
FROM factura
WHERE importe = (SELECT max(importe) FROM factura);
/* 14- Hallar los cod_fact e importe de las facturas correspondientes a los tres mayores importes. */
SELECT cod_fac, importe
FROM factura as f1
WHERE (
SELECT COUNT(*)
FROM factura AS f2
WHERE f1.importe < f2.importe
) < 3
ORDER BY f1.importe DESC;
/*  15- Hallar todos los datos de tres facturas de mayor importe. */
SELECT *
FROM factura
ORDER BY importe DESC
LIMIT 3;

/* 16- Hallar todos los datos de los artículos cuyo media de ventas para ese articulo
(media del nº de unidades vendidas en cada albaran para ese artículo) suponga
40% o más del stock actual para ese artículo. */

SELECT *
FROM articulo
WHERE stock*0.4 <= (SELECT AVG(cantidad) From albaran WHERE albaran.cod_art = articulo.cod_art);


/* 17- Hallar todos los datos de los albaranes correspondientes a los tres mayores 
importes de albaranes (Ayuda: hay que calcular el importe de cada albaran ya que
no esta en la tabla) (puedes utilizar una tabla temporal(TEMPORARY) para
resultados intermedios)*/

/*  CON TABLAS TEMPORALES */
CREATE TEMPORARY table t_albaran  as SELECT cod_alb, cantidad * precio as 'total' FROM articulo, albaran WHERE articulo.cod_art = albaran.cod_art;
CREATE TEMPORARY table t_ayuda  as SELECT cod_alb, cantidad * precio as 'total' FROM articulo, albaran WHERE articulo.cod_art = albaran.cod_art;

SELECT * FROM t_albaran AS t1
WHERE (
SELECT COUNT(*)
FROM t_ayuda AS t2
WHERE t1.total < t2.total
) < 3
order by t1.total desc;

drop table t_albaran;
drop table t_ayuda;

/* CON VISTAS*/
begin;
CREATE VIEW  v_albaran  as SELECT cod_alb, cantidad * precio as 'total' FROM articulo, albaran WHERE articulo.cod_art = albaran.cod_art;
/* AUNQUE HAYA 3 VALORES IGUALES en el total los albaranes son distintos*/
SELECT * FROM v_albaran AS t1
WHERE (
SELECT COUNT(*)
FROM v_albaran AS t2
WHERE t1.total < t2.total
) < 3
order by t1.total desc;
commit;

/* sin tablas temporales un punto en la ealuación final */

SELECT * 
FROM (SELECT cod_alb, cantidad * precio as 'total' FROM articulo, albaran WHERE articulo.cod_art = albaran.cod_art) AS t1
WHERE (
SELECT COUNT(*)
FROM (SELECT cod_alb, cantidad * precio as 'total' FROM articulo, albaran WHERE articulo.cod_art = albaran.cod_art) AS t2
WHERE t1.total < t2.total
) < 3
order by t1.total desc;

/* 18- Hallar, para cada cliente, el dni junto con su facturación total.*/
SELECT cliente.dni as 'DNI', SUM(importe) as 'facturación total'
FROM cliente, factura
WHERE cliente.dni = factura.dni
GROUP BY cliente.dni;

/* 19- Hallar para cada comercial, el importe total de la facturación originada por los
clientes que ha visitado alguna vez. Incluye dni de comercial y facturación de sus 
clientes. (Atención a no sumar repetidas veces importes de facturas. Puedes
utilizar una tabla temporal TEMPORARY para resultados intermedios) */
begin;
drop TEMPORARY table if exists importeClientes;
CREATE TEMPORARY table importeClientes as SELECT cliente.dni as 'DNI',SUM(importe) as 'facturacion'
FROM cliente, factura
WHERE cliente.dni = factura.dni
GROUP BY cliente.dni;

SELECT distinct (dni_comercial), facturacion
FROM visita, importeClientes
WHERE visita.dni_cli = importeClientes.dni;

drop TEMPORARY table if exists importeClientes;
commit;

/* SIN TABLAS TEMPORALES */
select distinct (dni_comercial), facturacion
from visita, (SELECT cliente.dni as 'DNI',SUM(importe) as 'facturacion'
				FROM cliente, factura
				WHERE cliente.dni = factura.dni
				GROUP BY cliente.dni) as importeClientes
WHERE visita.dni_cli = importeClientes.dni;

/* 20- Hallar la consulta para averiguar si existe algún artículo que se haya vendido a
todos los clientes. Si existe indicar código de artículo y descripción. */

/* Con 2 tablas temporales */
begin;
drop TEMPORARY table if exists table alb_fac_art
drop TEMPORARY table if exists table alb_fac_art2
create TEMPORARY table alb_fac_art as
SELECT ar.cod_art, descripcion, dni, factura.cod_fac, cod_alb
FROM articulo as ar, factura, albaran
WHERE ar.cod_art = albaran.cod_art
AND factura.cod_fac = albaran.cod_fac;

create TEMPORARY table alb_fac_art2 as
SELECT ar.cod_art, descripcion, dni, factura.cod_fac, cod_alb
FROM articulo as ar, factura, albaran
WHERE ar.cod_art = albaran.cod_art
AND factura.cod_fac = albaran.cod_fac;

select cod_art, descripcion 
from articulo
where cod_art in(select cod_art
				from alb_fac_art multi
				where not exists (
								select *
								from cliente cli
								where not exists (
												select *
												from alb_fac_art2 as multibis
												where multibis.cod_art = multi.cod_art and multibis.dni = cli.dni)));

drop temporary table if exists alb_fac_art;
drop temporary table if exists alb_fac_art2;
commit;
/* Con una vista */
begin;
create view  alb_fac_art as
SELECT ar.cod_art, descripcion, dni, factura.cod_fac, cod_alb
FROM articulo as ar, factura, albaran
WHERE ar.cod_art = albaran.cod_art
AND factura.cod_fac = albaran.cod_fac;

select cod_art, descripcion 
from alb_fac_art
where cod_art in(select cod_art
				from alb_fac_art multi
				where not exists (
								select *
								from cliente cli
								where not exists (
												select *
												from alb_fac_art as multibis
												where multibis.cod_art = multi.cod_art and multibis.dni = cli.dni)));

drop view alb_fac_art;
commit;

/* Sin tablas temporales y sin vistas */

select cod_art, descripcion 
from articulo
where cod_art in(select cod_art
				from (SELECT ar.cod_art, descripcion, dni, factura.cod_fac, cod_alb
					FROM articulo as ar, factura, albaran
					WHERE ar.cod_art = albaran.cod_art
					AND factura.cod_fac = albaran.cod_fac) as  multi
				where not exists (
								select *
								from cliente cli
								where not exists (
												select *
												from (SELECT ar.cod_art, descripcion, dni, factura.cod_fac, cod_alb
													FROM articulo as ar, factura, albaran
													WHERE ar.cod_art = albaran.cod_art
													AND factura.cod_fac = albaran.cod_fac) as multibis
												where multibis.cod_art = multi.cod_art and multibis.dni = cli.dni)));
/* De otra forma */
SELECT cod_art, descripcion
from articulo a1
where not exists 
	(select *
		from cliente c2
		where not exists
			(select *
			from albaran alb natural join factura natural join cliente 
			where alb.cod_art=a1.cod_art and cliente.dni=c2.dni));

/* 21- Hallar si existe algún artículo (y si existe, indicar su código y descripción) que se
haya vendido en todos los distritos (tomando como referencia de distrito el código
postal del cliente). (Sin TEMPORARY tabla 100% de la nota, con TEMPORARY
tabla 45% de la nota) */
/*  CON VISTAS */
begin;

create view v_alb_fac_art_cli as
SELECT ar.cod_art, descripcion, cliente.dni, factura.cod_fac, cod_alb, cod_postal
FROM articulo as ar, factura, albaran, cliente
WHERE ar.cod_art = albaran.cod_art
AND factura.cod_fac = albaran.cod_fac
AND cliente.dni = factura.dni;

select distinct(cod_art), descripcion
from v_alb_fac_art_cli
where cod_art in(select cod_art
				from v_alb_fac_art_cli multi
				where not exists (
								select *
								from cliente cli
								where not exists (
												select *
												from v_alb_fac_art_cli as multibis
												where multibis.cod_art = multi.cod_art and multibis.cod_postal = cli.cod_postal)));

drop view v_alb_fac_art_cli;
commit;
/* Sin vistas ni tablas temporales*/
select distinct(cod_art), descripcion
from articulo
where cod_art in(select cod_art
				from (SELECT ar.cod_art, descripcion, cliente.dni, factura.cod_fac, cod_alb, cod_postal
					FROM articulo as ar, factura, albaran, cliente
					WHERE ar.cod_art = albaran.cod_art
					AND factura.cod_fac = albaran.cod_fac
					AND cliente.dni = factura.dni) as multi
				where not exists (
								select *
								from cliente cli
								where not exists (
												select *
												from (SELECT ar.cod_art, descripcion, cliente.dni, factura.cod_fac, cod_alb, cod_postal
													FROM articulo as ar, factura, albaran, cliente
													WHERE ar.cod_art = albaran.cod_art
													AND factura.cod_fac = albaran.cod_fac
													AND cliente.dni = factura.dni) as multibis
												where multibis.cod_art = multi.cod_art and multibis.cod_postal = cli.cod_postal)));

/* De la otra forma */
SELECT cod_art, descripcion
from articulo a1
where not exists 
	(select *
		from cliente c2
		where not exists
			(select *
			from albaran alb natural join factura natural join cliente 
			where alb.cod_art=a1.cod_art and cliente.cod_postal=c2.cod_postal));
/* Creación de vistas */
/* Crear una vista llamada v_cli_fact que muestre el dni, nombre y apellidos de los clientes,
así como el importe total +21% de iva de su facturación hasta la fecha */
/*Ninguna de las dos vistas permitirá inserción de datos porque tiene campos calculados*/
begin;
drop view if exists v_cli_fact;
CREATE VIEW v_cli_fact as SELECT distinct(cliente.dni), nombre, apellidos, sum(importe * 1.21) as 'Importe + IVA' FROM cliente, factura WHERE cliente.dni = factura.dni GROUP BY cliente.dni, nombre, apellidos;
SELECT * FROM v_cli_fact;
commit;

begin;
drop view if exists v_distrito_fact;
CREATE VIEW v_distrito_fact as SELECT distinct(cod_postal), sum(importe * 1.21) as 'Importe + IVA' FROM cliente, factura WHERE cliente.dni = factura.dni GROUP BY cod_postal;
SELECT * FROM v_distrito_fact;
commit;

/* Vistas propias */
begin;
drop view if exists porc_art;
CREATE View porc_art as SELECT cod_art, precio, concat(truncate(precio / (SELECT MAX(precio) FROM articulo) * 100,0),' ','%') as 'porcenmax', concat(truncate(precio / (SELECT AVG(precio) FROM articulo) * 100,0), ' ','%') as 'porcenmedia' FROM articulo;
SELECT * from porc_art;
commit;

/* Carga datos de un fichero a una tabla */
load data infile "cliente.cvs"
into table cliente
fields terminated by ','
lines terminated by '\n';

/* Cargar datos desde un fichero en local*/
load data local infile "C:\Users\khru\Desktop\clientes.cvs"
into table cliente
fields terminated by ','
lines terminated by '\n';

/* ACTUALIZACIONES */
begin;
UPDATE cliente
WHERE dni = '11111111A'
SET apellidos = 'Pérez Pérez'
commit;

/* CONFIGURACIONES de MYSQL */
/*--------------------------*/
/* Saber que transaciones*/
SELECT @@GLOBAL.tx_isolation, @@tx_isolation;
/*Hacer que MySQL haga bien los group by*/
SET sql_mode='ONLY_FULL_GROUP_BY';
