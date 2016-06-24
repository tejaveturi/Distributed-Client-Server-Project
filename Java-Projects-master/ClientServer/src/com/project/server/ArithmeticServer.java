package com.project.server;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.ServerSocket;
import java.net.Socket;

public class ArithmeticServer {
	public static void main(String[] args) {
		try {
			int num1 = 0;
			int num2 = 0;
			int result = 0;
			ServerSocket arithmetic = new ServerSocket(1301);
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
							num1 = (int) in.readObject();
							num2 = (int) in.readObject();
							result = num1 + num2;
							out.writeObject("The Sum of " + num1 + "&" + num2 + " is:" + result);
							//choice=0;
							
							break;
					case 2: num1 = (int) in.readObject();
							num2 = (int) in.readObject();
							result = num1 - num2;
							out.writeObject("The subtraction of " + num1 + "&" + num2 + " is:" + result);
							break;
					case 3: num1 = (int) in.readObject();
							num2 = (int) in.readObject();
							result = num1 * num2;
							out.writeObject("The Multiplication of " + num1 + "&" + num2 + " is:" + result);
							
							break;
					case 4: num1 = (int) in.readObject();
							num2 = (int) in.readObject();
							result = num1 / num2;
							out.writeObject("The Division of " + num1 + "&" + num2 + " is:" + result);
							break;
					case 5: num1 = (int) in.readObject();
							num2 = (int) in.readObject();
							result = num1 % num2;
							out.writeObject("The modulus of " + num1 + "&" + num2 + " is:" + result);
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
