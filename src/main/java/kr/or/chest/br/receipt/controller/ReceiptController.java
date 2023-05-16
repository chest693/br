package kr.or.chest.br.receipt.controller;

import java.util.List;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.multipart.MultipartHttpServletRequest;


import kr.or.chest.br.receipt.dto.ReceiptDto;
import kr.or.chest.br.receipt.dto.LoginDto;
import kr.or.chest.br.receipt.dto.UserDto;
import kr.or.chest.br.receipt.dto.ResultMap;
import kr.or.chest.br.receipt.service.ReceiptService;
import kr.or.chest.br.common.BaseController;
import org.springframework.ui.Model;
import kr.or.chest.br.receipt.mapper.ReceiptMapper;
import javax.servlet.http.HttpServletRequest;


import kr.or.chest.br.common.CamelCaseMap;
import javax.servlet.http.HttpSession;
import kr.or.chest.br.common.Util;
import kr.or.chest.br.receipt.excel.ReceiptListExcelView;
import kr.or.chest.br.receipt.excel.depositListExcelView;

@RequestMapping("/receipt")
@Controller
public class ReceiptController extends BaseController {
	
	private Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ReceiptService receiptService;

    @Autowired
    private ReceiptMapper receiptMapper;
    
	@Value("${spring.nasPath}")
	private String nasPath;
	
    @RequestMapping("/test.do")
    public String jsp(Model model) {
        return "main/receipt/test";
    }
	
    // 기탁서접수 화면
    @RequestMapping("/receiptApply.do")
    public ModelAndView receiptApply(){
    	ModelAndView mv = new ModelAndView("main/receipt/receiptApply");
    	
        String dpstnId = getSessionInfo().getDpstnId();
        String bhfCode = getSessionInfo().getBhfCode();
    	
        mv.addObject("progrmList", receiptMapper.selectProgrm(dpstnId));
        mv.addObject("areaList", receiptMapper.selectArea(bhfCode));
    	
		return mv;
    }

    // 기탁서접수 등록
    @RequestMapping("/receiptAdd.do")
    @ResponseBody
    public HashMap<String,Object> receiptInsert(MultipartHttpServletRequest mRequest, ReceiptDto receiptDto ){
    	HashMap<String,Object> map = new HashMap<String,Object>();
        String resultCode = "";
        String resultMsg = "";
        String rceptNo = "";
        
        try {
        	map = receiptService.receiptInsert(mRequest, receiptDto);
        	
        	rceptNo = (String)map.get("rceptNo");
            resultCode = "S";
            resultMsg = "정상적으로 처리되었습니다.";
        } catch (Exception e) {
            resultCode = "E";
            resultMsg = "작업중 오류가 발생했습니다.\n관리자에게 문의바랍니다.";
        }

        map.put("resultCode",resultCode);
        map.put("resultMsg",resultMsg);
        map.put("rceptNo",rceptNo);
    	
    	return map;
    }

    // 기탁서 수정
    @RequestMapping("/receiptUpdate.do")
    @ResponseBody
    public HashMap<String,Object> receiptUpdate(MultipartHttpServletRequest mRequest, ReceiptDto receiptDto ){
    	HashMap<String,Object> map = new HashMap<String,Object>();
        String resultCode = "";
        String resultMsg = "";
        String rceptNo = "";
        
        try {
        	map = receiptService.receiptUpdate(mRequest, receiptDto);
        	
        	rceptNo = (String)map.get("rceptNo");
            resultCode = "S";
            resultMsg = "정상적으로 처리되었습니다.";
        } catch (Exception e) {
            resultCode = "E";
            resultMsg = "작업중 오류가 발생했습니다.\n관리자에게 문의바랍니다.";
        }

        map.put("resultCode",resultCode);
        map.put("resultMsg",resultMsg);
        map.put("rceptNo",rceptNo);
    	
    	return map;
    }
    
