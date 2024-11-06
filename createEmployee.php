<?php
include "includes/config/conn.php";
$conn = conn(); 

$result = $conn->query("select max(num) as last_id from provider");
$row = $result->fetch_assoc();
$last_id = $row['last_id'] + 1;

$manager = "SELECT num, firstName FROM employee;";
$mangers = mysqli_query($db, $query_charge);

$charge = "SELECT code, name FROM charge;";
$charges = mysqli_query($db, $query_charge);

$area = "SELECT code, name FROM area;";
$areas = mysqli_query($db, $query_charge);
?>

<link rel="stylesheet" href="incldues/css/forms.css">
<nav id="Return"><a href="index.php"> Return </a></nav>
<h2>ADD EMPLOYEE</h2>
<section id="formCont">
    <div id="formCard">
        <legend>Fill all fields</legend>
        <label>Employee Number</label>
        <input type="number" name="num" id="num" value="<?php echo $last_id;?>" required readonly>

        <label>First Name</label>
        <input type="text" name="firstName" id="firstName" required>
        
        <label>Last Name</label>
        <input type="text" name="lastName" id="lastName" required>

        <label>Second Last Name</label>
        <input type="text" name="surName" id="surName" required>

        <label>Phone Number</label>
        <input type="tel" name="numTel" id="numTel" required>
    
        <label>Email</label>
        <input type="email" name="email" id="email" required>
        
        <select name="charge" id="charge" >
                        <?php while($charge = mysqli_fetch_assoc($charges)): ?>
                            <option value="<?php echo $charge['code']; ?>"><?php echo $charge['name']; ?></option>
                        <?php endwhile; ?>
        </select>

        <select name="charge" id="charge" >
                        <?php while($charge = mysqli_fetch_assoc($charges)): ?>
                            <option value="<?php echo $charge['code']; ?>"><?php echo $charge['name']; ?></option>
                        <?php endwhile; ?>
        </select>
        
        <select name="area" id="area" >
                        <?php while($area = mysqli_fetch_assoc($areas)): ?>
                            <option value="<?php echo $charge['code']; ?>"><?php echo $charge['name']; ?></option>
                        <?php endwhile; ?>
        </select>
        <div>
            <button type="submit" class="button"> ADD </button>
        </div>
    </div>
</section>