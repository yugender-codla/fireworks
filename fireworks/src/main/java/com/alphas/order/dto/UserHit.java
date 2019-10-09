package com.alphas.order.dto;

import java.util.List;

import lombok.Data;

@Data
public class UserHit {

	private Integer hits;
	private List<UserInfo> list;
}
