<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div class="restriction_report" id="layer2" style="display:none;">
	<div class="pop_bg"></div>
	<div class="pop_up">
		<div class="pop_cont width1100P">
		    <iframe id="receiptDoc" name="receiptDoc" src="" style="width: 100%; height:860px; padding: 0px; margin 0px; border: 0px solid;" frameborder="0" scrolling="no"></iframe>
	    </div>
    </div>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/es6-promise/4.1.1/es6-promise.auto.js"></script>

<script language="javascript" type="text/javascript">

    function downloadPDF() {
        createChartImages();
        downloadImageWeb();
    }

    function createChartImages() {
        $('svg').each(function () {
            var chartId = $(this).parents().parents().attr('id');
            var chart = $('#' + chartId).highcharts();
            var render_width = $(this).width;
            var render_height = render_width * chart.chartHeight / chart.chartWidth;

            // exporting.js
            var svg = chart.getSVG({
                exporting: {
                    sourceWidth: chart.chartWidth,
                    sourceHeight: chart.chartHeight
                }
            });

            var tempCanvas = document.createElement('canvas');
            tempCanvas.height = render_height;
            tempCanvas.width = render_width;
            canvg(tempCanvas, svg);

            var imgData = tempCanvas.toDataURL('image/png');
            var imgTag = '<img src="' + imgData + '">';

            $('#' + chartId).find('div:first').append(imgTag);
            $(this).hide();
        });
    }

    function downloadImageWeb() {
        html2canvas(document.querySelector('#canvas')).then(function(canvas) {
            var imgSrc =  canvas.toDataURL();
            var docName = $('#reqstDoc').contents().find('#docName').html();
            var fileName = docName+'.png';
            var imgData = atob(imgSrc.split(",")[1]),
                len = imgData.length,
                buf = new ArrayBuffer(len),
                view = new Uint8Array(buf),
                blob,
                i;

            for (i = 0; i < len; i++) {
                view[i] = imgData.charCodeAt(i) & 0xff // masking
            }

            blob = new Blob([view], {
                type: "application/octet-stream"
            });

            // ie
            if (window.navigator.msSaveOrOpenBlob) {
                window.navigator.msSaveOrOpenBlob(blob, fileName)
            } else {
                var a = document.createElement("a");
                a.href = imgSrc;
                a.download = fileName;
                document.body.appendChild(a)
                a.click();
                setTimeout(function() {
                    document.body.removeChild(a)
                }, 100)
            }
        });
    }
    
    
</script>  
