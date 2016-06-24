package com.cms.webservice;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.Consumes;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;


@Path("/")
public class Webservice {
	private WebserviceImpl impl = new WebserviceImpl();
	
	 @Context
	    private HttpServletRequest request;
	
	@POST
	@Path("/createDepartments")
	@Produces(MediaType.APPLICATION_JSON)
	public String addDeps(@FormParam("department") String department, @FormParam("degrees") String degrees)
	{
		String output = impl.fnAddDepartment(department, degrees);
		return output;

	}
	
	@GET
	@Path("/getDepartments")
	@Produces(MediaType.APPLICATION_JSON)
	public String listDepartments()
	{
		String output = impl.fnGetDepartments();
		return output;
	}
	
	@POST
	@Path("/addUser")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String addUser(@FormParam("roleId")String role,@FormParam("email_id") String email_id, @FormParam("password") String password, @FormParam("role_id") String role_id, @FormParam("dept_id") String dept_id,@FormParam("fname") String fname, @FormParam("lname") String lname, @FormParam("address") String address, @FormParam("aemail_id") String aemail_id, @FormParam("joined_on") String joined_on,@FormParam("DOB") String dob, @FormParam("phone") String phone, @FormParam("gender") String gender) throws NumberFormatException, SQLException
	{
		System.out.println(role + email_id + password + role_id + dept_id + fname + lname + address + aemail_id + joined_on + dob + phone + gender);
		String output = impl.fnAddUser(Integer.parseInt(role), email_id, password, Integer.parseInt(role_id), Integer.parseInt(dept_id), fname, lname, address, aemail_id, joined_on, dob, phone, gender);
		return output;
	}
	
	@POST
	@Path("/addCourse")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String addCourse(@FormParam("cid") String cid,@FormParam("cname") String cname, @FormParam("cdescription") String description, @FormParam("deptid") String deptid, @FormParam("level") String level)
	{
		
		String output = impl.fnAddCourse(cid, cname, description, deptid,level);
		return output;
	}
	
	@POST
	@Path("/getCoursesByDept")
	@Produces(MediaType.APPLICATION_JSON)
	public String getCourseByDept(@FormParam("deptId") String deptId)
	{
		return impl.fnGetCourses(Integer.parseInt(deptId));
	}
	
	@POST
	@Path("/getClassroomsAvailable")
	@Produces(MediaType.APPLICATION_JSON)
	public String getClassrooms()
	{
		return impl.fnGetClassrooms();		
	}
	
	@POST
	@Path("/addCourseToSemester")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	@Produces(MediaType.APPLICATION_JSON)
	public String addCourseToSemester(@FormParam("courseId") String courseId, @FormParam("level") String level, @FormParam("semester") String semester, @FormParam("deptId") String deptId, @FormParam("seats") String seats, @FormParam("professorId") String professorId, @FormParam("year") String  year, @FormParam("dates") String dates, @FormParam("timings") String timings, @FormParam("classroomId") String classId)
	{
		System.out.println(courseId + Integer.parseInt(deptId) + professorId + semester + Integer.parseInt(year) + Integer.parseInt(seats) + dates + timings + classId + level);
		return impl.fnAddCourseToSemester(courseId, Integer.parseInt(deptId), professorId, semester, Integer.parseInt(year), Integer.parseInt(seats), dates, timings, classId,level);
	}

