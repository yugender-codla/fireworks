package com.alphas.repository;

import org.springframework.data.repository.CrudRepository;

import com.alphas.order.dto.Order;

public interface OrderRepository extends CrudRepository<Order, Long>{

}
