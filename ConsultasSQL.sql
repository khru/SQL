/**
*Ejercicios 7.3 sobre base de datos de ejemplo employees.sql
*/

/*1.Hallar todos los apellidos de los empleados junto con el nombre del 
departamento dónde trabajan o han trabajado (Ayuda: 331603 registros)*/

select last_name, dept_name 
from employees, dept_emp, departments 
where employees.emp_no=dept_emp.emp_no and
	 dept_emp.dept_no=departments.dept_no
ORDER BY last_name;

/*
==> esta consulta quita los repetidos y los agrupa
SELECT last_name, dept_name
FROM employees,dept_emp, departments
WHERE employees.emp_no = dept_emp.emp_no
AND dept_emp.dept_no=departments.dept_no
GROUP BY dept_name, last_name;

14733 
*/

/*2.Hallar todos los apellidos de los empleados junto con el nombre del 
departamento dónde trabajan o han trabajado utilizar clausulas inner join
para la reunión interna(Ayuda: 331603 registros)*/

select last_name, dept_name 
from employees 
	 inner join dept_emp on employees.emp_no=dept_emp.emp_no 
	 inner join departments on dept_emp.dept_no=departments.dept_no;

/*3.Hallar todos los apellidos de los empleados junto con el nombre del 
departamento dónde trabajan o han trabajado en los departamentos 
"Development" o "Research", indica también la fecha de contratación 
en ese departamento. Utiliza reunión interna con inner join
(Ayuda: 106833 registros)*/

select last_name, dept_name 
from employees 
	 inner join dept_emp on employees.emp_no=dept_emp.emp_no 
	 inner join departments on dept_emp.dept_no=departments.dept_no 
where dept_name in ("Development", "Research");

=============================================================================

SELECT last_name, dept_name
FROM employees, dept_emp, departments
WHERE employees.emp_no = dept_emp.emp_no
AND dept_emp.dept_no = departments.dept_no
AND dept_name = 'Development' OR dept_name ='Research';


/*4.Hallar la masa salarial total, sin discriminar fecha, correspondiente a los hombres
*/

select sum(salary) 
from salaries, employees 
where salaries.emp_no=employees.emp_no 
	  and gender='M';

/*5.Hallar la masa salarial total, sin discriminar fecha, correspondiente a las mujeres
*/

select sum(salary) 
from salaries, employees 
where salaries.emp_no=employees.emp_no 
	  and gender='F';

/*6.Hallar el sueldo medio, sin discriminar fecha, correspondiente a los 
hombres
*/
select avg(salary) 
from salaries, employees 
where salaries.emp_no=employees.emp_no 
	  and gender='M';

/*7.Hallar el sueldo medio, sin discriminar fecha, correspondiente a las 
mujeres
*/
select avg(salary) 
from salaries, employees 
where salaries.emp_no=employees.emp_no 
	  and gender='F';

/*8.Hallar el sueldo medio, sin discriminar fecha, correspondiente a los hombres.
Utiliza cláusulas inner
*/
select avg(salary) 
from salaries inner join employees 
	on salaries.emp_no=employees.emp_no 
where gender='M';

/*9.Hallar la masa saliarial total de los sueldos que empezaron a pagarse en el 
año 2000. Solo los que empezaron a pagarse en el año 2000
*/

select sum(salary) 
from salaries 
where from_date >= '2000-01-01' and from_date <= '2000-12-31';

/*10. Hallar el nombre y apellido del empleado que mayor sueldo ha percibido 
en todos los tiempos 
* Ayuda: el apellido del resultado es Pesch
*/

select first_name, last_name 
from employees, salaries 
where employees.emp_no=salaries.emp_no 
	  and salary=(select max(salary) from salaries);

/*11. Hallar el nº de empleados distintos cuyo salario (a partir del 2000) 
está por encima de la media de los salarios (a partir del 2000)
Ayuda:resultado 122559*/

select count(distinct(emp_no)) 
from salaries 
where from_date >= '2000-01-01' 
	  and salary >= 
			(select avg(salary) 
		     from salaries 
		     where from_date >=  '2000-01-01');

/*12. Hallar el nombre y apellido del último jefe de departamento conocido del 
departamento 'Development'. Ayuda: resultado apellido DasSarma
*/

select first_name, last_name  
from employees, dept_manager, departments 
where employees.emp_no=dept_manager.emp_no and 
      dept_manager.dept_no=departments.dept_no and 
      dept_name='Development' and 
      from_date >= 
           (select max(from_date) 
           	from dept_manager, departments 
           	where dept_manager.dept_no=departments.dept_no and 
           	dept_name='Development');

/*13. Hallar el nombre y apellidos de los empleados que trabajan 
o han trabajdo en los departamentos "Development' o 'Research'.
Utiliza subconsultas. Ayuda: 101599. Compara con la consulta 3
e indica porque los nº de registros de las dos consultas
son diferentes
*/

select first_name, last_name 
from employees 
where employees.emp_no in 
	(select emp_no 
	 from dept_emp, departments 
	 where dept_emp.dept_no=departments.dept_no and 
	 	   dept_name in ('Development', 'Research'));

