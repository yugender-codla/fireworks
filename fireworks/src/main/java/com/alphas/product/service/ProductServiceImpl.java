package com.alphas.product.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.product.dao.ProductDao;
import com.alphas.product.dto.Product;

@Service
public class ProductServiceImpl implements ProductService{

	@Autowired
	private ProductDao dao;
	
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
	
}
