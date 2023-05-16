<%@ page session="true" buffer="none" contentType="text/html; charset=utf-8"%>
<%@ include file="/include/taglib.h"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<!------------------------------------------------------------------------
Local Java Script
-------------------------------------------------------------------------->
<link rel="stylesheet" href="/css/chest_ams.css">
<SCRIPT LANGUAGE="JavaScript">
	function Installed()
	{
		try
		{
			return (new ActiveXObject('IEPageSetupX.IEPageSetup'));
		}
		catch (e)
		{
			return false;
		}
	}

	function printMe()
	{
		if (!Installed())
		{
			alert("컨트롤을 설치하지 않았습니다. 정상적으로 인쇄되지 않을 수 있습니다.");
		}
	}

	function printClick_old(){
		document.getElementById("prt1").style.display = "none";
		document.getElementById("prt2").style.display = "none";
		IEPageSetupX.header = "";
		IEPageSetupX.footer = "";
		IEPageSetupX.leftMargin = "5";
		IEPageSetupX.rightMargin = "5";
		IEPageSetupX.PrintBackground = true;
//		IEPageSetupX.ShrinkToFit = true;
		IEPageSetupX.Print(true);
//		IEPageSetupX.Preview();
	}

	function printClick(){
		$("#prt1").hide();
		$("#prt2").hide();
		window.print();
	}
	
	
</SCRIPT>

