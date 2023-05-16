/**
 *******************************************************************
 * @source        : /js/inhand.js 
 * @description   : version v1.0
 *******************************************************************
 * Date        Author        Contents
 * -----------------------------------------------------------------
 * 2005/10/12  Kwag, In Han  Initialize
 * 2011/10/30	June-Hee, Kim	Modify
 *******************************************************************
*/



	/*첨부파일 용량체크*/
	function fileCheck( file ){
	    // 사이즈체크
	    var maxSize  = 10 * 1024 * 1024    //30MB
	    var fileSize = 0;

		var fileExt = file.value.substring(file.value.lastIndexOf(".")+1);
		if(fileExt=="egg"){
			alert("egg파일은 업로드하실 수 없습니다.");
	        file.value="";
			return;
		}

		// 브라우저 확인
		var browser=navigator.appName;

		// 익스플로러일 경우
		if (browser=="Microsoft Internet Explorer")	{
			var oas = new ActiveXObject("Scripting.FileSystemObject");
			fileSize = oas.getFile( file.value ).size;
		} else { // 익스플로러가 아닐경우
			fileSize = file.files[0].size;
		}

	    if(fileSize > maxSize){
	        alert("파일용량 : "+ number_to_human_size(fileSize) +"\n\n첨부파일 용량은 10MB 이내로 등록 가능합니다.");
	        file.value="";
	        return;
	    }
	}

	/*파일사이즈 표시*/
	function number_to_human_size(x) {
		var s = ['bytes', 'kB', 'MB', 'GB', 'TB', 'PB'];
		var e = Math.floor(Math.log(x) / Math.log(1024));
		return (x / Math.pow(1024, e)).toFixed(2) + " " + s[e];
	}


	/*문자열길이 체크하여 화면에 표기*/
	function updateChar(length_limit, obj, display_obj){
		var comment='';
		comment = eval("document.all."+obj);
		var form = document.all;
		var length = calculate_msglen(comment.value);
		document.getElementById(display_obj).innerHTML = length;
		if (length > length_limit) {
			alert("최대 " + length_limit + "byte이므로 초과된 글자수는 자동으로 삭제됩니다.");
			comment.value = comment.value.replace(/\r\n$/, "");
			comment.value = assert_msglen(comment.value, length_limit, display_obj);
		}
	}

	/*문자열길이(Byte) Return*/
	function calculate_msglen(message){
		var nbytes = 0;

		for (i=0; i<message.length; i++) {
			var ch = message.charAt(i);

			if(escape(ch).length > 4) {
				nbytes += 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					nbytes += 1;
				}
			} else if (ch == '<' || ch == '>') {
				nbytes += 4;
			} else {
				nbytes += 1;
			}
		}

		return nbytes;
	}

	function assert_msglen(message, maximum, display_obj){
		var inc = 0;
		var nbytes = 0;
		var msg = "";
		var msglen = message.length;

		for (i=0; i<msglen; i++) {
			var ch = message.charAt(i);
			if (escape(ch).length > 4) {
				inc = 2;
			} else if (ch == '\n') {
				if (message.charAt(i-1) != '\r') {
					inc = 1;
				}
			} else if (ch == '<' || ch == '>') {
				inc = 4;
			} else {
				inc = 1;
			}

			if ((nbytes + inc) > maximum) {
				break;
			}

			nbytes += inc;
			msg += ch;
		}
		if(display_obj!=null){
			document.getElementById(display_obj).innerHTML = nbytes;
		}	
		return msg;
	}

//-------------------------------------------
// iframe사이즈조정
//-------------------------------------------
function resizeFrame(iframeObj){
    iframeObj = document.getElementById(iframeObj);
    var innerBody = iframeObj.contentWindow.document.body;
    oldEvent = innerBody.onclick;
    innerBody.onclick = function(){ resizeFrame(iframeObj, 1);oldEvent; };
    var innerHeight = innerBody.scrollHeight + (innerBody.offsetHeight - innerBody.clientHeight);
    iframeObj.style.height = innerHeight+"px";
    var innerWidth = innerBody.scrollWidth + (innerBody.offsetWidth - innerBody.clientWidth);
    iframeObj.style.width = innerWidth;     
    if( !arguments[1] )       
            this.scrollTo(1,1);

}


//-------------------------------------------
// 날짜유효성체크
//-------------------------------------------
function isValidDate(iDate){
	if(iDate.length !=8){
		return false;
	}
	
	oDate = new Date();
	oDate.setFullYear(iDate.substring(0,4));
	oDate.setMonth(parseInt(iDate.substring(4,6))-1);
	oDate.setDate(iDate.substring(6));
	
	if(oDate.getFullYear() != iDate.substring(0,4)
	   || oDate.getMonth() + 1 != iDate.substring(4,6)
	   || oDate.getDate() != iDate.substring(6)){
		return false;   
	}  
	
	return true;
}

//-------------------------------------------
// 날짜필드 focus on
//-------------------------------------------
function focusOnDate(_filed){
	_filed.value = _filed.value.replace(/-/g,'');
	_filed.select();
}	

//-------------------------------------------
// 날짜필드 focus out
//-------------------------------------------
function focusOutDate(_filed){
	var str = _filed.value;
	if(str!=""){
		if(str.length==8 && isValidDate(str)){
			_filed.value = str.substring(0,4)+"-"+str.substring(4,6)+"-"+str.substring(6,8); 
		} else {
			alert("날자포맷이 틀리거나 없는 날짜입니다.");
			_filed.select();
		}
	}		
}	

//-------------------------------------------
// 객체 타입
//-------------------------------------------
function getElementType(oElement) {
	if (oElement == null) {
		return null;
	}

	switch (oElement.tagName) {
		case "INPUT":
			switch (oElement.type) {
				case "button" :
					return "BUTTON";
				case "checkbox" :
					return "CHECKBOX";
				case "file" :
					return "FILE";
				case "hidden" :
					return "HIDDEN";
				case "image" :
					return "IMAGE";
				case "password" :
					return "PASSWORD";
				case "radio" :
					return "RADIO";
				case "reset" :
					return "RESET";
				case "submit" :
					return "SUBMIT";
				case "text" :
					return "TEXT";
				default :
					return null;
			}
		case "IMG":
			return "IMG"
		case "SELECT":
			return "SELECT"
		case "TEXTAREA":
			return "TEXTAREA"
		case "OBJECT":
			return "OBJECT"
		default :
			return null;
	}
}


//-------------------------------------------
//LPAD
//-------------------------------------------
function sfn_lpad(length, str) {
	var numStr = number + "";
	var zeroChars = "";

	for (var i = 0; i < (length - numStr.length); i++) {
		zeroChars = zeroChars + "0";
	}

	return (zeroChars + numStr);
}

//-------------------------------------------
// NULL 일 때 
//-------------------------------------------
function sfn_isNull(value) {
	if (value == null || (typeof(value) == "string" && sfn_trim(value) == "") ) {
		return true;
	}else{
		return false;
	}
}

//-------------------------------------------
// trim
//-------------------------------------------
function sfn_trim(inStr) { //????? ??? ???? (trim)
	var re = / /gi;
	inStr = inStr != null ? inStr.replace(re, ""): null;
	return inStr;
}

