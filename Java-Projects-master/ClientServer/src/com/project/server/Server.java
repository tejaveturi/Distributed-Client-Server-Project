package com.project.server;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.Scanner;

public class Server {
	public static void main(String[] args) {
		try {
			int num1;
			int num2;
			int result=0;
			boolean bool1,bool2 = false;
			String output;
			int check[]=new int[3];
			for(int i=0;i<3;i++)
				check[i]=0;
			ServerSocket socket = new ServerSocket(1300);
			Socket arithmetic=null;
			Socket logical = null;
			Socket fileServer = null;
			ObjectOutputStream sout = null;
			ObjectInputStream sin = null;
			
			//System.out.println("Waiting for connections");
			
			Socket link = socket.accept();
			System.out.println("Connected one client:" + link.getInetAddress());
			ObjectInputStream in = new ObjectInputStream(link.getInputStream());
			ObjectOutputStream out = new ObjectOutputStream(link.getOutputStream());
			int choice = (int) in.readObject();
			//System.out.println(choice);
			Scanner scan = new	 Scanner(System.in);
			while(true)
			{
			switch(choice)
			{
				case 1: 
							System.out.println("::::::::::::::::::::::::MENU::::::::::::::::::::::::::");
							System.out.println("1.Add\n2.Subtract\n3.Multiply\n4.Divide\n5.Modulus\n6.Exit");
							System.out.println("Enter the choice");
							int ch = scan.nextInt();
							System.out.println("Enter the First Number:");
							num1 = scan.nextInt();
							System.out.println("Enter the Second Number:");
							num2 = scan.nextInt();
							if(check[0]<=0)
							{	
								arithmetic = new Socket("127.0.0.1",1301);
								sout = new ObjectOutputStream(arithmetic.getOutputStream());
								sin = new ObjectInputStream(arithmetic.getInputStream());
								check[0]++;
							}
							//System.out.println("new socket");
							sout.writeObject(ch);
							sout.writeObject(num1);
							sout.writeObject(num2);
							output = (String) sin.readObject();
							System.out.println(output);
							out.writeObject(output);
							//arithmetic.close();
							break;
							
				case 2: 
							System.out.println("::::::::::::::::::::::::MENU::::::::::::::::::::::::::");
							System.out.println("1.Logical AND\n2.Logical OR\n3.Logical XOR\n4.Logical NOT\n5.Exit");
							System.out.println("Enter the choice");
							ch = scan.nextInt();
							if(ch == 4)
							{
								System.out.println("Enter the A value(true/false):");
								bool1 = scan.nextBoolean();
							}
							else
							{
								System.out.println("Enter the A value(true/false):");
								bool1 = scan.nextBoolean();
								System.out.println("Enter the B value(true/false):");
								bool2 = scan.nextBoolean();
							}
							if(check[1] <= 0)
							{	
								logical = new Socket("127.0.0.1",1302);
								sout = new ObjectOutputStream(logical.getOutputStream());
								sin = new ObjectInputStream(logical.getInputStream());
								check[1]++;
							}
							//System.out.println("new socket");
							sout.writeObject(ch);
							if(ch == 4)
							{
								sout.writeObject(bool1);
							}
							else
							{
								sout.writeObject(bool1);
								sout.writeObject(bool2);
							}
							output = (String) sin.readObject();
							System.out.println(output);
							out.writeObject(output);
							//arithmetic.close();
							break;
				case 3: 	String fileName;
							String directory;
							System.out.println("Enter the directory name:");
							directory = scan.next();
							System.out.println("Enter the fileName:");
							fileName = scan.next();
							if(check[2] <= 0)
							{
								fileServer = new Socket("127.0.0.1",1303);
								sout = new ObjectOutputStream(fileServer.getOutputStream());
								sin = new ObjectInputStream(fileServer.getInputStream());
								check[2]++;
							}
							sout.writeObject(directory);
							sout.writeObject(fileName);
							output = (String) sin.readObject();
							System.out.println(output);
							out.writeObject(output);
							break;
				default:break;
			}
				System.out.println("Server work is done ");
				System.out.println("Please go to client and enter new option ");
				//out.writeObject(result);
				choice = (int) in.readObject();
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
