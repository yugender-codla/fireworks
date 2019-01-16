package com.alphas.inventory.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dao.InvoiceDao;
import com.alphas.inventory.dto.Invoice;
import com.alphas.inventory.dto.InvoiceSearchForm;

@Service
public class InvoiceServiceImpl implements InvoiceService{

	@Autowired
	private InvoiceDao dao;
	
	@Override
	public Invoice addInvoice(Invoice invoice) throws AException {
		return dao.addInvoice(invoice);
	}

	@Override
	public  List<Invoice> retrieveInvoice(InvoiceSearchForm invoice) throws AException {
		// TODO Auto-generated method stub
		return dao.retrieveInvoice(invoice);
	}

	@Override
	public Invoice findById(Long id) {
		return dao.findById(id);
	}
}
