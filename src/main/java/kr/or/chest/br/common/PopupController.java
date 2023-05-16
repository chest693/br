package kr.or.chest.br.common;

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

import kr.or.chest.br.receipt.dto.ReceiptDto;
import kr.or.chest.br.receipt.dto.LoginDto;
import kr.or.chest.br.receipt.dto.UserDto;
import kr.or.chest.br.receipt.dto.ResultMap;
import kr.or.chest.br.receipt.service.ReceiptService;
import kr.or.chest.br.common.BaseController;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.ui.Model;
import kr.or.chest.br.receipt.mapper.ReceiptMapper;
import javax.servlet.http.HttpServletRequest;
import kr.or.chest.br.common.CamelCaseMap;
import javax.servlet.http.HttpSession;
import kr.or.chest.br.common.Util;
import kr.or.chest.br.receipt.excel.ReceiptListExcelView;;


@RequestMapping("/popup")
@Controller
public class PopupController extends BaseController {
	
	private Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ReceiptService receiptService;
    
    @Autowired
    private ReceiptMapper receiptMapper;

    @Value("${CHECKPLUS.SITE_CODE}")
    private String siteCode;    

    @Value("${CHECKPLUS.SITE_PASSWORD}")
    private String sitePassword;    

    //private String siteCode;    
    //private String sitePassword;    

    // NICE 휴대폰인증 성공
    @RequestMapping("/checkPlusSuccess.do")
    public ModelAndView checkPlusSuccess(@RequestParam(value="EncodeData") String EncodeData){
        ModelAndView mv = new ModelAndView("popup/popup/checkplus_success");

        mv.addObject("siteCode", siteCode);
        mv.addObject("sitePassword", sitePassword);
        mv.addObject("EncodeData", EncodeData);
        
        return mv;
    }
    
    // NICE 휴대폰인증 실패
    @RequestMapping("/checkPlusFail.do")
    public ModelAndView checkPlusFail(){
        ModelAndView mv = new ModelAndView("popup/popup/checkplus_fail");
        return mv;
    }
    
    // NICE 휴대폰인증
    @RequestMapping("/nicePopup.do")
    public ModelAndView mainGuideJoin(){
        ModelAndView mv = new ModelAndView("popup/popup/nicePopup");
        return mv;
    }

    
    
    // 접수상세
    @RequestMapping("/receiptDetail.do")
    public ModelAndView receiptDetail(ReceiptDto receiptDto){
        ModelAndView mv = new ModelAndView("popup/popup/receiptDetail");
    	
        String dpstnId = getSessionInfo().getDpstnId();
        String bhfCode = getSessionInfo().getBhfCode();
        
        receiptDto.setDpstnId(dpstnId);

        CamelCaseMap ccm = receiptMapper.selectReceiptDetail(receiptDto);

        mv.addObject("progrmList", receiptMapper.selectProgrm(dpstnId));
        mv.addObject("areaList", receiptMapper.selectArea(bhfCode));
        mv.addObject("receiptDto", receiptDto);
        mv.addObject("detail", ccm);
        return mv;
    }

    // 삭제사유
    @RequestMapping("/receiptDelPopup.do")
    public ModelAndView receiptDelPopup(ReceiptDto receiptDto){
        ModelAndView mv = new ModelAndView("popup/popup/receiptDelPopup");
    	
        String bhfCode = getSessionInfo().getBhfCode();
        
        CamelCaseMap ccm = receiptMapper.selectRceptPrint(receiptDto.getRceptNo(), getSessionInfo().getSptdpstnCd());
        
        mv.addObject("detail", ccm);
        mv.addObject("bhfInfo", receiptMapper.selectBhfInfo(bhfCode));
        return mv;
    }
    
    
    // 현장기부확인서 출력
    @RequestMapping("/receiptPrint.do")
    public ModelAndView receiptPrint(@RequestParam(value="rceptNo", defaultValue = "") String rceptNo){
        ModelAndView mv = new ModelAndView("popup/popup/receiptPopup");
        
        CamelCaseMap ccm = receiptMapper.selectRceptPrint(rceptNo, getSessionInfo().getSptdpstnCd());
        String ihidnumBizrno = (String)ccm.get("ihidnumBizrno");
        
        if(ihidnumBizrno.length()==13) {
        	ihidnumBizrno = ihidnumBizrno.substring(0,6) + "-"+ ihidnumBizrno.substring(6,7) + "******";
        }

        receiptMapper.printCntUpdate(rceptNo, getSessionInfo().getSptdpstnCd());
        
        mv.addObject("ihidnumBizrno", ihidnumBizrno);
        mv.addObject("detail", ccm);
        return mv;
    }
    
    // 파일다운로드
    @RequestMapping("/fileDownload.do")
    public ModelAndView fileDownload( @RequestParam(value="rceptNo") String rceptNo, @RequestParam(value="type") String type ) throws Exception {
    	return receiptService.fileDownload(rceptNo, type);
    }

    // 파일다운로드
    @RequestMapping("/documentDownload.do")
    public ModelAndView documentDownload( @RequestParam(value="file") String file ) throws Exception {
    	return receiptService.documentDownload(file);
    }

    @RequestMapping("/error.do")
    public ModelAndView error(Model model) {
        ModelAndView mv = new ModelAndView("popup/popup/error");
        return mv;
    }
    
}
