package com.alphas.order.service;

import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;

import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;

import com.alphas.common.dto.Event;
import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Stock;
import com.alphas.order.dto.Order;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.order.dto.UserInfo;
import com.alphas.product.dto.Product;

@Service
public interface OrderService {
	public Order addOrder(Order order) throws AException;
	public Order findById(Long id);
	public Order updateOrder(Order order) throws AException;
	public List<Order> trackOrder(Map<String, String> params) throws AException;
	public List<Order> findOrder(MultiValueMap<String, String> params) throws AException;
	public boolean modifyStatus(String orderId, Event event) throws AException;
	public List<Stock> getStockListForAnOrder(Long orderId) throws AException;
	public Map<String, List<OrderLineItem>> populateOrder(Order order, List<Product> products) throws AException;
	public List<Stock> retrieveOldAndCurrentOrder(Long orderId) throws AException;
	public void persistFootPrint(List<UserInfo> userInfos) throws AException;
	public List<UserInfo> showFootPrints() throws AException;
}
