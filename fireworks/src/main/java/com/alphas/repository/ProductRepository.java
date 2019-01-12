package com.alphas.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.alphas.product.dto.Product;

@Repository
public interface ProductRepository extends CrudRepository<Product, Long>{
	
	public Iterable<Product> findByName(String name);

}