//-------------------------------------------
// 현금 포맷
//-------------------------------------------
function getMoneyFormat( input )
{
	var inputLength = input.length;
	var share = inputLength/3;
	var rest = inputLength%3;
	var returnValue;

	if( input.substring( 0, 1 ) != "-" )
	{
		if( inputLength < 4 )
			return input;
		else
		{
			//3?? ???
			if( rest == 0 )
			{
				returnValue = input.substr( 0, 3 ) +",";

				for( i = 1; i < share; i++ )
					returnValue += input.substr( i*3, 3 ) +",";

				return returnValue.substring( 0, returnValue.lastIndexOf( "," ) );
			}
			else if( rest == 1 )
			{
				returnValue = input.substr( 0, 1 ) +",";

				for( i = 0; i < share; i++ )
					returnValue += input.substr( (i*3) + 1, 3 ) +",";

				return returnValue.substring( 0, returnValue.lastIndexOf( "," ) - 1 );
			}
			else if( rest == 2 )
			{
				returnValue = input.substr( 0, 2 ) +",";

				for( i = 0; i < share; i++ )
					returnValue += input.substr( (i*3) + 2, 3 ) +",";

				return returnValue.substring( 0, returnValue.lastIndexOf( "," ) -1 );
			}
		}
	}
	else
	{
		if( inputLength < 5 )
			return input;
		else
		{
			//3?? ???
			if( rest == 0 )
			{
				returnValue = input.substr( 0, 3 ) +",";

				for( i = 1; i < share; i++ )
					returnValue += input.substr( i*3, 3 ) +",";

				return returnValue.substring( 0, returnValue.lastIndexOf( "," ) );
			}
			else if( rest == 1 )
			{
				returnValue = input.substr( 0, 4 ) +",";

				for( i = 1; i < share; i++ )
					returnValue += input.substr( (i*3) + 1, 3 ) +",";

				return returnValue.substring( 0, returnValue.lastIndexOf( "," ) - 1 );
			}
			else if( rest == 2 )
			{
				returnValue = input.substr( 0, 2 ) +",";

				for( i = 0; i < share; i++ )
					returnValue += input.substr( (i*3) + 2, 3 ) +",";

				return returnValue.substring( 0, returnValue.lastIndexOf( "," ) -1 );
			}
		}
	}
}

//--------------------------------------------------------
//현금 포맷
//사용예) OnKeyUp="sfn_setMoneyFormat(this)"
//--------------------------------------------------------
function sfn_setMoneyFormat(_el){
	//alert(_el.value);
	var len;
	var str = _el.value;
	str = str.replace(/,/g,'');
	//maxlength 보다 크면 그만하기
	if (str.length > _el.maxlength){
		return;
	}
	
	if ( !/\d/.test(str) ){
		
	}
	var str1 = '';
	len = str.length;
	if(len>3){
		for(var i=0; len-i-3>0;i+=3){
			str1 = ','+str.substring(len-3-i, len-i)+str1;
		}
		str1 = str.substring(0,len-i)+str1;
		_el.value = str1;
	}else{
		_el.value = str;
	}
}

//--------------------------------------------------------
//숫자만 입력
//--------------------------------------------------------
//function sfn_onlyNumber(_el) {
//	//alert(event.keyCode);
//	//숫자키, 방향키, 백스페이스키, 탭키
//	if( !(( event.keyCode > 47 && event.keyCode < 58) 
//			|| ( event.keyCode > 95 && event.keyCode <106 ) 
//			|| event.keyCode==8 || event.keyCode==37 || event.keyCode==39
//			|| event.keyCode==9) ) {
//		//event.returnValue = false;
//		event.preventDefault(); 
//	}
//}

function sfn_onlyNumber(_el) {
	if(_el.style.imeMode != "disabled"){
		_el.value="";
		_el.style.imeMode = "disabled";
		_el.blur();
		_el.focus();
	}
	//숫자키, 방향키, 백스페이스키, 탭키
	if( !(( event.keyCode > 47 && event.keyCode < 58) 
			|| ( event.keyCode > 95 && event.keyCode <106 ) 
			|| event.keyCode==8 || event.keyCode==37 || event.keyCode==39
			|| event.keyCode==9) ) {
		//event.returnValue = false;
		event.preventDefault();
	}
}

function onlyNumber2(_el) {
	if( !(( event.keyCode > 47 && event.keyCode < 58) 
			|| ( event.keyCode > 95 && event.keyCode <106 ) 
			|| event.keyCode==8 || event.keyCode==37 || event.keyCode==39
			|| event.keyCode==9) ) {
		//event.returnValue = false;
		event.preventDefault();
	}
}


//--------------------------------------------------------
//영어, 숫자만 입력
//--------------------------------------------------------
function sfn_onlyAlphaNumber(_el) {
	//alert(event.keyCode);
	if( !((event.keyCode > 47 && event.keyCode < 58)
			|| (event.keyCode > 64 && event.keyCode < 91)
			|| (event.keyCode > 96 && event.keyCode < 123)
			|| (event.keyCode > 95 && event.keyCode <106 ) 
			|| event.keyCode==8 || event.keyCode==37 || event.keyCode==39
			|| event.keyCode==9) ) {
//		event.returnValue = false;
		event.preventDefault();
	}
}

//-------------------------------------------
// 쿠키 만들기
//-------------------------------------------
function setCookie(name, value, domain, expires)
{
  // cookie ????? ???? ????
  document.cookie = name + "=" + value + "; domain=" + domain +  "; expires=" + expires + "; path=/";
}


// ?????? ????? Cookie?????? ??????
function getCookie(name)
{
  var Found = false;
  var start, end;
  var i = 0;
  // cookie ????? ??u?? ???
  while ( i <= document.cookie.length ) {
    start = i;
    end = start + name.length;
    // name?? ?????? ????? ????
    if ( document.cookie.substring(start, end) == name ) {
      Found = true;
      break;
    }
    i++;
  }

  // name ??????? cookie???? a????
  if ( Found == true ) {
    start = end + 1;
    end = document.cookie.indexOf(";", start);

    // ?????? ?κ????? ???? ???(?????????? ";"?? ???)
    if ( end < start )
      end = document.cookie.length;

    // name?? ?????? value???? ??????? ???????.
    return unescape(document.cookie.substring(start, end));
  }
  // a?? ??????
  return "";
}

/**
 * @type   : function
 * @access : public
 * @desc   : ???????? Popup ????? ??? ????? u?
 * <pre>??뿹 :
 *     detectPopupBlockers(); => ????? ???? ?????? Alert ??????? ????.
 * </pre>
 * @param  : (None)
 * @return : (None)
 */

// Popup Check
function detectPopupBlockers() {
	var popBlock = 0;
	try {
		var top = 0;
		var left = screen.width;
		var testWin = window.open('/PopupTest.jsp','PopupTest','width=1,height=1,left=' + left + ',top=' + top + ',scrollbars=no,toolbar=no,menubars=no,location=no,status=no,titlebar=no');
		var testWinName = testWin.name;
		testWin.close();
	 } catch (exception) {
		window.focus();
		alert("?? ??????? ????? ??? ??????? ?????? ?????.");
		popBlock = 1;
		return false;
	} 
	return true;

}

