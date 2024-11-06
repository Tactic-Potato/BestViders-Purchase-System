<?php
include "includes/changecss.php";
require 'includes/config/conn.php';
session_start();
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $db = connect();
    $newPassword = $_POST['newPassword'];
    $confirmPassword = $_POST['confirmPassword'];
    $num = $_SESSION['num'];
    if ($newPassword === $confirmPassword) {
        $query = "UPDATE USER SET password = '$newPassword' WHERE num = '$num'";
        $result = mysqli_query($db, $query);
        if ($result) {
            $query = "SELECT area FROM EMPLOYEE WHERE num = '$num'";
            $areaResult = mysqli_query($db, $query);
            $user = mysqli_fetch_assoc($areaResult);
            switch ($user['area']) {
                case 'A001':
                    header("Location: rhindex.php");
                    break;
                case 'A002':
                    header("Location: purchasingindex.php");
                    break;
                case 'A003':
                    header("Location: supervisorindex.php");
                    break;
                case 'A004':
                    header("Location: storeindex.php");
                    break;
            }
            exit();
        } else {
            $error = "There was an error changing the password. Please try again.";
        }
    } else {
        $error = "Passwords do not match.";
    }
    mysqli_close($db);
}
?>
<section id="login-cont">
    <div id="login-card">
        <h2 id="logo-text">BESTVIDERS</h2>
        <div id="imglogin">
            <img class="loginimg" src="includes/images/logo.jpeg" alt="User icon"/>
        </div>

        <?php if (isset($error)) : ?>
            <p class="error-message"><?= $error ?></p>
        <?php endif; ?>

        <form method="POST" action="">
            <div id="formLogin">
                <div class="input-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" placeholder="Enter your new password" required>
                </div>
                <div class="input-group">
                    <label for="confirmPassword">Confirm Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Confirm your new password" required>
                </div>
            </div>   
            <div id="divbtn"> 
                <button id="btnlog" type="submit">Change Password</button>
            </div>
        </form> 
    </div>
</section>
