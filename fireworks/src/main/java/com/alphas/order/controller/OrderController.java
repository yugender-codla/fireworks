package com.alphas.order.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mobile.device.Device;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
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
import com.alphas.product.dto.ProductComboLineItem;
import com.alphas.product.service.ProductService;

@Controller
@RequestMapping("/fireworks")
public class OrderController {
	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());

	@Autowired
	private ProductService productService;

	@Autowired
	private OrderService orderService;
	


/*	@GetMapping("/showProducts")
	public String ShowProducts(Model model) {
		try {
			Order order = new Order();
			List<OrderLineItem> orderLineItems = new ArrayList<OrderLineItem>();
			List<Product> products = productService.retrieveAvailableProducts();

			for (Product product : products) {
				OrderLineItem lineItem = new OrderLineItem();
				lineItem.setProductId(product.getId());
				lineItem.setProductName(product.getName());
				lineItem.setPrice(product.getPrice());
				orderLineItems.add(lineItem);
			}
			order.setOrderLineItems(orderLineItems);

			model.addAttribute("order", order);
			model.addAttribute("products", products);
		} catch (AException e) {

		}
		model.addAttribute("pageView", "order/list");
		return "common/template";
	}*/

	@GetMapping("")
	public String ShowProducts(Device device, Model model) {
		try {

			List<Product> products = productService.retrieveAvailableProducts();

			Map<String, List<OrderLineItem>> productsMap = new LinkedHashMap<String, List<OrderLineItem>>();
			for (Product product : products) {
				if (!productsMap.containsKey(product.getCategory())) {
					productsMap.put(product.getCategory(), new ArrayList<OrderLineItem>());
				}

				OrderLineItem lineItem = new OrderLineItem();
				lineItem.setProductId(product.getId());
				lineItem.setProductName(product.getName());
				lineItem.setPrice(product.getPrice());
				lineItem.setProductComboLineItems(product.getProductComboLineItems());
				productsMap.get(product.getCategory()).add(lineItem);
			}

			model.addAttribute("productsMap", productsMap);
			model.addAttribute("products", products);
			//model.addAttribute("deviceType", deviceType);
			
				model.addAttribute("pageView", "order/orderPage"+(device.isMobile() || device.isTablet() ? "":"_d"));
				return "common/template"+(device.isMobile() || device.isTablet() ? "":"_d");
		} catch (AException e) {

		}
	
		return null;
	}

	@PostMapping(value = "/order/cart")
	public String showConfirmOrder(Device device, @ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {

		List<OrderLineItem> selectedLineItems = new ArrayList<OrderLineItem>();
	
		
		
		for (OrderLineItem orderLineItem : order.getOrderLineItems()) {
			if (orderLineItem.getQuantity() != null && orderLineItem.getQuantity() > 0) {
				selectedLineItems.add(orderLineItem);
			}
		}
		order.setOrderLineItems(selectedLineItems);
		
		if(order.getOrderLineItems().isEmpty()){
			redirectAttributes.addFlashAttribute("cartEmpty","Please drop something to the cart");
			return "redirect:/fireworks";
		}
		
		model.addAttribute("order", order);
		model.addAttribute("pageView", "order/showConfirmOrder");

		return "common/template";
	}

	@GetMapping(value = "/order/cart")
	public String showConfirmOrderViaGet(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {

		model.addAttribute("pageView", "order/showConfirmOrder");
		return "common/template";
	}
	
	
	
	
	@PostMapping(value = "/order/addToCart")
	public String addItemsToCartViaDesktop(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
try {
		List<OrderLineItem> selectedLineItems = new ArrayList<OrderLineItem>();
		for (OrderLineItem orderLineItem : order.getOrderLineItems()) {
			if (orderLineItem.getQuantity() != null && orderLineItem.getQuantity() > 0) {
				selectedLineItems.add(orderLineItem);
			}
		}
		order.setOrderLineItems(selectedLineItems);
		List<Product> products = productService.retrieveAvailableProducts();
		Map<String, List<OrderLineItem>> productsMap = orderService.populateOrder(order, products);
		
		model.addAttribute("productsMap", productsMap);
		model.addAttribute("products", products);
		model.addAttribute("order", order);
		
		model.addAttribute("pageView", "order/orderPage_d");
}catch(Exception e) {
	e.printStackTrace();
}
		return "common/template";
	}
	
	@PostMapping("/order/back")
	public String backToShowProducts(Device device,Order order, Model model) {
		try {
			List<Product> products = productService.retrieveAvailableProducts();
			Map<String, List<OrderLineItem>> productsMap = orderService.populateOrder(order, products);
			
			model.addAttribute("productsMap", productsMap);
			model.addAttribute("products", products);
		} catch (AException e) {
			
		}
		model.addAttribute("pageView", "order/orderPage"+(device.isMobile()|| device.isTablet() ? "":"_d"));
		return "common/template"+(device.isMobile()|| device.isTablet() ? "":"_d");
	}

	

	@PostMapping(value = "/order/save")
	public String saveOrder(@Valid @ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		try {
			if(result.hasErrors()) {
				model.addAttribute("order", order);
				model.addAttribute("pageView", "order/showConfirmOrder");
				return "common/template";
			}
			order.setStatus("");
			order = orderService.addOrder(order);

		} catch (AException exception) {
			LOGGER.error(exception.getMessage(), exception);
		}
		model.addAttribute("order", order);
		redirectAttributes.addFlashAttribute("order", order);
		return "redirect:confirm";
	}

	@GetMapping(value = "/order/confirm")
	public String showConfirmationPage(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		model.addAttribute("pageView", "order/success");
		if (order.getId() != null && order.getOrderNumber() != null) {
			model.addAttribute("orderNumber", order.getOrderNumber());
		} else {
			model.addAttribute("orderNumber", "Order has been already generated.");
		}
		return "common/template";
	}

	@GetMapping("/order/trackview")
	public String showTrackOrder(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {

		model.addAttribute("pageView", "order/track");
		return "common/template";
	}

	@GetMapping("/order/track")
	public String trackOrder(@RequestParam("orderNumber") String orderNumber,
			Model model, final RedirectAttributes redirectAttributes) {
		try {
			Map<String, String> params = new HashMap<String, String>();
			params.put("orderNumber", orderNumber);

			model.addAttribute("pageView", "order/track");
			model.addAttribute("orderNumber", orderNumber);
			model.addAttribute("orders", orderService.trackOrder(params));
		} catch (AException exception) {

		}
		return "common/template";
	}
	

	@GetMapping("/order/{id}/review")
	@ResponseBody
	public List<Stock> reviewOrder(@PathVariable("id") Long id, Model model,
			final RedirectAttributes redirectAttributes) {
		List<Stock> stockList = null;
		try {
			stockList = orderService.retrieveOldAndCurrentOrder(id);
		} catch (AException e) {

			e.printStackTrace();
		}
		return stockList;
	}
	
	
	
	
	@PostMapping("/order/modifyStatus")
	public String modifyStatus(@RequestParam("orderId") String orderId, @RequestParam("event") String event, @RequestParam("orderNumber") String orderNumber,
			@RequestBody MultiValueMap<String, String> params, Model model,
			final RedirectAttributes redirectAttributes) {
		try {
			
			boolean status = orderService.modifyStatus(orderId, Event.valueOf(event));
			if(!status) {
				model.addAttribute("msg", "One or more Products are not available. Please check Stock.");
			}
			
			model.addAttribute("orders", orderService.findOrder(params));
			model.addAttribute("statusCode", params.get("statusCode") == null ? null :params.get("statusCode").get(0).toString());
			model.addAttribute("pageView", "order/track");
		    redirectAttributes.addAttribute("orderNumber", orderNumber);	
		} catch (AException exception) {
			LOGGER.error(exception.getMessage(), exception);
		}
		return "redirect:track";
	}
	
	@GetMapping("/{id}/viewCombo")
	@ResponseBody
	public List<ProductComboLineItem> viewCombo(@PathVariable("id") Long productId, Model model,
			final RedirectAttributes redirectAttributes){
		List<ProductComboLineItem> list = null;
		try {
			list = productService.retrieveComboByProductId(productId);
		} catch (AException e) {
		e.printStackTrace();	
		}
		return list;
	}
	
	
}