    // 기탁서 삭제
    @RequestMapping("/receiptDelete.do")
    @ResponseBody
    public HashMap<String,Object> receiptDelete(ReceiptDto receiptDto ){
    	HashMap<String,Object> map = new HashMap<String,Object>();
        String resultCode = "";
        String resultMsg = "";
        
        try {
            receiptService.receiptDelete(receiptDto);
        	
            resultCode = "S";
            resultMsg = "정상적으로 처리되었습니다.";
        } catch (Exception e) {
            resultCode = "E";
            resultMsg = "작업중 오류가 발생했습니다.\n관리자에게 문의바랍니다.";
        }

        map.put("resultCode",resultCode);
        map.put("resultMsg",resultMsg);
    	
    	return map;
    }
    
    
    // 계좌정보
    @RequestMapping("/selectAccount.do")
    @ResponseBody
    public HashMap<String,Object> selectAccount(@RequestParam(value="progrmCode", defaultValue = "") String progrmCode){
        String dpstnId = getSessionInfo().getDpstnId();
        
    	HashMap<String,Object> map = new HashMap<String,Object>();
    	map.put("selectAccount",receiptMapper.selectAccount(dpstnId, progrmCode));
    	return map;
    }

    // 주민/사업자 번호 유효성 확인 
    @RequestMapping("/checkIhidnumBizrno.do")
    @ResponseBody
    public String checkIhidnumBizrno(@RequestParam(value="ihidnumBizrno", defaultValue = "") String ihidnumBizrno){
    	//String ihibiznoCheck = receiptMapper.checkIhidnumBizrno(ihidnumBizrno);
    	return receiptMapper.checkIhidnumBizrno(ihidnumBizrno);
    }
    
    // 접수내역
    @RequestMapping("/receiptList.do")
    public ModelAndView receiptList(ReceiptDto receiptDto, @RequestParam(value="PAGE", defaultValue = "1") int PAGE, @RequestParam(value="PAGE_GROUP", defaultValue = "10") int PAGE_GROUP){
        ModelAndView mv = new ModelAndView("main/receipt/receiptList");
    	
        String dpstnId = getSessionInfo().getDpstnId();
        String bhfCode = getSessionInfo().getBhfCode();
        
        receiptDto.setDpstnId(dpstnId);

        if ( ("").equals(Util.convertNull(receiptDto.getRceptDeFd())) ) {
    		receiptDto.setRceptDeFd(Util.getFirstDay());
        }
        
        if ( ("").equals(Util.convertNull(receiptDto.getRceptDeTd())) ) {
    		receiptDto.setRceptDeTd(Util.getToday("yyyyMMdd"));
        }

        if(receiptDto.getDpstnNm()==null) receiptDto.setDpstnNm("");
        if(receiptDto.getRegister()==null) receiptDto.setRegister("");
        
        receiptDto.setPAGE_GROUP(10);
        List<CamelCaseMap> list = receiptMapper.selectReceiptList(receiptDto);
        
        mv.addObject("progrmList", receiptMapper.selectProgrm(dpstnId));
        mv.addObject("areaList", receiptMapper.selectArea(bhfCode));
        mv.addObject("bhfInfo", receiptMapper.selectBhfInfo(bhfCode));
        mv.addObject("receiptDto", receiptDto);
        mv.addObject("list", list);
        return mv;
    }

