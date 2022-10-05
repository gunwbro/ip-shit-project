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
	ServletContext context = getServletContext();
	String saveFolder = context.getRealPath("files/thumbnail");

	Part part = request.getPart("img");

	String fileName = part.getSubmittedFileName();

	if (fileName != null && fileName.length() != 0) {
		part.write(saveFolder + File.separator + fileName);
	}
	System.out.println(fileName);
	String title = request.getParameter("title");
	String genre = request.getParameter("genre");
	String author = request.getParameter("author");
	String authorText = request.getParameter("authorText");
	String story = request.getParameter("summary");
	Date dt = new Date();
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	String currentTime = sdf.format(dt);
	// mariaDB 준비
	Class.forName("org.mariadb.jdbc.Driver");
	System.out.println("mariadb 사용가능");

	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD = "1234";
	// mariaDB 연결
	Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	// 쿼리
	PreparedStatement stmt = conn.prepareStatement(
			"insert into webtoon(title, genre, author, authorText, story,createdAt,updatedAt) values(?,?,?,?,?,?,?)",
			Statement.RETURN_GENERATED_KEYS); // ?표현식 : 변수자리
	stmt.setString(1, title);
	stmt.setString(2, genre);
	stmt.setString(3, author);
	stmt.setString(4, authorText);
	stmt.setString(5, story);
	stmt.setString(6, currentTime);
	stmt.setString(7, currentTime);
	System.out.println(stmt);

	// 쿼리 실행
	stmt.executeUpdate();
	ResultSet rs = stmt.getGeneratedKeys();
	if (rs.next()) {
		int id = rs.getInt(1);
		stmt = conn.prepareStatement(
		"insert into webtoon_image(name, location, size, createdAt, updatedAt,wtKey) values(?,?,?,?,?,?)"); // ?표현식 : 변수자리
		stmt.setString(1, fileName);
		stmt.setString(2, "./files/thumbnail/"+fileName);
		stmt.setString(3, Long.toString(part.getSize()));
		stmt.setString(4, currentTime);
		stmt.setString(5, currentTime);
		stmt.setString(6, Integer.toString(id));
		System.out.println(stmt);

		stmt.executeUpdate();
		// 쿼리 실행
		response.sendRedirect("wtSubmit.jsp");

	}
	conn.close(); // DB 종료
	%>
</body>
</html>