package com.alphas.inventory.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;

import org.hibernate.annotations.OnDelete;
import org.hibernate.annotations.OnDeleteAction;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Data;

@Entity
@Data
public class InvoiceLineItem implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "invoice_line_item_generator")
	@SequenceGenerator(name="invoice_line_item_generator", sequenceName = "invoice_line_item_seq", allocationSize=1)
	@Column(name = "id")
	private Long id;
	
	@Column(name="productId")
	private String productId;
	
	@Column(name="quantity")
	private Long quantity;
	
	@Column(name="price")
	private BigDecimal price;
	
	
	@ManyToOne(cascade= CascadeType.ALL, fetch = FetchType.EAGER)
    @JoinColumn(name = "invoiceid", referencedColumnName="invoiceid")
    private Invoice invoice;

}
