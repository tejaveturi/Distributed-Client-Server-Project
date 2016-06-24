package com.cms.webservice;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;







import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import sun.security.x509.AVA;

import com.cms.dao.Cart;
import com.cms.dao.ClassesAvailable;
import com.cms.dao.Classrooms_available;
import com.cms.dao.CourseHistory;
import com.cms.dao.Courses;
import com.cms.dao.CoursesInSemester;
import com.cms.dao.Department;
import com.cms.dao.DiscussionBoard;
import com.cms.dao.Enroll;
import com.cms.dao.Professors;
import com.cms.dao.Semesters;
import com.cms.dao.UserType;
import com.google.gson.Gson;

public class WebserviceImpl {

	Connections connect = new Connections();
	Connection connection = null;
	Statement statement = null;
	ResultSet resultset = null;
	int ADMIN_ROLE = 1024;
	int STUDENT_ROLE = 1027;
	int PROFESSOR_ROLE = 1029;
	public String fnAddDepartment(String department, String degrees)
	{
		String message = "";
		if(!department.equals("") && !degrees.equals(""))
		{
			try
			{
					
				connection = connect.getConnection();
				statement = connection.createStatement();
				String query = "INSERT INTO DEPARTMENTS(dept_name,degrees) values('"+ department.trim() + "','" + degrees +"')";
				if(statement.executeUpdate(query) != 0)
					message =  "Department Created Successfully";
				else
					message = "Department was not created";
				JSONObject obj = new JSONObject();
				obj.put("message", message);
				System.out.println(obj);
				return obj.toString();
			}catch(Exception e){
				return null;
			}
		}
		else
		{
			return "Please make sure Department name and Degrees are entered";
		}
	
		
	}
	
	public String fnGetDepartments()
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String query = "SELECT dept_id,dept_name,degrees from departments";
			resultset = statement.executeQuery(query);
			Department dept = null;
			//ArrayList<JSONObject> results = new ArrayList<JSONObject>();
			ArrayList<Department> results = new ArrayList<Department>();
			while(resultset.next())
			{
				dept = new Department();
				dept.setDept_id(resultset.getInt(1));
				dept.setDept_name(resultset.getString(2));
				dept.setDegrees(resultset.getString(3));
				results.add(dept);
			}
			/*
			 * Another Way for creating JSON string
			JSONArray jsonArray = new JSONArray();
	        while (resultset.next()) {
	          
	        	JSONObject obj = new JSONObject();
           
                //jsonArray.put(obj);
                obj.put("DEPT_ID",resultset.getInt(1));
                obj.put("DEPT_NAME",resultset.getString(2));
                obj.put("DEGREES", resultset.getString(2));
                
                results.add(obj);
            }*/
	        
