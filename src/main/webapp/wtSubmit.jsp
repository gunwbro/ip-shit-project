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
	String wtKey = request.getParameter("id");
	Class.forName("org.mariadb.jdbc.Driver");
	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD = "1234";

	Connection con = null;
	Statement stmt = null;
	ResultSet rs = null;
	ResultSet epRs = null;
	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	stmt = con.createStatement();

	String query = "SELECT * FROM webtoon";
	rs = stmt.executeQuery(query);
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
								onclick="location='deleteEpisode.jsp?id=<%=epRs.getString("epKey")%>'"></span>
							</li>
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
					<h2>웹툰 등록</h2>
				</div>
				<div class="body">
					<div class="blank"></div>
					<form action="insertWebtoon.jsp" method="POST"
						enctype="multipart/form-data">
						<div class="bodyElem">
							<div class="textBox">타이틀 :</div>
							<input class="titleValue" type="text" name="title">
						</div>
						<div class="bodyElem">
							<div class="textBox">장르 :</div>
							<select class="genre" name="genre">
								<option value="">장르 선택</option>
								<option value="일상">일상</option>
								<option value="공포">공포</option>
								<option value="순정">순정</option>
								<option value="개그">개그</option>
								<option value="미스테리">미스테리</option>
								<option value="판타지">판타지</option>
								<option value="스포츠">스포츠</option>
								<option value="액션">액션</option>

							</select>
						</div>
						<div class="bodyElem">
							<div class="textBox">작가명 :</div>
							<input class="authorValue" type="text" name="author">
						</div>
						<div class="bodyElem">
							<div class="textBox">작가의 말 :</div>
							<textarea class="authorTextValue" cols="35" rows="10"
								name="authorText"></textarea>
						</div>
						<div class="bodyElem">
							<div class="textBox">줄거리 :</div>
							<textarea class="summaryValue" cols="35" rows="10" name="summary"></textarea>
						</div>
						<div class="bodyElem">
							<div class="textBox">대표 이미지 :</div>
							<input class="img" type="file" name="img">
						</div>
						<div class="bodyElem">
							<div class="submitContent">
								<input type="submit" value="등록"
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