package com.alphas.order.dao;

import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;

import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.order.dto.Order;

@Service
public interface OrderDao {

	public Order addOrder(Order order) throws AException;
	public Order findById(Long id);
	public Order updateOrder(Order order) throws AException;
	public List<Order> trackOrder(Map<String, String> params) throws AException;
	
	
	
}
