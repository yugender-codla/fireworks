package com.alphas.product.dto;

import java.io.Serializable;
import java.math.BigDecimal;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.UniqueConstraint;

import lombok.AccessLevel;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Entity
@Data
@Table(name = "Product", uniqueConstraints={@UniqueConstraint(columnNames="name")})
@NamedQueries({@NamedQuery(name = "findProductById", query = "from Product WHERE id=:id"),
	@NamedQuery(name = "findAvailableProducts", query = "from Product p where p.available='Y' and p.active='Y'")
})

public class Product implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "product_id_generator")
	@SequenceGenerator(name="product_id_generator", sequenceName = "product_id_seq", allocationSize=1)
	@Column(name = "id")
	private Long id;
	
	@Column(name="name") 
	@Getter @Setter(AccessLevel.PUBLIC)
	private String name;
	
	@Column(name="active")
	@Getter @Setter(AccessLevel.PUBLIC)
	private String active;
	
	@Column(name="price")
	@Getter @Setter(AccessLevel.PUBLIC)
	private BigDecimal price;
	
	@Column(name="available")
	@Getter @Setter(AccessLevel.PUBLIC)
	private String available;
	
	
	/*
	 * Image start------------->
	 * 
	 * @Transient
	@Getter @Setter(AccessLevel.PUBLIC)
	private MultipartFile[] files;
	
	@Lob @Basic(fetch = FetchType.EAGER)
	@Getter @Setter(AccessLevel.PUBLIC)
	private byte[] image1;
	
	 
	@Getter @Setter(AccessLevel.PUBLIC)
	private String image1Name;
	

	
	public void setImages() throws IOException, NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		Class<?> c = this.getClass();
		int var = 1;
		for(int i = 0; i < this.files.length; i ++) {
			if(this.files[i] != null) {
			 Field img = c.getDeclaredField("image"+var);
			 Field imgName = c.getDeclaredField("image"+var+"Name");
			 img.set(this, this.files[i].getBytes());
			 imgName.set(this, this.files[i].getOriginalFilename());
			var ++;
			}
		}
	}
	
	*Image end------------->
	*/
	
	//Check if this is for New of Update
	
	public boolean isNew() {
		return (this.id == null);
	}
}

