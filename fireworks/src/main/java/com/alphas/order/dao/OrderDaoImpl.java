package com.alphas.order.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.transaction.Transactional;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.MultiValueMap;

import com.alphas.common.dao.StateMapDao;
import com.alphas.common.dto.Event;
import com.alphas.common.dto.States;
import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Stock;
import com.alphas.order.dto.Order;
import com.alphas.order.dto.OrderComboLineItem;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.order.dto.UserOrderLineItem;
import com.alphas.product.dao.ProductDao;
import com.alphas.product.dto.Product;
import com.alphas.repository.OrderInlineRepository;
import com.alphas.repository.OrderRepository;
import com.alphas.repository.UserOrderLineItemRepository;

@Service
public class OrderDaoImpl implements OrderDao{

	@Autowired
	private OrderRepository repository;
	
	@Autowired
	private OrderInlineRepository lineItemRepository;
	
	@Autowired
	private UserOrderLineItemRepository userOrderLineItemRepository;
	
	@Autowired
	private ProductDao productDao;
	
	@Autowired
	private StateMapDao stateMapDao;
	
	@Override
	@Transactional
	public Order addOrder(Order order) throws AException {
		
		try {
		long initTime = System.currentTimeMillis();
		for(OrderLineItem item: order.getOrderLineItems()) {
			item.setOrder(order);
			if("Combo".equals(item.getCategory())) {
				for(OrderComboLineItem comboLineItem : item.getOrderComboLineItems()) {
					comboLineItem.setProductComboLineItemId((Long.valueOf(comboLineItem.getProductComboLineItemData().split("\\|")[0].trim())));
					comboLineItem.setQuantity((Long.valueOf(comboLineItem.getProductComboLineItemData().split("\\|")[2].trim())));
					comboLineItem.setOrderLineItem(item);
				}
			}
			
		}	

		
		stateMapDao.moveState(order, Event.SUBMIT_ORDER, 100);
		
		order = repository.save(order);
		List<UserOrderLineItem> orderLineItems = this.addUserOrder(order);
		//System.out.println("Order main Time:=======: "+(System.currentTimeMillis()-initTime)+" milliseconds");
		userOrderLineItemRepository.saveAll(orderLineItems);
		
		long endTime = System.currentTimeMillis();
		//System.out.println("Total Time:=======: "+(endTime-initTime)+" milliseconds");
		}catch(Exception exception) {
			throw new AException(exception);
		}
		return order;
	}


	
	private List<UserOrderLineItem> addUserOrder(Order order) throws AException {
		List<UserOrderLineItem> list = new ArrayList<UserOrderLineItem>();
		try {
		for(OrderLineItem item: order.getOrderLineItems()) {
			UserOrderLineItem userOrder = new UserOrderLineItem(); 
			BeanUtils.copyProperties(item, userOrder);
			userOrder.setId(null);
			userOrder.setOrderId(order.getId());
			
			list.add(userOrder);
		}	
		
		}catch(Exception exception) {
			throw new AException(exception);
		}		
		return list;
	}

	
	
	@Override
	@Transactional
	public Order updateOrder(Order order) throws AException {
		
		for(OrderLineItem item: order.getOrderLineItems()) {
			item.setOrder(order);
		}	
		
		if(order.getId() != null) {
			
			Order oldOrderDetails = repository.findById(order.getId()).orElse(null);
			lineItemRepository.deleteAll(oldOrderDetails.getOrderLineItems());
		}
		
		stateMapDao.moveState(order, Event.MODIFY_ORDER, order.getStatusCode());
		order = repository.save(order);
		return order;
	}

	
	public Order findById(Long id) {
		return repository.findById(id).orElse(new Order());
	}
	
	
	/**
	 * Method is limited to searching by phone number now.. 
	 * @param params
	 * @return
	 */
	public List<Order> trackOrder(Map<String, String> params) throws AException{
		
		List<Order> list = new ArrayList<Order>();
		try {
		if(params.get("orderNumber") == null) { 
			return list;
		}
		
		Map<Long, Product> productsMap = productDao.retrieveAllProductsMap();
		list = repository.findByOrderNumber(params.get("orderNumber").toString());
		
		
		for (Order order : list) {
			List<OrderLineItem> items = order.getOrderLineItems();
			for (OrderLineItem orderLineItem : items) {
				orderLineItem.setProductName(productsMap.get(orderLineItem.getProductId()) == null ? null : productsMap.get(orderLineItem.getProductId()).getName());
			}
		}
		
		}catch(Exception exception) {
			throw new AException(exception);
		}
		return list;
	} 
	
