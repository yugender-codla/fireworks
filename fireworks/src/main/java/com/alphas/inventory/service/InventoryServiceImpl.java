package com.alphas.inventory.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dao.InventoryDao;
import com.alphas.inventory.dto.Invoice;

@Service
public class InventoryServiceImpl implements InventoryService{

	@Autowired
	private InventoryDao dao;
	
	@Override
	public Invoice addInvoice(Invoice invoice) throws AException {
		return dao.addInvoice(invoice);
	}

	@Override
	public Invoice retrieveInvoice(Invoice invoice) throws AException {
		// TODO Auto-generated method stub
		return null;
	}

}
