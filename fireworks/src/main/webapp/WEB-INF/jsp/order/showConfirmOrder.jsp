<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Confirmation Page</title>

<script type="text/javascript">

    $(document).ready(function(){
    	
    	 $("#backButton").click(function(){
             document.confirmationForm.action = "<%= request.getContextPath()%>/order/backToShowProducts";
          });    
    });   
    
    
    
</script>


</head>
<body>
	<div class="container">

		<c:if test="${not empty msg}">
		    <div class="alert alert-${css} alert-dismissible" role="alert">
			<button type="button" class="close" data-dismiss="alert" 
                                aria-label="Close">
				<span aria-hidden="true">�</span>
			</button>
			<strong>${msg}</strong>
		    </div>
		</c:if>

		<h1>Confirm Order</h1>

<spring:url value="/order/confirmOrder" var="confirmOrderUrl" />
 <form:form method="post" action="${confirmOrderUrl}" modelAttribute="order" name="confirmationForm">


		<table class="table table-striped">
			<thead>
				<tr>
					<th>Name</th>
					<th>Type</th>
					<th>Spec</th>
					<th>Function</th>
					<th>Price</th>
					<th>Quantity</th>
				</tr>
			</thead>

			<c:forEach var="item" items="${order.orderLineItems}" varStatus="loop">
			<c:set var="nameParts" value="${fn:split(item.productName, ',')}" />
			    <tr>
				
				<input type="hidden" name="orderLineItems[${loop.index}].productId" value="${item.productId}">
				<input type="hidden" name="orderLineItems[${loop.index}].price" value="${item.price}">
				<input type="hidden" name="orderLineItems[${loop.index}].quantity" value="${item.quantity}">
				
				<td>${nameParts[0]}</td>
				<td>${nameParts[1]}</td>
				<td>${nameParts[2]}</td>
				<td>${nameParts[3]}</td>
				<td>${item.price}</td>
				<td>${item.quantity}</td>
				
			    </tr>
			</c:forEach>
		</table>
		
		<label for="Phone Number">Phone No: </label> <form:input path="phoneNumber"/> 
		<label for="Email">Email: </label> <form:input path="email"/> 
		<label for="date">Deliver by: </label> <input name = "deliverBy"  type="date">
<br><br>
		
<input type="submit" value = "Back" id ="backButton">  		<input type = "submit" value = "Confirm Order"/>
</form:form>
	</div>
</body>
</html>