//-------------------------------------------
// 모달 팝업 열기
//-------------------------------------------
 function openModalDlg(){
  	var args=openModalDlg.arguments ;
 	var url, param, features , width, height;
 	
 	url = args[0] ;
 	param = null ;
 	width = "400px" ;
 	height = "435px" ;
 	features = "resizable:no;center:yes;help:no;status:no;scroll:no;" ;
/* 	
 	if (event != null){
		features += "dialogTop:"+(window.screenTop + event.clientY/2 )+"px;dialogLeft:"+( window.screenLeft + event.clientX )+"px;" ;
 	}
*/ 	
 	switch (args.length.toString()){
 		case '3' :
		 	if (args[1].toString().indexOf("px") > -1 ) width = args[1] ;
		 	else	width = args[1]+ "px" ;
		 	if (args[2].toString().indexOf("px") > -1 ) height = args[2] ;
		 	else	height = args[2]+ "px" ;
 			break ;
 		case '4' :
		 	if (args[2].toString().indexOf("px") > -1 ) width = args[2] ;
		 	else	width = args[2]+ "px" ;
		 	if (args[3].toString().indexOf("px") > -1 ) height = args[3] ;
		 	else	height = args[3]+ "px" ;
 			param = args[1] ;
 			break ;	
 		case '5' :
		 	if (args[2].toString().indexOf("px") > -1 ) width = args[2] ;
		 	else	width = args[2]+ "px" ;
		 	if (args[3].toString().indexOf("px") > -1 ) height = args[3] ;
		 	else	height = args[3]+ "px" ;
 			param = args[1] ;
 			features += "dialogTop:" +Number(screen.height/2-Number(args[3])/2) +"px;dialogLeft:"+ Number(screen.width/2-Number(args[2])/2)+"px;" ;
 			break ; 					
 		default :
 			break ;
 	} 
	// Explorer ???? ??? ????? ?????? ????(??? Ver.7?? ??????? u??? ???? ???(30px)
	if(navigator.appVersion.indexOf("MSIE 7") != -1 && navigator.appVersion.indexOf("MSIE 8") != -1 ){ 
	
	} else {
		height = height.substr(0,height.length-2);
		height = parseInt(height) + 30;
		height = height + "px";
	}
 	features += "dialogWidth:" + width + ";dialogHeight:" + height ;	
// 	alert("url=" + url + "\n param=" + param + "\n features=" + features) ;
 	return window.showModalDialog(url,param,features) ;
 }

//-------------------------------------------
// 팝업 열기
//-------------------------------------------
 function openWin(){
 	var args=openWin.arguments ;
 	var url, target, features , width, height;
 	url = args[0] ;
 	target = "popDefault" ;
 	width = "400px" ;
 	height = "435px" ;
 	features = "resizable=no,toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes," ;
 	
 	switch (args.length.toString()){
 		case '3' :
 			features += "width=" + args[1] + ",height=" + args[2] ;		
 			break ;
 		case '4' :
 			target = args[1] ;
 			features += "width=" + args[2] + ",height=" + args[3] ;
 			features += ",left=" + Number(screen.width/2-Number(args[2])/2) +",top=" + Number(screen.height/3-Number(args[3])/2);
 			break ;
 		case '5' :
 			if (args[4]){
			}
 			target = args[1] ;
 			features += "width=" + args[2] + ",height=" + args[3] ;
 			break ;
 		case '6' :
 			target = args[1] ;			 		
			features += "titlebar=no,left=" + Number(screen.width/2-Number(args[2])/2) +",top=" +  Number(screen.height/2-Number(args[3])/2) + "," ;
 			features += "width=" + args[2] + ",height=" + args[3] ;		
 			break ; 			
 		default :
 			features += "width=" + width + ",height=" + height ;
 			break ;
 	}
 		
 		// alert("[url]" + url + "[target]" + target + "[features]" + features) ;
 	return window.open(url,target,features) ;
 }


//-------------------------------------------
// 파일업로드시 파일명만 추출
//-------------------------------------------
function getNameFromPath(strFilePath){
	var objRE = new RegExp(/([^\/\\]+)$/);
	var strName = objRE.exec(strFilePath);

	if(strName == null){
		return null;
	} else {
		return strName[0];
	}		
}	


//-------------------------------------------
// 문자열의 bytes수 계산
//-------------------------------------------
function calculate_str(str){
	var nbytes = 0;
	for(i=0; i < str.length; i++){
		var ch = str.charAt(i);
		if(escape(ch).length > 4){
			nbytes += 2;
		} else if (ch == '\n'){
			if(str.charAt(i-1) != '\r'){
				nbytes += 1;
			}	
		} else if (ch == '<' || ch == '>'){
			nbytes += 4;
		} else {
			nbytes += 1;
		}					
	}		
	return nbytes;
}	


//-------------------------------------------
// 배경색
//-------------------------------------------
 function chtr(obj){ 
 obj.style.backgroundColor="#fcf2d3";
 }

 function chtr1(obj){ 
 obj.style.backgroundColor="#FFFFFF";
 }
 
 
 //-------------------------------------------
 // Disabled (2011/09/08,jhkim)
 // 필수: jQuery.js
 //-------------------------------------------
 function sfn_offEnabled(){
		var el = document.getElementsByTagName("input");
		var el_textarea = document.getElementsByTagName("textarea");
		var el_select = document.getElementsByTagName("select");
		for(var i=0; i<el.length; i++){
			el[i].disabled = true;
		}
		for(var i=0; i<el_textarea.length; i++){
			el_textarea[i].disabled = true;
		}
		for(var i=0; i<el_select.length; i++){
			el_select[i].disabled = true;
		}
 }
 
 function sfn_onEnabled(){
	 /*
	$('select').attr("disabled", false);
	$('input').attr("disabled", false);
	$('textarea').attr("disabled", false);
	*/
	//문서내 입력 필드 모두 enabled
	var el = document.getElementsByTagName("input");
	var el_textarea = document.getElementsByTagName("textarea");
	var el_select = document.getElementsByTagName("select");
	for(var i=0; i<el.length; i++){
		el[i].disabled = false;
	}
	for(var i=0; i<el_textarea.length; i++){
		el_textarea[i].disabled = false;
	}
	for(var i=0; i<el_select.length; i++){
		el_select[i].disabled = false;
	}
 }
 
