package com.alphas.order.controller;

import static java.util.stream.Collectors.toMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.MultiValueMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.alphas.common.dto.Event;
import com.alphas.common.exception.AException;
import com.alphas.order.dto.Order;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.order.service.OrderService;
import com.alphas.product.dto.Product;
import com.alphas.product.service.ProductService;

@Controller
@RequestMapping("/fireworks")
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
	}

	@GetMapping("")
	public String ShowProductsMap(Model model) {
		try {

			List<Product> products = productService.retrieveAvailableProducts();

			Map<String, List<OrderLineItem>> productsMap = new HashMap<String, List<OrderLineItem>>();
			for (Product product : products) {
				if (!productsMap.containsKey(product.getCategory())) {
					productsMap.put(product.getCategory(), new ArrayList<OrderLineItem>());
				}

				OrderLineItem lineItem = new OrderLineItem();
				lineItem.setProductId(product.getId());
				lineItem.setProductName(product.getName());
				lineItem.setPrice(product.getPrice());
				productsMap.get(product.getCategory()).add(lineItem);
			}

			model.addAttribute("productsMap", productsMap);
			model.addAttribute("products", products);
		} catch (AException e) {

		}
		model.addAttribute("pageView", "order/orderPage");
		return "common/template";
	}

	@PostMapping(value = "/showConfirmOrder")
	public String showConfirmOrder(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {

		List<OrderLineItem> selectedLineItems = new ArrayList<OrderLineItem>();
		for (OrderLineItem orderLineItem : order.getOrderLineItems()) {
			if (orderLineItem.getQuantity() != null && orderLineItem.getQuantity() > 0) {
				selectedLineItems.add(orderLineItem);
			}
		}
		order.setOrderLineItems(selectedLineItems);
		model.addAttribute("order", order);
		model.addAttribute("pageView", "order/showConfirmOrder");

		return "common/template";
	}

	@PostMapping("/backToShowProducts")
	public String backToShowProducts(Order order, Model model) {
		try {
			List<Product> products = productService.retrieveAvailableProducts();
			Map<String, List<OrderLineItem>> productsMap = new HashMap<String, List<OrderLineItem>>();
			Map<Long, OrderLineItem> orderLineItemMap = new HashMap<Long, OrderLineItem>();

			if (order.getOrderLineItems() != null) {
				orderLineItemMap = order.getOrderLineItems().stream().collect(toMap(s -> s.getProductId(), s -> s));
			}

			for (Product product : products) {
				OrderLineItem lineItem = new OrderLineItem();
				if (!productsMap.containsKey(product.getCategory())) {
					productsMap.put(product.getCategory(), new ArrayList<OrderLineItem>());
				}

				if (orderLineItemMap.containsKey(product.getId())) {
					lineItem.setChecked(true);
					lineItem.setQuantity(orderLineItemMap.get(product.getId()).getQuantity());
					lineItem.setPrice(orderLineItemMap.get(product.getId()).getPrice());
				}
				lineItem.setProductId(product.getId());
				lineItem.setProductName(product.getName());
				lineItem.setPrice(product.getPrice());
				// orderLineItems.add(lineItem);
				productsMap.get(product.getCategory()).add(lineItem);
			}
			// order.setOrderLineItems(orderLineItems);

			model.addAttribute("productsMap", productsMap);
			model.addAttribute("products", products);

		} catch (AException e) {

		}
		model.addAttribute("pageView", "order/orderPage");
		return "common/template";
	}

	@PostMapping(value = "/confirmOrder")
	public String confirmOrder(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {

		try {
			order.setStatus("");
			order = orderService.addOrder(order);

		} catch (AException exception) {
			LOGGER.error(exception.getMessage(), exception);
		}
		model.addAttribute("order", order);
		redirectAttributes.addFlashAttribute("order", order);
		return "redirect:showConfirmationPage";
	}

	@GetMapping(value = "/showConfirmationPage")
	public String showConfirmationPage(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		model.addAttribute("pageView", "order/confirmationPage");
		if (order.getId() != null) {
			model.addAttribute("orderNumber", order.getId());
		} else {
			model.addAttribute("orderNumber", "Order has been already generated.");
		}
		return "common/template";
	}

	@GetMapping("/showTrack")
	public String showTrackOrder(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {

		model.addAttribute("pageView", "order/track");
		return "common/template";
	}

	@PostMapping("/track")
	public String trackOrder(@ModelAttribute("order") Order order, BindingResult result, Model model,
			final RedirectAttributes redirectAttributes) {
		try {
			Map<String, String> params = new HashMap<String, String>();
			params.put("phoneNumber", order.getPhoneNumber());

			model.addAttribute("pageView", "order/track");
			model.addAttribute("phoneNumber", order.getPhoneNumber());
			model.addAttribute("orders", orderService.trackOrder(params));
		} catch (AException exception) {

		}
		return "common/template";
	}

	@PostMapping("/findOrders")
	public String findOrders(@RequestBody MultiValueMap<String, String> params, Model model,
			final RedirectAttributes redirectAttributes) {
		try {
			
			model.addAttribute("pageView", "order/searchOrders");
			model.addAttribute("orders", orderService.findOrder(params));
			model.addAttribute("statusCode", params.get("statusCode").get(0).toString());
			
		} catch (AException exception) {

		}
		return "common/template";
	}

	@GetMapping("/showSearchOrder")
	public String showSearchOrder(Model model,
			final RedirectAttributes redirectAttributes) {
		model.addAttribute("pageView", "order/searchOrders");
		return "common/template";
	}
	
	
	@PostMapping("/modifyStatus")
	public String modifyStatus(@RequestParam("orderId") String orderId, @RequestParam("event") String event,@RequestBody MultiValueMap<String, String> params, Model model,
			final RedirectAttributes redirectAttributes)
	{
		try {
		orderService.modifyStatus(orderId, Event.valueOf(event));
		model.addAttribute("orders", orderService.findOrder(params));
		model.addAttribute("statusCode", params.get("statusCode").get(0).toString());
		model.addAttribute("pageView", "order/searchOrders");
		} catch (AException exception) {

		}
		return "common/template";
	}
	
	
	
}
