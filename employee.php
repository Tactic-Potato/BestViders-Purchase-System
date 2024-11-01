<?php  include "includes/header.php";?>
<div id="infEmployee">
    <center>
        <table>
            <tr>
                <th>Number</th>
                <th>Name</th>
                <th>Status</th>
                <th>Telephone Number</th>
                <th>Email</th>
                <th>Manager</th>
                <th>Charge</th>
                <th>area</th>
            </tr>
            <?php 
                include "includes/config/conn.php";
                $db=connect();
                $query = mysqli_query($db,  "SELECT * FROM EMPLOYEE");
                while ($result = mysqli_fetch_array($query)){ ?>
                    <tr>
                        <td><?=$result['num']?></td>
                        <td><?=$result['firstName']?> <?=$result['lastName']?> <?=$result['surname']?></td>
                        <td><?=$result['status']?></td>
                        <td><?=$result['numTel']?></td>
                        <td><?=$result['email']?></td>
                        <td><?=$result['manager']?></td>
                        <td><?=$result['charge']?></td>
                        <td><?=$result['area']?></td>
                    </tr>
                    <!-- COMMIT -->
                <?php } mysqli_close($db); ?>
        </table>
    </center>
</div>
<?php include "includes/footer.php"?>