package com.alphas.order.service;

import javax.persistence.EntityManager;

import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.order.dto.Order;

@Service
public interface OrderService {
	public Order addOrder(Order order) throws AException;
	public Order findById(Long id);
	public Order updateOrder(Order order) throws AException;
}
