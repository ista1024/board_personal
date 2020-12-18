<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<script src="../include/jquery-3.5.1.min.js"></script>
	</head>
	<body>
		<script>alert('<%=request.getAttribute("result") %>');</script>
	</body>
</html>