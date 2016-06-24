<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <title>Login</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
  <style>
  .col-md-offset{
    margin-left:33.33333%;
  }
  .login-panel{
    margin-top:15%;
  }
  .alert-panel{
    margin-top:25%;
  }
  .mypanel{
    margin-top:30%;
  }
  .test{
    visibility: hidden;
  }
  </style>
  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
  <script>
  		$(document).ready(function() {
  		$("#loginButton").click(function() {
  			var username = $("#username").val();
  			var password = $("#password").val();
  			$.ajax({
  				type: 'POST',
  				data: {
  					username: username,
  					password: password
  				},
  				dataType: 'json',
  				url: '/CMS/service/login',
  				success: function(output){
  					if(output == true)
  					{
  						window.location = "dashboard.jsp";
  					}
  					else
  					{
  						alert("Username and password are not matching");
  						$("#username").val('');
  						$("#password").val('');
  						//window.location = "login.jsp";
  					}
  					
  				},
  				error: function(error){
  				}
  				
  			});
  		});
  	});
  </script>
</head>
<body>

<nav class="navbar navbar-default">
  <div class="container-fluid">
    <div class="navbar-header">
      <a class="navbar-brand" style="margin-left:500px" href="#">College Management System</a>
    </div>
    <div>
      
    </div>
  </div>
</nav>
  
<div class="container">
  <div class="row">
      <div class="col-md-4 col-md-offset-4">
        <div class="alert-panel" id="mydiv">
				
        </div>
        <div class="login-panel panel panel-default">
          <div class="panel-heading"><h3 class="panel-title">Login</h3></div>
          <div class="panel-body">
            <form   role="form" id="loginForm" method="POST" action="/CMS/Login" >
              <div   style="margin-bottom: 25px" class="form-group ">
                
                <!--label for="username">Username:</label-->
                <input type="text" class="form-control" id="username" name="username" placeholder="Username" autocomplete="off" > 
              </div>
              <div  style="margin-bottom: 25px" class="form-group">
                <!--label for="password">Password:</label-->
                 
                <input type="password" class="form-control" id="password" name="password" placeholder="Password" autocomplete="off" > 
              </div>
              
              
              <button type="button" class="btn btn-success   btn-block" id="loginButton"><span class="glyphicon glyphicon-log-in" > Login</span></button>
            </form>
          </div>
          <div class="panel-footer text-right">
            <a href="forgotPassword.html" >Forgot Password<span class="glyphicon glyphicon-chevron-right"></span></a>
          </div>
        </div>
      
 
      </div>
      </div>
</div>
<div class="footer" style="margin-top:12%">
      <div class="container">
        <p class="text-muted">Copyright 2015</p>
      </div>
    </div>
</body>
</html>
