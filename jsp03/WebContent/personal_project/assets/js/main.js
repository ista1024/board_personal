//var script = document.createElement('script');
//script.src = 'https://code.jquery.com/jquery-3.5.1.js';
//script.type = 'text/javascript';
//document.getElementsByTagName('head')[0].appendChild(script);

// 김용태 개인 프로젝트용 index header javascript 파일
// 유효성 검사
function check(re, what, message) {
	if(re.test(what.value)) {
		return true;
	}
	alert(message);
	what.focus();
	//return false;
}

window.onload = function () {
	// 게시판 로딩
	$.ajax({
		url: "/jsp03/personal_project_servlet/boardList.do",
		success: function(result) {
			$("#box2").html(result);
		}
	});
	
	// 로그인 페이지 로딩
	$("#login1").load("assets/login.jsp");
	
	// 마우스 휠 시 페이지단위 이동
	var elm = '.box';
	$(elm).each(function (index) {
		// 개별적으로 Wheel 이벤트 적용
		$(this).on('mousewheel DOMMouseScroll', function (e) {
			e.preventDefault();
			var delta = 0;
			if (!event) event = window.event;
			if (event.wheelDelta) {
				delta = event.wheelDelta / 120;
				if (window.opera) delta = -delta;
			} else if (event.detail) delta = -event.detail / 3;
			var moveTop = $(window).scrollLeft();
			var elmSelecter = $(elm).eq(index);
			// 마우스휠을 위에서 아래로
			if (delta < 0) {
				if ($(elmSelecter).next() != undefined) {
					try {
						moveTop = $(elmSelecter).next().offset().left;
					} catch (e) {}
				}
				// 마우스휠을 아래에서 위로
			} else {
				if ($(elmSelecter).prev() != undefined) {
					try {
						moveTop = $(elmSelecter).prev().offset().left;
					} catch (e) {}
				}
			}

			// 화면 이동 0.6초(600)
			$('html,body').stop().animate({
					scrollLeft: moveTop + 'px',
				},
				{
					duration: 600,
					complete: function () {},
				}
			);
		});
	});
};

function deleteMemberConfirm() {
	document.getElementById("deleteAllMember_result").innerHTML = "";
	if (confirm("초기화 하시겠습니까?")) {
		$.ajax({
			url: '/jsp03/personal_project_servlet/deleteAllMember.do',
			success: function() {
				document.getElementById("deleteAllMember_result").innerHTML = "kim을 제외한 모든 회원정보가 삭제되었습니다.";
			}
		}); // ajax
	};
} // deleteMemberConfirm()

function deleteBoardConfirm() {
	if (confirm("초기화 하시겠습니까?")) {
		document.getElementById("box2").innerHTML = "";
		$.ajax({
			url: '/jsp03/personal_project_servlet/deleteAllBoard.do',
			success: function(result) {
				$('#box2').html(result);
			}
		}); // ajax
	};
}

function showMemberInfo() {
	$("#login2").load("assets/member_info.jsp");
}