<?php
// Conexión a la base de datos
include "includes/config/conn.php";

$db = connect();
session_start();

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST['username'];
    $password = $_POST['password'];

    // 
    $sql = "SELECT username, password, area, status FROM USER as u 
    join EMPLOYEE as e on u.num = e.num 
    WHERE username = ?";
    $stmt = $db->prepare($sql);
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        // Comparar directamente la contraseña
        if ($password === $user['password']  ) {
            $_SESSION['username'] = $user['username'];
            if($user['status'] === 'inactivo'){
                
                echo '<script type="text/javascript"> alert("Usuario inactivo, contacta con RRHH"); window.location.href="login.php" </script>';
                exit;
            }
            $_SESSION['username'] = $user['username'];
            $_SESSION['area'] = $user['area'];

            switch ($user['area']) {
                case '1':
                    header("Location: order.php");
                    break;
                
                case '2':
                    header("Location: index.php");
                    
                    break;
                default:
                header("Location: index.php");
                
                    // De momento te  redirige a la página de inicio
                    exit;
                    break;
            }
             
            exit;
        } else {
            echo '<script type="text/javascript"> alert("Contraseña incorrecta"); window.location.href="login.php" </script>';

        }
    } else {
        echo '<script type="text/javascript"> alert("Usuario no encontrado"); window.location.href="login.php" </script>';
    }

    $stmt->close();
}
$conn->close();
?>