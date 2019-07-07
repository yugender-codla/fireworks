package com.alphas.common.controller;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alphas.common.dto.ContactForm;
import com.alphas.common.util.CommonUtil;
import com.alphas.mail.SendMail;

@Controller
public class FireSupportController {
	 static String url = "https://www.way2sms.com";
	
	@Autowired
	private SendMail mailSender;
	
	
	@Value("${toMailAddress}")
	private String toMailAddress;
	
	@Value("${enquirySubject}")
	private String enquirySubject;
	

	@Autowired
	CommonUtil commonUtil;
	
	@GetMapping("/firesupport")
	public String showMaintenancePage(Model model, final RedirectAttributes redirectAttributes) {
		model.addAttribute("pageView", "order/searchOrders");
		redirectAttributes.addFlashAttribute("usermsg",commonUtil.getLoggedInUser());
		return "common/maintenanceTemplate";
	}
	
	
	@GetMapping(value="/fireworks/contactUs")
	public String contactUs(@ModelAttribute("contactForm") ContactForm contactForm,BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		model.addAttribute("pageView", "common/contactUs");
		return "common/template";
		
	}
	
	@PostMapping("/fireworks/contactUs")
	public String sendMessage(@Valid @ModelAttribute("contactForm") ContactForm contactForm,BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		
		
		if(!result.hasErrors()) {
			enquirySubject = enquirySubject + "-"+ contactForm.getName();
			StringBuffer content = new StringBuffer(); 
					content.append(contactForm.getName() +"\n");
					content.append(contactForm.getUserEmail() +"\n");
					content.append(contactForm.getMessage() +"\n");
			mailSender.send(toMailAddress, enquirySubject,content.toString());
			redirectAttributes.addFlashAttribute("msg","Mail Sent.");
		}else {
			model.addAttribute("pageView", "common/contactUs");
			return "common/template";
		}
		return "redirect:contactUs";
	}
	
	
	 /*public String sendCampaign(String apiKey,String secretKey,String useType, String phone, String message, String senderId){
	      try{
	          // construct data
	        
	    	  jsonObject.put("apikey",apiKey);
	    	  jsonObject.put("secret",secretKey);
	    	  jsonObject.put("usetype",useType);
	    	  jsonObject.put("phone", phone);
	    	  jsonObject.put("message", URLEncoder.encode(message,"UTF-8"));
	    	  jsonObject.put("senderid", senderId);
	        URL obj = new URL(url + "/api/v1/sendCampaign");
	          // send data
	        HttpURLConnection httpConnection = (HttpURLConnection) obj.openConnection();
	        httpConnection.setDoOutput(true);
	        httpConnection.setRequestMethod("POST");
	        DataOutputStream wr = new DataOutputStream(httpConnection.getOutputStream());
	        wr.write(jsonObject.toString().getBytes());
	        // get the response  
	        BufferedReader bufferedReader = null;
	        if (httpConnection.getResponseCode() == 200) {
	            bufferedReader = new BufferedReader(new InputStreamReader(httpConnection.getInputStream()));
	        } else {
	            bufferedReader = new BufferedReader(new InputStreamReader(httpConnection.getErrorStream()));
	        }
	        StringBuilder content = new StringBuilder();
	        String line;
	        while ((line = bufferedReader.readLine()) != null) {
	            content.append(line).append("\n");
	        }
	        bufferedReader.close();
	        return content.toString();
	      }catch(Exception ex){
	        
	        return "{'status':500,'message':'Internal Server Error'}";
	      }
	        
	    }
	
	 @GetMapping("/sendSMS")
	 public void mainMethod() {
	    	String apikey = "0O08NH3SYM7UTL5SP8HSPUSAE7N098J8";
	    	String secretkey = "CJ5C8DL9CPHWCDNX";
	    	String useType = "prod";
	    	String phone = "9841363614";
	    	String message = "This is a test message.";
	    	String senderId = "9841008735";
	    	sendCampaign(apikey,secretkey,useType,phone, message,senderId);
	    }*/
}
