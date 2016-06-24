package com.cms;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

public class SampleClass {

	public static void main(String[] args) throws Exception {
		Class.forName("com.mysql.jdbc.Driver");
		Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/cms", "root", "dell");
		Statement st = con.createStatement();
		String sql = "Select * from users";
		int a = 1_2_3;
		System.out.println(a);
		
		ResultSet rs = st.executeQuery(sql);
		while(rs.next())
		{
			//System.out.println("Hello World");
			//System.out.println("Output:" + rs.getRow());
			System.out.println(rs.getInt(1));
			System.out.println(rs.getString(2));
			
		}
	}
	
	
}
