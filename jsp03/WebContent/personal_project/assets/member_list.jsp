<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<style type="text/css">
			.hideBorder {
				border: 0;
			}
			.hide {
				display: hidden; 
			}
			#memberListTable{
				max-height: 100px;
				overflow-y: auto;
			}
			
		</style>
		<%@ include file="./include/header.jsp" %>
		<script>
			function userEditList(num) {
				var memberListUserid = document.getElementById("memberListUserid" + num);
				var memberListName = document.getElementById("memberListName" + num);
				var memberSelect = document.getElementById("memberSelect" + num);
				var submitUserEdit = document.getElementById("submitUserEdit" + num);
				// memberListUserid.classList.toggle('hideBorder');
				memberListUserid.readOnly = false;
				memberListUserid.style.cssText = "border: 1px solid #000; color: blue;";
				memberListName.readOnly = false;
				memberListName.style.cssText = "border: 1px solid #000; color: blue;";
				memberSelect.disabled = false;
				submitUserEdit.style.cssText = "display: inline-block; border: 1px solid #000; color: blue;";
				submitUserEdit.classList.remove("hide");
			}
			function submitUserEdit(num) {
				var memberListUserid = document.getElementById("memberListUserid" + num);
				var beforeUserid = document.getElementById("beforeUserid" + num);
				var memberListName = document.getElementById("memberListName" + num);
				var memberSelect = document.getElementById("memberSelect" + num);
				var sesseionMember_rank = document.getElementById("sesseionMember_rank" + num);
				if (confirm("수정하시겠습니까?")) {
					var param = {
							"userid": memberListUserid.value, 
							"beforeUserid": beforeUserid.value, 
							"name" : memberListName.value,
							"member_rank" : memberSelect.value,
							"sesseionMember_rank": sesseionMember_rank.value
							}
					console.log(param);
					$.ajax({
						type: 'post',
						url: '${path}/personal_project_servlet/updateMember.do',
						data: param,
						success: function(result) {
							$('#memberList').html(result);
						}
					}); // ajax
				}
			}
			
		</script>
	</head>
	<body>
		<table class="table" id="memberListTable">
			<tr>
				<td>아이디</td>
				<td>이름</td>
				<td>회원등급</td>
				<td>가입일자</td>
				<td></td>
			</tr>
			<c:forEach var="dto" items="${memberList}" varStatus="memberlistNumber">
				<tr>
					<td>
						<input class="listInput hideBorder" id="memberListUserid${memberlistNumber.count}" value="${dto.userid}" readonly="readonly">
						<input type="hidden" id="beforeUserid${memberlistNumber.count}" value="${dto.userid}" disabled="disabled">
					</td>
					<td><input class="listInput hideBorder" id="memberListName${memberlistNumber.count}" value="${dto.name}" readonly="readonly"></td>
					<%-- <td>
					<c:choose>
						<c:when test="${dto.member_rank == 3}">
							어드민
						</c:when>
						<c:when test="${dto.member_rank == 2}">
							관리자
						</c:when>
						<c:when test="${dto.member_rank == 1}">
							일반회원
						</c:when>
						<c:otherwise>
							-
						</c:otherwise>
					</c:choose>
					</td> --%>
					<td>
						<select name="member_rank" id="memberSelect${memberlistNumber.count}" disabled="disabled">
							<c:choose>
								<c:when test="${dto.member_rank == 3}">
									<option selected="selected" value="3">어드민</option>
									<option value="2">관리자</option>
									<option value="1">일반회원</option>
								</c:when>
								<c:when test="${dto.member_rank == 2}">
									<option selected="selected" value="2">관리자</option>
									<option value="1">일반회원</option>
								</c:when>
								<c:when test="${dto.member_rank == 1}">
									<option value="2">관리자</option>
									<option selected="selected" value="1">일반회원</option>
								</c:when>
								<c:otherwise>
									<option selected="selected" value="0">-</option>
								</c:otherwise>
							</c:choose>
						</select>
					</td>
					<td>${dto.join_date}</td>
					<c:choose>
						<c:when test="${sessionScope.member_rank == 3}">
							<c:if test="${dto.member_rank == 3}">
								<td></td>
							</c:if>
							<c:if test="${dto.member_rank <= 2}">
								<td>
									<input type="hidden" id="sesseionMember_rank${memberlistNumber.count}" value="${sessionScope.member_rank}">
									<input type="button" id="userEdit${memberlistNumber.count}" value="수정" onclick="userEditList('${memberlistNumber.count}')">
									<input type="button" class="hide" id="submitUserEdit${memberlistNumber.count}" value="확인" onclick="submitUserEdit('${memberlistNumber.count}')">
								</td>
							</c:if>
						</c:when>
						<c:otherwise>
							<td></td>
						</c:otherwise>
					</c:choose>
				</tr>
			</c:forEach>
		</table>
	</body>
</html>