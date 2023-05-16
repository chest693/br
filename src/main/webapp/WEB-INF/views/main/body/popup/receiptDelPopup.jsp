<%@ page session="true" buffer="none" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/taglib.h"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%
	String url = (String)request.getRequestURL().toString();
	if(url.contains("https")){
		out.println("<script src='https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js'></script>");
	}else{
		out.println("<script src='http://dmaps.daum.net/map_js_init/postcode.v2.js'></script>");
	}
%>
<!------------------------------------------------------------------------
Local Java Script
-------------------------------------------------------------------------->
<script src='/js/jquery-ui.js'></script>
<script src="/js/jsit.js"></script>
<script src="/js/common.js"></script>
<script language="javascript">
// On Load
window.onload = function(){
}

//--------------------------------------
//LOADED FORM
//--------------------------------------
$(document).ready(function(){
  	//--------------------------------------
	//기부내역 삭제
	//--------------------------------------
    $("#btnDelete").click(function(event){
	    if ( $("#statsAt").val() == "1" ){
			alert("전송된 내역을 삭제하시려면 아래의 연락처로 연락해주십시요\n\n\n지   회 : ${bhfInfo.slldNm}\n\n연락처 : ${bhfInfo.telno}");
	        return;
	    }
	    
	    if ( $("#deleteResn").val() == "" ){
	        alert("삭제사유를 입력해주세요");
	        $("#deleteResn").focus();
	        return;
	    }
	    
        if(!confirm('['+$("#dpstnNm").html()+'] 님의 기부내역을 삭제 하시겠습니까?')){ 
            return false;
        }else{
	        deleteData()
        }
		
    });

});

function deleteData(){
	var form = $('form')[0];
	var formData = new FormData(form);

	$.ajax({
        url : '/receipt/receiptDelete.do',
        processData: false, 
        contentType: false,
		method : 'post',
		dataType : 'json',
		data: formData,
		success: function(data){
			if (data.resultCode == "S") {
				alert(data.resultMsg);
				$("img.close_pop").trigger("click");
			    parent.fn_goPage( $(parent.document).find("#PAGE").val() );
			} else {
				alert(data.resultMsg);
			}
		}
	});
}

</script>
<div id="joinform" class="container">
    <div class="cont" id="cont">
        <div class="row">
            <div class="top">
                <a><img src="/images/receipt/logo_mem.png" /></a>
            </div>
            <div class="close_bt">
                <img src="/images/pop_close_bt.png" class="close_pop" />
            </div>
        </div>
        <div class="cont_form">
        <form name="frm">
        <input id="rceptNo" name="rceptNo" type="hidden" value="<c:out value='${detail.rceptNo}'/>"/>
        <input id="statsAt" name="statsAt" type="hidden" value="<c:out value='${detail.statsAt}'/>"/>
            <div class="box_type01" style="padding:10px;">
                <div class="form_date_serch" style="padding-right:0px;">
                    <div class="row">
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title" style="width:30%"><b>기부일자 :</b></li>
                                <li style="width:70%">
                                    <span class="f-size12 marginL10"><c:out value='${detail.rceptDe}'/></span>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title" style="width:30%"><b>기부자현장 :</b></li>
                                <li style="width:70%">
                                    <span class="f-size12 marginL10"><c:out value='${userInfo.sptdpstnNm}'/></span>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title" style="width:30%"><b>기부자명 :</b></li>
                                <li style="width:70%">
                                    <span class="f-size12 marginL10" id="dpstnNm"><c:out value='${detail.dpstnNm}'/></span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="form_date_serch" style="padding-right:0px;">
                    <div class="row">
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title" style="width:30%"><b>기부금액 :</b></li>
                                <li style="width:70%">
                                    <span class="f-size12 marginL10 money"><fmt:formatNumber value="${detail.trumny}" pattern="#,###" /> 원</span>
                                </li>
                            </ul>
                        </div>
                        <div class="col-lg-4 col-md-4 col-xs-4 form">
                            <ul>
                                <li class="form_title" style="width:30%"><b>영수증발급 :</b></li>
                                <li style="width:70%">
                                    <span class="f-size12 marginL10">
                                        <c:if test='${detail.rceptReqstAt =="02"}'>미신청</c:if>
                                        <c:if test='${detail.rceptReqstAt =="01"}'>신청</c:if>
                                    </span>
                                </li>
                            </ul>
                        </div>
                     </div>
                </div>
            </div>
            <div class="row">
                <div  class="col-lg-12 col-md-12 col-xs-12 colorR fontBold f-size12 paddingB10">*필수입력</div>
            </div>
            <div class="row">
                <div class="input_box">
                    <div class="" >
                        <div class=" table_form04">
                            <!-- info table -->
                            <div class="info_table">
                                <table>
                                    <colgroup>
                                        <col style="width: 120px;" />
                                        <col style="width: auto;" />
                                    </colgroup>
                                    <tbody>
                                        <tr>
                                            <th>삭제이유 :</th>
                                            <td>
                                            <textarea id="deleteResn" name="deleteResn" class="sfn_required sfn_maxlength" rows="10" style="width: 100%;text-align:left" title="삭제사유"><c:out value='${detail.deleteResn}'/></textarea>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                            <!-- info table end -->
                        </div>
                    </div>
                </div>
            </div>
            <c:if test='${detail.deleteAt != "1"}'> 
             <div class="tr marginT10"><span id="btnDelete" class="btn_type_03_wide">삭제</span></div>
            </c:if>
            <c:if test='${detail.deleteAt == "1"}'> 
             <div class="tr marginT10">삭제 된 접수건입니다.</div>
            </c:if>
        </form>
        </div>
    </div>
</div>
