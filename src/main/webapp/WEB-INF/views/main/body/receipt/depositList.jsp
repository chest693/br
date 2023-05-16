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
  	
    $("#btn_Excel").click(function(event){
        fn_goExcel();
    });
  	
});

//--------------------------------------
//Excel버튼
//--------------------------------------
function fn_goExcel(){
    var f=document.frmList;

    if($("#rceptDeFd").val() == "" || $("#rceptDeFd").val() == null){ 
        alert("입금일자를 입력하셔야 합니다."); 
        return;
    }else if($("#rceptDeTd").val() == "" || $("#rceptDeTd").val() == null){ 
        alert("입금일자를 입력하셔야 합니다."); 
        return;
    }else if($("#progrm").val() == "" || $("#progrm").val() == null){
        alert("프로그램을 선택하셔야 합니다."); 
    	$("#progrm").focus();
        return;
    }else if($("#rcpmnyAcnut").val() == "" || $("#rcpmnyAcnut").val() == null){ 
        alert("입금계좌를 선택하셔야 합니다."); 
    	$("#rcpmnyAcnut").focus();
        return;
    }else if($("#tranFt").val() != "" && $("#tranEt").val() == ""){ 
        alert("입금시간를 선택하셔야 합니다."); 
        $("#tranEt").focus(); 
        return;
    }else if($("#tranFt").val() == "" && $("#tranEt").val() != ""){ 
        alert("입금시간를 선택하셔야 합니다."); 
        $("#tranFt").focus(); 
        return;
    }else{
    	f.action="/receipt/depositListExcelView.do"
   		f.submit();
    }    
}


