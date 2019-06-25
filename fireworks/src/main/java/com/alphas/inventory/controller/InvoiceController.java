package com.alphas.inventory.controller;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Invoice;
import com.alphas.inventory.dto.InvoiceLineItem;
import com.alphas.inventory.dto.InvoiceSearchForm;
import com.alphas.inventory.service.InvoiceService;
import com.alphas.product.service.ProductService;

@Controller
@RequestMapping("/invoice")
public class InvoiceController {
	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private ProductService productService;

	@Autowired
	private InvoiceService inventoryService;

	@GetMapping(value = "/add")
	public String showAddInventory(Model model) {
		Invoice invoice = new Invoice();
		try {
			model.addAttribute("invoice", invoice);
			model.addAttribute("productList", productService.retrieveAll());
			model.addAttribute("pageView","invoice/add");
		} catch (AException e) {
			LOGGER.error(e.getMessage(), e);
		}
	//	return "invoice/add";
		return "common/maintenanceTemplate";
	}

	@PostMapping(value = "/save")
	public String addInvoice(@ModelAttribute("invoice") Invoice invoice, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		String redirectTo = invoice.getInvoiceid() == null ? "redirect:add" : "redirect:search/display";
		try {
			//model.addAttribute("pageView",invoice.getInvoiceid() == null ? "invoice/add" : "invoice/edit");
			
			List<InvoiceLineItem> list = invoice.getInvoiceLineItems().stream().filter(t -> t.getProductId() != null).collect(Collectors.toList());
			invoice.setInvoiceLineItems(list);

			Invoice returnResult = inventoryService.addInvoice(invoice);

			model.addAttribute("invoice", invoice);
			model.addAttribute("productList", productService.retrieveAll());
			
			
			redirectAttributes.addFlashAttribute("msg",	"Invoice " + returnResult.getBillNo() + " created/updated successfully!");
		} catch (AException e) {
			LOGGER.error(e.getMessage(), e);
		}
		
		return redirectTo;
	}

	@GetMapping("/search/display")
	public String showSearch(Model model) {
		
		model.addAttribute("pageView","invoice/list");
		return "common/maintenanceTemplate";
	}

	@GetMapping(value = "/search/find")
	public String search(@RequestParam("fromDate") @DateTimeFormat(pattern = "yyyy-MM-dd") Optional<Date> fromDate,
			@RequestParam("toDate") @DateTimeFormat(pattern = "yyyy-MM-dd") Optional<Date> toDate, Model model,
			final RedirectAttributes redirectAttributes) {
		InvoiceSearchForm form = new InvoiceSearchForm();
		List<Invoice> list = null;
		try {

			form.setFromDate(fromDate);
			form.setToDate(toDate);
			model.addAttribute("invoices", inventoryService.retrieveInvoice(form));
			model.addAttribute("pageView","invoice/list");
		} catch (AException e) {
			LOGGER.error(e.getMessage(), e);
		}
		return "common/maintenanceTemplate";
	}

	@GetMapping(value = "/{id}/update")
	public String showUpdateInvoice(@PathVariable("id") Long id, Model model,
			final RedirectAttributes redirectAttributes) {
		try {
			Invoice invoice = inventoryService.findById(id);
			model.addAttribute("productList", productService.retrieveAll());
			model.addAttribute("invoice", invoice);
			model.addAttribute("pageView","invoice/edit");
		} catch (AException e) {
			LOGGER.error(e.getMessage(), e);
		}
		return "common/maintenanceTemplate";
	}
	
	
	@GetMapping(value = "/{id}/view")
	@ResponseBody
	public Invoice viewInvoice(@PathVariable("id") Long id, Model model,
			final RedirectAttributes redirectAttributes) {
		
			Invoice invoice = inventoryService.findById(id);
			invoice.getInvoiceLineItems().forEach(t -> t.setInvoice(null));
			model.addAttribute("invoice", invoice);
		return invoice;
	}

}
