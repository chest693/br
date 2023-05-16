<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script language="javascript">
$(document).ready(function(){
    $(".close_pop").click(function(event){
        jQuery('div.notice_pop').hide();
    });
    
    $(document).on("click", "#checkPlus", function(e){
        e.preventDefault();
        
       	window.name='mainPopup';
       	
    	fnPopup();
    });

    /*===========================================================
     * 휴대폰 본인인증
     *===========================================================*/
    /***
     * 본인인증 팝업 호출
     * @returns
     */
    function fnPopup(){
    	console.log( "chest_user fnPopup call" );
    	window.open('/popup/nicePopup.do', 'popupChk', 'width=500, height=550, top=100, left=100, fullscreen=no, menubar=no, status=no, toolbar=no, titlebar=yes, location=no, scrollbar=no');
    }
    
});
</script>

<style>
	.container:before,.container:after{display:table;content:" "}
	.container:after{clear:both}.row{margin-right:0px;margin-left:0px}
	@media(min-width:320px){.container{max-width:100%}
</style>

    <div class="notice_pop"  style="display:none;" id="notice_pop">
	<div class="pop_bg"></div>
	<div class="pop_up" id="main">
    <div id="noticeform" class="container">
    	<div class="cont" id="cont">
    		<div class="row">
    			<div class="top"><img src="/images/receipt/logo_mem.png" /></div>
    			<!--  
    			<div class="close_bt"><img src="/images/pop_close_bt.png"  class="close_pop"/></div>
    			-->
    		</div>
    		<div class="row">
	    		<div class="cont_form">
	    			<div class="title">
	    				<h4><b>공지사항</b></h4>
	    			</div>
	    			<div class="sub_txt">

<h4><b>○ 휴대폰 인증 추가 안내</b></h4><br><br><br>
<div style="margin-left:20px">
<font size="3"><b>
최근 중국발 해킹대상 사이트에 모금회 사이트가 대상으로 지목되었습니다.<br><br><br> 
 
이에 보건복지부 관제센터의 보안강화조치 권고에 따라 <br><br>
 
사이트 접속전 휴대폰인증을 통해 정상적인 접속만 로그인이 가능하도록 보완하였습니다.<br><br><br> 
 
휴대폰인증을 통한 추가인증은 별도의 개인정보를 저장하지 않으며,  <br><br>
 
인증기관에서 회신하는 정상여부만 체크합니다. <br><br><br>
 
따라서 휴대폰인증 후 로그인을 진행해주시기 바라며, 사이트 접근이 불편하시더라도<br><br> 
 
보안강화를 위한 조치에 여러분들의 양해를 부탁드립니다 <br><br><br>
 
감사합니다.<br><br>

</b></font>
</div>
<!--
<font size="3"><b>
정기점검이 아래와 같이 예정되어 있습니다.<br><br>
점검시간 동안 서비스 이용이 불가능합니다.<br><br>
작업상황에 따라 종료시간은 변경될 수 있습니다.<br><br><br><br>

점검일시 : 2022년 2월 4일(금) 22:00 ~ 2022년 2월 6일(일) 18:00<br><br>
점검내용 : [점검]서버 점검 및 업데이트<br><br>

</b></font>
-->
	    			</div>
	            <div class="title" align="center">
                   <span class="btn_type_01_big" id="checkPlus"><font size=4>휴대폰인증</font></span>
				</div>
				<!--  
	            <div class="title" align="right">
		    		<input type="checkbox" id="oneday" name="oneday"><font color='#333333'> 하루동안 열지 않음</font>
		    		<a href="#" id="hidden_noti_top"><img src='/img/icon_03.gif' border='0' class="close_pop"></a>
				</div>
				-->
	    		</div>
    		</div>
    	</div>
    </div>
    </div>
    </div>
