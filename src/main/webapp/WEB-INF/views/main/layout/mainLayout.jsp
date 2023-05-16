<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
<%@ include file="/include/taglib.h"%>


<!DOCTYPE html>
<html lang="ko">

	<head>
		<link rel="icon" href="images/favicon.ico" />
		<link rel="stylesheet" type="text/css" href="/css/chest.css" />
	
		<script src="http://code.jquery.com/jquery-latest.js"></script>
		<script src='/js/jsit.js'></script>
		<script src="/js/common.js"></script>
	
		<!-- jquery-->
		<script src='/js/jquery-1.11.3.min.js'></script>
		<script src='/js/jquery.ui.core.js'></script>
		<script src='/js/jquery-ui.js'></script>
		
		<!-- mask -->
		<script src="/js/mask/jquery.inputmask.bundle.min.js"></script>
		<script src="/js/mask.js"></script>
		
		<!-- jquery-validation script & i18n -->
		<script src="/js/validate/jquery.validate.min.js"></script>
		<script src="/js/validate/i18n/messages_ko.js"></script>
		
		<script src="/js/hashMap.js"></script>
	
		<!-- daum 우편번호검색 -->
		<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
		
		<!-- BASE64암호화 -->
		<script src="/js/webtoolkit.base64.js"></script>
		

	<meta charset="UTF-8">
	<title>사랑의열매</title>
	<!--<meta name="viewport" content="width=device-width, initial-scale=1.0">-->
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
    
	</head>
	<body>
		<section class="content">
			<tiles:insertAttribute name="header"/> <!--  /WEB-INF/views/common/layout/header.jsp -->
			<tiles:insertAttribute name="body"/> <!-- body -->
			
			<tiles:insertAttribute name="footer"/> <!-- /WEB-INF/views/common/layout/footer.jsp -->
		</section>
	</body>
</html>