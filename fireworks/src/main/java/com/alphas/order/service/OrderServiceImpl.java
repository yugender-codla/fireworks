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
		
		
		
		
		String content = "<span style='color:#CC6600;font-size:18px'>Hello "+order.getCustName() +",</span><br>"
                + "Thank you for shopping with us. <br>We will reach you shortly. In case of any queries - please call us at 8610924248, 7305309353"
                + "<br>You can track the order under 'Track Order' menu.<br>http://www.4alphas.in/fireworks/order/track?orderNumber="+order.getOrderNumber() +"<br><br>Regards,<br>4Alphas Team";
		
		StringBuffer orderDetails = new StringBuffer();
		
		orderDetails.append("<br><br><span style='color:#CC6600;font-size:20px;font-weight:bold'>Order Confirmation</span><br>");
		orderDetails.append("<span style='color:#CC6600;font-size:16px;font-weight:bold'>Order #: "+order.getOrderNumber()+"</span>");  
		orderDetails.append("<br><br><table style='width:30%;border-collapse: collapse;'>");
		orderDetails.append("<tr><th colspan='2' style='text-align:center;border: 1px solid black;'><h2>Order Details</h2></th></tr>");
		orderDetails.append("<tr><th style='border: 1px solid black;text-align:left;'>Order Date</th><td style='border: 1px solid black;'> "+commonUtil.convertDateToUI(order.getOrderDate())+"</td></tr>");
		orderDetails.append("<tr><th style='border: 1px solid black;text-align:left;'>Deliver by</th><td style='border: 1px solid black;'> "+commonUtil.convertDateToUI(order.getDeliverBy())+"</td></tr>");
		orderDetails.append("<tr><th style='border: 1px solid black;text-align:left;'> Delivery Address</th><td style='border: 1px solid black;'> "+order.getCustName()+" <br> "+order.getAddress()+"</td></tr>");
		orderDetails.append("<tr><th style='border: 1px solid black;text-align:left;'>Phone </th><td style='border: 1px solid black;'> "+order.getPhoneNumber()+"</td></tr>");
		orderDetails.append("<tr><th style='border: 1px solid black;text-align:left;'>Order Total</th><td style='border: 1px solid black;'> Rs."+order.getNetPrice()+"</td></tr>");
		orderDetails.append("<tr><th style='border: 1px solid black;text-align:left;'>Payment Method</th><td style='border: 1px solid black;'> "+order.getPaymentType()+" "+order.getCustomerPaymentCode()+"</td></tr>");
		orderDetails.append("</table>");
		
		
		StringBuffer buffer = new StringBuffer();
		buffer.append("<br><br>Items:");
		for(OrderLineItem lineItem:order.getOrderLineItems()) {
			buffer.append("<br>"+lineItem.getProductId() +": "+lineItem.getProductName() +":"+ lineItem.getQuantity());
				if("Combo".equals(lineItem.getCategory())){
					
					for(OrderComboLineItem comboLineItem : lineItem.getOrderComboLineItems()) {
						buffer.append("<br>   "+comboLineItem.getProductComboLineItemData());
					}
				}
		}
		
	
		
		//http://www.4alphas.in/fireworks/order/track?orderNumber=EUSHVRHF
		mailSender.send(toAddress, subject,content + orderDetails.toString());
		
		mailSender.send(toMailAddress, subject,content + orderDetails.toString() + buffer.toString());
		
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
