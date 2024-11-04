<?php  include "includes/header.php";?>
<div id="infOrder">
        <table>
            <tr>
                <th>Code</th>
                <th>Description</th>
                <th>Status</th>
                <th>Employee</th>
                <th>Request</th>
                <th>Material</th>
            </tr>
            <?php 
                include "includes/config/conn.php";
                $db=connect();
                $query = mysqli_query($db,  "SELECT * FROM `ORDER`");
                while ($result = mysqli_fetch_array($query)){ ?>
                    <tr>
                        <td><?=$result['code']?></td>
                        <td><?=$result['descrp']?></td>
                        <td><?=$result['status']?></td>
                        <td><?=$result['employee']?></td>
                        <td><?=$result['request']?></td>
                        <td><?=$result['rawMaterial']?></td>
                    </tr>
                <?php } mysqli_close($db); ?>
        </table>
</div>
<?php include "includes/footer.php"?>