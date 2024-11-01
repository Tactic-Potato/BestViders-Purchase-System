<?php  include "includes/header.php";?>
<div id="infMaterials">
    <center>
        <table>
            <tr>
                <th>Code</th>
                <th>Price</th>
                <th>Name</th>
                <th>Description</th>
                <th>Weight</th>
                <th>Stock</th>
                <th>Request</th>
                <th>Category</th>
            </tr>
            <?php 
                include "includes/config/conn.php";
                $db=connect();
                $query = mysqli_query($db,  "SELECT * FROM RAW_MATERIAL");
                while ($result = mysqli_fetch_array($query)){ ?>
                    <tr>
                        <td><?=$result['code']?></td>
                        <td><?=$result['price']?></td>
                        <td><?=$result['name']?></td>
                        <td><?=$result['descrp']?></td>
                        <td><?=$result['weight']?></td>
                        <td><?=$result['stock']?></td>
                        <td><?=$result['request']?></td>
                        <td><?=$result['category']?></td>
                    </tr>
                <?php } mysqli_close($db); ?>
        </table>
    </center>
</div>
<?php include "includes/footer.php"?>