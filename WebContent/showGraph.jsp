<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<% 
	StringBuilder myData=new StringBuilder();
	String strData ="";
    String chartTitle="";
    String legend="";
	try{
		//this list will hold the x-axis and y-axis data as a pair
		ArrayList<Map<String,Integer>> list = new ArrayList();
   		Map<String,Integer> map = null;
   		//Get the database connection
   		ApplicationDB db = new ApplicationDB();	
   		Connection con = db.getConnection();		

   		//Create a SQL statement
   		Statement stmt = con.createStatement();
   		
   		String graphType = request.getParameter("graph");
   		//Make a query depending on the graph type
   		String query = "" ;
   		String user=request.getParameter("user");
   		if(graphType.equals("beersPerPerson")){
   	   		query = "SELECT t.item, SUM(t.quantity) as num_beers FROM bills b, transactions t WHERE b.bill_id=t.bill_id AND t.type='beer' AND b.drinker="+"'"+user+"'"+" GROUP BY t.item ORDER BY num_beers desc;";
   		}else if(graphType.equals("spendingPerWeek")){
   			String bar_name=request.getParameter("bar_name");
   	   		query = "SELECT d.dayname, a.day_total FROM days d LEFT JOIN (SELECT b.day, FORMAT(SUM(b.total_price),2) as day_total FROM bills b WHERE b.bar="+"'"+bar_name+"'"+" AND b.drinker="+"'"+user+"'"+" GROUP BY b.day) a ON d.dayname=a.day ORDER BY FIELD(d.dayname, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');";
   		}else if(graphType.equals("spendingPerMonth")){
   			String bar_name=request.getParameter("bar_name");
   			query="SELECT m.idmonth, g.totalSpending FROM months m LEFT JOIN(SELECT DATE_FORMAT(b.date,'%M') as idmonth, SUM(b.total_price) as totalSpending FROM bills b WHERE b.drinker="+"'"+user+"'"+" AND b.bar="+"'"+bar_name+"'"+" GROUP BY idmonth) g ON g.idmonth=m.idmonth ORDER BY FIELD(m.idmonth, 'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER');";
   		}else if(graphType.equals("hourBarTransactions")){
   			String bar_name=request.getParameter("barName");
   			query="SELECT HOUR(b.time) as timeOfDay, count(b.bill_id) as hourTransactions FROM bills b WHERE b.bar="+"'"+bar_name+"'"+" GROUP BY timeOfDay ORDER BY timeOfDay ASC;";
   		}else if(graphType.equalsIgnoreCase("dayBarTransactions")){
   			String bar_name=request.getParameter("barName");
   			query="SELECT d.dayname, count(b.bill_id) as dayTransactions FROM days d LEFT JOIN bills b ON b.day=d.dayname WHERE b.bar="+"'"+bar_name+"'"+" GROUP BY d.dayname ORDER BY FIELD(d.dayname, 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');";
   		}else{
   			String beer_name=request.getParameter("beer");
   			query="SELECT m.idmonth, SUM(a.totalBought) as totalPurchases FROM months m LEFT JOIN(SELECT MONTHNAME(b.date) as idmonth, SUM(t.quantity) as totalBought FROM bills b LEFT JOIN transactions t ON t.bill_id=b.bill_id WHERE t.item="+"'"+beer_name+"'"+" GROUP BY b.drinker) a ON a.idmonth=m.idmonth GROUP BY m.idmonth ORDER BY FIELD(m.idmonth, 'JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER', 'NOVEMBER', 'DECEMBER');";
   		}
   		
   		//Run the query against the database.
   		ResultSet result = stmt.executeQuery(query);
   		//Process the result
   		while (result.next()) {
   			map=new HashMap<String,Integer>();
   			if(graphType.equalsIgnoreCase("beersPerPerson")){
   	   			map.put(result.getString("item"),result.getInt("num_beers"));
   	   		}else if(graphType.equalsIgnoreCase("spendingPerWeek")){
   	   			map.put(result.getString("dayname"),result.getInt("day_total"));
   	   		}else if(graphType.equalsIgnoreCase("spendingPerMonth")){
   	   			map.put(result.getString("idmonth"),result.getInt("totalSpending"));
   	   		}else if(graphType.equalsIgnoreCase("hourBarTransactions")){
   	   			map.put(result.getString("timeOfDay"),result.getInt("hourTransactions"));
   	   		}else if(graphType.equalsIgnoreCase("dayBarTransactions")){
   	   			map.put(result.getString("dayname"),result.getInt("dayTransactions"));
   	   		}else{
   	   			map.put(result.getString("idmonth"),result.getInt("totalPurchases"));
   	   		}
   			list.add(map);
   	    } 
   	    result.close();
   	    
   	    //Create a String of graph data of the following form: ["X-value1", Y-Value1],["X-value2",Y-Value2],...
        for(Map<String,Integer> hashmap : list){
        		Iterator it = hashmap.entrySet().iterator();
            	while (it.hasNext()) { 
           		Map.Entry pair = (Map.Entry)it.next();
           		String key = pair.getKey().toString().replaceAll("'", "");
           		myData.append("['"+ key +"',"+ pair.getValue() +"],");
           	}
        }
        strData = myData.substring(0, myData.length()-1); //remove the last comma
        
        //Create the chart title according to what the user selected
        if(graphType.equalsIgnoreCase("beersPerPerson")){
          chartTitle = "Number of beers drank by " + user;
          legend = "beers";
        }else if(graphType.equalsIgnoreCase("spendingPerWeek")){
            chartTitle = "Weekly Spending ($) for: "+user+" at "+request.getParameter("bar_name");
            legend="Weekly Spending";
        }else if(graphType.equalsIgnoreCase("spendingPerMonth")){
        	chartTitle = "Montly Spending ($) for: "+user+" at "+request.getParameter("bar_name");
        	legend="Monthly Spending";
        }else if(graphType.equalsIgnoreCase("hourBarTransactions")){
        	chartTitle = "Transactions per Hour of Day for: "+request.getParameter("barName");
        	legend = "Number of Transactions During Hour of Day";
        }else if(graphType.equalsIgnoreCase("dayBarTransactions")){
        	chartTitle = "Transactions per Day of Week for: "+request.getParameter("barName");
        	legend = "Number of Transactions During Day of Week";
        }else{
        	chartTitle = "Transactions per Month For: "+request.getParameter("beer");
        }
	}catch(SQLException e){
    		out.println(e);
    }
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Graphs</title>
		<script src="https://code.highcharts.com/highcharts.js"></script>
		<script> 
		
			var data = [<%=strData%>]; //contains the data of the graph in the form: [ ["X1", Y1],["X2",Y2],...]
			var title = '<%=chartTitle%>'; 
			var legend = '<%=legend%>';
			//this is an example of other kind of data
			//var data = [["01/22/2016",108],["01/24/2016",45],["01/25/2016",261],["01/26/2016",224],["01/27/2016",307],["01/28/2016",64]];
			var cat = [];
			data.forEach(function(item) {
			  cat.push(item[0]);
			});
			document.addEventListener('DOMContentLoaded', function () {
			var myChart = Highcharts.chart('graphContainer', {
			    chart: {
			        defaultSeriesType: 'column',
			        events: {
			            //load: requestData
			        }
			    },
			    title: {
			        text: title
			    },
			    xAxis: {
			        text: 'xAxis',
			        categories: cat
			    },
			    yAxis: {
			        text: 'yAxis'
			    },
			    series: [{
			        name: legend,
			        data: data
			    }]
			});
			});
		
		</script>
	</head>
	<body>

	<div id="graphContainer" style="width: 500px; height: 400px; margin: 0 auto"></div>



</body>
</html>