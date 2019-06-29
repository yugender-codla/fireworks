package com.alphas.order.dto;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;
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
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;

import com.alphas.common.dto.StateMap;
import com.alphas.common.util.CommonUtil;

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
	@NotNull(message="required")
	private Date deliverBy;
	
	@Column(name="phoneNumber")
	@NotNull(message="required")
	@Pattern(regexp = "[0-9]+",message = "Please enter only numbers")
	@Size(min=10, max=10,message = "Please enter 10 digit phone number")
	private String phoneNumber;
	
	@Column(name="email")
	@NotNull
	@Pattern(regexp ="^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$",message = "Please enter valid email id")
	private String email;
	
	@Column(name="status")
	private String status;
	
	@Column(name="statusCode")
	private int statusCode;
	
	@Column(name="orderNumber")
	private String orderNumber;
	
	@Column(name="custName")
	@NotNull(message="Name is required")
	@Size(min=1,message="Name is required")
	private String custName;
	
	@Column(name="modifiedFlag")
	private String modifiedFlag;
	
	@OneToMany(mappedBy="order",cascade = {CascadeType.ALL, CascadeType.MERGE, CascadeType.PERSIST})
	private List<OrderLineItem> orderLineItems;
	
	
		
	public Order() {
		//orderLineItems = new ArrayList<OrderLineItem>();
	}
	
	public BigDecimal getPriceOfTheOrder() {
		return BigDecimal.valueOf(orderLineItems.stream().mapToDouble(t -> t.getPrice().doubleValue() * t.getQuantity()).sum());
	}
	
	
	public String getDeliverByUI(){
		return new CommonUtil().convertDateToUI(deliverBy);
	}
	
	public List<String> getEvents(){
		return StateMap.getStatusEventMap(this.statusCode);
	}
	
}