/*14. Hallar el nombre y apellidos de los empleados que cobran o 
han cobrado mas que el salario medio de la empresa (incluye duplicados)
Ayuda: 1255038*/
select first_name, last_name 
from employees, salaries 
where employees.emp_no=salaries.emp_no 
and salary > (select avg(salary) from salaries);

/*15. Hallar el nombre y apellidos de los empleados que cobran o 
han cobrado mas que el salario medio de la empresa sin duplicados.
Ordenalos por apellidos y nombre
Ayuda: 178044
*/

 select first_name, last_name 
 from employees 
 where emp_no in 
 	(select emp_no from salaries where salary > 
 		(select avg(salary) 
 		 from salaries)
 	) 
 order by last_name, first_name;

/*16. Hallar el nombre y apellidos y salario de los empleados que 
cambiaron de sueldo o percibieron sueldo nuevo en 2000 y cuyo sueldo
duro solo en ese año. No utilices subconsultas. Ayuda:4409 
*/

select first_name, last_name 
from employees,salaries 
where employees.emp_no=salaries.emp_no and 
     from_date >= '2000-01-01' and to_date <= '2000-12-31';

/*17. Hallar el nombre y apellidos de los empleados que 
cambiaron de sueldo o percibieron sueldo nuevo en 2000 y cuyo sueldo
duro solo en ese año. Utiliza subconsultas. Ayuda:4409 
Compara los resultados con la consulta 16. Analiza la igualdad de 
resultados y argumenta en qué casos estas dos consultas no mostrarían
el mismo conjunto de resultados (en numero)
*/

select first_name, last_name 
from employees 
where emp_no in (select emp_no 
				 from salaries 
				 where from_date >= '2000-01-01' and to_date <= '2000-12-31'
				 );

/*18. Hallar el nombre del o los departamentos donde trabaja o trabajó 
el empleado que ha cobrado el mayor sueldo de la empresa. Ayuda: Sales.   
*/

select dept_name 
from departments, dept_emp 
where departments.dept_no=dept_emp.dept_no and 
	  emp_no in (select emp_no 
      			 from salaries 
      			 where salary = (select max(salary) 
      				  			 from salaries)  
      			);
      				 
/*19. Hallar el nº de empleados que no han sido nunca jefe de departamento*/
select count(*) 
from employees 
where emp_no not in (select emp_no 
					 from dept_manager);

/*20. Hallar información sobre si algún departamento no ha tenido nunca 
un jefe departamento
*/
select count(*) 
from departments 
where dept_no not in (select dept_no 
					  from dept_manager);


/*21. Hallar el num empleado que haya estado contratado en un departamento 
más tiempo de toda la empresa sin contar los contratos vigentes
Ayuda: datediff(fechahasta, fechadesde) => devuelve num días
Ayuda: contrato vigente to_date='9999-01-01'
Ayuda: resultado = 429386
*/
select emp_no 
from dept_emp  
where datediff(to_date,from_date) = (select max(datediff(to_date,from_date)) 
									from dept_emp 
									where to_date <> '9999-01-01') 
and to_date <> '9999-01-01';


/*22. Hallar el num_empleado, nombre, apellidos y el num de días del empleado 
que haya estado contratado más tiempo de toda la empresa sin contar los contratos
vigentes
Ayuda: Masaki y 6388 días
*/

select employees.emp_no, first_name,last_name,datediff(to_date,from_date) 
from dept_emp,employees 
where dept_emp.emp_no=employees.emp_no and 
datediff(to_date,from_date) = (select max(datediff(to_date,from_date)) 
							   from dept_emp 
							   where to_date <> '9999-01-01') 
and to_date <> '9999-01-01';

/*23. Hallar para cada departamento, el cod_dept, num de empleado y numero de 
días del que haya sido el jefe de ese departamento más tiempo para ese 
departamento sin contar los vigentes
Ayuda: entre otros d001-110022-2464 o d004-110386-1489
*/
select dept_no, emp_no, datediff(to_date,from_date) 
from dept_manager d1 
where datediff(to_date,from_date) = (select max(datediff(to_date,from_date)) 
									from dept_manager d2 
									where d2.dept_no=d1.dept_no 
									and to_date <> '9999-01-01') 
and to_date <> '9999-01-01'
order by dept_no;


/*24. Idem a 23 pero incluyendo el nombre de departamento y el nombre y 
apellidos de los empleados involucrados
*/
select d1.dept_no, dept_name, employees.emp_no, first_name, last_name, datediff(to_date,from_date) 
from dept_manager d1, departments, employees 
where d1.dept_no=departments.dept_no and 
      d1.emp_no=employees.emp_no and 
      datediff(to_date,from_date) = (select max(datediff(to_date,from_date)) 
      								 from dept_manager d2 
      								 where d2.dept_no=d1.dept_no and 
      								 to_date <> '9999-01-01') 
and to_date <> '9999-01-01' 
order by dept_no;

/*25. Hallar el sexo y los dias de jefatura de departamento 
de los jefes que menos hayan durado como jefe de departamento
en cualquier departamento diferenciado por sexo. Correlación.
Ayuda: M-1489 y F-859
*/ 
select gender, datediff(to_date,from_date) dias  
from dept_manager, employees e1 
where dept_manager.emp_no=e1.emp_no 
and datediff(to_date,from_date)=(select min(datediff(to_date,from_date)) 
	                             from dept_manager, employees e2 
	                             where dept_manager.emp_no=e2.emp_no 
	                             and e2.gender=e1.gender);


