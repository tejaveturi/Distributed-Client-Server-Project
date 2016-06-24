
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
    <link href="https://cdn.datatables.net/1.10.10/css/dataTables.bootstrap.min.css" rel="stylesheet">
  
    <script type="text/javascript" src="libraries/bootstrap/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" src="https://cdn.datatables.net/1.10.10/js/dataTables.bootstrap.min.js"></script>
    <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.3.14/angular.min.js"></script>
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
    			type: 'POST',
    			url: '/CMS/service/getSemesters',
    			dataType: 'json',
    			success: function(output) {
    				//$("#semester").html('');
    				//$("#year").html('');
    				console.log(output);
    				$.each(output, function(inx,val){
    					$("#semesters").append('<option value="'+ val.semester_name  + '">' + val.semester_name  + '</option>');
    					console.log("Entered" + val.year);
    					$("#years").append('<option value="'+ val.year  + '">' + val.year  + '</option>');
    				});
    				
    			},
    			error: function(jqXHR, status, error) {
    				console.log("error");
    			}
    		});
    		$.ajax({
    			type: 'POST',
    			url: '/CMS/service/getClassroomsAvailable',
    			dataType: 'json',
    			success: function(output) {
    				//$("#semester").html('');
    				//$("#year").html('');
    			
    				$.each(output, function(inx,val){
    					$("#classroom").append('<option value="' + val.classroom_id + '">' + val.classroom_id + '</option>' );
    				});
    				
    			},
    			error: function(jqXHR, status, error) {
    				console.log("error");
    			}
    		});
    		
    		$("#create").click(function() {
    			var semester = $("#semester").val();
    			var year = $("#year").val();
    			if(semester == "" || year == "")
    			{
    				alert("Please make sure all the required fields are entered properly");
    			}
    			else
	    		{
	    			$.ajax({
	    				type: 'POST',
	    				data: {
	    					semester: semester,
	    					year: year
	    				},
	    				url: '/CMS/service/createSemester',
	    				dataType: 'json',
	    				success: function(output) {
	    					
	    					$("#textbody").html(output.status);
	    					$("#myModal").modal('show');
	    					$("#semester").val('');
	    					$("#year").val('');
	    				},
	    				error: function(jqXHR, status, error){
	    					console.log("error");
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
    							var value = "addToSemester('" + val.course_id + "'," + deptId + " )";
    							$("#accordion").append('<h3>' + val.course_id + ":" + val.course_name + '</h3><div>' + val.course_description + '<br/><button type="button" class="btn btn-info"  style="margin-top:2%" id="select" onclick="' + value + '">Add to Semester</button>' + '</div>');	
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
    	function addToSemester(courseId,deptId)
    	{
    		//$("#addCourse").show();
    		$("#courseModal").modal({
    			backdrop: 'static',
    			keyboard: false
    		});
    		$("#courseModal").modal('show');
    		$.ajax({
    			type: 'POST',
    			url: '/CMS/service/getProfessors',
    			data: {
    				deptId: deptId
    			},
    			dataType: 'json',
    			success: function(output) {
    				//$("#semester").html('');
    				//$("#year").html('');
    				console.log(output);
    				$.each(output, function(inx,val){
    					$("#professor").append('<option value="'+ val.email_id + '">' + val.name  + '</option>');
    					
    				});
    				
    			},
    			error: function(jqXHR, status, error) {
    				console.log("error");
    			}
    		});
    		$("#courseId").val(courseId);
    		$("#addToSem").click(function() {
	    		var courseId = $("#courseId").val();
	    		
	    		var level = $("#level").val();
	    		var professor = $("#professor").val();
	    		var classroomId = $("#classroom").val();
	    		var year = $("#years").val();
	    		var semester = $("#semesters").val();
	    		var sDate = $("#from").val();
	    		var eDate = $("#end").val();
	    		var sTime = $("#sTime").val();
	    		var eTime = $("#eTime").val();
	    		var seats = $("#seats").val();
	    		var dates = sDate + " ---- " + eDate;
	    		var timings = sTime + "-" + eTime;
	    		alert(deptId + level + professor + classroomId + year + semester);
	    		console.log("courseId=" + courseId + "&deptId=" + deptId + "&level=" + level + "&professorId=" + professor + "&classroomId=" + classroomId + "&year=" + year + "&semester=" + semester + "&dates=" + dates + "&timings=" + timings + "&seats=" + seats);
	    		$.ajax({
	    			type: 'POST',
	    			data: {
	    				courseId: courseId,
	    				semester: semester,
	    				year: year
	    			},
	    			url: '/CMS/service/checkCourseInSemester',
	    			success: function(output) {
	    				console.log(output);
	    				if(output == true)
	    				{
	    					alert("Course Already there");
	    				}
	    				else
	    				{
	    					//alert("Ready to add");
	    					var params = "courseId=" + courseId + "&deptId=" + deptId + "&level=" + level + "&professorId=" + professor + "&classroomId=" + classroomId + "&year=" + year + "&semester=" + semester + "&dates=" + dates + "&timings=" + timings + "&seats=" + seats;	
	    					$.ajax({
	    						type: 'POST',
	    						data: params,
	    						url: '/CMS/service/addCourseToSemester',
	    						dataType: 'json',
	    						success: function(output) {
	    							alert(output.message);
	    						},
	    						error: function(jqXHR,status, error){
	    						}
	    					});
	    				}
	    			},
	    			error: function(jqXHR, status, error){
	    			}
	    		});
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
          <h1 class="page-header">Courses</h1>
          
         	<div ng-app> 
	         	<form class="form-inline" role="form" >
	         		<div class="form-group">
				      	<label class="radio-inline"><input type="radio" id="operation" ng-model="operation" value="Semester">Create Semester</label>
						<label class="radio-inline"><input type="radio" id="operation" ng-model="operation" value="Courses">Add Course to Semester</label>
				      
				    </div>
	         	</form>
				<div class="panel panel-primary" ng-show="operation == 'Semester'" style="margin-top:2%">
				  		<div class="panel-heading">Add Semester</div>
				  		<div class="panel-body">
				  		
				  			<form class="form-horizontal" role="form" method="POST" >
							    
							      
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
				  <div style="margin-top:2%" ng-show="operation == 'Courses'">
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
					  
					  <hr/>
					  
					  <div id="accordion">
					  
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
		    	 
		    	 <div class="modal fade" id="courseModal" role="dialog">
		        		<div class="modal-dialog">
				            <div class="modal-content">
				              <div class="modal-header">
				                  <button type="button" class="close" data-dismiss="modal">&times;</button>
				                  <h4 class="modal-title">Add Course to Semester</h4>
				               </div>
				              <div class="modal-body">
				                  <form class="form-horizontal" role="form" method="POST" >
					    <div class="form-group">
					      <label class="control-label col-sm-4" for="email">Course ID:*</label>
					      <div class="col-sm-8">
					        <input type="text" class="form-control" id="courseId" name="courseId" placeholder="Course ID" disabled>
					      </div>
					    </div>
					    <div class="form-group">
					      <label class="control-label col-sm-4" for="lev">Level:*</label>
					      <div class="col-sm-8">
					        <select class="form-control" id="level">
							    <option value="">Select level</option>
							    <option value="Undergraduate">Undergraduate</option>
							    <option value="Graduate">Graduate</option>
							 </select>
					      </div>
					    </div>
					    
					    <div class="form-group">
						  <label class="control-label col-sm-4" for="prof">Professor:*</label>
						  <div class="col-sm-8">
							  <select class="form-control" id="professor">
							    <option value="">Select Professor</option>
							    
							  </select>
						  </div>
						</div>
						<div class="form-group">
						  <label class="control-label col-sm-4" for="sem">Semester:*</label>
						  <div class="col-sm-8">
							  <select class="form-control" id="semesters">
							    <option value="">Select semester</option>
							    
							  </select>
						  </div>
						</div>
						<div class="form-group">
						  <label class="control-label col-sm-4" for="ye">Year:*</label>
						  <div class="col-sm-8">
							  <select class="form-control" id="years">
							    <option value="">Select year</option>
							    
							  </select>
						  </div>
						</div>
						<div class="form-group">
						  <label class="control-label col-sm-4" for="fr">Start Date:*</label>
						  <div class="col-sm-8">
							  <input type="date" class="form-control" id="from" name="from" >	
						  </div>
						</div>
						<div class="form-group">
						  <label class="control-label col-sm-4" for="fr">End Date:*</label>
						  <div class="col-sm-8">
							  <input type="date" class="form-control" id="end" name="end" >	
						  </div>
						</div>
						<div class="form-group">
						  <label class="control-label col-sm-4" for="st">Start Time:*</label>
						  <div class="col-sm-8">
							  <input type="text" class="form-control" id="sTime" name="sTime" placeholder="Eg. 07:00 AM or PM">	
						  </div>
						</div>
						<div class="form-group">
						  <label class="control-label col-sm-4" for="st">End Time:*</label>
						  <div class="col-sm-8">
							  <input type="text" class="form-control" id="eTime" name="eTime" placeholder="Eg. 08:00 AM or PM">	
						  </div>
						</div>
					    <div class="form-group">
						  <label class="control-label col-sm-4" for="croom">Classroom:*</label>
						  <div class="col-sm-8">
							  <select class="form-control" id="classroom">
							    <option value="">Select Classroom</option>
							    
							  </select>
						  </div>
						</div>
						<div class="form-group">
						  <label class="control-label col-sm-4" for="st">Seats:*</label>
						  <div class="col-sm-8">
							  <input type="text" class="form-control" id="seats" name="seats" placeholder="Seats">	
						  </div>
						</div>
						</form>
				              </div>
				              <div class="modal-footer">
				               <button type="button" class="btn btn-primary"  id="addToSem">Add to Semester</button>
				                  <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				              </div>
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
  