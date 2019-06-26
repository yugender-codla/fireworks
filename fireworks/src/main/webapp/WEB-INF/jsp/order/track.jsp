<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<html>

<head>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, shrink-to-fit=no">
<title>4aplhas</title>
<link rel="stylesheet" href="/assets/css/Contact-Form-Clean.css">

<link rel="stylesheet" href="/assets/css/Table-With-Search-1.css">
<link rel="stylesheet" href="/assets/css/Table-With-Search.css">


<script>

$(document).ready(function(){
	var infoModal = $('#myModal');
	
	 $(".trackOrderDetails").click(function(event){
		 event.preventDefault();
		 infoModal.find('.modal-body').html($(this).next().html());
		 infoModal.modal('show');
		 
	 });
});  





</script>
</head>

<body>
	<div class="contact-clean" style="height: 362px;">
		<spring:url value="/fireworks/track" var="trackOrderUrl" />
		<form:form method="post" style="height: 253px;"
			action="${trackOrderUrl}" modelAttribute="order" name="searchForm">
			<h2 class="text-center">Track Your Order</h2>
			<div class="form-group">
				<input class="form-control" type="text" name="phoneNumber"
					placeholder="Order Number" id="phoneNumber" name="phoneNumber"
					value="${phoneNumber}">
			</div>
			<div class="form-group">
				<button class="btn btn-primary" type="submit">search</button>
			</div>
		</form:form>
	</div>




	<div class="container">
		<div class="table-responsive-md">
		<c:if test="${fn:length(orders) gt 0}">
			<table class="table">
				<thead>
					<tr>
						<th>Order Id</th>
						<th>Deliver By</th>
						<th>Net Amount</th>
						<th>Status</th>

					</tr>
				</thead>

				<c:forEach var="item" items="${orders}" varStatus="loop">

					<tr>
						<td><a class="trackOrderDetails" href="#">${item.orderId}</a>
							<div style="display: none">
								<table class="table table-bordered">
									<thead>
										<tr>
											<th>Product Name</th>
											<th>Quantity</th>
											<th>Price</th>
										</tr>
									</thead>
									<tbody class="mdlTbody">
										<c:forEach var="subItem" items="${item.orderLineItems}"
											varStatus="subLoop">
											<tr>
												<td>${subItem.productName}</td>

												<td>${subItem.quantity}</td>

												<td>${subItem.quantity * subItem.price}</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div></td>

						<td>${item.deliverByUI}</td>

						<td>${item.priceOfTheOrder}</td>

						<td>${item.status}</td>
					</tr>
				</c:forEach>
			</table>
			</c:if>
		</div>

		</section>




	</div>


	<div class="modal fade" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">
						<span id="mdlInvoiceId">Order Details: </span>
					</h4>
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>



				</div>
				<div class="modal-body"></div>
				<!-- <div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div> -->
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->



	</div>
</body>

</html>