//-------------------------------------------
 // Readonly (2011/09/08,jhkim)
 // 필수: jQuery.js
 //-------------------------------------------
 function sfn_onReadonly(){
		var el = document.getElementsByTagName("input");
		var el_textarea = document.getElementsByTagName("textarea");
		var el_select = document.getElementsByTagName("select");
		for(var i=0; i<el.length; i++){
			el[i].disabled = true;
		}
		for(var i=0; i<el_textarea.length; i++){
			el_textarea[i].disabled = true;
		}
		for(var i=0; i<el_select.length; i++){
			el_select[i].disabled = true;
		}
 }
 
 function sfn_offReadonly(){
		var el = document.getElementsByTagName("input");
		var el_textarea = document.getElementsByTagName("textarea");
		var el_select = document.getElementsByTagName("select");
		for(var i=0; i<el.length; i++){
			el[i].disabled = false;
		}
		for(var i=0; i<el_textarea.length; i++){
			el_textarea[i].disabled = false;
		}
		for(var i=0; i<el_select.length; i++){
			el_select[i].disabled = false;
		}
 }
 
 //-------------------------------------------
 // 달력 생성 (2011/09/08,jhkim)
 // 필수파일: calendar.js, calendar.css
 // 파라미터: 달력을 그릴 영역 ID(div), 입력필드 NAME(input)
 //-------------------------------------------
 function sfn_loadCalendar(_areaName, _fieldName){
		g_globalObject2 = new JsDatePick({
			useMode:1,
			isStripped:false,
			target:_areaName,
			dateFormat:"%Y-%m-%d"
			/*selectedDate:{				This is an example of what the full configuration offers.
				day:5,						For full documentation about these settings please see the full version of the code.
				month:9,
				year:2006
			},
			yearsRange:[1978,2020],
			limitToToday:false,
			cellColorScheme:"beige",
			dateFormat:"%m-%d-%Y",
			imgPath:"img/",
			weekStartDay:1*/
		});

		
		g_globalObject2.setOnSelectedDelegate(function(){
			var obj = g_globalObject2.getSelectedDay();
			document.getElementById(_fieldName).value = obj.year+"-"+((obj.month+"").length==1?"0"+obj.month:obj.month) +"-"+((obj.day+"").length==1?"0"+obj.day:obj.day);
			this.closeCalendar();
		});
		
}
 
 //--------------------------------------------------------
 // 무결성 체크
 // 사용법) scl_validator.validate([FORM_NAME]);
 // RETURN) 정규식 통과 true, 실패 false
 //--------------------------------------------------------
var scl_validator = {
	validate : function(_form) {
		var elements = _form.elements;
		for(var i = 0; i <elements.length;i++) {
			var el = elements[i];
			if (!el.disabled){ //if not disabled
				var classes = el.className.split(" ");
				for(var j = 0; j < classes.length; j++) {
					// 각 클래스 명
					var className = classes[j].replace(" ").replace("-","");
					// 클래스명과 일치하는 메서드가 있으면...
					if(scl_validator[className]) {
						//var message = Validator[className](el.value);
						var message = scl_validator[className](el.value, el);
						// 오류가 있으면 메시지를 반환
						if(message) {
							scl_validator._handleError(message, el);
							return false;
						}
					}
				}
		}
			
			
		}
		return true;
	},
	//-------------------------------------------
	// 오류제어
	//-------------------------------------------
	_handleError : function(message, el) {
		var title = scl_validator._getTitle(el);
		alert(title +"(은)는 " + message);
		//el.focus();
	}, 
	_getTitle : function (el) {
		return el.title ? el.title : el.name;
	},
	//-------------------------------------------
	// 정규식
	//-------------------------------------------
	sfn_required : function(v) {
		return !v ? "반드시 입력하셔야 합니다." : false;
	},
	sfn_maxlength : function(v, el) {
//		alert(el.getAttribute("maxlength"));
//		alert(v.length);
		return el.getAttribute("maxlength") < v.length ? el.getAttribute("maxlength") + "자 이하로 입력하셔야 합니다." : false;
	},
	sfn_minlength : function(v) {
		return el.getAttribute("maxlength") > v.length ? el.getAttribute("maxlength") + "자 이상 입력하셔야 합니다." : false;
	},
	sfn_number : function(v) {
		return isNaN(v) || /^\s+$/.test(v) ? "숫자로 입력하셔야 합니다." : false;
	},
	sfn_digits : function(v) {
		return isNaN(v) || /[^\d]/.test(v)? "숫자만 입력하셔야 합니다." : false;			
	},
	sfn_alpha : function(v) {
		return /^[a-zA-Z]+$/.test(v) ? "알파벳만 입력하셔야 합니다." : false;
	},
	sfn_alphanum : function(v) {
		return /\W/.test(v) ? "알파벳과 숫자만 입력하셔야 합니다." : false;
	},
	sfn_date : function(v) {
		var _ymd = v.split("-");
		var date = new Date(_ymd[0], String(Number(_ymd[1])-1),_ymd[2]);
		return isNaN(date) ? "바른 날짜 형식으로 입력하셔야 합니다. \n(예:2010-12-31)" : false;
	},
	sfn_email : function(v) {
		return !/\w{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/.test(v) ? "바른 이메일 주소를 입력하셔야 합니다." : false;
	},
	sfn_url : function(v) {
		return !/^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)(:(\d+))?\/?/i.test(v) ? "바른 URL을 입력하셔야 합니다." : false;
	},
	sfn_tel : function(v) {
		return !/(\d{2,3}).*(\d{3,4}).*(\d{4})/.test(v) ? "바른 전화번호 형식으로 입력하셔야 합니다." : false;
	},
	//sfn_zipcode : function(v) {
	//	return !/(\d{4}).*(\d{4})/.test(v) ? "바른 전화번호 형식으로 입력하셔야 합니다." : false;
	//},
	sfn_passwd: function(v) {
		//return !/^[a-zA-Z0-9]{5,20}$/.test(v) ? "비밀번호는 영문,숫자 혼합 5자리 이상이어야 합니다." : false;
		//return !/(?=.*\d)(?=.*[a-zA-Z]).{5,20}/.test(v) ? "비밀번호는 영문,숫자 혼합 5자리 이상이어야 합니다." : false;

		var CHCK = /^[a-zA-Z0-9]{5,20}$/;
		var chckVal = CHCK.test(v);
		var confmVal = true;

		if (!v || v.length < 5 || !chckVal) {
		  confmVal = false;
		}

		return !confmVal ? "비밀번호는 영문,숫자 혼합 5자리 이상이어야 합니다." : false;
	},
	sfn_bizno: function(v) {
		  return !/^[0-9]{10}$/.test(v) ? "사업자 번호 10자리를 확인하십시오." : false;
	}
	
}

/*
전자우편 주소:
/^[a-z0-9_+.-]+@([a-z0-9-]+\.)+[a-z0-9]{2,4}$/

URL:
/^(file|gopher|news|nntp|telnet|https?|ftps?|sftp):\/\/([a-z0-9-]+\.)+[a-z0-9]{2,4}.*$/

HTML 태그 - HTML tags:
/\<(/?[^\>]+)\>/

전화 번호 - 예, 123-123-2344 혹은 123-1234-1234:
/(\d{3}).*(\d{3}).*(\d{4})/

날짜 - 예, 3/28/2007 혹은 3/28/07:
/^\d{1,2}\/\d{1,2}\/\d{2,4}$/

jpg, gif 또는 png 확장자를 가진 그림 파일명:
/([^\s]+(?=\.(jpg|gif|png))\.\2)/

1부터 50 사이의 번호 - 1과 50 포함:
/^[1-9]{1}$|^[1-4]{1}[0-9]{1}$|^50$/

16 진수로 된 색깔 번호:
/#?([A-Fa-f0-9]){3}(([A-Fa-f0-9]){3})?/

적어도 소문자 하나, 대문자 하나, 숫자 하나가 포함되어 있는 문자열(8글자 이상 15글자 이하) - 올바른 암호 형식을 확인할 때 사용될 수 있음:
/(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{8,15}/
 * */