    // 접수내역전송
    @RequestMapping("/transList.do")
    public ModelAndView transList(ReceiptDto receiptDto, @RequestParam(value="PAGE", defaultValue = "1") int PAGE, @RequestParam(value="PAGE_GROUP", defaultValue = "10") int PAGE_GROUP){
        ModelAndView mv = new ModelAndView("main/receipt/transList");
    	
        String dpstnId = getSessionInfo().getDpstnId();
        String bhfCode = getSessionInfo().getBhfCode();
        
        receiptDto.setDpstnId(dpstnId);

        if ( ("").equals(Util.convertNull(receiptDto.getRceptDeFd())) ) {
    		receiptDto.setRceptDeFd(Util.getFirstDay());
        }
        
        if ( ("").equals(Util.convertNull(receiptDto.getRceptDeTd())) ) {
    		receiptDto.setRceptDeTd(Util.getToday("yyyyMMdd"));
        }
        
        receiptDto.setPAGE_GROUP(10);
        
        if(receiptDto.getDpstnNm()==null) receiptDto.setDpstnNm("");
        
        List<CamelCaseMap> list = receiptMapper.selectTransList(receiptDto);
        
        mv.addObject("progrmList", receiptMapper.selectProgrm(dpstnId));
        mv.addObject("areaList", receiptMapper.selectArea(bhfCode));
        mv.addObject("receiptDto", receiptDto);
        mv.addObject("list", list);
        return mv;
    }

    
    // 기탁서 전송
    @RequestMapping("/transExec.do")
    @ResponseBody
    public HashMap<String,Object> transExec(ReceiptDto receiptDto ){
    	HashMap<String,Object> map = new HashMap<String,Object>();
        String resultCode = "";
        String resultMsg = "";
        
        try {

            receiptService.transExec(receiptDto);
        	
            resultCode = "S";
            resultMsg = "정상적으로 처리되었습니다.";
        } catch (Exception e) {
            resultCode = "E";
            resultMsg = "작업중 오류가 발생했습니다.\n관리자에게 문의바랍니다.";
        }

        map.put("resultCode",resultCode);
        map.put("resultMsg",resultMsg);
    	
    	return map;
    }

    
    // 입금내역
    @RequestMapping("/depositList.do")
    public ModelAndView depositList(ReceiptDto receiptDto, @RequestParam(value="PAGE", defaultValue = "1") int PAGE, @RequestParam(value="PAGE_GROUP", defaultValue = "10") int PAGE_GROUP){
        ModelAndView mv = new ModelAndView("main/receipt/depositList");
    	
        String dpstnId = getSessionInfo().getDpstnId();
        
        receiptDto.setDpstnId(dpstnId);

        if ( ("").equals(Util.convertNull(receiptDto.getRceptDeFd())) ) {
    		receiptDto.setRceptDeFd(Util.getFirstDay());
        }
        
        if ( ("").equals(Util.convertNull(receiptDto.getRceptDeTd())) ) {
    		receiptDto.setRceptDeTd(Util.getToday("yyyyMMdd"));
        }
        receiptDto.setPAGE_GROUP(10);
        
        if(receiptDto.getTranFt()==null) receiptDto.setTranFt("");
        if(receiptDto.getTranEt()==null) receiptDto.setTranEt("");
        if(receiptDto.getRcpnmyerNm()==null) receiptDto.setRcpnmyerNm("");
        
        List<CamelCaseMap> list = receiptMapper.selectDepositList(receiptDto);
        
        mv.addObject("progrmList", receiptMapper.selectProgrm(dpstnId));
        mv.addObject("receiptDto", receiptDto);
        mv.addObject("list", list);
        return mv;
    }

