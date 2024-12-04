<?php
include "../includes/config/conn.php";
include "../includes/config/functions.php";

// Obtener la información del empleado
$query_employee = "SELECT num, name FROM employee";
$conn = connect();

$num = $_REQUEST['num']; // Obtener el número del empleado

// Obtener la información del empleado
$infoEmployee = getEmployeeInfo($num);

if (!$infoEmployee) {
    exit("Empleado no encontrado.");
}
?>

<link rel="stylesheet" href="includes/css/forms.css">
<nav id="Return"><a href="WEmployees.php">Return</a></nav>
<section id="formCont">
    <div id="formCard">
        <form action="employeeRHProcess.php" method="POST">
            <label>Employee Number</label>
            <input type="number" name="num" id="num" value="<?=$infoEmployee['num']?>" readonly>
            <label>Employee Name</label>
            <input type="text" name="name" id="name" value="<?=$infoEmployee['name']?>" readonly>
            <input type="hidden" name="status" id="status" value="1"> <!-- 1 para reactivar -->
            <div>
                <button type="submit" class="button">REHIRE</button>
            </div>
        </form>
    </div>
</section>
