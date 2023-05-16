package kr.or.chest.br.common;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

import kr.or.chest.br.receipt.dto.LoginDto;
import kr.or.chest.br.receipt.dto.ResultMap;
import kr.or.chest.br.receipt.dto.UserDto;
import kr.or.chest.br.receipt.service.ReceiptService;


@Controller
public class MainController extends BaseController {
	private Logger log = LoggerFactory.getLogger(this.getClass());

    @Autowired
    private ReceiptService receiptService;
    @RequestMapping("/test.do")
    public String jsp(Model model) {
        return "login/test";
    }

    // 초기화면
    @RequestMapping("/login")
    public ModelAndView login(HttpServletRequest request, Model model) {
    	ModelAndView mv = new ModelAndView("login/login");
    	
        if(request.getSession().getAttribute("userInfo")!=null) {
        	mv = new ModelAndView("main/receipt/receiptApply");
    	}
    	
        return mv;
    }
    
    // 초기화면
    @RequestMapping("/mobileCertify.do")
    public ModelAndView mobileCertify(HttpServletRequest request, Model model) {
    	ModelAndView mv = new ModelAndView("login/mobileCertify");
    	
    	return mv;
    }
    
    
    // 로그인
    @RequestMapping("/login.do")
    @ResponseBody
    public HashMap<String,Object> login( HttpServletRequest request, LoginDto login, @RequestParam(value="id") String id, @RequestParam(value="pwd") String pwd){
    	HashMap<String,Object> map = new HashMap<String,Object>();
    	
    	ResultMap resultMap = receiptService.selectLoginEMPLInfo(request, login);
    	
        map.put("resultCode", resultMap.getResultCode());
        map.put("resultMsg", resultMap.getResultMsg());
        
    	return  map;
    }

    // 로그아웃
    @RequestMapping("/logout.do")
    public String logout( HttpSession session ){
        session.invalidate();
        
    	return  "login/login";
    }
    
    // 세션체크
    @RequestMapping("/sessionChk.do")
    @ResponseBody
    public HashMap<String,Object> sessionChk( HttpServletRequest request ){
    	HashMap<String,Object> map = new HashMap<String,Object>();
    	
    	UserDto user = (UserDto) request.getSession().getAttribute("userInfo");
    	
    	if(user==null) {
            map.put("resultCode", "F");
            map.put("resultMsg", "세션이 종료되었습니다.");
    	}else {
            map.put("resultCode", "S");
    	}
        
    	return  map;
    }
}