	@Override
	public List<Order> findOrder(MultiValueMap<String, String> params) {
		List<Order> list = new ArrayList<Order>();

		if (params.get("searchCriteria") == null || params.get("searchValue").get(0).toString().equals("0")) {
			list = repository.findAllByOrderByIdDesc();
		} else if ("orderStatus".equals(params.get("searchCriteria").get(0).toString())) {
			list = repository.findAllByStatusCode(Integer.valueOf(params.get("searchValue").get(0)));
		} else if ("phoneNumber".equals(params.get("searchCriteria").get(0).toString())) {
			list = repository.findByPhoneNumber(params.get("searchValue").get(0).toString());
		} else if ("orderNumber".equals(params.get("searchCriteria").get(0).toString())) {
			list = repository.findByOrderNumber(params.get("searchValue").get(0).toString());
		} else if ("email".equals(params.get("searchCriteria").get(0).toString())) {
			list = repository.findByEmail(params.get("searchValue").get(0).toString());
		}else if ("orderId".equals(params.get("searchCriteria").get(0).toString())) {
			list.add(repository.findById(Long.valueOf(params.get("searchValue").get(0))).orElse(new Order()));
		}else {
			list = repository.findAllByOrderByIdDesc();
		}
		return list;
	}
	
	
	public boolean modifyStatus(String orderId, Event event, EntityManager entityManager) throws AException{
		Order order = repository.findById(Long.valueOf(orderId)).orElse(null);
		int toStatusCode = stateMapDao.moveState(event, order.getStatusCode());
		
		if(Integer.valueOf(States.ADMIN_COMPLETE_PACKING.getStateId()).equals(toStatusCode)) {
			if(!checkAvailability(entityManager, Long.valueOf(orderId))) {
				return false;
			}
		}
		stateMapDao.moveState(order, event, order.getStatusCode());
		repository.save(order);
		return true;
	}
	
	
	private boolean checkAvailability(EntityManager em, Long orderId) {
		List<Stock> stockList = this.getStockListForAnOrder(em, orderId);
		
		for (Stock stock : stockList) {
			if(stock.getQty1() > stock.getQty2()) {
				return false;
			}
		}
		return true;
	}
	
	public List<Stock> getStockListForAnOrder(EntityManager em, Long orderId) {
		String queryString = "select product_id,quantity, round(t.available,0),t.name  from order_line_item oli left outer join  " + 
				"(select total.id,total.name, total.totalInvoiceQty, " + 
				"case when used.usedQty is null then 0 else used.usedQty end usedQty,   " + 
				"(case when total.totalinvoiceQty is null then 0 else total.totalinvoiceQty end - case when used.usedQty is null then 0 else used.usedQty end) as available " + 
				"from  " + 
				"(select p.id,p.name,case when sum(ili.quantity) is null then 0 else sum(ili.quantity) end as totalInvoiceQty from product p  " + 
				"left outer join invoice_line_item ili on p.id = ili.product_id  " + 
				"group by p.id,p.name) total  " + 
				"left outer join  " + 
				"( " + 
				"select oli.product_id, case when sum(quantity) is null then 0 else sum(quantity) end as usedQty from order_line_item oli  " + 
				"join order_main m on m.id = oli.order_id  " + 
				"where m.status_code in(105,102) group by oli.product_id  " + 
				") used on used.product_id = total.id " + 
				") t on t.id = product_id  " + 
				"where order_id = :orderid";
		
		Query query = em.createNativeQuery(queryString);
		query.setParameter("orderid", orderId);
		List<Object[]> objList = query.getResultList();
        List<Stock> ooBj = objList.stream().map(Stock::new).collect(Collectors.toList());
		return ooBj;
	}
	
	/**
	 * Method does full outer join on 2 tables. 
	 * 
	 * @param em
	 * @param orderId
	 * @return
	 */
	public List<Stock> retrieveOldAndCurrentOrder(EntityManager em, Long orderId) throws AException{
		
		List<Stock> ooBj = null;
		String queryString ="select p.id as productName, oli.quantity, uoli.quantity mQty,p.name " + 
				"from  order_line_item oli " + 
				"LEFT JOIN user_order_line_item uoli on oli.order_id = uoli.order_id and oli.product_id = uoli.product_id " + 
				"join order_main m on m.id = oli.order_id " + 
				"join product p on p.id = oli.product_id " + 
				"where m.id = :orderId " + 
				" union " + 
				"select p.id as productName, oli.quantity, uoli.quantity mQty,p.name " + 
				"from  order_line_item oli " + 
				"RIGHT JOIN user_order_line_item uoli on oli.order_id = uoli.order_id and oli.product_id = uoli.product_id " + 
				"join order_main m on m.id = uoli.order_id " + 
				"join product p on p.id = uoli.product_id " + 
				"where m.id = :orderId";
		try {
			Query query = em.createNativeQuery(queryString);
			query.setParameter("orderId", orderId);
			List<Object[]> objList = query.getResultList();
			ooBj = objList.stream().map(Stock::new).collect(Collectors.toList());
		}catch(Exception exception) {
			throw new AException(exception);
		}
		return ooBj;
	}
}
	
	
