package com.cms;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cms.webservice.Connections;

/**
 * Servlet implementation class AddDepartment
 */
@WebServlet("/AddDepartment")
public class AddDepartment extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
   
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String department_name = request.getParameter("dept");
		String degrees = request.getParameter("degrees");
		Connections connect = new Connections();
		if(department_name != "")
		{
			try
			{
				Connection con = connect.getConnection();
				Statement st = con.createStatement();
				String query = "INSERT INTO DEPARTMENTS(dept_name,degrees) values('"+ department_name.trim() + "','" + degrees +"')";
				st.executeUpdate(query);
				request.setAttribute("status","Department created successfully");
				//RequestDispatcher rd = request.getRequestDispatcher("/addDepartment.jsp");            
				//rd.forward(request, response);
				response.sendRedirect("/CMS/addDepartment.jsp");
			}catch(Exception e){
				e.printStackTrace();
			}
		}
		else
		{
			request.setAttribute("status","Department was not created");
			RequestDispatcher rd = request.getRequestDispatcher("/addDepartment.jsp");            
			rd.forward(request, response);
		}
	}

}
