<?php
include "includes/config/conn.php";
$conn = connect(); 


?>

<link rel="stylesheet" href="incldues/css/forms.css">
<nav id="Return"><a href="index.php"> Return </a></nav>
<h2>CREATE AN ORDER</h2>
<section id="formCont">
    <div id="formCard">
        <legend>Fill all fields</legend>

        <label>Description </label>
        <input type="textarea" name="descrp" id="descrp" required>
        
        <label>Employee number</label>
        <input type="number" name="employee" id="employee" required>
    
        <label>Request</label>
        <input type="number" name="request" id="request" required>

        <label>Code  of the raw material</label>
        <input type="text" name="rawMaterial" id="rawMaterial" required>

        <div>
            <button type="submit" class="button"> CREATE </button>
        </div>
    </div>
</section>