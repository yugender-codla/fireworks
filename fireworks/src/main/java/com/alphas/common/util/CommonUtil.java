package com.alphas.common.util;

import java.security.SecureRandom;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.Period;
import java.time.ZoneId;
import java.time.temporal.ChronoUnit;
import java.time.temporal.TemporalAdjusters;
import java.util.Date;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Component;

@Component
public class CommonUtil {

	
	@Value("${minimumDeliveryDays}")
	private Integer minimumDeliveryDays;
	
	
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
	
	
	
	public String convertDateToUI(Date date){
		Format formatter = new SimpleDateFormat("dd-MMM-yyyy");
		if(date == null) return null;
		return formatter.format(date);
	}
	
	
	public String convertDateToTimeStamp(Date date){
		Format formatter = new SimpleDateFormat("dd-MMM-yyyy HH:mm");
		if(date == null) return null;
		return formatter.format(date);
	}
	
	public String getLoggedInUser() {
	Authentication auth = SecurityContextHolder.getContext().getAuthentication();
	User user = (User)auth.getPrincipal();
	
	return user.getUsername();
	}
	
	public Date getDeliverDate() {
	        ZoneId defaultZoneId = ZoneId.systemDefault();
	        LocalDate locDate = LocalDate.now().with(TemporalAdjusters.next(DayOfWeek.SUNDAY));
	        Date date = null;
	        LocalDate today = LocalDate.now();
	        long noOfDays = ChronoUnit.DAYS.between(today,locDate);
	        if(noOfDays < 3) {
	        	locDate = locDate.with(TemporalAdjusters.next(DayOfWeek.SUNDAY));
	        }
	        date = Date.from(locDate.atStartOfDay(defaultZoneId).toInstant());
	        return date;
	}
}
