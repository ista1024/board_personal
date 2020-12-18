<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<%@ include file="./include/header.jsp" %>
		<!-- <script src="./include/jquery-3.5.1.min.js"></script> -->
		<script type="text/javascript">
			$(function() {
				//$("#btnBoardSave").click(function() {
				//	document.form1.submit();
				//	window.location.href = "${path}/personal_project/index.jsp";
				//});

				$("#btnList").click(function() {
					$.ajax({
						url: "${path}/personal_project_servlet/boardList.do",
						success: function(result) {
							$("#box2").html(result);
						}
					});
				});
			});
		</script>
	</head>
	<body>
		<h2>글쓰기</h2>
		<form name="formBoardWrite" method="post" action="${path}/personal_project_servlet/insertBoard.do" enctype="multipart/form-data">
			<table border="1" width="700px">
				<tr>
					<td>이름</td>
					<td>
						<c:choose>
							<c:when test="${sessionScope.userid != null}">
								&nbsp;${sessionScope.userid}<input name="userid" id="userid" value="${sessionScope.userid}" readonly type="hidden">
							</c:when>
							<c:otherwise>
								<input name="userid" id="userid">
							</c:otherwise>
						</c:choose>
					</td>
				</tr>
				<tr>
					<td>제목</td>
					<td><input name="subject" id="subject" size="60"></td>
				</tr>
				<tr>
					<td>본문</td>
					<td><textarea rows="5" cols="60" name="content" id="content"></textarea></td>
				</tr>
				<tr>
					<td>첨부파일</td>
					<td><input type="file" name="file1" id="file1"></td>
				</tr>
				<c:choose>
					<c:when test="${sessionScope.userid != null}">
						<input name="passwd" id="passwd" value="${sessionScope.passwd}" readonly type="hidden">
						<input name="check_member" id="check_member" value="y" readonly type="hidden">
					</c:when>
						<c:otherwise>
							<tr>
								<td>비밀번호</td>
								<td>
								<input type="password" name="passwd" id="passwd">
								</td>
							</tr>
						</c:otherwise>
					</c:choose>
				<tr>
					<td colspan="2" align="center"><button>확인</button>&nbsp;&nbsp;<input type="button" value="목록" id="btnList"></td>
				</tr>
			</table>
		</form>
	</body>
</html>