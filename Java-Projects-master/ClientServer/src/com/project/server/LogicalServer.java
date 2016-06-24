package com.project.server;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class LogicalServer {
	public static void main(String[] args) {
		try {
			boolean bool1;
			boolean bool2;
			boolean result;
			ServerSocket arithmetic = new ServerSocket(1302);
			System.out.println("Waiting for connections");
			Socket link = arithmetic.accept();
			System.out.println("Client Connected:" + link.getInetAddress());
			ObjectInputStream in = new ObjectInputStream(link.getInputStream());
			ObjectOutputStream out = new ObjectOutputStream(link.getOutputStream());
			int choice = 0;
			while(true)
			{
				System.out.println("Started");
				choice = (int) in.readObject();
				System.out.println("Choice is:" + choice);
				System.out.println("Entered");
				switch(choice)
				{
					case 1: System.out.println("Numbers reading");
							bool1 = (boolean) in.readObject();
							bool2 = (boolean) in.readObject();
							result = bool1 && bool2;
							out.writeObject("The Logical AND of " + bool1 + "&" + bool2 + " is:" +result);
							
							
							break;
					case 2: bool1 = (boolean) in.readObject();
							bool2 = (boolean) in.readObject();
							result = bool1 || bool2;
							out.writeObject("The Logical OR of " + bool1 + "&" + bool2 + " is:" +result);
							break;
					case 3: bool1 = (boolean) in.readObject();
							bool2 = (boolean) in.readObject();
							result = bool1 ^ bool2;
							out.writeObject("The Logical XOR of " + bool1 + "&" + bool2 + " is:" +result);
							break;
					case 4: bool1 = (boolean) in.readObject();
							//num2 = (int) in.readObject();
							result = !bool1;
							out.writeObject("The Logical NOT of " + bool1 + " is:" +result);
							break;
					default:break;
				}
				
				System.out.println("over");
				//choice = (int) in.readObject();
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
