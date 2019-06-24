package com.alphas.common.dto;

import java.util.HashMap;
import java.util.Map;

public enum States {

	START(100, "Start"),
	SUBMIT_ORDER(101, "Order Submitted"),
	
	MODIFY_ORDER(103, "Order Modified"),
	USER_APPROVE_ORDER(104, "User Approved Order"),

	ADMIN_COMPLETE_PACKING(102, "Packing Completed"),

	ORDER_DELIVERED(105, "Delivered"),
	
	ORDER_IN_PROGRESS(106, "Order In Progress");
	
	
	private final int aStateId;
	private final String aState;
	
	States(int mStateId, String mState){
		this.aStateId = mStateId;
		aState = mState;
	} 
	
	private static Map<Integer, String> statesMap = new HashMap<Integer, String>();
	static {
		States[] array = States.values();
		for (int i = 0; i < array.length; i++) {
			statesMap.put(array[i].aStateId, array[i].aState);
		}
	}
	
	public static String getStates(Integer stateId){
		return statesMap.get(stateId);
	}
	
	public String getState(){
		return this.aState;
	}
	
	public int getStateId() {
		return this.aStateId;
	}
}
