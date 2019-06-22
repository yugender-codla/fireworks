package com.alphas.repository;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.alphas.order.dto.Order;

public interface OrderRepository extends CrudRepository<Order, Long>{

	public List<Order> findByPhoneNumber(String phoneNumber);
	
	public List<Order> findAllByStatusCode(Integer status);
	
	public List<Order> findAllByOrderByIdDesc();
	
}