/*26. Idem a 25 pero incluyendo los nombres y apellidos 
de los empleados involucrados
Ayuda: Shem y Rutger*/
select first_name, last_name, gender, datediff(to_date,from_date) dias 
from dept_manager, employees e1 
where dept_manager.emp_no=e1.emp_no and 
datediff(to_date,from_date)=(select min(datediff(to_date,from_date)) 
							 from dept_manager, employees e2 
							 where dept_manager.emp_no=e2.emp_no and e2.gender=e1.gender);

/*27. Hallar para cada departamento el cod_dep y la duración mínima 
de las jefaturas para dicho departamento*/
select dept_no, datediff(to_date, from_date)  
from dept_manager d1 
where datediff(to_date, from_date) = (select min(datediff(to_date, from_date) ) 
									  from dept_manager d2 
									  where d2.dept_no=d1.dept_no);


/*28. Hallar para cada departamento el codigo de departamento, num empleado
y edad actual (en dias) de aquellos empleados que han sido jefes o son
jefes de ese departamento y que actualmente son los mayores de entre los 
que han sido jefes de ese departamento*/

select dept_no, employees.emp_no, datediff(now(),birth_date) 
from dept_manager d1, employees 
where d1.emp_no=employees.emp_no 
and  datediff(now(),birth_date) = (select max(datediff(now(),birth_date)) 
	                               from dept_manager d2, employees 
	                               where d2.emp_no=employees.emp_no 
	                               and d2.dept_no=d1.dept_no);

/*29. Idem a 28 pero indicad edad en años
*/

select dept_no, employees.emp_no, datediff(now(),birth_date)/365
from dept_manager d1, employees 
where d1.emp_no=employees.emp_no 
and  datediff(now(),birth_date) = (select max(datediff(now(),birth_date)) 
	                               from dept_manager d2, employees 
	                               where d2.emp_no=employees.emp_no 
	                               and d2.dept_no=d1.dept_no);

/*30. Hallar para cada departamento el código de departamento, nº de empleado 
y sueldo de aquellos empleados que habiendo trabajado en ese departamento han 
tenido un mayor sueldo que todos los que han pasado por ese departamento
¿QUé le ocurre a la consulta?. Razona porque crees que ocurre.*/ 

select dept_no, emp_no, salary
from dept_emp d1,salaries
where dept.emp_no=salaries.emp_no
and salary = (select max(salary) 
			  from dept d2, salaries 
			  where d2.emp_no=salaries.emp_no
			  and d2.dept_no=d1.dept_no);

/**
/* EXAMEN PARCIAL
*/			  

/*1. Hallar un listado de alumnos con nombre y apellidos (los dos) ordenado por apellido1
* (0,2 pt)*/
 select nombre, apellido1, apellido2 
 from alumno 
 order by apellido1;

/*2. Hallar un listado de asignaturas con codigo de asignatura, cod_interno, descripcion, nHoras
* ordenado por numero de horas de mayor a menor
* (0,2 pt)*/
select cod_asignatura, cod_interno, descripcion, nHoras 
from asignatura order by nHoras desc;

/*3. Hallar un listado de asignaturas con codigo de asignatura, cod_interno, descripcion, nHoras
* que tenga relación con la palabra datos
* (0,2 pt)*/
select cod_asignatura, cod_interno, descripcion, nHoras 
from asignatura 
where descripcion like '%datos%';

/*4. Hallar el dni y la edad actual (en años) de cada alumno
* (0,4 pt)*/
select dni, datediff(now(),fecha_nac)/365 
from alumno;

/*5.  Hallar dni, nombre y apellidos de aquellos alumnos que 
*residan en la población de Murcia'
*(0,4 pt)*/
select dni, nombre, apellido1, apellido2 
from alumno, codigopostal 
where alumno.cp=codigopostal.cp and poblacion='Murcia';

/*6. Hallar el numero de alumnos diferentes matriculados en el año 2010
*(0,4 pt)*/
select count(distinct(nre)) 
from matricula 
where anyo='2010';


/*7. Hallar el nombre, apellidos, y nombre de departamento donde trabaja cada profesor 
*(0,4 pt)*/
select profesor.nombre, apellido1, apellido2, departamento.nombre 
from profesor, departamento 
where profesor.cod_departamento=departamento.cod_departamento;

/*8. Hallar los nombres y apellidos de los alumnos, junto con 
el nombre de asignaturas y notas obtenidas en éstas
ordenalo por apellido1
(0,5 pt)*/
select nombre, apellido1, apellido2, descripcion,nota 
from alumno,asignatura,matricula 
where alumno.nre=matricula.nre 
	and asignatura.cod_asignatura=matricula.cod_asig
order by apellido1;


/*9. Hallar codigo de asignatura y descripcion de aquellas asignaturas que
se impartieron en el Edificio A en el año 2010 utiliza al menos 
una subconsulta para la reunión de dos tablas
(0,6 pt)*/
select cod_asignatura, descripcion 
from asignatura 
where cod_asignatura in (
	select cod_asig 
	from imparte,edificio 
	where imparte.cod_edificio=edificio.cod_edificio and 
		  edificio.nombre='Edificio A' 
		  and anyo='2010');
 
