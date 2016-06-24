package com.cms.webservice;

import java.sql.Connection;
import java.sql.DriverManager;

public class Connections {

	String username = "root";
	String password = "dell";
	String url = "jdbc:mysql://localhost:3306/cms";
	public Connection getConnection() throws Exception 
	{
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection(url, username, password);
		
		return con;
		
	}
}
