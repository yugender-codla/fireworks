package com.alphas.order.service;

import static java.util.stream.Collectors.toMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;

import com.alphas.common.dto.Event;
import com.alphas.common.exception.AException;
import com.alphas.common.util.CommonUtil;
import com.alphas.inventory.dto.Stock;
import com.alphas.mail.SendMail;
import com.alphas.order.dao.OrderDao;
import com.alphas.order.dto.Order;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.product.dto.Product;

@Service
public class OrderServiceImpl implements OrderService{

	private final Logger LOGGER = LoggerFactory.getLogger(this.getClass());
	
	@Autowired
	private OrderDao dao;
	
	@Autowired
	private EntityManagerFactory entityManagerFactory;
	
	@Autowired
	CommonUtil commonUtil;
	
	@Autowired
	SendMail mailSender;
	
	@Override
	public Order addOrder(Order order) throws AException {
		//EntityManager entityManager = null;
		try {
			if(order.getId() == null) {
				order.setOrderNumber(commonUtil.generateRandomString());
				order = dao.addOrder(order);
			}else {
				order = this.updateOrder(order);
			}
			
						
			this.sendMail(order);
			
			
		}catch(Exception exception) {
			throw new AException(exception);
		}finally {
			
		}
		return order;
	}

	@Override
	public Order findById(Long id) {
		return dao.findById(id);
	}

	
	@Override
	public Order updateOrder(Order order) throws AException {
		try {
			order.setModifiedFlag("Y");
			order = dao.updateOrder(order);
		}catch(Exception exception) {
			throw new AException(exception);
		}
		return order;
	}
	
	@Override
	public List<Order> trackOrder(Map<String, String> params) throws AException{
		return dao.trackOrder(params);
	}

	@Override
	public List<Order> findOrder(MultiValueMap<String, String> params) throws AException{
		return dao.findOrder(params);
	}
	
	@Override
	public boolean modifyStatus(String orderId, Event event) throws AException{
		EntityManager entityManager = null;
				try {
					entityManager = entityManagerFactory.createEntityManager();
					return dao.modifyStatus(orderId, event, entityManager);
				}finally {
					entityManager.close();
				}
		
	}
	
	@Override
	public List<Stock> getStockListForAnOrder(Long orderId) throws AException{
		EntityManager entityManager = null;
		List<Stock> stockList = null;
		try {
			entityManager = entityManagerFactory.createEntityManager();
			stockList = dao.getStockListForAnOrder(entityManager, orderId);
		}finally {
			entityManager.close();
		}
		return stockList;
	}
	
	@Override
	public Map<String, List<OrderLineItem>> populateOrder(Order order, List<Product> products) throws AException {
		Map<String, List<OrderLineItem>> productsMap = new LinkedHashMap<String, List<OrderLineItem>>();
		Map<Long, OrderLineItem> orderLineItemMap = new LinkedHashMap<Long, OrderLineItem>();

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

		return productsMap;
	}
	
	
	private void sendMail(Order order) {
		
		LOGGER.info("Mail is being sent."+order.getOrderNumber());
		
		String subject = "4Alphas - Fireworks - Order Number: "+order.getOrderNumber();
		String toAddress = order.getEmail();
		String content = "Dear Sir/Madam,"
                + "\n\nThank you for shopping with us. Your Order Number is: "+order.getOrderNumber()+". \nWe will reach you shortly. In case of any queries - please call us at 9841008735"
                + "\nYou can track the order under 'Track Order' menu.\nhttp://www.4alphas.in/fireworks/order/track?orderNumber="+order.getOrderNumber() +"\n\nRegards,\n4Alphas Team";
		
		//http://www.4alphas.in/fireworks/order/track?orderNumber=EUSHVRHF
		mailSender.send(toAddress, subject,content);
		
		LOGGER.info("Mail sent."+order.getOrderNumber());
	}
	
	@Override
	public List<Stock> retrieveOldAndCurrentOrder(Long orderId) throws AException{
		EntityManager entityManager = null;
		List<Stock> stockList = null;
		try {
			entityManager = entityManagerFactory.createEntityManager();
			stockList = dao.retrieveOldAndCurrentOrder(entityManager, orderId);
		}finally {
			entityManager.close();
		}
		return stockList;
	
	}
}
