<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Modification Status</title>
	</head>
	<body>
	
	<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Make a string with the query to update the database
			String str = request.getParameter("modificationQuery");
			//Run the modification against the database
			stmt.executeUpdate(str); %>
			<!-- If update is successful, display -->
			Success! Update Successfully Processed!
		
		<%
			//close the connection.
			db.closeConnection(con);
			%>

			
		<%} catch (Exception e) {
			//If update is failure due to foreign key violation, display error.
			out.println("Foreign Key Violation!");
		}%>

</body>
</html>