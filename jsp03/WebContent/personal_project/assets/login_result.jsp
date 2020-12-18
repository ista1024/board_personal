<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<%@ include file="./include/header.jsp" %>
	</head>
	<body>
		<c:choose>
			<c:when test="${sessionScope.userid == null}">
				<%=request.getAttribute("result") %>
			</c:when>
			<c:otherwise>
				${sessionScope.name}님 환영합니다.
			</c:otherwise>
		</c:choose>
		
	</body>
</html>
