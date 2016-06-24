package com.project.server;



import java.io.File;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class FileLookUpServer {
	
	/*
	  private String fileNameToSearch;
	  private List<String> result = new ArrayList<String>();
	 
	  public String getFileNameToSearch() {
		return fileNameToSearch;
	  }
	 
	  public void setFileNameToSearch(String fileNameToSearch) {
		this.fileNameToSearch = fileNameToSearch;
	  }
	 
	  public List<String> getResult() {
		return result;
	  }*/
	 
		static String output;
		public String getOutput()
		{
			return output;
		}
		public void setOutput(String output)
		{
			this.output = output;
		}
		
	    public void findFile(String name,File file)
	    {
	    	int flag = 0;
	        File[] list = file.listFiles();
	        if(list != null)
	        for (File files : list)
	        {
	            if (files.isDirectory())
	            {
	                findFile(name,files);
	            }
	            else if (name.equalsIgnoreCase(files.getName()))
	            {
	            	output = files.getParentFile().toString();
	                System.out.println(output);
	            	//return output;
	            }
	          
	        }
	       
	        
	    }
	    public static void main(String[] args) throws IOException, ClassNotFoundException 
	    {
	    	String result;
	    	String directory;
			String fileName;
			ServerSocket fileServer = new ServerSocket(1303);
			Socket link = fileServer.accept();
			System.out.println("Client Connected :" +link.getInetAddress());
			FileLookUpServer fileSearch = new FileLookUpServer();
			ObjectInputStream in = new ObjectInputStream(link.getInputStream());
			ObjectOutputStream out = new ObjectOutputStream(link.getOutputStream());
	        FileLookUpServer fserver = new FileLookUpServer();
	        while(true)
	        {
	        	directory = (String) in.readObject();
				fileName = (String) in.readObject();
	        	fserver.findFile(fileName,new File(directory));
	        	//System.out.println(output);
	        	if(output == null)
	        	{
	        		System.out.println("File Not Found");
	        		result = "File not found";
	        	}
	        	else
	        	{
	        		System.out.println("File Found-->" + output);
	        		result = "File found --->" + output;
	        	}
	        	out.writeObject(result);
	        }
	    }
	    /*
	  public static void main(String[] args) throws IOException, ClassNotFoundException {
	 
		
		while(true)
		{
			int count = 0;
			directory = (String) in.readObject();
			fileName = (String) in.readObject();
			String output = "";
			fileSearch.searchDirectory(new File(directory), fileName);
		 
			count = fileSearch.getResult().size();
			if(count ==0){
			    output += "\nNo result found!";
			    out.writeObject(output);
			}else{
			    output +="\nFound " + count + " result!\n";
			    for (String matched : fileSearch.getResult()){
				output += "Found : " + matched;
				out.writeObject(output);
				System.out.println(output);
			    }
			}
			System.out.println(fileName);
			System.out.println(count);
		}
		
	  }
	 
	  public void searchDirectory(File directory, String fileNameToSearch) {
	 
		setFileNameToSearch(fileNameToSearch);
	 
		if (directory.isDirectory()) {
		    search(directory);
		} else {
		    System.out.println(directory.getAbsoluteFile() + " is not a directory!");
		}
	 
	  }
	 
	  private void search(File file) {
	 
		if (file.isDirectory()) {
		  System.out.println("Searching directory ... " + file.getAbsoluteFile());
	 
	            //do you have permission to read this directory?	
		    if (file.canRead()) {
			for (File temp : file.listFiles()) {
			    if (temp.isDirectory()) {
				search(temp);
			    } else {
				if (getFileNameToSearch().equals(temp.getName().toLowerCase())) {			
				    result.add(temp.getAbsoluteFile().toString());
			    }
	 
			}
		    }
	 
		 } else {
			System.out.println(file.getAbsoluteFile() + "Permission Denied");
		 }
	      }
	 
	  }*/
}
