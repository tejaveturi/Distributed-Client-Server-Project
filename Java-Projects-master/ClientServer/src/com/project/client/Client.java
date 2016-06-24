package com.project.client;

import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.net.Socket;
import java.util.Scanner;

public class Client {
	public static void main(String[] args) throws Exception{
		int choice = 0;
		Socket server = new Socket("127.0.0.1",1300);
		ObjectOutputStream out = new ObjectOutputStream(server.getOutputStream());
		ObjectInputStream in = new ObjectInputStream(server.getInputStream());
		Scanner scan = new Scanner(System.in);
		while(true)
		{
			System.out.println("::::::::::::::::::::::::::::::::MENU::::::::::::::::::::::::::::::::::");
			System.out.println("1.Arithmetic Operations\n2.Logical Operations\n3.FileLookUpOperations");
			System.out.println("Enter the choice:");
			choice = scan.nextInt();
			switch(choice)
			{
				case 1: out.writeObject(1);
						System.out.println(in.readObject());
						break;
				case 2: out.writeObject(2);
						System.out.println(in.readObject());
						break;
				case 3: out.writeObject(3);
						System.out.println(in.readObject());
						break;
				default: System.out.println("Invalid Option");
						 break;
			}
		}
	}
}
