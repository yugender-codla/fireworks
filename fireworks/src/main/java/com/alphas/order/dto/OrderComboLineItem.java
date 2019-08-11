package com.alphas.order.dto;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;

import lombok.Data;

@Entity
@Data
@Table(name = "Order_Combo_Line_Item", uniqueConstraints = { @UniqueConstraint(columnNames = "id") })
public class OrderComboLineItem {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	
	@Transient	
	private String productComboLineItemData;
	
	@Column(name = "productComboLineItemId")
	public Long getProductComboLineItemId() {
		return Long.valueOf(this.productComboLineItemData.split("|")[0].trim());
	} 
	

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn
	private OrderLineItem orderLineItem;
}
