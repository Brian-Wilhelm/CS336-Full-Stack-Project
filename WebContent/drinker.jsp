<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Drinker Page</title>
	</head>
	<body>
		<% try {
	
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			//Get drinker's name from request
			String entity = request.getParameter("drinker");
			//Make a SELECT query to retrieve info from particular drinker
			String str = "SELECT b.bill_id, b.date, b.time, b.bar, b.items_price, b.tax_price, b.tip, b.total_price FROM bills b WHERE b.drinker=" + '"' + entity + '"' + " ORDER BY b.bar ASC, b.date ASC";
			//Run the query against the database.
			ResultSet result = stmt.executeQuery(str);
		%>
			
		<!--  Make an HTML table to show the results in: -->
	<table>
		<tr>    
			<td>Transactions For: <% out.println(entity); %> </td>
		</tr>
		<tr>
			<th>
				Bill ID
			</th>
			<th>
				Date
			</th>
			<th>
				Time
			</th>
			<th>
				Bar
			</th>
			<th>
				Item Price
			</th>
			<th>
				Tax Price
			</th>
			<th>
				Tip
			</th>
			<th>
				Total Price
			</th>
		</tr>
		
			<%
			//parse out the results
			while (result.next()) { %>
				<tr>    
					<td>
						<a href="showTransactions.jsp?transid=<%=result.getString("bill_id")%>"><%= result.getString("bill_id") %></a>
					</td>
					<td>
						<%= result.getString("date") %>
					</td>
					<td>
						<%= result.getString("time") %>
					</td>
					<td>
						<%= result.getString("bar") %>
					</td>
					<td>
						<%= result.getString("items_price") %>
					</td>
					<td>
						<%= result.getString("tax_price") %>
					</td>
					<td>
						<%= result.getString("tip") %>
					</td>
					<td>
						<%= result.getString("total_price") %>
					</td>
				</tr>
		<% } %>
		</table>
		<!-- Create buttons responsible for posting drinker name to graph page -->
		<form action="showGraph.jsp?graph=beersPerPerson&user=<%= entity %>" method="post">
			<input type="submit" value="Show Most Commonly Ordered Beers">
		</form>
		<form action="showGraph.jsp?graph=spendingPerWeek&user=<%= entity %>" method="post">
			<label for="bar_name">Enter a bar: </label>
			<input type="text" id="bar_name" name="bar_name">
			<input type="submit" value="Show Weekly Spending">
			<input type="submit" value="Show Monthly Spending" formaction="showGraph.jsp?graph=spendingPerMonth&user=<%= entity %>">
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