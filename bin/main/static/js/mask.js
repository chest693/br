$.extend($.inputmask.defaults, {
    placeholder: ""
});

$.fn.unmask = function () {
    if (this[0].tagName == "FORM") {
        $(":input", this).each(function(index, el) {
            remove(el);
        });
    } else {
        remove(this);
    }

    function remove(element) {
        var $element = $(element);
        if ($element.inputmask("hasMaskedValue")) {
            $element.inputmask("remove");
            if ($element.val().indexOf(",") > 0) {
                $element.val($element.val().replace(/,/gi, ""));
            }
        }
    }
};

var maskset = {
    aliases : [
        {alias: "date", options: {alias: "yyyy-mm-dd"}, numeric: true},
        {alias: "currency", options: {alias: "decimal", autoGroup: true, groupSeparator: ","}, numeric: true},
        {alias: "mobile", options: {mask: "999-999[9]-9999"}, numeric: true},
        {alias: "tel", options: {mask: "99[9]-999[9]-9999"}, numeric: true},
        {alias: "digit", options: {alias: "integer"}, numeric: true},
        {alias: "bizno", options: {mask: "999-99-99999"}, numeric: true},
        {alias: "rrn", options: {mask: "999999-9999999"}, numeric: true},
        {alias: "zipcode", options: {mask: "99999"}, numeric: true},
        {alias: "hm", options: {mask: "99:99"}, numeric: true}
    ]
};
$.fn.mask = function (name, pattern) {
    var selectedAlias = "";
    $.each(maskset.aliases, function(index, val) {
        if (name == val.alias) {
            selectedAlias = val;
            return false;
        }
    });

    if (selectedAlias == "" || selectedAlias == undefined) {
        alert("'" + name + "'에 해당하는 Mask 정보가 없습니다.");
        return;
    }

    if (pattern != undefined) {
        $.extend(selectedAlias.options, pattern);
    }

    this.each(function(index, el) {
        var $element = $(el);
        if (el.tagName == "INPUT") {
            if (selectedAlias.numeric) {
                $element.keydown(function (event) {
                    var korean = /[ㄱ-ㅎ|ㅏ-ㅣ|가-힣]/;
                    if (korean.test($element.val())) {
                        return false;
                    }
                    return true;
                    //$(this).val($(this).val().replace(/[^0-9]/gi,""));
                });
            }
            $element.inputmask(selectedAlias.options);
        } else {
            if ($element.text() != "") {
                $element.text($.inputmask.format($element.text().trim(), selectedAlias.options));
            }
        }
    });
};
/*
$.fn.mask = function (alias, pattern) {
    this.each(function(index, el) {
        var $element = $(el);
        if (alias == "currency" && pattern == undefined) {
            $(el).text($.inputmask.format($(el).text(), { alias: "decimal", autoGroup: true, groupSeparator: ","}));
        } else if (alias == "date" && pattern == undefined){
            $(el).text($.inputmask.format($(el).text(), { alias: "yyyy-mm-dd"}));
        }
    });
};
*/