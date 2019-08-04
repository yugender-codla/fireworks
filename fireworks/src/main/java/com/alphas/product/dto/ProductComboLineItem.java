package com.alphas.product.dto;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;

import com.alphas.order.dto.Order;

import lombok.AccessLevel;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Entity
@Data
@Table(name = "Product_Combo_Line_Item", uniqueConstraints={@UniqueConstraint(columnNames="id")})
@NamedQueries({@NamedQuery(name = "findByProductId", query = "from ProductComboLineItem WHERE productId=:id")
})

public class ProductComboLineItem implements Serializable{
private static final long serialVersionUID = 1L;
	

public ProductComboLineItem() {}


	@Id
	@Column(name = "id")
	private Long id;
	
	@Column(name="pid1") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private Long pid1;
	
	@Column(name="pid1Name") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private String pid1Name;
	
	@Column(name="pid1Qty") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private String pid1Qty;
	
	
	@Column(name="pid2") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private Long pid2;
	
	@Column(name="pid2Name") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private String pid2Name;
	
	@Column(name="pid2Qty") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private String pid2Qty;
	
	@Column(name="pid3") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private Long pid3;
	
	@Column(name="pid3Name") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private String pid3Name;
	
	@Column(name="pid3Qty") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private String pid3Qty;
	
	@ManyToOne
	@JoinColumn(name = "Product")
    private Product product;
	
	public ProductComboLineItem(Object... fields) {
		super();
		this.id = fields[0] == null ? null : ((java.math.BigInteger) fields[0]).longValue();
		this.pid1 = fields[2] == null ? null : ((java.math.BigInteger) fields[2]).longValue();
		this.pid2 = fields[3] == null ? null : ((java.math.BigInteger) fields[3]).longValue();
		this.pid3 = fields[4] == null ? null : ((java.math.BigInteger) fields[4]).longValue();
		this.pid1Name = fields[5] == null ? null : fields[5].toString();
		this.pid2Name = fields[6] == null ? null : fields[6].toString();
		this.pid3Name = fields[7] == null ? null : fields[7].toString();
		this.pid1Qty = fields[8] == null ? null : fields[8].toString();
		this.pid2Qty = fields[9] == null ? null : fields[9].toString();
		this.pid3Qty = fields[10] == null ? null : fields[10].toString();
	}
}
