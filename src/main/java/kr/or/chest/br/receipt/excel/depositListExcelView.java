package kr.or.chest.br.receipt.excel;

import java.util.Calendar;
import java.text.SimpleDateFormat;

import kr.or.chest.br.common.CamelCaseMap;
import kr.or.chest.br.common.Util;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.view.document.AbstractXlsxView;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.ss.usermodel.*;
import java.io.UnsupportedEncodingException;
import kr.or.chest.br.receipt.dto.ReceiptDto;

public class depositListExcelView extends AbstractXlsxView {

    static SimpleDateFormat noneDF 	= new SimpleDateFormat("yyyyMMdd");
	private Logger log = LoggerFactory.getLogger(this.getClass());
    public Font titleFont = null;
    public Font columnFont = null;

    @Override
	protected void buildExcelDocument(Map modelMap, Workbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
    	
    	ReceiptDto receiptDto = (ReceiptDto)modelMap.get("receiptDto");

    	String fd = receiptDto.getRceptDeFd();
    	String td = receiptDto.getRceptDeFd();
    	
        String sCurTime = noneDF.format(Calendar.getInstance().getTime());
		String excelName =  "입금내역_"+sCurTime+".xlsx";
		Sheet worksheet = null;
		Row row = null;
		Cell cell = null;
		CellStyle style = workbook.createCellStyle(); // 셀 스타일을 위한 변수
		style.setAlignment(CellStyle.ALIGN_CENTER); // 글 위치를 중앙으로 설정
		
        ArrayList<CamelCaseMap> list = (ArrayList<CamelCaseMap>)modelMap.get("list");
        
	    // 새로운 sheet를 생성한다.
	    worksheet = workbook.createSheet("입금내역("+fd+"-"+td+")");
	    // 첫번째 행 생성
	    row = worksheet.createRow(0);
	    // 헤더 설정
        cell = row.createCell(0);
	    		
        String[] title = {"순번", "입금일자", "입금시간", "입금구분", "은행코드", "입금은행", "지점", "입금자명", "입금액"};
        int[] cellWidth = {2000, 3000, 3000, 3000, 3000, 4000, 3000, 6000, 5000};
        
        cell.setCellStyle(getTitleStyle(workbook, 10, style.ALIGN_CENTER, false, false, false));
        cell.setCellValue("순번");

        for (int i = 0; i < title.length; i++) {
        	worksheet.setColumnWidth(i, cellWidth[i]);

            cell = row.createCell(i);
            cell.setCellStyle(getTitleStyle(workbook, 10, style.ALIGN_CENTER, true, true, true));
            cell.setCellValue(title[i]);
        }
        
        
	    int rowIndex = 1;
	    
    	CellStyle CellStyle_center = getColumnStyle(workbook, 10, CellStyle.ALIGN_CENTER, false, false, true);
    	CellStyle CellStyle_left = getColumnStyle(workbook, 10, CellStyle.ALIGN_LEFT, false, false, true);
    	CellStyle CellStyle_right = getColumnStyle(workbook, 10, CellStyle.ALIGN_RIGHT, false, false, true);

    	for (CamelCaseMap model : list) {
	    	row = worksheet.createRow(rowIndex);
            cell = row.createCell(0); //순번
            cell.setCellStyle(CellStyle_center);
            cell.setCellValue(Util.convertNull(model.getString("rnum")).toString());
            
            cell = row.createCell(1); //입금일자
            cell.setCellStyle(CellStyle_center);
            cell.setCellValue(Util.convertNull(model.getString("tranDate")).toString());

            cell = row.createCell(2); //입금시간
            cell.setCellStyle(CellStyle_center);
            cell.setCellValue(Util.convertNull(model.getString("tranTime")).toString());

            cell = row.createCell(3); //입금구분
            cell.setCellStyle(CellStyle_center);
            cell.setCellValue(Util.convertNull(model.getString("tranClsfy")).toString());

            cell = row.createCell(4); //은행코드
            cell.setCellStyle(CellStyle_center);
            cell.setCellValue(Util.convertNull(model.getString("bankId")).toString());

            cell = row.createCell(5); //입금은행
            cell.setCellStyle(CellStyle_center);
            cell.setCellValue(Util.convertNull(model.getString("bankName")).toString());

            cell = row.createCell(6); //지점
            cell.setCellStyle(CellStyle_center);
            cell.setCellValue(Util.convertNull(model.getString("tranBranch")).toString());

            cell = row.createCell(7); //입금자명
            cell.setCellStyle(CellStyle_center);
            cell.setCellValue(Util.convertNull(model.getString("tranContent")).toString());
            
            cell = row.createCell(8); //입금액
            cell.setCellStyle(CellStyle_right);
            cell.setCellValue(Util.convertNull(model.getString("tranAmt")).toString());

	    	rowIndex++;
        }	
	    
		try {
	        response.setHeader("Content-Disposition", "attachement; filename=\""
	            + java.net.URLEncoder.encode(excelName, "UTF-8") + "\";charset=\"UTF-8\"");
		} catch (UnsupportedEncodingException e) {
		    // TODO Auto-generated catch block
		    e.printStackTrace();
		}
	}
    
    public CellStyle getTitleStyle(Workbook workbook, int fontSize, short align, boolean isBold, boolean isBG, boolean isBorder) {
        CellStyle style = workbook.createCellStyle();

        if (titleFont == null) {
        	titleFont = workbook.createFont();
        }

        style.setFont(getFont(titleFont, fontSize, isBold));
        style.setAlignment(align);
        style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

        if (isBG) {
			style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
        }

        if (isBorder) {
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
			style.setBorderLeft(CellStyle.BORDER_THIN);
			style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
			style.setBorderRight(CellStyle.BORDER_THIN);
			style.setRightBorderColor(IndexedColors.BLACK.getIndex());
			style.setBorderTop(CellStyle.BORDER_THIN);
			style.setTopBorderColor(IndexedColors.BLACK.getIndex());
        }

        return style;
    }
    
    public CellStyle getColumnStyle(Workbook workbook, int fontSize, short align, boolean isBold, boolean isBG, boolean isBorder) {
		CellStyle style = workbook.createCellStyle();

        if (columnFont == null) {
        	columnFont = workbook.createFont();
        }

		style.setFont(getFont(columnFont, fontSize, isBold));
		style.setAlignment(align);
		style.setVerticalAlignment(CellStyle.VERTICAL_CENTER);

        if (isBG) {
			style.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
			style.setFillPattern(CellStyle.SOLID_FOREGROUND);
        }

        if (isBorder) {
			style.setBorderBottom(CellStyle.BORDER_THIN);
			style.setBottomBorderColor(IndexedColors.BLACK.getIndex());
			style.setBorderLeft(CellStyle.BORDER_THIN);
			style.setLeftBorderColor(IndexedColors.BLACK.getIndex());
			style.setBorderRight(CellStyle.BORDER_THIN);
			style.setRightBorderColor(IndexedColors.BLACK.getIndex());
			style.setBorderTop(CellStyle.BORDER_THIN);
			style.setTopBorderColor(IndexedColors.BLACK.getIndex());
        }

        return style;
    }    
    
    public Font getFont(Font objFont, int fontSize, boolean isBold) {
        objFont.setFontHeightInPoints((short) fontSize);

        if (isBold) {
          objFont.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
        } else {
          objFont.setBoldweight(HSSFFont.BOLDWEIGHT_NORMAL);
        }

        objFont.setColor(IndexedColors.BLACK.getIndex());

        return objFont;
      }        
}