//-------------------------------------------
// 주민등록번호
//-------------------------------------------
function sfn_jumin (_v)
{
	var arg_v = _v.replace(/-/g,'');
	ResNo1 = arg_v.substring(0, 6);
	ResNo2 = arg_v.substring(6);
	
	var chk = 0;
	var yy  = ResNo1.substring(0,2);
	var mm  = ResNo1.substring(2,4);
	var dd  = ResNo1.substring(4,6);
	var sex = ResNo2.substring(0,1);

	if (ResNo1.length != 6) 
	{
		// 길이가 짧다.
		return false;
	}
	
	if ((sex != 1 && sex != 2 && sex != 3 && sex != 4) || (ResNo2.length != 7)) 
	{
		// 뒷자리 이상하다.
		return false;
	}   

	if ((ResNo1.length == 6) && (ResNo2.length == 7)) 
	{
		var ich = parseInt(sex, 10);	
		switch(ich) 
		{
			case 1: break;
			case 2: break;
			case 3: if(yy == 00) break;
			case 4: if(yy == 00) break;
			default:
				// 이건 뭘까...
				return false;
		}
	}
	
	for(var i = 0; i <=5; i++) 
	{ 
		chk = chk + (((i % 8) + 2) * parseInt(ResNo1.substring(i, i + 1)));
	}
	
	for(var i = 6; i <= 11; i++) 
	{
		chk = chk + (((i % 8) + 2) * parseInt(ResNo2.substring(i - 6, i - 5)));
	}
	
	chk = 11 - (chk % 11);
	chk = chk % 10;
	
	if(chk != ResNo2.substring(6, 7)) 
	{
		// 이것도 모르겠고....
		return false;
	}
	
	return true;
}


//--------------------------------------------------------
// 페이지 처리 (메인)
// EX) scl_page.load(11, 20, 9999999);
//--------------------------------------------------------
var scl_page = {

	//PAGE ON_LOAD
	load: function( _page, _pageGroup, _total) {
		document.getElementsByName("PAGE").value = _page;
		document.getElementsByName("PAGE_GROUP").value = _pageGroup;
		document.getElementsByName("TOTAL").value = _total;

		var prevGroup = _pageGroup-19;
		var nextGroup = _pageGroup+1;
		var prevPage = _page-1;
		var nextPage = _page+1;
		var totalPage = ((_total-1)/10)+1;
		if (_page != 0 ){
			if (prevGroup > 0){
				//scl_page.appendNode(" [prev_group]", prevGroup, false);
				scl_page.appendPrevNext(prevGroup, "arrow_paging_for");
			}
			if (prevPage > 0){
				//scl_page.appendNode(" [prev_page]", prevPage, false);
				scl_page.appendPrevNext(prevPage, "arrow_paging_prev");
			}
			for(var i = 9; i > -1; i--){
				var pageNo = ((_pageGroup)-i);
				if( pageNo > totalPage ){ break; }
				   
				scl_page.appendNode(" " + pageNo, pageNo, ((_page == pageNo) ? true: false));
			}
			
			if (nextPage <= totalPage){
				//scl_page.appendNode(" [next_page]", nextPage, false);
				scl_page.appendPrevNext(nextPage, "arrow_paging_next");
			}
			if (nextGroup <= totalPage){
				//scl_page.appendNode(" [next_group]", nextGroup, false);
				scl_page.appendPrevNext(nextGroup, "arrow_paging_back");
			}
		} else {
			
			scl_page.appendNode("1", 1, true);
		}
		
	},
	
	// APPEND NODE
	appendNode:function(_text, _page, _flag){
		var objPageBar = document.getElementById("c_list_page_bar");
		var prefB;
		
		var prevText = document.createTextNode(_text);
		//var prevA =objPageBar.appendChild(document.createElement("a"));
		var prevA =objPageBar.appendChild(document.createElement("ul"));
		
			prefB = prevA.appendChild(document.createElement("li"));
			
		if (_flag) { //현재페이지
			prefB = prefB.appendChild(document.createElement("a"));
			prefB.setAttribute("class", "on");
			prefB.appendChild(prevText);
			//////////////prefB.setAttribute("className", "page_red");
//			prefB.style.color = 'red';
//			prefB.style.fontSize = '11px';
//			prefB.style.fontFamily = 'dotum, Verdana';
//			prefB.style.letterSpacing = '2px';
//			prefB.style.fontWeight = 'bold';
//			prefB.style.textDecoration = 'none';
//			prefB.style.cursor = 'pointer';
		}else{ //기타 페이지
			////////////prevA.setAttribute("href", "#");
			prevA = prefB.appendChild(document.createElement("a"));
			prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
			prevA.appendChild(prevText);
		}
		//alert(prefB +" / "+prevA);
	},
	appendPrevNext: function (_page, _img){
		var objPageBar = document.getElementById("c_list_page_bar");
		var prefB;
		
		var prevA =objPageBar.appendChild(document.createElement("a"));
		prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
		
		//prefB = objPageBar.appendChild(document.createElement("img"));
		prefB = prevA.appendChild(document.createElement("img"));
		prefB.setAttribute("src","/images/"+_img+".png");
		prefB.style.width = "15";
		prefB.style.height = "13";
		prefB.style.border = "0";
		prefB.style.padding = "0px 3px 0px 3px";
		prefB.setAttribute("align","absmiddle");
	}
	
}


//--------------------------------------------------------
// 페이지 처리 (메인)
// EX) scl_page.load(11, 20, 9999999);
//--------------------------------------------------------
var scl_page_ext = {

	//PAGE ON_LOAD
	load: function( _page, _pageGroup, _total) {
	
		document.getElementsByName("PAGE")(0).value = _page;
		document.getElementsByName("PAGE_GROUP")(0).value = _pageGroup;
		document.getElementsByName("TOTAL")(0).value = _total;
		var prevGroup = _pageGroup-19;
		var nextGroup = _pageGroup+1;
		var prevPage = _page-1;
		var nextPage = _page+1;
		var totalPage = ((_total-1)/15)+1;
		if (_page != 0 ){
			if (prevGroup > 0){
				scl_page_ext.appendPrevNext(prevGroup, "arrow_paging_for");
			}
			if (prevPage > 0){
				scl_page_ext.appendPrevNext(prevPage, "arrow_paging_prev");
			}
			for(var i = 9; i > -1; i--){
				var pageNo = ((_pageGroup)-i);
				if( pageNo > totalPage ){ break; }
				scl_page_ext.appendNode(" " + pageNo, pageNo, ((_page == pageNo) ? true: false));
			}
			
			if (nextPage <= totalPage){
				scl_page_ext.appendPrevNext(nextPage, "arrow_paging_next");
			}
			if (nextGroup <= totalPage){
				scl_page_ext.appendPrevNext(nextGroup, "arrow_paging_back");
			}
		} else {
			scl_page_ext.appendNode("1", 1, true);
		}
		
	},
	
	// APPEND NODE
	appendNode:function(_text, _page, _flag){
		var objPageBar = document.getElementById("c_list_page_bar");
		var prefB;
		
		var prevText = document.createTextNode(_text);
		//var prevA =objPageBar.appendChild(document.createElement("a"));
		var prevA =objPageBar.appendChild(document.createElement("ul"));
		
		    prefB = prevA.appendChild(document.createElement("li"));
		
		if (_flag) { //현재페이지
			prefB = prefB.appendChild(document.createElement("a"));
			prefB.setAttribute("class", "on");
			prefB.appendChild(prevText);
		}else{ //기타 페이지
			prevA = prefB.appendChild(document.createElement("a"));
			prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
			prevA.appendChild(prevText);
		}
	},
	appendPrevNext: function (_page, _img){
		var objPageBar = document.getElementById("c_list_page_bar");
		var prefB;
		
		var prevA =objPageBar.appendChild(document.createElement("a"));
		prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
		
		prefB = prevA.appendChild(document.createElement("img"));
		prefB.setAttribute("src","/images/"+_img+".png");
		prefB.style.width = "15";
		prefB.style.height = "13";
		prefB.style.border = "0";
		prefB.style.padding = "0px 3px 0px 3px";
		prefB.setAttribute("align","absmiddle");
	}
	
}

