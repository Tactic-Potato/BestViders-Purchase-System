<?php
include "includes/config/conn.php";
$conn = connect(); 

$query_employee = "select num, firstName from employee";
$employees = mysqli_query($conn, $query_employee);


$query_rawMaterial = "select code, name from RAW_MATERIAL";
$materials = mysqli_query($conn, $query_rawMaterial);
?>


<link rel="stylesheet" href="incldues/css/forms.css">
<nav id="Return"><a href="index.php"> Return </a></nav>
<h2>CREATE AN ORDER</h2>
<section id="formCont">
    <div id="formCard">
        <legend>Fill all fields</legend>

        <label>Description </label>
        <input type="textarea" name="descrp" id="descrp" required>
        
        <select name="employee" id="employee" >
                            <?php while($employee = mysqli_fetch_assoc($employees)): ?>
                                <option value="<?php echo $employee['code']; ?>"><?php echo $employee['name']; ?></option>
                            <?php endwhile; ?>
        </select>
    
        <select name="rawMaterial" id="rawMaterial" >
                            <?php while($request = mysqli_fetch_assoc($resquests)): ?>
                                <option value="<?php echo $rawMaterial['code']; ?>"><?php echo $rawMaterial['name']; ?></option>
                            <?php endwhile; ?>
        </select>


        <div>
            <button type="submit" class="button"> CREATE </button>
        </div>
    </div>
</section>