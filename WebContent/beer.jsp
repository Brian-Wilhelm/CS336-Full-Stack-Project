<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Beer Page</title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the selected beer from request
			String beer_name = request.getParameter("beer");
			//Make a SELECT query for the selected beer
			String str = "SELECT b.bar, SUM(t.quantity) as totalSold FROM bills b LEFT JOIN transactions t ON t.bill_id=b.bill_id WHERE t.item="+"'"+beer_name+"'"+" GROUP BY b.bar ORDER BY totalSold DESC LIMIT 5;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
		<tr>    
			<td>Top Selling Bars For: <% out.println(beer_name); %> </td>
		</tr><tr>
			<th>Bar</th>
			<th>Quantity Sold</th>
		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td>
						<%= result.getString("bar") %>
					</td>
					<td>
						<%= result.getString("totalSold") %>
					</td>
				</tr>
		<% } %>
		</table>
		<%
			str="SELECT b.drinker, SUM(t.quantity) as totalBought FROM bills b LEFT JOIN transactions t ON t.bill_id=b.bill_id WHERE t.item="+"'"+beer_name+"'"+" GROUP BY b.drinker ORDER BY totalBought DESC LIMIT 10;";
			result = stmt.executeQuery(str);
		%>
		<table>
		<tr>    
			<td>Top 10 Drinkers of <% out.println(beer_name); %> </td>
		</tr>
		<tr>
			<th>Beer</th>
			<th>Quantity Sold</th>
		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td>
						<%= result.getString("drinker") %>
					</td>
					<td>
						<%= result.getString("totalBought") %>
					</td>
				</tr>
		<% } %>
		</table>
		<form action="showGraph.jsp?graph=beerStat&beer=<%= beer_name %>" method="post">
			<input type="submit" value="Show Beer Orders by Month">
		</form>
		<%
			//close the connection.
			db.closeConnection(con);
			%>

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>