<%@ page session="true" buffer="none" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/taglib.h"%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="/css/layout_notice.css" />
<meta http-equiv=Content-Type content="text/html; charset=utf-8">
<script language="javascript">
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

function success( obj ) {
	var sname = obj.sName;
	var mobileNo = obj.sMobileNo;
	var result = obj.result;
	var birth = obj.sBirthDate;	//생년월일
	var a,b,c,m = mobileNo;
	
	$("#result").val(result);

    $(location).attr("href","/login");
//    $(location).attr("href","/index_proposal.html");
}

function fail() {
	alert("본인인증이 실패하였습니다.");
}



</script>

<style>
/*notice_form*/
	#noticeform.container{}
	#noticeform.container .cont{width:850px; border:0px solid #e1e1e1;background-color:#fff; min-height:100px;margin:0 auto; padding:0px 0px;position:relative;}
	#noticeform.container .cont .top{width:850px; background-color:#a01319; padding:20px 30px;}
	#noticeform.container .cont .close_bt{position:absolute; top:28px; right:25px; cursor:pointer;}
	#noticeform.container .cont .cont_form{padding:30px 35px 30px 40px; max-height:800px;}
	#noticeform.container .cont .cont_form div.title{ display:inline-block; border-bottom:2px solid #646464;padding-bottom:10px; position:relative; width:100%;  }
	#noticeform.container .cont .cont_form div.sub_txt{ font-size:12px; cursor:default;padding:10px 0px;}
	#noticeform.container .cont .cont_form div.tab_box{margin:10px 0 20px 0;width:100%;display:inline-block;border-bottom:1px solid #e1e1e1;}
	#noticeform.container .cont .cont_form div.tab_box div.bt{cursor:pointer;margin-bottom:-1px;padding:10px 0 10px 0;background-color:#f4f4f4; border:1px solid #e1e1e1;text-align:center;font-size:12px;font-weight:bold;}
	#noticeform.container .cont .cont_form div.tab_box div.on{background-color:#fff;border-top:1px solid #333333;border-left:1px solid #333333!important;border-right:1px solid #333333;border-bottom:1px solid #fff;}
	#noticeform.container .cont .cont_form div.tab_box div.bt:last-child{border-left:0px;}
	#noticeform.container .cont .cont_form div.sub_info{margin:10px 0 5px 0;width:100%;display:inline-block; font-size:12px;}
	#noticeform.container .cont .cont_form div.headline{font-weight:bold; font-size:12px; cursor:default;padding:10px 0px;color:#000;}
	#noticeform.container .cont .cont_form div.input_box{border:1px solid #d5d5d5;background-color:#f4f4f4;padding:10px;}
	#noticeform.container .cont .cont_form div.bt_box{margin-top:20px;text-align:center;}
	
	#main.footer{ width:100%; position:fixed; bottom:0px; border-top:1px solid #e1e1e1; background-color:#f4f4f4;}
	#main.footer .cont{ width:1200px; margin:0 auto; padding:20px 0px 30px 0px; position:relative; }
	#main.footer .cont .logo{}
	#main.footer .cont .adress{ font-size:12px; width:900px; position:absolute; right:0px;top:20px;}
	@media(max-height:900px){
	#main.footer{ width:100%;position: relative; border-top:1px solid #e1e1e1; background-color:#f4f4f4;}
	#main.footer .cont{ width:1200px; margin:0 auto; padding:20px 0px 30px 0px; position:relative; }
	#main.footer .cont .logo{}
	#main.footer .cont .adress{ font-size:12px; width:900px; position:absolute; right:0px;top:20px;}
	
	.footer{ width:100%; position:relative; bottom:0px; border-top:1px solid #e1e1e1; background-color:#f4f4f4;}
	.footer .cont{ width:1200px; margin:0 auto; padding:20px 0px 30px 0px; position:relative; }
	.footer .cont .logo{}
	.footer .cont .adress{ font-size:12px; width:900px; position:absolute; right:0px;top:20px;}
	
	
	span.btn_type_01_big{margin-top:0px;padding:12px 56px; color:#fff; cursor:pointer; border:1px solid #840e12; background-color:#a01318; font-size:13px; font-weight:bold;position:relative;display:inline-block; line-height:16px;}
	span.btn_type_01_big a{margin-top:0px;padding:12px 56px; color:#fff; cursor:pointer; border:1px solid #840e12; background-color:#a01318; font-size:13px; font-weight:bold;position:relative;display:inline-block; line-height:16px;}
	
	span.btn_type_01{margin-top:2px;padding:3px 10px; color:#fff; cursor:pointer; border:1px solid #840e12; background-color:#a01318; font-size:11px; font-weight:bold;position:relative;display:inline-block; line-height:16px;}
	span.btn_type_01 a{margin-top:2px;padding:3px 10px; color:#fff; cursor:pointer; border:1px solid #840e12; background-color:#a01318; font-size:11px; font-weight:bold;position:relative;display:inline-block; line-height:16px;}
	
	
</style>


</head>
<body>
  
<div id="joinform" class="container">
    <div class="cont" id="cont" style="margin-top:30px">
        <div class="row" style="margin-left:-20px">
            <div class="top">
                <a href="/"><img src="/images/receipt/logo_mem.png" /></a>
            </div>
        </div>
        <div class="cont_form" style="overflow-x:hidden; overflow-y:hidden;width:1000px;margin-top:10px">
	        <div class="box_type01">
	           <div class="form_date_serch">
		    		<div class="row">
			    		<div class="cont_form" style="overflow-y:hidden">
			    			<div class="sub_txt">
		
								
								<font size="3"><b>
최근 중국 해킹조직의 해킹시도 목록에<br><br>

모금회의 사이트도 해킹대상으로 지목되었습니다.<br><br><br>

 

이에 보건복지부 관제센터의 보안강화조치 권고에 따라<br><br>

사이트 접속시 인증절차를 추가하여 정상적인 접속자만<br><br>

사용이 가능하도록 조치하였습니다.<br><br><br>

 

추가인증은 별도의 개인정보를 저장하지 않으며<br><br>

인증기관에서 회신하는 정상 사용자 여부만 체크합니다.<br><br><br>

 

사이트 접근이 불편하시더라도 보안강화를 위한<br><br>

조치에 사용자 여러분들의 양해를 부탁드립니다.<br><br>

 

감사합니다.
								</b></font>

			    			</div>
			    		</div>
		    		</div>
	           </div>
               <div class="bt_box tc marginB30">
                   <span class="btn_type_01_big" id="checkPlus"><font size=4>휴대폰인증</font></span>
               </div>
	        </div>
        </div>
    </div>
</div>

<div id="main" class="footer">
	<div class="cont" id="cont">
		<div class="logo"><img src="/images/footer_logo.png" /></div>
		<div class="adress">
                (04519) 서울 중구 세종대로21길 39 (정동 1-17) 사랑의열매 회관 6층 사회복지공동모금회 (회장 김병준)<br />
                사업등록번호 116-82-14426 / TEL. 02-6262-3000 / Call Center. 080-890-1212 / FAX. 02-6262-3100 / webmaster@chest.or.kr<br />
                COPYRIGHT 1997- Community Chest Of Korea., ALL RIGHTS RESERVED.
        </div>
	</div>
</div>
<input type="hidden" name="result" id="result" value="N" />

	    	  	
</body>
</html>

