package kr.or.chest.br.common;

import javax.servlet.http.HttpServletRequest;

import kr.or.chest.br.receipt.dto.UserDto;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class BaseController {
	private Logger log = LoggerFactory.getLogger(this.getClass());

	protected UserDto getSessionInfo() {
        ServletRequestAttributes sra = (ServletRequestAttributes)RequestContextHolder.currentRequestAttributes();
        HttpServletRequest request = sra.getRequest();
        UserDto user = (UserDto) request.getSession().getAttribute("userInfo");
        return user;
    }

	protected String goPage(String url) {
    	if(getSessionInfo()==null) {
    		log.debug("getSessionInfo IS NULL");
    		url = "login/login";
    	}
		log.debug("getSessionInfo IS NOT NULL : " + url);
    	
    	return url;
    }

}
