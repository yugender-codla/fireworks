package com.alphas.product.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.product.dto.Product;
import com.alphas.repository.ProductRepository;

@Service
public class ProductServiceImpl implements ProductService{

	@Autowired
	ProductRepository repository;
	
	@Override
	public Product add(Product product) throws AException {
		Product result = null;
		result = repository.save(product);
		
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
