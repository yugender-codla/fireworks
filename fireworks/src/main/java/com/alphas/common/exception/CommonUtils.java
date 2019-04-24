package com.alphas.common.exception;

import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;

public class CommonUtils {

	static Format formatter = new SimpleDateFormat("dd-MMM-yyyy");
	
	public static String convertDateToUI(Date date){
		return formatter.format(date);
	}
	
}
