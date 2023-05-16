package kr.or.chest.br.common.interceptor;

import java.util.Arrays;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
//import kr.or.chest.br.common.interceptor.TestFilter;
//import kr.or.chest.br.common.interceptor.CorsFilter;
import kr.or.chest.br.common.interceptor.CorsFilter;

@Configuration   //스프링부트 웹 설정
public class Configurations implements WebMvcConfigurer {
	/** Register Filter **/
	/** If you want to register other filer, Add Bean for other fileter **/
	/*
	@Autowired
	private CorsFilter corsFilter;	

	@Bean
	public FilterRegistrationBean<CorsFilter> getFilterRegistrationBean() {
		FilterRegistrationBean<CorsFilter> registrationBean = new FilterRegistrationBean<>();
		registrationBean.setFilter(corsFilter);
		registrationBean.setOrder(Ordered.LOWEST_PRECEDENCE - 1);
		registrationBean.addUrlPatterns("/*");
		return registrationBean;
	}	
	*/
	@Override  //인터셉터 등록
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(new LoginCheckInterceptor());  //만들어준 인터셉터
		
		/*
        List<String> URL_PATTERNS = Arrays.asList("/receiptList.do", "/배열로가능2");

		registry.addInterceptor(new LoginCheckInterceptor())  //만들어준 인터셉터
		.addPathPatterns(URL_PATTERNS)   //이런식으로 배열로도 가능하고,
		.excludePathPatterns("/receiptList.do")   //1개1개씩 추가도 가능하다.
		.excludePathPatterns("/원하는패턴2");
		List<String> URL_PATTERNS = Arrays.asList("/receipt/*");
        
		registry.addInterceptor(new LoginCheckInterceptor())
				.addPathPatterns(URL_PATTERNS);
		*/
		
	}
	
}