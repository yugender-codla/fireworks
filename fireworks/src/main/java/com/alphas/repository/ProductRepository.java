package com.alphas.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.alphas.product.dto.Product;

@Repository
public interface ProductRepository extends JpaRepository<Product, Long>{
	
	public Iterable<Product> findByName(String name);

}