	@POST
	@Path("/searchCourses")
	@Consumes(MediaType.APPLICATION_FORM_URLENCODED)
	public String searchCourse(@FormParam("deptId") String deptId, @FormParam("level") String level,@FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnSearchCourses(Integer.parseInt(deptId), level, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/getUserType")
	@Produces(MediaType.APPLICATION_JSON)
	public String getUserType()
	{
		
		return impl.fnGetUserType();
	}
	
	@POST
	@Path("/checkUser")
	@Produces(MediaType.APPLICATION_JSON)
	public boolean checkUser(@FormParam("emailId") String emailId)
	{
		return impl.fnCheckUser(emailId);
	}
	
	@POST
	@Path("/createSemester")
	@Produces(MediaType.APPLICATION_JSON)
	public String createSemester(@FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnCreateSemester(semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/getSemesters")
	@Produces(MediaType.APPLICATION_JSON)
	public String getSemesters()
	{
		return impl.fnGetSemesters();
	}
	
	@POST
	@Path("/getProfessors")
	@Produces(MediaType.APPLICATION_JSON)
	public String getProfessors(@FormParam("deptId") String deptId)
	{
		return impl.fnGetProfessors(Integer.parseInt(deptId));
	}
	
	@POST
	@Path("/checkCourseInSemester")
	@Produces(MediaType.APPLICATION_JSON)
	public boolean checkCourseInSemester(@FormParam("courseId") String courseId, @FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnCheckCourseInSemester(courseId, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/addToCart")
	@Produces(MediaType.APPLICATION_JSON)
	public String addToCart(@FormParam("studentId") String studentId, @FormParam("courseId") String courseId, @FormParam("classroomId") String classroomId, @FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnAddToCart(studentId, courseId, classroomId, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/enroll")
	@Produces(MediaType.APPLICATION_JSON)
	public  String enroll(@FormParam("studentId") String studentId, @FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnEnroll(studentId, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/checkInCart")
	@Produces(MediaType.APPLICATION_JSON)
	public boolean checkInCart(@FormParam("studentId") String studentId, @FormParam("courseId") String courseId, @FormParam("classroomId") String classroomId,  @FormParam("year") String year, @FormParam("semester") String semester)
	{
		return impl.fnCheckInCart(studentId, courseId, classroomId, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/getCoursesInCart")
	@Produces(MediaType.APPLICATION_JSON)
	public String getCoursesInCart(@FormParam("studentId") String studentId, @FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnGetCoursesInCart(studentId, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/deleteFromCart")
	@Produces(MediaType.APPLICATION_JSON)
	public String deleteCourseInCart(@FormParam("studentId") String studentId, @FormParam("courseId") String courseId)
	{
		return impl.fnDeleteCourseFromCart(studentId, courseId);
	}
	
	@POST
	@Path("/checkInEnrollment")
	@Produces(MediaType.APPLICATION_JSON)
	public boolean checkInEnrollment(@FormParam("studentId") String studentId, @FormParam("semester") String semester,@FormParam("year") String year,@FormParam("courseId") String courseId )
	{
		return impl.fnCheckEnrollment(studentId, courseId, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/dropCourse")
	@Produces(MediaType.APPLICATION_JSON)
	public String dropCourse(@FormParam("studentId") String studentId, @FormParam("courseId") String courseId, @FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnDropCourse(studentId, courseId, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/getEnrolledCourses")
	@Produces(MediaType.APPLICATION_JSON)
	public String getEnrolledCourses(@FormParam("studentId") String studentId, @FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnGetCoursesEnrolled(studentId, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/getCourseHistory")
	@Produces(MediaType.APPLICATION_JSON)
	public String getCourseHistory(@FormParam("studentId") String studentId)
	{
		return impl.fnGetCourseHistory(studentId);
	}
	
	@POST
	@Path("/createThread")
	@Produces(MediaType.APPLICATION_JSON)
	public String createThread( @FormParam("courseId") String courseId, @FormParam("posted") String posted,@FormParam("topicName") String topic, @FormParam("description") String description, @FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnCreateThread(courseId, posted, topic, description, semester, Integer.parseInt(year));
	}
	
	@POST
	@Path("/getThreadsInCourse")
	@Produces(MediaType.APPLICATION_JSON)
	public String getThreadsInCourse(@FormParam("courseId") String courseId, @FormParam("semester") String semester, @FormParam("year") String year)
	{
		return impl.fnGetThreadsInCourse(courseId, semester, year);
	}
	
	@POST
	@Path("/getTopic")
	@Produces(MediaType.APPLICATION_JSON)
	public String getTopic(@FormParam("topicId") String topicId, @FormParam("courseId") String courseId)
	{
		
		return impl.fnGetTopic(topicId, courseId);
	}
	
	@POST
	@Path("/login")
	@Produces(MediaType.APPLICATION_JSON)
	public boolean login(@FormParam("username") String username, @FormParam("password") String password)
	{
		return impl.login(username,password, request);
	}
}
