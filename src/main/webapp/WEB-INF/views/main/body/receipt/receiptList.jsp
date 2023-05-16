<%@ page session="true" buffer="none" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/taglib.h"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>

<!------------------------------------------------------------------------
Local Java Script
-------------------------------------------------------------------------->
<script src="/js/common.js"></script>
<script language="javascript">
//<!CDADA[
    
//--------------------------------------
// ONLOAD
//--------------------------------------
$(window).load(function(){
});

$(document).ready(function(){

    //---------------------------------
    // SET PAGE_BAR
    //---------------------------------
    var _page = 0;
    var _pageGroup = 0;
    var _total = 0;
    <c:if test="${list != null}">
    <c:forEach var="list" items="${list}" begin="0" end="0">
        _page = <c:out value='${list.page}'/>;
        _pageGroup = <c:out value='${list.pageGroup}'/>;
        _total = <c:out value='${list.total}'/>;
    </c:forEach>
    </c:if>
    scl_page_row.load( _page, _pageGroup, _total, 10,"PAGE","PAGE_GROUP","TOTAL");

	
	var dat = new Date();
	
	var rceptDeFd = "<c:out value='${receiptDto.rceptDeFd}'/>";
	var rceptDeTd = "<c:out value='${receiptDto.rceptDeTd}'/>";
	
	if(rceptDeFd==""){
		rceptDeFd = $.datepicker.formatDate("yy-mm", dat)+"-01";
	}else{
		rceptDeFd = convertDateFormat(rceptDeFd);
	}
	if(rceptDeTd==""){
		rceptDeTd = $.datepicker.formatDate("yy-mm-dd", dat);
	}else{
		rceptDeTd = convertDateFormat(rceptDeTd);
	}

	$("#rceptDeFd").val(rceptDeFd);
	$("#rceptDeTd").val(rceptDeTd);
	
    //--------------------------------------
    // 버튼 클릭(조회)
    //--------------------------------------
    $("#btn_Retrievet").click(function(event){
        fn_goPage(1);
    });

    $("#btn_Excel").click(function(event){
        fn_goExcel();
    });

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
	    		nulltext : "::: 전체 :::",
	    		dataList : selectAccount
	    };
        $("select[name=rcpmnyAcnut]").removeOption();
        $("select[name=rcpmnyAcnut]").addOptions(options);
  	});
  	
  	if("<c:out value='${receiptDto.progrm}'/>" != ""){
		$("select[name=progrm]").trigger("change");
		$("select[name=rcpmnyAcnut]").val("<c:out value='${receiptDto.rcpmnyAcnut}'/>");
  	}
  	
});

//--------------------------------------
//Excel버튼
//--------------------------------------
function fn_goExcel(){
    var f=document.frmList;

    if(f.rceptDeFd.value == "" || f.rceptDeFd.value == null){ 
        alert("접수일자를 입력하셔야 합니다."); 
        return;
    }else if(f.rceptDeTd.value == "" || f.rceptDeTd.value == null){ 
        alert("접수일자를 입력하셔야 합니다."); 
        return;
    }else{
    	f.action="/receipt/receiptListExcelView.do"
   		f.submit();
    }
}

//--------------------------------------
//페이지이동
//--------------------------------------
function fn_goPage(currPage){
    var f=document.frmList;

    if(f.rceptDeFd.value == "" || f.rceptDeFd.value == null){ 
        alert("접수일자를 입력하셔야 합니다."); 
        return;
    }else if(f.rceptDeTd.value == "" || f.rceptDeTd.value == null){ 
        alert("접수일자를 입력하셔야 합니다."); 
        return;
    }else{
        f.PAGE.value = currPage;
        
    	f.action="/receipt/receiptList.do"
   		f.submit();
    }
}

function search1(currPage) {
    var f=document.frmList;
    f.PAGE.value = currPage;
    var params = jQuery("#frmList").serialize();
    
       $.ajax({
          url: '/receiptList.do',
          data: params,
          dataType : 'html',
          //contentType: 'application/x-www-form-urlencoded; charset=UTF-8', 
          type: 'POST',
          success: function(data){
			location.href = "/receipt/receiptList.do";
          }
      });
}

