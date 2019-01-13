package com.alphas.product.dao;

import java.util.List;

import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.product.dto.Product;

@Service
public interface ProductDao {
	public Product add(Product product) throws AException;
	public List<Product> retrieveAll() throws AException;
	public Product findById(Long id) throws AException;
	public List<Product> findByName(String name) throws AException;
}
