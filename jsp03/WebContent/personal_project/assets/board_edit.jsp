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
				$("#btnList").click(function(){
					$.ajax({
						url: "${path}/personal_project_servlet/boardList.do",
						success: function(result) {
							$("#box2").html(result);
						}
					});
				});
				$("#btnDeleteBoard").click(function() {
					var param = $("form").serialize();
					if (confirm("삭제하시겠습니까?")) {
						$.ajax({
							data: param,
							url: "${path}/personal_project_servlet/deleteBoard.do",
							success: function() {
								location.reload();
							}
						});
						
						// location.href = "${path}/personal_project_servlet/deleteBoard.do?num=${dto.num}";
						// document.formEdit.action = "${path}/personal_project_servlet/deleteBoard.do";
						// document.formEdit.submit();
					}
				});
			});
		</script>
	</head>
	<body>
		<h2>수정</h2>
		<form id="formBoardEdit" name="formBoardEdit" action="${path}/personal_project_servlet/updateBoard.do" method="post" enctype="multipart/form-data">
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
					<td><input name="subject" id="subject" size="60" value="${dto.subject}"></td>
				</tr>
				<tr>
					<td>본문</td>
					<td><textarea rows="5" cols="60" name="content" id="content">${dto.content}</textarea></td>
				</tr>
				<tr>
					<td>첨부파일</td>
					<td>
						<c:if test="${dto.filesize > 0}">
							${dto.filename} (${dto.filesize / 1024} KB)
							<input type="checkbox" name="fileDel">첨부파일 삭제<br>
						</c:if>
						<input type="file" name="file1" id="file1">
					</td>
				</tr>
				<c:choose>
					<c:when test="${sessionScope.userid != null}">
						<input name="passwd" id="passwd" value="${sessionScope.passwd}" readonly type="hidden">
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
					<td colspan="2" align="center">
						<input type="hidden" name="num" value="${dto.num}">
						<button>수정</button>
						<input type="button" value="삭제" id="btnDeleteBoard">
						<input type="button" value="목록" id="btnList">
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>