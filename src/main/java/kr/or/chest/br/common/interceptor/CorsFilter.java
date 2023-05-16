package kr.or.chest.br.common.interceptor;

import java.io.IOException;
import java.util.Enumeration;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.Ordered;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;
import kr.or.chest.br.common.HttpRequestWithModifiableParameters;
import java.util.Base64;
import java.util.Base64.Decoder;
import kr.or.chest.br.common.ModifiableHttpServletRequest;

@Order(Ordered.LOWEST_PRECEDENCE -1)
@Component
public class CorsFilter implements Filter{
	private Logger log = LoggerFactory.getLogger(this.getClass());

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
/*
		HttpServletRequest req = (HttpServletRequest) request;
		
		ModifiableHttpServletRequest m = new ModifiableHttpServletRequest(req);
		request = (HttpServletRequest)m;
		req = (HttpServletRequest) request;
		
		
		HttpRequestWithModifiableParameters param = new HttpRequestWithModifiableParameters(req); //요렇게 생성해서
		for (Enumeration e = req.getParameterNames() ; e.hasMoreElements() ;) {
			String strName  = (String) e.nextElement();
			Object strValue = req.getParameter(strName);
					
			if(strValue.getClass().toString().contains("String")){
				Decoder decoder = Base64.getDecoder(); 
				if(checkForEncode(strValue.toString())) {
					byte[] decodedBytes = decoder.decode(strValue.toString().getBytes());
					m.setParameter(strName, new String(decodedBytes));
					log.debug( "@ encoding Value : " +strName + " [" + strValue.toString() + "]["+new String(decodedBytes)+"]");
				} else {
					m.setParameter(strName, new String(strValue.toString()));
					log.debug( "@ normal Value :  " +strName + " [" + strValue.toString() + "]");
				}
			}
		}

		m = new ModifiableHttpServletRequest(req);
		request = (HttpServletRequest)m;
*/		
		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {

	}

	public static boolean checkForEncode(String string) {
	    String pattern = "^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{4}|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)$";
	    Pattern r = Pattern.compile(pattern);
	    Matcher m = r.matcher(string);
	    if (m.find()) {
	    	return true;
	    } else {
	    	return false;
	    }
	}	
	
} 