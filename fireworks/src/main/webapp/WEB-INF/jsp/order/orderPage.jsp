<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Order</title>


<script type="text/javascript">


	$(document).ready(function() {
		$("#qntyCountInputTxt").val(0);
		$("#qntyCountInputLbl").text(0);

		$(".quantityBtnAdd").click(function() {
			var parentTag = $(this).parent().children('label');
			var val = parseInt(parentTag.text());
			val = val + 1;
			parentTag.text(val);

			calculateQty();
		});

		$(".quantityBtnMinus").click(function() {
			var parentTag = $(this).parent().children('label');
			var val = parseInt(parentTag.text());
			if (val > 0) {
				val = val - 1;
				parentTag.text(val);
			}
			calculateQty();
		});

		function calculateQty(){
			var qnty = 0;
			var price = 0;
			var totalPrice = 0;
			$(".qty-class").each(function() {
				qnty = qnty + parseInt($(this).text());
				price = $(this).parent().children(".hiddenPrice").val();
				$(this).parent().children(".hiddenQnty").val(parseInt($(this).text()));
				
				totalPrice = totalPrice + parseInt($(this).text()) * parseFloat(price);
				
			});
			
			$("#qntyCountInputTxt").val(qnty);
			$("#qntyCountInputLbl").text(qnty);


			$("#priceCountInputTxt").val(totalPrice);
			$("#priceCountInputLbl").text(totalPrice);			
		}
		
		calculateQty();

	});
</script>
</head>
<body>

	

	<!-- <div class="container-fluid padding">
	<div class="row welcome text-center">
		<div class="col-12">
			<h1 class="display-4">List of Products</h1>
		</div>
		<hr>
	</div>
</div>
 -->
<spring:url value="/fireworks/order" var="showConfirmOrderUrl" />
 <form:form method="post" action="${showConfirmOrderUrl}" modelAttribute="order">

 	<input type="hidden" name="phoneNumber" value="${order.phoneNumber}"/> 
    <input type="hidden" name="email" value="${order.email}"/> 
    <input type="hidden" name="id" value="${order.id}"/>
    <input type="hidden" name="statusCode" value="${order.statusCode}"/>
	<input type="hidden" name="orderId" value="${order.orderId}"/>

	<c:set var="itemsCounter" value="${0}"/>
	<div class="container-fluid padding">
		<c:forEach var="item" items="${productsMap}" varStatus="toploop">
		
		<div class="pb-2 mt-4 mb-2 border-bottom">
			<h5> ${item.key}</h5>
		</div>
		<div class="row row-padding">
		<c:forEach var="subItem" items="${item.value}"  varStatus="loop">
			<c:set var="itemsCounter" value="${itemsCounter + 1}" />
			<div class="col-12 col-sm-6 col-md-3 col-lg-3 ">
				<div class="card">
					<div class="card-body">

						<div class="float-left">
							<c:set var="nameParts" value="${fn:split(subItem.productName, ',')}" />
								<input type="hidden" name="orderLineItems[${itemsCounter}].productId" value="${subItem.productId}">
								
								<input type="hidden" name="orderLineItems[${itemsCounter}].productName" value="${subItem.productName}">
							<h4 class="card-text">${nameParts[0]} ${nameParts[1]} ${nameParts[2]}<br> ${nameParts[3]}</h4>
							
							<div style="font-size: 12px;">
								<span><i class="fa"	style="color: grey">&#xf156;</i> </span> <label class="price-class">${subItem.price}</label>
							</div>
						</div>

						<div class="rounded border border-grey quantity-padding float-right" >
							<button class="btn quantityBtnMinus" type="button">
								<i class="fa fa-minus" aria-hidden="true"
									style="color: grey; cursor: hand"></i>
							</button>
							<input type="hidden" class="hiddenPrice" name="orderLineItems[${itemsCounter}].price" value="${subItem.price}">
							<input type="hidden" name="orderLineItems[${itemsCounter}].quantity" class="hiddenQnty" value="${subItem.quantity}">
							
							<label class="qty-class">${subItem.quantity}</label>
							<button class="btn quantityBtnAdd" type="button">
								<i class="fa fa-plus" aria-hidden="true"
									style="color: #F26522; cursor: hand"></i>
							</button>
						</div>
			
					</div>
				</div>
			</div>
		
		</c:forEach>
		</div>
	</c:forEach>





</div>
<div class="buttonStyleRectangle1 btn-group btn-group-justified " role="group" aria-label="Justified button group" style="position: fixed; bottom: 0px;">
	<div class="float-left">
		<p>
			<input type="hidden" id="qntyCountInputTxt">
			<input type="hidden" id="priceCountInputTxt">
			<span id="qntyCountInputLbl"></span> Items | <span class="input-group-btn"><i class="fa"
				style="color: white">&#xf156;</i> </span> <span id="priceCountInputLbl">0</span>
		</p>
	</div>
	<div class="float-right">
		<a class="btn-success" href="javascript:$('form').submit()" role="button"><p>
				View Cart <i class="fa fa-shopping-cart"></i>
			</p></a>
	</div>
</div>
</form:form>



</body>



</html>







