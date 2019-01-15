package com.alphas.inventory.dao;

import org.springframework.stereotype.Service;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Invoice;

@Service
public interface InventoryDao {
	public Invoice addInvoice(Invoice invoice) throws AException;
	public Invoice retrieveInvoice(Invoice invoice) throws AException;
}
