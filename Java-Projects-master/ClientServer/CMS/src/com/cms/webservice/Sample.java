package com.cms.webservice;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.codehaus.jettison.json.JSONObject;

import com.cms.dao.Department;
import com.google.gson.Gson;

public class Sample {
	public static void main(String[] args) {
		try
		{
			Connections con = new Connections();
			Connection connect = con.getConnection();
			System.out.println(connect);
			
		}catch(Exception e){
			//return null;
		}	
	}
}