    // 입금내역 Excel
    @RequestMapping("/depositListExcelView.do")
    public depositListExcelView excelDepositListDownload( ReceiptDto receiptDto, Model model ) {
		
        String dpstnId = getSessionInfo().getDpstnId();
        String bhfCode = getSessionInfo().getBhfCode();
        
        receiptDto.setDpstnId(dpstnId);

        if(receiptDto.getRceptDeFd()==null || ("").equals(receiptDto.getRceptDeFd()) ) {
    		receiptDto.setRceptDeFd(Util.getFirstDay());
        }
        if(receiptDto.getRceptDeTd()==null || ("").equals(receiptDto.getRceptDeTd()) ) {
    		receiptDto.setRceptDeTd(Util.getToday("yyyyMMdd"));
        }
        
    	receiptDto.setPAGE(1);
    	receiptDto.setPAGE_GROUP(999999);
        
		model.addAttribute("list", receiptMapper.selectDepositList(receiptDto));
		model.addAttribute("receiptDto", receiptDto);
		
        return new depositListExcelView();
    }
    
    
    // 접수내역 Excel
    @RequestMapping("/receiptListExcelView.do")
    public ReceiptListExcelView excelReceiptListDownload( ReceiptDto receiptDto, Model model ) {
		
        String dpstnId = getSessionInfo().getDpstnId();
        String bhfCode = getSessionInfo().getBhfCode();
        
        receiptDto.setDpstnId(dpstnId);

        if(receiptDto.getRceptDeFd()==null || ("").equals(receiptDto.getRceptDeFd()) ) {
    		receiptDto.setRceptDeFd(Util.getFirstDay());
        }
        if(receiptDto.getRceptDeTd()==null || ("").equals(receiptDto.getRceptDeTd()) ) {
    		receiptDto.setRceptDeTd(Util.getToday("yyyyMMdd"));
        }
        
    	receiptDto.setPAGE(1);
    	receiptDto.setPAGE_GROUP(999999);
        
		model.addAttribute("list", receiptMapper.selectReceiptList(receiptDto));
		model.addAttribute("receiptDto", receiptDto);
		
        return new ReceiptListExcelView();
    }
    
    // 접수상세
    @RequestMapping("/receiptDetail.do")
    public ModelAndView receiptDetail(ReceiptDto receiptDto){
        ModelAndView mv = new ModelAndView("main/receipt/receiptDetail");
    	
        String dpstnId = getSessionInfo().getDpstnId();
        String bhfCode = getSessionInfo().getBhfCode();
        
        receiptDto.setDpstnId(dpstnId);

        CamelCaseMap ccm = receiptMapper.selectReceiptDetail(receiptDto);
        
        mv.addObject("progrmList", receiptMapper.selectProgrm(dpstnId));
        mv.addObject("areaList", receiptMapper.selectArea(bhfCode));
        mv.addObject("receiptDto", receiptDto);
        mv.addObject("ccm", ccm);
        return mv;
    }
 

	// 현장기부확인서 발행
    @RequestMapping("/issueSave.do")
    @ResponseBody
    public HashMap<String,Object> issueSave(ReceiptDto receiptDto){
    	HashMap<String,Object> map = new HashMap<String,Object>();
        String resultCode = "";
        String resultMsg = "";
        String cnfirmNo = "";
        
        try {
        	cnfirmNo = receiptService.issueSave(receiptDto);
        	
            resultCode = "S";
            resultMsg = "정상적으로 처리되었습니다.";
        } catch (Exception e) {
            resultCode = "E";
            resultMsg = "작업중 오류가 발생했습니다.\n관리자에게 문의바랍니다.";
        }

        map.put("resultCode",resultCode);
        map.put("resultMsg",resultMsg);
        map.put("cnfirmNo",cnfirmNo);
    	
    	return map;
    }    

	// 현장기부 첨부파일 삭제
    @RequestMapping("/delReceiptFile.do")
    @ResponseBody
    public HashMap<String,Object> delReceiptFile(@RequestParam(value="rceptNo") String rceptNo, @RequestParam(value="type") String type){
    	HashMap<String,Object> map = new HashMap<String,Object>();
        String resultCode = "";
        String resultMsg = "";
        
        try {
        	receiptService.delReceiptFile(rceptNo , type);
        	
            resultCode = "S";
            resultMsg = "정상적으로 처리되었습니다.";
        } catch (Exception e) {
            resultCode = "E";
            resultMsg = "작업중 오류가 발생했습니다.\n관리자에게 문의바랍니다.";
        }

        map.put("resultCode",resultCode);
        map.put("resultMsg",resultMsg);
    	
    	return map;
    }    

    
}
