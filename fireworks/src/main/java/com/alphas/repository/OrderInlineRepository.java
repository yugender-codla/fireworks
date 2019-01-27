package com.alphas.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.alphas.inventory.dto.Invoice;
import com.alphas.order.dto.OrderLineItem;

@Repository
public interface OrderInlineRepository extends CrudRepository<OrderLineItem, Long>{

}
