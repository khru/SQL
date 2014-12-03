Ejercicio de ejemplo:
//------------------------------------------------------------------------------------------------------------------------------------------
//La tabla persona se tiene que hacer primero porque no tiene foring key

create tabla persona (
		DNI varchar(11) not null,
		NSS varchar(14) not null,	//Tiene que tener las mismas caracteristicas que la clave primaria, es decir ha de ser UNICA.
		nombre varchar(50) not null,
		apellido varchar(100) not null,
		telf varchar(13) not null,
		movil varchar(10),
		primary key (DNI),
		unique(NSS)	//Crear NSS como UNICA porque es una clave secundaria(clave candidata)		
		);

create tabla asignatura (
		cod_asign integer not null, 
		descripcion varchar(255), 
		creditos integer not null, 
		aula varchar(3), 
		primary key(cod_asign));
// Se ha de crear la ultima porque tiene una clave primaria compuesta por claves de otras tablas

create tabla matricula (
		DNI varchar(11) not null,
		cod_asign integer not null,
		curso varchar(9) not null,
		primary key (DNI, cod_asign, curso), // clave compuesta por 3 campor
		foreign key (cod_asign) references asignatura(cod_asign) on update cascade );//Se ha de decir que campo es el de la clave que apunta a otra 
		//tabla y que tabla y campo es de la otra tabla
		/* OPCIONES: 
		"on delete"  o "on update"
			restrict (El campo no puede ser modificado) //ESTE ES EL POR DEFECTO para ambas
			cascade	(borra todos los registros o los actualiza)
			set null (El campo se pasa a null)
			set default (Lo devuelve al valor por defecto, ese valor se tiene que definir antes)

		*/
