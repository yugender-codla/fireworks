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
    
    .bodypadding{
    	margin-top: 1em;
    }
</style>
<script type="text/javascript">

    $(document).ready(function(){
    	
    	 $("label[required]").addClass("required");

    	 $(".backButton").click(function(){
 	
    		 showSpinButton();
    		 
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
						
						
						$(".paymentRadioClass").click(function() {
							var paymentImage = $(this).attr("lbl");
							$('.paymentImg').show();
							showOne(paymentImage);
						});
						
						function showOne(id) {
						   $('.paymentImg').not('#' + id).hide();
						    if(id=='yourUpiId'){
							   $('#defaultPayMsg').show(); 
						   } 
						}
						
						  $('#completeOrder').click(function() {
							  
							  var paymentType = $("input[name=paymentType]:checked").val();
							  var confirmText;
							  if(paymentType=='cash'){
								  confirmText = ' Payment Type: Cash\nAre you sure that you want to submit the order?';
							  }else{
								  confirmText = '\nPayment Type: '+paymentType+'. Please ensure payment is made within 1 hour for hassle-free delivery.\nAre you sure that you want to submit the order?';
							  }
							  
						    if (confirm('Total Amount:'+$("#netPriceCountOuputLbl").text()+confirmText)) {
						    	showSpinButton();
						    }else{
						    	return false;
						    }
						});
						
						
						function calculateQty() {
							var qnty = 0;
							var price = 0;
							var totalPrice = 0;
							$(".qty-class")
									.each(
											function() {
												qnty = qnty + parseInt($(this).text());
												price = $(this).parent().children(".hiddenPrice").val();
												$(this).parent().children(".hiddenQnty").val(parseInt($(this).text()));
												$(this).parent().parent().parent().children(".priceCountOuputLbl").html("<span><i class='fa' style='color: grey'>&#xf156;</i></span> "+(parseInt($(this).text()) * parseInt(price)));
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

						        
							/*** Date Calendar Set up***/	        
						        var MyDate = new Date();
						        var MyDateString;
						        MyDate.setDate(MyDate.getDate() + 3);

						        MyDateString = MyDate.getFullYear()+ '-'
						        			 + ('0' + (MyDate.getMonth()+1)).slice(-2) + '-'
						        			 + ('0' + MyDate.getDate()).slice(-2);
						        document.getElementById("deliverBy").setAttribute("min", MyDateString);
						        

					});
    
    
    function checkLoad()
	 {
	 	document.getElementById("spinButton").style.visibility = "hidden";
	 }
	 
    function showSpinButton(){
    	 showLoad();
  	  if(document.getElementById("spinButton")){
  	  		document.getElementById("spinButton").style.visibility = "visible";
    		}
  	  if(document.getElementById("spinButtonDown")){
  	  		document.getElementById("spinButtonDown").style.visibility = "visible";
  		}
    }
    
	 setInterval("checkLoad()",5000);
  
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

		
		<spring:url value="/fireworks/order/save" var="confirmOrderUrl" />
		<form:form method="post" action="${confirmOrderUrl}" modelAttribute="order" name="confirmationForm">
			<input type="hidden" name="id" value="${order.id}">
			<input type="hidden" name="statusCode" value="${order.statusCode}" />
			<input type="hidden" name="orderNumber" value="${order.orderNumber}" />

			<c:set var="netPrice" value="${0}" />

<div class="row" >			
	<div class="col-12 col-sm-12 col-md-5 col-lg-5 " >
	<div>
		 <div class="row" style="padding-top:0px">
	    	<div class="col-6" style="padding-top:0px"><h2>Cart</h2></div>
	    	<div class="col-6" style="padding-top:0px">
	    	 <div class="float-right" >
	    	 <%if(request.getHeader("User-Agent").indexOf("Mobile") != -1) { %>
	    	  <i class="fa fa-refresh fa-spin" id="spinButton" style="visibility:hidden"></i>
		    	 <a href="#" class="previous round backButton" style = "text-decoration: none;display: inline-block;padding: 8px 16px;">&#8249;</a>
	    	 <%} %>
	    	<!-- <button type="button" value="Back" id="backButtonTop"
						class="btn btn-secondary backButton">&laquo; Previous</button>
						-->
						</div> 
						</div>
	 	 </div>
			
			
			<div class="row row-padding">
				<div class="col-12 col-sm-12 col-md-12 col-lg-12">
					<div class="table-responsive showConfirmOrderCartItemsDiv">
						<table class="table tblTemplate showConfirmOrderCartItemsTbl">
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
											<td  style="width: 50%;vertical-align: top">
												<input type="hidden" name="orderLineItems[${loop.index}].category" value="${item.category}">
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
											<td style="width: 50%;vertical-align: top">${nameParts[0]}
												${nameParts[1]} ${nameParts[2]} ${nameParts[3]} 
											</td>
										</c:otherwise>
									</c:choose> 

									<td style="vertical-align: top;padding-top:20px">
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

									<td class="priceCountOuputLbl" style="text-align: left;vertical-align: top;padding-top:30px"><span><i class='fa' style='color: grey'>&#xf156;</i></span> ${item.quantity * item.price}</td>
									<c:set var="netPrice"
										value="${netPrice + (item.quantity * item.price)}" />

								</tr>
							</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
				
			</div>
			<div class="col-12 col-sm-12 col-md-12 col-lg-12" style="text-align:center;padding-top:0px;">
			Total: <b> <label id="cartItemsCountLbl">0</label></b> ITEMS | <b><span class="rupeesymbol"><i class="fa" >&#xf156;</i></span> <span id="netPriceCountOuputLbl">${netPrice}</span></b>
			</div> 
		</div>
		</div>
		<div class="col-12 col-sm-12 col-md-7 col-lg-7" >
		<h2 >Order Form</h2>
			
			<div class="row row-padding confimPgInputForm" >

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 ">
					<label class="" for="inputName" required>Name</label>
				</div>
				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<!-- <input type="text" class="form-control " name="custName"> -->
					<form:input path="custName" cssClass="form-control" maxlength="25"/>
					<form:errors path="custName" cssClass="error" />
				</div>

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 ">
					<label class="" for="inputEmail" required>Email</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<!-- <input type="email" name="email" class="form-control"
						id="inputEmail" > -->

					<form:input path="email" cssClass="form-control" id="inputEmail" maxlength="50"/>
					<form:errors path="email" cssClass="error" />
				</div>

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 ">
					<label class="" for="Phone Number" required>Phone </label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<!-- <input type="tel" class="form-control " name="phoneNumber"> -->
					<form:input path="phoneNumber" cssClass="form-control" maxlength="10"/>
					<form:errors path="phoneNumber" cssClass="error" />
				</div>

				<div class="col-4 col-sm-4 col-md-2 col-lg-2 " style="white-space:nowrap">
					<label class="" for="Deliver by" required>Deliver By</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<input id = "deliverBy" name="deliverBy" type="date" class="form-control" style="font-size:12px;"
						value="<fmt:formatDate pattern="yyyy-MM-dd" value="${order.deliverBy}" />">

					<form:errors path="deliverBy" cssClass="error" />
				</div>
				
				
				<div class="col-4 col-sm-4 col-md-2 col-lg-2 ">
					<label class="" for="Address" required>Address</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<form:textarea path="address" cssClass="form-control" id="inputAddress" maxlength="150" />
					<form:errors path="address" cssClass="error" />
				</div>
				
				<div class="col-4 col-sm-4 col-md-2 col-lg-2 ">
					<label class="" for="Notes">Notes</label>
				</div>

				<div class="col-8 col-sm-8 col-md-4 col-lg-4">
					<form:textarea path="notes" cssClass="form-control" id="inputAddress"  maxlength="150"/>
					<form:errors path="notes" cssClass="error" />
				</div>
				
				<div class="col-12 col-sm-12 col-md-12 col-lg-12" style="text-align:center;padding-top:10px;padding-bottom:0px;">
					<h4>Select a payment method <br></h4>
					<form:errors path="paymentType" cssClass="error" />
				</div>


				<div class="col-12 col-sm-12 col-md-3 col-lg-3" style="padding-bottom:0px;padding-right:5px;">
				<div class="row">
				<div class="col-6 col-sm-6 col-md-12 col-lg-12"  style="padding-bottom:0px">
					<form:radiobutton path="paymentType" value="PayTM" lbl="payTmImg" cssClass="paymentRadioClass"/> <img src="/images/Paytm_logo.png" style="width:50px;height:20px">
				</div>
				<div class="col-6 col-sm-6 col-md-12 col-lg-12"  style="padding-bottom:0px">
					<form:radiobutton path="paymentType" value="PhonePe" lbl="phonePayImg" cssClass="paymentRadioClass"/> <img src="/images/phonepeicon.jpeg" style="width:80px;height:30px">
				</div>
				<div class="col-6 col-sm-6 col-md-12 col-lg-12"  style="padding-bottom:0px">
					<form:radiobutton path="paymentType" value="GPay" lbl="tezImg" cssClass="paymentRadioClass"/> <img src="/images/gpayLogo1.png" style="width:50px;height:20px">
				</div>
				<div class="col-6 col-sm-6 col-md-12 col-lg-12"  style="padding-bottom:0px">
					<form:radiobutton path="paymentType" value="cash" lbl="defaultPayMsg" cssClass="paymentRadioClass"/><label class="" for="byCash"> By Cash</label>
				</div>
				<div class="col-6 col-sm-6 col-md-12 col-lg-12"  style="padding-bottom:0px">
					<form:radiobutton path="paymentType" value="UPI" lbl="yourUpiId" cssClass="paymentRadioClass"/><label class="" for="upi"> Your UPI ID</label>
				</div>
				</div>
				</div>
				
				<div class="col-12 col-sm-12 col-md-9 col-lg-9" style="valign:middle;text-align: left;align-content: left;padding-left:0px;padding-bottom:0px;">
				<div class="paymentInputTxtBox float-center"><span id="yourUpiId" class="paymentImg" style="display:none;"><form:input path="customerPaymentCode" cssClass="form-control" cssStyle="width:150px;font-size:14px" maxlength="25" placeholder="Enter your UPI ID"/> (We will send you<br>a payment request)</span></div>
				<span id="payTmImg" class="paymentImg" style="display:none"><img src="/images/paytm.jpeg" style="width:200px;height:200px"> <br><b>9841363614@paytm</b> </span>
					<span id="phonePayImg" class="paymentImg" style="display:none"><img src="/images/phonepeqrCode.jpeg" style="width:200px;height:200px"> <br><b>9841363614@ybl</b> </span>
					<span id="tezImg" class="paymentImg" style="display:none"><img src="/images/Gpay.jpeg" style="width:200px;height:200px"> <br><b>dilipindia6@okaxis</b> </span>
				<span id="defaultPayMsg" class="paymentImg" >
				<img src="/images/secure-payments.png" style="width:100px;height:100px">
				</span>
				
				
				</div>
				
				<%-- <div class="col-3 col-sm-3 col-md-3 col-lg-3">
					<form:radiobutton path="paymentType" value="payTM" lbl="payTmImg" cssClass="paymentRadioClass"/> <img src="/images/Paytm_logo.png" style="width:50px;height:20px">
				</div>
				
				<div class="col-3 col-sm-3 col-md-3 col-lg-3">
					<form:radiobutton path="paymentType" value="phonepe" lbl="phonePayImg" cssClass="paymentRadioClass"/> <img src="/images/phonePayLogo.png" style="width:80px;">
	
				</div>
				
				<div class="col-3 col-sm-3 col-md-3 col-lg-3">
					<form:radiobutton path="paymentType" value="tez" lbl="tezImg" cssClass="paymentRadioClass"/> <img src="/images/gpayLogo1.png" style="width:50px;height:20px">
				</div>
				
				<div class="col-3 col-sm-3 col-md-3 col-lg-3">
				<form:radiobutton path="paymentType" value="cash" lbl="cash" cssClass="paymentRadioClass"/><label class="" for="byCash"> By Cash</label>
				</div>
				
				<div class="col-12 col-sm-12 col-md-12 col-lg-12" style="text-align:center;height:100px;valign:middle;padding-top:5px;padding-bottom: 40px;font-family: Open Sans">
					<span id="payTmImg" class="paymentImg" style="display:none"><img src="/images/paytm.jpeg" style="width:200px;height:200px"> OR <b>9841363614@paytm</b> OR </span>
					<span id="phonePayImg" class="paymentImg" style="display:none"><img src="/images/phonepeqrCode.jpeg" style="width:200px;height:200px"> OR <b>9841363614@ybl</b> OR </span>
					<span id="tezImg" class="paymentImg" style="display:none"><img src="/images/Gpay.jpeg" style="width:200px;height:200px"> OR <b>dilipindia6@okaxis</b> OR </span>
					
				</div> 
				</div>--%>
								
			</div>
			
			 <div class="row row-padding" style="text-align: center;padding-top:0px">
				<div class="col-12 col-sm-12 col-md-12 col-lg-12">
				<span style="color:red;font-size:11px"> ${minimumValueOrderMessage}</span>
				<i class="fa fa-refresh fa-spin" id="spinButtonDown" style="visibility:hidden"></i>
					<button type="button" value="Back" id="backButton"
						class="btn btn-secondary backButton">&laquo; Previous</button>
					<button id="completeOrder" type="submit" value="Order Now" class="btn" style="padding:7px;border-radius: 6px;background-color: #F26522;color:#ffffff" ">
						Complete Order</button>
					
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