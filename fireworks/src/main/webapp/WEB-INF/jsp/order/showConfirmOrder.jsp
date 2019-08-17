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
<style>
 .bs-example{
        margin: 20px;
    }
    .accordion .fa{
        margin-right: 0.5rem;
    }
</style>
<script type="text/javascript">

    $(document).ready(function(){
    	
    	 $("#backButton").click(function(){
             document.confirmationForm.action = "<%=request.getContextPath()%>/fireworks/order/back";
             document.confirmationForm.submit();
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

						function calculateQty() {
							var qnty = 0;
							var price = 0;
							var totalPrice = 0;
							$(".qty-class")
									.each(
											function() {
												qnty = qnty + parseInt($(this).text());
												price = $(this).parent().children(".hiddenPrice")
														.val();
												$(this).parent()
														.children(".hiddenQnty")
														.val(parseInt($(this).text()));
												$(this).parent().parent()
														.parent().children(".priceCountOuputLbl")
														.html("<span><i class='fa' style='color: grey'>&#xf156;</i></span> "+(qnty * parseFloat(price)));
												totalPrice = totalPrice + parseInt($(this).text()) * parseFloat(price);
											});

							$("#netPriceCountOuputLbl").text(totalPrice);
							$("#cartItemsCountLbl").text(qnty);
						}
						
						
						
						
						
						// Add minus icon for collapse element which is open by default
						        $(".collapse.show").each(function(){
						        	$(this).prev(".card-header").find(".fa").addClass("fa-minus").removeClass("fa-plus");
						        });
						        
						        // Toggle plus minus icon on show hide of collapse element
						        $(".collapse").on('show.bs.collapse', function(){
						        	$(this).prev(".card-header").find(".fa").removeClass("fa-plus").addClass("fa-minus");
						        }).on('hide.bs.collapse', function(){
						        	$(this).prev(".card-header").find(".fa").removeClass("fa-minus").addClass("fa-plus");
						        });
						  
						        calculateQty();

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
		<spring:url value="/fireworks/order/save" var="confirmOrderUrl" />
		<form:form method="post" action="${confirmOrderUrl}"
			modelAttribute="order" name="confirmationForm">
			<input type="hidden" name="id" value="${order.id}">
			<input type="hidden" name="statusCode" value="${order.statusCode}" />
			<input type="hidden" name="orderNumber" value="${order.orderNumber}" />

			<c:set var="netPrice" value="${0}" />

<div class="row" >			
	<div class="col-5 col-sm-5 col-md-5 col-lg-5 middleContent" >
	<div >
			<h2>Cart</h2>
			
			<b><label id="cartItemsCountLbl">0</label></b> ITEMS | <b><span class="rupeesymbol"><i class="fa" >&#xf156;</i></span> <span id="netPriceCountOuputLbl">${netPrice}</span></b> 

			
			<div class="row row-padding">
				<div class="col-12 col-sm-12 col-md-12 col-lg-12">
					<div class="table-responsive showConfirmOrderCartItemsDiv">
						<table class="table tblTemplate showConfirmOrderCartItemsTbl" style="border-right:1px solid #f3f3f3">
						<thead>
								<tr>
									<th  style="width: 50%">Name</th>
									<th>Qty</th>
									<th>Total</th>

								</tr>
							</thead>
							<tbody class="cartItems">
							<c:forEach var="item" items="${order.orderLineItems}"
								varStatus="loop">
								<c:set var="nameParts"
									value="${fn:split(item.productName, ',')}" />
								<tr>
									
								 	<c:choose>
										<c:when test="${item.category == 'Combo'}">
											<td  style="width: 50%">
												
	<div class="accordion" id="accordionExample-${loop.index}">
        <div class="card" style="margin-left: 0px;padding-left: 0px;">
            <div class="card-header" id="headingOne-${loop.index}" style="background-color: #fff;border-color: #fff;padding-left: 0px;">
              		<span data-toggle="collapse" data-target="#collapseOne-${loop.index}" style="cursor: pointer;"><i class="fa fa-plus"></i>${nameParts[0]}
												${nameParts[1]} ${nameParts[2]} ${nameParts[3]}
              		</span>
            </div>
            <div id="collapseOne-${loop.index}" class="collapse " aria-labelledby="headingOne-${loop.index}" data-parent="#accordionExample-${loop.index}">
                <div class="card-body comboLineItemDiv" style="font-size:12px">
                     <p> 	<c:set var="comboLineItemCounter" value="${0}" />
                     <c:forEach var="orderComboLineItem" items="${item.orderComboLineItems}" varStatus="comboLoop">
                     	
                     	<c:set var="comboNameParts"	value="${fn:split(orderComboLineItem.productComboLineItemData, '|')}" />
                     	${comboLineItemCounter+1}] ${comboNameParts[1]} (${comboNameParts[2]})
                     	<input type="hidden" name="orderLineItems[${loop.index}].orderComboLineItems[${comboLineItemCounter}].productComboLineItemData" value="${orderComboLineItem.productComboLineItemData}">
                     	 <br>
                     	  <c:set var="comboLineItemCounter" value="${comboLineItemCounter + 1}" />
					 </c:forEach>
                    
                    
                </div>
            </div>
        </div>
        </div>
												
											</td>
										
										</c:when>
										<c:otherwise>
											<td style="width: 50%">${nameParts[0]}
												${nameParts[1]} ${nameParts[2]} ${nameParts[3]} ab
											</td>
										</c:otherwise>
									</c:choose> 

									<td>
										<div class="rounded border border-grey quantity-padding" style="width:70px;">
											<button class="btn quantityBtnMinus" type="button">
												<i class="fa fa-minus qtyBtnGeneral" aria-hidden="true"
													style="color: grey; cursor: hand"></i>
											</button>
												<input type="hidden" name="orderLineItems[${loop.index}].productId" value="${item.productId}"> 
												<input type="hidden" class="hiddenPrice" name="orderLineItems[${loop.index}].price" value="${item.price}"> 
												<input type="hidden" class="hiddenQnty" name="orderLineItems[${loop.index}].quantity" value="${item.quantity}"> 
												<input type="hidden" name="orderLineItems[${loop.index}].productName" value="${item.productName}"> 
												
												
												<label
												class="qty-class qtyBtnGeneral">${item.quantity}</label>
											<button class="btn quantityBtnAdd" type="button">
												<i class="fa fa-plus qtyBtnGeneral" aria-hidden="true"
													style="color: #F26522; cursor: hand;"></i>
											</button>
										</div>
									</td>

									<td class="priceCountOuputLbl" style="text-align: left"><span><i class='fa' style='color: grey'>&#xf156;</i></span> ${item.quantity * item.price}</td>
									<c:set var="netPrice"
										value="${netPrice + (item.quantity * item.price)}" />

								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				
			</div>
		</div>
		</div>
		<div class="col-7 col-sm-7 col-md-7 col-lg-7" >
		<h2 >Register Form</h2>
			
			<div class="row row-padding confimPgInputForm" >

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 align-right">
					<label class="" for="inputName">Name</label>
				</div>
				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<!-- <input type="text" class="form-control " name="custName"> -->
					<form:input path="custName" cssClass="form-control" />
					<form:errors path="custName" cssClass="error" />
				</div>

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 align-right">
					<label class="" for="inputEmail">Email</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<!-- <input type="email" name="email" class="form-control"
						id="inputEmail" > -->

					<form:input path="email" cssClass="form-control" id="inputEmail" />
					<form:errors path="email" cssClass="error" />
				</div>

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 align-right">
					<label class="" for="Phone Number">Phone </label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<!-- <input type="tel" class="form-control " name="phoneNumber"> -->
					<form:input path="phoneNumber" cssClass="form-control" />
					<form:errors path="phoneNumber" cssClass="error" />
				</div>

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 align-right">
					<label class="" for="Deliver by">Deliver by</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<input name="deliverBy" type="date" class="form-control" style="font-size:12px;"
						value="<fmt:formatDate pattern="yyyy-MM-dd" value="${order.deliverBy}" />">

					<form:errors path="deliverBy" cssClass="error" />
				</div>
				
				<div class="col-4 col-sm-4 col-md-2 col-lg-2 align-right">
					<label class="" for="Address">Address</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<form:textarea path="address" cssClass="form-control" id="inputAddress" />
					<form:errors path="address" cssClass="error" />
				</div>
				
				<div class="col-4 col-sm-4 col-md-2 col-lg-2 align-right">
					<label class="" for="Notes">Notes to 4Alphas</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<form:textarea path="notes" cssClass="form-control" id="inputAddress" />
					<form:errors path="notes" cssClass="error" />
				</div>

			</div>
			
			<div class="row row-padding" style="text-align: center;">
				<div class="col-12 col-sm-12 col-md-12 col-lg-12">
					<button type="button" value="Back" id="backButton"
						class="btn btn-primary"><- Back</button>
					<button type="submit" value="Confirm Order" class="btn btn-primary">
						Confirm Order</button>
				</div>
			
			</div>
			</div>
			
				</div>
		</form:form>
	</div>
			
			
			
			
			<%-- <div class="row row-padding">
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
									
								 	<c:choose>
										<c:when test="${item.category == 'Combo'}">
											<td style="width: 40%">
												
	<div class="accordion" id="accordionExample-${loop.index}">
        <div class="card" style="margin-left: 0px;padding-left: 0px;">
            <div class="card-header" id="headingOne-${loop.index}" style="background-color: #fff;border-color: #fff;padding-left: 0px;">
              		<span data-toggle="collapse" data-target="#collapseOne-${loop.index}" style="cursor: pointer;"><i class="fa fa-plus"></i>${nameParts[0]}
												${nameParts[1]} ${nameParts[2]} ${nameParts[3]}
              		</span>
            </div>
            <div id="collapseOne-${loop.index}" class="collapse " aria-labelledby="headingOne-${loop.index}" data-parent="#accordionExample-${loop.index}">
                <div class="card-body comboLineItemDiv" style="font-size:12px">
                     <p> 	<c:set var="comboLineItemCounter" value="${0}" />
                     <c:forEach var="orderComboLineItem" items="${item.orderComboLineItems}" varStatus="comboLoop">
                     	
                     	<c:set var="comboNameParts"	value="${fn:split(orderComboLineItem.productComboLineItemData, '|')}" />
                     	${comboLineItemCounter+1}] ${comboNameParts[1]} (${comboNameParts[2]})
                     	<input type="hidden" name="orderLineItems[${loop.index}].orderComboLineItems[${comboLineItemCounter}].productComboLineItemData" value="${orderComboLineItem.productComboLineItemData}">
                     	 <br>
                     	  <c:set var="comboLineItemCounter" value="${comboLineItemCounter + 1}" />
					 </c:forEach>
                    
                    
                </div>
            </div>
        </div>
        </div>
												
											</td>
										
										</c:when>
										<c:otherwise>
											<td style="width: 40%">${nameParts[0]}
												${nameParts[1]} ${nameParts[2]} ${nameParts[3]}
											</td>
										</c:otherwise>
									</c:choose> 

									<td style="width: 9em;">
										<div class="rounded border border-grey quantity-padding" style="width:70px;">
											<button class="btn quantityBtnMinus" type="button">
												<i class="fa fa-minus qtyBtnGeneral" aria-hidden="true"
													style="color: grey; cursor: hand"></i>
											</button>
											<input type="hidden"
												name="orderLineItems[${loop.index}].productId"
												value="${item.productId}"> <input type="hidden"
												class="hiddenPrice"
												name="orderLineItems[${loop.index}].price"
												value="${item.price}"> <input type="hidden"
												class="hiddenQnty"
												name="orderLineItems[${loop.index}].quantity"
												value="${item.quantity}"> <input type="hidden"
												class="hiddenQnty"
												name="orderLineItems[${loop.index}].productName"
												value="${item.productName}"> <label
												class="qty-class qtyBtnGeneral">${item.quantity}</label>
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
									<th colspan="1"><span class="rupeesymbol"><i
											class="fa">&#xf156;</i></span> <span id="netPriceCountOuputLbl">${netPrice}</span>
									</th>
								</tr>
							</tfoot>
						</table>
					</div>
				</div>
			</div> --%>


			<!-- 
			<div class="row row-padding" style="text-align: center;">
				<div class="col-12 col-sm-12 col-md-12 col-lg-12">
					<button type="button" value="Back" id="backButton"
						class="btn btn-primary"><- Back</button>
					<button type="submit" value="Confirm Order" class="btn btn-primary">
						Confirm Order</button>
				</div>
			</div> -->
		


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