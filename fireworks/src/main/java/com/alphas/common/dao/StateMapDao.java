package com.alphas.common.dao;

import org.springframework.stereotype.Service;

import com.alphas.common.dto.Event;
import com.alphas.order.dto.Order;

@Service
public interface StateMapDao {
	public Order moveState(Order order,Event event, int fromState);
	public int moveState(Event event, int fromState);
}
