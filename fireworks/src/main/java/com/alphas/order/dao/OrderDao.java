package com.alphas.order.dao;

import javax.persistence.EntityManager;

import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.order.dto.Order;

@Service
public interface OrderDao {

	public Order addOrder(Order order, EntityManager entityManager) throws AException;
	public Order findById(Long id);
	public Order updateOrder(Order order) throws AException;
	
	
	
	
}
