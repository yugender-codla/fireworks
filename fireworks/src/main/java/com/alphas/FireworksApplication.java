package com.alphas;

import java.util.ArrayList;
import java.util.List;
import java.util.TimeZone;

import javax.annotation.PostConstruct;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.CacheManager;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.concurrent.ConcurrentMapCacheManager;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Scope;
import org.springframework.mobile.device.DeviceHandlerMethodArgumentResolver;
import org.springframework.mobile.device.DeviceResolverHandlerInterceptor;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter;

import com.alphas.order.dto.UserFootPrint;
import com.alphas.order.dto.UserInfo;

@EnableScheduling
@EnableCaching
@SpringBootApplication
public class FireworksApplication extends WebMvcConfigurerAdapter{

	public static void main(String[] args) {
		SpringApplication.run(FireworksApplication.class, args);
	}
	
	
	@PostConstruct
	  public void init(){
	    // Setting Spring Boot SetTimeZone
	    TimeZone.setDefault(TimeZone.getTimeZone("IST"));
	  }
	

	private int MAX_UPLOAD_SIZE = 5 * 1024 * 1024; 
	@Bean(name = "multipartResolver")
	public CommonsMultipartResolver multipartResolver() {
	    CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
	    multipartResolver.setMaxUploadSize(MAX_UPLOAD_SIZE);
	    return multipartResolver;
	}
	
	
	 @Bean
	 public CacheManager cacheManager() {
	        return new ConcurrentMapCacheManager("products");
	    }
	
	/** Configuration to detect device **/ 
	 
	@Bean
	public DeviceResolverHandlerInterceptor 
	        deviceResolverHandlerInterceptor() {
	    return new DeviceResolverHandlerInterceptor();
	}

	@Bean
	public DeviceHandlerMethodArgumentResolver 
	        deviceHandlerMethodArgumentResolver() {
	    return new DeviceHandlerMethodArgumentResolver();
	}

	@Override
	public void addInterceptors(InterceptorRegistry registry) {
	    registry.addInterceptor(deviceResolverHandlerInterceptor());
	}

	@Override
	public void addArgumentResolvers(
	       List<HandlerMethodArgumentResolver> argumentResolvers) {
	   argumentResolvers.add(deviceHandlerMethodArgumentResolver());
	}
	
	
	@Bean
	@Scope("singleton")
	public UserFootPrint userFootPrint() {
		List<UserInfo> list = new ArrayList<>();
		UserFootPrint userFootPrint = new UserFootPrint();
		userFootPrint.setUserInfoList(list);
	    return userFootPrint;
	}
	
	/** End of config to detect device**/
}

