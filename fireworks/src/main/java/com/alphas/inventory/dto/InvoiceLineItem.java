package com.alphas.inventory.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;

import lombok.Data;

@Entity
@Data
public class InvoiceLineItem implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "INVOICE_LINE_ITEM_SEQ_GEN")
	@SequenceGenerator(name = "INVOICE_LINE_ITEM_SEQ_GEN", sequenceName = "invoice_line_item_seq", allocationSize = 1)
	private Long id;
	
	@Column(name="productId")
	private String productId;
	
	@Column(name="quantity")
	private Long quantity;
	
	@Column(name="price")
	private BigDecimal price;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn
    private Invoice invoice;
	
}