/*10. Hallar cuantos alumnos diferentes han obtenido en 2010 una calificación (en cualquier asignatura) 
superior a la media de calificaciones de todas las matriculas de ese mismo año 2010
(0,7 pt)*/

 select count(distinct(alumno.nre)) 
 from alumno, matricula 
 where alumno.nre=matricula.nre and anyo='2010' 
 and  nota > (select avg(nota) from matricula where anyo='2010');


/*11. Hallar para cada asignatura el nombre, apellidos, descripcion de asignatura y nota de 
los alumnos que más nota han obtenido de dicha asignatura. Ordenalo por apellido1
(1 pt) */
select nombre, apellido1, apellido2, descripcion, nota 
from alumno, matricula m1, asignatura  
where alumno.nre=m1.nre 
      and m1.cod_asig=asignatura.cod_asignatura 
      and nota = (select max(nota) 
      	          from matricula m2 
      	          where m2.cod_asig=m1.cod_asig) 
order by apellido1;

/*12. Hallar nombre y apellidos de aquellos alumnos que hayan obtenido alguna vez
en alguna asignatura una calificación exactamente igual a la calificación media
para dicha asignatura, sin duplicados.
(1 pt)*/
select nombre, apellido1, apellido2 
from alumno 
where nre in (select nre 
			  from matricula m1 
			  where nota = (select avg(nota) 
			  	            from matricula m2 
			  	            where m2.cod_asig=m1.cod_asig)
			 );
/*13. Hallar nombre y apellidos y edad en años de aquellos alumnos 
que han obtenio la máxima nota en cada asignatura. Incluye solo
los que sean mayores de 30 años, incluye duplicados si existen.
(1 pt)*/ 
select nombre, apellido1, apellido2, datediff(now(),fecha_nac)/365 
from alumno, matricula m1 
where alumno.nre=m1.nre and 
nota = (select max(nota) 
	   from matricula m2 
	   where m2.cod_asig=m1.cod_asig) 
and datediff(now(),fecha_nac)/365 > 30;

/*14. Hallar para cada departamento el nombre del departamento
nombre y apellidos y edad en años del profesor de mayor
edad para ese departamento
(1 pt)*/
select d1.nombre, profesor.nombre, apellido1, apellido2, datediff(now(),fecha_nac)/365 
from departamento d1, profesor 
where profesor.cod_departamento=d1.cod_departamento 
and datediff(now(),fecha_nac)/365=(select 
									max(datediff(now(),fecha_nac)/365) 
									from profesor 
									where profesor.cod_departamento=d1.cod_departamento);

/*15. Hallar para cada departamento nombre, apellidos del/los profesores que hayan calificado 
alguna vez alumnos con la maxima nota para ese departamento. Adjunta también el nombre de departamento
, el nre del estudiante que obtuvo la nota y la nota en sí/
(1 pt)*/
select profesor.nombre, apellido1, apellido2, d1.nombre, matricula.nre, nota 
from departamento d1, profesor, imparte, matricula 
where profesor.cod_departamento=d1.cod_departamento and 
      profesor.nrp=imparte.nrp_profesor and 
      imparte.cod_asig=matricula.cod_asig and 
      nota = (select max(nota) 
      	      from departamento d2, profesor, imparte, matricula 
      	      where profesor.cod_departamento=d2.cod_departamento and 
      	      profesor.nrp=imparte.nrp_profesor and 
      	      imparte.cod_asig=matricula.cod_asig and 
      	      d2.cod_departamento=d1.cod_departamento);
			  
/**
* Ejercicios 8.1
*/
1- Halla el valor absoluto de la suma de las notas de la alumna Marta.
SELECT ABS(SUM(nota)) 
FROM matricula 
WHERE estudiante='Marta';

2- Halla la suma de las edades de todos los alumnos, interpretando que aquellos alumnos cuya edad no haya sido registrada en el sistema tienen 18 años.
SELECT SUM(IFNULL(edad,18)) 
FROM estudiante;

3- Halla la media de horas de todas las asignaturas, y también el entero inmdiatamente superior.
SELECT AVG(horas),CEIL(avg(horas)) 
FROM asignatura;

4- Halla la media de las horas en las que se ha matriculado la alumna Lucía, truncando el resultado a un único decimal.
SELECT TRUNCATE(AVG(horas),1) 
FROM asignatura,matricula 
WHERE estudiante='Lucía' 
AND nombre=asignatura;

5- Muestra el nombre y la nota de cada alumno que haya aprobado Historia, y también el entero inmediatamente inferior a esta nota.
SELECT estudiante,nota,FLOOR(nota) 
FROM matricula 
WHERE asignatura='Historia' 
and nota>=5;

6- Muestra el nombre de cada alumno, el caracter ASCII correspondiente a la edad, y el código ASCII correspondiente a la primera letra del nombre.
SELECT nombre, CHAR(edad),ASCII(nombre) 
FROM estudiante; 

7- Muestra el nombre y las horas de cada asignatura, y también las horas de cada asignatura al elevarla a 2 redondeando a las decenas.
SELECT nombre,horas,ROUND(POWER(horas,2),-1) 
FROM asignatura;

