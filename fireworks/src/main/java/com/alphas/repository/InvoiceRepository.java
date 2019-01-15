package com.alphas.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.alphas.inventory.dto.Invoice;

@Repository
public interface InvoiceRepository extends CrudRepository<Invoice, Long>{

}
