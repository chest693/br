package kr.or.chest.br.receipt.service;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpSession;

import kr.or.chest.br.receipt.dto.LoginDto;
import kr.or.chest.br.receipt.dto.ReceiptDto;
import kr.or.chest.br.receipt.dto.ResultMap;
import kr.or.chest.br.common.CamelCaseMap;
import kr.or.chest.br.common.Paging;

import org.apache.ibatis.annotations.Param;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

public interface ReceiptService {

	public ResultMap selectLoginEMPLInfo(HttpServletRequest request, LoginDto login);

	public HashMap<String,Object> receiptInsert(MultipartHttpServletRequest mRequest, ReceiptDto receiptdto);

	public HashMap<String,Object> receiptUpdate(MultipartHttpServletRequest mRequest, ReceiptDto receiptdto);

	public void transExec(ReceiptDto receiptdto);
	
	public void fileUpload(MultipartHttpServletRequest mRequest, ReceiptDto receiptdto, String rceptNo, String type);

	public void delReceiptFile(String rceptNo, String type);
	
	public String issueSave(ReceiptDto receiptdto);
	
    public ModelAndView fileDownload(String rceptNo, String type);

    public ModelAndView documentDownload(String file);
    
	public void receiptDelete(ReceiptDto receiptdto);
}
