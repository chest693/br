<%@ page session="true" buffer="none" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/taglib.h"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<!------------------------------------------------------------------------
Local Java Script
-------------------------------------------------------------------------->
<%
	String url = (String)request.getRequestURL().toString();
	if(url.contains("https")){
		out.println("<script src='https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js'></script>");
	}else{
		out.println("<script src='http://dmaps.daum.net/map_js_init/postcode.v2.js'></script>");
	}
%>

<script src="/js/common.js"></script>
<script language="javascript">
//<!CDADA[
    
//--------------------------------------
// ONLOAD
//--------------------------------------
$(window).load(function(){
});

$(document).ready(function(){
	var dat = new Date();
	$("#rceptDe").val($.datepicker.formatDate("yy-mm-dd", dat));

  	$("select[name=progrm]").change(function() {
  		var selectAccount;

	    $.ajax({
	        url : '/receipt/selectAccount.do',
	        method : "post",
	        dataType : 'json',
	        async    : false, // default : true(비동기)
	        data : "progrmCode=" + $("#progrm").val(),
	        success : function(data) {
	        	selectAccount = data.selectAccount;
	        }
	    });

	    var options = {
	    		callback : "",
	    		value    : "code",
	    		text     : "name",
	    		nulltext : "::: 선택 :::",
	    		dataList : selectAccount
	    };
        $("select[name=rcpmnyAcnut]").removeOption();
        $("select[name=rcpmnyAcnut]").addOptions(options);
  	});
  	
  	if("<c:out value='${receiptDto.progrm}'/>" != ""){
		$("select[name=progrm]").trigger("change");
		$("select[name=rcpmnyAcnut]").val("<c:out value='${receiptDto.rcpmnyAcnut}'/>");
  	}
	
	//--------------------------------------
	//우편번호검색
	//--------------------------------------
    $("#zipPopup").click(function(event){
		openZonecodePopup("zonecodeCallback");
    });
  	
    $('#dpstnNm').focusout(function() {
		$("#rcpnmyerNm").val($("#dpstnNm").val());
   	});

  //--------------------------------------
  //주민번호 유효성 체크
  //--------------------------------------
    $('#ihidnumBizrno').focusout(function() {
		if($(this).val().length==0){
		    return;
		}

		if( $(this).val().length == 13 || $(this).val().length == 10){
			$.ajax({
			    url : '/receipt/checkIhidnumBizrno.do',
			    method : "post",
			    async    : false, // default : true(비동기)
			    data : "ihidnumBizrno=" + $("#ihidnumBizrno").val(),
			    success : function(ihibiznocheck) {
			    	if(ihibiznocheck=="S"){
						$("#enableIhidYn").val("Y");
					}else{
						$("#enableIhidYn").val("N");
						alert("유효한 주민/사업자 번호가 아닙니다.");
						//$("#ihidnumBizrno").focus();
					}
			    }
			});
		}else{
			  $("#enableIhidYn").val("N");
		      alert("유효한 주민/사업자 번호가 아닙니다.");
		      //$("#ihidnumBizrno").focus();
		      return;
		}
   	});
    
    /*
  	$("#fileNm1").change(function() {
    	if($(this).val() != "" && getNameFromPath($(this).val()).length > 30){
    		alert('기탁서  파일명은 30자이내로 작성해주십시요.');
    		$(this).val("");
    	}
   	});
  	
  	$("#fileNm2").change(function() {
    	if($(this).val() != "" && getNameFromPath($(this).val()).length > 30){
    		alert('개인정보동의서  파일명은 30자이내로 작성해주십시요.');
    		$(this).val("");
    	}
   	});
  	*/
  	
});

