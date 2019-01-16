package com.alphas.repository;

import java.util.Date;
import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import com.alphas.inventory.dto.Invoice;

@Repository
public interface InvoiceRepository extends CrudRepository<Invoice, Long>{
	
	@Query("select invoice from Invoice invoice where invoice.billDate between ?1 and ?2")
	public List<Invoice> findByBillDate(Date fromDate, Date endDate);

}
