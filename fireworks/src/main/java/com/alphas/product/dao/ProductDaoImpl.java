package com.alphas.product.dao;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.persistence.EntityManager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
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
		Iterator<Product> i = repository.findAll().iterator();
		while(i.hasNext()) {
			Product p = i.next();
			p.getImage1();
			p.getImage2();
			p.getImage3();
			p.getImage4();
			p.getImage5();
			products.add(p);
		}
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
	
	public List<Product> findAllNoLazy(EntityManager entityManager) throws AException{
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
	}
	
	
	
}
