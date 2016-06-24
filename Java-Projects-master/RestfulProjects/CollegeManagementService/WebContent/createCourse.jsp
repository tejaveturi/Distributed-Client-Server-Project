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
   

    <title>Courses</title>

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
    <script type="text/javascript" src="libraries/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/dataTables.bootstrap.min.js"></script>
    <script type="text/javascript" src="libraries/Utils.js"></script>
    <script type="text/javascript">
    	
    	$(document).ready(function() {
    		
    	//$("#myModal").modal('show');
    		//$("#accordion").append('<h3>Section6</h3><div>Welcome</div>');
    		//$("#accordion").append('<h3>Section5</h3><div>Hello</div>');
    		var degree_data = "";
    		var departmentName = "";
    		
    		
    		$.ajax({
    			type: 'GET',
    			url: '/CMS/service/getDepartments',
    			dataType: 'json',
    			success: function(output){
    				//$("#dept").html('');
    				$.each(output, function(inx,val) {
    					$("#dept").append("<option value='" + val.dept_id + "'>" + val.dept_name + "</option" );
    					
    				});
    			},
    			error: function(error) {
    				console.log(error);
    			}	
    		});
    		$.ajax({
    			type: 'GET',
    			url: '/CMS/service/getDepartments',
    			dataType: 'json',
    			success: function(output){
    				//$("#dept").html('');
    				$.each(output, function(inx,val) {
    					$("#depts").append("<option value='" + val.dept_id + "'>" + val.dept_name + "</option" );
    					
    				});
    			},
    			error: function(error) {
    				console.log(error);
    			}	
    		});
    		$("#create").click(function() {
    			var courseId = $("#cid").val();
    			var courseName = $("#cname").val();
    			var description = $("#description").val();
    			var deptId = $("#dept").val();
    			var level = $("#level").val();
    			if(courseId == "" || courseName == ""  || description == "" || deptId == "" || level == "" )
    			{
    				alert("Please make sure all required fields are entered");
    			}
    			else
    			{
    				$.ajax({
    					type: 'POST',
    					data: {
    						cid: courseId,
    						cname: courseName,
							cdescription: description,
							deptid: deptId,
							level:  level  						
    					},
    					url: '/CMS/service/addCourse',
    					success: function(output){
    						$("#textbody").html(output);
    						$("#myModal").modal('show');
    						$("#cid").val('');
    						$("#cname").val('');
    						$("#description").val('');
    						$("#dept").val('');
    						$("#level").val('');
    					},
    					error: function(output){
    					}
    				});
    			}
    		});
    		
    		$("#getCourses").click(function() {
    		
    			var deptId = $("#depts").val();
    			 
    			$.ajax({
    				type: 'POST',
    				dataType: 'json',
    				url: '/CMS/service/getCoursesByDept',
    				data: {
    					deptId: deptId
    				},
    				contentType: 'application/json',
    				success: function(output){
    					$( "#accordion" ).accordion({
							      event: "click hoverintent"
							    });
    					//$("#accordion").html('');
    					console.log("The length is: " + output.length + output);
    					if(output.length == 0)
    					{
    						alert("No Courses are added");
    						$("#accordion").accordion("destroy");   
    						$("#accordion").empty(); 
    					//	$("#accordion").hide();
    					}
    					else
    					{
    						$("#accordion").accordion("destroy");   
    						$("#accordion").empty(); 
    						$.each(output, function(inx,val) {
    							
    							$("#accordion").append('<h3>' + val.course_id + ":" + val.course_name + '</h3><div>' + val.course_description + ' </div>');	
    						});
    						//$("#accordion").show();
    						
    					}
    					$(function() {
							    $( "#accordion" ).accordion({
							      event: "click hoverintent"
							    });
							  });
							 
							  /*
							   * hoverIntent | Copyright 2011 Brian Cherne
							   * http://cherne.net/brian/resources/jquery.hoverIntent.html
							   * modified by the jQuery UI team
							   */
							  $.event.special.hoverintent = {
							    setup: function() {
							      $( this ).bind( "mouseover", jQuery.event.special.hoverintent.handler );
							    },
							    teardown: function() {
							      $( this ).unbind( "mouseover", jQuery.event.special.hoverintent.handler );
							    },
							    handler: function( event ) {
							      var currentX, currentY, timeout,
							        args = arguments,
							        target = $( event.target ),
							        previousX = event.pageX,
							        previousY = event.pageY;
							 
							      function track( event ) {
							        currentX = event.pageX;
							        currentY = event.pageY;
							      };
							 
							      function clear() {
							        target
							          .unbind( "mousemove", track )
							          .unbind( "mouseout", clear );
							        clearTimeout( timeout );
							      }
							 
							      function handler() {
							        var prop,
							          orig = event;
							 
							        if ( ( Math.abs( previousX - currentX ) +
							            Math.abs( previousY - currentY ) ) < 7 ) {
							          clear();
							 
							          event = $.Event( "hoverintent" );
							          for ( prop in orig ) {
							            if ( !( prop in event ) ) {
							              event[ prop ] = orig[ prop ];
							            }
							          }
							          // Prevent accessing the original event since the new event
							          // is fired asynchronously and the old event is no longer
							          // usable (#6028)
							          delete event.originalEvent;
							 
							          target.trigger( event );
							        } else {
							          previousX = currentX;
							          previousY = currentY;
							          timeout = setTimeout( handler, 100 );
							        }
							      }
							 
							      timeout = setTimeout( handler, 100 );
							      target.bind({
							        mousemove: track,
							        mouseout: clear
							      });
							    }
							  };
    				},
    				error: function(error) {
    					console.log("Error");
    				}
    			});
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
             if(Integer.parseInt(roleId) == 1024)
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
          <h1 class="page-header">Courses</h1>
         
		<div class="panel panel-primary">
		  		<div class="panel-heading">Create Course</div>
		  		<div class="panel-body">
		  			<%
					//String status_msg=(String)request.getAttribute("status");  
					//if(status_msg!=null)
					//out.println("<p align=center><font color=red size=4px align=center>"+status_msg+"</font></p>");
					%>
		  			<form class="form-horizontal" role="form" method="POST" >
		  				<div class="form-group">
					      <label class="control-label col-sm-2" for="cid">Course Id:*</label>
					      <div class="col-sm-8">
					        <input type="text" class="form-control" id="cid" name="cid" placeholder="Course ID">
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-2" for="cname">Course Name:*</label>
					      <div class="col-sm-8">
					        <input type="text" class="form-control" id="cname" name="cname" placeholder="Course Name">
					      </div>
					    </div>
					    <div class="form-group">
						  <label  class="control-label col-sm-2" for="description">Description:*</label>
						  <div class="col-sm-8">
						  	<textarea class="form-control" rows="5" id="description" placeholder="Course Description"></textarea>
						  </div>
						</div>
					   	<div class="form-group">
						  <label class="control-label col-sm-2" for="deptid">Department:*</label>
						  <div class="col-sm-8">
							  <select class="form-control" id="dept">
							    <option value="">Select a value</option>
							    
							  </select>
						  </div>
						</div>
						<div class="form-group">
						  <label class="control-label col-sm-2" for="level">Level:*</label>
						  <div class="col-sm-8">
							  <select class="form-control" id="level">
							    <option value="">Select a value</option>
							    <option value="Undergraduate">Undergraduate</option>
								<option value="Graduate">Graduate</option>
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
		 
		  <h3 class="sub-header">Course List</h3>
		  <br/>
		  <br/>
		  
		  <form class="form-horizontal" role="form" method="POST" >
		  				
		   	<div class="form-group">
			  <label class="control-label col-sm-2" for="deptid">Department:*</label>
			  <div class="col-sm-4">
				  <select class="form-control" id="depts">
				    <option value="">Select a value</option>
				    
				  </select>
			  </div>
			</div>
			
		    
		    <div class="form-group">        
		      <div class="col-sm-offset-2 col-sm-10">
		        <button type="button" id="getCourses" class="btn btn-danger">Get Courses</button>
		      </div>
		    </div>
		  </form>
		  <div id="accordion">
		  </div>
		  
		  <div class="modal fade" id="myModal" role="dialog">
        		<div class="modal-dialog">
		            <div class="modal-content">
		              <div class="modal-header">
		                  <button type="button" class="close" data-dismiss="modal">&times;</button>
		                  <h4 class="modal-title">Status</h4>
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
  