
<%@ page language="java"%>
<%
	String username = (String) session.getAttribute("username");
	String roleId = (String) session.getAttribute("roleId");
	String semester = request.getParameter("semester");
	String year = request.getParameter("year");
	String courseId = request.getParameter("courseId");
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
   

    <title>Discussion Board</title>

    <!-- Bootstrap core CSS -->
    <link href="libraries/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom styles for this template -->
    <link href="libraries/dashboard.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/1.10.10/css/dataTables.bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
  	 <link rel="stylesheet" href="libraries/jquery-ui/jquery-ui.theme.css">
  	<style>
  	.selected{
    background-color: rgb(224,224,224) ;
    color: #000;
}
  	</style>

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
    <script src="libraries/jquery-1.11.3.js"></script>
    <script src="libraries/jquery-ui/jquery-ui.js"></script>
    <link href="https://cdn.datatables.net/1.10.10/css/dataTables.bootstrap.min.css" rel="stylesheet">
  
    <script type="text/javascript" src="libraries/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/dataTables.bootstrap.min.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
    <script type="text/javascript">
    	$("document").ready(function() {
    		$("#dboardDetailPanel").hide();
    		var id = "<%= username%>";
    		var courseId = "<%= courseId%>";
    		var semester = "<%= semester%>";
    		var year = "<%= year%>";
    		$.ajax({
    			type: 'POST',
    			data: {
    				courseId: courseId,
    				semester: semester,
    				year : year
    			},
    			url: '/CMS/service/checkCourseInSemester',
    			dataType: 'json',
    			success: function(output){
    				if(output == true)
    				{
	    				$("#createThread").click(function() {
				    		$("#discussionModal").modal({
				    			backdrop: 'static',
				    			keyboard: false
				    		});
			    			$("#discussionModal").modal('show');
			    			$("#postThread").click(function() {
			    				var topicName = $("#tname").val();
			    				var description = $("#description").val();
			    				if(topicName == "" || description == "")
			    				{
			    					alert("Please enter all the fields");
			    				}
			    				else
			    				{
			    					$.ajax({
			    						type: 'POST',
			    						data: {
			    							semester: semester,
			    							year: year,
			    							courseId: courseId,
			    							topicName: topicName,
			    							description : description,
			    							posted: id
			    						},
			    						url: '/CMS/service/createThread',
			    						success: function(output){
			    							$("#tname").val('');
			    							$("#description").val('');
			    							alert(output.message);
			    							window.location.reload();
			    						},
			    						error: function(jqXHR, status, error){
			    						}
			    					});
			    				}
			    			});
			    			
	    				});
	    				
	    				var dboard = $("#dboard").dataTable({
	    					"oLanguage": {
		                          "sEmptyTable":     "<img src='loading1.gif'>",
		                      }
	    				});
	    				$.ajax({
	    					type: 'POST',
	    					data: {
	    						courseId: courseId,
	    						semester: semester,
	    						year: year
	    					},
	    					url: '/CMS/service/getThreadsInCourse',
	    					dataType: 'json',
	    					success: function(output) {
	    						if(output.length == 0)
	    						{
	    							$("#dboard .dataTables_empty").html("No posts available")
	    						}
	    						else
	    						{
	    							dboard.fnClearTable();
	    							dboard.fnFilter('');
	    							$.each(output, function(inx,val) {
	    								var data = [
	    									val.topicId,
	    									val.topicName,
	    									val.courseId,
	    									val.name,
	    									val.topicDescription
	    								];
	    								dboard.fnAddData(data);
	    							});
	    						}
	    					},
	    					error: function(jqXHR, status, error) {
	    					}
	    				});
	    				$("#dboard tbody").on('click', 'tr', function() {
	    					var topicId = $('td',this).eq(0).text();
	    					var courseId = $('td',this).eq(2).text();
	    					$.ajax({
	    						type: 'POST',
	    						data: {
	    							topicId: topicId,
	    							courseId: courseId
	    						},
	    						dataType: 'json',
	    						url: '/CMS/service/getTopic',
	    						beforeSend: function(){
	    							$("#dboardDetailPanel").show();
	    							var el = document.getElementById('dboardDetailPanel');
	    							el.scrollIntoView(true);
	    						},
	    						success: function(output){
	    							
	    							$("#dataPanel").html('');
	    							$.each(output, function(inx,val) {
	    								$("#dataPanel").append('<b>Topic Name:</b>' + val.topicName + '<br/><hr/>' );
	    								$("#dataPanel").append('<b>Topic Description:</b>'  + val.topicDescription + '<br/><hr/>'  );
	    								$("#dataPanel").append('</b>Posted By:</b>' + val.name + '<br/><hr/>');
	    							});
	    						},
	    						error: function(jqXHR, status, error) {
	    						}
	    					});
	    				});
	    			}
	    			else
	    			{
	    				alert("No Such course existed");
	    			}
    			},
    			error: function(jqXHR, status, error) {
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
          <h1 class="page-header">Discussion Board</h1>
          	<button type="button" class="btn btn-success" id="createThread" style="margin-bottom:2%">Create Thread</button>
				 
			<div class="panel panel-primary" id="dboardPanel">
			<div class="panel-heading">Discussion Board</div>	 
			<div class="panel-body">	 
			<table class="table table-bordered table-responsive" id="dboard" style="cursor:pointer">
				<thead>
					<tr>
						<td>Topic Id</td>
						<td>Topic Name</td>
						<td>Course Id</td>
						<td>Posted By</td>
						<td>Description</td>
					</tr>
				</thead>
				<tbody>
				</tbody>
			</table>
			</div>	 
			</div>
			
			<div class="panel panel-success" id="dboardDetailPanel">
			<div class="panel-heading">Discussion Board</div>	 
			<div class="panel-body">	 
				<div id="dataPanel">
				
				</div>
			</div>	 
			</div>
				  <div class="modal fade" id="discussionModal" role="dialog">
		        		<div class="modal-dialog">
				            <div class="modal-content">
				              <div class="modal-header">
				                  <button type="button" class="close" data-dismiss="modal">&times;</button>
				                  <h4 class="modal-title">Create New Topic</h4>
				               </div>
				              <div class="modal-body">
				                  <form class="form-horizontal" role="form" method="POST">
				                  	<div class="form-group">
								      <label class="control-label col-sm-4" for="tn">Topic Name:*</label>
								      <div class="col-sm-8">
								        <input type="text" class="form-control" id="tname" name="tname" placeholder="Topic Name">
								      </div>
								    </div>
								    <div class="form-group">
								      <label class="control-label col-sm-4" for="td">Topic Description:*</label>
								      <div class="col-sm-8">
								        <textarea rows="8" class="form-control" id="description" name="description" placeholder="Topic Description"></textarea>
								      </div>
								    </div>
				                  </form>
				              </div>
				              <div class="modal-footer">
				                  <button type="button" class="btn btn-primary" id="postThread">Post</button>
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
  