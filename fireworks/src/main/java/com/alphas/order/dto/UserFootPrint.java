package com.alphas.order.dto;

import java.io.Serializable;
import java.util.List;

import lombok.Data;


@Data
public class UserFootPrint implements Serializable{
	private static final long serialVersionUID = 1L;
	private List<UserInfo> userInfoList;
	
	
}
