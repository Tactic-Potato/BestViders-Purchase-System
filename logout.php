<?php
session_start(); // Inicia la sesión

// Destruye todas las variables de sesión
$_SESSION = [];

// Elimina la cookie de sesión si existe
if (ini_get("session.use_cookies")) {
    $params = session_get_cookie_params();
    setcookie(session_name(), '', time() - 42000,
        $params["path"], $params["domain"],
        $params["secure"], $params["httponly"]
    );
}

// Finalmente destruye la sesión
session_destroy();

// Redirige al usuario a la página de inicio de sesión o principal
header("Location: login.php");
exit();