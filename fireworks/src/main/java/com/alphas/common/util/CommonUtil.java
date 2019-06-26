package com.alphas.common.util;

import java.security.SecureRandom;

import org.springframework.stereotype.Component;

@Component
public class CommonUtil {

	public static void main(String args[])
	{
		SecureRandom random = new SecureRandom();
		CommonUtil util = new CommonUtil();
		System.out.println(util.generateRandomString());
		//System.out.println(generateRandomString(random, 6));
	}
	
	public String generateRandomString(){
		SecureRandom random = new SecureRandom();
		int length = 8;
        return random.ints(48,122)
                .filter(i-> (i<57 || i>65) && (i <90 || i>97))
                .mapToObj(i -> (char) i)
                .limit(length)
                .collect(StringBuilder::new, StringBuilder::append, StringBuilder::append)
                .toString().toUpperCase();
    }
}
