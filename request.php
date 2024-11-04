<?php  include "includes/header.php";?>
<div id="infRequest">
        <table>
            <tr>
                <th>Number</th>
                <th>Status</th>
                <th>Subtotal</th>
                <th>Date</th>
                <th>Check by Employee</th>
                <th>Provider</th>
            </tr>
            <?php 
                include "includes/config/conn.php";
                $db=connect();
                $query = mysqli_query($db,  "SELECT * FROM REQUEST");
                while ($result = mysqli_fetch_array($query)){ ?>
                    <tr>
                        <td><?=$result['num']?></td>
                        <td><?=$result['status']?></td>
                        <td><?=$result['subtotal']?></td>
                        <td><?=$result['requestDate']?></td>
                        <td><?=$result['employee']?></td>
                        <td><?=$result['provider']?></td>
                    </tr>
                <?php } mysqli_close($db); ?>
        </table>
</div>
<?php include "includes/footer.php"?>