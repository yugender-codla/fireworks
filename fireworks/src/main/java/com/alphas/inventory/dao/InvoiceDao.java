package com.alphas.inventory.dao;

import java.util.List;

import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Invoice;
import com.alphas.inventory.dto.InvoiceSearchForm;

@Service
public interface InvoiceDao {
	public Invoice addInvoice(Invoice invoice) throws AException;
	public  List<Invoice> retrieveInvoice(InvoiceSearchForm invoice) throws AException;
	public Invoice findById(Long id);
}