//--------------------------------------------------------
// 페이지 처리 (메인)
// EX) scl_page.load(11, 20, 9999999);
//--------------------------------------------------------
var scl_page_row = {

	//PAGE ON_LOAD
	load: function( _page, _pageGroup, _total, _row) {
		$("#PAGE").val(_page);
		$("#PAGE_GROUP").val(_pageGroup);
		$("#TOTAL").val(_total);
		var prevGroup = _pageGroup-19;
		var nextGroup = _pageGroup+1;
		var prevPage = _page-1;
		var nextPage = _page+1;
		var totalPage = ((_total-1)/_row)+1;
		if (_page != 0 ){
			if (prevGroup > 0){
				scl_page_row.appendPrevNext(prevGroup, "arrow_paging_for");
			}
			if (prevPage > 0){
				scl_page_row.appendPrevNext(prevPage, "arrow_paging_prev");
			}
			for(var i = 9; i > -1; i--){
				var pageNo = ((_pageGroup)-i);
				if( pageNo > totalPage ){ break; }
				scl_page_row.appendNode(" " + pageNo, pageNo, ((_page == pageNo) ? true: false));
			}
			
			if (nextPage <= totalPage){
				scl_page_row.appendPrevNext(nextPage, "arrow_paging_next");
			}
			if (nextGroup <= totalPage){
				scl_page_row.appendPrevNext(nextGroup, "arrow_paging_back");
			}
		} else {
			scl_page_row.appendNode("1", 1, true);
		}
		
	},
	
	// APPEND NODE
	appendNode:function(_text, _page, _flag){
		var objPageBar = document.getElementById("c_list_page_bar");
		var prefB;
		
		var prevText = document.createTextNode(_text);
		//var prevA =objPageBar.appendChild(document.createElement("a"));
		var prevA =objPageBar.appendChild(document.createElement("ul"));
		
		    prefB = prevA.appendChild(document.createElement("li"));
		
		if (_flag) { //현재페이지
			prefB = prefB.appendChild(document.createElement("a"));
			prefB.setAttribute("class", "on");
			prefB.appendChild(prevText);
		}else{ //기타 페이지
			prevA = prefB.appendChild(document.createElement("a"));
			prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
			prevA.appendChild(prevText);
		}
	},
	appendPrevNext: function (_page, _img){
		var objPageBar = document.getElementById("c_list_page_bar");
		var prefB;
		
		var prevA =objPageBar.appendChild(document.createElement("a"));
		prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
		
		prefB = prevA.appendChild(document.createElement("img"));
		prefB.setAttribute("src","/images/"+_img+".png");
		prefB.style.width = "15";
		prefB.style.height = "13";
		prefB.style.border = "0";
		prefB.style.padding = "0px 3px 0px 3px";
		prefB.setAttribute("align","absmiddle");
	}
	
}

//--------------------------------------------------------
// 페이지 처리 (메인)
// EX) scl_page.load(11, 20, 9999999);
//--------------------------------------------------------
var scl_page_row_ext = {

	//PAGE ON_LOAD
	load: function( _page, _pageGroup, _total, _row, _pageNm, _pageGroupNm, _totalNm) {
	
		document.getElementsByName(_pageNm)(0).value = _page;
		document.getElementsByName(_pageGroupNm)(0).value = _pageGroup;
		document.getElementsByName(_totalNm)(0).value = _total;
		var prevGroup = _pageGroup-19;
		var nextGroup = _pageGroup+1;
		var prevPage = _page-1;
		var nextPage = _page+1;
		var totalPage = ((_total-1)/_row)+1;
		if (_page != 0 ){
			if (prevGroup > 0){
				scl_page_row.appendPrevNext(prevGroup, "arrow_paging_for");
			}
			if (prevPage > 0){
				scl_page_row.appendPrevNext(prevPage, "arrow_paging_prev");
			}
			for(var i = 9; i > -1; i--){
				var pageNo = ((_pageGroup)-i);
				if( pageNo > totalPage ){ break; }
				scl_page_row.appendNode(" " + pageNo, pageNo, ((_page == pageNo) ? true: false));
			}
			
			if (nextPage <= totalPage){
				scl_page_row.appendPrevNext(nextPage, "arrow_paging_next");
			}
			if (nextGroup <= totalPage){
				scl_page_row.appendPrevNext(nextGroup, "arrow_paging_back");
			}
		} else {
			scl_page_row.appendNode("1", 1, true);
		}
		
	},
	
	// APPEND NODE
	appendNode:function(_text, _page, _flag){
		var objPageBar = document.getElementById("c_list_page_bar");
		var prefB;
		
		var prevText = document.createTextNode(_text);
		//var prevA =objPageBar.appendChild(document.createElement("a"));
		var prevA =objPageBar.appendChild(document.createElement("ul"));
		
		    prefB = prevA.appendChild(document.createElement("li"));
		
		if (_flag) { //현재페이지
			prefB = prefB.appendChild(document.createElement("a"));
			prefB.setAttribute("class", "on");
			prefB.appendChild(prevText);
		}else{ //기타 페이지
			prevA = prefB.appendChild(document.createElement("a"));
			prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
			prevA.appendChild(prevText);
		}
	},
	appendPrevNext: function (_page, _img){
		var objPageBar = document.getElementById("c_list_page_bar");
		var prefB;
		
		var prevA =objPageBar.appendChild(document.createElement("a"));
		prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
		
		prefB = prevA.appendChild(document.createElement("img"));
		prefB.setAttribute("src","/images/"+_img+".png");
		prefB.style.width = "15";
		prefB.style.height = "13";
		prefB.style.border = "0";
		prefB.style.padding = "0px 3px 0px 3px";
		prefB.setAttribute("align","absmiddle");
	}
	
}


