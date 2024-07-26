<%@page import="db.InitDB"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.temporal.ChronoUnit"%>
<%@page import="java.time.LocalTime"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import='java.sql.*'%>
<%@ page import='java.io.*'%>
<%@ page import='java.text.*'%>
<!doctype html>
<html lang="en">
<head>
<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet" href="bootstrap.min.css">
<link rel="stylesheet" href="style.css" />
<link rel="icon" href="images/favicon.png" />

<title>DashBoard</title>
</head>
<body>

	<!-- 	Navigation Bar -->
	<nav class="navbar navbar-expand-md navbar-dark bg-primary">
		<a class="navbar-brand" href="index.jsp">Park Me</a>
		<button class="navbar-toggler" type="button" data-toggle="collapse"
			data-target="#collapsingNavbar">
			<span class="navbar-toggler-icon"></span>
		</button>
		<div class="navbar-collapse collapse" id="collapsingNavbar">
			<ul class="navbar-nav">
				<li class="nav-item active"><a class="nav-link"
					href="dashboard.jsp">Dashboard <span class="sr-only">(current)</span>
				</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="rentmyspace.jsp">Rent my space</a></li>
				<li class="nav-item active"><a class="nav-link"
					href="parkmyvehicle.jsp">Park my vehicle</a></li>



			</ul>
			<%session = request.getSession();
			String email = (String)session.getAttribute("email");%>
			<ul class="navbar-nav ml-auto">
				<li class="nav-item active login-text"><a class="nav-link"
					href="<%if(email == null) out.println("login.jsp"); %>"> <%out.println(email); %>
				</a></li>
			</ul>
		</div>
	</nav>

	<!--Dash Board Contents  -->
	<nav class="navbar" style="margin-top: auto; padding: 10px;">
		<ul class="nav nav-tabs">
			<li class="nav-item"><a class="nav-link" href="dashboard.jsp">My
					Cars</a></li>
			<li class="nav-item"><a class="nav-link" href="myparking.jsp">My
					Parking</a></li>
			<li class="nav-item"><a class="nav-link active"
				href="currentparking.jsp">Current Parking</a></li>
			<li class="nav-item"><a class="nav-link"
				href="parkinghistory.jsp">Parking History</a></li>
		</ul>
	</nav>


	<p class="badge badge-primary" style="margin: 10px;">Current Parked
		Cars</p>

	<div class='container align-items-center border-bottom pt-5' style="">
		<div class='row'>
			<%
			Connection con = InitDB.getConnection();
			Cookie[] cookies = request.getCookies();
			Cookie cookie = null;
			String userId = null;
			
	
			if( cookies != null ) {
				for (int i = 0; i < cookies.length; i++) {
					cookie = cookies[i];
					if(cookie.getName().equals("userId")) {
						userId = cookie.getValue();
					}
				}
			} 
			try {
				if(userId != null) {
					PreparedStatement statement = con.prepareStatement("SELECT * FROM booking WHERE userId = ? AND completion = 0");
					statement.setString(1, userId);
					
					ResultSet rs = statement.executeQuery();
					while (rs.next()) {
						LocalDateTime dateTime = LocalDateTime.of(rs.getDate("datePlaced").toLocalDate(), rs.getTime("timePlaced").toLocalTime());
						String dateT = dateTime.plusHours(Long.parseLong(rs.getString("hour"))).toString();
						String time[] = dateT.split("T");
						
						out.println(
								"<div class='card h-100 ' style='width: 20rem; margin: 10px;'><img src=");
						out.println("'GetCarImage?carId=" + rs.getString("carId") + "'" + " class='card-img-top' style='height : 212px;' alt='...'><div class='card-body'><h5 class='card-title'>");
						out.println("Parking Amount :: " + rs.getString("price") + "</h5>");
						out.println("<p class='text-primary'>Date Parking Ends :-" + time[0] + " </p>");
						out.println("<p class='text-primary'>Time Parking Ends :-" + time[1] + " </p>"); 
						out.println("<a href='UnPark?carId="+ rs.getString("carId") + "' class='btn btn-primary'>UnPark</a> </div></div>");
						
					}
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				con.close();
			}
				
			%>
		</div>
	</div>


	<script type="text/javascript" src="js/dashboard.js"></script>
	<!-- Optional JavaScript -->
	<!-- jQuery first, then Popper.js, then Bootstrap JS -->
	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
		integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
		integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
		crossorigin="anonymous"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
		integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
		crossorigin="anonymous"></script>
</body>
</html>