var btnHd = document.querySelector('#btnHd');
var hd = document.getElementById('hd');
btnHd.addEventListener('click', function() {
	hd.classList.toggle('extended');
});

function header_change() {
	if (document.getElementById('hd').className == '' || document.getElementById('hd').className == 'reduced') {
		document.getElementById('hd').className = 'extended';
	} else {
		document.getElementById('hd').className = 'reduced';
	}
} // header_change()

function header_animation() {
	document.getElementById("text1").innerHTML = "";
	document.getElementById("text2").innerHTML = "";
	document.getElementById('nav').style.display = "none";
	
	var text1 = '신입프로그래머 김용태';
	var delay = 150;
	var elem1 = document.getElementById('text1');
	//text- string
	//elem - jQuery element where text is to be attached
	//delay - the delay in each text
	var addTextByDelay = function (text, elem, delay) {
		
		if (!elem) {
			elem = document.getElementById('body');
		}
		if (!delay) {
			delay = 100;
		}
		if (text.length > 0) {
			//append first character
			elem.append(text[0]);
			setTimeout(function () {
				//Slice text by 1 character and call function again
				addTextByDelay(text.slice(1), elem, delay);
			}, delay);
		}
	};
	var text2 = 'JSP 개인 프로젝트 페이지입니다.';
	var elem2 = document.getElementById('text2');
	//text- string
	//elem - jQuery element where text is to be attached
	//delay - the delay in each text
	var addTextByDelay = function (text, elem, delay) {
		if (!elem) {
			elem = document.getElementById('body');
		}
		if (!delay) {
			delay = 100;
		}
		if (text.length > 0) {
			//append first character
			elem.append(text[0]);
			setTimeout(function () {
				//Slice text by 1 character and call function again
				addTextByDelay(text.slice(1), elem, delay);
			}, delay);
		}
	};

	function navbarShowUp() {
		setTimeout(function () {
			var nav = document.getElementById('nav');
			nav.style.display = 'inline';
		}, 3000);
	}
	
	addTextByDelay(text1, elem1, delay);
	addTextByDelay(text2, elem2, delay);
	navbarShowUp();
}
header_animation();
document.getElementById("login_out").innerHTML = 
document.getElementById("login_out").onclick = function () {login_out()};