//--------------------------------------
//초기화
//--------------------------------------
function fn_Init(){
	var dat = new Date();
	
	$("#rceptNo").val("");
	$("#rceptDe").val($.datepicker.formatDate("yy-mm-dd", dat));
	$("input:radio[name='dpstnSe']:radio[value='01']").prop('checked', true);
	
	$("#dpstnArea").val("");
	$("#trumny").val("");
	$("#progrm").val("");
	$("#rcpmnyAcnut").val("");
	$("#dpstnCn").val("");
	$("#dpstnNm").val("");
	$("#rcpnmyerNm").val("");
	$("#telno").val("");
	$("#email").val("");
	$("#ihidnumBizrno").val("");
	$("input:radio[name='rceptReqstAt']:radio[value='02']").prop('checked', true);
	
	$("#zip").val("");
	$("#adres1").val("");
	$("#adres2").val("");
	$("#lnmAdres").val("");
	
	$("#fileNm1").val("");
	$("#fileNm2").val("");
}


function zonecodeCallback(data) {
	$("#zip").val(data.zonecode);
	$("#adres1").val(data.address);
	$("#adres2").val(data.extraAddr);
	$("#lnmAdres").val(data.jibunAddress);

	SetCaretAtEnd(document.frm.adres1);
}

//--------------------------------------
//신청버튼 클릭 시
//--------------------------------------
function fn_btnConfirm(){
  //전송 시 버튼 숨김
  //document.getElementById("btnApply").style.display = "none";
	if(!validation()){
	   btnCancel(); //submit;
	}
}

//--------------------------------------
//취소버튼 클릭 시
//--------------------------------------
function btnCancel(){
  //전송 시 버튼 숨김
  document.getElementById("btnApply").style.display = "";
}

//-------------------------------------
//기부금 접수 제출
//-------------------------------------
function validation(){
	var personInfoFlag = true;
	
	if ( $("#rceptDe").val() == "" ){
		alert("접수일자를 입력해주세요");
		return false;
	}
	if ( $("#dpstnArea").val() == "" ){
		alert("지역을 선택하세요");
		$("#dpstnArea").focus();
		return false;
	}
	if ( $("#trumny").val() == "" ){
		alert("기탁금액을 입력해주세요");
		$("#trumny").focus();
		return false;
	}
	if ( $("#progrm").val() == "" ){
		alert("프로그램을 선택하세요");
		$("#progrm").focus();
		return false;
	}
	if ( $("#rcpmnyAcnut").val() == "" ){
		alert("입금계좌를 선택하세요");
		$("#rcpmnyAcnut").focus();
		return false;
	}
	if ( $("#dpstnNm").val() == "" ){
		alert("기탁자명을 입력하세요");
		$("#dpstnNm").focus();
		return false;
	}
	if ( $("#rcpnmyerNm").val() == "" ){
		alert("입금자명을 입력하세요");
		$("#rcpnmyerNm").focus();
		return false;
	}
	if ( $("#enableIhidYn").val() != "" && $("#enableIhidYn").val() != "Y" ){
		alert("주민/사업자 번호가 올바르지 않습니다.");
		return false;
	}
	if(getRadioValue($("#rceptReqstAt"))=="01"){
		if($("#ihidnumBizrno").val()==""){
			alert("주민/사업자 번호를 입력해주세요");
			$("#ihidnumBizrno").focus();
			return false;
		}

		if($("#zip").val()==""){
			alert("주소를 입력해주세요");
			return false;
		}
	}

	if($("#telno").val() == "" && $("#email").val() == "" && $("#ihidnumBizrno").val() == "" && $("#zip").val() == "" ){
		personInfoFlag = false;
	}
	//personInfoFlag = false;

	if ( personInfoFlag && !isNaN($("#fileNm2").val()) ){
		alert('개인정보동의서을 첨부하세요');
		return false;
	}
	if(!confirm("아래의 기탁내역을 저장하시겠습니까?\n\n\n기 탁 자  : "+ $("#dpstnNm").val() +"\n\n기 탁 일  : "+$("#rceptDe").val()+"\n기탁금액 : "+ getMoneyFormat($("#trumny").val().replace(/,/gi,"")) + " 원")){
		return false;
	} else {
		//$("#dpstnCn").val( $('<html>').text($("#dpstnCn").val()).html() );
		saveData();
	}
}