			Gson gson = new Gson();
			String output = gson.toJson(results);
			System.out.println(output);
			return output;
		}catch(Exception e){
			return null;
		}	
	}
	
	public String fnAddUser(int current_role, String email_id,  String password,  int role_id,int dept_id,String fname, String lname, String address, String aemail_id, String joined_on, String dob,String phone, String gender) throws SQLException
	{
		if(current_role == ADMIN_ROLE)
		{
			try {
				connection = connect.getConnection();
				connection.setAutoCommit(false);
				statement = connection.createStatement();
				String sql1 = "";
				String sql2 = "";
				String message = "";
				if(role_id == ADMIN_ROLE)
				{
					sql1 = "INSERT INTO users(email_id,password,role_id,dept_id) values('"+ email_id + "','" + password +"','" + role_id + "','" + dept_id + "')";
					sql2 = "INSERT INTO admin(fname,lname,phone,address,alternative_email,email_id) values('"+ fname +"','" + lname + "','" + phone + "','" + address + "','" + aemail_id + "','" + email_id + "')"; 
				}
				else if(role_id == PROFESSOR_ROLE)
				{
					sql1 = "INSERT INTO users(email_id,password,role_id,dept_id) values('"+ email_id + "','" + password +"','" + role_id + "','" + dept_id + "')";
					sql2 = "INSERT INTO professors(email,fname,lname,dob,phone,alternative_email,address,gender) values('" + email_id + "','" + fname +"','" + lname + "','" + dob + "','" + phone + "','" + aemail_id + "','" + address + "','" + gender + "' )"; 
				}
				else if(role_id == STUDENT_ROLE)
				{
					sql1 = "INSERT INTO users(email_id,password,role_id,dept_id) values('"+ email_id + "','" + password +"','" + role_id + "','" + dept_id + "')";
					sql2 = "INSERT INTO students(email,fname,lname,dob,phone,address,alternative_email,joined_on,gender) values('" + email_id + "','" + fname +"','" + lname + "','" + dob + "','" + phone + "','" + address + "','" + aemail_id + "','" + joined_on + "','" + gender + "' )"; 
				}
				
				if(statement.executeUpdate(sql1) != 0 && statement.executeUpdate(sql2) != 0)
				{
					connection.commit();
					message = "User Created Successfully";
				}
				else
				{
					connection.rollback();
					message = "User not created";
				}
				return message;
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				connection.rollback();
				return null;
			}
		}
		else
		{
			return "You doesnt have permission to create User";
		}
	}
	
	public String fnAddCourse(String courseId, String courseName, String courseDescription, String dept_id, String level)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "INSERT INTO courses values('"+ courseId + "','" + courseName + "','" + courseDescription + "','" + Integer.parseInt(dept_id) + "','" + level + "')";
			System.out.println(sql);
			int rows = statement.executeUpdate(sql);
			
			if(rows != 0)
				return "Course created successfully";
			else
				return "Course not created";
		}catch(Exception e){
			return null;
		}
		
	}
	
	public String fnGetCourses(int deptId)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT * FROM courses where dept_id=" + deptId;
			resultset = statement.executeQuery(sql);
			ArrayList<Courses> results = new ArrayList<Courses>();
			Courses courses = new Courses();
			while(resultset.next())
			{	
				courses = new Courses();
				
				courses.setCourse_id(resultset.getString(1));
				courses.setCourse_name(resultset.getString(2));
				courses.setCourse_description(resultset.getString(3));
				courses.setDept_id(resultset.getInt(4));
				courses.setLevel(resultset.getString(5));
				results.add(courses);
			}
			Gson gson = new Gson();
			String output = gson.toJson(results);
			System.out.println(output);
			return output;
		}catch(Exception e){
			return null;
	
		}
	}	
	
	public String fnAddCourseToSemester(String courseId,int deptId,String professor_id,String semester,int year, int seats,String dates,String timings,String classId, String level)
	{
		System.out.println(courseId + deptId + professor_id + semester + year + seats + dates + timings + classId + level);
		try
		{
			System.out.println("Hello");
			String message = "";
			HashMap results = new HashMap();
			connection = connect.getConnection();
			statement = connection.createStatement();
			String query = "UPDATE classrooms_available set status = 0 where classroom_id ='" + classId + "'";
			System.out.println("World" + query);
			int stat1 = statement.executeUpdate(query);
			System.out.println(query + stat1);
			String sql = "INSERT INTO classroom values('" + classId + "','" + semester + "','" + professor_id + "','" + year + "','" + seats + "','" + dates + "','" + timings + "',"  + deptId + ",'"+ courseId + "','" + level + "')";
			int status = statement.executeUpdate(sql);
			System.out.println(sql + status);
			if(status == 1)
				results.put("message", "Course Successfully Added to the " + semester + " " +year);
			else
				results.put("message", "Course not added");
			Gson gson = new Gson();
			String output = gson.toJson(results);
			return output;
		}catch(Exception e){
			e.printStackTrace();
			
			return null;
		}
	}
	
	public String fnGetClassrooms()
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT classroom_id,status from CLASSROOMS_AVAILABLE where status = 1";
			resultset = statement.executeQuery(sql);
			ArrayList<Classrooms_available> results = new ArrayList<Classrooms_available>(); 
			Classrooms_available rooms = null;
			while(resultset.next())
			{
				rooms = new Classrooms_available();
				rooms.setClassroom_id(resultset.getString(1));
				rooms.setStatus(resultset.getInt(2));
				results.add(rooms);
			}
			Gson gson = new Gson();
			String output = gson.toJson(results);
			return output;
		}catch(Exception e){
			return null;
		}
	}
	
	public String fnSearchCourses(int deptId , String level, String semester, int year)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			ArrayList<ClassesAvailable> results = new ArrayList<ClassesAvailable>();
			ClassesAvailable availableClasses = null;
			String sql = "SELECT cl.classroom_id,cl.semester_name,cl.professor_id, cl.year, cl.seats, cl.date, cl.timings, cl.dept_id, cl.course_id, cl.level, cou.course_name, cou.courser_description,p.fname,p.lname from classroom cl join courses cou join professors p where cl.course_id = cou.course_id and cl.professor_id = p.email and cl.dept_id = " + deptId + " and cl.level = '" + level + "' and cl.semester_name= '" + semester + "' and cl.year = " + year  ;
			System.out.println(sql);
			resultset = statement.executeQuery(sql);
			
			while(resultset.next())
			{
				availableClasses = new ClassesAvailable();
				availableClasses.setClassroom_id(resultset.getString(1));
				availableClasses.setSemester_name(resultset.getString(2));
				availableClasses.setProfessor_id(resultset.getString(3));
				availableClasses.setYear(resultset.getInt(4));
				availableClasses.setSeats(resultset.getInt(5));
				availableClasses.setDate(resultset.getString(6));
				availableClasses.setTimings(resultset.getString(7));
				availableClasses.setDept_id(resultset.getInt(8));
				availableClasses.setCourse_id(resultset.getString(9));
				availableClasses.setLevel(resultset.getString(10));
				availableClasses.setCourse_name(resultset.getString(11));
				availableClasses.setCourse_description(resultset.getString(12));
				availableClasses.setName(resultset.getString(13) + " " + resultset.getString(14));
				results.add(availableClasses);
			}
			
			Gson gson = new Gson();
			String output = gson.toJson(results);
			System.out.println(output + sql);
			return output;
			
			
		}catch(Exception e){
			return null;
		}
		
	}
	
	public String fnGetUserType()
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT roleid,rolename from usertype";
			System.out.println(sql);
			resultset = statement.executeQuery(sql);
			ArrayList<UserType> results = new ArrayList<UserType>();
			UserType users = null;
			while(resultset.next())
			{
				users = new UserType();
				users.setRoleId(resultset.getInt(1));
				users.setRolename(resultset.getString(2));
				
				results.add(users);
			}
			
			Gson gson = new Gson();
			String output = gson.toJson(results);
			
			System.out.println(output);
			return output;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public String fnCreateSemester(String semesterName,int year)
	{
		try
		{
			int count = 0;
			String msg = "";
			connection = connect.getConnection();
			statement = connection.createStatement();
			String query = "SELECT count(semester_name) from semesters where semester_name='" + semesterName + "' and year=" + year;
			resultset = statement.executeQuery(query);
			while(resultset.next()) 
			{
				count = resultset.getInt(1);
			}
			if(count == 1)
			{
				msg = "Semester Already Existed";
			}
			else
			{
				String sql = "INSERT INTO SEMESTERS(semester_name,year) values('" + semesterName + "'," + year + ")";
				System.out.println(sql);
				int status  = statement.executeUpdate(sql);
				msg =  "Semester created Successfully";
			}
			HashMap a = new HashMap();
			a.put("status", msg);
			//obj.put("status", msg);
			Gson gson = new Gson();
			String output = gson.toJson(a);
			System.out.println(output);
			return output;
		}catch(Exception e){
			return null;
		}
	}
	
	public boolean fnCheckUser(String emailId)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "Select count(email_id) from users where email_id = '" + emailId + "'";
			
			resultset = statement.executeQuery(sql);
			int count = 0;
			while(resultset.next())
			{
				count = resultset.getInt(1);
			}
			System.out.println(count + sql);
			if(count == 1)
				return true;
			else
				return false;
		}catch(Exception e){
			return true;
		}
	}
	
	public String fnGetSemesters()
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			resultset = statement.executeQuery("SELECT ID,SEMESTER_NAME,YEAR FROM SEMESTERS");
			ArrayList<Semesters> results = new ArrayList<Semesters>();
			Semesters sem = null;
			while(resultset.next())
			{
				sem = new Semesters();
				sem.setId(resultset.getInt(1));
				sem.setSemester_name(resultset.getString(2));
				sem.setYear(resultset.getInt(3));
				
				results.add(sem);
			}
			Gson gson = new Gson();
			String output = gson.toJson(results);
			
			return output;
		}catch(Exception e){
			return null;
		}
	}
	
	public String fnGetProfessors(int deptId)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "select users.email_id,users.dept_id,professors.fname,professors.lname from users  join professors  where users.email_id = professors.email and users.role_id = 1029 and users.dept_id=3";
			resultset = statement.executeQuery(sql);
			ArrayList<Professors> results = new ArrayList<Professors>();
			Professors prof = null;
			while(resultset.next())
			{
				prof = new Professors();
				prof.setEmail_id(resultset.getString(1));
				prof.setDept_id(resultset.getInt(2));
				prof.setName(resultset.getString(3) + " " + resultset.getString(4));
				
				results.add(prof);
		
			}
			
			Gson gson = new Gson();
			String output = gson.toJson(results);
			System.out.println(output);
			return output;
		}catch(Exception e){
			return null;
		}
	}
	
	public boolean fnCheckCourseInSemester(String courseId, String semester,int year)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT count(course_id) from classroom where course_id = '" + courseId + "' and semester_name = '" + semester + "' and year = " + year;
			resultset = statement.executeQuery(sql);
			int count = 0;
			while(resultset.next())
			{
				count = resultset.getInt(1);
			}
			System.out.println(count + sql);
			if(count >= 1)
				return true;
			else
				return false;
	
		}catch(Exception e){
			e.printStackTrace();
			return true;
		}
	}
	
	public String fnAddToCart(String student_id, String course_id, String classroom_id, String semester, int year)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "INSERT INTO CART VALUES('" + student_id + "','" + course_id + "','" + classroom_id + "','" + semester + "'," + year + ")";
			int status = statement.executeUpdate(sql);
			HashMap results = new HashMap();
			if(status == 1)
				results.put("message", "Added to cart");
			else
				results.put("message", "Not added to cart");
			Gson gson = new Gson();
			String output = gson.toJson(results);
			System.out.println(output);
			return output;
		}catch(Exception e){
			return null;
		}	
	}
	
	public boolean fnCheckInCart(String student_id, String course_id, String classroom_id, String semester, int year)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "select count(student_id) from cart where student_id='" + student_id + "' and course_id = '" + course_id + "' and classroom_id ='" + classroom_id + "' and semester = '" + semester + "' and year = " + year;
			resultset = statement.executeQuery(sql);
			int count = 0;
			while(resultset.next())
			{
				count = resultset.getInt(1);
			}
			if(count >= 1)
				return true;
			else
				return false;
		}catch(Exception e){
			return true;
		}
		
	}
	
	public String fnGetCoursesInCart(String studentId, String semester, int year)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "select professors.fname,professors.lname,classroom.timings,classroom.date,classroom.course_id,courses.course_name from cart join classroom join professors join courses where student_id='" + studentId + "' and cart.course_id = classroom.course_id and classroom.professor_id = professors.email and courses.course_id =cart.course_id and classroom.semester_name='" + semester + "' and classroom.year=" + year;
			System.out.println(sql);
			resultset = statement.executeQuery(sql);
			ArrayList<Cart> results = new ArrayList<Cart>();
			Cart cart = null;
			while(resultset.next())
			{
				cart = new Cart();
				cart.setName(resultset.getString(1) + " " + resultset.getString(2));
				cart.setTimings(resultset.getString(3));
				cart.setDate(resultset.getString(4));
				cart.setCourseId(resultset.getString(5));
				cart.setCourseName(resultset.getString(6));
				
				results.add(cart);
			}
			Gson gson = new Gson();
			String output = gson.toJson(results);
			System.out.println(output);
			return output;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public String fnDeleteCourseFromCart(String studentId, String courseId)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "DELETE FROM CART WHERE student_id='" + studentId + "' and course_id = '" + courseId + "'";
			int status = statement.executeUpdate(sql);
			HashMap results = new HashMap();
			if(status == 1)
				results.put("message", "Course Deleted from Cart");
			else
				results.put("message", "Course not deleted");
			Gson gson = new Gson();
			String output = gson.toJson(results);
			return output;
		}catch(Exception e){
			return null;
		}
	}
	
	public String fnEnroll(String studentId, String semester, int year)
	{
		try
		{
			HashMap results = new HashMap();
			int incCount = 0;
			int count = 0;
			connection = connect.getConnection();
			Connection con = connect.getConnection();
			statement = con.createStatement();
			Statement statement2 = connection.createStatement();
			String sql = "SELECT count(student_id) from cart where student_id='" + studentId + "' and semester='" + semester + "' and year=" + year;
			ResultSet resultset1 = statement.executeQuery(sql);
			resultset1.next();
			count = resultset1.getInt(1);
			resultset1.close();
			String query = "SELECT student_id,course_id,classroom_id, semester, year from cart where student_id='" + studentId + "' and semester='" + semester + "' and year=" + year;
			resultset = statement.executeQuery(query);
			ArrayList<Enroll> resultsData = new ArrayList<Enroll>();
			Enroll enroll = null;
			while(resultset.next())
			{
				enroll = new Enroll();
				enroll.setStudentId(resultset.getString(1));
				enroll.setCourseId(resultset.getString(2));
				enroll.setClassroomId(resultset.getString(3));
				enroll.setSemester(resultset.getString(4));
				enroll.setYear(resultset.getInt(5));
				
				resultsData.add(enroll);
				
			}
			System.out.println(resultsData.size());
			for(int index = 0; index < resultsData.size(); index++)
			{
				
				sql = "INSERT INTO course_student values('" + resultsData.get(index).getStudentId() + "','" + resultsData.get(index).getCourseId() + "','" + resultsData.get(index).getClassroomId() + "','" + resultsData.get(index).getSemester() + "'," + resultsData.get(index).getYear() + ",'Confirmed',0)";
				System.out.println(sql);
				int status1 = statement.executeUpdate(sql);
				System.out.println(status1);
				String sql2 = "INSERT INTO course_history(student_id,course_id,semester,year) values('" + resultsData.get(index).getStudentId() + "','" + resultsData.get(index).getCourseId() + "','" + resultsData.get(index).getSemester() + "'," + resultsData.get(index).getYear() + ")";
				System.out.println(sql2);
				int status2 = statement2.executeUpdate(sql2);
				System.out.println(status2);
			}
			/*sql = "INSERT INTO course_student values('" + resultset.getString(1) + "','" + resultset.getString(2) + "','" + resultset.getString(3) + "','" + resultset.getString(4) + "'," + resultset.getInt(5) + ")";
			int status1 = statement.executeUpdate(sql);
			incCount++;*/
		
			if(count == resultsData.size())
			{
				sql = "DELETE FROM CART WHERE student_id='" + studentId + "' and semester='" + semester + "' and year =" + year;
				int status = statement.executeUpdate(sql);
				System.out.println("Deleted");
				results.put("status", "Successfully enrolled");
			}
			else
			{
				results.put("status","Sorry Enrollment not happened");
			}
			
			
			Gson gson = new Gson();
			String output = gson.toJson(results);
			System.out.println(output);
			
			return output;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public boolean fnCheckEnrollment(String studentId,String courseId, String semester, int year)
	{
		try
		{
			//HashMap results = new HashMap();
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT count(student_id) from course_student where course_id ='" + courseId + "' and semester='" + semester + "' and year =" + year;
			resultset = statement.executeQuery(sql);
			int count = 0;
			while(resultset.next())
			{
				count = resultset.getInt(1);
			}
			if(count >= 1)
				return true;
			else
				return false;
		}catch(Exception e){
			return true;
		}
	}
	
	public String fnDropCourse(String studentId, String courseId, String semester, int year)
	{
		try
		{
			HashMap results = new HashMap();
			connection = connect.getConnection();
			statement = connection.createStatement();
			Statement statement2 = connection.createStatement();
			String sql = "DELETE FROM COURSE_STUDENT where student_id='" + studentId + "' and course_id='" + courseId + "' and semester='" + semester + "' and year=" + year;
			int status = statement.executeUpdate(sql);
			String sql2 = "DELETE FROM COURSE_HISTORY where student_id='" + studentId + "' and course_id='" + courseId + "' and semester='" + semester + "' and year=" + year;
			int status2 = statement2.executeUpdate(sql2);
			
			if(status >= 1 && status2 >= 1)
				results.put("message","Course was dropped successfully");
			else
				results.put("message","Error in dropping the course");
			Gson gson = new Gson();
			String output = gson.toJson(results);
			return output;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public String fnGetCoursesEnrolled(String studentId, String semester, int year)
	{
		try
		{
			ArrayList<CoursesInSemester> results = new ArrayList<CoursesInSemester>();
			CoursesInSemester sem = null;
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT e.STUDENT_ID, e.COURSE_ID , c.COURSE_NAME from course_student e join courses c where e.STUDENT_ID='" + studentId + "' and semester ='" + semester + "' and year=" + year + " and e.COURSE_ID = c.COURSE_ID ";
			System.out.println(sql);
			resultset = statement.executeQuery(sql);
			while(resultset.next())
			{
				sem = new CoursesInSemester();
				sem.setStudentId(resultset.getString(1));
				sem.setCourseId(resultset.getString(2));
				sem.setCourseName(resultset.getString(3));
				
				results.add(sem);
			}
			Gson gson = new Gson();
			String output = gson.toJson(results);
			return output;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public String fnGetCourseHistory(String studentId)
	{
		try
		{
			ArrayList<CourseHistory> results = new ArrayList<CourseHistory>();
			CourseHistory history = null;
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT h.COURSE_ID,h.STUDENT_ID,h.SEMESTER,h.YEAR,c.COURSE_NAME FROM COURSE_HISTORY h join COURSES c WHERE h.COURSE_ID = c.COURSE_ID and h.STUDENT_ID='" + studentId + "'";
			resultset = statement.executeQuery(sql);
			while(resultset.next())
			{
				history = new CourseHistory();
				
				history.setCourseId(resultset.getString(1));
				history.setStudentId(resultset.getString(2));
				history.setSemester(resultset.getString(3));
				history.setYear(resultset.getInt(4));
				history.setCourseName(resultset.getString(5));
				
				results.add(history);
				
			}
			
			Gson gson = new Gson();
			String output = gson.toJson(results);
			return output;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public String fnCreateThread(String courseId, String posted, String topicName, String topicDescription, String semester, int year)
	{
		try
		{
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "INSERT INTO DISCUSSION_BOARD(course_id,posted_by,topic_name,topic_description,semester,year) values('" + courseId + "','" + posted + "','" + topicName + "','" + topicDescription + "','" + semester + "'," + year + ")";
			int status = statement.executeUpdate(sql);
			HashMap results = new HashMap();
			results.put("message", "Topic posted successfully");
			Gson gson = new Gson();
			String output = gson.toJson(results);
			return output;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public String fnGetThreadsInCourse(String courseId, String semester, String year)
	{
		try
		{
			DiscussionBoard db = null;
			ArrayList<DiscussionBoard> results = new ArrayList<DiscussionBoard>();
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT d.TOPIC_ID,d.COURSE_ID, d.TOPIC_NAME, d.TOPIC_DESCRIPTION,s.FNAME,s.LNAME from DISCUSSION_BOARD d join STUDENTS s where d.POSTED_BY = s.EMAIL and d.course_id ='" + courseId + "' and  d.SEMESTER='" + semester + "' and year=" + year;
			resultset = statement.executeQuery(sql);
			while(resultset.next())
			{
				db = new DiscussionBoard();
				
				db.setCourseId(resultset.getString(2));
				db.setTopicName(resultset.getString(3));
				db.setTopicDescription(resultset.getString(4));
				db.setName(resultset.getString(5) + " " + resultset.getString(6));
				db.setTopicId(resultset.getInt(1));
				results.add(db);
				
			}
			
			Gson gson = new Gson();
			String output = gson.toJson(results);
			return output;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public String fnGetTopic(String topicId, String courseId)
	{
		try
		{
			DiscussionBoard db = null;
			ArrayList<DiscussionBoard> results = new ArrayList<DiscussionBoard>();
			connection = connect.getConnection();
			statement = connection.createStatement();
			String sql = "SELECT d.TOPIC_ID,d.COURSE_ID, d.TOPIC_NAME, d.TOPIC_DESCRIPTION,s.FNAME,s.LNAME from DISCUSSION_BOARD d join STUDENTS s where d.POSTED_BY = s.EMAIL and d.course_id ='" + courseId + "' and  d.topic_id='" + topicId + "'" ;
			System.out.println(sql);
			resultset = statement.executeQuery(sql);
			
			while(resultset.next())
			{
				db = new DiscussionBoard();
				
				db.setCourseId(resultset.getString(2));
				db.setTopicName(resultset.getString(3));
				db.setTopicDescription(resultset.getString(4));
				db.setName(resultset.getString(5) + " " + resultset.getString(6));
				db.setTopicId(resultset.getInt(1));
				results.add(db);
				
			}
			
			Gson gson = new Gson();
			String output = gson.toJson(results);
			return output;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
	}
	
	public boolean login(String username, String password, HttpServletRequest request)
	{
		try{
			System.out.println("Welcome");
			//Class.forName("com.mysql.jdbc.Driver");
			//Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cms","root","dell");
			connection = connect.getConnection();
			Statement st = connection.createStatement();
			String sql = "Select email_id,role_id from users where email_id ='" + username + "' and password = '" + password + "'";  
			HttpSession session = null;
			ResultSet rs = st.executeQuery(sql);
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			session = request.getSession();
			System.out.println(columnCount);
			int roleId;
			if(rs.next())
			{
					
				String uname =  rs.getString(1);
				roleId =  rs.getInt(2);
				String role = roleId + "";
				session.setAttribute("username", uname);
				session.setAttribute("roleId", role);
				//response.sendRedirect("dashboard.jsp");
				return true;
			}
			else
			{
				session.setAttribute("error","Wrong Username and Password");
				//request.setAttribute("error","Wrong Username and Password");
				System.out.println("Hello");
				return false;
				//response.sendRedirect("/CMS/login.jsp");
				//RequestDispatcher rd = request.getRequestDispatcher("login.jsp");            
				//rd.forward(request, response);
				
			}
			
			
		}catch(Exception e){
			e.printStackTrace();
			return true;
		}
	}
}
