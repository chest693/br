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
	
    $("#btn_Retrievet").click(function(event){
        fn_goPage(1);
    });

    $("#btnTrans").click(function(event){

        if($('.tranChk:checked').length==0){
    		alert("선택된 내역이 없습니다.");
    		return; 
        }    	
    	
    	if(!confirm('기부내역을 전송하시겠습니까?')){ 
    		return; 
    	}
    	
    	var form = $('form')[0];
    	var formData = new FormData(form);
    	
    	$.ajax({
            url : '/receipt/transExec.do',
            processData: false, 
            contentType: false,
    		method : 'post',
    		dataType : 'json',
    		data: formData,
    		success: function(data){
    			if (data.resultCode == "S") {
    				alert(data.resultMsg);
    				fn_goPage($("#PAGE").val());
    			} else {
    				alert(data.resultMsg);
    			}
    		}
    	});
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
  	
  	$("#checkall").click( function() {
    	if($(this).is(":checked")){
            $('.tranChk').prop( 'checked', true );
    	}else{
            $('.tranChk').prop( 'checked', false );
    	}
	});
  		
});

//--------------------------------------
//페이지이동
//--------------------------------------
function fn_goPage(currPage){
    var f=document.frmList;

    if($("#rceptDeFd").val() == "" || $("#rceptDeFd").val() == null){ 
        alert("접수일자를 입력하셔야 합니다."); 
        return;
    }else if($("#rceptDeTd").val() == "" || $("#rceptDeTd").val() == null){ 
        alert("접수일자를 입력하셔야 합니다."); 
        return;
    }else{
        f.PAGE.value = currPage;
    	f.action="/receipt/transList.do"
   		f.submit();
    }
}


