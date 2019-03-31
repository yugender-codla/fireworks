package com.alphas.order.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.transaction.Transactional;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.order.dto.Order;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.order.dto.UserOrderLineItem;
import com.alphas.product.dao.ProductDao;
import com.alphas.product.dto.Product;
import com.alphas.repository.OrderInlineRepository;
import com.alphas.repository.OrderRepository;
import com.alphas.repository.UserOrderLineItemRepository;

@Service
public class OrderDaoImpl implements OrderDao{

	@Autowired
	private OrderRepository repository;
	
	@Autowired
	private OrderInlineRepository lineItemRepository;
	
	@Autowired
	private UserOrderLineItemRepository userOrderLineItemRepository;
	
	@Autowired
	private ProductDao productDao;
	
	@Override
	@Transactional
	public Order addOrder(Order order) throws AException {
		
		try {
		long initTime = System.currentTimeMillis();
		for(OrderLineItem item: order.getOrderLineItems()) {
			item.setOrder(order);
		}	

		List<UserOrderLineItem> orderLineItems = this.addUserOrder(order);
		order = repository.save(order);
		System.out.println("Order main Time:=======: "+(System.currentTimeMillis()-initTime)+" milliseconds");
		userOrderLineItemRepository.saveAll(orderLineItems);
		
		long endTime = System.currentTimeMillis();
		System.out.println("Total Time:=======: "+(endTime-initTime)+" milliseconds");
		}catch(Exception exception) {
			throw new AException(exception);
		}
		return order;
	}


	
	private List<UserOrderLineItem> addUserOrder(Order order) throws AException {
		List<UserOrderLineItem> list = new ArrayList<UserOrderLineItem>();
		try {
		for(OrderLineItem item: order.getOrderLineItems()) {
			UserOrderLineItem userOrder = new UserOrderLineItem(); 
			BeanUtils.copyProperties(item, userOrder);
			userOrder.setId(null);
			userOrder.setOrderId(order.getId());
			list.add(userOrder);
		}	
		
		}catch(Exception exception) {
			throw new AException(exception);
		}		
		return list;
	}

	
	
	@Override
	@Transactional
	public Order updateOrder(Order order) throws AException {
		
		for(OrderLineItem item: order.getOrderLineItems()) {
			item.setOrder(order);
		}	
		
		if(order.getId() != null) {
			
			Order oldOrderDetails = repository.findById(order.getId()).orElse(null);
			lineItemRepository.deleteAll(oldOrderDetails.getOrderLineItems());
		}
		order = repository.save(order);
		return order;
	}

	
	public Order findById(Long id) {
		return repository.findById(id).orElse(new Order());
	}
	
	
	/**
	 * Method is limited to searching by phone number now.. 
	 * @param params
	 * @return
	 */
	public List<Order> trackOrder(Map<String, String> params) throws AException{
		
		List<Order> list = new ArrayList<Order>();
		try {
		if(params.get("phoneNumber") == null) {
			return list;
		}
		
		Map<Long, Product> productsMap = productDao.retrieveAllProductsMap();
		
		list = repository.findByPhoneNumber(params.get("phoneNumber").toString());
		
		for (Order order : list) {
			List<OrderLineItem> items = order.getOrderLineItems();
			for (OrderLineItem orderLineItem : items) {
				orderLineItem.setProductName(productsMap.get(orderLineItem.getProductId()) == null ? null : productsMap.get(orderLineItem.getProductId()).getName());
			}
		}
		
		}catch(Exception exception) {
			throw new AException(exception);
		}
		return list;
	} 
}