//--------------------------------------
//상세페이지
//--------------------------------------
function fn_goDetail( rceptNo ){
//	var url = "/popup/receiptDetail.do?rceptNo="+Base64.encode(rceptNo)+"&test=1234";
	var url = "/popup/receiptDetail.do?rceptNo="+rceptNo;
	layer_popup($("#layer2"), url, 900);
}

//--------------------------------------
//상세페이지
//--------------------------------------
function fn_Print( rceptNo ){
    $.openWindow({url: "/popup/receiptPrint.do?rceptNo="+rceptNo, width:770, height: 650});
}

//-------------------------------------
//현장기부확인서 발급
//-------------------------------------
function fn_Issue( rceptNo, statsAt ){
//	if ( statsAt > "0" ){ //0:미전송,1:전송,2:접수확인,3:처리완료
//	alert("전송된 내역은 기부확인서를 신청할 수 없습니다.");
//	return;
//}
    if(!confirm('기부확인서를 발급하시겠습니까?')){
		return;
	}

    $.ajax({
        url : '/receipt/issueSave.do',
        method : "post",
        dataType : 'json',
        async    : false, // default : true(비동기)
        data : "rceptNo=" + rceptNo,
        success : function(data) {
			if (data.resultCode == "S") {
			    $.openWindow({url: "/popup/receiptPrint.do?rceptNo="+rceptNo, width:770, height: 650});
				fn_goPage($("#PAGE").val());
			} else {
				alert(data.resultMsg);
			}
        }
    });
}

//--------------------------------------
//기부내역 삭제
//--------------------------------------
function fn_goDelete( rceptNo, statsAt ){
	if ( statsAt == "1" ){
		alert("전송된 내역을 삭제하시려면 아래의 연락처로 연락해주십시요\n\n\n지   회 : ${bhfInfo.slldNm}\n\n연락처 : ${bhfInfo.telno}");
		return;
	}

	var url = "/popup/receiptDelPopup.do?rceptNo="+rceptNo;
	layer_popup($("#layer2"), url, 900);

}

$(function() {    
    $(".date_picker").datepicker({ dateFormat: 'yy-mm-dd' });
});

//]]>
</script>

<style type="text/css">
	a:link { color: red; text-decoration: none;}
	a:visited { color: red; text-decoration: none;}
	a:hover { color: blue; text-decoration: underline;}
