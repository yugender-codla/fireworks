package com.alphas.product.dao;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.product.dto.Product;
import com.alphas.repository.ProductRepository;

@Service
public class ProductDaoImpl implements ProductDao{
	
	@Autowired
	ProductRepository repository;
	
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
		repository.findAll().forEach(products::add);
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
	

}
