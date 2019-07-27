package com.alphas.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.alphas.product.dto.ProductComboLineItem;

@Repository
public interface ProductComboLineItemRepository extends CrudRepository<ProductComboLineItem, Long>{
	
	public Iterable<ProductComboLineItem> findByProductId(Long productId);
}
