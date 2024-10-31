<?php 
    function connect(): mysqli{
        $db = mysqli_connect("localhost", "root", "", "bestviders");
        if (!$db) {
            die("Connection failed: " . mysqli_connect_error());
        } else {
            echo "Connected successfully!";
        }
        return $db;
    }
?>