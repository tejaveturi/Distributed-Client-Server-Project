package com.cms;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


/**
 * Servlet implementation class Login
 */
@WebServlet("/Login")
public class Login extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String email_id = request.getParameter("username");
		String password = request.getParameter("password");
		String username = "";
		int roleId = 0;
		PrintWriter out = response.getWriter();
		HttpSession session = null;
		//out.println(email_id + password);
		System.out.println("Hello world");
		try{
			System.out.println("Welcome");
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cms","root","dell");
			Statement st = con.createStatement();
			String sql = "Select email_id,role_id from users where email_id ='" + email_id + "' and password = '" + password + "'";  
			
			ResultSet rs = st.executeQuery(sql);
			ResultSetMetaData rsmd = rs.getMetaData();
			int columnCount = rsmd.getColumnCount();
			session = request.getSession();
			out.println(columnCount);
			
			if(rs.next())
			{
					
				username =  rs.getString(1);
				roleId =  rs.getInt(2);
				String role = roleId + "";
				session.setAttribute("username", username);
				session.setAttribute("roleId", role);
				response.sendRedirect("dashboard.jsp");
			}
			else
			{
				session.setAttribute("error","Wrong Username and Password");
				//request.setAttribute("error","Wrong Username and Password");
				System.out.println("Hello");
				//response.sendRedirect("/CMS/login.jsp");
				//RequestDispatcher rd = request.getRequestDispatcher("login.jsp");            
				//rd.forward(request, response);
				
			}
			
			
		}catch(Exception e){
			e.printStackTrace();
		}
	}

}
