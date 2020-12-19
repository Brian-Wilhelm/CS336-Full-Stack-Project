<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Transaction Page</title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the transaction id from link on table
			String entity = request.getParameter("transid");
			//Make a SELECT query of all bills with selected transaction id
			String str = "SELECT * FROM transactions t WHERE t.bill_id=" + '"' + entity + '"';
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
		<tr>    
			<td>Transaction: <% out.println(entity); %> </td>
		</tr>
		<tr>
			<th>Item Purchased</th>
			<th>Quantity</th>
			<th>Price</th>
		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td>
						<%= result.getString("item") %>
					</td>
					<td>
						<%= result.getString("quantity") %>
					</td>
					<td>
						<%= result.getString("price") %>
					</td>
				</tr>
				

			<% }
			//close the connection.
			db.closeConnection(con);
			%>
		</table>

			
		<% } catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>