
<link rel="stylesheet" href = "includes/css/login.css">

<div>
    <img class = "logo" src="includes/images/logotemp.png"/>
</div>
<section id="login-cont">
    <div id="login-card">
        <h2 id="h2">BESTVIDERS</h2>
            <div id = "imglogin"> 
            <img class = "loginimg" src="includes/images/xd.jpeg" alt="image doesn't exist"/>
            </div>
            <form  method="POST" action="loginProcess.php">
                <div id="formLogin">
                        <div id="columns">
                            <label id="textForm" for="username">Username </label>
             
                            <input type = "text" id="username" name=username placeholder="Write your username here" required>
                        </div>
                        <div id="columns">
                            <label id="textForm" for="password">Password </label>
                    
                            <input type="password" id="password" name="password" placeholder="Write your password here" required >
                        </div>
                </div>   
                    <div id = "divbtn"> 
                        <button id = "btnlog">Log in</button>
                    </div>
            </form> 
</div>
</section>