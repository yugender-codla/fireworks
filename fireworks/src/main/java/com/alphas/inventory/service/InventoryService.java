package com.alphas.inventory.service;

import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Invoice;

@Service
public interface InventoryService {
	
	public Invoice addInvoice(Invoice invoice) throws AException;
	public Invoice retrieveInvoice(Invoice invoice) throws AException;
	

}
