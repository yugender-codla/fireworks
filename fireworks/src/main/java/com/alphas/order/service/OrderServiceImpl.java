package com.alphas.order.service;

import java.util.List;
import java.util.Map;

import javax.persistence.EntityManagerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.order.dao.OrderDao;
import com.alphas.order.dto.Order;

@Service
public class OrderServiceImpl implements OrderService{

	@Autowired
	private OrderDao dao;
	
	@Autowired
	private EntityManagerFactory entityManagerFactory;
	
	@Override
	public Order addOrder(Order order) throws AException {
		//EntityManager entityManager = null;
		try {
			//entityManager = entityManagerFactory.createEntityManager();
			order = dao.addOrder(order);
		}catch(Exception exception) {
			throw new AException(exception);
		}finally {
			
		}
		return order;
	}

	@Override
	public Order findById(Long id) {
		return dao.findById(id);
	}

	
	@Override
	public Order updateOrder(Order order) throws AException {
		try {
			order = dao.updateOrder(order);
		}catch(Exception exception) {
			throw new AException(exception);
		}
		return order;
	}
	
	@Override
	public List<Order> trackOrder(Map<String, String> params) throws AException{
		return dao.trackOrder(params);
	}

}
