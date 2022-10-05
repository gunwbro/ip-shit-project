<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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
<title>Insert title here</title>
</head>
<body>
	<%
	request.setCharacterEncoding("utf-8");

	String epKey = request.getParameter("id");
	// mariaDB 준비
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("mariadb 사용가능");

	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD = "1234";
	// mariaDB 연결
	Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	// 쿼리
	PreparedStatement stmt = conn.prepareStatement("DELETE FROM episode WHERE epKey=?"); // ?표현식 : 변수자리
	stmt.setString(1, epKey);

	System.out.println(stmt);

	// 쿼리 실행
	stmt.executeUpdate();

	
	response.sendRedirect("wtSubmit.jsp");

	conn.close(); // DB 종료
	%>
</body>
</html>