//--------------------------------------
//상세페이지
//--------------------------------------
function fn_goDetail( rceptNo ){
	var url = "/popup/receiptDetail.do?rceptNo="+rceptNo;
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

    <input name="transCnt" id="transCnt" type="hidden" value=""/>
    <input name="rowCnt" id="rowCnt" type="hidden" value=""/>

    <div class="container">
        <div class="sub_header">
            <div class="location-stats">
                <h3>접수내역전송</h3><span class="txt">전송내역을 조회 및 전송 하실 수 있습니다.</span>
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
                                        <input name="dpstnNm" id="dpstnNm" type="text" value="<c:out value='${receiptDto.dpstnNm}'/>" style="ime-mode:active;" class="sfn_required" maxlength="20" title="기탁자명" />
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">상태 :</li>
                                <li class="form_input">
                                    <div class="select">
                                        <select id="statsAt" name="statsAt" class="sfn_required" title="상태">
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
                        <div style="clear:both"></div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title">프로그램 :</li>
                                <li class="form_input">
                                    <div class="select">
                                        <select name="progrm" id="progrm" class="sfn_required" title="프로그램">
                                        <option value="">::: 전체 :::</option>
                                        <c:forEach var="list" items="${progrmList}">
                                        <option value="<c:out value='${list.progrmCode}'/>" <c:if test='${receiptDto.progrm == list.progrmCode}'>selected</c:if>><c:out value='${list.progrmNm}'/></option>
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
                                        <option value="<c:out value='${list.areaCode}'/>" <c:if test='${receiptDto.dpstnArea == list.areaCode}'>selected</c:if>><c:out value='${list.areaNm}'/></option>
                                        </c:forEach>
                                        </select>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="form_date_confirm">
                    <span class="btn_type_03" id="btn_Retrievet">검색</span>
                </div>
                <div class="form_date_confirm" style="right: 20px">
                    <span class="btn_type_03" id="btnTrans">전송</span>
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
                            <table id="mstTbl">
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
                                    <col width="auto" />
                                </colgroup>
                                <thead>
                                    <tr>
                                        <th scope="col"><input type="checkbox" id="checkall" name="checkall"/></th>
                                        <th scope="col">상태</th>
                                        <th scope="col">접수번호</th>
                                        <th scope="col">접수일자</th>
                                        <th scope="col">기탁자명</th>
                                        <th scope="col">입금자명</th>
                                        <th scope="col">전화번호</th>
                                        <th scope="col">기탁서유형</th>
                                        <th scope="col">기탁금액</th>
                                        <th scope="col">입금계좌</th>
                                        <th scope="col">영수증신청여부</th>
                                        <th scope="col">기탁서</th>
                                        <th scope="col">개인정보동의서</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="list" items="${list}" varStatus="cnt" >
                                    <tr>
                                        <td class="tc">
	                                        <input type=checkbox class="tranChk" id="receiptDtoList[<c:out value='${cnt.index}'/>].tranChk" name="receiptDtoList[<c:out value='${cnt.index}'/>].tranChk" <c:if test="${list.transYn == 'N'}">style="display:none" disabled</c:if>>
	                                        <input type=hidden id="receiptDtoList[<c:out value='${cnt.index}'/>].rceptNo" name="receiptDtoList[<c:out value='${cnt.index}'/>].rceptNo" value="<c:out value='${list.rceptNo}'/>">
                                        </td>
                                        <td class="tc"><c:out value='${list.statsAtNm}'/></td>
                                        <td class="tc"><a href='javascript:fn_goDetail(<c:out value='"${list.rceptNo}'/>");'><c:out value='${list.rceptNo}'/></a>
                                        </td>
                                        <td class="tc"><c:out value='${list.rceptDeS}'/></td>
                                        <td class="tc" title="<c:out value='${list.dpstnNm}'/>">
											<c:choose>
												<c:when test="${fn:length(list.dpstnNm) > 10}">
													<c:out value="${fn:substring(list.dpstnNm,0,9)}"/>....
												</c:when>
												<c:otherwise>
													<c:out value="${list.dpstnNm}"/>
												</c:otherwise> 
											</c:choose>
                                        </td>
                                        <td class="tc" title="<c:out value='${list.rcpnmyerNm}'/>">
											<c:choose>
												<c:when test="${fn:length(list.rcpnmyerNm) > 10}">
													<c:out value="${fn:substring(list.rcpnmyerNm,0,9)}"/>....
												</c:when>
												<c:otherwise>
													<c:out value="${list.rcpnmyerNm}"/>
												</c:otherwise> 
											</c:choose>
                                        </td>
                                        <td class="tc"><c:out value='${list.telno}'/></td>
                                        <td class="tc"><c:out value='${list.dpstnSeNm}'/></td>
                                        <td class="tr"><fmt:formatNumber value="${list.trumny}" pattern="#,###" /> 원</td>
                                        <td class="tc"><c:out value='${list.rcpmnyAcnut}'/></td>
                                        <td class="tc"><c:out value='${list.rceptReqstAtNm}'/></td>
                                        <td class="tc">
                                            <c:if test="${list.realFileNm != ''}">
												<a href="#" onclick="window.open('/popup/fileDownload.do?rceptNo=<c:out value="${list.rceptNo}"/>&type=1','attach','width=0,height=8')">
													<img src="/images/ico_down.gif" title="기탁서 다운로드"/>
												</a>
                                            </c:if>
                                        </td>
                                        <td class="tc">
                                            <c:if test="${list.realFileNm1 != ''}">
												<a href="#" onclick="window.open('/popup/fileDownload.do?rceptNo=<c:out value="${list.rceptNo}"/>&type=2','attach','width=0,height=8')">
	                                                <img src="/images/ico_down.gif" title="개인정보동의서 다운로드"/>
												</a>
                                            </c:if>
                                        </td>                                    
                                    </tr>
                                    <tr>
                                    </tr>
                                    <c:set var="row_cnt" value="<c:out value='${cnt.index}'/>"/>
                                    <c:set var="total_cnt" value="<c:out value='${list.total}'/>"/>
                                    <c:set var="total_amt" value="<c:out value='${list.totalAmt}'/>"/>
                                    </c:forEach>
                                    <c:if test="${fn:length(list)==0}">
                                     <tr><td colspan="9" align="center">조회된 내용이 없습니다.</td></tr>
                                    </c:if>
                                </tbody>
                            </table>
                    </div>
                </div>
                <div align="left" style="font-size:12px;color:blue;">* 기탁서가 첨부되어야만 기부내역을 전송할 수 있습니다.</div>
                <div align="center" class="paging" id="c_list_page_bar"></div>
            </div>
        </div>
    </div>
</form>
<jsp:include page="../comm/receiptLayer.jsp" flush="false" />
<script language="javascript">
	var total_cnt = "<c:out value='${total_cnt}'/>";
	var total_amt = "<c:out value='${total_amt}'/>";
	var row_cnt = "<c:out value='${row_cnt}'/>";
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
	    document.getElementsByName("transCnt")(0).value = "0";
	    document.getElementsByName("rowCnt")(0).value = parseInt(row_cnt)+1;
	}
</script>
<iframe style="border: 0px;" id="attach" name="attach" width="0px" height="0px"></iframe>
