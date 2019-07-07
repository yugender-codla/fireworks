package com.alphas.inventory.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class Inventory implements Serializable {
	private static final long serialVersionUID = 1L;
	private Long productId;
	private String productName;
	private Long invoicedQty;
	private Long usedQty;
	private Long availQty;
	private Long requiredQty;

	public Inventory(Object... fields) {
		super();
		this.productId = fields[0] == null ? null : ((java.math.BigInteger) fields[0]).longValue();
		this.productName = fields[1] == null ? null : fields[1].toString();
		this.invoicedQty = fields[2] == null ? null : Long.valueOf(fields[2].toString());
		this.usedQty = fields[3] == null ? null : Double.valueOf(fields[3].toString()).longValue();
		this.availQty = fields[4] == null ? null : Double.valueOf(fields[4].toString()).longValue();
		this.requiredQty = fields[5] == null ? null : Double.valueOf(fields[5].toString()).longValue();
	}

}
