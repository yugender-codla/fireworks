package com.alphas.product.dto;

import java.io.IOException;
import java.io.Serializable;
import java.lang.reflect.Field;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.UniqueConstraint;

import org.springframework.web.multipart.MultipartFile;

import lombok.AccessLevel;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;

@Entity
@Data
@Table(name = "Product", uniqueConstraints={@UniqueConstraint(columnNames="name")})
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
	
	@Transient
	@Getter @Setter(AccessLevel.PUBLIC)
	private MultipartFile[] files;
	
	@Lob @Basic(fetch = FetchType.LAZY)
	@Getter @Setter(AccessLevel.PUBLIC)
	private byte[] image1;
	
	@Lob @Basic(fetch = FetchType.LAZY)
	@Getter @Setter(AccessLevel.PUBLIC)
	private byte[] image2;
	
	@Lob @Basic(fetch = FetchType.LAZY)
	@Getter @Setter(AccessLevel.PUBLIC)
	private byte[] image3;
	
	@Lob @Basic(fetch = FetchType.LAZY)
	@Getter @Setter(AccessLevel.PUBLIC)
	private byte[] image4;
	
	@Lob @Basic(fetch = FetchType.LAZY)
	@Getter @Setter(AccessLevel.PUBLIC)
	private byte[] image5;
	

	
	public void setImages() throws IOException, NoSuchFieldException, SecurityException, IllegalArgumentException, IllegalAccessException{
		Class<?> c = this.getClass();
		int var = 1;
		for(int i = 0; i < this.files.length; i ++) {
			if(this.files[i] != null) {
			 Field img = c.getDeclaredField("image"+var);
			 img.set(this, this.files[i].getBytes());
			var ++;
			}
		}
	}
	
	//Check if this is for New of Update
	
	public boolean isNew() {
		return (this.id == null);
	}
}

