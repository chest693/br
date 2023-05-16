<%@ page session="true" buffer="none" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/taglib.h"%>
<html>
<link rel="stylesheet" type="text/css" href="/css/login_style.css" />
<script type="text/javascript">

function success( obj ) {
	var sname = obj.sName;
	var mobileNo = obj.sMobileNo;
	var result = obj.result;
	var birth = obj.sBirthDate;	//생년월일
	var a,b,c,m = mobileNo;
	
	$("#result").val(result);

	setCookie('popupInfoBr', 'close',{expires:1});
    jQuery('div.notice_pop').hide();
    
}

function fail() {
	alert("본인인증이 실패하였습니다.");
}


//쿠키적용 20150903
function setCookie(cName, cValue){
	var todayDate = new Date();
	todayDate.setHours(24);
	document.cookie = cName + "=" + escape(cValue) + "; path=/; expires=" + todayDate.toGMTString() + ";";
}
//쿠키적용 20150903

//쿠키설정
function setCookie(cName, cValue, cDay){
	var expire = new Date();
	expire.setDate(expire.getDate() + cDay);
	cookies = cName + '=' + escape(cValue) + '; path=/ ';
	if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;
}
function getCookie(cName){
	cName = cName + '=';
	var cookieData = document.cookie;
	var start  = cookieData.indexOf(cName);
	var cValue = '';
	if(start != -1){
		var end = cookieData.indexOf(';', start);
		if(end == -1) end = cookieData.length;
		cValue = cookieData.substring(start, end);
	}
	return unescape(cValue);
}


$(window).load(function(){
	//쿠키설정
	if(!getCookie('popupInfoBr')){
		//if (getToday() < "20220207") {
//	    	jQuery('div.notice_pop').show(0);
		//}
	}	
});

$(document).ready(function() {
	$(document).on("click", "#btnReq", function () {
		fnSubmit();
	})

    $("#hidden_noti_top").click(function(){
    	if($('input:checkbox[id="oneday"]').is(":checked")){
    		setCookie('popupInfoBr', 'close',{expires:1});
    	}
    });

})

function validate(){
	if($("#id").val()=="") {
		alert("아이디를 입력해주세요.");
		$("#id").focus();
		return false;
	}

	if($("#pwd").val()=="") {
		alert("비밀번호를 입력해주세요.");
		$("#pwd").focus();
		return false;
	}
	
	return true;
}

function fnSubmit() {
	if(validate()){
		login();
	}	
}

function login() {
    var params = {
            id : $("#id").val(), 
            pwd:$("#pwd").val()
        };
	$.ajax({
		url: '/login.do',
		method : 'post',
		dataType : 'json',
		data: params,
		success: function(data){
			//정상 전송되었을 경우 처리
			if (data.resultCode == "S") {
				location.href = "/receipt/receiptApply.do";
			} else {
				alert(data.resultMsg);
			}
		}
	});
}       
       
//--------------------------------------
//엔터키 입력 받아 submit 실행하기
//--------------------------------------
function key_check(chkkey) {
	var keyCode = event.keyCode ;
	if(keyCode==13){
		fnSubmit();
	}else{
		return;
	}
}

function getToday(){
    var now = new Date();
    var year = now.getFullYear();
    var month = now.getMonth() + 1;    //1월이 0으로 되기때문에 +1을 함.
    var date = now.getDate();

    month = month >=10 ? month : "0" + month;
    date  = date  >= 10 ? date : "0" + date;
     // ""을 빼면 year + month (숫자+숫자) 됨.. ex) 2018 + 12 = 2030이 리턴됨.

    //console.log(""+year + month + date);
    return today = ""+year + month + date; 
}

</script>
<body id="main">
	<div id="wrapper">
		<div class="login-page">
			<div class="title"  ><a><img src="/images/logo.png"></a></div>
			  <div class="form">
			    <h1>사회복지 공동모금회 업무지원 시스템<br/>
			    <span>LOGIN</span></h1>
			      <input type="text" id="id" name="id" value="" onKeyPress="key_check(this.value)" placeholder="아이디를 입력해주세요"/>
			      <input type="password" id="pwd" name="pwd" value="" onKeyPress="key_check(this.value)" placeholder="비밀번호를 입력해주세요"/>
			      <button id="btnReq"><img src="/images/btn_icon.png" width="110" height="110" /></button>
			  </div>
		</div>
	</div>
</body>	
<input type="hidden" name="result" id="result" value="N" />
<jsp:include page="popup/noticePop.jsp" flush="false" />
</html>