//--------------------------------------------------------
//페이지 처리 (팝업)
//EX) scl_page.load(11, 20, 9999999);
//--------------------------------------------------------
var scl_pop_page = {

	//PAGE ON_LOAD
	load: function( _page, _pageGroup, _total) {
	
		document.getElementsByName("PAGE")(0).value = _page;
		document.getElementsByName("PAGE_GROUP")(0).value = _pageGroup;
		document.getElementsByName("TOTAL")(0).value = _total;

		var prevGroup = _pageGroup-19;
		var nextGroup = _pageGroup+1;
		var prevPage = _page-1;
		var nextPage = _page+1;
		var totalPage = ((_total-1)/10)+1;

		if (_page != 0 ){
			if (prevGroup > 0){
				//scl_pop_page.appendNode(" [prev_group]", prevGroup, false);
				scl_pop_page.appendPrevNext(prevGroup, "prev2");
			}
			if (prevPage > 0){
				//scl_pop_page.appendNode(" [prev_page]", prevPage, false);
				scl_pop_page.appendPrevNext(prevPage, "prev1");
			}
			for(var i = 9; i > -1; i--){
				var pageNo = ((_pageGroup)-i);
				if( pageNo > totalPage ){ break; }
				   
				scl_pop_page.appendNode(" " + pageNo, pageNo, ((_page == pageNo) ? true: false));
			}
			
			if (nextPage <= totalPage){
				//scl_pop_page.appendNode(" [next_page]", nextPage, false);
				scl_pop_page.appendPrevNext(nextPage, "next1");
			}
			if (nextGroup <= totalPage){
				//scl_pop_page.appendNode(" [next_group]", nextGroup, false);
				scl_pop_page.appendPrevNext(nextGroup, "next2");
			}
		} else {
			scl_pop_page.appendNode("1", 1, true);
		}
		
	},
	
	// APPEND NODE
	appendNode:function(_text, _page, _flag){
		var objPageBar = document.getElementById("popup_page_bar");
		var prefB;
		
		var prevText = document.createTextNode(_text);
		var prevA =objPageBar.appendChild(document.createElement("a"));
		
		if (_flag) { //현재페이지
			prefB = prevA.appendChild(document.createElement("span"));
			//prefB.setAttribute("className", "page_red");
			prefB.appendChild(prevText);
			//prefB.setAttribute("className", "page_red");
			prefB.style.color = 'red';
			prefB.style.fontSize = '11px';
			prefB.style.fontFamily = 'dotum, Verdana';
			prefB.style.letterSpacing = '2px';
			prefB.style.fontWeight = 'bold';
			prefB.style.textDecoration = 'none';
			prefB.style.cursor = 'pointer';
		}else{ //기타 페이지
			//prevA.setAttribute("href", "#");
			prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
			prevA.appendChild(prevText);
		}
	},
	appendPrevNext: function (_page, _img){
		var objPageBar = document.getElementById("popup_page_bar");
		var prefB;
		
		var prevA =objPageBar.appendChild(document.createElement("a"));
		prevA.setAttribute("href", "javascript:fn_goPage("+_page+")");
		
		//prefB = objPageBar.appendChild(document.createElement("img"));
		prefB = prevA.appendChild(document.createElement("img"));
		prefB.setAttribute("src","/img/common/page/"+_img+".gif");
		prefB.style.width = "15";
		prefB.style.height = "13";
		prefB.style.border = "0";
		prefB.style.padding = "0px 3px 0px 3px";
		prefB.setAttribute("align","absmiddle");
	}
	
}

//--------------------------------------------------------
// 일자, 개월 수 계산
// 사용예) 
//  - 개월수 => scl_date.getDifMonths(start, end)
//  - 일자 더하기 => scl_date.getDayAfter( yyyymmdd, gap )
//--------------------------------------------------------
var scl_date = {
	isLeapYear : function(year)
	{
		// parameter가 숫자가 아니면 false
		if (isNaN(year))
			return false;
		else		{
			var nYear = eval(year);
	
			// 4로 나누어지고 100으로 나누어지지 않으며 400으로는 나눠지면 true(윤년)
			if (nYear % 4 == 0 && nYear % 100 != 0 || nYear % 400 == 0)
				return true;
			else
				return false;
		}
	},
	
	// start, end format: yyyymmdd
	getDifMonths : function (start, end)
	{
		start = start.replace(/-/g,'');
		end = end.replace(/-/g,'');

		var startYear = start.substring(0, 4);
		var endYear = end.substring(0, 4);
		var startMonth = start.substring(4, 6) - 1;
		var endMonth = end.substring(4, 6) - 1;
		var startDay = start.substring(6, 8);
		var endDay = end.substring(6, 8);
	
		// 연도 차이가 나는 경우
		if (eval(startYear) < eval(endYear))	{
			// 종료일 월이 시작일 월보다 수치로 빠른 경우
			if (eval(startMonth) > eval(endMonth))	{
				var newEnd = startYear + "1231";
				var newStart = endYear + "0101";
	
				return (eval(getDifMonths(start, newEnd)) + eval(getDifMonths(newStart, end))).toFixed(2);
			// 종료일 월이 시작일 월보다 수치로 같거나 늦은 경우
			} else									{
				var formMonth = eval(startMonth) + 1;
				if (eval(formMonth) < 10)	formMonth = "0" + formMonth;
	
				var newStart = endYear + "" + formMonth + "" + startDay;
				var addMonths = (eval(endYear) - eval(startYear)) * 12;
	
				return (eval(addMonths) + eval(getDifMonths(newStart, end))).toFixed(2);
			}
		} else									{	
			// 월별 일수차 (30일 기준 차이 일수)
			var difDaysOnMonth = new Array(1, -2, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1);
			var difDaysTotal = scl_dateUtil.getDifDays(start, end);
	
			for (i = startMonth; i < endMonth; i++)	{
				if (i == 1 && scl_dateUtil.isLeapYear(startYear))	difDaysTotal -= (difDaysOnMonth[i] + 1);
				else									difDaysTotal -= difDaysOnMonth[i];
			}
	
			// because view this function
			//window.alert("- run getDifMonths()\n- " + start + " ~ " + end + " => " + (difDaysTotal / 30).toFixed(2));
			
			return (difDaysTotal / 30).toFixed(2);
		 }
	},
	
	// start, end format: yyyymmdd
	getDifDays : function (start, end)
	{
		var dateStart = new Date(start.substring(0, 4), start.substring(4, 6) - 1, start.substring(6, 8));
		var dateEnd = new Date(end.substring(0, 4), end.substring(4, 6) - 1, end.substring(6, 8));
		var difDays = (dateEnd.getTime() - dateStart.getTime()) / (24 * 60 * 60 * 1000);
	
		// because view this function
		//window.alert("- run getDifDays()\n- " + start + " ~ " + end + " => " + Math.ceil(difDays));
	
		return Math.ceil(difDays);
	},
	
	//-------------------------------------------
	// 일(날) 수 더하기
	//-------------------------------------------
	getDayAfter : function ( yyyymmdd, gap )
	{
		var tdyy = yyyymmdd.substr(0,4);
		var tdmm = parseInt(yyyymmdd.substr(4,2),10) - 1;
		var tddd = yyyymmdd.substr(6,2);
		var tgap = gap;

		ffday=new Date(tdyy,tdmm,tddd)
		gaps = parseInt(tddd,10) + parseInt(tgap,10)
		ffday.setDate(gaps)

		var yyto = ffday.getFullYear();
		var mmto = ffday.getMonth() + 1;
		var ddto = ffday.getDate();

		mmto += "";
		ddto += "";

		if( mmto.length == 1 )
			mmto = "0" + mmto;

		if( ddto.length == 1 )
			ddto = "0" + ddto;

		return yyto+""+mmto+""+ddto;
	},
	//-------------------------------------------
	// (월)의 마지막 날짜
	//-------------------------------------------
	getLastDate : function (Value)
	{
		var year, month

		if(Value.length == 8){
			year = Value.substring(0, 4);
			month = Value.substring(4, 6);

		    // ??¹??? ??(??)?? ?????? ???? ???????
	    	return lastDate = year + month + new Date(year, month, 0).getDate(); 
		}
	},
	//-------------------------------------------
	// 오늘 날짜(년월일) 
	//-------------------------------------------
	getDate : function ()
	{
		var args=getDate.arguments ;
		var res ;
		if (args.length == 1 ){
	    	var date = SVR_NOW_DATE.toDate('YYYYMMDD') ;
	    	res	= date.format(args[0]) ;
	    }else {
	    	res = SVR_NOW_DATE ;
	    }

	    return res ;
	}

}


