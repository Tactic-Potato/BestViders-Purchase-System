<?php
require 'includes/config/conn.php';
session_start();

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $db = connect();
    $email = $_POST['email'];
    $password = $_POST['password'];
    
    $query = "
        SELECT E.num, E.firstName, E.lastName, E.area, U.password 
        FROM employee AS E
        JOIN user AS U ON E.num = U.num
        WHERE E.email = '$email' AND U.password = '$password'
    ";

    $result = mysqli_query($db, $query);

    if (mysqli_num_rows($result) === 1) {
        $user = mysqli_fetch_assoc($result);
        $_SESSION['user_name'] = $user['firstName'] . ' ' . $user['lastName'];
        $_SESSION['num'] = $user['num'];
        $_SESSION['role'] = $user['area'];  // Guardar el rol en la sesión
        
        if ($password === "1234567890") {
            header("Location: changepassword.php");
            exit();
        }

        // Redirigir a un solo archivo index.php
        header("Location: index.php");
        exit();
    } else {
        $error = "Incorrect email or password.";
    }
    mysqli_close($db);
}
?>

<section id="login-cont">
    <link rel="stylesheet" href="includes/css/login.css">
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
