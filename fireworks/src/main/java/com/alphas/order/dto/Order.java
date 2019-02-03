package com.alphas.order.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Entity
@Data
@Table(name = "OrderMain")
public class Order implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "order_seq")
	@SequenceGenerator(name = "order_seq", sequenceName = "order_id_seq", allocationSize = 1)
	private Long id;
	
	@Column(name="deliverBy")
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date deliverBy;
	
	@Column(name="phoneNumber")
	private String phoneNumber;
	
	@Column(name="email")
	private String email;
	
	@Column(name="status")
	private String status;
	
	@OneToMany(mappedBy="order",cascade = {CascadeType.ALL, CascadeType.MERGE, CascadeType.PERSIST})
	private List<OrderLineItem> orderLineItems;
	
	
	public Order() {
		//orderLineItems = new ArrayList<OrderLineItem>();
	}
	
}