//--------------------------------------
//페이지이동
//--------------------------------------
function fn_goPage(currPage){
    var f=document.frmList;

    if($("#rceptDeFd").val() == "" || $("#rceptDeFd").val() == null){ 
        alert("입금일자를 입력하셔야 합니다."); 
        return;
    }else if($("#rceptDeTd").val() == "" || $("#rceptDeTd").val() == null){ 
        alert("입금일자를 입력하셔야 합니다."); 
        return;
    }else if($("#progrm").val() == "" || $("#progrm").val() == null){
        alert("프로그램을 선택하셔야 합니다."); 
    	$("#progrm").focus();
        return;
    }else if($("#rcpmnyAcnut").val() == "" || $("#rcpmnyAcnut").val() == null){ 
        alert("입금계좌를 선택하셔야 합니다."); 
    	$("#rcpmnyAcnut").focus();
        return;
    }else if($("#tranFt").val() != "" && $("#tranEt").val() == ""){ 
        alert("입금시간를 선택하셔야 합니다."); 
        $("#tranEt").focus(); 
        return;
    }else if($("#tranFt").val() == "" && $("#tranEt").val() != ""){ 
        alert("입금시간를 선택하셔야 합니다."); 
        $("#tranFt").focus(); 
        return;
    }else{
        f.PAGE.value = currPage;
        
    	f.action="/receipt/depositList.do"
   		f.submit();
    }
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
                <h3>입금내역</h3><span class="txt">입금내역을 조회 하실 수 있습니다.</span>
                <div class="location"><h3 style="color: gray">기탁현장 : ${userInfo.sptdpstnNm}</h3></div>
            </div>
        </div>
        <div class="cont" id="cont"> 
			<!-- 조건START -->
            <div class="box_type01">
                <div class="form_date_serch">
                    <div class="row">
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">입금일자 :</li>
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
                                <li class="form_title">입금시간 :</li>
                                <li class="form_input">
                                    <div class="dateP_02">
                                        <div class="input">

                                        	<SELECT ID="tranFt" NAME="tranFt">
                                        		<OPTION VALUE="" <c:if test='${receiptDto.tranFt == ""}'>selected</c:if>>전체</OPTION>
                                        		<OPTION VALUE="00" <c:if test='${receiptDto.tranFt == "00"}'>selected</c:if>>00</OPTION>
                                        		<OPTION VALUE="01" <c:if test='${receiptDto.tranFt == "01"}'>selected</c:if>>01</OPTION>
                                        		<OPTION VALUE="02" <c:if test='${receiptDto.tranFt == "02"}'>selected</c:if>>02</OPTION>
                                        		<OPTION VALUE="03" <c:if test='${receiptDto.tranFt == "03"}'>selected</c:if>>03</OPTION>
                                        		<OPTION VALUE="04" <c:if test='${receiptDto.tranFt == "04"}'>selected</c:if>>04</OPTION>
                                        		<OPTION VALUE="05" <c:if test='${receiptDto.tranFt == "05"}'>selected</c:if>>05</OPTION>
                                        		<OPTION VALUE="06" <c:if test='${receiptDto.tranFt == "06"}'>selected</c:if>>06</OPTION>
                                        		<OPTION VALUE="07" <c:if test='${receiptDto.tranFt == "07"}'>selected</c:if>>07</OPTION>
                                        		<OPTION VALUE="08" <c:if test='${receiptDto.tranFt == "08"}'>selected</c:if>>08</OPTION>
                                        		<OPTION VALUE="09" <c:if test='${receiptDto.tranFt == "09"}'>selected</c:if>>09</OPTION>
                                        		<OPTION VALUE="10" <c:if test='${receiptDto.tranFt == "10"}'>selected</c:if>>10</OPTION>
                                        		<OPTION VALUE="11" <c:if test='${receiptDto.tranFt == "11"}'>selected</c:if>>11</OPTION>
                                        		<OPTION VALUE="12" <c:if test='${receiptDto.tranFt == "12"}'>selected</c:if>>12</OPTION>
                                        		<OPTION VALUE="13" <c:if test='${receiptDto.tranFt == "13"}'>selected</c:if>>13</OPTION>
                                        		<OPTION VALUE="14" <c:if test='${receiptDto.tranFt == "14"}'>selected</c:if>>14</OPTION>
                                        		<OPTION VALUE="15" <c:if test='${receiptDto.tranFt == "15"}'>selected</c:if>>15</OPTION>
                                        		<OPTION VALUE="16" <c:if test='${receiptDto.tranFt == "16"}'>selected</c:if>>16</OPTION>
                                        		<OPTION VALUE="17" <c:if test='${receiptDto.tranFt == "17"}'>selected</c:if>>17</OPTION>
                                        		<OPTION VALUE="18" <c:if test='${receiptDto.tranFt == "18"}'>selected</c:if>>18</OPTION>
                                        		<OPTION VALUE="19" <c:if test='${receiptDto.tranFt == "19"}'>selected</c:if>>19</OPTION>
                                        		<OPTION VALUE="20" <c:if test='${receiptDto.tranFt == "20"}'>selected</c:if>>20</OPTION>
                                        		<OPTION VALUE="21" <c:if test='${receiptDto.tranFt == "21"}'>selected</c:if>>21</OPTION>
                                        		<OPTION VALUE="22" <c:if test='${receiptDto.tranFt == "22"}'>selected</c:if>>22</OPTION>
                                        		<OPTION VALUE="23" <c:if test='${receiptDto.tranFt == "23"}'>selected</c:if>>23</OPTION>
                                        	</SELECT>
                                        </div>
                                        <div class="txt">~</div>
                                        <div class="input">
                                        	<SELECT ID="tranEt" NAME="tranEt">
                                        		<OPTION VALUE="" <c:if test='${receiptDto.tranEt == ""}'>selected</c:if>>전체</OPTION>
                                        		<OPTION VALUE="00" <c:if test='${receiptDto.tranEt == "00"}'>selected</c:if>>00</OPTION>
                                        		<OPTION VALUE="01" <c:if test='${receiptDto.tranEt == "01"}'>selected</c:if>>01</OPTION>
                                        		<OPTION VALUE="02" <c:if test='${receiptDto.tranEt == "02"}'>selected</c:if>>02</OPTION>
                                        		<OPTION VALUE="03" <c:if test='${receiptDto.tranEt == "03"}'>selected</c:if>>03</OPTION>
                                        		<OPTION VALUE="04" <c:if test='${receiptDto.tranEt == "04"}'>selected</c:if>>04</OPTION>
                                        		<OPTION VALUE="05" <c:if test='${receiptDto.tranEt == "05"}'>selected</c:if>>05</OPTION>
                                        		<OPTION VALUE="06" <c:if test='${receiptDto.tranEt == "06"}'>selected</c:if>>06</OPTION>
                                        		<OPTION VALUE="07" <c:if test='${receiptDto.tranEt == "07"}'>selected</c:if>>07</OPTION>
                                        		<OPTION VALUE="08" <c:if test='${receiptDto.tranEt == "08"}'>selected</c:if>>08</OPTION>
                                        		<OPTION VALUE="09" <c:if test='${receiptDto.tranEt == "09"}'>selected</c:if>>09</OPTION>
                                        		<OPTION VALUE="10" <c:if test='${receiptDto.tranEt == "10"}'>selected</c:if>>10</OPTION>
                                        		<OPTION VALUE="11" <c:if test='${receiptDto.tranEt == "11"}'>selected</c:if>>11</OPTION>
                                        		<OPTION VALUE="12" <c:if test='${receiptDto.tranEt == "12"}'>selected</c:if>>12</OPTION>
                                        		<OPTION VALUE="13" <c:if test='${receiptDto.tranEt == "13"}'>selected</c:if>>13</OPTION>
                                        		<OPTION VALUE="14" <c:if test='${receiptDto.tranEt == "14"}'>selected</c:if>>14</OPTION>
                                        		<OPTION VALUE="15" <c:if test='${receiptDto.tranEt == "15"}'>selected</c:if>>15</OPTION>
                                        		<OPTION VALUE="16" <c:if test='${receiptDto.tranEt == "16"}'>selected</c:if>>16</OPTION>
                                        		<OPTION VALUE="17" <c:if test='${receiptDto.tranEt == "17"}'>selected</c:if>>17</OPTION>
                                        		<OPTION VALUE="18" <c:if test='${receiptDto.tranEt == "18"}'>selected</c:if>>18</OPTION>
                                        		<OPTION VALUE="19" <c:if test='${receiptDto.tranEt == "19"}'>selected</c:if>>19</OPTION>
                                        		<OPTION VALUE="20" <c:if test='${receiptDto.tranEt == "20"}'>selected</c:if>>20</OPTION>
                                        		<OPTION VALUE="21" <c:if test='${receiptDto.tranEt == "21"}'>selected</c:if>>21</OPTION>
                                        		<OPTION VALUE="22" <c:if test='${receiptDto.tranEt == "22"}'>selected</c:if>>22</OPTION>
                                        		<OPTION VALUE="23" <c:if test='${receiptDto.tranEt == "23"}'>selected</c:if>>23</OPTION>
                                        	</SELECT>
                                        </div>
                                    </div>
                                </li>
                            </ul>
                        </div>                        
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">입금자명 :</li>
                                <li class="form_input">
                                    <div class="input width200P fl">
                                        <input name="rcpnmyerNm" id="rcpnmyerNm" type="text" value="<c:out value='${receiptDto.rcpnmyerNm}' />" maxlength="20" style="ime-mode:active;" class="sfn_required" title="기탁자명" />
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div style="clear:both"></div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">프로그램 :</li>
                                <li class="form_input">
                                    <div class="select">
                                        <select name="progrm" id="progrm" class="sfn_required" title="프로그램">
                                        <option value="">::: 선택 :::</option>
                                        <c:forEach var="list" items="${progrmList}">
                                        <option value="<c:out value='${list.progrmCode}'/>" <c:if test='${receiptDto.progrm == list.progrmCode}'>selected</c:if>>${list.progrmNm}</option>
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
                                            <option value="">::: 선택 :::</option>
                                        </select>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="form_date_confirm">
                    <span class="btn_type_03" id="btn_Retrievet">검색</span>
                    <span class="btn_type_03" id="btn_Excel">Excel</span>
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
                        </tr>
                    </tbody>
                </table>


            </div>
            <div class="row table_form01">
                <div class="result_table">
                    <div class="result_list">
                            <table>
                                <colgroup>
                                    <col width="auto"  />
                                    <col width="auto" />
                                    <col width="auto"  />
                                    <col width="auto" />
                                    <col width="auto"  />
                                    <col width="auto" />
                                    <col width="auto" />
                                    <col width="auto"  />
                                    <col width="auto" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col">순번</th>
                                        <th scope="col">입금일자</th>
                                        <th scope="col">입금시간</th>
                                        <th scope="col">입금구분</th>
                                        <th scope="col">은행코드</th>
                                        <th scope="col">입금은행</th>
                                        <th scope="col">지점</th>
                                        <th scope="col">입금자명</th>
                                        <th scope="col">입금액</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="list" items="${list}" varStatus="cnt" >
                                    <tr>
                                        <td class="tc"><fmt:formatNumber value="${list.rnum}" pattern="#,###" /></td>
                                        <td class="tc">
                                        	<fmt:parseDate var="date" value="${list.tranDate}" pattern="yyyyMMdd" />
                                        	<fmt:formatDate value="${date}" pattern="yyyy-MM-dd" />
										</td>
                                        <td class="tc"><c:out value='${list.tranTime}'/></td>
                                        <td class="tc"><c:out value='${list.tranClsfy}'/></td>
                                        <td class="tc"><c:out value='${list.bankId}'/></td>
                                        <td class="tc"><c:out value='${list.bankName}'/></td>
                                        <td class="tc"><c:out value='${list.tranBranch}'/></td>
                                        <td class="tc"><c:out value='${list.tranContent}'/></td>
                                        <td class="tr"><fmt:formatNumber value="${list.tranAmt}" pattern="#,###" /></td>
                                    </tr>
                                    <c:set var="total_cnt" value="${list.total}'/>"/>
                                    <c:set var="total_amt" value="${list.totalAmt}'/>"/>
                                    </c:forEach>
                                    <c:if test="${fn:length(list)==0}">
                                     <tr><td colspan="9" align="center">조회된 내용이 없습니다.</td></tr>
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
	var rcpmnyAcnut = "<c:out value='${receiptDto.rcpmnyAcnut}'/>";
    var total_cnt = "<c:out value='${total_cnt}'/>";
    var total_amt = "<c:out value='${total_amt}'/>";
    var fd = convertDateFormat("<c:out value='${receiptDto.rceptDeFd}'/>");
    var td = convertDateFormat("<c:out value='${receiptDto.rceptDeTd}'/>");
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
        document.getElementById('sum').innerHTML = "<span class='fontBold'>입금계좌</span> : <span class='colorR'>"+ rcpmnyAcnut +"</span>&nbsp;&nbsp;&nbsp;&nbsp;<span class='fontBold'>입금기간</span> : <span class='colorR'>"+fd+"~"+td+"</span>&nbsp;&nbsp;&nbsp;&nbsp;<span class='fontBold'>입금건수</span> : <span class='colorR'>"+ total_cnt +"</span> 건 &nbsp;&nbsp;&nbsp;&nbsp;<span class='fontBold'>입금금액</span> : <span class='colorR'>"+total_amt+"</span>원";
    }
</script>
