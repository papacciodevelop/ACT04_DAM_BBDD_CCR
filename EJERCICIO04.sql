/*Crear un tablespace de 400MB llamado empresa donde se almacenarán todos los datos.*/
CREATE TABLESPACE empresa DATAFILE 'C:\SQLDEVELOPER\EJERCICIO04\empresa.dbf' size 400M;

/* Crea un usuario llamado “tecnico” que tenga todos los privilegios en el sistema Oracle. */
CREATE USER tecnico IDENTIFIED BY "1234" DEFAULT TABLESPACE empresa QUOTA UNLIMITED ON  empresa;
/*Comprobar que realmente tiene asignados estos permisos. */
GRANT CREATE SESSION TO tecnico;
/*LE ASIGNAMOS TODOS LOS PRIVILEGIOS*/
GRANT ALL PRIVILEGES TO tecnico;
/* PODRÁ TRABAJAR CON LOS OBJETOS BASICOS DE LA BBDD  NO NECESARIO SE ASIGNA ARRIBA CON ALL PRIV
GRANT RESOURCE TO  TECNICO; */
SELECT PRIVILEGE FROM dba_sys_privs WHERE grantee='TECNICO';

/* cONECTAMOS CON EL USUARIO*/
CONNECT tecnico;
/* CREAMOS LA TABLA CON LOS DATOS */
CREATE TABLE incidencias(
cod_incidencia INT PRIMARY KEY NOT NULL,
equipo_incidencia VARCHAR(25) NOT NULL,
descripcion VARCHAR(70) NOT NULL,
usuario VARCHAR(25) NOT NULL,/*¿NO DEBERIA SER OTRA TABLA CON LOS USUARIOS CREADOS?*/
fecha DATE NOT NULL,
/*hora DATE DEFAULT sysdate NO ESTABA MUY SEGURO DE SI SE REQUERIA FORMATO HORA O SOLO INTRODUCIR NUMEROS*/
hora VARCHAR(8),/*23:45:02*/
solucionada CHAR(1) NOT NULL,
coste NUMBER(6) NOT NULL);

INSERT INTO INCIDENCIAS VALUES(05458,'MAC M1','PROBLEMA AL GESTIONAR NODE','IOS-DEVELOPERS',TO_DATE('22/02/2022','DD/MM/YYYY'),'12:32','S',75 );
INSERT INTO INCIDENCIAS VALUES(00541,'MACBOOK INTEL','PANTALLA RETINA CON PROBLEMAS','IOS-DEVELOPERS',TO_DATE('20/02/2022', 'DD/MM/YYYY'),'09:02:03','N',400.58 );



/* 4 Crear dos usuarios “user1” y “user2” con password “Abcd1234”, que se encarguen de la gestión de las incidencias (añadir, modificar, borrar, consultar).  Comprueba que los privilegios se han asignado de forma correcta y que puede hacer las operaciones asignadas.*/
/*CREAR USER1*/
CREATE USER user1 IDENTIFIED BY "abcd1234"  DEFAULT TABLESPACE empresa QUOTA UNLIMITED ON empresa;
/*permisos para que se pueda loggerar*/
GRANT CREATE SESSION TO user1;
/*PERMISOS SOBRE LA TABLA */
GRANT SELECT,INSERT ,UPDATE, DELETE ON tecnico.incidencias TO user1;
/*conectamos*/
CONNECT user1;
/*crud*/
INSERT INTO INCIDENCIAS VALUES(00564,'lenovo idealpad','PANTALLA  CON PROBLEMAS','android-DEVELOPERS',TO_DATE('10/02/2022', 'DD/MM/YYYY'),'00:02:03','N',100.58 );
SELECT * FROM incidencias;
UPDATE incidencias set descripcion = 'se apaga' WHERE cod_incidencia = 00564;
DELETE FROM incidencias where cod_incidencia = 00564;
/*COMPROBAR PERMISOS SOBRE TABLA*/
SELECT PRIVILEGE FROM dba_tab_privs WHERE grantee='USER1' AND table_name='INCIDENCIAS';


/*CREAR USER2*/
CREATE USER user2 IDENTIFIED BY "abcd1234"  DEFAULT TABLESPACE empresa QUOTA UNLIMITED ON empresa;
/*permisos para que se pueda loggerar*/
GRANT CREATE SESSION TO user2;
/*PERMISOS SOBRE LA TABLA */
GRANT SELECT,INSERT ,UPDATE, DELETE ON tecnico.incidencias TO user2;

