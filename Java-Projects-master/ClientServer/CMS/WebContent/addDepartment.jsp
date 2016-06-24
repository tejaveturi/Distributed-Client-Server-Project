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
   

    <title>Department</title>

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
    		var departmentsList = $("#departmentsList").dataTable({
    			 "oLanguage": {
                          "sEmptyTable":     "<img src='loading1.gif'>",
                      }
    		});
    		
    		$.ajax({
    			type: 'GET',
    			url: '/CMS/service/getDepartments',
    			dataType: 'json',
    			success: function(output){
    				departmentsList.fnClearTable();
    				var degrees = "";
    				$.each(output, function(inx,val) {
    					if(val.degrees == "")
    						degrees = "No degrees";
    					else
    						degrees = val.degrees;
    					var data = [
    						val.dept_id,
    						val.dept_name,
    						degrees
    					];
    					departmentsList.fnAddData(data);
    				});
    			},
    			error: function(error) {
    				console.log(error);
    			}	
    		});
    		$("#create").click(function() {
    			departmentName = $("#dept").val();
    			$('input:checkbox[name=degree]').each(function() {
	    			if($(this).is(":checked"))
	    			{
	    				degree_data += $(this).val() + ",";
	    			}
	    		});
	    		if(departmentName == "" && degree_data == "")
	    		{
	    			alert("Please provide input to all  the fields");
	    		}
	    		else
	    		{
	    			$.ajax({
						data: {
							department: departmentName,
							degrees: degree_data
						},
						url: '/CMS/service/createDepartments',
						type: 'POST',
						//contentType: 'application/json',
						complete: function() {
							alert("Department Created Successfully");
							window.location.reload(true);
						}
					});
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
          <li class="active"><a href="dashboard.jsp" class="glyphicon glyphicon-dashboard"> Dashboard <span class="sr-only">(current)</span></a></li>
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
            <li><a href="createCourse.jsp" class="glyphicon glyphicon-blackboard"> Courses</a></li>
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
          <h1 class="page-header">Departments</h1>
          <div class="panel panel-success">
          	<div class="panel-heading">Departments List</div>
          	<div class="panel-body">
	          	<table class="table table-striped table-hover table-responsive table-bordered" id="departmentsList">
	          		<thead>
	          			<tr>
	          				<th>Dept Id</th>
	          				<th>Dept Name</th>
	          				<th>Degrees Offered</th>
	          			</tr>
	          		</thead>
	          	</table>
          	</div>
          </div>
          <hr/>
		<div class="panel panel-primary">
		  		<div class="panel-heading">Create Department</div>
		  		<div class="panel-body">
		  			<%
					//String status_msg=(String)request.getAttribute("status");  
					//if(status_msg!=null)
					//out.println("<p align=center><font color=red size=4px align=center>"+status_msg+"</font></p>");
					%>
		  			<form class="form-horizontal" role="form" method="POST" >
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="dept">Department Name:*</label>
					      <div class="col-sm-8">
					        <input type="text" class="form-control" id="dept" name="dept" placeholder="Department Name">
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="dept">Degrees Offered:*</label>
					      <div class="col-sm-8">
					      	<label class="checkbox-inline"><input type="checkbox" id="dgr" name="degree" value="M.S">M.S</label>
							<label class="checkbox-inline"><input type="checkbox" id="dgr" name="degree" value="B.S">B.S</label>
							<label class="checkbox-inline"><input type="checkbox" id="dgr" name="degree" value="Ph.d">Ph.d</label>
							<label class="checkbox-inline"><input type="checkbox" id="dgr" name="degree" value="M.B.A">M.B.A</label>
					        <!--  input type="text" class="form-control" id="dept" name="degrees" placeholder="Degrees"-->
					      </div>
					    </div>
					    
					    <div class="form-group">        
					      <div class="col-sm-offset-2 col-sm-10">
					        <button type="submit" id="create" class="btn btn-danger">Create</button>
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
  