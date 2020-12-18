<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		<%@ include file="./include/header.jsp" %>
		<style type="text/css">
			.hideButton {
				display: none; 
			}
		</style>
		<script type="text/javascript">
			function hideLoginTable() {
				document.getElementById('loginTable').style.display = 'none';
			}
			
			function showLoginTable() {
				document.getElementById('loginTable').style.display = 'block';
			}
			
			function boardListReload() {
				$.ajax({
					url: '${path}/personal_project_servlet/boardList.do',
					success: function(result) {
						$('#box2').html(result);
					}
				});
			}
			
			// 로그인
			function login_out() {
				var loginTable = document.getElementById('loginTable');
				var btnLogin = document.getElementById('btnLogin_out');
				var btnMemberInfo = document.getElementById('btnMemberInfo');
				var btnMemberList = document.getElementById('btnMemberList');
				if (btnLogin.classList.contains('login')) {
					$.ajax({
						url: '${path}/personal_project_servlet/logout.do',
						async: false,
						success: function() {
							$('#login2').html("");
							$('#login_result').html("");
							$('#loginUserid').val("");
							$('#loginPasswd').val("");
							loginTable.style.display = 'block';
							btnLogin.innerHTML = '로그인';
							btnLogin.classList.remove('login');
							btnMemberInfo.style.display = 'none';
							btnMemberList.style.display = 'none';
						}
					});
					boardListReload();
				}
				else {
					var userid = document.getElementById("loginUserid");
					var passwd = document.getElementById("loginPasswd");
					var login2 = document.getElementById("login2");
					if (userid.value == "") {
						alert('아이디를 입력하세요');
						userid.focus();
						return;
					} else if (passwd.value == "") {
						alert('비밀번호를 입력하세요');
						passwd.focus();
						return;
					} else {
						var param =	'userid=' +	userid.value + '&passwd=' + passwd.value;
						$.ajax({
							type: 'post',
							url: '${path}/personal_project_servlet/loginMember.do',
							async: false,
							data: param,
							success: function(result) {
								$('#login_result').html(result);
								if (result.indexOf('아이디 또는 비밀번호가') != -1) {
									
								} else {
									loginTable.style.display = 'none';
									btnLogin.innerHTML = '로그아웃';
									btnLogin.classList.toggle('login');
									btnMemberInfo.style.display = 'inline-block';
									btnMemberList.style.display = 'inline-block';
								}
							}
						}); // ajax
						boardListReload();
					}
				}
			} // login_out()
			
			function joinMember() {
				var reid = /^[a-zA-Z0-9]+$/; // 아이디가 적합한지 검사할 정규식
				var repw = /^[a-zA-Z0-9]{1,4}$/; // 비밀번호 유효성 검사식
				var userid = document.getElementById("joinUserid");
				var passwd = document.getElementById("joinPasswd");
				var name = document.getElementById("joinName");
				
				document.getElementById("join_result").innerHTML = "";
				
				if (userid.value == "") {
					alert('아이디를 입력하세요');
					userid.focus();
					return;
				} else if (passwd.value == "") {
					alert('비밀번호를 입력하세요');
					passwd.focus();
					return;
				} else if (name.value == "") {
					alert('이름을 입력하세요');
					name.focus();
					return;
				} else if(!check(reid, userid, "아이디는 0~9의 숫자와 영문자만 사용하실 수 있습니다.")) {
					return false;
				} else if(userid.value.length < 4 || userid.value.length > 11) {
					alert('아이디는 4~10자로 입력해주세요');
					userid.focus();
					return;
				} else if(!check(repw, passwd, "비밀번호를 1~4자까의 영문대소문자와 숫자로 입력해주세요.")) {
					return false;
				} else if (userid.value.indexOf(" ") >= 0) {
					alert("아이디에 공백을 사용할 수 없습니다.");
					userid.focus();
					userid.select();
					return false;
				} else if (passwd.value.indexOf(" ") >= 0) {
					alert("비밀번호에 공백을 사용할 수 없습니다.");
					userid.focus();
					userid.select();
					return false;
				} else if (name.value.length > 4) {
					alert('이름은 4자 이하로 입력해주세요');
					name.focus();
					return;
				} else {
					var param =	'userid=' +	userid.value + '&passwd=' + passwd.value + '&name=' + name.value;
					$.ajax({
						type: 'post',
						url: '${path}/personal_project_servlet/joinMember.do',
						data: param,
						success: function(result) {
							$('#join_result').html(result);
						}
					}); // ajax
				}
			} // joinMember()
			
		</script>
	</head>
	<body>
		로그인
		<c:choose>
			<c:when test="${sessionScope.userid != null}">
				<script type="text/javascript">hideLoginTable();</script>
			</c:when>
			<c:otherwise>
				<script type="text/javascript">showLoginTable();</script>
			</c:otherwise>
		</c:choose>
		<div id="loginTable">
			<form class="form-inline" name="form1" id="">
				<div class="form-group">
					<label class="sr-only" for="loginUserid">Id</label>
					<input type="text" class="form-control" id="loginUserid" placeholder="kim" />
				</div>
				<div class="form-group">
					<label class="sr-only" for="loginPasswd">Password</label>
					<input type="password" class="form-control" id="loginPasswd" placeholder="1234" />
				</div>
				<!-- <div class="checkbox">
					<label id="checkbox_label"> <input type="checkbox" /> Remember me </label>
				</div> -->
			</form>
		</div>
		<div id="login_result">
			<c:if test="${sessionScope.userid != null}">
				${sessionScope.name}님 환영합니다.
			</c:if>
		</div>
		<c:choose>
			<c:when test="${sessionScope.userid != null}">
				<button id="btnLogin_out" class="btn btn-default login" onclick="login_out()">로그아웃</button>
				<button id="btnMemberInfo" class="btn btn-default" onclick="showMemberInfo()">회원정보</button>
			</c:when>
			<c:otherwise>
				<button id="btnLogin_out" class="btn btn-default" onclick="login_out()">로그인</button>
				<button id="btnMemberInfo" class="btn btn-default hideButton" onclick="showMemberInfo()">회원정보</button>
			</c:otherwise>
		</c:choose>
		<hr>
		회원가입
		<form class="form-inline" name="form2" id="form2">
			<div class="form-group">
				<label class="sr-only" for="joinUserid">Id</label>
				<input type="text" class="form-control" id="joinUserid" placeholder="아이디" />
			</div>
			<div class="form-group">
				<label class="sr-only" for="joinPasswd">Password</label>
				<input type="password" class="form-control" id="joinPasswd" placeholder="비밀번호" />
			</div>
			<div class="form-group">
				<label class="sr-only" for="joinName">Name</label>
				<input type="text" class="form-control" id="joinName" placeholder="이름" />
			</div>
		</form>
		<div id="join_result"></div>
		<button class="btn btn-default" onclick="joinMember()">Sign in</button>
		<hr>
		<div id="deleteAllMember_result"></div>
	</body>
</html>