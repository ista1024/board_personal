<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<%@ include file="./include/header.jsp" %>
		<!-- <script src="./include/jquery-3.5.1.min.js"></script> -->
		<style type="text/css">
			#commentList {
				width: 700px;
				height: 200px;
				overflow-x: hidden;
				overflow-y: auto;
			}
		</style>
		<script type="text/javascript">
			$(function() {
				comment_list();
				$("#btnSaveComment").click(function() {
					comment_add();
				});
				$("#btnList").click(function(){
					$.ajax({
						url: "${path}/personal_project_servlet/boardList.do",
						success: function(result) {
							$("#box2").html(result);
						}
					});
				});
				$("#btnEdit").click(function(){
					var param = "board_num=${dto.num}&passwd=" + $("#passwd").val();
				    $.ajax({
				        type: 'POST',
				        url: "${path}/personal_project_servlet/boardPass_check.do",
				        data: param,
				        success: function (result) {
				        	$("#box2").html(result);
				        }
				    });
				});
				$("#btnReply").click(function(){
					var param = $("form").serialize();
					$.ajax({
				        type: 'POST',
				        url: "${path}/personal_project_servlet/boardReply.do",
				        data: param,
				        success: function (result) {
				        	$("#box2").html(result);
				        }
				    });
				});
				$("#btnDeleteByManager").click(function() {
					var param = $("form").serialize();
					if (confirm("관리자 권한으로 삭제하시겠습니까?")) {
						$.ajax({
							data: param,
							url: "${path}/personal_project_servlet/deleteBoardByManager.do",
							success: function() {
								location.reload();
							}
						});
					}
				});
			});
			function comment_list() {
				var board_num = document.getElementById("board_num").value;
				var path = "${path}/personal_project_servlet/commentList.do?board_num=" + board_num;
				// 백그라운드로 서버 호출
				$.ajax({
					type: "post",
					url: "${path}/personal_project_servlet/commentList.do?board_num=" + board_num,
					success: function(result) {
						$("#commentList").html(result);
					}
				});
			}
			
			function comment_add() {
				var board_num = document.getElementById("board_num").value;
				var param = "board_num=" + board_num + "&userid=" + $("#userid").val() + "&content=" + $("#content").val() + "&check_member=" + $("#commentCheck_member").val();
				$.ajax({
					type: "post",
					url: "${path}/personal_project_servlet/addComment.do",
					data: param,
					success: function() {
						$("#content").val("");
						comment_list();
					}
				});
			}
			
		</script>
	</head>
	<body>
		<h2>content 상세화면</h2>
		<form name="formBoard" id="formBoard" method="post">
			<table border="1" width="700px">
				<tr>
					<td>날짜</td>
					<td>${dto.reg_date}</td>
					<td>조회수</td>
					<td>${dto.readcount}</td>
				</tr>
				<tr>
					<td>이름</td>
					<td colspan="3">
						<c:if test="${dto.check_member == 'n'}">
									*
						</c:if>
						${dto.userid}
					</td>
				</tr>
				<tr>
					<td>제목</td>
					<td colspan="3">${dto.subject}</td>
				</tr>
				<tr>
					<td>본문</td>
					<td colspan="3">${dto.content}</td>
				</tr>
				<c:choose>
					<c:when test="${sessionScope.userid == dto.userid}">
						<input type="hidden" name="passwd" id="passwd" value="${sessionScope.passwd}" readonly>
					</c:when>
					<c:otherwise>
						<tr>
							<c:if test="${dto.num > 11}">
								<td>비밀번호</td>
								<td colspan="3"><input type="password" name="passwd" id="passwd">
									<c:if test="${param.message == 'error'}">
										<span style="color:red;">비밀번호가 일치하지 않습니다.</span>
									</c:if>
								</td>
							</c:if>
						</tr>
					</c:otherwise>
				</c:choose>
				<tr>
					<td>첨부파일</td>
					<td colspan="3">
						<c:if test="${dto.filesize > 0}">
							${dto.filename}(${dto.filesize} bytes)
							<a href="${path}/personal_project_servlet/download.do?num=${dto.num}">[다운로드]</a>
						</c:if>
					</td>
				</tr>
				<tr>
					<td colspan="4" align="center">
						<c:if test="${dto.num > 11}">
							<c:choose>
								<c:when test="${sessionScope.userid == dto.userid}">
									<input type="button" id="btnEdit" value="수정/삭제">
								</c:when>
								<c:otherwise>
									<c:if test="${dto.check_member == 'n'}">
										<input type="button" id="btnEdit" value="수정/삭제">
									</c:if>
								</c:otherwise>
							</c:choose>
							<input type="button" id="btnReply" value="답변달기">
						</c:if>
						<input type="hidden" id="board_num" name="num" value="${dto.num}">
						<input type="button" id="btnList" value="목록">
						<c:if test="${dto.num > 11}">
							<c:if test="${sessionScope.member_rank >= 2}">
								<input type="button" id="btnDeleteByManager" value="관리자 삭제">
							</c:if>
						</c:if>
					</td>
				</tr>
			</table>
		</form>
		<br>
		<!-- 댓글 쓰기 폼 -->
		<c:if test="${dto.num > 11}">
			<table width="700px">
				<tr>
					<td>
						<c:choose>
							<c:when test="${sessionScope.userid != null}">
								&nbsp;${sessionScope.userid}<input type="hidden" readonly id="userid" value="${sessionScope.userid}">
								<input type="hidden" name="commentCheck_member" id="commentCheck_member" value="y">
							</c:when>
							<c:otherwise>
								<input id="userid" placeholder="이름">
							</c:otherwise>
						</c:choose>
					</td>
					<td rowspan="2"><button id="btnSaveComment">확인</button></td>
				</tr>
				<tr>
					<td><textarea rows="2" cols="60" id="content" placeholder="댓글을 입력하시려면 내용을 입력하세요"></textarea></td>
				</tr>
			</table>
		</c:if>
		<!-- 댓글 목록을 출력할 영역 -->
		<div id="commentList"></div>
	</body>
</html>