<?php
include "../includes/config/conn.php";
$conn = connect();

// Obtener los datos enviados desde el formulario
$num = $_POST['num'];
$numTel = $_POST['numTel'];
$email = $_POST['email'];

// Recuperar los valores originales si algún campo está vacío
$query = "SELECT numTel, email FROM employee WHERE num = ?";
$stmt = $conn->prepare($query);
if ($stmt === false) {
    die("Error preparando la consulta: " . $conn->error);
}

// Asociar parámetros y ejecutar la consulta
$stmt->bind_param("i", $num);
$stmt->execute();
$result = $stmt->get_result();

// Verificar si el empleado existe
if ($result->num_rows > 0) {
    $employee = $result->fetch_assoc();

    // Mantener los valores originales si no se modificaron
    $numTel = empty($numTel) ? $employee['numTel'] : $numTel;
    $email = empty($email) ? $employee['email'] : $email;
} else {
    echo '<script type="text/javascript"> 
            alert("Employee not found"); 
            window.location.href = "WEmployees.php"; 
          </script>';
    exit();
}

// Consulta de actualización preparada
$update = "UPDATE employee SET numTel = ?, email = ? WHERE num = ?";
$stmt = $conn->prepare($update);
if ($stmt === false) {
    die("Error preparando la consulta: " . $conn->error);
}

// Asociar parámetros a la consulta
$stmt->bind_param("ssi", $numTel, $email, $num);

// Ejecutar la consulta
if ($stmt->execute()) {
    echo '<script type="text/javascript"> 
            alert("Updated Successfully"); 
            window.location.href = "WEmployees.php"; 
          </script>';
} else {
    echo '<script type="text/javascript"> 
            alert("Error Updating the employee: ' . $stmt->error . '"); 
            window.location.href = "WEmployees.php"; 
          </script>';
}

// Cerrar la conexión y la consulta preparada
$stmt->close();
$conn->close();
?>
