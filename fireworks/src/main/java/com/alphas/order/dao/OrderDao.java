package com.alphas.order.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;

import com.alphas.common.dto.Event;
import com.alphas.common.exception.AException;
import com.alphas.order.dto.Order;

@Service
public interface OrderDao {

	public Order addOrder(Order order) throws AException;
	public Order findById(Long id);
	public Order updateOrder(Order order) throws AException;
	public List<Order> trackOrder(Map<String, String> params) throws AException;
	public List<Order> findOrder(MultiValueMap<String, String> params) throws AException;
	public Order modifyStatus(String orderId, Event event) throws AException;
	
}
