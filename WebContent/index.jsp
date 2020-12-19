<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Bar Beer Drinker Main Page</title>
	</head>
	<body>
		
		<br>
		<br>
		View a Drinker's Transactions
		<form action="drinker.jsp" method="get">
		<input type="text" id="drinker" name="drinker">
		<input type="submit" value="View a Drinkers Transactions">
		</form>
		<br>
		<br>
		View Information About a Bar
		<form action="bar.jsp" method="get">
		<input type="text" id="barName" name="barName">
		<input type="submit" value="View a Bar">
		</form>
		<br>
		<br>
		View A Beer
		<form action="beer.jsp" method="get">
		<input type="text" id="beer" name="beer">
		<input type="submit" value="View a Beer">
		</form>
		<br>
		Make A Modification to the Database
		<form action="modify.jsp" method="get">
		<input type="submit" value="Make a Modification">
		</form>

</body>
</html>