package com.alphas.product.dto;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.SequenceGenerator;

import lombok.AccessLevel;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Entity
@Data
public class Product implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@Id
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "product_id_generator")
	@SequenceGenerator(name="product_id_generator", sequenceName = "product_id_seq", allocationSize=1)
	@Column(name = "id")
	@Getter @Setter(AccessLevel.PUBLIC)
	private Long id;
	
	@Column(name="name")
	@Getter @Setter(AccessLevel.PUBLIC)
	private String name;
	
	@Column(name="active")
	@Getter @Setter(AccessLevel.PUBLIC)
	private Character active;
	
	@Lob
	@Getter @Setter(AccessLevel.PUBLIC)
	private byte[] image1;

	//Check if this is for New of Update
	
	public boolean isNew() {
		return (this.id == null);
	}
}