/*conectamos*/
CONNECT user2;
/*crud*/
INSERT INTO INCIDENCIAS VALUES(456,'ASUS','SIN GRAFICA','JAVA-DEVELOPERS',TO_DATE('10/02/2022', 'DD/MM/YYYY'),'00:02:03','N',500 );
SELECT * FROM incidencias;
UPDATE incidencias set descripcion = 'se apaga' WHERE cod_incidencia = 456;
DELETE FROM incidencias where cod_incidencia = 456;

/*COMPROBAR PERMISOS SOBRE LA TABLA */
GRANT SELECT,INSERT ,UPDATE, DELETE ON tecnico.incidencias TO user2;


/* 5. Se decide que el usuario “user1” pueda crear nuevos usuarios, pero no podrá eliminar a ningún usuario.  Comprobar que realmente tiene asignados estos permisos. 
Quitamos el permiso de borrar registros al usuario “user2” sobre la tabla de incidencias. Comprobación.*/


/*AÑADIR PERMISO PARA CREAR USUSARIOS*/
GRANT CREATE USER TO user1;
/*COMPROBAR SI SE AÑADE EL PERMISO AL USER1*/
SELECT PRIVILEGE FROM dba_sys_privs WHERE grantee='USER1';
CONNECT user1; 
/* INTENTO BORRAR EL USUARIO USER2 Y LANZA UN ORA-01031: privilegios insuficientes*/
DROP USER user2;
/* QUITAR PERMISO DE BORRAR*/
REVOKE DELETE ON tecnico.incidencias FROM USER2;
SELECT PRIVILEGE FROM dba_tab_privs WHERE grantee='USER2' AND table_name= 'INCIDENCIAS';

/*6-- El usuario “tecnico” concede al usuario “user2”, la posibilidad de asignar el permiso de lectura (SELECT) 
de datos a otros usuarios sobre la tabla de incidencias. Comprobar que realmente tiene asignados estos permisos.*/

/*CONECTAMOS A TÉCNICO*/
CONNECT tecnico;
/*PERMISO DE SELECT*/
GRANT SELECT ON tecnico.incidencias TO user2 WITH GRANT OPTION;
/*COMPROBAR LOS PERMISOS*/
SELECT PRIVILEGE FROM dba_tab_privs WHERE grantee='USER2' AND table_name='INCIDENCIAS';
/*conexion a user2*/
CONNECT user2;
/*ASIGNAR SELECT A USER1*/
GRANT SELECT ON tecnico.incidencias to user1;

/* --7-- Crea un rol llamado rolincidencias con las siguientes características: 
Puede iniciar sesión, leer y modificar la tabla de incidencias (no puede ni borrar ni añadir).*/

/*CREATE ROL*/
CREATE ROLE rolincidencias;
/*permisos de conexion */
GRANT CREATE SESSION TO rolincidencias;
/*ASIGNAR PERMISO DE SELECT EN ROLINCIDENCIAS */
GRANT SELECT ON tecnico.incidencias to rolincidencias;
/*ASIGNAR PERMISO DE update EN ROLINCIDENCIAS */
GRANT UPDATE ON tecnico.incidencias to rolincidencias;
/*MOSTRAR PRIVILEGIOS DE LA TABLA*/
SELECT PRIVILEGE table_name FROM role_tab_privs WHERE role = 'ROLINCIDENCIAS';


/* --8--Crea un usuario nuevo llamado “user3” con password “System1234” y le asignas 
el rol anterior. Comprueba que tienen los permisos correspondientes.*/

/*CREAR USUSARIO*/
CREATE USER user3 IDENTIFIED BY "System1234" DEFAULT TABLESPACE empresa QUOTA UNLIMITED ON empresa;
/*asignar el rol a user3*/
GRANT rolincidencias TO user3;
SELECT SUBSTR(grantee,1,20),SUBSTR(grantee,1,20)FROM dba_role_privs WHERE grantee='USER3';
CONNECT user3;
SELECT * FROM tecnico.incidencias;
UPDATE tecnico.incidencias SET coste=200 WHERE cod_incidencia = '5458';


/*--9--  Crearemos un perfil para los usuarios llamado perfilusuario que tenga un
tiempo máximo de conexión de 1 hora, dos conexiones simultáneas y le obligue a cambiar 
la contraseña cada 30 días. Asigna este perfil al usuario user3*/
 /*CREAR PERFIL*/
CREATE PROFILE perfilusuario LIMIT SESSIONS_PER_USER 2 CONNECT_TIME 60/*SON MINUTOS*/ PASSWORD_LIFE_TIME 30; 
ALTER USER user3 profile perfilusuario;
SELECT RESOURCE_NAME , SUBSTR(LIMIT,1,10) FROM DBA_PROFILES WHERE profile= 'PERFILUSUARIO';