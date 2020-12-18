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
			/*
			$(function() {
				$("#btnWrite").click(function() {
					$('#box2').html("${path}/personal_project/assets/board_write.jsp");
				});
			});
			*/
			
			document.getElementById("btnWrite").onclick = function () {
				$.ajax({
					url: '${path}/personal_project_servlet/write.do',
					success: function(result) {
						$('#box2').html(result);
					}
				});
			};
			
			function list(page){
				$.ajax({
					url: '${path}/personal_project_servlet/boardList.do?curPage=' + page,
					success: function(result) {
						$('#box2').html(result);
					}
				});
			}
			
			function viewBoard(num) {
				$.ajax({
					url: '${path}/personal_project_servlet/viewBoard.do?num=' + num,
					success: function(result) {
						$('#box2').html(result);
					}
				});
			}
			
			function searchBoard() {
				var param = $("#formSearchBoard").serialize();
				console.log(param);
				$.ajax({
					type: 'POST',
					data: param,
					url: '${path}/personal_project_servlet/searchBoard.do',
					success: function(result) {
						$('#box2').html(result);
					}
				});
			}
			
		</script>
	</head>
	<body>
		<form id="formSearchBoard" method="post">
			<select name="search_option">
				<option value="userid">이름</option>
				<option value="subject">제목</option>
				<option value="content">내용</option>
				<option value="all">이름+제목+내용</option>
			</select>
			<input name="keyword">
			<button type="button" id="btnSearchBoard" onclick="searchBoard()">검색</button>
		</form>
		<button id="btnWrite">글쓰기</button> 
		<span>* : 비회원  / </span>
		<span>
			현재 로그인 중인 아이디 : 
			<c:choose>
				<c:when test="${sessionScope.userid != null}">
					${sessionScope.userid}
				</c:when>
				<c:otherwise>
					* 비회원
				</c:otherwise>
			</c:choose>
		</span>
		<table border="1" width="900px" class="table-condensed">
			<tr>
				<th>번호</th>
				<th>이름</th>
				<th>제목</th>
				<th>날짜</th>
				<th>조회수</th>
				<th>첨부파일</th>
				<th>다운로드</th>
			</tr>
			<c:forEach var="dto" items="${boardList}">
				<c:choose>
					<c:when test="${dto.show == 'd'}">
						<tr>
							<td>${dto.num}</td>
							<td colspan="6" align="center">관리자에 의해 삭제된 게시물입니다.</td>
						</tr>
					</c:when>
					<c:when test="${dto.show == 'y'}">
						<tr>
							<td>${dto.num}</td>
							<td>
								<c:if test="${dto.check_member == 'n'}">
									*
								</c:if>
								${dto.userid}
							</td>
							<td>
								<!-- 답글 들여쓰기 -->
								<c:forEach var="i" begin="1" end="${dto.re_level}">
									&nbsp;&nbsp;
								</c:forEach>
								<a onclick="viewBoard(${dto.num})">${dto.subject}</a>
								<!-- 댓글갯수 표시 -->
								<c:if test="${dto.comment_count > 0}">
									<span style="color: red;">(${dto.comment_count})</span>
								</c:if>
							</td>
							<td>${dto.reg_date}</td>
							<td>${dto.readcount}</td>
							<td align="center">
								<c:if test="${dto.filesize > 0}">
									<a href="${path}/personal_project_servlet/download.do?num=${dto.num}">${dto.filename}
									<!-- <img src="./assets/css/attach-file.png"> --></a>
									<!-- <script>
										setTimeout('location.reload()', 100 * 1000); // 다운횟수를 100초마다 새로고침
									</script> -->
								</c:if>
							</td>
							<td>${dto.down}</td>
						</tr>
					</c:when>
					<c:otherwise>
						<tr>
							<td>${dto.num}</td>
							<td colspan="6" align="center">삭제된 게시물입니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<!-- 페이지 네비게이션 출력 -->	
			<tr>
				<td colspan="7" align="center">
					<c:if test="${page.curBlock > 1}">
						<a href="#" onclick="list('1')">[처음]</a>
					</c:if>
					<c:if test="${page.curBlock > 1}">
						<a href="#" 
							onclick="list('${page.prevPage}')">[이전]</a>
					</c:if>
					<c:forEach var="num" begin="${page.blockStart}"
						end="${page.blockEnd}">
						<c:choose>
							<c:when test="${num == page.curPage }">
								<span style="color:red;">${num}</span>
							</c:when>
							<c:otherwise>
								<a href="#" onclick="list('${num}')">${num}</a>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<c:if test="${page.curBlock < page.totBlock}">
						<a href="#" onclick="list('${page.nextPage}')">[다음]</a>
					</c:if>
					<c:if test="${page.curPage < page.totPage}">
						<a href="#" onclick="list('${page.totPage}')">[끝]</a>
					</c:if>
				</td>
			</tr>
		</table>
	</body>
</html>