<?php
//sintáxis ==>define('NOMBREVARIABLE','valor');
define('SITENAME','BestViders');

define('ROOTURL','http://localhost/PeliculasPato/admin/');
define('DOCROOT',$_SERVER['DOCUMENT_ROOT'].'/PeliculasPato/admin/');

//VARIABLES SON PARA LA CONEXION A LA BASE DE DATOS
define('DBHOST','localhost');
define('DBUSER','root');
define('DBPASSWD','');
define('DBNAME','bestviders');



include('funciones.php');

session_start();
?>