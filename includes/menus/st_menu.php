<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Store</title>
</head>
<body>
    <section id="header"> 
        <h1>BestViders</h1> 
        <div id="menu">
        <ul class="navbar-nav">
        <!-- Dropdown Orders -->
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="ordersDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Orders
            </a>
            <ul class="dropdown-menu" aria-labelledby="ordersDropdown">
                <li><a class="dropdown-item" href="order/WOrder_aprov.php">Check Orders</a></li>
            </ul>
        </li>
        <!-- Dropdown Providers -->
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="providersDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Providers
            </a>
            <ul class="dropdown-menu" aria-labelledby="providersDropdown">
                <li><a class="dropdown-item" href="provider/WProvider.php">Check All Providers</a></li>
                <li><a class="dropdown-item" href="provider/WProviderRM.php">Check Removed Providers</a></li>
                <li><a class="dropdown-item" href="provider/WAssocProvider.php">Check Associted Providers</a></li>
            </ul>
        </li>
        
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="requestsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Resquest
            </a>
            <ul class="dropdown-menu" aria-labelledby="requestsDropdown">
                <li><a class="dropdown-item" href="request/WRequest.php">Check Requests</a></li>
            </ul>
        </li>
        <!-- Logout Button -->
        <li class="nav-item">
            <a class="nav-link btn btn-outline-danger ms-3" href="logout.php" role="button">
                Logout
            </a>
        </li>
        
    </ul>
    </div>
    </section>



    <!-- 
       <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="requestsDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Troubles
            </a>
            <ul class="dropdown-menu" aria-labelledby="requestsDropdown">
                <li><a class="dropdown-item" href="request/WRequest.php">Check Requests</a></li>
            </ul>
        </li>
    -->