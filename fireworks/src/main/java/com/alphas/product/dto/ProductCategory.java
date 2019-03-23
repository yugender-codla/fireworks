package com.alphas.product.dto;

import java.io.Serializable;
import java.util.List;
import java.util.Map;

import com.alphas.order.dto.OrderLineItem;

import lombok.Data;

@Data
public class ProductCategory implements Serializable{

	private static final long serialVersionUID = 1L;
	private String categoryName;
	//private List<OrderLineItem> orderLineItems;
	
	public ProductCategory(String categoryName){
		this.categoryName = categoryName;
	}
	
	private Map<String, List<OrderLineItem>> orderLineItems;

/*
	@Override
	public boolean equals(Object obj) {
		return this.categoryName.equals(((ProductCategory)obj).getCategoryName());
	}

	@Override
	public int hashCode() {
				return Arrays.hashCode(new Object[] {
						categoryName
				    });
	}*/
}
