package com.alphas.product.service;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.product.dao.ProductDao;
import com.alphas.product.dto.Product;
import com.alphas.product.dto.ProductComboLineItem;

@Service
public class ProductServiceImpl implements ProductService{

	@Autowired
	private ProductDao dao;
	
	@Autowired
	private EntityManagerFactory entityManagerFactory;
	
	@Override
	public Product add(Product product) throws AException {
		return dao.add(product);
	}
	
	@Override
	public List<Product> retrieveAll() throws AException{
		return dao.retrieveAll();
	}
	
	@Override
	public Product findById(Long id) throws AException{
		return dao.findById(id);
	}
	
	@Override
	public List<Product> findByName(String name) throws AException{
		return dao.findByName(name);
	}
	
	
	@Override
	public void delete(Long id) throws AException{
		dao.delete(id);
	}
	
	
	/*@Override
	public Product findProductByIdNoLazy(Long id) throws AException{
		EntityManager entityManager = entityManagerFactory.createEntityManager();
		return dao.findProductByIdNoLazy(entityManager, id);
	}
	@Override
	public List<Product> findAllNoLazy() throws AException{
		EntityManager entityManager = entityManagerFactory.createEntityManager();
		return dao.findAllNoLazy(entityManager);
	}*/
	
	@Cacheable(value="products")
	@Override
	public List<Product> retrieveAvailableProducts() throws AException{
		
		EntityManager entityManager = entityManagerFactory.createEntityManager();
		try {
		return dao.retrieveAvailableProducts(entityManager);
		}finally {
			entityManager.close();
		}
	}
	
	@Override
	public List<ProductComboLineItem> retrieveComboByProductId(Long productId) throws AException{
		EntityManager entityManager = null;
		List<ProductComboLineItem> list = null;
		try {
		entityManager = entityManagerFactory.createEntityManager();
		list = dao.retrieveComboByProductId(entityManager, productId);
		}finally {
			entityManager.close();
		}
		return list;
	}
}
