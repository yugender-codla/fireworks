package com.alphas.order.service;

import static java.util.stream.Collectors.toMap;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;

import com.alphas.common.dto.Event;
import com.alphas.common.exception.AException;
import com.alphas.common.util.CommonUtil;
import com.alphas.inventory.dto.Stock;
import com.alphas.mail.SendMail;
import com.alphas.order.dao.OrderDao;
import com.alphas.order.dto.Order;
import com.alphas.order.dto.OrderComboLineItem;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.product.dto.Product;
import com.alphas.product.dto.ProductComboLineItem;

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
	
	@Value("${toMailAddress}")
	private String toMailAddress;
	
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
				lineItem.setOrderComboLineItems(orderLineItemMap.get(product.getId()).getOrderComboLineItems());
				
				
				for(int i=0;i<product.getProductComboLineItems().size();i++) {
					if(product.getProductComboLineItems() != null && product.getProductComboLineItems().get(i) != null && lineItem.getOrderComboLineItems() != null &&
							lineItem.getOrderComboLineItems().get(i) != null) {
					product.getProductComboLineItems().get(i).setPidCheckedData(lineItem.getOrderComboLineItems().get(i).getProductComboLineItemData());
					}
				}
		
			}
			lineItem.setProductId(product.getId());
			lineItem.setProductName(product.getName());
			lineItem.setPrice(product.getPrice());
			// orderLineItems.add(lineItem);

			lineItem.setProductComboLineItems(product.getProductComboLineItems());
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
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("\n\nItems:");
		for(OrderLineItem lineItem:order.getOrderLineItems()) {
			buffer.append("\n"+lineItem.getProductId() +": "+lineItem.getProductName() +":"+ lineItem.getQuantity());
				if("Combo".equals(lineItem.getCategory())){
					
					for(OrderComboLineItem comboLineItem : lineItem.getOrderComboLineItems()) {
						buffer.append("\n   "+comboLineItem.getProductComboLineItemData());
					}
				}
		}
		
		StringBuffer mailingAddress = new StringBuffer();
		mailingAddress.append("\n\nTo:");
		mailingAddress.append("\n"+order.getCustName());
		mailingAddress.append("\n"+order.getPhoneNumber());
		mailingAddress.append("\n"+order.getAddress());
		mailingAddress.append("\nPayment Type: "+order.getPaymentType());
		
		
		//http://www.4alphas.in/fireworks/order/track?orderNumber=EUSHVRHF
		mailSender.send(toAddress, subject,content);
		
		mailSender.send(toMailAddress, subject,content + buffer.toString() + mailingAddress.toString());
		
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
