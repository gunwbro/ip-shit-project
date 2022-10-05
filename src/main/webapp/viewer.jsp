<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="myBean.Webtoon"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" href="viewer.css">
<title>웹툰</title>
</head>
<body>
	<%
	request.setCharacterEncoding("utf-8");
	%>
	<%
	String wtKey = request.getParameter("id");
	String no = request.getParameter("no");
	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD = "1234";

	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;
	ResultSet brs = null;
	ResultSet ars = null;
	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	stmt = con.createStatement();

	String query = "SELECT * FROM episode e left join episode_file ef on e.epKey=ef.epKey where type='file' and e.wtKey="
			+ wtKey + " and e.no=" + no;
	String bq = "SELECT * FROM episode e left join episode_file ef on e.epKey=ef.epKey where type='file' and e.wtKey="
			+ wtKey + " and e.no=" + Integer.toString(Integer.parseInt(no) - 1);
	String aq = "SELECT * FROM episode e left join episode_file ef on e.epKey=ef.epKey where type='file' and e.wtKey="
			+ wtKey + " and e.no=" + Integer.toString(Integer.parseInt(no) + 1);
	rs = stmt.executeQuery(query);
	brs = stmt.executeQuery(bq);
	ars = stmt.executeQuery(aq);
	%>
	<div class="wrap">
		<%
		if (rs.next()) {
		%>
		<div class="header">
			<div class="backBtn"
			onclick="location='epList.jsp?id=<%=wtKey%>'">
				<img class="backBtnIcon" src="./icon/left-arrow.png"
					alt="back button">
			</div>
			<h1 class="title">
				<%=no%>.
				<%=rs.getString("title")%>
			</h1>
		</div>
		<div class="content">
			<img class="epView" src=<%=rs.getString("location")%>>
		</div>
		<div class="wbar">
			<div class="wbar-content">
				<div>
					<%
					if (brs.next()) {
					%>
					<img class="leftBtnIcon" src="./icon/left-arrow.png"
						alt="back button"
						onclick="location='viewer.jsp?id=<%=wtKey%>&no=<%=Integer.toString(Integer.parseInt(no) - 1)%>'">
					<%
					}
					%>
				</div>
				<div>
					<%
					if (ars.next()) {
					%>
					<img class="rightBtnIcon" src="./icon/right-arrow.png"
						alt="back button"
						onclick="location='viewer.jsp?id=<%=wtKey%>&no=<%=Integer.toString(Integer.parseInt(no) + 1)%>'">
					<%
					}
					%>
				</div>
			</div>
		</div>
		<%
		}
		%>
	</div>
</body>

</html>