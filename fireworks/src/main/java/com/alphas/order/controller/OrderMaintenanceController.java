package com.alphas.order.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alphas.common.dto.Event;
import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Stock;
import com.alphas.order.dto.Order;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.order.service.OrderService;
import com.alphas.product.dto.Product;
import com.alphas.product.service.ProductService;

@Controller
@RequestMapping("/firesupport/order")
public class OrderMaintenanceController {
	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());
	
	
	@Autowired
	private ProductService productService;

	@Autowired
	private OrderService orderService;
	
	@PostMapping("/find")
	public String findOrders(@RequestBody MultiValueMap<String, String> params, Model model,
			final RedirectAttributes redirectAttributes) {
		try {

			model.addAttribute("pageView", "order/searchOrders");
			model.addAttribute("orders", orderService.findOrder(params));
			model.addAttribute("searchCriteria", params.get("searchCriteria").get(0).toString());
			model.addAttribute("searchValue", params.get("searchValue").get(0).toString());

		} catch (AException exception) {

		}
		return "common/maintenanceTemplate";
	}

	@GetMapping("/search")
	public String showSearchOrder(Model model, final RedirectAttributes redirectAttributes) {
		model.addAttribute("pageView", "order/searchOrders");
		return "common/maintenanceTemplate";
	}

	@PostMapping("/modifyStatus")
	public String modifyStatus(@RequestParam("orderId") String orderId, @RequestParam("event") String event,
			@RequestBody MultiValueMap<String, String> params, Model model,
			final RedirectAttributes redirectAttributes) {
		try {
			
			boolean status = orderService.modifyStatus(orderId, Event.valueOf(event));
			if(!status) {
				model.addAttribute("msg", "One or more Products are not available. Please check Stock.");
			}
			
			model.addAttribute("orders", orderService.findOrder(params));
			model.addAttribute("statusCode", params.get("statusCode") == null ? null :params.get("statusCode").get(0).toString());
			model.addAttribute("pageView", "order/searchOrders");
			
		} catch (AException exception) {
			LOGGER.error(exception.getMessage(), exception);
		}
		return "common/maintenanceTemplate";
	}

	@GetMapping(value = "/{id}/view")
	@ResponseBody
	public List<Stock> viewStock(@PathVariable("id") Long id, Model model,
			final RedirectAttributes redirectAttributes) {
		List<Stock> stockList = null;
		try {
			stockList = orderService.getStockListForAnOrder(id);
		} catch (AException e) {

			e.printStackTrace();
		}

		return stockList;
	}

	@PostMapping(value = "/{id}/retrieve")
	public String retrieveOrder(@PathVariable("id") Long id, Model model,
			final RedirectAttributes redirectAttributes) {
		Order order = null;
		try {
			order = orderService.findById(id);
			List<Product> products = productService.retrieveAvailableProducts();
			Map<String, List<OrderLineItem>> productsMap = orderService.populateOrder(order, products);
			
			model.addAttribute("productsMap", productsMap);
			model.addAttribute("products", products);
			
		} catch (AException e) {
			e.printStackTrace();
		}
		model.addAttribute("order", order);
		model.addAttribute("pageView", "order/orderPage");
		return "common/maintenanceTemplate";
		
	}
	

}
