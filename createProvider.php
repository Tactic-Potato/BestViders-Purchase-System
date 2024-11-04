<?php
include "includes/config/conn.php"
$conn = conn(); 

$result = $conn->query("select max(num) as last_id from provider");
$row = $result->fetch_assoc();
$last_id = $row['last_id'] + 1;
?>

<link rel="stylesheet" href="incldues/css/forms.css">
<nav id="Return"><a href="index.php"> Return </a></nav>
<h2>ADD PROVIDER</h2>
<section id="formCont">
    <div id="formCard">
        <legend>Fill all fields</legend>
        <label>Provider Number</label>
        <input type="number" name="num" id="num" value="<?php echo $last_id;?>" required readonly>

        <label>Fiscal Name</label>
        <input type="text" name="fiscalName" id="fiscalName" required>
        
        <label>Phone Number</label>
        <input type="text" name="numTel" id="numTel" required>
    
        <label>Email</label>
        <input type="email" name="email" id="email" required>

        <div>
            <button type="submit" class="button"> ADD </button>
        </div>
    </div>
</section>