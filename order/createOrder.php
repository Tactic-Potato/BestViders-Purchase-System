<?php
require '../includes/config/conn.php';

$db = connect();

$query_employee = "SELECT num, firstName FROM employee";
$employees = mysqli_query($db, $query_employee);

$query_rawMaterial = "SELECT code, name FROM raw_material";
$materials = mysqli_query($db, $query_rawMaterial);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $descrp = $_POST['descrp'];
    $employee = $_POST['employee'];
    $rawMaterial = $_POST['rawMaterial'];

    if (empty($rawMaterial)) {
        echo "<script>
                alert('Por favor selecciona un material válido.');
                window.location.href = 'createOrder.php';
              </script>";
        exit;
    }    

    // Validar si el material existe
    $query_check_material = "SELECT 1 FROM raw_material WHERE code = ?";
    $stmt_check = mysqli_prepare($db, $query_check_material);
    mysqli_stmt_bind_param($stmt_check, 'i', $rawMaterial);
    mysqli_stmt_execute($stmt_check);
    mysqli_stmt_store_result($stmt_check);

    if (mysqli_stmt_num_rows($stmt_check) == 0) {
        echo "<script>
                alert('El material seleccionado no existe. Por favor, selecciona un material válido.');
                window.location.href = 'createOrder.php';
              </script>";
        exit;
    }
    mysqli_stmt_close($stmt_check);

    // Usar el procedimiento almacenado
    $stmt = mysqli_prepare($db, "CALL Sp_CreateOrder(?, ?, ?)");
    
    if (!$stmt) {
        die('Error preparando la consulta: ' . mysqli_error($db));
    }

    mysqli_stmt_bind_param($stmt, 'sii', $descrp, $employee, $rawMaterial);

    // Ejecutar el procedimiento almacenado
    if (mysqli_stmt_execute($stmt)) {
        echo "<script>
                alert('Registro Exitoso');
                window.location.href = 'createOrder.php';
              </script>";
    } else {
        echo "<script>
                alert('Error al registrar: " . mysqli_stmt_error($stmt) . "');
                window.location.href = 'createOrder.php';
              </script>";
    }

    mysqli_stmt_close($stmt);
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="../includes/css/Form3.css">
    <title>Create Order</title>
</head>
<body>
<nav id="Return"><a href="../index.php">Return</a></nav>
<section id="formCont">
    <div id="formCard">
        <form id="orderForm" method="POST" action="createOrder.php">
            <h2>Create an Order</h2>
            
            <!-- Descripción -->
            <div class="row">
                <div class="form-group">
                    <label for="descrp">Description</label>
                    <textarea 
                        name="descrp" 
                        id="descrp" 
                        placeholder="Enter order description" 
                        required
                    ></textarea>
                </div>
            </div>

            <!-- Selección de empleado -->
            <div class="row">
                <div class="form-group">
                    <label for="employee">Employee</label>
                    <select name="employee" id="employee" required>
                        <option value="" disabled selected>Select employee</option>
                        <?php while ($employee = mysqli_fetch_assoc($employees)): ?>
                            <option value="<?php echo $employee['num']; ?>">
                                <?php echo $employee['firstName']; ?>
                            </option>
                        <?php endwhile; ?>
                    </select>
                </div>

                <!-- Selección de material -->
                <div class="form-group">
                    <label for="rawMaterial">Raw Material</label>
                    <select name="rawMaterial" id="rawMaterial" required>
                        <option value="" disabled selected>Select raw material</option>
                        <?php while ($material = mysqli_fetch_assoc($materials)): ?>
                            <option value="<?php echo $material['code']; ?>">
                                <?php echo $material['name']; ?>
                            </option>
                        <?php endwhile; ?>
                    </select>
                </div>
            </div>

            <!-- Botón de envío -->
            <div class="button-container">
                <button type="submit" class="button">ADD ORDER</button>
            </div>
        </form>

        <!-- Mensaje dinámico -->
        <div id="message"></div>
    </div>
</section>
</body>
</html>