8- Halla la raiz cuadrada del valor absoluto de cada nota de los alumnos mayores de edad, ignorando la parte decimal.
SELECT estudiante,TRUNCATE(SQRT(ABS(nota)),0) 
FROM estudiante,matricula 
WHERE estudiante=nombre 
AND edad>=18;

9- Calcula mediante una consulta. Si impartimos la asignatura de Lengua en clases de 4 horas, ¿cuántas horas se nos quedan "cojas", es decir, sin ajustarse a una clase completa de 4 horas?
SELECT MOD(horas,4) 
FROM asignatura 
Where nombre='Lengua';

10- Calcula la nota media de Lucía, redondeando el resultado final al número entero más próximo, y después redondeando cada nota al número entero más próximo antes de calcular la media.
SELECT estudiante,ROUND(AVG(nota),0),AVG(ROUND(nota,0)) 
FROM matricula 
WHERE estudiante='Lucía';

11- Calcula la nota media de Lucía. Se asignará un 3 de nota en aquellas asignaturas que no hayan sido evaluadas.
SELECT AVG(IFNULL(nota,3)) 
FROM matricula 
WHERE estudiante='Lucía';

12- Muestra un número que nos indique el signo de la nota de Marta en Historia (-1 negativo, 1 positivo).
SELECT SIGN(nota) 
FROM matricula 
WHERE estudiante='Marta' 
AND asignatura='Historia';

13- Muestra una entrada por cada profesor, hallando la media de horas que ha de impartir cada uno.
SELECT distinct(profesor) p,(SELECT AVG(horas) 
FROM asignatura where p=profesor) FROM asignatura;

14- Muestra el nombre de cada estudiante menor de edad en mayúsculas, y la nota en la asignatura Matemáticas.
SELECT UPPER(estudiante),nota 
FROM matricula,estudiante 
WHERE nombre=estudiante 
AND edad<18 
AND asignatura='Matemáticas';

15- Muestra, en una sola cadena, el nombre de cada alumno en minúsculas, y la edad separados por un guión.
SELECT CONCAT(LOWER(nombre),'-',IFNULL(edad,'')) 
FROM estudiante;

16- Muestra, en una sola cadena, el nombre de cada alumno, la asignatura en la que está matriculado separado por un guión, y la cadena ": APROBADO", por cada alumno que haya aprobado.
SELECT CONCAT(estudiante,'-',asignatura,': APROBADO') 
FROM matricula WHERE nota>=5;

Nota: Para mostrar los aprobados y suspensos podría hacerse así:
SELECT IF (IFNULL(nota,0) >= 5,concat(estudiante, ' - ',IFNULL(nota,0),' :APROBADO'), concat(estudiante, ' - ',IFNULL(nota,0) ,' :SUSPENSO')) 
from matricula;

17- Muestra el nombre de cada profesor, y una nueva cadena de 20 caracteres de largo formada por el nombre del profesor(sin espacios en blanco ni signos de interrogación), rellenando por la izquierda con asteriscos y guiones alternativamente.
SELECT nombre,LPAD(REPLACE(LTRIM(nombre),'?',''),20,'*-') 
FROM profesor;

18- Muestra el nombre de cada profesor, la longitud del nombre, y la longitud del nombre después de haber eliminado los signos de interrogación y los espacios en blanco que aparezcan por la izquierda.
SELECT nombre,LENGTH(nombre),LENGTH(REPLACE(LTRIM(nombre),'?','')) 
FROM profesor;

19- Muestra el nombre de cada estudiante, la asignatura en la que está matriculado, y el código ASCII correspondiente al nombre de la asignatura después de haber eliminado las 4 primeras letras.
SELECT estudiante,asignatura, ASCII(SUBSTR(asignatura,5)) 
FROM matricula;

20- Muestra el nombre de cada asignatura convertido a mayúsculas, y la posición del nombre en mayúsculas en la que aparece por primera vez el caracter "a".
SELECT UPPER(nombre),INSTR(UPPER(nombre),'a') 
FROM asignatura;

21- Muestra el nombre de cada profesor, las 3 primeras letras de cada asignatura que imparte, y la longitud del nombre de cada asignatura después de haberle quitado las 3 primeras letras.
SELECT profesor.nombre,SUBSTR(asignatura.nombre,1,3),LENGTH(asignatura.nombre)-3 
FROM profesor,asignatura WHERE profesor=profesor.nombre;

22- Halla el nombre de cada alumno y la asignatura en la que está matriculado, la fecha y los días restantes del mes de la fecha en la que se matricularon.
SELECT estudiante,asignatura,fecha,DATEDIFF(LAST_DAY(fecha),fecha) 
FROM matricula;

23- Halla el nombre, la fecha en la que se matricularon en cada asignatura, y la fecha añadiéndole 15 días, de los alumnos mayores de edad.
SELECT estudiante,fecha,ADDTIME(fecha,"15 00:00:00") 
FROM matricula,estudiante 
WHERE nombre=estudiante AND edad>=18;

