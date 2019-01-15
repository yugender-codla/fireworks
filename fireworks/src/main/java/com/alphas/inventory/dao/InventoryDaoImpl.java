package com.alphas.inventory.dao;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Invoice;
import com.alphas.repository.InvoiceRepository;

@Component
public class InventoryDaoImpl implements InventoryDao{

	@Autowired
	private InvoiceRepository repository;
	
	@Override
	public Invoice addInvoice(Invoice invoice) throws AException {
		invoice = repository.save(invoice);
		return invoice;
	}

	@Override
	public Invoice retrieveInvoice(Invoice invoice) throws AException {
		repository.findAll();
		return null;
	}
}
