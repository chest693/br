$(document).ready(function() {
    /*************************************************************
     * 레이어팝업 닫기
     *************************************************************/
    $("img.close_pop").click(function(){
        var hidePopup =  parent.document.getElementById('layer2');
        
        parent.document.getElementById('receiptDoc').src = "";
        hidePopup.style.display = "none";
    })

    $("table > thead > tr > th").on("click", ".check_all", function (e) {
        var $parents = $(this).parents("table"); // 선택된 checkbox의 table
        var chkIndex = ($(this).parents("th").index()+1); // 선택된 checkbox의 index
        var checked  = $(this).prop("checked"); // check여부
        $parents.find("tbody > tr >td:nth-child("+chkIndex+")").find(":checkbox").prop("checked",checked); // tbody의 선택된 index에 해당하는 checkobx 를 check여부에 따라 셋팅
    });

    $("body").on("keydown", function (e) {
        var key = (e) ? e.keyCode : e.keyCode;

        // 백스페이스
        if (key == 8) { // backspace
            var tags = /INPUT|SELECT|TEXTAREA/i;
            var inputType = /text|password/i;
            if (!tags.test(e.target.tagName) || !inputType.test(e.target.type) || e.target.disabled || e.target.readOnly) {
                e.preventDefault();
            }
        }

        // 새로고침
        if(key == 116) { // F5
            e.preventDefault();
        }
    });
// 동적으로 row가 추가된 경우에도 숫자만 입력 가능하도록 하기 위하여 이벤트를 on으로 변경.
//    /* 숫자만 입력 가능 */
//    $(function(){
//       $('.numberic').keypress(function(event){
//           if (event.which && (event.which > 47 && event.which < 58 || event.which == 8)) {
//           } else {
//              event.preventDefault();
//           }
//       });
//       //크롬등에서 ime-mode:disabled 정상작동 되지않으므로 정규식으로 처리
//       $('.numberic').keyup(function(event){
//           $(this).val($(this).val().replace(/[^0-9]/g,''));
//       });
//    });
//    $.setDatepicker();


}).on("keypress", ".numberic", function(event) {
    if (event.which && (event.which > 47 && event.which < 58 || event.which == 8)) {
    } else {
       event.preventDefault();
    }
}).on("keyup", ".numberic", function(event) {
    $(this).val($(this).val().replace(/[^0-9]/g,''));
}).on("keypress", ".minority", function(event) {
    if (event.which && ( event.which > 47 && event.which < 58 || event.which == 8 || event.which == 46)) {
    } else {
       event.preventDefault();
    }
}).on("keyup", ".minority", function(event) {
    $(this).val($(this).val().replace( /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/g, '' ));
});

//openWindow
$.openWindow = function (options) {
    if (options.width == undefined || options.width == "") {
        options.width = 1024;
    }
    if (options.height == undefined || options.height == "") {
        options.height = 768;
    }
    if (options.layout == undefined || options.layout == "") {
        options.layout = "resizable=no, toolbar=no, menubar=no, location=no, status=no, scrollbars=yes";
    }
    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : screen.left;
    var dualScreenTop = window.screenTop != undefined ? window.screenTop : screen.top;
    var screenWidth = window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var screenHeight = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;
    var left = (screenWidth / 2) - (options.width / 2) + dualScreenLeft;
    var top = (screenHeight / 2) - (options.height / 2) + dualScreenTop;
    var url = options.url;
    var index =  url.lastIndexOf("views/");
    var popupWindowName = "";

    if (index > 0) {
        popupWindowName = url.substr(index+6).replace(".do","");
    } else {
        popupWindowName = "COMMON_WINDOW";
    }

    //var popupWindowName = "__COMMON_WINDOW__" + Math.floor((Math.random() * 10000000000000000) + 1);

    var param = "";

    if (options.params) {
      param += "?" + $.param(options.params);
    }

    var w = window.open(url + param, popupWindowName, "top=" + top + ", left=" + left + ", width=" + options.width + ", height=" + options.height + ", " + options.layout);
//    w.focus();
    return w;
};


/**
 * @desc      : 모든 option을 초기화시킨다.
 * @author    : jsKim
 */
