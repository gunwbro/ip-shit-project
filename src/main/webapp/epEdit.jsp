<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<link rel="stylesheet" href="setting.css">
<title>관리자 페이지</title>
</head>

<body>
	<%
	String epKey = request.getParameter("id");
	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD = "1234";

	Connection con = null;
	Statement stmt = null;
	Statement epstmt = null;
	ResultSet rs = null;
	ResultSet epRs = null;
	ResultSet epr = null;
	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	stmt = con.createStatement();
	epstmt = con.createStatement();

	String query = "SELECT * FROM webtoon";
	String equery = "SELECT * FROM episode where epKey=" + epKey;
	rs = stmt.executeQuery(query);
	epr = epstmt.executeQuery(equery);

	%>
	<div class="wrap">
		<div class="left">
			<div class="blank"></div>
			<h1 onclick="location='index.jsp'">Webtoon</h1>
			<div class="wtSubmit" onclick="location='wtSubmit.jsp'">
				<h2>웹툰 등록</h2>
			</div>
			<ul class="wtList">
				<%
				while (rs.next()) {
					epRs = stmt.executeQuery("SELECT * FROM episode where wtKey=" + rs.getInt("wtKey") + " order by no DESC");
				%>
				<li class="webtoon"><span><%=rs.getString("title")%></span> <span><img
						class="wtBtn" src="./icon/icons8-edit-48.png" alt="search button"
						onclick="location='wtEdit.jsp?id=<%=rs.getString("wtKey")%>'"></span>
					<span><img class="wtBtn" src="./icon/icons8-trash-48.png"
						alt="search button"
						onclick="location='deleteWebtoon.jsp?id=<%=rs.getString("wtKey")%>'"></span>
					<ol class="episode" reversed style="list-style: none">
						<div class="newEp"
							onclick="location='epSubmit.jsp?id=<%=rs.getInt("wtKey")%>'">+</div>
						<%
						while (epRs.next()) {
						%>
						<li><span><%=epRs.getString("no")%>. <%=epRs.getString("title")%></span><span><img
								class="wtBtn" src="./icon/icons8-edit-48.png"
								alt="search button"
								onclick="location='epEdit.jsp?id=<%=epRs.getString("epKey")%>'"></span>
							<span><img class="wtBtn" src="./icon/icons8-trash-48.png"
								alt="search button"
								onclick="location='deleteEpisode.jsp?id=<%=epRs.getString("epKey")%>'"></span></li>
						<%
						}
						%>
					</ol></li>
				<%
				}
				%>
			</ul>
		</div>
		<div class="right">
			<div class="content">
				<div class="head">
					<h2>회차 수정</h2>
				</div>
				<div class="body">
					<div class="blank"></div>
					<form action="updateEpisode.jsp?id=<%=epKey%>" method="POST"
						enctype="multipart/form-data">
						<%	if (epr.next()) {
							
						 %>
						<div class="bodyElem">
							<div class="textBox">회차 제목 :</div>
							<input class="titleValue" type="text" name="title"
								value=<%=epr.getString("title")%>>
						</div>
						<div class="bodyElem">
							<div class="textBox ">등록일(yyyy-mm-dd) :</div>
							<input class="dateValue" type="text" name="startAt"
								value=<%=epr.getString("startAt")%>>
						</div>
						<div class="bodyElem">
							<div class="textBox">회차 :</div>
							<input class="titleValue" type="text" name="no"
								value=<%=epr.getString("no")%>>
						</div>
						<%} %>
						<div class="bodyElem">
							<div class="textBox">썸네일 :</div>
							<input class="thumbnail" type="file" name="thumbnail">
						</div>
						<div class="bodyElem">
							<div class="textBox">만화 파일 :</div>
							<input class="epFile" type="file" name="file">
						</div>
						<div class="bodyElem">
							<div class="submitContent">
								<input type="submit" value="수정"
									style="background-color: transparent; border: 0px transparent solid;">
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>

</body>
<script src="wtSubmit.js"></script>
</html>