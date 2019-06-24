package com.alphas.common.dao;

import org.springframework.stereotype.Component;

import com.alphas.common.dto.Event;
import com.alphas.common.dto.StateMap;
import com.alphas.common.dto.States;
import com.alphas.order.dto.Order;

@Component
public class StateMapDaoImpl implements StateMapDao{

	public Order moveState(Order order,Event event, int fromState) {
		
		StateMap stateMap = StateMap.getStateMap(event+"-"+fromState);
		if(stateMap != null) {
			order.setStatusCode(stateMap.getaToState());
			order.setStatus(States.getStates(stateMap.getaToState()));
		}
		return order;
	}

	
public int moveState(Event event, int fromState) {
		
		StateMap stateMap = StateMap.getStateMap(event+"-"+fromState);
		if(stateMap != null) {
			return stateMap.getaToState();
		}
		return fromState;
	}
}
