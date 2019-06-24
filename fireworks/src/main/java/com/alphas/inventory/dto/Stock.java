package com.alphas.inventory.dto;

import java.io.Serializable;

import lombok.Data;


@Data
public class Stock implements Serializable{

	private Long productId;
	
	private Long requiredQuantity;
	
	private Long availableQuantity;
	
	private String productName;
	
	 public Stock(Object...fields) {
	        super();
	        this.productId = ((java.math.BigInteger) fields[0]).longValue();
	        this.requiredQuantity =  Long.valueOf(fields[1].toString());
	        this.availableQuantity = Double.valueOf(fields[2].toString()).longValue();
	        this.productName = fields[3].toString();
	    }
}
