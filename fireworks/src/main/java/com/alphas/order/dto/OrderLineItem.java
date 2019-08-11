package com.alphas.order.dto;

import java.io.Serializable;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Transient;

import com.alphas.product.dto.ProductComboLineItem;

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
	
	@Column(name="category")
	private String category;
	
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn
    private Order order;
	
	@Transient
	private boolean checked;
	
	@Transient
	private List<ProductComboLineItem> productComboLineItems;
	
	@OneToMany(mappedBy="orderLineItem",cascade = {CascadeType.ALL, CascadeType.MERGE, CascadeType.PERSIST})
	private List<OrderComboLineItem> orderComboLineItems;
	
}
