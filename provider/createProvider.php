<?php
require '../includes/config/conn.php';

$db = connect();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Escapamos las variables para evitar inyecciones SQL
    $fiscalName = mysqli_real_escape_string($db, $_POST['fiscal_name']);
    $email = mysqli_real_escape_string($db, $_POST['email']);
    $numTel = mysqli_real_escape_string($db, $_POST['numTel']);
    
    // Insertar nuevo proveedor en la tabla PROVIDER
    $insert_query = "INSERT INTO provider (fiscal_name, email, numTel) VALUES ('$fiscalName', '$email', '$numTel')";
    
    if (mysqli_query($db, $insert_query)) {
        $providerId = mysqli_insert_id($db); // Obtener el ID del proveedor insertado
        
        // Verificar si se seleccionó un material
        if (isset($_POST['material']) && !empty($_POST['material'])) {
            // Limpiar el código del material y evitar espacios extra
            $materialCode = trim(mysqli_real_escape_string($db, $_POST['material']));
            
            // Consultar si el código del material existe
            $checkMaterialQuery = "SELECT COUNT(*) as count FROM raw_material WHERE code = '$materialCode'";
            $result = mysqli_query($db, $checkMaterialQuery);
            
            // Verificar si la consulta fue exitosa
            if ($result) {
                $row = mysqli_fetch_assoc($result);
                if ($row['count'] > 0) {
                    // El material existe, insertar en raw_provider
                    $materialInsertQuery = "INSERT INTO raw_provider (provider, material) VALUES ('$providerId', '$materialCode')";
                    if (mysqli_query($db, $materialInsertQuery)) {
                        echo "<script>
                                alert('Proveedor registrado exitosamente');
                                if (confirm('¿Deseas registrar otro proveedor?')) {
                                    document.getElementById('providerForm').reset();
                                } else {
                                    window.location.href = '../index.php';
                                }
                            </script>";
                    } else {
                        echo "<script>
                                alert('Error al registrar el material: " . mysqli_error($db) . "');
                                window.location.href = 'createProvider.php';
                            </script>";
                    }
                } else {
                    echo "<script>
                            alert('El material con código $materialCode no existe en la base de datos.');
                            window.location.href = 'createProvider.php';
                        </script>";
                }
            } else {
                echo "<script>
                        alert('Error al verificar el material con código $materialCode. " . mysqli_error($db) . "');
                        window.location.href = 'createProvider.php';
                    </script>";
            }
        } else {
            echo "<script>
                    alert('Por favor, selecciona un material.');
                    window.location.href = 'createProvider.php';
                </script>";
        }
    } else {
        echo "<script>
                alert('Error al registrar el proveedor: " . mysqli_error($db) . "');
                window.location.href = 'createProvider.php';
            </script>";
    }
}
?>


<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="../includes/css/form2.css">
    <title>Human Resources</title>
    <style>
        /* Estilo para la ventana modal */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.5);
        }
        .modal-content {
            background-color: #fff;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
<nav id="Return"><a href="../index.php"> Return </a></nav>
<section id="formCont">
    <div id="formCard">
    <form id="providerForm" method="POST">
    <h2>Provider Information</h2>

    <div class="form-group">
        <label>Fiscal Name</label>
        <input type="text" name="fiscal_name" id="fiscalName" placeholder="Enter fiscal name" required>
    </div>

    <div class="form-group">
        <label>Email</label>
        <input type="email" name="email" id="email" placeholder="Enter email address" required>
    </div>

    <div class="form-group">
        <label>Phone Number</label>
        <input type="tel" name="numTel" id="numTel" placeholder="Enter phone number" required>
    </div>

    <div class="form-group">
        <label>Material</label>
        <select name="material" id="material" required>
            <option value="">Select a material</option>
            <?php
            // Fetch materials from raw_material table
            $materials_query = "SELECT code, name FROM raw_material";
            $materials_result = mysqli_query($db, $materials_query);
            
            if ($materials_result) {
                while ($row = mysqli_fetch_assoc($materials_result)) {
                    echo "<option value='" . htmlspecialchars($row['code']) . "'>" . htmlspecialchars($row['name']) . "</option>";
                }
            } else {
                echo "<option disabled>No materials available</option>";
            }
            ?>
        </select>
    </div>

    <div class="button-container">
        <button type="submit" class="button">ADD PROVIDER</button>
    </div>
</form>

    </div>
</section>

<!-- Modal for material selection -->
<div id="materialModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h2>Select Materials</h2>
        <form id="materialForm">
            <?php
            if (mysqli_num_rows($materials_result) > 0) {
                while ($material = mysqli_fetch_assoc($materials_result)) {
                    echo '<div class="checkbox">
                            <label>
                                <input type="checkbox" name="materials[]" value="' . $material['code'] . '"> ' . $material['name'] . '
                            </label>
                          </div>';
                }
            } else {
                echo "<p>No materials found.</p>";
            }
            ?>
            <button type="button" id="submitMaterialSelection" class="button">Save Selection</button>
        </form>
    </div>
</div>

<script>
    // Open the modal when the button is clicked
    document.getElementById("openModalBtn").onclick = function() {
        document.getElementById("materialModal").style.display = "block";
    }

    // Close the modal when the close button is clicked
    document.getElementsByClassName("close")[0].onclick = function() {
        document.getElementById("materialModal").style.display = "none";
    }

    // Close the modal if the user clicks outside of the modal content
    window.onclick = function(event) {
        if (event.target == document.getElementById("materialModal")) {
            document.getElementById("materialModal").style.display = "none";
        }
    }

    // Handle material selection and save the selected materials
    document.getElementById("submitMaterialSelection").onclick = function() {
        var selectedMaterials = [];
        var checkboxes = document.querySelectorAll('input[name="materials[]"]:checked');
        checkboxes.forEach(function(checkbox) {
            selectedMaterials.push(checkbox.value);
        });
        
        // Set the selected materials in the hidden input field
        document.getElementById("selectedMaterials").value = selectedMaterials.join(',');

        // Close the modal
        document.getElementById("materialModal").style.display = "none";
    }
</script>

</body>
</html>


