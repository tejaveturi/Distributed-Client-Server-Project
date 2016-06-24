package com.cms;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

import com.cms.webservice.Connections;

public class functions {

	Connections connect = new Connections();
	public ResultSet fnGetDepartments() throws Exception
	{
		Connection con = connect.getConnection(); 
		Statement st = con.createStatement();
		String query = "select dept_id,dept_name from departments";
		ResultSet rs = st.executeQuery(query);
		return rs;
		
	}
}
