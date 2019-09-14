package com.alphas.common.dto;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public enum StateMap {

	START(Event.START, 100, 100),
	SUBMIT_ORDER(Event.SUBMIT_ORDER,100, 101),
	
	/*MODIFY_ORDER(Event.MODIFY_ORDER, 101, 103),
	USER_APPROVE_ORDER(Event.USER_APPROVE_ORDER, 103, 104),*/
	
	
	ADMIN_ORDER_IN_PROGRESS1(Event.WORK_IN_PROGRESS, 101,106),
	/*ADMIN_ORDER_IN_PROGRESS2(Event.IN_PROGRESS, 104,106),*/
	
	ADMIN_COMPLETE_PACKING(Event.PACKING_COMPLETED, 106, 102),
	
	ORDER_DELIVERED(Event.DELIVERED, 102, 105);
	
	
	private final Event aEvent;
	private final int aFromState;
	private final int aToState;
	
	StateMap(Event mEvent, int mFromState, int mToState){
		this.aEvent = mEvent;
		this.aFromState = mFromState;
		this.aToState = mToState;
	}
	
	static Map<String, StateMap> values = new HashMap<String, StateMap>();
	
	/** Map for From state vs Event. This is used in search order screen - to move the records to next status **/
	static Map<Integer, List<String>> statusEventMap = new HashMap<Integer, List<String>>();
	
	static {
		StateMap[] array = StateMap.values();
		for (int i = 0; i < array.length; i++) {
			values.put(array[i].aEvent+"-"+array[i].aFromState, array[i]);
			
			if(statusEventMap.get(array[i].aFromState) != null) {
				statusEventMap.get(array[i].aFromState).add(array[i].aEvent.toString());
			}else {
				List<String> events = new ArrayList<String>();
				events.add(array[i].aEvent.toString());
				statusEventMap.put(Integer.valueOf(array[i].aFromState), events);
			}
		}
				
	}
	
	public static StateMap getStateMap(String event) {
		return values.get(event);
	}

	public static List<String> getStatusEventMap(int fromState) {
		return statusEventMap.get(fromState);
	}
	
	public Event getaEvent() {
		return aEvent;
	}

	public int getaFromState() {
		return aFromState;
	}

	public int getaToState() {
		return aToState;
	}
	
	
}
