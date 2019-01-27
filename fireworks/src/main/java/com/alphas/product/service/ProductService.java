package com.alphas.product.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.product.dto.Product;

@Service
public interface ProductService {
	
	public Product add(Product product) throws AException;
	public List<Product> retrieveAll() throws AException;
	public Product findById(Long id) throws AException;
	public List<Product> findByName(String name) throws AException;
	/*public Product findProductByIdNoLazy(Long id) throws AException;
	public List<Product> findAllNoLazy() throws AException;*/
	public void delete(Long id) throws AException;
	
	public List<Product> retrieveAvailableProducts() throws AException;
}
