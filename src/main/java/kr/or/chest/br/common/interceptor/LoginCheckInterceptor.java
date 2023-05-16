/**
 *
 */
package kr.or.chest.br.common.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.HandlerInterceptorAdapter;
import kr.or.chest.br.receipt.dto.UserDto;

/**
 * @author kimbongjin
 *
 */
public class LoginCheckInterceptor extends HandlerInterceptorAdapter {

	private Logger log = LoggerFactory.getLogger(this.getClass());

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String requestURI = request.getRequestURI();
        boolean isCheck = true;

        if (request.getParameter("unChecked") != null) {
            if ("Y".equals(request.getParameter("unChecked"))) {
                isCheck = false;
            }
        }
        
        if (isCheck) {
        	if ("/".equals(requestURI)) {
	            return true;
	        } else if (requestURI.indexOf("/sessionChk.do") > -1) {
                return true;
            } else if (requestURI.indexOf("/popup/") > -1) {
	            return true;
	        } else if (requestURI.indexOf("/robots.txt") > -1) {
                return true;
            } /*else if (requestURI.indexOf("/login.do") > -1) {
                return true;
            } else if (requestURI.indexOf("/login") > -1) {
                return true;
            }*/ else if (requestURI.indexOf("/test.do") > -1) {
                return true;
            } else if (requestURI.indexOf("/index.html") > -1) {
                return true;
            } else if (requestURI.indexOf("/index_br.html") > -1) {
                return true;
            } /*else {
                UserDto user = (UserDto) request.getSession().getAttribute("userInfo");
                if(user!=null) {
                    return true;
                }
                
            }
            */
        	//url 직접 접근 방지
	        if(request.getHeader("REFERER")==null) {
	        	request.getRequestDispatcher(request.getContextPath() + "/popup/error.do").forward(request, response);
	        	log.debug("잘못된 접근입니다. ["+requestURI+"]");
	        	return false;
	        }
	        
	    	return true;
            
            
        } else {
            return true;
        }
        
        //request.getRequestDispatcher(request.getContextPath() + "/index.html").forward(request, response);
    	//response.sendRedirect("/index_br.html");
        //return false;
    }
    
    @Override
    public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView modelAndView) throws Exception {

    }
}