</style>
<form  method="post" id="frmList" name="frmList">
    <!-- 파라미터.페이지넘김 -->
    <input id="PAGE" name="PAGE" type="hidden" value="<c:out value='${PAGE}'/>"/>
    <input id="PAGE_GROUP" name="PAGE_GROUP" type="hidden" value="<c:out value='${PAGE_GROUP}'/>"/>
    <input id="TOTAL" name="TOTAL" type="hidden" value="<c:out value='${TOTAL}'/>"/>

    <div class="container">
        <div class="sub_header">
            <div class="location-stats">
                <h3>접수내역</h3><span class="txt">접수내역을 조회 및 수정 하실 수 있습니다.</span>
                <div class="location"><h3 style="color: gray">기탁현장 : <c:out value='${userInfo.sptdpstnNm}'/></h3></div>
            </div>
        </div>
        <div class="cont" id="cont"> 
			<!-- 조건START -->
            <div class="box_type01_ra" style="height:113px">
                <div class="form_date_serch">
                    <div class="row">
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">접수일자 :</li>
                                <li class="form_input">
                                    <div class="dateP_02">
                                        <div class="input">
                                            <input name="rceptDeFd" id="rceptDeFd" value='' type="text" class="sfn_required date_picker" OnkeyDown="javascript:sfn_onlyNumber(this);" onfocus="focusOnDate(this);" onblur="focusOutDate(this);" title="접수일자"/>
                                        </div>
                                        <div class="txt">~</div>
                                        <div class="input">
                                            <input name="rceptDeTd" id="rceptDeTd" value='' type="text" class="sfn_required date_picker" OnkeyDown="javascript:sfn_onlyNumber(this);" onfocus="focusOnDate(this);" onblur="focusOutDate(this);" title="접수일자"/>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">기탁자명 :</li>
                                <li class="form_input">
                                    <div class="input width200P fl">
                                        <input name="dpstnNm" id="dpstnNm" type="text" value="<c:out value='${receiptDto.dpstnNm}'/>" style="ime-mode:active;" maxlength="20" class="sfn_required" title="기탁자명" />
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">상태 :</li>
                                <li class="form_input">
                                    <div class="select">
                                        <select name="statsAt" class="sfn_required" title="상태">
	                                        <option value="" <c:if test='${receiptDto.statsAt == ""}'>selected</c:if>>::: 전체 :::</option>
	                                        <option value="0" <c:if test='${receiptDto.statsAt == "0"}'>selected</c:if>>미전송</option>
	                                        <option value="1" <c:if test='${receiptDto.statsAt == "1"}'>selected</c:if>>전송</option>
	                                        <option value="2" <c:if test='${receiptDto.statsAt == "2"}'>selected</c:if>>접수확인</option>
	                                        <option value="3" <c:if test='${receiptDto.statsAt == "3"}'>selected</c:if>>처리완료</option>
                                        </select>
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
                                        <option value="">::: 전체 :::</option>
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
                                    <div class="select">
                                        <select name="rcpmnyAcnut" id="rcpmnyAcnut" class="sfn_required" title="입금계좌">
                                            <option value="">::: 전체 :::</option>
                                        </select>
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
                                        <option value="">::: 전체 :::</option>
                                        <c:forEach var="list" items="${areaList}">
                                        <option value="${list.areaCode}" <c:if test='${receiptDto.dpstnArea == list.areaCode}'>selected</c:if>>${list.areaNm}</option>
                                        </c:forEach>
                                        </select>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">등록자ID :</li>
                                <li class="form_input">
                                    <div class="input width200P fl">
                                        <input name="register" id="register" type="text" value="<c:out value='${receiptDto.register}'/>" style="ime-mode:active;" class="sfn_required" title="등록자ID" />
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">삭제구분 :</li>
                                <li class="form_input">
                                    <div class="select">
                                        <select name="deleteAt" id="deleteAt" class="sfn_required" title="삭제구분">
                                        <option value="" <c:if test='${receiptDto.deleteAt == ""}'>selected</c:if>>::: 전체 :::</option>
                                        <option value="0" <c:if test='${receiptDto.deleteAt == "0"}'>selected</c:if>>정상</option>
                                        <option value="1" <c:if test='${receiptDto.deleteAt == "1"}'>selected</c:if>>삭제</option>
                                        </select>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="form_date_confirm">
                    <span class="btn_type_03" id="btn_Retrievet">검색</span>
                    <!--  
                    <span class="btn_type_03" id="btn_Excel">Excel</span>
                    -->
                </div>
            </div>
			<!-- 조건END -->


        <div class="cont" id="cont">
            <div class="row serch_tab paddingB3">
                <table width="1200px" border=0>
                    <tbody>
                        <tr>
                            <td>
                                <div class="col-lg-11 col-md-11 col-xs-11 f-size12 lineH26" id="sum"></div>
                            </td>
                            <td align="right">
								<span style="font-size:13px;color:red;font-weight:bold"><a href="/js/IEPageSetupX.exe">기부확인서 출력이 되지않을 경우 설치하세요</a></span>
							</td>
                        </tr>
                    </tbody>
                </table>


            </div>
            <div class="row table_form01">
                <div class="result_table">
                    <div class="result_list">
                            <table>
                                <colgroup>
                                    <col width="auto" />
                                    <col width="auto" />
                                    <col width="auto" />
                                    <col width="auto" />
                                    <col width="auto" />
                                    <col width="auto" />
                                    <col width="auto" />
                                    <col width="auto" />
                                    <col width="auto" />
                                    <col width="auto" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">접수번호</th>
                                        <th scope="col">접수일자</th>
                                        <th scope="col">상태</th>
                                        <th scope="col">기탁자명</th>
                                        <th scope="col">입금자명</th>
                                        <th scope="col">전화번호</th>
                                        <th scope="col">기탁서유형</th>
                                        <th scope="col">기탁금액</th>
                                        <th scope="col">입금계좌</th>
                                        <th scope="col">영수증신청여부</th>
                                        <th scope="col">기부확인서</th>
                                        <th scope="col">삭제</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="rcept_list" items="${list}" varStatus="cnt" >
                                    <tr>
                                        <td class="tc"><a href='javascript:fn_goDetail("<c:out value='${rcept_list.rceptNo}'/>");'><c:out value='${rcept_list.rceptNo}'/></a>
                                            <input name='statsAt${cnt.index+1}' type="hidden" value="<c:out value='${rcept_list.statsAt}'/>"/>
                                        </td>
                                        <td class="tc"><c:out value='${rcept_list.rceptDeS}'/></td>
                                        <td class="tc"><c:out value='${rcept_list.statsAtNm}'/></td>
                                        <td class="tc" title="<c:out value='${rcept_list.dpstnNm}'/>">
											<c:choose>
												<c:when test="${fn:length(rcept_list.dpstnNm) > 10}">
													<c:out value="${fn:substring(rcept_list.dpstnNm,0,9)}"/>....
												</c:when>
												<c:otherwise>
													<c:out value="${rcept_list.dpstnNm}"/>
												</c:otherwise> 
											</c:choose>
                                        </td>
                                        <td class="tc" title="<c:out value='${rcept_list.rcpnmyerNm}'/>">
											<c:choose>
												<c:when test="${fn:length(rcept_list.rcpnmyerNm) > 10}">
													<c:out value="${fn:substring(rcept_list.rcpnmyerNm,0,9)}"/>....
												</c:when>
												<c:otherwise>
													<c:out value="${rcept_list.rcpnmyerNm}"/>
												</c:otherwise> 
											</c:choose>
                                        </td>
                                        <td class="tc"><c:out value='${rcept_list.telno}'/></td>
                                        <td class="tc"><c:out value='${rcept_list.dpstnSeNm}'/></td>
                                        <td class="tr"><fmt:formatNumber value="${rcept_list.trumny}" pattern="#,###" /> 원</td>
                                        <td class="tc"><c:out value='${rcept_list.rcpmnyAcnut}'/></td>
                                        <td class="tc"><c:out value='${rcept_list.rceptReqstAtNm}'/></td>
                                        <td class="tc">
                                            <c:if test='${rcept_list.cnfirmNo == NULL}'>
                                                <a href='javascript:fn_Issue("<c:out value='${rcept_list.rceptNo}'/>","<c:out value='${rcept_list.statsAt}'/>");'>
                                                    <img src="/images/ico_write.gif" title="기부확인서 신청"/>
                                                </a>
                                            </c:if>
                                            <c:if test='${rcept_list.cnfirmNo != NULL}'>
                                                <a href='javascript:fn_Print("<c:out value='${rcept_list.rceptNo}'/>","<c:out value='${rcept_list.statsAt}'/>","N");'>
                                                    <img src="/images/ico_print.gif" title="기부확인서 출력"/>
                                                </a>
                                            </c:if>
                                        </td>
                                        <td class="tc">
                                            <a href='javascript:fn_goDelete("<c:out value='${rcept_list.rceptNo}'/>","<c:out value='${rcept_list.statsAt}'/>");'>
								                <c:if test='${rcept_list.deleteAt != "1"}'>
	                                                <img src="/images/ico_del.gif" />
								                </c:if>
								                <c:if test='${rcept_list.deleteAt == "1"}'>
									                	삭제
								                </c:if>
                                            </a>
                                        </td>
                                    </tr>
                                    <tr>
                                    </tr>
                                    <c:set var="total_cnt" value="${rcept_list.total}"/>
                                    <c:set var="total_amt" value="${rcept_list.totalAmt}"/>
                                    </c:forEach>
                                    <c:if test="${fn:length(list)==0}">
                                     <tr><td colspan="12" align="center">조회된 내용이 없습니다.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                    </div>
                </div>
                <div align="center" class="paging" id="c_list_page_bar"></div>
            </div>
        </div>
    </div>
</form>
<jsp:include page="../comm/receiptLayer.jsp" flush="false" />
<script language="javascript">
    var total_cnt = "<c:out value='${total_cnt}'/>";
    var total_amt = "<c:out value='${total_amt}'/>";
    if(total_cnt=="") {
    	total_cnt = "0";
    }else{
    	total_cnt = setComma(parseFloat(total_cnt));
    }
    if(total_amt=="") {
    	total_amt = "0";
    } else {
    	total_amt = setComma(parseFloat(total_amt));
    }
    
    if(total_cnt!=""){
        document.getElementById('sum').innerHTML = "<span class='fontBold'>기부건수</span> : <span class='colorR'>"+ total_cnt +"</span> 건 <span class='fontBold'>기부금액</span> : <span class='colorR'>"+total_amt+"</span>원";
    }
</script>
