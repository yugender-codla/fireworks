package com.alphas.order.dto;

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
import javax.persistence.Transient;

import lombok.Data;

@Entity
@Data
public class OrderLineItem implements Serializable{
	private static final long serialVersionUID = 1L;
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "ORDER_LINE_ITEM_SEQ_GEN")
	@SequenceGenerator(name = "ORDER_LINE_ITEM_SEQ_GEN", sequenceName = "order_line_item_seq", allocationSize = 1)
	private Long id;
	
	@Column(name="productId")
	private Long productId;
	
	@Transient
	private String productName;
	
	@Column(name="quantity")
	private Integer quantity = 0;
	
	@Column(name="price")
	private Long price;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn
    private Order order;
	
	@Transient
	private boolean checked;
	
	
}
