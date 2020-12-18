<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<style type="text/css">
			input {
				margin: auto;
			}
			#commentReplyContent {
				width: 350px;
			}
			.tr {
				display: inline;
				padding: 0;
				margin: auto;
				display: none;
			}
		</style>
		<%@ include file="./include/header.jsp" %>
		<!-- <script src="./include/jquery-3.5.1.min.js"></script> -->
		<script type="text/javascript">
			function commentReplyForm(num) {
				var tr_num = "tr" + num;
				document.getElementById(tr_num).style.display = "block";
			}
			function hideReplyForm(num) {
				var tr_num = "tr" + num;
				var user_num = "cmUserid" + num;
				var comm_num = "commentReplyContent" + num;
				document.getElementById(user_num).value = "";
				document.getElementById(comm_num).value = "";
				document.getElementById(tr_num).style.display = "none";
			}
			function addCommentReply(num) {
				var tr_num = "tr" + num;
				var board_num = document.getElementById("board_num" + num).value;
				var comment_num = document.getElementById("comment_num" + num).value;
				var cm_userid = document.getElementById("cmUserid" + num);
				var cm_commentReplyContent = document.getElementById("commentReplyContent" + num);
				var check_member = document.getElementById("check_member" + num);
				var param = "board_num=" + board_num + "&comment_num=" + comment_num + "&userid=" + cm_userid.value + "&content=" + cm_commentReplyContent.value +"&check_member=" + check_member.value;
				$.ajax({
					type: "post",
					data: param,
					url: "${path}/personal_project_servlet/addCommentReply.do",
					success: function() {
						$(cm_userid).val("");
						$(cm_commentReplyContent).val("");
						document.getElementById(tr_num).style.display = "none";
						comment_list();
					}
				});
			}
		</script>
	</head>
	<body>
		<form method="POST" name="form${status.count}">
			<table border="1" width="700px">
				<c:forEach var="row" items="${list}" varStatus="status">
					<tr>
						<td>
							<c:forEach var="i" begin="1" end="${row.comment_re_level}">
								&nbsp;&nbsp;
							</c:forEach>
							<c:if test="${row.check_member == 'n'}">
								*
							</c:if>
							${row.userid}( <fmt:formatDate value="${row.reg_date}" pattern="yy-MM-dd hh:mm" />)
							${row.content}
						</td>
						<c:if test="${row.board_num > 11}">
						<td><input type="button" onclick="commentReplyForm('${status.count}')" value="대댓글"></td>
						</c:if>
					</tr>
					<tr class="tr" id="tr${status.count}">
						<td>
							<c:choose>
								<c:when test="${sessionScope.userid != null}">
									&nbsp;${sessionScope.userid}<input type="hidden" readonly id="cmUserid${status.count}" value="${sessionScope.userid}" >
									<input type="hidden" name="check_member" id="check_member${status.count}" value="y">
								</c:when>
								<c:otherwise>
									<input id="cmUserid${status.count}" placeholder="이름">
									<input type="hidden" name="check_member" id="check_member${status.count}" value="n">
								</c:otherwise>
							</c:choose>
							<input type="hidden" id="board_num${status.count}" value="${row.board_num}">
							<input type="hidden" id="comment_num${status.count}" value="${row.comment_num}">
							<input id="commentReplyContent${status.count}" placeholder="내용을 입력하세요">
						</td>
						<td><button type="button" id="btnSaveComment${status.count}" onclick="addCommentReply('${status.count}')">확인</button>
							<button type="button" onclick="hideReplyForm('${status.count}')">취소</button>
						</td>
					</tr>
				</c:forEach>
			</table>
		</form>
	</body>
</html>