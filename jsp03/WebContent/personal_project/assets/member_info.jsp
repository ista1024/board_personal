<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<%@ include file="./include/header.jsp" %>
		<script>
			function memberList() {
				var listUserid = document.getElementById("listUserid").value;
				var member_rank = document.getElementById("listMember_rank").value;
				var param = {"userid":listUserid, "member_rank":member_rank};
				$.ajax({
					data: param,
					url: "${path}/personal_project_servlet/memberList.do",
					success: function(result) {
						$("#memberList").html(result);
					}
				});
			}
		</script>
	</head>
	<body>
		<c:if test="${sessionScope.userid != null}">
			<div>
				<c:if test="${sessionScope.member_rank >= 2}">
					<button type="button" class="btn btn-default" onclick="memberList()">관리자용 회원 목록</button>
					<input type="hidden" id="listMember_rank" value="${sessionScope.member_rank}">
				</c:if>
				<table class="table">
					<tr>
						<td>아이디</td>
						<td>이름</td>
						<td>회원등급</td>
						<td>가입일자</td>
					</tr>
					<tr>
						<td>${sessionScope.userid}<input type="hidden" id="listUserid" value="${sessionScope.userid}"></td>
						<td>${sessionScope.name}</td>
						<c:choose>
							<c:when test="${sessionScope.member_rank == 3}">
								<td>어드민</td>
							</c:when>
							<c:when test="${sessionScope.member_rank == 2}">
								<td>관리자</td>
							</c:when>
							<c:when test="${sessionScope.member_rank == 1}">
								<td>일반회원</td>
							</c:when>
						</c:choose>
						<td>${sessionScope.join_date}</td>
					</tr>
				</table>
			</div>
		</c:if>
		<div id="memberList">
		</div>
	</body>
</html>