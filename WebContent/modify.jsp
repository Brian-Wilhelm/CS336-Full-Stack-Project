<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Modification Page</title>
	</head>
	<body>
		<% try { %>
			<!-- Enter a MySQL statement to modify the database with -->
			Enter MySQL Statement:
			<form action='makeMod.jsp' method='post'>
			<textarea id='modificationQuery' name='modificationQuery' rows='4' cols='50'></textarea>
			<input type='submit' id='modificationQuery' name='modificationQuery' value='Submit'>
			</form>
			
		<% } catch (Exception e) {
			out.print(e);
		}
		%>
	

	</body>
</html>