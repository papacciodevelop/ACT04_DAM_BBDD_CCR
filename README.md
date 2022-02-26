# ACT04_DAM_BBDD_CCR
Gestión de incidencias.


La empresa para la que estamos trabajando nos ha pedido una pequeña aplicación para controlar las incidencias que se van produciendo en los diferentes equipos y servidores de la empresa. Por lo que decidimos crear una base de datos para controlar el problema.
De cada incidencia guardaremos la siguiente información:
    • Código de la incidencia.
    • Equipo donde se produce la incidencia
    • Descripción 
    • usuario 
    • fecha 
    • hora 
    • Solucionada (S/N) 
    • Coste

Un ejemplo de incidencia podría ser: Ana Mora nos comenta el día 12/10/2021 a las 13:50 que el equipo portátil 01 no funciona el disco duro.
Para implementar la tarea debemos realizar las siguientes operaciones:
    1. Crear un tablespace de 400MB llamado empresa donde se almacenarán todos los datos.
    2. Crea un usuario llamado “tecnico” que tenga todos los privilegios en el sistema Oracle. Comprobar que realmente tiene asignados estos permisos.


    3. Utilizando el usuario de nombre “tecnico” crea la tabla incidencias. Utilizar el tipo de campo y la longitud que creáis más adecuados para cada uno de los campos. Introduce datos en las tablas.


    4. Crear dos usuarios “user1” y “user2” con password “Abcd1234”, que se encarguen de la gestión de las incidencias (añadir, modificar, borrar, consultar).  Comprueba que los privilegios se han asignado de forma correcta y que puede hacer las operaciones asignadas.


    5. Se decide que el usuario “user1” pueda crear nuevos usuarios, pero no podrá eliminar a ningún usuario.  Comprobar que realmente tiene asignados estos permisos. 
Quitamos el permiso de borrar registros al usuario “user2” sobre la tabla de incidencias. Comprobación.


    6. El usuario “tecnico” concede al usuario “user2”, la posibilidad de asignar el permiso de lectura (SELECT) de datos a otros usuarios sobre la tabla de incidencias. Comprobar que realmente tiene asignados estos permisos.

    7. Crea un rol llamado rolincidencias con las siguientes características: Puede iniciar sesión, leer y modificar la tabla de incidencias (no puede ni borrar ni añadir).

    8. Crea un usuario nuevo llamado “user3” con password “System1234” y le asignas el rol anterior. Comprueba que tienen los permisos correspondientes.

    9. Crearemos un perfil para los usuarios llamado perfilusuario que tenga un tiempo máximo de conexión de 1 hora, dos conexiones simultáneas y le obligue a cambiar la contraseña cada 30 días. Asigna este perfil al usuario user3