$.fn.removeOption = function() {
    $(this).find("option").remove();
    return $(this);
};

//addOptions
/**
 * @desc      : select tag의 option을 추가해준다.
 * @comment   :
 * @param     : options  - selectedVal : 초기 select의 선택값
 *                       - callback    : select를 생성후 처리할 callback funtion명
 *                       - value       : select의 option의 value
 *                       - text        : select의 option의 text  <option value="1">text</option>
 *                       - nulltext    : --선택--,--전체--등 null값의 text
 *                       - dataList    : 조회된 data
 * @create    : 2014.10.16
 * @author    : jsKim
 */
$.fn.addOptions = function(options) {
    $(this).find("option").remove();

    if (!options) {
        alert("parameter가 없습니다.");
        return false;
    }

    if (options.nulltext) {
      $(this).append($("<option>", {value: "", text: options.nulltext}));
    }

    for (var index = 0; index < options.dataList.length; index++) {
    	if(options.dataList[index][options.value] != ""){
    		$(this).append($("<option>", {value: options.dataList[index][options.value], text : options.dataList[index][options.text]}));
    	}	
    }

    if (options.callback) {
        eval(options.callback)();
    }
};

//close
$.closeWindow = function () {
    if (browser.name == "mozilla") {
        window.open("about:blank", "_self").close();
    } else {
        self.close();
    }
};

//browser detect
var browser = (function() {
    var s = navigator.userAgent.toLowerCase();
    var match = /(chrome)[ \/]([\w.]+)/.exec(s) ||
                /(webkit)[ \/](\w.]+)/.exec(s) ||
                /(opera)(?:.*version)?[ \/](\w.]+)/.exec(s) ||
                /(msie) ([\w.]+)/.exec(s) ||
               !/compatible/.test(s) && /(mozilla)(?:.*? rv:([\w.]+))?/.exec(s) ||
               [];
    return {name: match[1] || "", version: match[2] || "0"};
}());

//addRow
$.fn.addRow = function (templateId, params) {
    $(".empty", this).parent().remove();

    var formatter = $.validator.format($.trim($(templateId).val()));
    var numbering = $("td", formatter([])).hasClass("numbering");

    var _params;
    if (numbering) {
        var rowCount = $(".numbering", this).length;
        _params = [++rowCount, rowCount - 1];
    } else {
        _params = [$("tbody > tr", this).length];
    }
    var row = $(formatter((params == undefined) ? _params : _params.concat(params)));
    $(row).appendTo(this);

    return row;
};

//addTemplate
$.fn.addTemplate = function (templateId, params) {

    var formatter = $.validator.format($.trim($(templateId).val()));

    var template = $(formatter(params));
    $(template).appendTo(this);

    return template;
};

//addFormatter
$.fn.addFormatter = function (template, params) {

    var formatter = $.validator.format(template);

    var template = $(formatter(params));
    $(template).appendTo(this);

    return template;
};

//addEmptyRow
$.fn.addEmptyRow = function(pColspan) {

    var colspan = pColspan || $(this).find("th").size();
    var rowCnt = $(this).find("tbody > tr").size();
    var $div = $(this).parent();
    var style = "";
    if (rowCnt == 0) {
        if ($div.hasClass("scroll-body")) {
            style = " style='height: 179px;'";
        }
        $("<tr"+style+"><td class='ta_c empty ea' colspan='"+colspan+"'>조회된 내용이 없습니다.</td></tr>").appendTo(this).find("tbody");
    }
};



