package com.alphas.order.dao;

import javax.persistence.EntityManager;
import javax.transaction.Transactional;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.order.dto.Order;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.order.dto.UserOrderLineItem;
import com.alphas.repository.OrderInlineRepository;
import com.alphas.repository.OrderRepository;

@Service
public class OrderDaoImpl implements OrderDao{

	@Autowired
	private OrderRepository repository;
	
	@Autowired
	private OrderInlineRepository lineItemRepository;
	
	
	@Override
	@Transactional
	public Order addOrder(Order order, EntityManager entityManager) throws AException {
		
		try {
		
		for(OrderLineItem item: order.getOrderLineItems()) {
			item.setOrder(order);
		}	

		order = repository.save(order);
		this.addUserOrder(order, entityManager);
		
		}catch(Exception exception) {
			throw new AException(exception);
		}
		return order;
	}


	
	private boolean addUserOrder(Order order, EntityManager entityManager) throws AException {
		try {
			entityManager.getTransaction().begin();
		for(OrderLineItem item: order.getOrderLineItems()) {
			UserOrderLineItem userOrder = new UserOrderLineItem(); 
			BeanUtils.copyProperties(item, userOrder);
			userOrder.setId(null);
			userOrder.setOrderId(order.getId());
			entityManager.persist(userOrder);
		}	

		}catch(Exception exception) {
			throw new AException(exception);
		}finally {
			entityManager.getTransaction().commit();
		}
		return true;
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
	
	
}
