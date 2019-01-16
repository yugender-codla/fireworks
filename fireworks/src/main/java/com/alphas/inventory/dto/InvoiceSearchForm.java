package com.alphas.inventory.dto;

import java.io.Serializable;
import java.util.Date;
import java.util.Optional;

import lombok.Data;

@Data
public class InvoiceSearchForm implements Serializable {

	private Optional<Date> fromDate;
	private Optional<Date> toDate;
	
}
