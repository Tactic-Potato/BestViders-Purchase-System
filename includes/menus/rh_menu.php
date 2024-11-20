<div class="collapse navbar-collapse justify-content-end" id="navbarNav">
    <ul class="navbar-nav">
        <!-- Dropdown Orders -->
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="ordersDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Orders
            </a>
            <ul class="dropdown-menu" aria-labelledby="ordersDropdown">
                <li><a class="dropdown-item" href="order/WOrder.php">Check Orders</a></li>
                <li><a class="dropdown-item" href="order/createOrder.php">Generate Order</a></li>
            </ul>
        </li>
        <!-- Dropdown Providers -->
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="providersDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Providers
            </a>
            <ul class="dropdown-menu" aria-labelledby="providersDropdown">
                <li><a class="dropdown-item" href="provider/WProvider.php">Check Providers</a></li>
                <li><a class="dropdown-item" href="provider/createProvider.php">Add Provider</a></li>
            </ul>
        </li>
        <!-- Dropdown Employees -->
        <li class="nav-item dropdown">
            <a class="nav-link dropdown-toggle" href="#" id="employeesDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Employees
            </a>
            <ul class="dropdown-menu" aria-labelledby="employeesDropdown">
                <li><a class="dropdown-item" href="employees/WEmployees.php">Check Employees</a></li>
                <li><a class="dropdown-item" href="employees/createEmployee.php">Add Employee</a></li>
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
