package com.alphas.common.exception;

public class AException extends Exception{
	private static final long serialVersionUID = 1L;
	
	public AException(String s) 
    { 
        super(s); 
    }
	
	public AException(Exception e) 
    { 
        super(e); 
    }
	
	
}