<style type="text/css">
	.a{font-size:30px;line-height:30px;backgroud:#000000}
</style>

<!--  
<BODY OnLoad="printMe();" OnUnload="if (Installed()) IEPageSetupX.RollBack();">
<OBJECT id=IEPageSetupX classid="clsid:41C5BC45-1BE8-42C5-AD9F-495D6C8D7586" codebase="https://br.chest.or.kr/js/IEPageSetupX.cab#version=1,4,0,3" style="width:0;height:0">
	<param name="copyright" value="http://isulnara.com">
	<div style="position:absolute;top:276;left:320;width:300;height:68;border:solid 1 #99B3A0;background:#D8D7C4;overflow:hidden;z-index:1;visibility:visible;"><FONT style='font-family: "굴림", "Verdana"; font-size: 9pt; font-style: normal;'></div>
</OBJECT>
-->
<!--//one line-->
<BODY>
<div align="center">
<div id="prt1">
<table width="720" border="0" cellspacing="0" cellpadding="10">
  <tr>
    <td align="center" height="50px"><a href="javascript:printClick();"><img src="/img/popup/bt_print.gif" border="0"></a></td>
  </tr>
</table>
</div>
<table width="720" border="0" cellpadding="0" cellspacing="0" bgcolor="#7288E2">
  <tr>
    <td background="/img/popup/logo_bg_print.gif" bgcolor="#FFFFFF" style="background-repeat:no-repeat; background-position:center">
		<table width="100%" border="1" cellpadding="1" cellspacing="0">
		  <tr>
			<td colspan="5">
			  <table width="100%" border="0">
				<tr>
				  <td>&nbsp;</td>
				  <td width="35%" height="40px">
					<table width="100%" border="1" cellpadding="1" cellspacing="0">
					  <tr>
						<td width="30%" height="25px">
						  <div align="center">일련번호</div>
						  </td>

						<td width="70%">
						  <div align="center"><c:out value='${detail.rceptNo}'/></div>
						  </td>
						</tr>
					  </table>
					</td>

				  <td width="30%"  height="50px">
					<div align="center"><div class="a"><b>기부확인서</b></div></div>
				  </td>
				  <td width="35%">
				  </td>
				</tr>
			  </table>
			</td>
		  </tr>
		  <tr>
			<td colspan="4" bgcolor="#CCCCCC" height="25px">&nbsp;<b>1. 기탁자</b></td>
		  </tr>
		  <tr>
			<td width="20%" height="25px">
			  <div align="center">성 명 (법 인 명)</div>
			</td>
			<td width="30%">&nbsp;<c:out value='${detail.dpstnNm}'/></td>
			<td width="20%" align=center>
			  주민등록번호<br>(사업자등록번호)
			</td>
			<td width="30%">&nbsp;<c:out value='${ihidnumBizrno}'/></td>
		  </tr>
		  <tr>
			<td width="20%" align=center>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</td>
			<td colspan="3" height="25px">&nbsp;<c:out value='${detail.adres1}'/> <c:out value='${detail.adres2}'/></td>
		  </tr>
		  <tr>
			<td colspan="4" bgcolor="#CCCCCC"  height="25px">&nbsp;<b>2. 기부처</b></td>
		  </tr>
		  <tr>
			<td width="20%" height="25px">
			  <div align="center">기 부 처(법인명)</div>
			</td>
			<td width="30%">&nbsp;<c:out value='${detail.slldNm}'/></td>
			<td width="20%" align=center>
			  사업자등록번호
			</td>
			<td width="30%">&nbsp;<c:out value='${detail.bizrno}'/></td>
		  </tr>
		  <tr>
			<td width="23%" height="25px">
			  <div align="center">주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;소</div>
			</td>
			<td width="28%" colspan=3>&nbsp;<c:out value='${detail.bhfAddres}'/></td>
		  </tr>
		  <tr>
			<td colspan="4" bgcolor="#CCCCCC"  height="25px">&nbsp;<b>3.  발급처</b></td>
		  </tr>
		  <tr>
			<td width="23%" height="25px">
			  <div align="center">발&nbsp;급&nbsp;처 ( 현 장 )</div>
			</td>
			<td width="28%" colspan=3>&nbsp;<c:out value='${detail.sptdpstnNm}'/></td>
		  </tr>
		</table>
		<table width="100%" border="1" cellpadding="1" cellspacing="0">
		  <tr>
			<td colspan="5" bgcolor="#CCCCCC"  height="25px">&nbsp;<b>4. 기부내용</b></td>
		  </tr>
		  <tr>
			<td width="33%" height="25px">
			  <div align="center"><b>년 월 일</b></div>
			</td>
			<td width="33%">
			  <div align="center"><b>적&nbsp;&nbsp;&nbsp;&nbsp;요</b></div>
			  <b><font color="#000000" size="5"></font></b></td>
			<td width="34%">
			  <div align="center"><b>금&nbsp;&nbsp;&nbsp;&nbsp;액</b></div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center"><c:out value='${detail.rceptDe}'/></div>
			</td>
			<td width="26%">
			  <div align="center">현금</div>
			</td>
			<td width="26%">
			  <div align="right"><fmt:formatNumber value="${detail.trumny}" pattern="#,###" /> 원&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td width="22%" height="22px">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
			<td width="26%">
			  <div align="center">&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td colspan="2" align=center bgcolor="#CCCCCC"  height="22px"><b>합&nbsp;&nbsp;계</b></td>
			<td colspan="3" bgcolor="#CCCCCC">
			  <div align="right"><b><fmt:formatNumber value="${detail.trumny}" pattern="#,###" /> 원</b>&nbsp;</div>
			</td>
		  </tr>
		  <tr>
			<td colspan="5"  style="position:relative ;">
			  <img src="/img/stamp.jpg" style="position:relative ; top:55px ; left:670px ; width:5% ; height:40px ; border:0" />
			  &nbsp;위와 같이 기부금을 기부하였음을 확인합니다.<br>
			  <div align="right"><jsp:useBean id="now" class="java.util.Date"/><fmt:formatDate value="${now}" pattern="yyyy" />&nbsp;&nbsp;년&nbsp;&nbsp; <fmt:formatDate value="${now}" pattern="MM" />&nbsp;&nbsp;월 <fmt:formatDate value="${now}" pattern="dd" />&nbsp;&nbsp;일&nbsp;&nbsp;</div><br>
			  <div align="right">기부금 수령인&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;사회복지공동모금회장 (인)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div><br>
			</td>
		  </tr>
		  <tr>
			<td colspan="5" height="36"><br>
			  &nbsp;&nbsp;* 개인 기부자의 경우 확인서 작성 시 주민등록번호를 알려주시면 별도의 신청없이 <br>
			  &nbsp;&nbsp;&nbsp;&nbsp;<b><font size=3>국세청 연말간소화서비스</b></font> 를 통해 소득공제 증빙서류의 조회 및 발급이 가능합니다.<br><br>
			  &nbsp;&nbsp;* 법정 소득공제용 기부금영수증 발급을 원하시는 경우 아래 연락처로 연락주시기 바랍니다. <br>
			  &nbsp;&nbsp;&nbsp;&nbsp;국세청에 제출하실 용도가 아니시면 본 확인서를 기부 증빙용으로 사용하시면 됩니다.<br><br>
			  &nbsp;&nbsp;* <b><font size=3>단체명</font></b>으로 기부하신 경우 <b><font size=3>기부금영수증 발급이 불가할 수 있습니다</font></b>. (00일동, 00동호회 등)<br><br>
			  &nbsp;&nbsp;* 기부금영수증 발급 시 기부자명, 주민등록번호(또는 사업자번호), 주소가 필수 기재사항입니다.<br><br>
			</td>
		  </tr>
		</table><br>
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
		  <tr>
			<td width="459">&nbsp;&nbsp;<img src="/img/popup/top_logo.gif"></td>
			<td width="455" colspan="2" align=right><c:out value='${detail.pstmtrAdres}'/>&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3"></td>
		  </tr>
		  <tr>
			<td width="459">&nbsp;<c:out value='${detail.bhfAddres}'/></td>
			<td width="455" colspan="2" align=right><c:out value='${detail.dpstnNm}'/> 귀하&nbsp;</td>
		  </tr>
		  <tr>
			<td colspan="3" align=right></td>
		  </tr>
		  <tr>
			<td colspan=3>&nbsp;TEL : <c:out value='${detail.bhfTelno}'/></td>
		  </tr>
		  <tr>
			<td width="459">&nbsp;FAX : <c:out value='${detail.bhfFxnum}'/></td>
			<td width="455" align=right><c:out value='${detail.pstmtrZip}'/></td>
			<td width="100" align=right>&nbsp;</td>
		  </tr>
		</table>
	</td>
  </tr>
</table>
</body>
<div id="prt2">
<table width="720" border="0" cellspacing="0" cellpadding="10">
  <tr>
    <td align="center"><a href="javascript:printClick();"><img src="/img/popup/bt_print.gif" border="0"></a></td>
  </tr>
</table>
</div>
</div>