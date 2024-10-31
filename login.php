<?php
    require "../../includes/config/conn.php";
    include "../../includes/css/style.css";
    
    
    $username = isset($_POST["username"]) ? $_POST["username"] : '';
    $password = isset($_POST["password"]) ? $_POST["password"] : ''; 

?>
<section>
    <h2>LOG IN</h2>
        <form method="POST" action="login.php">
            <div>
                <label for="username">Username</label>
                <input type = "text" id="username" name=username placeholder="write your username here" required>
            </div>
            <div>
                <label for="password">Password</label>
                <input type="password" id="password" name="password" minlength="10" required>
            </div>
            <div>
                <button>Log in</button>
            </div>
        </form>
</section>