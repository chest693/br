package kr.or.chest.br;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.PropertySource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
//import org.springframework.session.data.redis.config.annotation.web.http.EnableRedisHttpSession;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpSession; 
import java.util.HashMap; 
import java.util.Map; 
import java.util.Optional; 
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;

@PropertySource({
    "classpath:checkPlus.properties"
})

@SpringBootApplication
//@EnableRedisHttpSession
public class BrApplication {
	private Logger log = LoggerFactory.getLogger(this.getClass());

	public static void main(String[] args) {
		SpringApplication.run(BrApplication.class, args);
	}

}