function saveData(){
	var form = $('form')[0];
	var formData = new FormData(form);
	
	$.ajax({
        url : '/receipt/receiptAdd.do',
        processData: false, 
        contentType: false,
		method : 'post',
		dataType : 'json',
		data: formData,
		success: function(data){
			if (data.resultCode == "S") {
				fn_Issue(data.rceptNo.trim());
			} else {
				alert(data.resultMsg);
			}
		}
	});
}

//-------------------------------------
//현장기부확인서 발급
//-------------------------------------
function fn_Issue(rceptNo){
	if(!confirm('접수번호['+rceptNo.trim()+']로 입력되었습니다.\n\n접수된 내역은 접수내역메뉴에서 확인 가능합니다.\n\n현장기부확인서를 발급하시겠습니까?')){
		fn_Init();
		return;
	}

	$("#rceptNo").val(rceptNo);
	
    $.ajax({
        url : '/receipt/issueSave.do',
        method : "post",
        dataType : 'json',
        async    : false, // default : true(비동기)
        data : "rceptNo=" + $("#rceptNo").val(),
        success : function(data) {
			if (data.resultCode == "S") {
			    $.openWindow({url: "/popup/receiptPrint.do?rceptNo="+rceptNo, width:770, height: 650});
				fn_Init();
			} else {
				alert(data.resultMsg);
			}
        }
    });
}

$(function() {    
    $(".date_picker").datepicker({ dateFormat: 'yy-mm-dd' });
});



