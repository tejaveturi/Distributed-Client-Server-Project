<%@page import="java.sql.ResultSet"%>
<%@page import="com.cms.functions"%>
<%@ page language="java"%>
<%
	String username = (String) session.getAttribute("username");
	String roleId = (String) session.getAttribute("roleId");
	if(roleId != null && username != null)
	{
	
 %>    

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
    <meta name="description" content="">
    <meta name="author" content="">
   

    <title>User</title>

    <!-- Bootstrap core CSS -->
    <link href="libraries/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="libraries/dashboard.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.10.10/css/dataTables.bootstrap.min.css" rel="stylesheet">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script type="text/javascript" src="libraries/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/dataTables.bootstrap.min.js"></script>
    <script type="text/javascript">
    	$(document).ready(function() {
    	//$("#myModal").modal('show');
    		var degree_data = "";
    		var departmentName = "";
    		
    		var year = new Date().getFullYear();
    		var newYear = year;
    		$("#year").append("<option value'" + year + "'>" + year + "</option>");
    		for(var index = 1 ; index <= 10; index++)
    		{
    			newYear = newYear + 1;
    			$("#year").append("<option value'" + newYear + "'>" + newYear + "</option>");
    		}
    		$.ajax({
    			type: 'POST',
    			dataType: 'json',
    			url: '/CMS/service/getUserType',
    			success: function(output) {
    				$.each(output, function(inx,val) {
    					$("#role_id").append("<option value='" + val.roleId + "'>" + val.rolename.toUpperCase() + "</option>");
    				});
    			},
    			error: function(jqXHR, status, error) {
    				console.log("error");
    			}
    		});
    		
    		$.ajax({
    			type: 'GET',
    			url: '/CMS/service/getDepartments',
    			dataType: 'json',
    			success: function(output){
    				
    				//$("#dept").html('');
    				$.each(output, function(inx,val) {
    					$("#dept_id").append("<option value='" + val.dept_id + "'>" + val.dept_name + "</option" );
    					
    				});
    			},
    			error: function(error) {
    				console.log(error);
    			}
    		});
    		$("#create").click(function() {
    			var roleId = <%=roleId%>;
    			var email_id = $("#email").val();
    			var password = $("#password").val();
    			var rpwd = $("#rpwd").val();
    			var role_id = $("#role_id").val();
    			var dept_id = $("#dept_id").val();
    			var fname = $("#fname").val();
    			var lname = $("#lname").val();
    			var address = $("#address").val(); 
    			var aemail_id = $("#aemail").val(); 
    			var semester = $("#semester").val();
    			var year = $("#year").val(); 
    			var DOB = $("#dob").val();
    			var phone = $("#phone").val(); 
    			var gender = $("#gender").val();
    			var joined_on = semester + "-" + year;
    			console.log("roleId=" + roleId + "&email_id=" + email_id + "&password=" + password + "&role_id=" +  role_id +  "&dept_id=" + dept_id + "&fname=" + fname + "&lname=" + lname + "&address=" + address + "&aemail_id=" + aemail_id  + "&joined_on=" + joined_on + "&DOB=" + DOB +  "&phone=" + phone + "&gender=" + gender);
    			if(email_id == "" || password == "" || rpwd == ""  || role_id ==  "" || dept_id == "" || fname == "" || lname == "" || semester == "" || year == ""  || gender == "" || phone == "" ||  dob == "" )  
    			{
    				alert("Please make sure all fields are entered");
    			}
    			else
    			{
    				if(password != rpwd)
    				{
    					alert("Passwords not matching");
    				}
    				else
    				{
    					$.ajax({
    						type: 'POST',
    						url: '/CMS/service/checkUser',
    						data: {
    							emailId: email_id
    						},
    						success: function(output) {
    							console.log(output);
    							if(output == true)
    							{
    								$("#textbody").html('User Already exists');
    								$("#myModal").modal('show');
    							}
    							else
    							{
    								var params = "roleId=" + roleId + "&email_id=" + email_id + "&password=" + password + "&role_id=" +  role_id +  "&dept_id=" + dept_id + "&fname=" + fname + "&lname=" + lname + "&address=" + address + "&aemail_id=" + aemail_id  + "&joined_on=" + joined_on + "&DOB=" + DOB +  "&phone=" + phone + "&gender=" + gender
    								$.ajax({
    									type: 'POST',
    									url: '/CMS/service/addUser',
    									data: params,
    									success: function(output){
    										$("#textbody").html(output);
    										$("#myModal").modal('show');
    										$("#email").val('');
							    			$("#password").val('');
							    			$("#rpwd").val('');
							    			$("#role_id").val('');
							    			$("#dept_id").val('');
							    			$("#fname").val('');
							    			$("#lname").val('');
							    			$("#address").val(''); 
							    			$("#aemail").val(''); 
							    			$("#semester").val('');
							    			$("#year").val(''); 
							    			$("#dob").val('');
							    			$("#phone").val(''); 
							    			$("#gender").val('');
    									},
    									error: function(jqXHR, status, error){
    										console.log("error");
    									}
    								});
    							}
    						},
    						error: function(jqXHR, status, error) {
    							console.log("error");
    						}
    					});
    				}
    			}
    		});
    		
    	});
    </script>
    
  </head>

  <body>

    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container-fluid">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar1" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="#">CMS</a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            
          </ul>
          <!--  form class="navbar-form navbar-right">
            <input type="text" class="form-control" placeholder="Search...">
          </form-->
        </div>
      </div>
    </nav>

    <div class="container-fluid">
      <div class="row">
        <div class="col-sm-3 col-md-2 sidebar" id="navbar1">
          <ul class="nav nav-sidebar navbar-inverse" >
            <li class="active"><li class="active"><a href="dashboard.jsp" class="glyphicon glyphicon-dashboard"> Dashboard <span class="sr-only">(current)</span></a></li>
            <li><a href="search.jsp" class="glyphicon glyphicon-search"> Search</a></li>
             <%
             if(Integer.parseInt(roleId) == 1027)
             {
              %>
             <li><a href="mycart.jsp" class="glyphicon glyphicon-shopping-cart"> Cart</a></li>
            <li><a href="drop.jsp" class="glyphicon glyphicon-minus"> Drop</a></li>
            <%
             }
             
            else if(Integer.parseInt(roleId) == 1024)
             {
              %>
            <li><a href="courses.jsp" class="glyphicon glyphicon-cog"> Semester</a></li>
            <li><a href="createCourses.jsp" class="glyphicon glyphicon-blackboard"> Courses</a></li>
            <li><a href="addDepartment.jsp" class="glyphicon glyphicon-folder-close"> Department</a></li>
            <li><a href="newUser.jsp" class="glyphicon glyphicon-user"> User</a></li>
             <%
             }
             else
             {
             	response.sendRedirect("logout.jsp");
             }
              %>
            <li><a href="logout.jsp" class="glyphicon glyphicon-log-out"> Logout</a></li>
          </ul>
          
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
          <h1 class="page-header">Users</h1>
          
          
		<div class="panel panel-primary">
		  		<div class="panel-heading">Create User</div>
		  		<div class="panel-body">
		  		
		  			<form class="form-horizontal" role="form" method="POST" >
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="email">Email:*</label>
					      <div class="col-sm-8">
					        <input type="email" class="form-control" id="email" name="email" placeholder="Email Id">
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="pwd">Password:*</label>
					      <div class="col-sm-8">
					        <input type="password" class="form-control" id="password" name="password" placeholder="Password">
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="rpwd">Re Password:*</label>
					      <div class="col-sm-8">
					        <input type="password" class="form-control" id="rpwd" name="rpwd" placeholder="Re-Enter Password">
					      </div>
					    </div>
					    <div class="form-group">
						  <label class="control-label col-sm-2" for="role">Role:*</label>
						  <div class="col-sm-8">
							  <select class="form-control" id="role_id">
							    <option value="">Select a role</option>
							    
							  </select>
						  </div>
						</div>
						<div class="form-group">
						  <label class="control-label col-sm-2" for="dept">Department:*</label>
						  <div class="col-sm-8">
							  <select class="form-control" id="dept_id">
							    <option value="">Select a department</option>
							    
							  </select>
						  </div>
						</div>
						<div class="form-group">
					      <label class="control-label col-sm-2" for="fn">First Name:*</label>
					      <div class="col-sm-8">
					        <input type="text" class="form-control" id="fname" name="fname" placeholder="First Name">
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="ln">Last Name:*</label>
					      <div class="col-sm-8">
					        <input type="text" class="form-control" id="lname" name="lname" placeholder="Last Name">
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="gen">Gender:*</label>
					      <div class="col-sm-8">
					      	<label class="radio-inline"><input type="radio" id="gender" name="gender" value="M">Male</label>
							<label class="radio-inline"><input type="radio" id="gender" name="gender" value="F">Female</label>
					      </div>
					    </div>
					    <div class="form-group">
						  <label  class="control-label col-sm-2" for="address">Address:*</label>
						  <div class="col-sm-8">
						  	<textarea class="form-control" rows="5" id="address" placeholder="Address"></textarea>
						  </div>
						</div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="aemail">AlternateEmail:</label>
					      <div class="col-sm-8">
					        <input type="email" class="form-control" id="aemail" name="aemail" placeholder="AlternateEmail Id">
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="date">DOB:*</label>
					      <div class="col-sm-8">
					        <input type="date" class="form-control" id="dob" name="dob" placeholder="DOB">
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="ph">Phone:*</label>
					      <div class="col-sm-8">
					        <input type="text" class="form-control" id="phone" name="phone" placeholder="Phone Number">
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="sem">Semester:*</label>
					      <div class="col-sm-8">
					        <select class="form-control" id="semester">
							    <option value="">Select a semester</option>
							    <option value="Fall">Fall</option>
							    <option value="Summer">Summer</option>
							    <option value="Spring">Spring</option>
							  </select>
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="year">Year:*</label>
					      <div class="col-sm-8">
					        <select class="form-control" id="year">
							    <option value="">Select a year</option>
							   
							</select>
					      </div>
					    </div>
					    
					    
					    <div class="form-group">        
					      <div class="col-sm-offset-2 col-sm-10">
					        <button type="button" id="create" class="btn btn-danger">Create</button>
					      </div>
					    </div>
					  </form>
		  		</div>
		  </div>		
		  
		  <div class="modal fade" id="myModal" role="dialog">
        		<div class="modal-dialog">
		            <div class="modal-content">
		              <div class="modal-header">
		                  <button type="button" class="close" data-dismiss="modal">&times;</button>
		                  <h4 class="modal-title">Message</h4>
		               </div>
		              <div class="modal-body">
		                  <p id="textbody">This is a small modal.</p>
		              </div>
		              <div class="modal-footer">
		                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
		              </div>
		          </div>
        		</div>
    	 </div> 

         
          
        </div>
      </div>
    </div>

   
    
    
  </body>
</html>


<%
}
else
{
	response.sendRedirect("login.jsp");
}
 %>
  