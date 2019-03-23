<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Confirmation Page</title>

<script type="text/javascript">

    $(document).ready(function(){
    	
    	 $("#backButton").click(function(){
             document.confirmationForm.action = "<%=request.getContextPath()%>/order/backToShowProducts";
					});
    	 
    	 
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
				qnty = parseInt($(this).text());
				price = $(this).parent().children(".hiddenPrice").val();
				$(this).parent().children(".hiddenQnty").val(parseInt($(this).text()));
				$(this).parent().parent().parent().children(".priceCountOuputLbl").text((qnty * parseFloat(price)).toFixed(2));
				totalPrice = totalPrice + parseInt($(this).text()) * parseFloat(price);
			});
			
			$("#netPriceCountOuputLbl").text(totalPrice.toFixed(2));			
		}
 		
    	 
		});
</script>


</head>
<body>
	<div class="container bodypadding">

		<c:if test="${not empty msg}">
			<div class="alert alert-${css} alert-dismissible" role="alert">
				<button type="button" class="close" data-dismiss="alert"
					aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
				<strong>${msg}</strong>
			</div>
		</c:if>

		<h5>Bill Details</h5>
		<hr>
		<spring:url value="/order/confirmOrder" var="confirmOrderUrl" />
		<form:form method="post" action="${confirmOrderUrl}"
			modelAttribute="order" name="confirmationForm">

			<c:set var="netPrice" value="${0}" />
			<div class="row row-padding">
				<div class="col-12 col-sm-12 col-md-12 col-lg-12">
					<div class="table-responsive-md">
						<table class="table tblTemplate">
							<thead>
								<tr>
									<th>Name</th>
									<th>Qty</th>
									<th>Total</th>
									
								</tr>
							</thead>

							<c:forEach var="item" items="${order.orderLineItems}"
								varStatus="loop">
								<c:set var="nameParts"
									value="${fn:split(item.productName, ',')}" />
								<tr>
									<td style="width:40%">${nameParts[0]}<br> ${nameParts[1]}
										${nameParts[2]} ${nameParts[3]}</td>
									<td style="width:9em;">
										<div class="rounded border border-grey quantity-padding" >
											<button class="btn quantityBtnMinus" type="button">
												<i class="fa fa-minus qtyBtnGeneral" aria-hidden="true"
													style="color: grey; cursor: hand"></i>
											</button>
												<input type="hidden" name="orderLineItems[${loop.index}].productId"	value="${item.productId}">
												<input type="hidden" class="hiddenPrice" name="orderLineItems[${loop.index}].price"	value="${item.price}">
												<input type="hidden" class="hiddenQnty" name="orderLineItems[${loop.index}].quantity"	value="${item.quantity}">
											<label class="qty-class qtyBtnGeneral">${item.quantity}</label>
											<button class="btn quantityBtnAdd" type="button">
												<i class="fa fa-plus qtyBtnGeneral" aria-hidden="true"
													style="color: #F26522; cursor: hand;"></i>
											</button>
										</div>
									</td>
									
									<td class="priceCountOuputLbl" style="text-align: left">${item.quantity * item.price}</td>
									<c:set var="netPrice"
										value="${netPrice + (item.quantity * item.price)}" />
								  
								</tr>
							</c:forEach>
							<tfoot>
								<tr>
									<th colspan="2">Total</th>
									<th colspan="1"><span class="rupeesymbol"><i class="fa" >&#xf156;</i></span> <span id="netPriceCountOuputLbl">${netPrice}</span> </th>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div>

			<div class="row row-padding confimPgInputForm">
				<div class="col-4 col-sm-4 col-md-2 col-lg-2 align-right">
					<label class="" for="inputEmail">Email</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<input type="email" name="email" class="form-control"
						id="inputEmail" >
				</div>

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 align-right">
					<label class="" for="Phone Number">Phone </label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<input type="text" class="form-control " name="phoneNumber"
						>
				</div>

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 align-right">
					<label class="" for="Deliver by">Deliver by</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<input name="deliverBy" type="date" class="form-control">
				</div>
				
			</div>
			<div class="row row-padding" style="text-align: center;">
				<div class="col-12 col-sm-12 col-md-12 col-lg-12">
					<button type="submit" value="Back" id="backButton" class="btn btn-secondary">Back</button>
					<button type="submit" value="Confirm Order" class="btn btn-success"> Confirm Order</button>
				</div>
			</div>
			
			<%-- <label for="Phone Number">Phone No: </label>
			<form:input path="phoneNumber" />
			<label for="Email">Email: </label>
			<form:input path="email" />
			<label for="date">Deliver by: </label>
			<input name="deliverBy" type="date">
			<br>
			<br> --%>

				
					
					 
			
		</form:form>
	</div>


	<%-- <div class="form-inline ">
				<div class="form-group">
					<label class="control-label col-sm-2" for="Phone Number">Phone
						No:</label>
					<div class="col-sm-10">
						<form:input path="phoneNumber" cssClass="form-control" />
					</div>

					<label class="control-label col-sm-2" for="email">Email:</label>
					<div class="col-sm-10">
						<form:input path="email" cssClass="form-control" />
					</div>


					<label class="control-label col-sm-2" for="Deliver by">Deliver
						by:</label>
					<div class="col-sm-10">
						<input name="deliverBy" type="date" class="form-control">
					</div>
				</div>
			</div> --%>



</body>
</html>