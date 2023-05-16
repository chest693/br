<%@ page session="true" buffer="none" contentType="text/html; charset=utf-8"%>
<%@ page import="kr.or.chest.br.receipt.dto.UserDto"%>
<%@ include file="/include/taglib.h"%>

<%------------------------------------------------------------------------
JSP Tracert Log
--------------------------------------------------------------------------%>
<% 
String PGM_ID   = "tmpTop";
String JSP_NAME = "/WEB-INF/jsp/portalMain/"+PGM_ID+".jsp";
String JSP_DESC = "포탈메인 Top";

UserDto user = (UserDto) request.getSession().getAttribute("userInfo");

if(user==null){
%>
<script type="text/javascript">
	alert("세션이 종료되었습니다.");
    location.href = "/";
</script>
<%	
}
%>
<script type="text/javascript">
var maxSessionTime = "<%= request.getSession().getMaxInactiveInterval() %>";
//var maxSessionTime = 60*2;
var sessionMin;
var sessionSec = 60;
var sessionIntervalId;
window.onload = function(){ 
	scl_el.lodingHide(window); //로딩이미지
}

$(document).ready(function(){
//	var name = navigator.appName;
//	IE old version ( IE 10 or Lower )
//	if ( name == "Microsoft Internet Explorer" ) {
//		$('#ieUpgrade').show();
//	}
    sessionIntervalId = setInterval('timeCheck();', 1000);
});

function timeCheck() {
    if(maxSessionTime==0) {
		alert('세션이 종료되었습니다.');
		clearInterval(sessionIntervalId);
		fn_logout();
		return false;
    }
		sessionSec--;
		maxSessionTime = maxSessionTime-1;
		sessionMinute = Math.floor(maxSessionTime/60);
		
		if(sessionMinute==NaN) sessionMinute=0;
		
		if(sessionMinute < 10){
			$('#sessionTime').text(sessionMinute+'분 '+sessionSec+'초 후에 로그아웃됩니다.');
		}
		
		if(sessionSec==0) {
		  sessionSec = 60;
	}
}


//------------------------------------
//로그아웃
//------------------------------------
function fn_logout(){
    location.href = "/logout.do";
}

//------------------------------------
//CONTENTs 열기
//------------------------------------
function fn_openBody(_url){
	$.ajax({
		url: '/sessionChk.do',
		method : 'post',
		dataType : 'json',
		success: function(data){
			//정상 전송되었을 경우 처리
			if (data.resultCode == "S") {
			    location.href = _url;
			}else{
				alert(data.resultMsg);
			    location.href = "/login";
			}
		}
	});
}

function goHome(){
	$.ajax({
		url: '/sessionChk.do',
		method : 'post',
		dataType : 'json',
		success: function(data){
			//정상 전송되었을 경우 처리
			if (data.resultCode == "F") {
			    location.href = "/login";
			}
		}
	});
}
</script>
<!--   
<div id="ieUpgrade" style="width:100%;height:50px; display:none; vertical-align:middle; text-align:center;border: 1px solid #7E9ECC; background: #E2ECFF; text-align: center; clear: both; ">
<h3>사용하시는 인터넷브라우저를 11버전으로 업그레이드 후에 이용하시기 바랍니다.</h3>
</div>
-->
<div id="loadingBar"><img src="/images/loading_2.GIF" id="loading-image" /></div><div id="unloadingBar"></div>
<div class="top" id="top">
	<div class="header">
	    <div class="logo">
	        <a href="javascript:goHome()"><img src="/images/receipt/logo.png" alt="기부확인서발급시스템" /></a>
	    </div>
	    <div class="private">
	        <span class="user_txt"><c:out value='${userInfo.sptdpstnNm}'/></span> 님 환영합니다. 
	        <span class="btn_type_02" onClick="javascript:fn_logout();">로그아웃</span>
	    </div>
	    <div class="private" style="margin-top:35px">
        	<span id="sessionTime"></span>  
	    </div>
	</div>
	<div class="navi">
	    <div class="topnav">
	    
			<c:if test='${userInfo.userSeCode eq "1"}'>
	        <div class="menu">  
	            <div class="menu01 gn01"  onclick="javascript:fn_openBody('/receipt/receiptApply.do');">기탁서접수</div>    
	        </div>  
	        <div class="menu">  
	            <div class="menu01 gn02"  onclick="javascript:fn_openBody('/receipt/receiptList.do');">접수내역</div>   
	        </div>
	        <div class="menu">  
	            <div class="menu01 gn02"  onclick="javascript:fn_openBody('/receipt/transList.do');">접수내역전송</div>   
	        </div>    
	        <div class="menu">  
	            <div class="menu01 gn02"  onclick="javascript:fn_openBody('/receipt/depositList.do');">입금내역</div>   
	        </div>
			</c:if>
			<c:if test='${userInfo.userSeCode eq "2"}'>
	        <div class="menu">  
	            <div class="menu01 gn02"  onclick="javascript:fn_openBody('/receipt/depositList.do');">입금내역</div>   
	        </div>    
			</c:if>
			<c:if test='${userInfo.userSeCode eq "3"}'>
	        <div class="menu">  
	            <div class="menu01 gn01"  onclick="javascript:fn_openBody('/receipt/receiptApply.do');">기탁서접수</div>    
	        </div>  
	        <div class="menu">  
	            <div class="menu01 gn02"  onclick="javascript:fn_openBody('/receipt/receiptList.do');">접수내역</div>   
	        </div>
	        <div class="menu">  
	            <div class="menu01 gn02"  onclick="javascript:fn_openBody('/receipt/transList.do');">접수내역전송</div>   
	        </div>    
			</c:if>
	    </div>    
	</div>
</div>
</div>