$.fn.serializeObject = function() {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

$.fn.serializeParam = function() {
    return $.convertJsonParam($(this).serializeObject());
};
$.convertJsonParam = function(params) {
    var param = "";
    var i = 0;
    $.each(params,function(key,value){
        if (i > 0) param += "&";

        param += key + "=" + value;
        i++;
    });
    return param;
};

/**
 * 하위항목의 값을 초기화 시킨다.
 * @param exceptionClass : 예외 Class
 */
$.fn.clearForm = function(exceptionClass) {
    $(this).find('input, select, textarea').not("."+exceptionClass).val('');
    $(this).find('input:radio').not("."+exceptionClass).attr('checked', false);
    $(this).find('input:checkbox').not("."+exceptionClass).removeAttr('checked');
};

/**
 * 하위의 모든 input,textarea,button,select를 diabled/enabled시킨다.
 * @param isDisabled (Default : true)
 */
$.fn.disabled = function(isDisabled) {
    if (isDisabled == null) {
        isDisabled = true;
    }
    $(this).find('input, textarea, button, select').attr('disabled',isDisabled);
    if (isDisabled) {
        $(this).find('.hasDatepicker').datepicker('disable');
    } else {
        $(this).find('.hasDatepicker').datepicker('enable');
    }

};

//현재날짜 조회
function getCurrentDate(){
    var date = new Date();
    $.ajax({
        url : '/comm/popup/findCurrentDate.do',
        method : "post",
        dataType : 'json',
        async    : false, // default : true(비동기)
        success : function(data) {
            date = new Date(data.CurrentDate);
        }
    });
    return date;
};

/**
 * row num sort
 */

/*
날짜계산
예) dateAddDel('20190315',2,'d') = 20190317
    dateAddDel('20190315',2,'m') = 20190515
    dateAddDel('20190315',2,'y') = 20210315 
*/
function dateAddDel(sDate, nNum, type) {
	var yy = parseInt(sDate.substr(0, 4), 10);
	var mm = parseInt(sDate.substr(4, 2), 10);
	var dd = parseInt(sDate.substr(6, 2), 10);
	
	if (type == "d") {
		d = new Date(yy, mm-1, dd + nNum);
	} else if (type == "m") {
		d = new Date(yy, mm-1 + nNum, dd);
	} else if (type == "y") {
		d = new Date(yy + nNum, mm - 1, dd);
	}
	var yyyy = d.getFullYear();
	mm = d.getMonth() + 1; mm = (mm < 10) ? '0' + mm : mm;
	dd = d.getDate(); dd = (dd < 10) ? '0' + dd : dd;
	
	return '' + yyyy + '' +  mm  + '' + dd;
}


$.fn.sortRowNum = function() {
  var pattern = /\[\d\]/gi;
  var elementName;
  var index = 0;
  //해당 요소에서 select, input의 name을 변경함.
  $(this).find('select, input').each(function(){
    index = $(this).parents('tr').index();
    elementName = $(this).attr('name');
    if(elementName){
        $(this).attr('name',elementName.replace(pattern,'['+index+']'));
    }
  });
}

/**
 * row num sort
 */
$.fn.sortRowSpanNum = function() {
  var pattern = /\[\d\]/gi;
  var elementName;
  var index = 0;
  var row = 0;
  //해당 요소에서 select, input의 name을 변경함.
  $(this).find('tbody tr').each(function(){
    index = $(this).index();
    $(this).find('select, input').each(function(){

      elementName = $(this).attr('name');
      if(elementName){
          $(this).attr('name',elementName.replace(pattern,'['+row+']'));
      }
    });

    //rowspan=2 가 되어있으므로 홀수 일때 row를 증가 시켜준다.
    if(index%2!=0){
        row = row+1;
    }
  });
}

/**
 * 1000단위 콤마
 */
function setComma(value){
  value = parseInt(removeComma(value))||0;
  var reg = /\B(?=(\d{3})+(?!\d))/g;
  return value.toString().replace(reg,',');
};

/**
 * 콤마 제거
 */
function removeComma(value){
  var reg = /[\,]/g;
  return value.toString().replace(reg,'');
};

/**
 * 숫자이외 특수문자 제거
 */
function removeNotNum(value){
  var reg = /\D/g;
  return value.toString().replace(reg,'');
};

/**
 * 숫자이외 특수문자 제거
 */
$.fn.removeNotNum = function(){
  $(this).val(removeNotNum($(this).val()));
};

/**
 * element 콤마셋팅
 */
$.fn.setComma = function(){
  $(this).val(setComma(parseInt($(this).val())));
};

/**
 * element 콤마제거
 */
$.fn.setRemoveComma = function(){
    $(this).val(removeComma($(this).val()));
};

/**
 * element 콤마제거
 */
$.fn.removeComma = function(){
  return removeComma($(this).val());
};

/**
 * 숫자 INPUT에 포커스가 갈 경우 콤마 제거.
 */
$(document).on('focusin', '.num', function(){
  $(this).setRemoveComma();
});

/**
 * 숫자 input에 포커스가 아웃 될경우 콤마를 추가한다.
 */
$(document).on('focusout', '.num', function(){
  $(this).setComma();
});

/**
 * 숫자 INPUT에서 숫자이외 값 입력 막기.
 */
$(document).on('keyup', '.num', function(){
    var value= $(this).val();
    var reg = /\D/gi;
    if(value.match(reg))
        $(this).val(value.replace(reg,''));
  });

$( document ).ajaxError(function( event, jqxhr, settings, thrownError ) {
    alert("처리도중 문제가 발생하였습니다.");
});


/**
 * 이메일 유효성 체크
 * @param email
 * @returns
 */
function checkEmail(email) {
    var regEmail = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;
    return regEmail.test(email);
}

/**
 * 핸드폰번호 유효성 체크
 * @param phone
 */
function checkMobilePhone(phone) {
    var regPhone = /(01[016789])[-](\d{4}|\d{3})[-]\d{4}$/g;
    return regPhone.test(phone);
}

/**
 * 전화번호 하이픈 자동넣기
 */
$(document).on('keyup', '.mobilePhone', function(){
    var value= $(this).val();
    $(this).attr("maxlength",13);
    $(this).val(setHypenPhone(value));
  });

/**
 * 핸드폰에 하이픈 자동으로 입력 처리
 * @param str
 * @returns
 */
function setHypenPhone(str){
    str = str.replace(/[^0-9]/g, '');
    var tmp = '';
    if( str.length < 4){
        return str;
    }else if(str.length < 7){
        tmp += str.substr(0, 3);
        tmp += '-';
        tmp += str.substr(3);
        return tmp;
    }else if(str.length < 11){
        tmp += str.substr(0, 3);
        tmp += '-';
        tmp += str.substr(3, 3);
        tmp += '-';
        tmp += str.substr(6);
        return tmp;
    }else{
        tmp += str.substr(0, 3);
        tmp += '-';
        tmp += str.substr(3, 4);
        tmp += '-';
        tmp += str.substr(7);
        return tmp;
    }
    return str;
}

/**
 * 필수 엘리먼트 체크
 * obj : 체크대상obj
 * type : true css적용, false css미적용
 */
function vaildateReqObj(type, obj) {

    var result = true;
    if ( type ) {
        obj.each(function (){
            var val;
            if ( $(this)[0].tagName == "TD" ) {
                val = $(this).text();
            } else {
                val = $(this).val();
            }
            if ( val == "" ) {
                $(this).addClass("validation-req");
                result = false;
            }else {
                $(this).removeClass("validation-req");
            }
        })
    } else {
        obj.each(function (){
            if ( $(this).val() == "" ) {
                result = false;
            }
        })
    }
    return result;
}

/**
 * 폼필수 엘리먼트 체크 class reqInput class사용
 * obj : 체크대상 form
 * type : true css적용, false css미적용
 */
function vaildateReqForm(type, form) {
    return vaildateReqObj(type, $(form).find(".reqInput") );
}

$(document).ajaxStart(function () {
    //show ajax indicator
    ajaxindicatorstart('');
}).ajaxStop(function () {
    //hide ajax indicator
    ajaxindicatorstop();
});

function ajaxindicatorstart(text) {
    if ($('body').find('#resultLoading').attr('id') != 'resultLoading') {
        // ajax-loader 이미지 생성 http://www.ajaxload.info/
        $('body').append('<div id="resultLoading" style="display:none"><div><img src="/img/ajax-loader.gif"><div>'+text+'</div></div><div class="bg"></div></div>');
    }

    $('#resultLoading').css({
        'width':'100%',
        'height':'100%',
        'position':'fixed',
        'z-index':'10000000',
        'top':'0',
        'left':'0',
        'right':'0',
        'bottom':'0',
        'margin':'auto'
    });

    $('#resultLoading .bg').css({
        'background':'#000000',
        'opacity':'0',
        'width':'100%',
        'height':'100%',
        'position':'absolute',
        'top':'0'
    });

    $('#resultLoading>div:first').css({
        'width': '250px',
        'height':'75px',
        'text-align': 'center',
        'position': 'fixed',
        'top':'0',
        'left':'0',
        'right':'0',
        'bottom':'0',
        'margin':'auto',
        'font-size':'16px',
        'z-index':'10',
        'color':'#ffffff'

    });

    $('#resultLoading .bg').height('100%');
    $('#resultLoading').fadeIn(300);
    $('body').css('cursor', 'wait');
}

function ajaxindicatorstop() {
    $('#resultLoading .bg').height('100%');
    $('#resultLoading').fadeOut(300);
    $('body').css('cursor', 'default');
}

/**
 * textarea enter길이 2로 체크
 * @param obj
 */
function maxLengthTextarea(obj){
    var str = $(obj).val();
    var str2 = "";
    var maxLen = $(obj).attr("maxlength");
    var strLen = str.length;
    var rlen = 0;

    for(var i=0; i<strLen; i++){
        if ( maxLen >= rlen ){
            str2 = str.substring(0,i);
        }
        one_char = str.charAt(i);
        if(one_char.charCodeAt(str) == '10'){
            rlen += 2;
        }else{
            rlen++;
        }
    }
    if(maxLen < rlen ){
        $(obj).val(str2);
    }
}


/**
 * 페이징처리
 */
$.fn.setPagintion = function (paginationInfo, jsFunction) {
    $(this).children().remove();

    var firstPageLabel    = " <a href=\"?pageIndex={1}\" class=\"page-others\" onclick=\"{0}({1});return false; \">처음</a> ";
    var previousPageLabel = " <a href=\"?pageIndex={1}\" class=\"page-others\"  onclick=\"{0}({1});return false; \">이전</a> ";
    var currentPageLabel  = " <span class=\"page-select\">{0}</span> ";
    var otherPageLabel    = " <a href=\"?pageIndex={1}\" class=\"page-others\" onclick=\"{0}({1});return false; \">{2}</a> ";
    var nextPageLabel     = " <a href=\"?pageIndex={1}\" class=\"page-others\"  onclick=\"{0}({1});return false; \">다음</a> ";
    var lastPageLabel     = " <a href=\"?pageIndex={1}\" class=\"page-others\" onclick=\"{0}({1});return false; \">끝</a> ";

    var strBuff = "";

    var firstPageNo = paginationInfo.firstPageNo;
    var firstPageNoOnPageList = paginationInfo.firstPageNoOnPageList;
    var totalPageCount = paginationInfo.totalPageCount;
    var pageSize = paginationInfo.pageSize;
    var lastPageNoOnPageList = paginationInfo.lastPageNoOnPageList;
    var currentPageNo = paginationInfo.currentPageNo;
    var lastPageNo = paginationInfo.lastPageNo;

    if (totalPageCount > pageSize) {
        if (firstPageNoOnPageList > pageSize) {
            $(this).addFormatter(firstPageLabel,[jsFunction,firstPageNo] )
            $(this).addFormatter(previousPageLabel,[jsFunction,firstPageNoOnPageList - 1] )
        } else {
            $(this).addFormatter(firstPageLabel,[jsFunction,firstPageNo] )
            $(this).addFormatter(previousPageLabel,[jsFunction,firstPageNo] )
        }
    }

    for (var i = firstPageNoOnPageList; i <= lastPageNoOnPageList; i++) {
        if (i == currentPageNo) {
            $(this).addFormatter(currentPageLabel,[i] )
        } else {
            $(this).addFormatter(otherPageLabel,[jsFunction, i, i] )
        }
    }

    if (totalPageCount > pageSize) {
        if (lastPageNoOnPageList < totalPageCount) {
            $(this).addFormatter(nextPageLabel,[jsFunction, firstPageNoOnPageList + pageSize] )
            $(this).addFormatter(lastPageLabel,[jsFunction, lastPageNo] )
        } else {
            $(this).addFormatter(nextPageLabel,[jsFunction, lastPageNo] )
            $(this).addFormatter(lastPageLabel,[jsFunction, lastPageNo] )
        }
    }
};



/**
 * 은행코드/계좌번호 유효성을 체크한다.
 * @param bankCode 은행코드
 * @param accountNumber 계좌번호
 * @param money 금액(가상계좌)
 */
$.checkeDepositor = function (param) {
    var returnValue = "";
    $.ajax({
        url : '/comm/popup/getDepositor.do',
        method : "post",
        dataType : 'json',
        async    : false, // default : true(비동기)
        data : param,
        success : function(data) {
            returnValue = data.resultMsg;
            if (data.resultCode == "E") {
                alert(data.resultMsg);
                returnValue = "";
            }
        }
    });
    return returnValue;
};


Date.prototype.addDays = function(days) {
    var dat = new Date(this.valueOf());
    dat.setDate(dat.getDate() + days);
    return dat;
}

/**
 * 주민등록번호
 * @param value
 * @returns {Boolean}
 */
function checkRrn(value){
    value = value.replace(/-/g,"");
    if (value.length != 13) {
        return false;
    }
    var tempGbCd = value.substr(7, 1);
    if (tempGbCd == "A" || tempGbCd == "B") {
        return true;
    }
    var sum = 0;

    if (value.match(/\d{2}[0-1]\d{1}[0-3]\d{1}\d{7}/)) {
        if (value.substr(6, 1) >= 5 && value.substr(6, 1) <= 8) { //외국인
            if (Number(value.substr(7, 2)) % 2 != 0) return false;
            for (var i = 0; i < 12; i++) {
                sum += Number(value.substr(i, 1)) * ((i % 8) + 2);
            }
            if ((((11 - (sum % 11)) % 10 + 2) % 10) == Number(value.substr(12, 1))) {
                return true;
            }
            return false;

        } else { //내국인
            for (var i = 0; i < 12; i++) {
                sum += Number(value.substr(i, 1)) * ((i % 8) + 2);
            }
            if (((11 - (sum % 11)) % 10) == Number(value.substr(12, 1))) {
                return true;
            }
            return false;
        }
    } else {
        return false;
    }
}


function lengthValid() {
  var isCheck = true;

  /**
   * 최대 입력 자리수 체크
   */
  $(document).find('.length_check').each(function(){
      var maxLength = $(this).attr('data-length');
      var value = $(this).val();
      if(value.length > maxLength) {
        $(this).val(value.substring(0,maxLength));
        alert("입력할 수 있는 글자는 "+maxLength+"입니다.");
        isCheck = false;
        $(this).focus();
        return false;
      }
  });


  return isCheck;
}

/**
 * 최대 입력 자리수 체크
 */
$(document).on('focusout', '.length_check', function(){
    var maxLength = $(this).attr('data-length');
    var value = $(this).val();
    if(value.length > maxLength) {
      $(this).val(value.substring(0,maxLength));
      alert("입력할 수 있는 글자는 "+maxLength+"입니다.");
      $(this).focus();
      return false;
    }
});


//-------------------------------------------
//날짜유효성체크
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
//날짜필드 focus on
//-------------------------------------------
function focusOnDate(_filed){
_filed.value = _filed.value.replace(/-/g,'');
_filed.select();
}

//-------------------------------------------
//날짜필드 focus out
//-------------------------------------------
function focusOutDate(_filed){
var str = _filed.value;
if(str!=""){
  if(str.length==8 ){
    _filed.value = str.substring(0,4)+"-"+str.substring(4,6)+"-"+str.substring(6,8);
  } else {
    alert("날짜포맷이 틀리거나 없는 날짜입니다.");
    _filed.select();
  }
}
}


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

//콤마찍기
function comma(str) {
  str = String(str);
  return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
}

//콤마풀기
function uncomma(str) {
  str = String(str);
  return str.replace(/[^\d]+/g, '');
}

//값 입력시 콤마찍기
function inputNumberFormat(obj) {
  obj.value = comma(uncomma(obj.value));
}

/*date -> yyyy-mm-dd로 반환*/
function getFormatDate(date){
	var d = new Date(date), 
	month = '' + (d.getMonth() + 1), 
	day = '' + d.getDate(), 
	year = d.getFullYear(); 
	
	if (month.length < 2) month = '0' + month; 
	if (day.length < 2) day = '0' + day; 
	return [year, month, day].join('-');
}

/*yyyymmdd -> date형식으로 반환*/
function to_date(date_str)
{
    var yyyyMMdd = String(date_str);
    var sYear = yyyyMMdd.substring(0,4);
    var sMonth = yyyyMMdd.substring(4,6);
    var sDate = yyyyMMdd.substring(6,8);

    return new Date(Number(sYear), Number(sMonth)-1, Number(sDate));
}


/*yyyymmdd -> yyyy-mm-dd 반환*/
function convertDateFormat(dat){
	var year = dat.substring(0, 4);
	var month = dat.substring(4, 6);
	var day = dat.substring(6, 8);
	
	return year + '-' + month + '-' + day;
	
}

//특정 달을 입력해 주면,
//그 달에 해당되는 분기를 반환하는 함수
function quarterYear(month) {
return Math.ceil( month / 3 );
}


//현재 월 반환 함수
function currentMonth() {
var d = new Date();

return d.getMonth() + 1; // 현재 월만 반환
}


/*첨부파일 용량체크*/
function fileCheck( file ){
    // 사이즈체크
    var maxSize  = 10 * 1024 * 1024    //10MB
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

/**
 * chestOn 전자결제 팝업을 호출한다.
 * @param docHeaderKey docHeader
 */
function openChestOnDocument(documentId) {
    var options = {
            url : "http://on.chest.or.kr/DeskPlusEIP/Approval/Common/Popup/View.aspx",
            params : {
              cID: "1",
                dID: documentId
            }
            ,width:"1400"
    };
    $.openWindow(options);
}

//레이어 팝업 호출처리
function layer_popup(el, url, x){
    var $el = $(el);        //레이어의 id를 $el 변수에 저장

    $el.width(x);
	
	receiptDoc.location.href=url;     //iframe 에 열 파일 링크

    $el.fadeIn();
    
    var $elWidth = ~~($("#receiptDoc").outerWidth()),
    $elHeight = ~~($("#receiptDoc").outerHeight()),
    docWidth = $(document).width(),
    docHeight = $(document).height();

    // 화면의 중앙에 레이어를 띄운다.
    if ($elHeight < docHeight || $elWidth < docWidth) {
		$("#receiptDoc").css("margin-top",-$elHeight /2+550);
		$("#receiptDoc").css("margin-left",-$elWidth/2+550);
    } else {
		$("#receiptDoc").css("top",0);
		$("#receiptDoc").css("left",0);
    }
}

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
	document.getElementById(display_obj).innerHTML = nbytes;
	return msg;
}

function getToday(){
    var dt = new Date();
    var recentYear = dt.getFullYear();
    var recentMonth = dt.getMonth() + 1;
    var recentDay = dt.getDate();

    if(recentMonth < 10) recentMonth = "0" + recentMonth;
    if(recentDay < 10) recentDay = "0" + recentDay;

    return recentYear + "" + recentMonth + "" + recentDay;

}

function chk_extension( obj, gubun ) {
	var str = obj.value;
	idx = str.lastIndexOf('.');
	if( idx != -1 ) {
		ext = str.substring( idx+1, str.len );
	} else {
		ext = "";
	}
	// 확장자 비교
	compStr = new Array("gif","jpg","jpeg","png","bmp","pdf");
	isSubmit = false;
	if( ext != "" ) {
		for( i = 0; i < compStr.length; i++ ) {
			if( ext.toLowerCase() == compStr[i] ) {
				isSubmit = true;
				break;
			}
		}
	}
	if( str!="" && !isSubmit ) {
		if(gubun=="1"){
			$("#fileNm1").val("");
		}else{
			$("#fileNm2").val("");
		}
		alert("이미지파일만 업로드 가능합니다.");
	}else{
		fileCheck( obj );
	}
}

/*첨부파일 용량체크*/
function fileCheck( file , maxFileSize){
    // 사이즈체크
    var maxSize  = maxFileSize * 1024 * 1024
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
        alert("파일용량 : "+ number_to_human_size(fileSize) +"\n\n첨부파일 용량은 "+maxFileSize+"MB 이내로 등록 가능합니다.");
        file.value="";
        return;
    }
}

