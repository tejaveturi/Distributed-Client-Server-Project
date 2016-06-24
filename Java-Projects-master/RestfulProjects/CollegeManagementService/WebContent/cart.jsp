<%@ page language="java"%>
<%
	String username = (String) session.getAttribute("username");
	String roleId = (String) session.getAttribute("roleId");
	String semester = request.getParameter("semester");
	int year = Integer.parseInt(request.getParameter("year"));
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
   

    <title>Cart</title>

    <!-- Bootstrap core CSS -->
    <link href="libraries/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="libraries/dashboard.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.10.10/css/dataTables.bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
  	 <link rel="stylesheet" href="libraries/jquery-ui/jquery-ui.theme.css">
  

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="libraries/jquery-1.11.3.js"></script>
    <script src="libraries/jquery-ui/jquery-ui.js"></script>
    <link href="https://cdn.datatables.net/1.10.10/css/dataTables.bootstrap.min.css" rel="stylesheet">
  
    <script type="text/javascript" src="libraries/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/dataTables.bootstrap.min.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
    <script type="text/javascript">
    	$(document).ready(function() {
    		var semester = '<%=semester%>';
    		var year = '<%=year%>';
    		var emailId = '<%=username%>';
    		var cartList = $("#cartTable").dataTable({
    		});
    		$.ajax({
    			type: 'POST',
    			data: {
    				studentId: emailId,
    				semester: semester,
    				year: year
    			},
    			url: '/CMS/service/getCoursesInCart',
    			dataType: 'json',
    			success: function(output){
    				if(output.length == 0)
    				{
    					$("#cartTable .dataTables_empty").html("No courses are available");
    				}
    				else
    				{
    					cartList.fnClearTable();
    					cartList.fnFilter('');
    					$.each(output, function(inx,val) {
    						var action = "deleteFromCart('" + emailId + "','" + val.courseId + "')";
    						var data = [
    							'<button type="button" onclick="' + action + '" class="btn btn-default">Remove</button>', 
    							val.courseId,
    							val.courseName,
    							val.date,
    							val.name,
    							val.timings
    						];
    						cartList.fnAddData(data);
    					});
    				}
    			},
    			error: function(jqXHR, status, error){
    			}
    		});
    		
    		$("#enroll").click(function() {
    			$.ajax({
    				type: 'POST',
    				data: {
						studentId: emailId,
						semester: semester,
						year: year    				
    				},
    				dataType: 'json',
    				url: '/CMS/service/enroll',
    				success: function(output){
    					$("#textbody").html(output.status);
    					$("#myModal").modal('show');
    				},
    				error: function(jqXHR, status, error){
    				}
    			});
    			window.location.reload();
    		});
    		
    		
    		
    		
    		
    	});
    	
    	function deleteFromCart(emailId, courseId)
    	{
    		var semester = '<%=semester%>';
    		var year = '<%=year%>';
    		var emailId = '<%=username%>';
    		$.ajax({
    			type: 'POST',
    			url: '/CMS/service/deleteFromCart',
    			data: {
    				studentId: emailId,
    				courseId: courseId
    			},
    			dataType: 'json',
    			success: function(output) {
    				alert(output.message);
    				window.location.reload();
    				$.ajax({
		    			type: 'POST',
		    			data: {
		    				studentId: emailId,
		    				semester: semester,
		    				year: year
		    			},
		    			url: '/CMS/service/getCoursesInCart',
		    			dataType: 'json',
		    			success: function(output){
		    				if(output.length == 0)
		    				{
		    					$("#cartTable .dataTables_empty").html("No data found");
		    				}
		    				else
		    				{
		    					cartList.fnClearTable();
		    					cartList.fnFilter('');
		    					$.each(output, function(inx,val) {
		    						var action = "deleteFromCart('" + emailId + "','" + val.courseId + "')";
		    						var data = [
		    							'<button type="button" onclick="' + action + '" class="btn btn-default">Remove</button>', 
		    							val.courseId,
		    							val.courseName,
		    							val.date,
		    							val.name,
		    							val.timings
		    						];
		    						cartList.fnAddData(data);
		    					});
		    				}
		    			},
		    			error: function(jqXHR, status, error){
		    			}
		    		});
    		
    			},
    			error: function(jqXHR, status, error){
    			}
    		});
    	}
    	
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
          <h1 class="page-header">Cart</h1>
				  <table class="table table-striped table-responsive table-bordered" id="cartTable">
				  	<thead>
				  		<tr>
				  			<td></td>
				  			<td>Course ID</td>
				  			<td>Course Name</td>
				  			<td>Date</td>
				  			<td>Prof Name</td>
				  			<td>Timings</td>
				  		</tr>
				  	</thead>
				  </table> 
				  <button type="button" class="btn btn-success" id="enroll">Enroll</button>	
				  
				 
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
  