24- Muestra el estudiante, la asignatura y la fecha en la que se matriculó cada alumno en cada asignatura, y halla los meses que faltan hasta enero de 2016 desde la fecha en la que se matriculó cada alumno en cada asignatura (Nota: la fecha más antigua es de 2014, luego el máximo de meses posible es 24).
SELECT estudiante,asignatura,fecha,25-MONTH(fecha)-(12*(YEAR(fecha)-2014)) AS meses_restantes 
FROM matricula;

25- Halla el nombre de todos los profesores que llevan impartiendo clase desde hace más de un año, y muestra la fecha desde que empezaron a dar clase y cuántos días han pasado desde que empezaron (Nota: sólo una entrada por profesor, los días se calculan desde la fecha más antigua. La fecha de la tabla MATRICULA es el primer día de clase).
SELECT p1.nombre,fecha,DATEDIFF(SYSDATE(),fecha) 
FROM matricula,profesor p1,asignatura 
WHERE p1.nombre=profesor 
AND asignatura=asignatura.nombre 
AND DATEDIFF(SYSDATE(),fecha)>365 
AND DATEDIFF(SYSDATE(),fecha)=(SELECT MAX(DATEDIFF(SYSDATE(),fecha)) 
								FROM matricula,profesor p2,asignatura 
								WHERE p1.nombre=p2.nombre 
								AND p2.nombre=profesor 
								AND asignatura=asignatura.nombre);

/**
*Ejercicios 7.4 sobre base de datos de instituto.sql
*/

/*1.Hallar nombre y apellidos de los alumnos junto con el codigo de asignatura, 
descripcion, nota obtenida y año*/
select nombre, apellido1, apellido2, cod_asig, descripcion, nota, anyo 
from alumno, matricula, asignatura 
where alumno.nre=matricula.nre and 
	  matricula.cod_asig=asignatura.cod_asignatura;

/*2. Hallar nombre y apellidos de los profesores junto con el codigo de asignatura
impartida, descripcion, año de impartición y nombre de edificio dónde la impartió*/
select profesor.nombre, apellido1, apellido2, cod_asig, descripcion, anyo, edificio.nombre 
from profesor, imparte, asignatura, edificio 
where profesor.nrp=imparte.nrp_profesor and 
      imparte.cod_asig=asignatura.cod_asignatura and 
      imparte.cod_edificio=edificio.cod_edificio;

/*3. Hallar cod_asignatura, descripcion y horas de cada asignatura junto con la
 descricpión del departamento al que pertenece el pofesor que la imparte*/
select asignatura.cod_asignatura, asignatura.descripcion, nHoras, departamento.descripcion 
from asignatura, imparte, profesor, departamento 
where asignatura.cod_asignatura=imparte.cod_asig and 
	  imparte.nrp_profesor=profesor.nrp and 
	  departamento.cod_departamento=profesor.cod_departamento;

/*4.Hallar en nº de matriculas totales realizadas en asignaturas impartidas
por profesores del departamento de sistemas*/ 
select count(*) 
from matricula, asignatura, imparte, profesor, departamento  
where matricula.cod_asig=asignatura.cod_asignatura and 
      asignatura.cod_asignatura=imparte.cod_asig and 
      imparte.nrp_profesor=profesor.nrp and 
      profesor.cod_departamento=departamento.cod_departamento and 
      departamento.nombre='Sistemas';

/*5. Hallar en nº de alumnos diferentes matriculados en asignaturas impartidas
por profesores del departamento de sistemas*/
select count(distinct(nre)) 
from matricula, asignatura, imparte, profesor, departamento  
where matricula.cod_asig=asignatura.cod_asignatura and 
      asignatura.cod_asignatura=imparte.cod_asig and 
      imparte.nrp_profesor=profesor.nrp and 
      profesor.cod_departamento=departamento.cod_departamento and 
      departamento.nombre='Sistemas';


/*6. Hallar el nº de alumnos totales (sin duplicados) que cursaron asignaturas en el Edificio A en 
el año 2007*/
select count(distinct(nre)) 
from matricula, asignatura, imparte, edificio 
where matricula.cod_asig=asignatura.cod_asignatura and 
      imparte.cod_asig=asignatura.cod_asignatura and 
      imparte.cod_edificio=edificio.cod_edificio and 
      imparte.anyo='2007' and edificio.nombre='Edificio A';

/*7. Hallar dni, nombre, apellidos, edad en años y nombre de departamento de los profesores de 
mayor edad de  cada departamento*/
select dni, p1.nombre, apellido1, apellido2, datediff(now(),fecha_nac)/365, departamento.nombre 
from profesor p1, departamento 
where p1.cod_departamento=departamento.cod_departamento and 
      datediff(now(),fecha_nac)=(select max(datediff(now(),fecha_nac)) 
      	                         from profesor p2 
      	                         where p2.cod_departamento=p1.cod_departamento);

/*8.Hallar el dni, nombre y apellidos y num horas totales del profesor con dni '47948793H' 
contando todas las asignaturas que ha impartido en 2008*/
select dni, nombre, apellido1, apellido2, sum(nHoras)  
from profesor,imparte, asignatura 
where profesor.nrp=imparte.nrp_profesor and 
      imparte.cod_asig=asignatura.cod_asignatura and 
      dni='47948793H' and imparte.anyo=2008;

