<?php
require 'includes/config/conn.php';
session_start();

// Check if the form has been submitted
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $db = connect();

    // Get form data
    $email = mysqli_real_escape_string($db, $_POST['email']);
    $password = mysqli_real_escape_string($db, $_POST['password']);

    // Query the database to validate the email and password
    $query = "
        SELECT E.num, E.firstName, E.lastName, E.area, U.password 
        FROM EMPLOYEE AS E
        JOIN USER AS U ON E.num = U.num
        WHERE E.email = '$email' AND U.password = '$password'
    ";

    $result = mysqli_query($db, $query);

    if (mysqli_num_rows($result) === 1) {
        // Valid email and password
        $user = mysqli_fetch_assoc($result);
        $_SESSION['user_name'] = $user['firstName'] . ' ' . $user['lastName'];
        $_SESSION['num'] = $user['num'];
        
        // Redirect based on the area of work
        switch ($user['area']) {
            case 'A001':
                header("Location: rhindex.php");
                break;
            case 'A002':
                header("Location: purchasingindex.php");
                break;
            case 'Supervisor':
                header("Location: supervisorindex.php");
                break;
            case 'Store':
                header("Location: storeindex.php");
                break;
            default:
                header("Location: error.php");
                break;
        }
        exit();
    } else {
        // Incorrect email or password
        $error = "Incorrect email or password.";
    }

    mysqli_close($db);
}
?>
<div>
    <link rel="stylesheet" href="includes/css/login.css">
    <img class="logo" src="includes/images/logotemp.png"/>
</div>
<section id="login-cont">
    <div id="login-card">
        <h2 id="h2">BESTVIDERS</h2>
        <div id="imglogin"> 
            <img class="loginimg" src="includes/images/xd.jpeg" alt="Image not available"/>
        </div>
        <?php if (isset($error)) : ?>
            <p style="color: red;"><?= $error ?></p>
        <?php endif; ?>
        <form method="POST" action="">
            <div id="formLogin">
                <div id="columns">
                    <label id="textForm" for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email here" required>
                </div>
                <div id="columns">
                    <label id="textForm" for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password here" required>
                </div>
            </div>   
            <div id="divbtn"> 
                <button id="btnlog" type="submit">Log In</button>
            </div>
        </form> 
    </div>
</section>