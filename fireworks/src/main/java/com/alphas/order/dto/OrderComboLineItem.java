package com.alphas.order.dto;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import lombok.Data;

@Entity
@Data
@Table(name = "Order_Combo_Line_Item", uniqueConstraints = { @UniqueConstraint(columnNames = "id") })
public class OrderComboLineItem implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	
	private Long productComboLineItemId;
	
	private String productComboLineItemData;
	
	private Long quantity;
	

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn
	private OrderLineItem orderLineItem;
}
