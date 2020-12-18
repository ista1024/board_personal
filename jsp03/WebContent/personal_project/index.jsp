<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width-device-width, initial-scale=1.0" />
		<link href="https://fonts.googleapis.com/css2?family=Jua&display=swap" rel="stylesheet" />
		<link href="https://fonts.googleapis.com/css2?family=Gugi&family=Jua&display=swap" rel="stylesheet" />
		<link rel="stylesheet" href="style.css" />
		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" 
			integrity="sha384-HSMxcRTRxnN+Bdg0JdbxYKrThecOKuH5zCYotlSAcp1+c8xmyTe9GYg1l9a69psu" crossorigin="anonymous" />
		<link rel="stylesheet" href="./assets/css/main.css" />
		<%@ include file="./assets/include/header.jsp" %>
		<script src="https://code.jquery.com/jquery-3.5.1.js"></script>
		<script src="./assets/js/main.js"></script>
		<title>JSP 프로젝트</title>
	</head>
	<body>
		<div id="hd">
			<div id="header">
				<div id="title">
					<h2><span id="text1">신입프로그래머 김용태</span></h2>
					<h3 id="text2">JSP 개인 프로젝트 페이지입니다.</h3>
				</div>
				<nav id="nav">
					<button onclick="header_animation()" class="btn btn-default">헤더 애니메이션 다시보기</button>
					<button class="btn btn-default" id="btnHd">헤더 확장</button>
				</nav>
			</div>
			<video muted autoplay loop>
				<source src="./assets/css/cloud2.mp4" type="video/mp4" />
				<strong>Your browser does not support the video tag.</strong>
			</video>
		</div>
		<div id="header_padding"></div>
		<div id="wrapNav">
			<p>마우스 휠로 다양한 컨텐츠를 확인하세요</p>
			<table>
				<tr>
					<td>&lt;&lt;</td>
					<td id="navTd2"> </td>
					<td>&gt;&gt;</td>
				</tr>
			</table>
		</div>
		<div class="boxwrap">
			<div class="box 1">
				<p> 1 : 게시판 <button class="btn btn-default" onclick="deleteBoardConfirm()">게시판 초기화</button></p>
				<div id="box2">
				</div>
			</div>
			<div class="box 2">
				<p> 2 : 회원가입 및 로그인 <button class="btn btn-default" onclick="deleteMemberConfirm()">회원정보 초기화</button></p>
					<hr>
				<div id="login1">
					로그인
				</div>
				<div id="login2">
				</div>
			</div>
			<div class="box 3"><p> 3 : 컨텐츠 준비 중입니다.</p>
			</div>
			<!-- <div class="box 4"><p> 4</p></div> -->
		</div>
	</body>
	<script src="./assets/js/footer.js"></script>
</html>