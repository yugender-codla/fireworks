<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


 <link rel="stylesheet" href="/css/style_d.css">
 
<head>
<style>

</style>
<script type="text/javascript">


	var init = function () {
	   //return scroll position in session storage
	   $('#middleContentDiv').scrollTop(sessionStorage.scrollPos || 0)
	};
	window.onload = init;
	
	$(document).ready(function() {
		  calculateQty(); 
		$('#middleContentDiv').scroll(function () {
			  //set scroll position in session storage
			  sessionStorage.scrollPos = $('#middleContentDiv').scrollTop();
			});
		
		
		$("#qntyCountInputTxt").val(0);
		$("#qntyCountInputLbl").text(0);

		$(".quantityBtnAdd").click(function() {
			var parentTag = $(this).parent().children('label');
			var val = parseInt(parentTag.text());
			val = val + 1;
			parentTag.text(val);

			calculateQty();
			
			//$("#orderForm").attr('action', '/fireworks/order/addToCart');
			//$("#orderForm").submit();
		});

		$(".quantityBtnMinus").click(function() {
			var parentTag = $(this).parent().children('label');
			
			var val = parseInt(parentTag.text());
			
			if (val > 0) {
				val = val - 1;
				parentTag.text(val);
			}
			calculateQty();
			//$("#orderForm").attr('action', '/fireworks/order/addToCart');
			//$("#orderForm").submit();
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

			
			$("#cartItemsCountLbl").text(qnty);
		}
		
		

		
		var infoModal = $('#myModal');
		
		 $(".view-button").click(function(event){
			 event.preventDefault();
			 var url = $(this).attr("seq");
			 
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
		            	
		            		 row = row + "<tr><td>"+output[i].pid1Name+ "</td></tr>";
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
		 
	
		 
		  $(".qtyPlusMinusBtn").click(function(){
			  loadCartItems();
		  });
		 
			
		  function loadCartItems(){
			  $(".cartItems").empty();
				var totalPrice = 0;
			  $(".qty-class").each(function(){
					var parentTag = $(this).parent().children('label');
					var mainTag = parentTag.parent();
					var val = parseInt(parentTag.text());
					
					var cartItemsTbody = $(".cartItems");
					
					if(val > 0){
						var lbl = mainTag.find('.hiddenLabel').text();
			  			var qty = mainTag.find('.qty-class').text();
		  				var price =  mainTag.find('.hiddenPrice').val();
		  				var productId = mainTag.find('.hiddenProductId').text();
		  				var lblElement = '';
		  				
		  				if($(this).attr("key") == 'Combo'){
		  					lblElement = '<tr><td style="width:30%;font-size:11px;">'+lbl+'</td>';
		  				}else{
		  					lblElement = '<tr><td style="width:30%;font-size:11px;">'+lbl+'</td>';	
		  				}
		  				 
		  				
						
						
						var qtyBtnElement = '<td style="width:9em;"><div	class="rounded border border-grey quantity-padding float-right"><button class="btn quantityBtnMinus1" type="button" onclick="javascript:cartItemPlusMinusFunction(this)" seq="btnMinus-'+productId+'">'
							+ '<i class="fa fa-minus" aria-hidden="true" style="color: grey; cursor: hand"></i>	</button>'
							+'<label class="" style="color: grey;" >'+qty+'</label>'
							+'<button class="btn quantityBtnAdd1" type="button" onclick="javascript:cartItemPlusMinusFunction(this)" seq="btnAdd-'+productId+'">	<i class="fa fa-plus" aria-hidden="true" style="color: #F26522; cursor: hand"></i></button>'
							+'</div></td>';
									
							
						var priceElement = "<td class='priceCountOuputLbl' style='text-align: left;font-size:11px;'> <span><i class='fa' style='color: grey'>&#xf156;</i></span> "+parseInt(price * qty)+"  </td></tr>";
						
							$(".cartItems").append(lblElement+qtyBtnElement+priceElement);
							totalPrice = parseInt(totalPrice + (price * qty));
							
					}       
					
	                 
			  });
				$("#netPriceCountOuputLbl").html(totalPrice);
		  }
		  
		  loadCartItems();  
		
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
	
	
	  

	
	 function cartItemPlusMinusFunction(v){
		 document.getElementById(v.getAttribute('seq')).click();
	 }
	 
	 function cartItemComboViewFunction(v){
		 document.getElementById('comboViewId-'+v.id.substring(v.id.indexOf('-')+1,v.id.length)).click();
		}
</script>

<style>
#scrollspy{
position:fixed;
top:100px;
}

.middleContent{
padding-top:120px;
}
</style>
</head>


<!------ Include the above in your HEAD tag ---------->
<spring:url value="/fireworks/order/cart" var="showConfirmOrderUrl" />
 <form:form method="post" action="${showConfirmOrderUrl}" modelAttribute="order" id="orderForm">

 	<input type="hidden" name="phoneNumber" value="${order.phoneNumber}"/> 
    <input type="hidden" name="email" value="${order.email}"/> 
    <input type="hidden" name="id" value="${order.id}"/>
    <input type="hidden" name="statusCode" value="${order.statusCode}"/>
	<input type="hidden" name="orderNumber" value="${order.orderNumber}"/>
<div class="container">
	<div class="row">
	
			<div class="col-xs-3" style="width:20%;">
<nav id="scrollspy" class ="navbar" >
			<ul class="nav nav-pills nav-stacked flex-column mr-auto ml-auto">
					<c:set var="categoryCounter" value="${0}" />
					<c:forEach var="item" items="${productsMap}" varStatus="toploop">
						<c:set var="categoryCounter" value="${categoryCounter + 1}" />

						<c:choose>
							<c:when test="${categoryCounter eq 1}">
								<li  class="nav-item"><a class="nav-link active"
									href="#tab${categoryCounter}">${item.key} (${fn:length(item.value)})</a></li>
							</c:when>
							<c:otherwise>
								<li class="nav-item "><a class="nav-link"	href="#tab${categoryCounter}">${item.key} (${fn:length(item.value)})</a></li>
							</c:otherwise>
						</c:choose>

					</c:forEach>
				</ul>
</nav>

			<!-- <nav id="mainNavbar" >
				
					
 					<ul class="nav nav-pills nav-stacked">
 					<li class="nav-item nav-link"><a href="#divDesert">Desert</a></li>
 					<li class="nav-item nav-link active" ><a href="#divLight">Desert</a></li>
 					<li class="nav-item nav-link "><a href="#divTulips">Desert</a></li>
 					<li class="nav-item nav-link "><a href="#div">Desert</a></li>
 					</ul>
 					
 
 </nav> -->

			
</div>



			<div class="col-xs-6 middleContent" style="width:50%">
			<div data-spy="scroll" data-target="#scrollspy" data-offset="0" style="overflow-y: scroll;height: 700px;width:100%;position:relative;" id="middleContentDiv">				
					<c:set var="itemsCounter" value="${0}" />
					<c:set var="tabsCounter" value="${0}" />
				
					
					<c:forEach var="item" items="${productsMap}" varStatus="toploop">
						<c:set var="tabsCounter" value="${tabsCounter + 1}" />

					<div id="tab${tabsCounter}">
						<div class="pb-2 mt-4 mb-2 border-bottom" >
							<h2>${item.key}</h2> 
							<h6>${fn:length(item.value)} ITEMS</h6>
						</div>
						<c:forEach var="subItem" items="${item.value}" varStatus="loop">
							<c:set var="itemsCounter" value="${itemsCounter + 1}" />
								<c:set var="comboLineItemCounter" value="${0}" />
						<spring:url value="/fireworks/${subItem.productId}/viewCombo" var="viewUrl" />
							<div class="col-12 col-sm-12 col-md-12 col-lg-12 ">
								<div class="card">
									<div class="card-body">

										<div class="float-left">
											<c:set var="nameParts"
												value="${fn:split(subItem.productName, ',')}" />
											<input type="hidden"
												name="orderLineItems[${itemsCounter}].productId"
												value="${subItem.productId}"> <input type="hidden"
												name="orderLineItems[${itemsCounter}].productName"
												value="${subItem.productName}">
												
												 <input type="hidden"
												name="orderLineItems[${itemsCounter}].category"
												value="${item.key}">
										
											<div class="card-text ">
										
											<c:choose>
												<c:when test="${item.key == 'Combo'}">
											
												<div class="accordion " id="accordionExample-${subItem.productId}">
											        <div class="card " style="margin-left: 0px;padding-left: 0px;">
											            <div class="card-header" id="headingOne-${subItem.productId}" style="background-color: #fff;border-color: #fff;padding-left: 0px;color:#F26522">
											              		<span data-toggle="collapse" data-target="#collapseOne-${subItem.productId}"><i class="fa fa-plus"></i> ${nameParts[0]}
											              		</span>
											            </div>
											            <div style="font-size: 12px;">
															${nameParts[1]} ${nameParts[2]} ${nameParts[3]} <br>
															<span><i class="fa" style="color: grey">&#xf156;</i>
															</span> <label class="price-class" style="color: grey">${subItem.price}</label>
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
											
											</div>
											<c:if test="${item.key != 'Combo'}">
											<div style="font-size: 12px;">
											${nameParts[1]} ${nameParts[2]} ${nameParts[3]} <br>
												<span><i class="fa" style="color: grey">&#xf156;</i>
												</span> <label class="price-class" style="color: grey">${subItem.price}</label>
											</div>
											</c:if>
										</div>
										<div
											class="rounded border border-grey quantity-label float-top float-right divQtyAddBtnPanel" style="width:70px;padding:9px;display:none;" id="divQtyAddBtnPanel-${subItem.productId}">
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
				</div>
		<div class="col-xs-3 middleContent" style="width:30%">


			<h2>Cart</h2>
			<b><label id="cartItemsCountLbl">0</label></b> ITEMS | <b><span class="rupeesymbol"><i class="fa" >&#xf156;</i></span> <span id="netPriceCountOuputLbl">0</span></b> 

		<div style="overflow-y: auto;overflow-x:hidden;min-height:0px;max-height: 400px;position:relative;" id="cartItemsDiv">	
		<c:set var="netPrice" value="${0}" />
			<div class="row row-padding">
				<div class="col-12 col-sm-12 col-md-12 col-lg-12">
					<div class="table-responsive-md ">
						<table class="table tblTemplate">
						<tbody class="cartItems">
							
							</tbody>
						</table>
					</div>
				</div>
				
			</div>
		
		</div>
		<div class="row row-padding">
				<div class="col-12 col-sm-12 col-md-12 col-lg-12">
				<button type="button" class="btn-success" style="width:200px" onclick = "javascript:$('form').submit()">Check Out</button>
				</div>
		</div>
		</div>
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