//]]>
</script>


    <div class="container">
        <div class="sub_header">
            <div class="location-stats">
                <h3>기탁서접수</h3>
                <div class="location"><h3 style="color: gray">기부현장 : <c:out value='${userInfo.sptdpstnNm}'/></h3></div>
            </div>
        </div>
        <div class="cont" id="cont">
        
	    <form name="frm" id="frm">
            <input id="enableIhidYn" name="enableIhidYn" type="hidden" value=""/>
            <input id="rceptNo" name="rceptNo" type="hidden"/>
            <div class="box_type01">
                <div class="form_date_serch">
                    <div class="row">
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">접수일자 :</li>
                                <li class="form_input">
                                    <div class="dateP_02">
                                        <div class="input">
                                            <input name="rceptDe" id="rceptDe" value='' type="text" class="sfn_required date_picker" OnkeyDown="javascript:sfn_onlyNumber(this);" onfocus="focusOnDate(this);" onblur="focusOutDate(this);" title="접수일자"/>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">기탁서유형 :</li>
                                <li class="form_input">
                                    <div class="chk">
                                        <label><input id="dpstnSe" name="dpstnSe" type="radio" value="01" class="sfn_required" title="일반" checked /> 일반</label>
                                        <label><input id="dpstnSe" name="dpstnSe" type="radio" value="02" class="sfn_required" title="지정"/> 지정</label>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">지역 :</li>
                                <li class="form_input">
                                    <div class="select">
                                        <select name="dpstnArea" id="dpstnArea" class="sfn_required" title="지역">
                                        <option value="">::: 선택 :::</option>
                                        <c:forEach var="list" items="${areaList}">
                                        <option value="${list.areaCode}" <c:if test='${receiptDto.dpstnArea == list.areaCode}'>selected</c:if>>${list.areaNm}</option>
                                        </c:forEach>
                                        </select>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div style="clear:both"></div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">기탁금액 :</li>
                                <li class="form_input">
                                    <div class="input">
                                        <input name="trumny" id="trumny" type="text" value="" class="sfn_required" OnkeyDown="javascript:sfn_onlyNumber(this);" OnKeyUp="javascript:sfn_setMoneyFormat(this);" maxlength="20" title="기탁금액" />
                                    </div>
                                </li>
                            </ul>
                        </div>


                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">프로그램 :</li>
                                <li class="form_input">
                                    <div class="select">
                                        <select name="progrm" id="progrm" class="sfn_required" title="프로그램">
                                        <option value="">::: 선택 :::</option>
                                        <c:forEach var="list" items="${progrmList}">
                                        <option value="${list.progrmCode}" <c:if test='${receiptDto.progrm == list.progrmCode}'>selected</c:if>>${list.progrmNm}</option>
                                        </c:forEach>
                                        </select>
                                    </div>
                                </li>
                            </ul>
                        </div>


                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">입금계좌 :</li>
                                <li class="form_input">
                                    <div class="input">
                                        <select name="rcpmnyAcnut" id="rcpmnyAcnut" class="sfn_required" title="입금계좌">
                                            <option value="">::: 선택 :::</option>
                                        </select>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div style="clear:both"></div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">기탁내용 :</li>
                                <li class="form_input">
                                    <div class="input" style="width:905px">
                                        <input id="dpstnCn" name="dpstnCn" type="text" value="" style="ime-mode:active;" class="sfn_required input_200" title="기탁내용"/>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div style="clear:both"></div>
                    </div>
                </div>
            </div>
            
            <div class="box_type01">
                <div class="form_date_serch">
                    <div class="row">
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">기탁자명 :</li>
                                <li class="form_input">
                                    <div class="dateP_02">
                                        <div class="input width200P fl">
	                                        <input id="dpstnNm" name="dpstnNm" type="text" value="" style="ime-mode:active;" class="sfn_required" maxlength="20" title="기탁자명" />
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">입금자명 :</li>
                                <li class="form_input">
                                    <div class="dateP_02">
                                        <div class="input width200P fl">
	                                        <input id="rcpnmyerNm" name="rcpnmyerNm" type="text" value="" style="ime-mode:active;" class="sfn_required" maxlength="20" title="기탁자명" />
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">전화번호 :</li>
                                <li class="form_input">
                                    <div class="dateP_02">
                                        <div class="input width200P fl">
                                            <input id="telno" name="telno" type="text" value="" title="전화번호" placeholder="000-0000-0000"/>
                                        </div>
                                    </div>

                                </li>
                            </ul>
                        </div>
                        <div style="clear:both"></div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">이메일 :</li>
                                <li class="form_input">
                                    <div class="dateP_02">
                                        <div class="input width200P fl">
	                                        <input id="email" name="email" type="text" value="" style="ime-mode:active;" class="sfn_required" maxlength="50" title="이메일" />
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">주민/사업자번호 :</li>
                                <li class="form_input">
                                    <table>
                                        <colgroup>
                                            <col style="width: auto;" />
                                        </colgroup>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="input width220P fl">
			                                            <input name="ihidnumBizrno" id="ihidnumBizrno" type="text" value="" class="" maxlength="13" placeholder="'-'없이 입력하십시오" OnkeyDown="javascript:sfn_onlyNumber(this);" title="주민등록번호" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </li>
                            </ul>
                        </div>
                        <div style="clear:both"></div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">영수증신청 :</li>
                                <li class="form_input">
                                    <div class="chk">
                                        <label><input id="rceptReqstAt" name="rceptReqstAt" type="radio" value="01" class="sfn_required" title="신청" /> 신청</label>
                                        <label><input id="rceptReqstAt" name="rceptReqstAt" type="radio" value="02" class="sfn_required" title="미신청" checked/>미신청</label>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div style="clear:both"></div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">주소 :</li>
                                <li class="form_input">

                                    <table width="900px">
                                        <colgroup>
                                            <col style="width: auto;"/>
                                        </colgroup>
                                        <tbody>
                                            <tr>
                                                <td>
                                                    <div class="input width100P fl">
                                                        <input id="zip" name="zip" type="text" value=""  class="" title="우편번호" readonly/>
                                                    </div>
                                                    <span class="btn_type_03_wide fl" id="zipPopup" style="width:135px;">우편번호검색</span>
                                                </td>
                                                <td>
                                                    <div class="input width400P fl">
                                                        <input id="adres1" name="adres1" type="text" value=""  class="" maxlength="200" title="주소" />
                                                    </div>
                                                    <div class="input width200P fl">
                                                        <input id="adres2" name="adres2" type="text" value="" style="border:0px;background-color:#f6f6f6;" class="" readonly/>
                                                        <input id="lnmAdres" name="lnmAdres" type="hidden" value="" />
                                                    </div>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </li>
                            </ul>
                        </div>
                        <div style="clear:both"></div>

                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">첨부 서류 :</li>
                                <li class="form_input">

		                            <div class=" table_form04">
		                                <div class="info_table">
		                                    <table width="1200px" border=0>
		                                        <colgroup>
		                                            <col style="width: auto;" />
		                                            <col style="width: auto;" />
		                                            <col style="width: auto;" />
		                                        </colgroup>
		                                        <tbody>
		                                            <tr>
		                                                <td width="100px">
		                                                    <div class="input width90P fl" style="border:0px;background-color:#ececec;"><font color=black>기탁서파일 :</font></div>
		                                                </td>
		                                                <td width="300px" colspan=2>
		                                                    <div class="input width400P fl">
		                                                    <!--  
					                                            <input type="file" id="fileNm1" name="fileNm1" onChange="chk_extension(this,'1');fileCheck(this, 10);" accept="image/*,.pdf" class="upload-hidden" title="기탁서파일">
															-->					                                            
					                                            <input type="file" id="fileNm1" name="fileNm1" accept="image/*,.pdf" class="upload-hidden" title="기탁서파일">
		                                                    </div>
		                                                </td>
		                                            </tr>
		                                            <tr>
		                                                <td width="120px">
		                                                    <div class="input width120P fl" style="border:0px;background-color:#ececec;"><font color=black>개인정보동의서 :</font></div>
		                                                </td>
		                                                <td width="300px">
		                                                    <div class="input width400P fl">
		                                                    <!--  
					                                            <input type="file" id="fileNm2" name="fileNm2" onChange="chk_extension(this,'2');fileCheck(this, 10);" accept="image/*,.pdf" class="upload-hidden" title="개인정보동의서">
															-->					                                            
					                                            <input type="file" id="fileNm2" name="fileNm2" accept="image/*,.pdf" class="upload-hidden" title="개인정보동의서">
		                                                    </div>
		                                                </td>
		                                                <td width="300px">
		                                                	<div style="width:300px;color:#000000">
			                                                	<a href="#" onclick="window.open('/popup/documentDownload.do?file=persionInfoConsent.hwp','attach','width=0,height=8')">개인정보동의서 다운로드</a>
		                                                	</div>
		                                                </td>
		                                            </tr>
		                                            <tr>
		                                                <td colspan="3">
		                                                	<div style="width:600px;color:#0000ff">
		                                                	* 전화번호, 이메일, 주민번호, 주소등 개인정보가 등록될 경우 개인정보동의서가 첨부되어야 합니다.
		                                                	</div>
		                                                </td>
		                                            </tr>
		                                            <tr>
		                                                <td colspan="3">
		                                                	<div style="width:600px;color:#000000">
				                                            * [첨부파일명은 반드시 한글 30자이내로 작성해주세요]&nbsp;&nbsp;&nbsp;* [첨부파일은 10MB를 초과할 수 없습니다.]
		                                                	</div>
		                                                </td>
		                                            </tr>
		                                            <tr>
		                                                <td colspan="3">
		                                                	<span style="font-size:13px;color:red;font-weight:bold;">
		                                                		<a href="/js/IEPageSetupX.exe">* 기부확인서 출력이 되지않을 경우 설치하세요</a></span>
		                                                </td>
		                                            </tr>
		                                        </tbody>
		                                    </table>
		                                </div>
		                            </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
            <div class="bt_box tr" >
                <span class="btn_type_01_wide" onclick="javascript:fn_Init();" id="btnInit">초기화</span>
                <span class="btn_type_01_wide" onclick="javascript:fn_btnConfirm();" id="btnApply">저장</span>
            </div>
            <div style="height:50px"></div>
        </form>

        </div>
    </div>

	<iframe style="border: 0px;" id="attach" name="attach" width="0px" height="0px"></iframe>    