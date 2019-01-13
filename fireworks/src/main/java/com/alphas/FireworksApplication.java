package com.alphas;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;

@SpringBootApplication
public class FireworksApplication {

	public static void main(String[] args) {
		SpringApplication.run(FireworksApplication.class, args);
	}

	private int MAX_UPLOAD_SIZE = 5 * 1024 * 1024; 
	@Bean(name = "multipartResolver")
	public CommonsMultipartResolver multipartResolver() {
	    CommonsMultipartResolver multipartResolver = new CommonsMultipartResolver();
	    multipartResolver.setMaxUploadSize(MAX_UPLOAD_SIZE);
	    return multipartResolver;
	}
}

