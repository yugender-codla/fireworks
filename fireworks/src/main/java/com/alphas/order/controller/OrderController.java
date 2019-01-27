package com.alphas.order.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

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
import com.alphas.order.dto.Order;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.order.service.OrderService;
import com.alphas.product.dto.Product;
import com.alphas.product.service.ProductService;
import static java.util.stream.Collectors.toMap;

@Controller
@RequestMapping("/order")
public class OrderController {
	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());
	
	
	@Autowired
	private ProductService productService;
	
	@Autowired
	private OrderService orderService;

	@GetMapping("/showProducts")
	public String ShowProducts(Model model) {
		try {
			Order order = new Order();
			List<OrderLineItem> orderLineItems = new ArrayList<OrderLineItem>();
			List<Product> products = productService.retrieveAvailableProducts();
			
			for(Product product: products) {
				OrderLineItem lineItem = new OrderLineItem();
				lineItem.setProductId(product.getId());
				lineItem.setProductName(product.getName());
				lineItem.setPrice(product.getPrice());
				orderLineItems.add(lineItem);
			}
			order.setOrderLineItems(orderLineItems);

			model.addAttribute("order",order);
			model.addAttribute("products",products);
		} catch (AException e) {
			
		}
		model.addAttribute("pageView","order/list");
		return "common/template";
	}
	
	
	@PostMapping(value = "/showConfirmOrder")
	public String showConfirmOrder(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		
		List<OrderLineItem> selectedLineItems = new ArrayList<OrderLineItem>();
		for (OrderLineItem orderLineItem : order.getOrderLineItems()) {
			if(orderLineItem.isChecked()) {
				selectedLineItems.add(orderLineItem);
			}
		}
		order.setOrderLineItems(selectedLineItems);
		model.addAttribute("order",order);
		model.addAttribute("pageView","order/showConfirmOrder");
		
		return "common/template";
	}
	
	
	
	@PostMapping("/backToShowProducts")
	public String backToShowProducts(Order order, Model model) {
		try {
			List<OrderLineItem> orderLineItems = new ArrayList<OrderLineItem>();
			List<Product> products = productService.retrieveAvailableProducts();
			Map<Long, OrderLineItem> orderLineItemMap = order.getOrderLineItems().stream().collect(toMap(s -> s.getProductId(), s -> s ));
			
			for(Product product: products) {
				OrderLineItem lineItem = new OrderLineItem();
				if(orderLineItemMap.containsKey(product.getId())) {
					lineItem.setChecked(true);
					lineItem.setQuantity(orderLineItemMap.get(product.getId()).getQuantity());
					lineItem.setPrice(orderLineItemMap.get(product.getId()).getPrice());
				}
				lineItem.setProductId(product.getId());
				lineItem.setProductName(product.getName());
				lineItem.setPrice(product.getPrice());
				orderLineItems.add(lineItem);
			}
			order.setOrderLineItems(orderLineItems);

			model.addAttribute("order",order);
			model.addAttribute("products",products);
		} catch (AException e) {
			
		}
		model.addAttribute("pageView","order/list");
		return "common/template";
	}
	
	@PostMapping(value = "/confirmOrder")
	public String confirmOrder(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		
		try {
			order.setStatus("");
			orderService.addOrder(order);
			
			model.addAttribute("pageView","order/confirmationPage");
			}catch(AException exception) {
				LOGGER.error(exception.getMessage(), exception);
			}
		
		return "common/template";
	}
}

