package com.alphas.inventory.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Invoice;
import com.alphas.inventory.service.InventoryService;
import com.alphas.product.service.ProductService;

@Controller
@RequestMapping("/inventory")
public class InventoryController {
		private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());
		
		@Autowired
		private ProductService productService;
		
		@Autowired
		private InventoryService inventoryService;
		
		@GetMapping(value = "/add")
		public String showAddInventory(Model model) {
			Invoice invoice = new Invoice();
			try {
				model.addAttribute("invoice", invoice);
				model.addAttribute("productList",productService.retrieveAll());
			}catch(AException e) {
				LOGGER.error(e.getMessage(), e);
			}
			return "inventory/add";
		}
	
		
		@PostMapping(value = "/save")
		public String addInvoice(@ModelAttribute("invoice") Invoice invoice, BindingResult result, Model model, final RedirectAttributes redirectAttributes) {
		try {
			Invoice returnResult = inventoryService.addInvoice(invoice);

			model.addAttribute("invoice", invoice);
			model.addAttribute("productList",productService.retrieveAll());
			
			
			redirectAttributes.addFlashAttribute("msg", "Invoice "+returnResult.getBillNo()+" created successfully!");
		}catch(AException e) {
			LOGGER.error(e.getMessage(), e);
		}
			return "inventory/add";
		}
		
}