/*9. Hallar el dni, nombre, apellidos y nombre de población de los profesores de mayor
edad de cada población*/
select dni, nombre, apellido1, apellido2, datediff(now(), fecha_nac)/365, poblacion 
from profesor, codigopostal c1 
where profesor.cp=c1.cp and 
datediff(now(), fecha_nac)=(select max(datediff(now(), fecha_nac)) 
	 						from profesor, codigopostal c2 
	 						where profesor.cp=c2.cp and c2.poblacion=c1.poblacion); 

/*10. Hallar el dni, nombre, apellidos y nombre de población de los alumnos de mayor
edad de cada población pero solo de los matriculados en 2010, puedes incluir duplicados*/
select dni, nombre, apellido1, apellido2, datediff(now(), fecha_nac)/365, poblacion 
from alumno, matricula, codigopostal c1 
where alumno.cp=c1.cp and 
      matricula.nre=alumno.nre and 
      anyo=2010 and 
      datediff(now(), fecha_nac)=(select max(datediff(now(), fecha_nac)) 
      	                          from alumno, matricula, codigopostal c2 
      	                          where alumno.cp=c2.cp and 
      	                                matricula.nre=alumno.nre and 
      	                                anyo=2010 and 
      	                                c2.poblacion=c1.poblacion);

/**
*Ejercicios 9.1 sobre base de datos de instituto.sql
*/

/*1.Hallar el nre y la nota media de cada uno de los alumnos
La nota media hará referencia a el expediente del alumno */
select alumno.nre, avg(nota)  
from alumno,matricula 
where alumno.nre=matricula.nre 
group by alumno.nre;

/*2.Hallar el nre y la nota media de cada uno de los alumnos
La nota media solo hará referencia a las matriculas de 2010 
de cada alumno*/
select alumno.nre, avg(nota)   
from alumno,matricula  
where alumno.nre=matricula.nre and 
anyo=2010 
group by alumno.nre;

/*3.Hallar el nre y la nota media de cada uno de los alumnos
La nota media solo hará referencia a las matriculas de 2010 
de cada alumno. Sacar solo los alumnos de nota media superior
o igual a 5*/
select alumno.nre, avg(nota)   
from alumno,matricula  
where alumno.nre=matricula.nre and 
      anyo=2010 
group by alumno.nre
having avg(nota) >= 5;

/*4.Hallar el nre y la nota media de cada uno de los alumnos
La nota media de todo su expediente solo hará referencia a 
las asignaturas aprobadas de todo su expediente*/
select alumno.nre, avg(nota)   
from alumno,matricula  
where alumno.nre=matricula.nre and 
      nota >= 5 
group by alumno.nre; 


/*5.Hallar el nre y la nota media de cada uno de los alumnos
La nota media de todo su expediente solo hará referencia a 
las asignaturas aprobadas de todo su expediente
Sacar solo los alumnos que tengan nota media >= 8*/
select alumno.nre, avg(nota)  
from alumno,matricula  
where alumno.nre=matricula.nre and 
      nota >= 5 
group by alumno.nre 
having avg(nota) >= 8;

/*6. Hallar el codigo de asignatura y el total de matriculados diferentes 
por cada asignatura en 2010*/
select cod_asig, count(distinct(nre)) 
from matricula 
where anyo=2010 
group by cod_asig;

/*7. Hallar para cada asignatura el codigo y la nota media de dicha
asignatura teniendo en cuenta todas la matriculas de todos los 
años*/
select cod_asig, avg(nota) 
from matricula 
group by cod_asig;

/*8. Hallar para cada asignatura el codigo y la nota media de dicha
asignatura teniendo en cuenta solo las matriculas de 2008 */
select cod_asig, avg(nota) 
from matricula 
where anyo=2008 
group by cod_asig;

/*9. Hallar para cada asignatura el codigo y la nota media de dicha
asignatura teniendo en cuenta solo las matriculas de 2008. 
Sacar solo las asignaturas cuya nota media resultante sea
< 5*/
select cod_asig, avg(nota) 
from matricula 
where anyo=2008 
group by cod_asig 
having avg(nota) < 5;

/*10. Hallar para cada asignatura el código y la descripción asi como
la nota media para cada una de ellas*/
select cod_asig, descripcion, avg(nota) 
from matricula, asignatura 
where matricula.cod_asig=asignatura.cod_asignatura 
group by cod_asig, descripcion;

/*11. Hallar para cada profesor el nrp y la nota media
contando todas las notas obtenidas por todos los alumnos
que han cursado asignaturas impartidas por él*/
select nrp_profesor, avg(nota) 
from  imparte, matricula 
where imparte.cod_asig=matricula.cod_asig 
group by nrp_profesor;

/*12. Hallar para cada profesor el nrp y la nota media
contando todas las notas obtenidas por todos los alumnos
que han cursado asignaturas impartidas por él, pero 
solo considerando las asignaturas impartidas en 
2009*/
select nrp_profesor, avg(nota) 
from  imparte, matricula 
where imparte.cod_asig=matricula.cod_asig and 
      imparte.anyo=2009 
group by nrp_profesor;

/*13. Hallar para cada profesor el nrp y la nota media
contando todas las notas obtenidas por todos los alumnos
que han cursado asignaturas impartidas por él, pero 
solo considerando las asignaturas impartidas en 
2009 y solo cuando la nota media resultante 
sea inferior a 5*/
select nrp_profesor, avg(nota) 
from imparte, matricula 
where imparte.cod_asig=matricula.cod_asig and 
      imparte.anyo=2009 
