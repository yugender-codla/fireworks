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
import com.alphas.mail.SendMail;

@Controller
public class FireSupportController {
	
	
	@Autowired
	private SendMail mailSender;
	
	
	@Value("${toMailAddress}")
	private String toMailAddress;
	
	@Value("${enquirySubject}")
	private String enquirySubject;
	
	
	
	@GetMapping("/firesupport")
	public String showMaintenancePage(Model model, final RedirectAttributes redirectAttributes) {
		model.addAttribute("pageView", "order/searchOrders");
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
	
}
