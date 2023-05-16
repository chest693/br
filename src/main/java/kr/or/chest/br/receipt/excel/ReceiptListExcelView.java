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
import org.apache.poi.ss.usermodel.*;
import java.io.UnsupportedEncodingException;
import kr.or.chest.br.receipt.dto.ReceiptDto;

public class ReceiptListExcelView extends AbstractXlsxView {

    static SimpleDateFormat noneDF 	= new SimpleDateFormat("yyyyMMdd");
	private Logger log = LoggerFactory.getLogger(this.getClass());

    @Override
	protected void buildExcelDocument(Map modelMap, Workbook workbook, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
    	
    	ReceiptDto receiptDto = (ReceiptDto)modelMap.get("receiptDto");

    	String fd = receiptDto.getRceptDeFd();
    	String td = receiptDto.getRceptDeFd();
    	
        String sCurTime = noneDF.format(Calendar.getInstance().getTime());
		String excelName =  "접수내역_"+sCurTime+".xlsx";
		Sheet worksheet = null;
		Row row = null;
		CellStyle style = workbook.createCellStyle(); // 셀 스타일을 위한 변수
		style.setAlignment(CellStyle.ALIGN_CENTER); // 글 위치를 중앙으로 설정
		
        ArrayList<CamelCaseMap> list = (ArrayList<CamelCaseMap>)modelMap.get("list");
        
	    // 새로운 sheet를 생성한다.
	    worksheet = workbook.createSheet("접수내역("+fd+"-"+td+")");
	    
	    // 가장 첫번째 줄에 제목을 만든다.
	    row = worksheet.createRow(0);
	    
	    // 칼럼 길이 설정
	    int columnIndex = 0;
	    while (columnIndex < 10) {
	    	
	    	if(columnIndex == 0) {
	    		worksheet.setColumnWidth(columnIndex, 4000);
	    	} else if (columnIndex == 1) {
	    		worksheet.setColumnWidth(columnIndex, 3000);
	    	} else if (columnIndex == 2) {
	    		worksheet.setColumnWidth(columnIndex, 3000);
	    	} else if (columnIndex == 3) {
	    		worksheet.setColumnWidth(columnIndex, 7000);
	    	} else if (columnIndex == 4) {
	    		worksheet.setColumnWidth(columnIndex, 7000);
	    	} else if (columnIndex == 5) {
	    		worksheet.setColumnWidth(columnIndex, 4000);
	    	} else if (columnIndex == 6) {
	    		worksheet.setColumnWidth(columnIndex, 3000);
	    	} else if (columnIndex == 7) {
	    		worksheet.setColumnWidth(columnIndex, 4000);
	    	} else if (columnIndex == 8) {
	    		worksheet.setColumnWidth(columnIndex, 5000);
	    	} else if (columnIndex == 9) {
	    		worksheet.setColumnWidth(columnIndex, 4000);
	    	}
	    	columnIndex++;
	    }
	    
	    // 헤더 설정
	    row = worksheet.createRow(0);
	    row.createCell(0).setCellValue("접수번호");
	    row.createCell(1).setCellValue("접수일자");
	    row.createCell(2).setCellValue("상태");
	    row.createCell(3).setCellValue("기탁자명");
	    row.createCell(4).setCellValue("입금자명");
	    row.createCell(5).setCellValue("전화번호");
	    row.createCell(6).setCellValue("기탁서유형");
	    row.createCell(7).setCellValue("기탁금액");
	    row.createCell(8).setCellValue("입금계좌");
	    row.createCell(9).setCellValue("영수증신청여부");
	    
	    int rowIndex = 1;
	    
        for (CamelCaseMap model : list) {
	    	row = worksheet.createRow(rowIndex);
	    	row.createCell(0).setCellValue(Util.convertNull(model.getString("rceptNo")).toString());
	    	row.createCell(1).setCellValue(Util.convertNull(model.getString("rceptDeS")).toString());
	    	row.createCell(2).setCellValue(Util.convertNull(model.getString("statsAtNm")).toString());
	    	row.createCell(3).setCellValue(Util.convertNull(model.getString("dpstnNm")).toString());
	    	row.createCell(4).setCellValue(Util.convertNull(model.getString("rcpnmyerNm")).toString());
	    	row.createCell(5).setCellValue(Util.convertNull(model.getString("telno")).toString());
	    	row.createCell(6).setCellValue(Util.convertNull(model.getString("dpstnSeNm")).toString());
	    	row.createCell(7).setCellValue(Util.convertNull(model.getString("trumny")).toString());
	    	row.createCell(8).setCellValue(Util.convertNull(model.getString("rcpmnyAcnut")).toString());
	    	row.createCell(9).setCellValue(Util.convertNull(model.getString("rceptReqstAtNm")).toString());

	    	rowIndex++;
        }	
	    /*
	    // 셀 병합 CellRangeAddress(시작 행, 끝 행, 시작 열, 끝 열)
	    worksheet.addMergedRegion(
	    		new CellRangeAddress(list.size() + 1, list.size() + 1, 0, 6));
	    
	    // 병합 테스트를 위한 설정
	    row = worksheet.createRow(list.size() + 1);
	    row.createCell(0).setCellValue("셀 병합 테스트");
	    row.getCell(0).setCellStyle(style); // 지정한 스타일을 입혀준다.
	    */
	    
	    try {
	        response.setHeader("Content-Disposition", "attachement; filename=\""
	            + java.net.URLEncoder.encode(excelName, "UTF-8") + "\";charset=\"UTF-8\"");
	      } catch (UnsupportedEncodingException e) {
	        // TODO Auto-generated catch block
	        e.printStackTrace();
	      }
	}
}