//--------------------------------------------------------
// Element 제어
//--------------------------------------------------------
var scl_el = {
		
	// RESET one by one --------------------------------
	reset: function(_el){
		var arrEl = _el;
		var lenEl = arrEl.length;
		
		for (var i=0; i<lenEl; i++){
			//alert(arrEl[i].type);
			if (arrEl[i].type == "text"){
				arrEl[i].value = "";
			}else if (arrEl[i].type == "radio"){
				arrEl[i].checked = false;
			}else if (arrEl[i].type == "select"){
				arrEl[i].selected = false;
			}else if (arrEl[i].type == "file") {
			    var obj2= arrEl[i].cloneNode(false);
			    arrEl[i].parentNode.replaceChild(obj2, arrEl[i]);
			}
		}
	}, //reset
	
	//--------------------------------------------------------
	// 로딩이미지
	// 사용예) scl_el.lodingShow(window);
	//  필수사항) 
	// <div id="loadingBar" style="position:absolute; top:40%; left:45%; display:none;">
	// <img src="/images/loading.gif" /></div>
	// <div id="divBody" style=""></div>
	//--------------------------------------------------------
	lodingHide: function(_loc){
		//alert(_loc.document.getElementById('loadingBar'));
		_loc.document.getElementById('loadingBar').style.display="none";
		//$("#loadingBar").hide();
		_loc.document.getElementById('unloadingBar').style.display="block";
		//$("#unloadingBar").show();
	}, //lodingHide
	lodingShow: function(_loc){
		_loc.document.getElementById('loadingBar').style.display="block";
		//$("#loadingBar").show();
		_loc.document.getElementById('unloadingBar').style.display="none";
		//$("#unloadingBar").hide();
	}, //lodingShow
	//--------------------------------------------------------
	// 로딩이미지
	// 사용예) scl_el.lodingShow(window);
	//  필수사항) 
	// <div id="loadingBar" style="position:absolute; top:40%; left:45%; display:none;">
	// <img src="/images/loading.gif" /></div>
	// <div id="divBody" style=""></div>
	//--------------------------------------------------------
	popup_loadingHide: function(_loc){
		//alert(_loc.document.getElementById('loadingBar'));
		_loc.document.getElementById('loadingBar').style.display="none";
		//$("#loadingBar").hide();
		_loc.document.getElementById('unloadingBar').style.display="block";
		//$("#unloadingBar").show();
	}, //lodingHide
	popup_loadingShow: function(_loc){
		_loc.document.getElementById('loadingBar').style.display="block";
		//$("#loadingBar").show();
		_loc.document.getElementById('unloadingBar').style.display="none";
		//$("#unloadingBar").hide();
	}, //lodingShow
	//--------------------------------------------------------
	// 카피라이트 위치
	// 사용예) scl_el.lodingShow(true);
	//--------------------------------------------------------
    copyrightPos: function(_flag, _height){
		/*
		if( _flag ){
			document.getElementById("copyright").style.position = 'relative';
		}else{
			document.getElementById("copyright").style.position = 'absolute';
		}
		*/
	},
	
	setValue: function(_el, _val){
		if ( _val != null || _val != undefined){
			if (arrEl[i].type == "text"){
				arrEl[i].value = _val;
			}else if (arrEl[i].type == "radio"){
				if (arrEL[i].value == _val){
					arrEl[i].checked = true;
				}else{
					arrEl[i].checked = false;
				}
			}else if (arrEl[i].type == "select"){
				if (arrEL[i].value == _val){
					arrEl[i].selected = true;
				}else{
					arrEl[i].selected = false;
				}
			}
		}
	}, //setValue
	
	hideTop: function(){
		parent.document.getElementById('top').style.display="none";
	},
	
	showTop: function(){
		parent.document.getElementById('top').style.display="block";
	},
	submit: function (_form, _action, _target){
		var f = _form;
		f.action = _action;
	    f.method = "post";
	    f.target = sfn_isNull(_target) ? "_self" : _target; 
	    f.submit();
	},
	
	//submit
	
}

/**
 * 우편번호 검색 팝업
 * @param callback
 * @return zipData.zonecode   5자리 새우편번호
 *         zipData.fullAddr   최종 주소 변수
 *         zipData.extraAddr  조합형 주소 변수
 */
function openZonecodePopup(callback) {
    var zipData = {
    };

    new daum.Postcode({
        oncomplete: function(data) {
            // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 각 주소의 노출 규칙에 따라 주소를 조합한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var fullAddr = ''; // 최종 주소 변수
            var extraAddr = ''; // 조합형 주소 변수

            
            // 사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
            if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                fullAddr = data.roadAddress;

            } else { // 사용자가 지번 주소를 선택했을 경우(J)
                fullAddr = data.jibunAddress;
            }

            // 사용자가 선택한 주소가 도로명 타입일때 조합한다.
            if(data.userSelectedType === 'R'){
                //법정동명이 있을 경우 추가한다.
                if(data.bname !== ''){
                    extraAddr += data.bname;
                }
                // 건물명이 있을 경우 추가한다.
                if(data.buildingName !== ''){
                    extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                }
                // 조합형주소의 유무에 따라 양쪽에 괄호를 추가하여 최종 주소를 만든다.
                fullAddr += (extraAddr !== '' ? ' ('+ extraAddr +')' : '');
            }

            //// 우편번호와 주소 정보를 해당 필드에 넣는다.
            //document.getElementById('sample6_postcode').value = data.zonecode; //5자리 새우편번호 사용
            //document.getElementById('sample6_address').value = fullAddr;
            //
            //// 커서를 상세주소 필드로 이동한다.
            //document.getElementById('sample6_address2').focus();
            zipData.zonecode = data.zonecode;
            zipData.address = data.address + ', ';
            zipData.jibunAddress = data.jibunAddress;
            zipData.fullAddr = fullAddr;
            
            if(extraAddr !== ''){
            	extraAddr = ' ('+ extraAddr +')';
            }	
            zipData.extraAddr = extraAddr;
            eval(callback)(zipData);
        }
    }).open();
}

function SetCaretAtEnd(elem) {
    var elemLen = elem.value.length;
    // For IE Only
    if (document.selection) {
        // Set focus
        elem.focus();
        // Use IE Ranges
        var oSel = document.selection.createRange();
        // Reset position to 0 & then set at end
        oSel.moveStart('character', -elemLen);
        oSel.moveStart('character', elemLen);
        oSel.moveEnd('character', 0);
        oSel.select();
    }
    else if (elem.selectionStart || elem.selectionStart == '0') {
        // Firefox/Chrome
        elem.selectionStart = elemLen;
        elem.selectionEnd = elemLen;
        elem.focus();
    } // if
} // SetCaretAtEnd()

function getNameFromPath(strFilepath) {
    var objRE = new RegExp(/([^\/\\]+)$/);
    var strName = objRE.exec(strFilepath);

    if (strName == null) {
        return null;
    } else {
         return strName[0];
    }
}

//--------------------------------------
//라디오버튼 값 가져오기 
//--------------------------------------
function getRadioValue(theField){
    for(var i=0; i < theField.length; i++){
        if(theField[i].checked){
            return theField[i].value;
        }
    }
}    

