package com.alphas.inventory.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Entity
@Table(name = "Invoice")
@Data
public class Invoice implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "INVOICE_SEQ")
	@SequenceGenerator(name = "INVOICE_SEQ", sequenceName = "invoice_id_seq", allocationSize = 1)
	@Column(name = "invoiceid")
	private Long inid;
	
	@Column(name="billDate")
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date billDate;
	
	@Column(name="billNo")
	private String billNo;
	
	@OneToMany(fetch = FetchType.EAGER,mappedBy="invoice",cascade = CascadeType.ALL)
	private List<InvoiceLineItem> invoiceLineItems;
	
	
	
	
}
