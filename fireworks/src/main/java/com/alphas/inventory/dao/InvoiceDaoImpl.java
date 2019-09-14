package com.alphas.inventory.dao;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import javax.persistence.EntityManager;
import javax.persistence.Query;
import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Component;

import com.alphas.common.exception.AException;
import com.alphas.inventory.dto.Inventory;
import com.alphas.inventory.dto.Invoice;
import com.alphas.inventory.dto.InvoiceLineItem;
import com.alphas.inventory.dto.InvoiceSearchForm;
import com.alphas.inventory.dto.Stock;
import com.alphas.repository.InvoiceLineItemRepository;
import com.alphas.repository.InvoiceRepository;

import lombok.Data;

@Component
@Data
public class InvoiceDaoImpl implements InvoiceDao{

	@Autowired
	private InvoiceRepository repository;
	
	@Autowired
	private InvoiceLineItemRepository lineItemRepository;
	
	@Value("${fireworks.invoice.defaultFromDate}")
	@DateTimeFormat(pattern="yyyy-MM-dd")
	private Date defaultFromDate;
	
	@Override
	@Transactional
	public Invoice addInvoice(Invoice invoice) throws AException {
		
		for(InvoiceLineItem item: invoice.getInvoiceLineItems()) {
			item.setInvoice(invoice);
		}	
		
		if(invoice.getInvoiceid() != null) {
			
			Invoice oldInvoiceDetails = repository.findById(invoice.getInvoiceid()).orElse(null);
			lineItemRepository.deleteAll(oldInvoiceDetails.getInvoiceLineItems());
		}
		invoice = repository.save(invoice);
		return invoice;
	}

	@Override
	public  List<Invoice> retrieveInvoice(InvoiceSearchForm invoice) throws AException {
		;
		return repository.findByBillDate(invoice.getFromDate().orElse(defaultFromDate), invoice.getToDate().orElse(new Date()));
	}
	
	
	public Invoice findById(Long id) {
		return repository.findById(id).orElse(new Invoice());
	}
	
	
	
	/***
	 * Method used to retrieve the stock availability at any point of time.
	 * Available qty = [total qty invoiced] - [all 'packed' and 'delivered' items]
	 * Required qty = [qty not packed or delivered] 
	 * 
	 * @param em
	 * @return
	 * @throws AException
	 */
	@Override
	public List<Inventory> retrieveStockAvailability(EntityManager em) throws AException{
/*	Without combo - perfect	
 * String queryString = "select * from( " + 
				"select total.id,total.name, total.totalInvoiceQty, " + 
				"case when used.usedQty is null then 0 else used.usedQty end usedQty,   " + 
				"(case when total.totalinvoiceQty is null then 0 else total.totalinvoiceQty end - case when used.usedQty is null then 0 else used.usedQty end) as available, " + 
				"case when orderQty.requiredQty is null then 0 else orderQty.requiredQty end as required  " + 
				"from  " + 
				"(select p.id,p.name,case when sum(ili.quantity) is null then 0 else sum(ili.quantity) end as totalInvoiceQty from product p  " + 
				"left outer join invoice_line_item ili on p.id = ili.product_id  " + 
				"group by p.id,p.name) total  " + 
				"left outer join  " + 
				"( " + 
				"select oli.product_id, case when sum(quantity) is null then 0 else sum(quantity) end as usedQty from order_line_item oli  " + 
				"join order_main m on m.id = oli.order_id  " + 
				"where m.status_code in(105,102) group by oli.product_id  " + 
				") used on used.product_id = total.id " + 
				"left outer join  " + 
				"( " + 
				"select oli.product_id, case when sum(quantity) is null then 0 else sum(quantity) end as requiredQty from order_line_item oli join order_main m on m.id = oli.order_id  " + 
				"where m.status_code not in(105,102) group by oli.product_id " + 
				") orderQty on orderQty.product_id = total.id) maintbl order by maintbl.required desc ";*/
		
		String queryString = 
				"select total.id,total.name, total.totalInvoiceQty, "+
	"case when used.usedQty is null then 0 else used.usedQty end usedQty, "+  
	"(case when total.totalinvoiceQty is null then 0 else total.totalinvoiceQty end - case when used.usedQty is null then 0 else used.usedQty end) as available, "+
	"case when orderQty.requiredQty is null then 0 else orderQty.requiredQty end as required  "+
	"from  "+
	"(select p.id,p.name,case when sum(ili.quantity) is null then 0 else sum(ili.quantity) end as totalInvoiceQty from product p "+ 
	"left outer join invoice_line_item ili on p.id = ili.product_id  "+
	"group by p.id,p.name) total  "+
	"left outer join  "+
	"( "+
	"select t.productId, case when sum(t.qty) is null then 0 else sum(t.qty) end as usedQty from ( "+
	"select oli.product_id as productId, sum(oli.quantity) as qty from order_line_item oli  "+
	"join order_main om on om.id = oli.order_id where om.status != 'Cancelled' and om.status_code in(105,102) and (oli.category is null OR oli.category != 'Combo') "+ 
	"group by oli.product_id "+
	"UNION "+
	"select ocli.product_combo_line_item_id as productId, sum(ocli.quantity * oli.quantity) as qty from "+ 
	"order_combo_line_item ocli join order_line_item oli on oli.id = ocli.order_line_item_id "+
	"join order_main om on om.id = oli.order_id where om.status != 'Cancelled' and om.status_code in(105,102) and oli.category = 'Combo' "+ 
	"group by ocli.product_combo_line_item_id) t "+
	"group by t.productId "+
	") used on used.productid = total.id "+
	"left outer join  "+
	"( "+
	"select t.productId, case when sum(t.qty) is null then 0 else sum(t.qty) end as requiredQty from ( "+
	"select oli.product_id as productId, sum(oli.quantity) as qty from order_line_item oli  "+
	"join order_main om on om.id = oli.order_id where om.status != 'Cancelled' and om.status_code not in(105,102) and (oli.category is null OR oli.category != 'Combo') "+ 
	"group by oli.product_id "+
	"UNION "+
	"select ocli.product_combo_line_item_id as productId, sum(ocli.quantity * oli.quantity) as qty from "+ 
	"order_combo_line_item ocli join order_line_item oli on oli.id = ocli.order_line_item_id "+
	"join order_main om on om.id = oli.order_id where om.status != 'Cancelled' and om.status_code not in(105,102) and oli.category = 'Combo' "+ 
	"group by ocli.product_combo_line_item_id) t "+
	"group by t.productId "+
	") orderQty on orderQty.productid = total.id";
				
		
		List<Inventory> ooBj = null;
		try {
		Query query = em.createNativeQuery(queryString);

		List<Object[]> objList = query.getResultList();
        ooBj = objList.stream().map(Inventory::new).collect(Collectors.toList());
	}catch(Exception exception) {
		throw new AException(exception);
	}
		return ooBj;
	}
	
}
