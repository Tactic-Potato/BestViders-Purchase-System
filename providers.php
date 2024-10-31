<?php  include "includes/header.php";?>
<div id="infProviders">
    <table>
        <tr>
            <th>Provider Number</th>
            <th>Fiscal name</th>
            <th>Email</th>
            <th>Phone number</th>
        </tr>
        <?php 
            include "includes/config/conn.php";
            $db=connect();
            $query = mysqli_query($db,  "SELECT * FROM providers");
            while ($result = mysqli_fetch_array($query)){ ?>
                <tr>
                    <td><?=$result['num']?></td>
                    <td><?=$result['fiscalName']?></td>
                    <td><?=$result['email']?></td>
                    <td><?=$result['numTel']?></td>
                </tr>
            <?php } mysqli_close($db); ?>
    </table>
</div>
<?php include "includes/footer.php"?>