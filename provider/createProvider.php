<?php
require '../includes/config/conn.php';

$db = connect();

$query_category = "SELECT code, name FROM category";
$categorys = mysqli_query($db, $query_category);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Escapamos las variables para evitar inyecciones SQL
    $fiscalName = mysqli_real_escape_string($db, $_POST['fiscal_name']);
    $email = mysqli_real_escape_string($db, $_POST['email']);
    $category_code = mysqli_real_escape_string($db, $_POST['category_code']);

    // Insertar nuevo proveedor en la tabla PROVIDER
    $insert_query = "INSERT INTO provider (fiscal_name, email, category_code) VALUES ('$fiscalName', '$email', '$category_code')";

    if (mysqli_query($db, $insert_query)) {
        echo "<script>
                alert('Proveedor registrado exitosamente');
                if (confirm('¿Deseas registrar otro proveedor?')) {
                    document.getElementById('providerForm').reset();
                } else {
                    window.location.href = 'rhindex.php';
                }
            </script>";
    } else {
        echo "<script>
                alert('Error: " . mysqli_error($db) . "');
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
                    <label>Category</label>
                    <select name="category_code" id="category_code" required>
                        <option value="" disabled selected>Select Category</option>
                        <?php while($category = mysqli_fetch_assoc($categorys)): ?>
                            <option value="<?php echo $category['code']; ?>">
                                <?php echo $category['name']; ?>
                            </option>
                        <?php endwhile; ?>
                    </select>
                </div>

            <div class="button-container">
                <button type="submit" class="button">ADD PROVIDER</button>
            </div>
        </form>
    </div>
</section>
