create table empleado (
	dni varchar(11) not null,
	nss varchar(14) not null,
	nombre varchar(50) not null,
	telf varchar(10) not null,
	unique(nss),
	primary key(dni)
	);

create table cocinero(
	dni varchar(11) not null,
	nss varchar(14) not null,
	fech_entrada date not null,
	primary key(dni),
	foreign key (dni) references cocinero(dni)
	);

create table almacen (
	num_almacen integer not null,
	nombre integer varchar(50) not null,
	primary key(num_almacen)
	);

create table estanteria (
	num_almacen integer not null,
	id integer not null,
	tam integer not null,
	cantidad integer not null,
	cod_ingrediente integer not null,
	primary key(num_almacen),
	foreign key(cod_ingrediente) references ingredientes(cod_ingrediente),
	foreign key(num_almacen) references almacen(num_almacen)
	);
