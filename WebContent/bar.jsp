<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Bar Page</title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get the bar name from the request
			String bar_name = request.getParameter("barName");
			//Make a SELECT query to load the table with values from the selected bar
			String str = "SELECT b.drinker, ROUND(SUM(b.total_price),2) as totalSpent FROM bills b WHERE b.bar="+"'"+bar_name+"'"+" GROUP BY b.drinker ORDER BY totalSpent DESC LIMIT 10;";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
		<tr>    
			<td>Top 10 Spenders At: <% out.println(bar_name); %> </td>
		</tr>
		<tr>
			<th>Drinker</th>
			<th>Total Spent ($)</th>
		</tr>
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td>
						<a href="drinker.jsp?drinker=<%=result.getString("drinker")%>"><%= result.getString("drinker") %></a>
					</td>
					<td>
						<%= result.getString("totalSpent") %>
					</td>
				</tr>
				<%} %>
	</table>
		<% str="SELECT t.item, SUM(t.quantity) as totalOrders FROM transactions t, bills b WHERE b.bill_id=t.bill_id AND b.bar="+"'"+bar_name+"'"+" AND t.type='beer' GROUP BY t.item ORDER BY totalOrders DESC LIMIT 10;";
		result=stmt.executeQuery(str);
		%>
	<table>
		<tr>
			<td>Top 10 Beers At: <% out.println(bar_name); %> </td>
		</tr>
		<tr>
			<th>Beer</th>
			<th>Quantity Ordered</th>
		</tr>
			<%
			while (result.next()){%>
				<tr>
					<td>
						<%= result.getString("item") %>
					</td>
					<td>
						<%= result.getString("totalOrders") %>
					</td>
				</tr>
		<% } %>
	</table>
	<% str="SELECT b1.manf, SUM(t.quantity) as totalSold FROM beer b1, transactions t, bills b2 WHERE b2.bar="+"'"+bar_name+"'"+" AND b2.bill_id=t.bill_id AND t.item=b1.name GROUP BY b1.manf ORDER BY totalSold DESC LIMIT 5;";
		result=stmt.executeQuery(str);
		%>
	<table>
		<tr>
			<td>Top 5 Selling Manufacturers At: <% out.println(bar_name); %> </td>
		</tr>
		<tr>
			<th>Manufacturer</th>
			<th>Quantity Sold</th>
		</tr>
			<%
			while (result.next()){%>
				<tr>
					<td>
						<%= result.getString("manf") %>
					</td>
					<td>
						<%= result.getString("totalSold") %>
					</td>
				</tr>
		<% } %>
	</table>
	<form action="showGraph.jsp?graph=hourBarTransactions&barName=<%= bar_name %>" method="post">
			<input type="submit" value="Show Hourly Transactions of <%= bar_name %>">
	</form>
	<form action="showGraph.jsp?graph=dayBarTransactions&barName=<%= bar_name %>" method="post">
			<input type="submit" value="Show Daily Transactions of <%= bar_name %>">
	</form>
			<% //close the connection.
			db.closeConnection(con);
			%>

			
		<%} catch (Exception e) {
			out.print(e);
		}%>
	

	</body>
</html>