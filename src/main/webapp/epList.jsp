<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="myBean.Webtoon"%>
<%@ page import="java.sql.DriverManager"%>
<%@ page import="java.sql.Connection"%>
<%@ page import="java.sql.Statement"%>
<%@ page import="java.sql.PreparedStatement"%>
<%@ page import="java.sql.ResultSet"%>
<%@page import="java.util.*,java.io.*,java.text.*"%>

<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<link rel="stylesheet" href="epList.css">
<title>웹툰</title>
</head>
<body>
	<%
	request.setCharacterEncoding("utf-8");
	%>
	<%
	String wtKey = request.getParameter("id");
	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD = "1234";
	Date dt = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String currentTime = sdf.format(dt);
	
	Connection con = null;
	Statement stmt = null;
	Statement epst = null;
	ResultSet rs = null;
	ResultSet eprs = null;
	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	stmt = con.createStatement();

	String query = "SELECT * FROM webtoon w LEFT JOIN webtoon_image wi on w.wtKey=wi.wtKey where w.wtKey=" + wtKey;
	String equery = "SELECT * FROM episode e LEFT JOIN episode_file ef on e.epKey=ef.epKey where e.startAt <= '" + currentTime +"' and e.wtKey=" + wtKey
			+ " and ef.type='thumbnail'" + " order by startAt desc";
	rs = stmt.executeQuery(query);
	eprs = stmt.executeQuery(equery);
	%>
	<div class="wrap">
		<div class="header">
			<div class="adminBtn" onclick="location='wtSubmit.jsp'">
				<img class="adminBtnIcon" src="./icon/icons8-edit-48.png"
					alt="admin button">
			</div>
			<div class="home-sb">
				<div class="home">
					<h1 onclick="location='index.jsp'" style="cursor: pointer">Webtoon</h1>
				</div>
				<form action="index.jsp" method="GET" style="display: flex">
					<input class="searchBar" type="text" name="search">
					<button class="searchBtn"
						style="border: 0; outline: 0; background-color: white;">
						<img class="searchBtnIcon" src="./icon/icons8-search-48.png"
							alt="search button">
					</button>
				</form>
			</div>
		</div>
		<div class="content">
			<div class="webtoons">
				<%
				if (rs.next()) {
				%>
				<div class="webtoon wt1">
					<div class="webtoonImg">
						<img src=<%=rs.getString("location")%> alt="thumbnail"
							style="width: 100%; height: 100%">
					</div>
					<div class="wt-information">
						<div class="title-name">
							<div class="webtoonTitle">
								<%=rs.getString("title")%>
							</div>
							<div class="webtoonAuthor">
								<%=rs.getString("author")%>
							</div>
						</div>
						<div class="summary">
							<%=rs.getString("story")%>
						</div>
						<div class="genre">
							<%=rs.getString("genre")%>
						</div>
					</div>
					<div class="authorText">
						<%=rs.getString("authorText")%>
					</div>
					<%
					}
					%>
				</div>
			</div>
			<div class="episodes">
				<%
				while (eprs.next()) {
				%>
				<div class="episode"
					onclick="location='viewer.jsp?id=<%=wtKey%>&no=<%=eprs.getString("no")%>'">
					<div class="episodeImg">
						<img src=<%=eprs.getString("location")%> alt="thumbnail"
							style="width: 100%; height: 100%">
					</div>
					<div class="episodeTitle"><%=eprs.getString("no")%>.
						<%=eprs.getString("title")%></div>
					<div><%=eprs.getString("startAt")%>
					</div>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</div>
</body>

</html>