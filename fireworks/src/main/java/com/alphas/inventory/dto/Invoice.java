package com.alphas.inventory.dto;

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

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Entity
@Table(name = "Invoice")
@Data
public class Invoice implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "INVOICE_SEQ")
	@SequenceGenerator(name = "INVOICE_SEQ", sequenceName = "invoice_id_seq", allocationSize = 1)
	private Long invoiceid;
	
	@Column(name="billDate")
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date billDate;
	
	@Column(name="billNo")
	private String billNo;
	
	@Column(name="totalPrice")
	private BigDecimal totalPrice;
	
	@Column(name="discountPrice")
	private BigDecimal discountPrice;
	
	@Column(name="discountPercentage")
	private BigDecimal discountPercentage;
	
	
	@OneToMany(mappedBy="invoice",cascade = {CascadeType.ALL, CascadeType.MERGE, CascadeType.PERSIST})
	private List<InvoiceLineItem> invoiceLineItems;
	
	
	
	
	
}
