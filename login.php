<?php
include "includes/loginh.php";
require 'includes/config/conn.php';
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $db = connect();
    $email = $_POST['email'];
    $password = $_POST['password'];
    
    $query = "
        SELECT E.num, E.firstName, E.lastName, E.area, U.password 
        FROM EMPLOYEE AS E
        JOIN USER AS U ON E.num = U.num
        WHERE E.email = '$email' AND U.password = '$password'
    ";

    $result = mysqli_query($db, $query);

    if (mysqli_num_rows($result) === 1) {
        $user = mysqli_fetch_assoc($result);
        $_SESSION['user_name'] = $user['firstName'] . ' ' . $user['lastName'];
        $_SESSION['num'] = $user['num'];
        
        if ($password === "1234567890") {
            header("Location: changepassword.php");
            exit();
        }
        switch ($user['area']) {
            case 'A001':
                header("Location: index.php");
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
        $error = "Incorrect email or password.";
    }
    mysqli_close($db);
}
?>

<section id="login-cont">
    <div id="login-card">
        <h2 id="h2">BESTVIDERS</h2>
        <div id="imglogin"> 
            <img class="loginimg" src="includes/images/logo.jpeg" alt="User icon"/>
        </div>
        <?php if (isset($error)) : ?>
            <p style="color: red;"><?= $error ?></p>
        <?php endif; ?>
        <form method="POST" action="">
            <div id="formLogin">
                <div id="columns">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>
                <div id="columns">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>
            </div>
            <div id="divbtn">
                <button id="btnlog" type="submit">Log In</button>
            </div>
        </form>
    </div>
</section>