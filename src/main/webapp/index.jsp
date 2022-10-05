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
<link rel="stylesheet" href="index.css">
<title>웹툰</title>
</head>

<body>
	<%
	request.setCharacterEncoding("utf-8");
	String genre = request.getParameter("genre");
	String search = request.getParameter("search");
	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD = "1234";

	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;

	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	stmt = con.createStatement();

	String query = null;
	query = "SELECT * FROM webtoon w LEFT JOIN webtoon_image wi on w.wtKey=wi.wtKey ";

	System.out.println("장르:" + genre);
	System.out.println("검색:" + search);

	if (genre != null && search != null) {
		query += "where genre='" + genre + "'";
		query += "&& title LIKE " + "'%" + search + "%'";
	} else if (genre != null && search == null) {
		query += "where genre='" + genre + "'";
	} else if (search != null && genre == null) {
		query += "where title LIKE " + "'%" + search + "%'";
	}
	System.out.println(query);
	rs = stmt.executeQuery(query);
	System.out.println(stmt);
	%>
	<jsp:useBean id="webtoon" class="myBean.Webtoon" scope="page" />
	<jsp:setProperty name="webtoon" property="*" />
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
			<%
			System.out.println(search);
			if (search == null) {
			%>
			<div class="menuBar">
				<div class="menuElem" onclick="location='index.jsp?genre=일상'">
					<div>일상</div>
				</div>
				<div class="menuElem" onclick="location='index.jsp?genre=공포'">
					<div>공포</div>
				</div>
				<div class="menuElem" onclick="location='index.jsp?genre=순정'">
					<div>순정</div>
				</div>
				<div class="menuElem" onclick="location='index.jsp?genre=개그'">
					<div>개그</div>
				</div>
				<div class="menuElem" onclick="location='index.jsp?genre=미스테리'">
					<div>미스테리</div>
				</div>
				<div class="menuElem" onclick="location='index.jsp?genre=판타지'">
					<div>판타지</div>
				</div>
				<div class="menuElem" onclick="location='index.jsp?genre=스포츠'">
					<div>스포츠</div>
				</div>
				<div class="menuElem" onclick="location='index.jsp?genre=액션'">
					<div>액션</div>
				</div>
			</div>
			<%
			}
			%>
		</div>
		<div class="content">
			<div class="webtoons">
				<%
				while (rs.next()) {
				%>
				<div class="webtoon wt1"
					onclick="location='epList.jsp?id=<%=rs.getString("wtKey")%>'">
					<div class="webtoonImg">
						<img src=<%=rs.getString("location")%> alt="thumbnail"
							style="width: 100%; height: 100%">
					</div>
					<div class="webtoonTitle"><%=rs.getString("title")%></div>
					<div class="webtoonAuthor"><%=rs.getString("Author")%>
					</div>
				</div>
				<%
				}
				%>
			</div>
		</div>
	</div>
	<div class="content">
		<div class='webtoons'></div>
	</div>
	</div>

</body>

</html>