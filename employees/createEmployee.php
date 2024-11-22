<?php
require '../includes/config/conn.php';

$db = connect();
$manager_query = "SELECT num, firstName FROM employee WHERE charge = 'MNGR'"; // Filtrar solo managers potenciales
$managers = mysqli_query($db, $manager_query);

$charge_query = "SELECT code, name FROM charge";
$charges = mysqli_query($db, $charge_query);

$area_query = "SELECT code, name FROM area";
$areas = mysqli_query($db, $area_query); 

// Procesar el formulario
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $firstName = $_POST['firstName'];
    $lastName = $_POST['lastName'];
    $surName = $_POST['surName'];
    $numTel = $_POST['numTel'];
    $email = $_POST['email'];
    $manager = $_POST['manager'] ?? NULL; // Permitir nulo en el manager
    $charge = $_POST['charge'];
    $area = $_POST['area'];
    
    $insert_query = "INSERT INTO employee (firstName, lastName, surname, numTel, email, manager, charge, area)
                    VALUES ('$firstName', '$lastName', '$surName', '$numTel', '$email', NULLIF('$manager', ''), '$charge', '$area')";

    if (mysqli_query($db, $insert_query)) {
        echo "<script>
                alert('Registro exitoso');
                if (confirm('¿Deseas realizar otro registro?')) {
                    document.getElementById('employeeForm').reset();
                } else {
                    window.location.href = 'rhindex.php';
                }
            </script>";
    } else {
        echo "Error: " . mysqli_error($db);
    }
}
?>
<head>
    <link rel="stylesheet" href="../includes/css/Form.css">
    <title>Human Resources</title>
</head>
<body>
<nav id="Return"><a href="../index.php"> Return </a></nav>
<section id="formCont">
    <div id="formCard">
        <form id="employeeForm" method="POST">
            <h2>Employee Name</h2>
            <div class="row">
                <div class="form-group">
                    <label>Name</label>
                    <input type="text" name="firstName" id="firstName" placeholder="Enter first name" required>
                </div>
                <div class="form-group">
                    <label>Last Name</label>
                    <input type="text" name="lastName" id="lastName" placeholder="Enter last name" required>
                </div>
                <div class="form-group">
                    <label>Second Last Name</label>
                    <input type="text" name="surName" id="surName" placeholder="Enter second last name" required>
                </div>
            </div>

            <h2>Contact</h2>
            <div class="row">
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="tel" name="numTel" id="numTel" placeholder="Enter phone number" required>
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" id="email" placeholder="Enter email address" required>
                </div>
            </div>

            <h2>Work Information</h2>
            <div class="row">
                <div class="form-group">
                    <label>Manager</label>
                    <select name="manager" id="manager">
                        <option value="">Make Manager</option> <!-- Esta opción insertará un valor NULL en el campo 'manager' -->
                        <?php while($manager = mysqli_fetch_assoc($managers)): ?>
                            <option value="<?php echo $manager['num']; ?>">
                                <?php echo $manager['num'] . " " . $manager['firstName']; ?>
                            </option>
                        <?php endwhile; ?>
                    </select>
                </div>
                <div class="form-group">
                    <label>Charge</label>
                    <select name="charge" id="charge" required>
                        <option value="" disabled selected>Select charge</option>
                        <?php while($charge = mysqli_fetch_assoc($charges)): ?>
                            <option value="<?php echo $charge['code']; ?>"><?php echo $charge['name']; ?></option>
                        <?php endwhile; ?>
                    </select>
                </div>
                <div class="form-group">
                    <label>Area</label>
                    <select name="area" id="area" required>
                        <option value="" disabled selected>Select area</option>
                        <?php while($area = mysqli_fetch_assoc($areas)): ?>
                            <option value="<?php echo $area['code']; ?>"><?php echo $area['name']; ?></option>
                        <?php endwhile; ?>
                    </select>
                </div>
            </div>

            <div class="button-container">
                <button type="submit" class="button">ADD EMPLOYEE</button>
            </div>
        </form>
    </div>
</section>