package com.alphas.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.alphas.inventory.dto.Invoice;
import com.alphas.inventory.dto.InvoiceLineItem;

@Repository
public interface InvoiceLineItemRepository extends CrudRepository<InvoiceLineItem, Long>{
	
	public void deleteByInvoice(Invoice invoice);

}
