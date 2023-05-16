package kr.or.chest.br;

import org.springframework.boot.web.servlet.error.ErrorController;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;

@Controller 
public class CustomErrorController implements ErrorController { 
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
	private String VIEW_PATH = "/error/"; 
	
	@RequestMapping(value = "/error") 
	public String handleError(HttpServletRequest request) { 
		
		Object status = request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE); 

		if(status != null){ 
			int statusCode = Integer.valueOf(status.toString()); 
			log.debug("---------------------- CustomErrorController["+statusCode+"] --------------------------");

			if(statusCode == 400){ 
				return VIEW_PATH + "error"; 
			} 

			if(statusCode == 401){ 
				return VIEW_PATH + "error"; 
			} 

			if(statusCode == 403){ 
				return VIEW_PATH + "error"; 
			} 

			if(statusCode == 404){ 
				return VIEW_PATH + "error"; 
			} 
			
			if(statusCode == 500){ 
				return VIEW_PATH + "error"; 
			} 
		} 
		
		return "error"; 
	} 
	
	@Override public String getErrorPath()	{ 
		return "/error"; 
	} 
}
