package com.alphas.inventory.dto;

import java.io.Serializable;

import lombok.Data;


@Data
public class Stock implements Serializable{

	private Long productId;
	
	private Long qty1;
	
	private Long qty2;
	
	private String productName;
	
	 public Stock(Object...fields) {
	        super();
	        this.productId = fields[0] == null ? null : ((java.math.BigInteger) fields[0]).longValue();
	        this.qty1 =  fields[1] == null ? null : Double.valueOf(fields[1].toString()).longValue();
	        this.qty2 = fields[2] == null ? null : Double.valueOf(fields[2].toString()).longValue();
	        this.productName = fields[3] == null ? null : fields[3].toString();
	    }
}
