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
	String saveFolder = context.getRealPath("files/episode");

	Part thumbnail = request.getPart("thumbnail");
	Part file = request.getPart("file");

	String thumbnailFileName = thumbnail.getSubmittedFileName();
	String fileFileName = file.getSubmittedFileName();

	if (thumbnailFileName != null && thumbnailFileName.length() != 0) {
		thumbnail.write(saveFolder + File.separator + thumbnailFileName);
	}
	if (fileFileName != null && fileFileName.length() != 0) {
		file.write(saveFolder + File.separator + fileFileName);
	}
	String wtKey = request.getParameter("id");
	String title = request.getParameter("title");
	String startAt = request.getParameter("startAt");
	String no = request.getParameter("no");
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
			"insert into episode(title,no,startAt,createdAt,updatedAt,wtKey) values(?,?,?,?,?,?)",
			Statement.RETURN_GENERATED_KEYS); // ?표현식 : 변수자리
	stmt.setString(1, title);
	stmt.setString(2, no);
	stmt.setString(3, startAt);
	stmt.setString(4, currentTime);
	stmt.setString(5, currentTime);
	stmt.setString(6, wtKey);
	System.out.println(stmt);

	// 쿼리 실행
	stmt.executeUpdate();
	ResultSet rs = stmt.getGeneratedKeys();
	if (rs.next()) {
		int id = rs.getInt(1);
		stmt = conn.prepareStatement(
		"insert into episode_file(name, location, size, createdAt, updatedAt, epKey, type) values(?,?,?,?,?,?,?)"); // ?표현식 : 변수자리
		stmt.setString(1, thumbnailFileName);
		stmt.setString(2, "./files/episode/" + thumbnailFileName);
		stmt.setString(3, Long.toString(thumbnail.getSize()));
		stmt.setString(4, currentTime);
		stmt.setString(5, currentTime);
		stmt.setInt(6, id);
		stmt.setString(7, "thumbnail");
		System.out.println(stmt);

		// 쿼리 실행
		stmt.executeUpdate();

		stmt = conn.prepareStatement(
		"insert into episode_file(name, location, size, createdAt, updatedAt, epKey, type) values(?,?,?,?,?,?,?)"); // ?표현식 : 변수자리
		stmt.setString(1, fileFileName);
		stmt.setString(2, "./files/episode/" + fileFileName);
		stmt.setString(3, Long.toString(file.getSize()));
		stmt.setString(4, currentTime);
		stmt.setString(5, currentTime);
		stmt.setInt(6, id);
		stmt.setString(7, "file");
		System.out.println(stmt);

		// 쿼리 실행
		stmt.executeUpdate();
		response.sendRedirect("wtSubmit.jsp");
	}
	conn.close(); // DB 종료
	%>
</body>
</html>