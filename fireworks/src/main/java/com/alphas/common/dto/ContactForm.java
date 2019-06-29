package com.alphas.common.dto;

import java.io.Serializable;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Pattern;
import javax.validation.constraints.Size;

import lombok.Data;

@Data
public class ContactForm implements Serializable{
	private static final long serialVersionUID = 1L;
	
	@NotNull
	@Size(min=1,message="Name is required")
	private String name;
	
	@NotNull
	@Pattern(regexp ="^[a-zA-Z0-9_!#$%&'*+/=?`{|}~^.-]+@[a-zA-Z0-9.-]+$",message = "Please enter valid email id")
	private String userEmail;
	
	@NotNull
	@Size(min =10, message ="Please enter atleast 10 characters")
	private String message;
	
	

}
