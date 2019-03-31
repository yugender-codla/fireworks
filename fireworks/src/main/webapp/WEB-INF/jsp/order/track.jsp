<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Track Order</title>


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

		<h5>Track Order</h5>
		<hr>

		<section>
			<spring:url value="/order/track" var="trackOrderUrl" />
			<form:form method="post" action="${trackOrderUrl}"
				modelAttribute="order" name="searchForm" class="form-inline">

				<label for="phoneNumber">Phone Number:</label>
				<input type="text" class="form-control" id="phoneNumber"
					name="phoneNumber" value="${phoneNumber}">


				<button type="submit" class="btn btn-primary">Track</button>
			</form:form>
		</section>
		<br> <br>
		<section>

			<div class="table-responsive-md">
				<table class="table table-fixed">
					<thead>
						<tr>
							<th class="col-3">Order Id</th>
							<th class="col-3">Deliver By</th>
							<th class="col-3">Net Amount</th>
							<th class="col-3">Status</th>

						</tr>
					</thead>
					
					<c:forEach var="item" items="${orders}" varStatus="loop">
					
						<tr>
							<td class="col-3">
							<a class="trackOrderDetails" href="#">${item.id}</a>
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
													<td >${subItem.productName}</td>
												
													<td >${subItem.quantity}</td>
												
													<td>${subItem.quantity * subItem.price}</td>
												</tr>
										</c:forEach>
										</tbody>
										</table>
								</div></td>

							<td class="col-3">${item.deliverByUI}</td>

							<td class="col-3">${item.priceOfTheOrder}</td>

							<td class="col-3">Received ${item.status}</td>
						</tr>
					</c:forEach>
				</table>
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
				<div class="modal-body">
					
				</div>
				<!-- <div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div> -->
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- /.modal -->

</body>
</html>