<?php
include "includes/config/conn.php";
$conn = connect(); 

$result = $conn->query("select max(num) as last_id from PROVIDER");
$row = $result->fetch_assoc();
$last_id = $row['last_id'] + 1;

$query_manager = "SELECT num, firstName FROM EMPLOYEE where manager IS NULL;";
$managers = mysqli_query($conn, $query_manager);

$query_charge = "SELECT code, name FROM CHARGE;";
$charges = mysqli_query($conn, $query_charge);

$query_area = "SELECT code, name FROM AREA;";
$areas = mysqli_query($conn, $query_area);
?>

<link rel="stylesheet" href="incldues/css/forms.css">
<nav id="Return"><a href="index.php"> Return </a></nav>
<h2>ADD EMPLOYEE</h2>
<section id="formCont">
    <div id="formCard">
        <form action="employeeProcess.php" method="POST">
            <legend>Fill all fields</legend>
            <label>Employee Number</label>
            <input type="number" name="num" id="num" value="<?php echo $last_id;?>" required >

            <label>First Name</label>
            <input type="text" name="firstName" id="firstName" required>
            
            <label>Last Name</label>
            <input type="text" name="lastName" id="lastName" required>

            <label>Second Last Name</label>
            <input type="text" name="surname" id="surname" required>

            <label>Phone Number</label>
            <input type="tel" name="numTel" id="numTel" required>
        
            <label>Email</label>
            <input type="email" name="email" id="email" required>
            
            <select name="manager" id="manager" >
                            <option value="">Make manager</option>
                            <?php while($manager = mysqli_fetch_assoc($managers)): ?>
                                
                                <option value="<?php echo $manager['num']; ?>"><?php echo $manager['num'] . " "; ?><?php echo $manager['firstName']; ?></option>
                            <?php endwhile; ?>
            </select>
            
            <select name="charge" id="charge" >
                            <?php while($charge = mysqli_fetch_assoc($charges)): ?>
                                <option value="<?php echo $charge['code']; ?>"><?php echo $charge['name']; ?></option>
                            <?php endwhile; ?>
            </select>
            
            <select name="area" id="area" >
                            <?php while($area = mysqli_fetch_assoc($areas)): ?>
                                <option value="<?php echo $area['code']; ?>"><?php echo $area['name']; ?></option>
                            <?php endwhile; ?>
            </select>
            <div>
                <button type="submit" class="button"> ADD </button>
            </div>
        </form>
    </div>
</section>