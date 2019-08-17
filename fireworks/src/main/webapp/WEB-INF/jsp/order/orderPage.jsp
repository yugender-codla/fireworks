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
				
				 $("#divQtyAddBtnPanel-"+this.id.substring(this.id.indexOf('-')+1,this.id.length)).hide();
				 
					if(parseInt($(this).text()) == parseInt(0)){
						
					 $("#divQtyBtnPanel-"+this.id.substring(this.id.indexOf('-')+1,this.id.length)).hide();
					 $("#divQtyAddBtnPanel-"+this.id.substring(this.id.indexOf('-')+1,this.id.length)).show();
					 
					}
			});
			
			$("#qntyCountInputTxt").val(qnty);
			$("#qntyCountInputLbl").text(qnty);


			$("#priceCountInputTxt").val(totalPrice);
			$("#priceCountInputLbl").text(totalPrice);			
		}
		
		calculateQty();

		
		var infoModal = $('#myModal');
		
		 $(".view-button").click(function(event){
			 event.preventDefault();
			 var url = $(this).attr("id");
			 var htmlHeadString = "<div> <table class='table table-bordered'><tbody class='mdlTbody'>";
			 var htmlFootString = "</tbody></table></div>";
			 $.ajax({
		            type: 'GET',
		            url: url,
		            dataType: 'json',
		            success: function (output) {
		            	var lineItemsLength = output.length;
		            
						var row = "";
						var tFootContent = "";
		            	for(var i=0;i<lineItemsLength;i++){
		            	
		            		 row = row + "<tr><td>"+output[i].pid1+ "</td></tr>";
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
		 
		 
		 $(".divQtyAddBtnPanel").click(function(){
			 $(this).hide();
			 $("#divQtyBtnPanel-"+this.id.substring(this.id.indexOf('-')+1,this.id.length)).show(400);
			 $("#btnAdd-"+this.id.substring(this.id.indexOf('-')+1,this.id.length)).click();
		 });
		 
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
	});
</script>

<style>
.middleContent{
padding-top:5em;
}
</style>
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
<spring:url value="/fireworks/order/cart" var="showConfirmOrderUrl" />
 <form:form method="post" action="${showConfirmOrderUrl}" modelAttribute="order">

 	<input type="hidden" name="phoneNumber" value="${order.phoneNumber}"/> 
    <input type="hidden" name="email" value="${order.email}"/> 
    <input type="hidden" name="id" value="${order.id}"/>
    <input type="hidden" name="statusCode" value="${order.statusCode}"/>
	<input type="hidden" name="orderNumber" value="${order.orderNumber}"/>

	<c:set var="itemsCounter" value="${0}"/>
	<div class="container-fluid padding middleContent">
		<c:forEach var="item" items="${productsMap}" varStatus="toploop">
		
		<div class="pb-2 mt-4 mb-2 border-bottom">
			<h5> ${item.key}</h5>
		</div>
		<div class="row row-padding">
		<c:forEach var="subItem" items="${item.value}"  varStatus="loop">
			<c:set var="itemsCounter" value="${itemsCounter + 1}" />
			<c:set var="comboLineItemCounter" value="${0}" />
			<spring:url value="/firesupport/product/${subItem.productId}/viewCombo" var="viewUrl" />
			<div class="col-12 col-sm-6 col-md-3 col-lg-3" style="padding-bottom:0px;">
				<div class="card">
					<div class="card-body">

						<div class="float-left">
							<c:set var="nameParts" value="${fn:split(subItem.productName, ',')}" />
								<input type="hidden" name="orderLineItems[${itemsCounter}].productId" value="${subItem.productId}">
								
								<input type="hidden" name="orderLineItems[${itemsCounter}].productName" value="${subItem.productName}">
								 <input type="hidden" name="orderLineItems[${itemsCounter}].category" value="${item.key}">
							<h3 class="card-text">
							<c:choose>
												<c:when test="${item.key == 'Combo'}">
											
												<div class="accordion " id="accordionExample-${subItem.productId}">
											        <div class="card " style="margin-left: 0px;padding-left: 0px;">
											            <div class="card-header" id="headingOne-${subItem.productId}" style="background-color: #fff;border-color: #fff;padding-left: 0px;color:#F26522"">
											              		<span data-toggle="collapse" data-target="#collapseOne-${subItem.productId}" style="cursor: pointer;"><i class="fa fa-plus"></i> ${nameParts[0]}
											              		</span>
											            </div>
											              
											             <div id="collapseOne-${subItem.productId}" class="collapse comboLineItemDiv" aria-labelledby="headingOne-${loop.index}" data-parent="#accordionExample-${subItem.productId}">
											                <div class="card-body comboLineItemDiv">
											                
											                    <c:forEach var="comboLineItem" items="${subItem.productComboLineItems}" varStatus="comboLoop">
											                
											                    <c:choose>
																	<c:when test="${fn:length(comboLineItem.pid2Name) > 0}">
																	<c:set var="orderComboLineItem1CheckedData" value="${comboLineItem.pid1}|${comboLineItem.pid1Name}|${comboLineItem.pid1Qty}"></c:set>
																	 <c:choose>
																	<c:when test = "${comboLineItem.pidCheckedData eq orderComboLineItem1CheckedData}">
																		<input type="radio" name="orderLineItems[${itemsCounter}].orderComboLineItems[${comboLineItemCounter}].productComboLineItemData" checked="checked" value="${comboLineItem.pid1}|${comboLineItem.pid1Name}|${comboLineItem.pid1Qty}">${comboLineItem.pid1Name} (${comboLineItem.pid1Qty})<br>
																	</c:when>
																	<c:otherwise>
																		 <input type="radio" name="orderLineItems[${itemsCounter}].orderComboLineItems[${comboLineItemCounter}].productComboLineItemData" checked="checked"  value="${comboLineItem.pid1}|${comboLineItem.pid1Name}|${comboLineItem.pid1Qty}">${comboLineItem.pid1Name} (${comboLineItem.pid1Qty})<br> 
																	</c:otherwise>
																		</c:choose>
																		
																		
																		 <c:if test = "${fn:length(comboLineItem.pid2Name) > 0}">
																		 <c:set var="orderComboLineItem2checkedData" value="${comboLineItem.pid2}|${comboLineItem.pid2Name}|${comboLineItem.pid2Qty}"></c:set>
																		  <c:choose>
																		 <c:when test = "${comboLineItem.pidCheckedData eq orderComboLineItem2checkedData}">
											                    			<input type="radio"  name="orderLineItems[${itemsCounter}].orderComboLineItems[${comboLineItemCounter}].productComboLineItemData" checked="checked" value="${comboLineItem.pid2}|${comboLineItem.pid2Name}|${comboLineItem.pid2Qty}">${comboLineItem.pid2Name} (${comboLineItem.pid2Qty}) <br>
											                    		</c:when>
											                    		<c:otherwise>
											                    			<input type="radio"  name="orderLineItems[${itemsCounter}].orderComboLineItems[${comboLineItemCounter}].productComboLineItemData" value="${comboLineItem.pid2}|${comboLineItem.pid2Name}|${comboLineItem.pid2Qty}">${comboLineItem.pid2Name} (${comboLineItem.pid2Qty}) <br>
											                    		</c:otherwise>
											                    			 </c:choose>
											                    		 </c:if>
											                    		
											                    		
																		
																		
																		
																		 <c:if test = "${fn:length(comboLineItem.pid3Name) > 0}">
																		 <c:set var="orderComboLineItem3heckedData" value="${comboLineItem.pid3}|${comboLineItem.pid3Name}|${comboLineItem.pid3Qty}"></c:set>
																		  <c:choose>
																		 <c:when test = "${comboLineItem.pidCheckedData eq orderComboLineItem3heckedData}">
																		  	<input type="radio" name="orderLineItems[${itemsCounter}].orderComboLineItems[${comboLineItemCounter}].productComboLineItemData" checked="checked"  value="${comboLineItem.pid3}|${comboLineItem.pid3Name}|${comboLineItem.pid3Qty}">${comboLineItem.pid3Name} (${comboLineItem.pid3Qty}) <br>
											                    			</c:when>
											                    			<c:otherwise>
											                    			<input type="radio" name="orderLineItems[${itemsCounter}].orderComboLineItems[${comboLineItemCounter}].productComboLineItemData" value="${comboLineItem.pid3}|${comboLineItem.pid3Name}|${comboLineItem.pid3Qty}">${comboLineItem.pid3Name} (${comboLineItem.pid3Qty}) <br>
											                    			</c:otherwise>
											                    			</c:choose>
											                    		 </c:if>
											                    		  
																	</c:when>
																	<c:otherwise>
																		${comboLineItem.pid1Name} (${comboLineItem.pid1Qty}) 
																		<input type="hidden" name="orderLineItems[${itemsCounter}].orderComboLineItems[${comboLineItemCounter}].productComboLineItemData" value="${comboLineItem.pid1}|${comboLineItem.pid1Name}|${comboLineItem.pid1Qty}">
																	</c:otherwise>
																</c:choose>	
											                  <hr>
											                  <c:set var="comboLineItemCounter" value="${comboLineItemCounter + 1}" />
											                    </c:forEach>
											                    
											                </div>
											            </div>
											        </div>
      											  </div>
											
											
											
												</c:when>
												<c:otherwise>
												${nameParts[0]}
												</c:otherwise>
										</c:choose>
							</h3>
							<div style="font-size: 12px;">
											${nameParts[1]} ${nameParts[2]} ${nameParts[3]} <br>
												<span><i class="fa" style="color: grey">&#xf156;</i>
												</span> <label class="price-class" style="color: grey">${subItem.price}</label>
											</div>
						</div>

						<div class="rounded border border-grey quantity-label float-top float-right divQtyAddBtnPanel" style="width:70px;display:none;" id="divQtyAddBtnPanel-${subItem.productId}">
										<div>ADD</div>	
										</div>
										 <div
											class="rounded border border-grey quantity-padding float-top float-right" style="width:70px;" id="divQtyBtnPanel-${subItem.productId}">
											 <button class="btn quantityBtnMinus qtyPlusMinusBtn" type="button" id="btnMinus-${subItem.productId}">
												<i class="fa fa-minus" aria-hidden="true"
													style="color: grey; cursor: hand"></i>
											</button> 
											<span style="display:none;" class="hiddenProductId">${subItem.productId}</span>
											<span style="display:none;" class="hiddenLabel">
											${nameParts[0]} <br>${nameParts[1]} ${nameParts[2]} ${nameParts[3]}
											</span>
											<input type="hidden" class="hiddenPrice"
												name="orderLineItems[${itemsCounter}].price"
												value="${subItem.price}"> <input type="hidden"
												name="orderLineItems[${itemsCounter}].quantity"
												class="hiddenQnty" value="${subItem.quantity}"> <label
												class="qty-class"  key = "${item.key}" style="color: grey;" id="qtyClass-${subItem.productId}" >${subItem.quantity}</label> 
												
										<button class="btn quantityBtnAdd qtyPlusMinusBtn" type="button" id="btnAdd-${subItem.productId}">
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

<div class="modal fade" id="myModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">
						<span id="mdlInvoiceId">Products:</span>
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







