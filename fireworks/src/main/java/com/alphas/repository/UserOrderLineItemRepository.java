package com.alphas.repository;

import org.springframework.data.repository.CrudRepository;

import com.alphas.order.dto.UserOrderLineItem;

public interface UserOrderLineItemRepository extends CrudRepository<UserOrderLineItem, Long>{

}
