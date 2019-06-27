package com.alphas.common.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/firesupport")
public class FireSupportController {
	
	@GetMapping("")
	public String showMaintenancePage(Model model, final RedirectAttributes redirectAttributes) {
		model.addAttribute("pageView", "order/searchOrders");
		return "common/maintenanceTemplate";
	}
}
