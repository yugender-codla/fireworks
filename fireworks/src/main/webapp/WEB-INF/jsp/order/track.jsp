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


<script>
function callAction(id,obj){
	document.getElementById("orderId").value=id;
	document.getElementById("event").value=obj.value;
	document.getElementById("searchCriteria").value="orderId";
	document.getElementById("searchValue").value=id;
	alert(obj.id);
	document.getElementById("orderNo").value=obj.id;
	
	document.forms[1].action = "/fireworks/order/modifyStatus";
	document.forms[1].method="post";
	document.forms[1].submit();

}


$(document).ready(function(){
	var infoModal = $('#myModal');
	
	 $(".trackOrderDetails").click(function(event){
		 event.preventDefault();
		 infoModal.find('.modal-body').html($(this).next().html());
		 infoModal.modal('show');
		 
	 });
	 
			var infoModal = $('#myModal');
			 $(".view-button").click(function(event){
				 event.preventDefault();
				 var url = $(this).attr("id");
				 var htmlHeadString = "<div> <table class='table table-bordered'>	<thead>	<tr><th>Product Name</th><th>New</th><th>Old</th></tr></thead><tbody class='mdlTbody'>";
				 var htmlFootString = "</tbody></table></div>";

				 $.ajax({
			            type: 'GET',
			            url: url,
			            dataType: 'json',
			            success: function (output) {
			            	
			            	var lineItemsLength = output.length;
							var row = "";
							var tFootContent = "";
							var qty1 = "";
			            	for(var i=0;i<lineItemsLength;i++){
			            		qty1 = "-";
			            		qty2 = "-";
			            		
			            		if(output[i].qty1 != null){
			            			qty1 = output[i].qty1;
			            		}
			            		
			            		if(output[i].qty2 != null){
			            			qty2 = output[i].qty2;
			            		}
			            		 row = row + "<tr><td>"+output[i].productName+"</td><td>"+qty1+"</td><td>"+qty2+"</td></tr>";
			            	}
			            	
			            	var fullString = htmlHeadString + row + htmlFootString;
			            	
			            	infoModal.find('.modal-body').html(fullString);
		            		infoModal.modal('show');
			            	//$('#myModal').modal('toggle');
			            },
			            error: function(output){
			            alert("fail");
			            }
			        });
				 
				 
				 
			     });
	
});  






</script>
</head>

<body>
	<div class="contact-clean" style="height: 362px;">
		<spring:url value="/fireworks/order/track" var="trackOrderUrl" />
		<form:form method="get" style="height: 253px;"
			action="${trackOrderUrl}" modelAttribute="order" name="searchForm">
			<h2 class="text-center">Track Your Order</h2>
			<div class="form-group">
				<input class="form-control" type="text" name="orderNumber"
					placeholder="Order Number" id="orderNumber" name="orderNumber"
					value="${orderNumber}">
			</div>
			<div class="form-group">
				<button class="btn btn-primary" type="submit">search</button>
			</div>
		</form:form>
	</div>




	<div class="container">
	<form>
		<div class="table-responsive-md">
		<c:if test="${fn:length(orders) gt 0}">
			<table class="table">
				<thead>
					<tr>
						<th>Order Id</th>
						<th>Name</th>
						<th>Deliver By</th>
						<th>Net Amount</th>
						<th>Status</th>
					<!-- 	<th>Action</th> -->
					</tr>
				</thead>

				<c:forEach var="item" items="${orders}" varStatus="loop">

					<tr>
						<td><a class="trackOrderDetails" href="#" target="_blank">${item.orderNumber}</a>
							<div style="display: none">
							<table class="table table-bordered">
							<tr><td>
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
												<td>${subItem.productName}
												<c:if test="${fn:length(subItem.orderComboLineItems) gt 0}">
												<ul>
												<c:forEach var="comboItem" items="${subItem.orderComboLineItems}" varStatus="comboLoop">
												<c:set var="nameParts"
												value="${fn:split(comboItem.productComboLineItemData, '|')}" />
													 <li>${nameParts[1]} (${nameParts[2]})</li>
												</c:forEach>
												</ul>
												</c:if>
												</td>

												<td>${subItem.quantity}</td>

												<td>${subItem.quantity * subItem.price}</td>
											</tr>
										</c:forEach>
											<tr>
											<td>Net Price
											</td>
											<td colspan="2">Rs. ${item.netPrice}
											</td>
											</tr>
											
									</tbody>
								</table>
								</td></tr>
								<tr>
								<td>
								<div>
									<p>
									Order #: ${item.orderNumber}<br>
									<b>Delivery Address:</b><br>
										Mr/Ms. ${item.custName}<br>
										${item.phoneNumber}<br>
										${item.address}<br>
										Payment Type: ${item.paymentType}
										
									</p>
								</div>
								
								</td>
								</tr>
								</table>
							</div></td>
							<td>${item.custName}</td>

						<td>${item.deliverByUI}</td>

						<td>${item.priceOfTheOrder}</td>

						<td>${item.status}</td>
					<%-- 	
						<td>
						<spring:url value="/fireworks/order/${item.id}/review" var="reviewUrl" />
							<c:if test="${item.statusCode == '103'}">
				  				<button style="font-size:10px;width:25px" type="button" value ="USER_APPROVE_ORDER" id="${item.orderNumber}" onclick ="callAction(${item.id},this)" title="APPROVE ORDER">A</button>
				  			</c:if>
						<c:if test="${item.modifiedFlag == 'Y'}">
				  			<button class="view-button" id="${reviewUrl}" type ="button" style="font-size:10px;width:25px" title="View">R</button>
				  		</c:if>
						</td> --%>
					</tr>
				</c:forEach>
			</table>
			</c:if>
		</div>
		
		<input type="hidden" name="orderId" id="orderId">
		<input type="hidden" name="event" id="event">
		<input type="hidden" name="orderNumber" id="orderNo">
		
		<input type="hidden" name="searchCriteria" id="searchCriteria">
		<input type="hidden" name="searchValue" id="searchValue">
		<input type="hidden" name="page" value="orderTracker">
</form>

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




</body>

</html>