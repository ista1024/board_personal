<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- 
	1) JSTL(JSP Standard Tag Library, JSP 표준 태그 라이브러리)
	2) 사용 이유 : model1 은 JSP 페이지 중심, model2 는 java코드(서블릿, 모델) 분리
	3) JSP 웹페이지에서는 java코드를 안쓸 수 없기 때문에 최소화 하기 위해 JSTL과 EL기법을 사용
		복잡한 자바 코드를 대체하기 위한 태그
	4) taglib prefix="태그 접두어" uri="태그 라이브러리의 식별자"
	5) Core tag(핵심태그, 자주 사용되는 태그들) => 태그 접두어로 접근
		ex) prefix="c"
 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- c는 prefix="c"의 c를 의미 var="변수명" values="값"
String path = request.getContextPath();를 워낙 자주 쓰다보니 header에 넣고 include시킴
또한 위 코드보다 JSTL로 변환해서 쓰는 게 더 유용함 -->
<c:set var="path" value="${pageContext.request.contextPath}" />