group by nrp_profesor 
having avg(nota) < 5;

/*14. Hallar para cada profesor el nrp, nombre y apellidos 
y la nota media contando todas las notas obtenidas por todos los alumnos
que han cursado asignaturas impartidas por él, pero 
solo considerando las asignaturas impartidas en 
2009 y solo cuando la nota media resultante 
sea inferior a 5*/
select nrp_profesor, nombre,apellido1, apellido2, avg(nota) 
from  imparte, profesor, matricula 
where profesor.nrp=imparte.nrp_profesor and 
      imparte.cod_asig=matricula.cod_asig and 
      imparte.anyo=2009 
group by nrp_profesor, nombre, apellido1, apellido2 
having avg(nota) < 5;

/*15. Hallar para cada departamento el codigo de departamento
junto con la nota media para ese departamenteo calculada en base 
a todas las asignaturas impartidas por profesores de ese departamento 
teniendo en cuenta solo las notas de los alumnos matriculados en 2008*/
select cod_departamento, avg(nota) 
from profesor, imparte, asignatura, matricula  
where profesor.nrp=imparte.nrp_profesor and 
      asignatura.cod_asignatura=imparte.cod_asig and 
      matricula.cod_asig=asignatura.cod_asignatura and
      matricula.anyo=2008
group by cod_departamento; 

/*16. Hallar para cada departamento el codigo de departamento y nombre
junto con la nota media para ese departamenteo calculada en base 
a todas las asignaturas impartidas por profesores de ese departamento 
teniendo en cuenta solo las notas de los alumnos matriculados en 2008.
Sacar solo lo departamentos cuya media resultante así calculada sea
menor que 5
*/
select departamento.cod_departamento, departamento.nombre, avg(nota) 
from departamento, profesor, imparte, asignatura, matricula  
where departamento.cod_departamento=profesor.cod_departamento and 
      profesor.nrp=imparte.nrp_profesor and 
      asignatura.cod_asignatura=imparte.cod_asig and 
      matricula.cod_asig=asignatura.cod_asignatura and
       matricula.anyo=2008 
group by departamento.cod_departamento, departamento.nombre 
having avg(nota) < 5;

			  
/**
* FUNCIONES
*/
//FUNCIONES Numericas
# ABS(X) Valor absoluto de X Ej.; (7,35 = 7) y (-7 = 7)						
# CEIL(X) Valor inmediatamente superior a X (1,23 = 2) y (-1,23 = -1)						
# FLOOR	FLOOR(X) Valor inmediatamente inferior a X (1.23 = 1) y (-1,23 = -2)						
# MOD(N,M) || N % M	Devuelve el resto de la división entera de N y M						
# IFNULL || IFNULL(M, N) Devuelve en caso de no ser null M y si es null N						
# POW(X,Y) Eleva X a Y						
# ROUND(X) || ROUND(X,D) redondea X a entero, o redondea a X con Y numeros decimales						
					-->	ROUND(1.298, 1) = 1.3 &&  ROUND(23.298, -1) = 20						
# SIGN(X) Devuelve un -1 si es negativo o un 1 si es positivo						
# SQRT(X) La raíz cuadrada de X						
# TRUNCATE(X,D)	el número X, truncado a D decimales. Si D es 0, el resultado no trendrá punto decimal
//FUNCIONES caracteres
# CHAR(N1,N2...) recive números y los convierte en caracteres
# CONCAT(str1,str2,...) Devuelve la cadena resultante de concatenar los argumentos
# LOWER(str) Devuelve un str en minusculas
# UPPER(str) Devuelve un str en mayusculas
# LPAD(str,len,padstr) devuelve el str con la cadena padstr el número de veces estipulado en len
# RPAD(str,len,padstr) devuelve el str con la cadena padstr el número de veces estipulado en len
# LTRIM(str) Acorta el espacio de la izquierda de str
# RTRIM(str) Acorta el espacio de la derecha de str
# REPLACE(str,from_str,to_str) devuelve el str acortado desde from_str hasta to_str
# SUBSTR(str, pos, lon) devuelve un str desde la posición pos con la longuitud lon
					-->  SUBSTRING('Funciones MySQL',7,3) = nes
# ASCII(str) devuelve el ASCII del caractere que le pases
# INSTR(str,substr) instanceOf de substr
# LENGTH(str) la longitud del string
//FUNCIONES de fechas
# SYSDATE() || NOW() Devuelve la fecha y hora actual
# ADDTIME(expr,expr2) añade expr2 a expr y devuelve el resultado
# LAST_DAY(fecha) Toma un valor fecha o fecha y hora y devuelve el valor correspondiente
para el último día del mes. Devuelve NULL si el argumento no es válido.
# DATEDIFF(expr,expr2) devuelve el número de días entre la fecha de inicio expr y la
de final expr2
# YEAR(fecha) Devuelve el año para una fecha, en el rango de 1000 a 9999
# MONTH(fecha) Devuelve el mes de una fecha, en el rango de 1 a 12.
# DAY(fecha) Devuelve el día del mes de una fecha, en el rango de 1 a 31.
