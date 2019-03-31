package com.alphas.product.dao;

import static java.util.stream.Collectors.toMap;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.persistence.EntityManager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.order.dto.OrderLineItem;
import com.alphas.product.dto.Product;
import com.alphas.repository.ProductRepository;

@Service
public class ProductDaoImpl implements ProductDao{
	
	@Autowired
	private ProductRepository repository;
	
	@Override
	public Product add(Product product) throws AException {
		Product result = null;
		
			try {
				result = repository.save(product);
			}catch(org.springframework.dao.DataIntegrityViolationException e) {
				throw new AException("The product with name: "+product.getName()+" already exists!");
			}catch(Exception e) {
				throw new AException(e);
			} 
		return result;
	}
	
	@Override
	public List<Product> retrieveAll() throws AException{
		List<Product> products = new ArrayList<Product>();
		repository.findAll().forEach(products::add);;
		return products;
	}
	
	@Override
	public Product findById(Long id) throws AException{
		return repository.findById(id).orElse(null);
	}
	
	@Override
	public List<Product> findByName(String name) throws AException{
		List<Product> products = new ArrayList<Product>();
		repository.findByName(name).forEach(products::add);
		return products;
	}
	
	@Override
	public void delete(Long id) throws AException{
		Product product = this.findById(id);
		product.setActive("N");
		this.add(product);
	}
	
	@Override
	public List<Product> retrieveAvailableProducts(EntityManager entityManager) throws AException{
		List<Product> result = new ArrayList<Product>();
		try {
			result = entityManager.createNamedQuery("findAvailableProducts").getResultList();
		}catch(Exception e) {
			throw new AException(e);
		}
		return result ;
	}
	
	@Override
	public Map<Long, Product> retrieveAllProductsMap() throws AException{
		List<Product> products = this.retrieveAll();
		Map<Long, Product> productMap = new HashMap<Long, Product>();
		productMap = products.stream().collect(toMap(s -> s.getId(), s-> s));
		return productMap;
	}
	
	
	/*public List<Product> findAllNoLazy(EntityManager entityManager) throws AException{
		List<Product> result = new ArrayList<Product>();
		try {
			result = entityManager.createNamedQuery("findProducts").getResultList();
			
		
		}catch(Exception e) {
			throw new AException(e);
		}
		return result ;
	}
	
	public Product findProductByIdNoLazy(EntityManager entityManager, Long id) throws AException{
		try {
		List result = entityManager.createNamedQuery("findProductById").setParameter("id", id).getResultList();
		if(result != null & !result.isEmpty()) {
			return (Product)result.get(0);
		}
		}catch(Exception e) {
			throw new AException(e);
		}
		return null;
	}*/
	
	
	
}
