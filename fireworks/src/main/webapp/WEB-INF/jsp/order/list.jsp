<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!-- - I think this is not used..... -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
	<div class="container">

		<c:if test="${not empty msg}">
		    <div class="alert alert-${css} alert-dismissible" role="alert">
			<button type="button" class="close" data-dismiss="alert" 
                                aria-label="Close">
				<span aria-hidden="true">×</span>
			</button>
			<strong>${msg}</strong>
		    </div>
		</c:if>

		<h1>Items</h1>

<spring:url value="/order/showConfirmOrder" var="showConfirmOrderUrl" />
 <form:form method="post" action="${showConfirmOrderUrl}" modelAttribute="order">

 	<input type="hidden" name="phoneNumber" value="${order.phoneNumber}"/> 
    <input type="hidden" name="email" value="${order.email}"/> 

		<table class="table table-striped">
			<thead>
				<tr>
					<th>Select</th>
					<th>Name</th>
					<th>Type</th>
					<th>Spec</th>
					<th>Function</th>
					<th>Price</th>
					<th>Quantity</th>
				</tr>
			</thead>
			
	
			<c:forEach var="item" items="${order.orderLineItems}" varStatus="loop">
			    <tr>
				<td>
				
				<c:choose>
   					 <c:when test="${item.checked}">
					    <input type="checkbox" name="orderLineItems[${loop.index}].checked" checked="checked" >    
				    </c:when>    
				    <c:otherwise>
						<input type="checkbox" name="orderLineItems[${loop.index}].checked"  >        
					</c:otherwise>
				</c:choose>
				<c:set var="nameParts" value="${fn:split(item.productName, ',')}" />
				<input type="hidden" name="orderLineItems[${loop.index}].productId" value="${item.productId}">
				<input type="hidden" name="orderLineItems[${loop.index}].price" value="${item.price}">
				<input type="hidden" name="orderLineItems[${loop.index}].productName" value="${item.productName}">
				</td>
				<td>${nameParts[0]}</td>
				<td>${nameParts[1]}</td>
				<td>${nameParts[2]}</td>
				<td>${nameParts[3]}</td>
				<td>${item.price}</td>
				<td><input type="text" name="orderLineItems[${loop.index}].quantity" value="${item.quantity}"></td>
				
			    </tr>
			</c:forEach>
		</table>
		
		<input type = "submit" value = "Order Now"/>
</form:form>
	</div>
</body>
</html>