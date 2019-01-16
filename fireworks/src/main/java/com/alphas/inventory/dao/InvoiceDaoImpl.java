package com.alphas.inventory.dao;

import java.util.Date;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Invoice;
import com.alphas.inventory.dto.InvoiceLineItem;
import com.alphas.inventory.dto.InvoiceSearchForm;
import com.alphas.repository.InvoiceLineItemRepository;
import com.alphas.repository.InvoiceRepository;

import lombok.Data;

@Component
@Data
public class InvoiceDaoImpl implements InvoiceDao{

	@Autowired
	private InvoiceRepository repository;
	
	@Autowired
	private InvoiceLineItemRepository lineItemRepository;
	
	@Value("${fireworks.invoice.defaultFromDate}")
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date defaultFromDate;
	
	@Override
	@Transactional
	public Invoice addInvoice(Invoice invoice) throws AException {
		
		for(InvoiceLineItem item: invoice.getInvoiceLineItems()) {
			item.setInvoice(invoice);
		}	
		
		if(invoice.getInvoiceid() != null) {
			
			Invoice oldInvoiceDetails = repository.findById(invoice.getInvoiceid()).orElse(null);
			lineItemRepository.deleteAll(oldInvoiceDetails.getInvoiceLineItems());
		}
		invoice = repository.save(invoice);
		return invoice;
	}

	@Override
	public  List<Invoice> retrieveInvoice(InvoiceSearchForm invoice) throws AException {
		;
		return repository.findByBillDate(invoice.getFromDate().orElse(defaultFromDate), invoice.getToDate().orElse(new Date()));
	}
	
	
	public Invoice findById(Long id) {
		return repository.findById(id).orElse(new Invoice());
	}
	
	
}
